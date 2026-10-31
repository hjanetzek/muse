# CtrlrX in muse

[CtrlrX](https://github.com/damiensellier/CtrlrX) (Damien Sellier's continuation of Roman Kubiak's Ctrlr) hosts editor panels for MIDI hardware: a panel is a set of controls that send MIDI (mostly SysEx), with Lua scripts for anything more, such as receiving and sending patch banks. Panels exist for several machines that MAME emulates, so CtrlrX could give the muse plugins a patch editor and librarian.

This is an analysis of CtrlrX 5.6.36 (`d35edd22`, 2026-10-21) and of the decision how to use it.

## CtrlrX

- Licence: BSD-3-Clause or GPL-2.0-or-later, so it can be combined with muse (GPL-3.0).
- Actively maintained, about one commit a week.
- About 68k lines of its own code:

  | Part | Lines |
  |---|---|
  | `Core/CtrlrPanel`, `Core/CtrlrModulator`, `Core/CtrlrManager` (panel model) | 9.3k |
  | `UIComponents/CtrlrComponents` (sliders, buttons, LCDs, ...) | 14k |
  | `Lua` (Lua manager and the bindings of Ctrlr and JUCE classes) | 14k |
  | `MIDI` | 3.9k |
  | `Native` (per OS, e.g. embedding a panel into an exported binary) | 2.6k |
  | `UIComponents/CtrlrPanel` (panel canvas, but also the panel editor) | 10k |
  | `UIComponents/CtrlrLua` (Lua editor and debugger) | 11k |
  | `UIComponents/CtrlrPropertyEditors`, `CtrlrApplicationWindow`, `CtrlrMIDI` (editor UI) | 9.5k |

- Bundled third-party code in `Source/Misc`: boost (33 MB, for luabind), LuaJIT (7 MB) and Lua 5.1, luabind, libusb, rapidfuzz.
- JUCE 6.0.8 is vendored in `JUCE/` and patched, 44 commits touch it. The largest change removes `final` from all JUCE classes so that the Lua bindings can derive from them. Others change the ZipFile and code editor modules and the VST3 and AAX wrappers. gearmulator uses JUCE 7.0.10.
- The Lua scripts in panels use the JUCE API directly through luabind (`PopupMenu`, `AlertWindow`, `Path`, `Image`, `Justification`, `MemoryBlock`, ...), so the bound JUCE API is part of the interface panels depend on.
- The UI is made of JUCE components. gearmulator's UI is RmlUi, so a panel is a separate JUCE component in the editor.
- `CtrlrProcessor` (the `AudioProcessor`) passes host MIDI to the panels and sends the panels' MIDI to the host. Panels can also open MIDI devices themselves.
- Instance modes (`CtrlrInstance` in `Core/CtrlrMacros.h`): the normal editor, and "restricted" instances that run one embedded panel without the editor, which is what CtrlrX exports as a stand-alone plugin.

## Panels for machines in MAME

Panel files are a zlib-compressed binary JUCE `ValueTree` (`.bpanelz`) or XML (`.panel`). The CtrlrX repository includes four panel collections as submodules in `Panels/`.

| Machine | MAME | Panel | Controls | Lua |
|---|---|---|---|---|
| TX81Z | plays (`tx81z`) | Yamaha - TX81Z - Lime (Roman Kubiak) | 97, all SysEx like `F0 43 1y 12 27 xx F7` | none |
| TX81Z | plays | CTX81Z 3.2.1 (dnaldoog), editor and librarian | 410 | 488 KB |
| ESQ-1, ESQ-M | plays (`esq1`, `esqm`) | Ensoniq ESQ1 1.1 (JaseFOS) | 140 | 63 KB |
| SQ-80 | plays (`sq80`) | SQ80 editor 0.4 | 330 | 164 KB |
| DW-8000, Juno-106, JX-8P, MKS-7, MKS-50, D-50, JV-880, DX7, DX11 | no sound yet | panels exist | | |
| FB-01, DX100, MU50, Poly-800, EX-20 | in the library | no panel | | |

Licences of the collections: dnaldoog's panels are BSD-3-Clause, the Sequential/DSI panels GPL-3.0. The unityconstruct collection is marked BSD-3-Clause but was gathered from many authors, and Roman Kubiak's original panels have no licence file. Only panels with a clear licence can be distributed with muse, others have to be added by the user.

## Options

1. **CtrlrX next to the plugin.** The CtrlrX VST3 in the DAW sends its MIDI to a muse plugin, the plugin's MIDI output (`mp_midi_output`) goes back for patch dumps. Needs no code and shows whether the panels work with the emulation.
2. **Panels as data.** gearmulator has a patch manager (patch database, banks, tags, SysEx drag and drop, with an RmlUi UI) and describes parameters and their SysEx in `parameterDescriptions_*.json`. A converter from panels to that JSON and an RML layout handles panels that are plain SysEx, such as Lime. Each machine needs C++ to read and write its patch dumps, and the Lua logic of the panels is lost.
3. **The CtrlrX runtime in the plugin.** Panels run as they are, including their Lua scripts.

## Decision: option 3

### Fork

`CtrlrX/` is [hjanetzek/muse-ctrlrx](https://github.com/hjanetzek/muse-ctrlrx), branch `muse`. Its history starts with the tree of CtrlrX 5.6.36 and doesn't contain upstream's history, which has more than 350 MB of bundled libraries and build products. `muse/upstream-commit` names the upstream commit the branch is synced to. The commits:

1. `CtrlrX 5.6.36 for muse`: upstream's tree without the paths listed in `muse/removed-paths`:
   - `JUCE/`, `JuceLibraryCode/`: the plugins use gearmulator's JUCE.
   - `Source/Misc/boost`, `libusb`, `luajit`, `lua`, `cmake/luajit`: the system's packages are used.
   - `Packaging/`, `Doc/`, `Tests/`, `.github/`, the `.jucer` projects, the build scripts and the panel submodules.
2. `muse: LF line endings`: upstream mixes CRLF, LF and both in one file. The fork has `* text=auto eol=lf` in `.gitattributes`.
3. `muse/sync-upstream.sh: sync without upstream's history`, see below.
4. Changes that could go upstream, they keep the build with JUCE 6 working:
   - `Build with JUCE 7 and C++17`: luabind and noexcept functions and scoped enums, `File` and `Font` being final, thread priorities, changed signatures and new overloads, Ogg and FLAC being optional.
   - `Panels without a MIDI output device send to the host again`: fixes a bug of 5.6.36.
5. `muse/CMakeLists.txt` builds the static library `ctrlrLib` against the JUCE of the project that adds it. `CTRLR_EMBEDDED` leaves out the plugin entry point, `muse/include/JuceHeader.h` replaces the Projucer's, and the resources are built as `CtrlrBinaryData` so they don't clash with the plugin's `BinaryData`.

`muse/sync-upstream.sh [ref]` fetches upstream and merges it:

- For the merge, the upstream commit of `muse/upstream-commit` becomes a second parent of `HEAD` through a temporary graft (`git replace --graft`), so git finds the right merge base. The merge is squashed, so no upstream commit becomes part of the branch, and the graft is removed again.
- `-X renormalize` merges upstream's CRLF into the LF files.
- The paths of `muse/removed-paths` are removed again, including files upstream adds there. Only conflicts in the files muse keeps are left to resolve by hand, then `muse/sync-upstream.sh --continue` commits the merge.

Tested with a branch made like this one from an upstream commit 30 commits older than 5.6.36: synced to 5.6.36, its tree equalled the one of the `muse` branch.

The remote `upstream` is damiensellier/CtrlrX, `me` is muse-ctrlrx. Changes for upstream have to be ported onto upstream's history for a pull request.

### Integration

In gearmulator, `MAME_CTRLR_DIR` (set by `build.sh`) adds `ctrlrLib` to the build. It also adds `juce_gui_extra` and `juce_product_unlocking` to the JUCE modules and sets `JUCE_MODAL_LOOPS_PERMITTED=1`, which the panels' Lua scripts need.

`mameJucePlugin/mameCtrlr.cpp` runs a `CtrlrProcessor` in each plugin instance, on the message thread:

- The machine's MIDI output (events from the device) goes to the panels through `CtrlrProcessor::processPanels()`. It doesn't go through `processBlock()`, which passes its input on to its output.
- Every 5 ms the panels' MIDI is taken from `processBlock()` and sent to the machine as editor events.
- The panels are set to receive from and send to the host and not to pass the host's MIDI through.
- The state of CtrlrX, with its panels, is the chunk `CTRL` of the plugin's state. Loading a state closes the open panels first, because CtrlrX adds the panels of a state to those that are open.
- "CtrlrX Panel..." in the editor's menu opens the CtrlrX editor in a window. If no panel is open, the first panel file in `<datapath>/<machine>/panels` is opened.

The plugins link the system's `libluajit-5.1.so.2` and `libusb-1.0.so.0`.

### Status

Tested with the TX81Z and the panels CTX81Z 3.2.1 and Yamaha - TX81Z - Lime:

- The panels load, CTX81Z runs its Lua scripts.
- The panels control the machine. The TX81Z only takes SysEx with "SYS INFO AVAIL" in its Utility settings, and it listens on its basic receive channel: CTX81Z sends on channel 1, Lime on channel 3 (the panel's MIDI channel).
- CtrlrX opens no MIDI devices (`CTRLR_EMBEDDED`), the panels always use the plugin's MIDI.
- The CtrlrX window shows only the panel, without menus, tabs and the panel editor, at the size of the panel's canvas.
- CTX81Z shows the machine's current voice, so the machine's SysEx reaches the panel.
- The plugin's state keeps the panel and its values, and restoring a state twice leaves one panel. A panel restored with the state no longer crashes before the CtrlrX window was opened.

Open:

- Bank receive and send were not checked yet.
- With the menus gone, other panels can't be opened from the CtrlrX window: the plugin only opens the first panel of the machine's folder. A choice of panels in the plugin's menu would help.
- CtrlrX keeps settings and a log of its own, these have not been looked at yet.
- Several plugin instances in one process share CtrlrX's static log pointer (`CtrlrLog::ctrlrLog`).
