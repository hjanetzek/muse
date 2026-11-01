# muse

Hardware synthesizers emulated by [MAME](https://www.mamedev.org), played as CLAP and VST3 instrument plugins.

The plugins take MIDI from the host and return the machine's audio. The machine's front panel is shown the way MAME draws it from its layout, and it can be used with the mouse. The machine's NVRAM (its patch memory) is saved with the host project.

Editor and librarian panels made for [CtrlrX](https://github.com/damiensellier/CtrlrX) run inside the plugins: "CtrlrX Panel..." in the plugin's menu (right click) opens the panel in a window of its own, the panel's MIDI goes to the machine and the machine's MIDI back to the panel. See [docs/ctrlrx.md](docs/ctrlrx.md).

The plugin side is built on [gearmulator](https://github.com/dsp56300/gearmulator), which provides the JUCE plugin, the GUI framework and the MIDI handling.

## Machines

| Plugin | Machine | MAME driver |
|---|---|---|
| MAME-TX81Z | Yamaha TX81Z FM Tone Generator | `tx81z` |
| MAME-EX20 | Wersi EX-20 Digital Organ | `ex20` |
| MAME-LinnDrum | Linn Electronics LinnDrum | `linndrum` |
| MAME-SD1 | Ensoniq SD-1 (32 voice) | `sd132` |
| MAME-PSR70 | Yamaha PSR-70 | `psr70` |

The MAME library also contains the FB-01, DX100, MU50, ESQ-1/ESQ-M/SQ-80 and Poly-800 drivers, which don't have a plugin yet.

The LinnDrum has no MIDI input. Its plugin maps General MIDI drum notes to its pads, and velocity picks the louder variations (snare 1-3, bass 1-2, hi-hat 1-2). The upper row of pads plays drums (hi-hats, toms, rides) or percussion (cabasa, tambourine, congas, cowbell, claps), as the PERC. button sets it; the notes of both go to the same pads. A pad sounds about 10 ms after its note, the time the LinnDrum's firmware takes to see the key. The note maps are in `gearmulator/source/mame/mameLib/noteMap.cpp`.

MAME's LinnDrum layout leaves its knobs and mixer sliders to a Lua script, which the plugins don't run; the plugins make the knobs and sliders of a layout draggable themselves: a knob with a vertical drag, a slider along its travel. They are also the plugin's parameters (44 for the LinnDrum: tempo, volume, tuning, the mixer's gain and pan, and three internal trimmers), which the host can automate, and they are saved with the host project. A product's parameters are the machine's adjusters as MAME names them, in `parameterDescriptions_mame.json` of its folder, written by `mpctest` with `MPCTEST_FIELDS=<file>`.

[docs/music-instruments.md](docs/music-instruments.md) lists all instruments in MAME by how complete their emulation is.

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
| `../roms/` | ROMs shared by all machines, `~/.local/share/mame-plugin/roms`: searched after the machine's own, the easiest place for everything, including parent sets and devices' ROMs (the SD-1 21-voice needs `sd1.zip`, `sd132.zip` and the display's `esq2x40_vfx.7z`). |
| `nvram/<machine>/` | The machine's starting NVRAM (its patch memory), optional. Some machines start with empty patch memory and stay silent until patches are loaded. A new plugin instance starts from these files and afterwards keeps its own copy in the host project. |
| `panels/` | CtrlrX panels (`.bpanelz`, `.panel`, ...), optional. The first one is opened when a plugin instance shows its panel for the first time. [docs/ctrlrx.md](docs/ctrlrx.md) lists panels for the machines. None are included. |
| `cfg/` | Written by MAME, its settings for the machine. |
| `default.lay` | A MAME layout file, optional. Shown instead of the layout compiled into the library, see [Layout development](#layout-development). |

`./install-roms.sh <file or URL>...` puts ROM sets (`.zip` or `.7z`, named as MAME names the set) into the shared folder, downloading URLs first and checking each archive. A machine whose ROMs are missing doesn't start; the plugin then opens its own ROM folder, which is searched as well.

`~/.config/mame-plugin/mame-plugin.ini` can set further ROM folders, searched after the machine's own, and another data folder:

```ini
# ;-separated, each holding <machine>.zip or <machine>/ like a MAME ROM folder
rompath = /home/me/mame/roms
datapath = /home/me/mame-plugin
# reload the machine's layout file whenever it changes
layoutdev = 1
# draw the panel with the plugin's UI instead of showing MAME's rendering (experimental)
nativelayout = 1
# the UI scale in percent for all the plugins; without it each keeps the one chosen in its menu
uiscale = 150
```

The environment variables `MAME_PLUGIN_ROMPATH`, `MAME_PLUGIN_DATAPATH`, `MAME_PLUGIN_LAYOUTDEV`, `MAME_PLUGIN_NATIVELAYOUT` and `MAME_PLUGIN_UISCALE` override them. A plugin window can't be resized: its size, and that of its text, follows the UI scale only. With `nativelayout`, the panel is drawn from the layout's description, see [docs/layout-loader.md](docs/layout-loader.md).

## Layout development

MAME compiles a machine's layout (`mame/src/mame/layout/<name>.lay`) into the library, so changing it normally means building MAME again and restarting the plugin. Instead, the plugins show the file `<machine>/default.lay` (or `<machine>/<machine>.lay`) of the data folder in place of the compiled layout, MAME's usual place for external artwork. With `layoutdev = 1`, they load it again within half a second of each change, while the machine keeps running. To work on the layout in the repository, link it there:

```sh
ln -s "$PWD/mame/src/mame/layout/tx81z.lay" ~/.local/share/mame-plugin/tx81z/default.lay
MAME_PLUGIN_LAYOUTDEV=1 ./gearmulator/bin/plugins/Release/Standalone/MAME-TX81Z
```

A file that doesn't parse leaves the compiled layout on screen; MAME's error, with line and column, goes to the plugin's log (on the console for the stand-alone application). Reloading takes the emulation a moment, so the audio may drop out briefly. Only the panel is reloaded: if the new layout has another aspect ratio, close and open the editor. Layout scripts (Lua) don't run in the plugins; knobs and sliders work without them, see above. Remove the file again to get the compiled layout back. [docs/layout-workflow.md](docs/layout-workflow.md) describes how to match a layout to a photo of the hardware, comparing it with screenshots taken over the plugins' MCP server.

## Licence

MAME is licensed under the GPL-2.0-or-later (with parts under BSD-3-Clause), CtrlrX under the BSD-3-Clause or GPL-2.0-or-later, gearmulator under the GPL-3.0. The plugins combine both and are distributed under the GPL-3.0, see [LICENSE](LICENSE).
