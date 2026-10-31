# muse

Hardware synthesizers emulated by [MAME](https://www.mamedev.org), played as CLAP and VST3 instrument plugins.

The plugins take MIDI from the host and return the machine's audio. The machine's front panel is shown the way MAME draws it from its layout, and it can be used with the mouse. The machine's NVRAM (its patch memory) is saved with the host project.

Editor and librarian panels made for [CtrlrX](https://github.com/damiensellier/CtrlrX) run inside the plugins: "CtrlrX Panel..." in the plugin's menu (right click) opens them, the panel's MIDI goes to the machine and the machine's MIDI back to the panel. See [docs/ctrlrx.md](docs/ctrlrx.md).

The plugin side is built on [gearmulator](https://github.com/dsp56300/gearmulator), which provides the JUCE plugin, the GUI framework and the MIDI handling.

## Machines

| Plugin | Machine | MAME driver |
|---|---|---|
| MAME-TX81Z | Yamaha TX81Z FM Tone Generator | `tx81z` |
| MAME-EX20 | Wersi EX-20 Digital Organ | `ex20` |

The MAME library also contains the FB-01, DX100, MU50, ESQ-1/ESQ-M/SQ-80 and Poly-800 drivers, which don't have a plugin yet. [docs/music-instruments.md](docs/music-instruments.md) lists all instruments in MAME by how complete their emulation is.

## Repository layout

| Path | Contents |
|---|---|
| `mame/` | MAME fork, branch `muse-plugin`. `src/osd/plugin` is the plugin OSD and the C API (`mame_plugin.h`) of `libmame_synths.so`. `src/mame/synths.flt` lists the drivers that go into the library. |
| `CtrlrX/` | [muse-ctrlrx](https://github.com/hjanetzek/muse-ctrlrx), branch `muse`: CtrlrX without what muse doesn't use, synced with upstream. `muse/` has the build of the library the plugins link and the script that merges upstream. |
| `gearmulator/` | [muse-gearmulator](https://github.com/hjanetzek/muse-gearmulator), the gearmulator fork, branch `mame`. `source/mame/mameLib` runs a machine through the C API, `source/mame/mameJucePlugin` is the plugin shared by all machines, and each `source/mame/<machine>JucePlugin` folder is one plugin product. |
| `docs/` | Notes on the MAME instruments. |

## Building

Linux only for now. You need a C++17 compiler, CMake, Ninja, what MAME and JUCE need to build, and boost, LuaJIT and libusb for CtrlrX (on Arch, for example, `sdl2 alsa-lib freetype2 fontconfig libx11 libxrandr libxinerama libxcursor mesa boost luajit libusb`).

```sh
git clone --recursive https://github.com/hjanetzek/muse.git
cd muse
./build.sh            # or: ./build.sh install
```

`./build.sh install` copies the plugins to `~/.clap` and `~/.vst3`. The MAME library is installed next to the plugins, which find it there.

The first build of MAME takes a while. `JOBS=n` sets the number of parallel jobs. `FORMATS` sets the plugin formats to build, `CLAP VST3` by default.

## Running the stand-alone application

Each machine can also run as a stand-alone application, without a host:

```sh
FORMATS="CLAP VST3 Standalone" ./build.sh
./gearmulator/bin/plugins/Release/Standalone/MAME-TX81Z
```

The applications are in `gearmulator/bin/plugins/Release/Standalone`, next to the MAME library they load. "Options" in the window's title bar chooses the audio device and the MIDI inputs, and saves or loads the state to a file. The application keeps the state of the machine, its devices and the CtrlrX panels in `~/.config/MAME-<machine>.settings` and starts from it the next time; "Reset to default state" starts the machine afresh. A right click on the machine's panel opens the plugin's menu with "Settings..." (more MIDI ports, for example) and "CtrlrX Panel...".

## Data folder

Everything a machine needs besides the plugin is in a folder of its own, `~/.local/share/mame-plugin/<machine>/`:

| Folder | Contents |
|---|---|
| `roms/` | The machine's ROMs, as MAME expects them: `<machine>.zip` or a folder `<machine>/` with the ROM files, e.g. `tx81z/roms/tx81z/tx81z-v1.6.ic15`. Not included. |
| `nvram/<machine>/` | The machine's starting NVRAM (its patch memory), optional. Some machines start with empty patch memory and stay silent until patches are loaded. A new plugin instance starts from these files and afterwards keeps its own copy in the host project. |
| `panels/` | CtrlrX panels (`.bpanelz`, `.panel`, ...), optional. The first one is opened when a plugin instance shows its panels for the first time, others can be opened from the CtrlrX menu. [docs/ctrlrx.md](docs/ctrlrx.md) lists panels for the machines. None are included. |
| `cfg/` | Written by MAME, its settings for the machine. |

`~/.config/mame-plugin/mame-plugin.ini` can set further ROM folders, searched after the machine's own, and another data folder:

```ini
# ;-separated, each holding <machine>.zip or <machine>/ like a MAME ROM folder
rompath = /home/me/mame/roms
datapath = /home/me/mame-plugin
```

The environment variables `MAME_PLUGIN_ROMPATH` and `MAME_PLUGIN_DATAPATH` override both.

## Licence

MAME is licensed under the GPL-2.0-or-later (with parts under BSD-3-Clause), CtrlrX under the BSD-3-Clause or GPL-2.0-or-later, gearmulator under the GPL-3.0. The plugins combine both and are distributed under the GPL-3.0, see [LICENSE](LICENSE).
