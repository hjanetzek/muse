# TODO

## Audio

- **Output gain per plugin, with an optional limiter.** Machines come out at quite different levels: the TX81Z peaks at -28.5 dBFS for one full-level carrier, about -13 dBFS for typical factory patches. Its firmware writes a total level of 16 (-12 dB) for output level 99, and MAME's driver routes the chip at 0.6, leaving headroom for 8 voices of 4 carriers each. Give each product a default gain (e.g. +6 to +12 dB for the TX81Z) that the user can change, and an optional limiter so loud chords don't clip. gearmulator already has an output gain (`outputGain` in the MCP device info) to build on.
- **TX81Z master volume.** The MASTER VOLUME buttons are read as inputs but change nothing in MAME; on the hardware they presumably control an analog stage after the DAC.

## Machines


## UI

- **Native MAME layouts in the gearmulator UI.** See the plan in [docs/layout-loader.md](docs/layout-loader.md).

## CtrlrX

See "Open" under Status in [docs/ctrlrx.md](docs/ctrlrx.md#status).
