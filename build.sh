#!/bin/sh
# Builds the MAME library and the plugins.
#
#   ./build.sh            build
#   ./build.sh install    build, then install the plugins to ~/.clap and ~/.vst3
#
# JOBS sets the number of parallel jobs, BUILD_TYPE the CMake build type (Release), FORMATS the plugin formats
# ("CLAP VST3", add Standalone for the stand-alone applications)

set -e

ROOT=$(cd "$(dirname "$0")" && pwd)
JOBS=${JOBS:-$(nproc)}
BUILD_TYPE=${BUILD_TYPE:-Release}
BUILD="$ROOT/build"
PRODUCTS="MAME-TX81Z MAME-EX20"
TARGETS="tx81zJucePlugin ex20JucePlugin"
FORMATS=${FORMATS:-CLAP VST3}

standalone=OFF
case " $FORMATS " in *" Standalone "*) standalone=ON;; esac

# libmame_synths.so: MAME with the machines listed in synths.flt and the plugin OSD
make -C "$ROOT/mame" OSD=plugin BUILDDIR=build/plugin SUBTARGET=synths SOURCEFILTER=src/mame/synths.flt -j"$JOBS"

cmake -S "$ROOT/gearmulator" -B "$BUILD/gearmulator" -G Ninja \
	-DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
	-Dgearmulator_SYNTH_MAME=ON \
	-Dgearmulator_SYNTH_OSIRUS=OFF -Dgearmulator_SYNTH_OSTIRUS=OFF \
	-Dgearmulator_SYNTH_VAVRA=OFF -Dgearmulator_SYNTH_XENIA=OFF \
	-Dgearmulator_SYNTH_88EMU=OFF -Dgearmulator_SYNTH_JE8086=OFF \
	-Dgearmulator_SYNTH_NODALRED2X=OFF \
	-Dgearmulator_BUILD_FX_PLUGIN=OFF \
	-Dgearmulator_BUILD_JUCEPLUGIN_Standalone=$standalone \
	-DMAME_PLUGIN_LIBRARY="$ROOT/mame/libmame_synths.so" \
	-DMAME_PLUGIN_INCLUDE_DIR="$ROOT/mame/src/osd/plugin" \
	-DMAME_CTRLR_DIR="$ROOT/CtrlrX"

targets=
for t in $TARGETS; do
	for f in $FORMATS; do
		targets="$targets ${t}_$f"
	done
done
cmake --build "$BUILD/gearmulator" -j"$JOBS" --target $targets

# the plugins are in gearmulator/bin/plugins/$BUILD_TYPE, the stand-alone applications in its Standalone folder
[ "$1" = "install" ] || exit 0

STAGE="$BUILD/install"
rm -rf "$STAGE"
for p in $PRODUCTS; do
	for f in $FORMATS; do
		case $f in CLAP|VST3)
			cmake --install "$BUILD/gearmulator" --prefix "$STAGE" --component "$p-$f";;
		esac
	done
done

# the CLAP plugins share one copy of the library, each VST3 bundle has its own
if [ -d "$STAGE/lib/clap" ]; then
	mkdir -p "$HOME/.clap"
	cp --remove-destination "$STAGE"/lib/clap/* "$HOME/.clap/"
	echo "installed the CLAP plugins to $HOME/.clap"
fi
if [ -d "$STAGE/lib/vst3" ]; then
	mkdir -p "$HOME/.vst3"
	for b in "$STAGE"/lib/vst3/*.vst3; do
		rm -rf "$HOME/.vst3/$(basename "$b")"
		cp -r "$b" "$HOME/.vst3/"
	done
	echo "installed the VST3 plugins to $HOME/.vst3"
fi
