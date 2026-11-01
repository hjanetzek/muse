#!/bin/sh
# install-roms.sh <file or URL>... - puts MAME ROM sets (.zip or .7z, named as MAME names the set, e.g. sd132.zip or
# esq2x40_vfx.7z) into the ROM folder all the plugins search: <datapath>/roms, ~/.local/share/mame-plugin/roms by
# default. URLs (http, https) are downloaded first. Each archive is checked before it is installed.
set -eu

usage() {
	echo "usage: $0 <file.zip|file.7z|URL>..." >&2
	exit 1
}
[ $# -gt 0 ] || usage

# the data folder, found as the plugins find it: MAME_PLUGIN_DATAPATH, datapath in mame-plugin.ini, the default
config="${XDG_CONFIG_HOME:-$HOME/.config}/mame-plugin/mame-plugin.ini"
datapath="${XDG_DATA_HOME:-$HOME/.local/share}/mame-plugin"
if [ -f "$config" ]; then
	configured=$(sed -n 's/^[[:space:]]*datapath[[:space:]]*=[[:space:]]*//p' "$config" | tail -n 1 | sed 's/[[:space:]]*$//')
	[ -n "$configured" ] && datapath="$configured"
fi
datapath="${MAME_PLUGIN_DATAPATH:-$datapath}"
roms="$datapath/roms"
mkdir -p "$roms"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

check() {
	case "$1" in
	*.zip)
		if command -v unzip >/dev/null 2>&1; then
			unzip -tq "$1" >/dev/null
		else
			[ "$(head -c 2 "$1")" = "PK" ]
		fi ;;
	*.7z)
		if command -v 7z >/dev/null 2>&1; then
			7z t "$1" >/dev/null
		else
			[ "$(head -c 2 "$1")" = "7z" ]
		fi ;;
	*)
		return 1 ;;
	esac
}

status=0
for source in "$@"; do
	case "$source" in
	http://*|https://*)
		name=$(basename "${source%%\?*}")
		file="$work/$name"
		echo "downloading $source"
		if ! curl -fL --silent --show-error -o "$file" "$source"; then
			status=1
			continue
		fi ;;
	*)
		name=$(basename "$source")
		file="$source" ;;
	esac

	case "$name" in
	*.zip|*.7z) ;;
	*)
		echo "$name: not a .zip or .7z ROM set, skipped" >&2
		status=1
		continue ;;
	esac

	if ! check "$file"; then
		echo "$name: damaged or not an archive, skipped" >&2
		status=1
		continue
	fi

	if [ -f "$roms/$name" ] && cmp -s "$file" "$roms/$name"; then
		echo "$name: already installed"
		continue
	fi
	cp "$file" "$roms/$name"
	echo "$name: installed in $roms"
done
exit $status
