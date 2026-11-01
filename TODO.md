# TODO

## Audio

- **Output gain per plugin, with an optional limiter.** Machines come out at quite different levels: the TX81Z peaks at -28.5 dBFS for one full-level carrier, about -13 dBFS for typical factory patches. Its firmware writes a total level of 16 (-12 dB) for output level 99, and MAME's driver routes the chip at 0.6, leaving headroom for 8 voices of 4 carriers each. Give each product a default gain (e.g. +6 to +12 dB for the TX81Z) that the user can change, and an optional limiter so loud chords don't clip. gearmulator already has an output gain (`outputGain` in the MCP device info) to build on.
- **TX81Z master volume.** The MASTER VOLUME buttons are read as inputs but change nothing in MAME; on the hardware they presumably control an analog stage after the DAC.

## Machines

- **TX81Z tuning.** The starting NVRAM in the data folder has Master Tune at -64; A4 plays at 415 Hz.
- **Layout knob and slider settings in the plugin state.** MAME keeps adjuster values (the LinnDrum's knobs and mixer) in the machine's `cfg/` folder, shared by all instances and not saved with the host project.

## CtrlrX

See "Open" under Status in [docs/ctrlrx.md](docs/ctrlrx.md#status).
