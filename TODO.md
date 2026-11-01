# TODO

## Audio

- **Output gain per plugin, with an optional limiter.** Machines come out at quite different levels: the TX81Z peaks at -28.5 dBFS for one full-level carrier, about -13 dBFS for typical factory patches. Its firmware writes a total level of 16 (-12 dB) for output level 99, and MAME's driver routes the chip at 0.6, leaving headroom for 8 voices of 4 carriers each. Give each product a default gain (e.g. +6 to +12 dB for the TX81Z) that the user can change, and an optional limiter so loud chords don't clip. gearmulator already has an output gain (`outputGain` in the MCP device info) to build on.
- **TX81Z master volume.** The MASTER VOLUME buttons are read as inputs but change nothing in MAME; on the hardware they presumably control an analog stage after the DAC.

## Build size

All products contain the same code (only the machine, plugin ID, skin and parameters differ): 4 machines take 1.1 GB, 51 MB per Standalone and CLAP, 116 MB per VST3 bundle, which has its own 65 MB copy of the MAME library. From cheap to thorough:

- **One copy of the MAME library** for all formats and products, loaded from a shared place.
- **A thin Standalone**: one small CLAP host loading the machine's plugin, instead of a full build per product.
- **One binary per format for all machines**, the machine chosen when it loads: CLAP and VST3 can offer several plugins from one file, JUCE's wrappers can't, so gearmulator's plugin layer has to change. Not: JUCE and RmlUi as shared libraries, whose global state conflicts between plugins in one host.

## Machines


## UI

- **Native MAME layouts in the gearmulator UI.** See the plan in [docs/layout-loader.md](docs/layout-loader.md).

## CtrlrX

See "Open" under Status in [docs/ctrlrx.md](docs/ctrlrx.md#status).
