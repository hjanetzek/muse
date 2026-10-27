# Music instruments in MAME, by completeness

Built from MAME 0.289 (mame0289-1779-g5b6ff58a0c9) on branch muse-plugin, using `-listxml` of a build that contains only the instrument drivers. 327 machines from 171 driver files are listed.

What counts as an instrument here: synthesizers, samplers, drum machines, keyboards and organs, sound modules, and some closely related gear (sequencers, effects units, MIDI controllers and players, music toys). Arcade music games (beatmania, Guitar Freaks, …) and TV games are left out, and so are computers that only have a MIDI port, such as the Atari ST.

## Overview

| Category | Machines |
|---|---:|
| [Working](#working) | 17 |
| [Working, with known problems](#working-with-known-problems) | 49 |
| [Not working, makes sound](#not-working-makes-sound) | 70 |
| [Not working, no sound](#not-working-no-sound) | 191 |

**Columns**

- **MIDI in**: the driver has a MIDI input MAME can connect to, so it can be played from a host or a plugin. Many skeleton drivers have no MIDI port wired up yet, even when the real machine has one.
- **Plugin**: the driver is already part of the plugin library (`src/mame/synths.flt`).
- **Problems**: features MAME reports as imperfect or missing for this machine.
- Clones show their parent in brackets after the name.

## Working

MAME marks the machine as working, with no known emulation problems.

| Machine | Name | Manufacturer | Year | Kind | MIDI in | Plugin | Problems |
|---|---|---|---|---|:-:|:-:|---|
| `midifex` | MIDIFEX | Alesis | 1986 | Effects | yes |  |  |
| `midiverb` | MIDIverb | Alesis | 1986 | Effects | yes |  |  |
| `cz101` | CZ-101 Digital Synthesizer | Casio | 1984 | Synthesizer | yes |  |  |
| `sz1` | SZ-1 Digital Multi-Track Sequencer | Casio | 1985 | Sequencer | yes |  |  |
| `litelrn` | Lite 'n Learn: Electronic Organ | Concept 2000 | 1978 | Toy |  |  |  |
| `mrmusical` | Mr. Mus-I-Cal | Concept 2000 | 1978 | Toy |  |  |  |
| `wavesynth` | Waveblaster-based expander | MAME | 2020 | Sound module | yes |  |  |
| `jaminator` | Jaminator | Noise Toys Inc. | 1990 | Toy |  |  |  |
| `obdmx` | DMX | Oberheim | 1980 | Drum machine |  |  | tape missing |
| `midi2cv8` | midi2cv8 | PAiA Electronics | 1997 | MIDI-to-CV converter | yes |  |  |
| `midi2cv8_vhz` | midi2cv8 V/Hz | PAiA Electronics | 1997 | MIDI-to-CV converter | yes |  |  |
| `sb55` | Sound Brush SB-55 | Roland | 1991 | MIDI file player | yes |  |  |
| `fb01` | FB-01 FM Sound Generator | Yamaha | 1986 | Sound module | yes | yes |  |
| `psr11` | PortaTone PSR-11 | Yamaha | 1986 | Keyboard |  |  |  |
| `pss170` | PortaSound PSS-170 | Yamaha | 1986 | Keyboard |  |  |  |
| `mu10` | MU10 Tone Generator | Yamaha | 1994 | Sound module | yes |  |  |
| `mu50` | MU50 Tone Generator | Yamaha | 1995 | Sound module | yes | yes |  |

## Working, with known problems

Playable. MAME lists features that are imperfect or missing, often sound details, unemulated parts such as a disk drive, or a missing control.

| Machine | Name | Manufacturer | Year | Kind | MIDI in | Plugin | Problems |
|---|---|---|---|---|:-:|:-:|---|
| `ct8000` | Casiotone 8000 | Casio | 1983 | Keyboard | yes |  | sound imperfect |
| `ctfk1` | Casiotone FK-1 | Casio | 1983 | Keyboard | yes |  | sound imperfect |
| `cz230s` | CZ-230S Digital Preprogrammed Synthesizer | Casio | 1985 | Synthesizer | yes |  | sound imperfect |
| `cz1` | CZ-1 Digital Synthesizer | Casio | 1986 | Synthesizer | yes |  | sound imperfect |
| `mz1` (cz1) | MZ-1 (prototype) | Casio | 1986 | Synthesizer | yes |  | sound imperfect |
| `rz1` | RZ-1 Digital Sampling Rhythm Composer | Casio | 1986 | Drum machine | yes |  | sound imperfect |
| `ap10` | Celviano AP-10 | Casio | 1995 | Keyboard | yes |  | sound imperfect |
| `ctk530` | CTK-530 | Casio | 1995 | Keyboard | yes |  | sound imperfect |
| `ctk630` | CTK-630 | Casio | 1995 | Keyboard | yes |  | sound imperfect |
| `gz70sp` | GZ-70SP GM Sound Speaker System | Casio | 1996 | Sound module | yes |  | sound imperfect |
| `ctk601` | CTK-601 | Casio | 1997 | Keyboard | yes |  | sound imperfect |
| `ctk551` | CTK-551 | Casio | 2000 | Keyboard | yes |  | sound imperfect |
| `wk1600` (wk1800) | WK-1600 | Casio | 2000 | Keyboard | yes |  | sound imperfect |
| `wk1800` | WK-1800 | Casio | 2000 | Keyboard | yes |  | disk missing, sound imperfect |
| `sfxphasor` | Sound FX Phasor | Electroplay | 1981 | Toy |  |  | sound imperfect |
| `vfx` | VFX | Ensoniq | 1989 | Synthesizer | yes |  | sound imperfect |
| `vfxsd` | VFX-SD | Ensoniq | 1989 | Synthesizer | yes |  | sound imperfect |
| `sd1` (sd132) | SD-1 (21 voice) | Ensoniq | 1990 | Synthesizer | yes |  | sound imperfect |
| `sd132` | SD-1 (32 voice) | Ensoniq | 1991 | Synthesizer | yes |  | sound imperfect |
| `kt76` | KT-76 | Ensoniq | 1996 | Synthesizer | yes |  | sound imperfect |
| `mmarvin` | Musical Marvin | Entex | 1980 | Toy |  |  | sound imperfect |
| `linndrum` | LinnDrum | Linn Electronics | 1982 | Drum machine |  |  | sound imperfect, tape missing |
| `tr707` | TR-707 Rhythm Composer | Roland | 1985 | Drum machine | yes |  | sound imperfect, tape missing |
| `s330` (w30) | S-330 Digital Sampler | Roland | 1988 | Sampler | yes |  | sound imperfect |
| `w30` | W-30 Music Workstation | Roland | 1988 | Workstation | yes |  | controls imperfect, graphics imperfect, sound imperfect |
| `sc88` | Sound Canvas SC-88 | Roland | 1994 | Sound module | yes |  | sound imperfect |
| `sc88pro` | Sound Canvas SC-88Pro | Roland | 1996 | Sound module | yes |  | sound imperfect |
| `prophet5r30` | Prophet 5 (Model 1000) Rev 3.0 | Sequential Circuits | 1980 | Synthesizer |  |  | sound imperfect, tape missing |
| `sixtrak` | Six-Trak (Model 610) Rev B/C | Sequential Circuits | 1984 | Synthesizer | yes |  | sound imperfect |
| `sixtraka` (sixtrak) | Six-Trak (Model 610) Rev A | Sequential Circuits | 1984 | Synthesizer | yes |  | sound imperfect |
| `ex20` | EX-20 Digital Organ | Wersi | 1986 | Organ | yes | yes | sound imperfect |
| `dx100` | DX100 Digital Programmable Algorithm Synthesizer | Yamaha | 1985 | Synthesizer | yes | yes | sound imperfect |
| `psr60` | PortaTone PSR-60 | Yamaha | 1985 | Keyboard | yes |  | sound imperfect |
| `psr70` (psr60) | PortaTone PSR-70 | Yamaha | 1985 | Keyboard | yes |  | sound imperfect |
| `tx81z` | TX81Z FM Tone Generator | Yamaha | 1987 | Synthesizer | yes | yes | sound imperfect |
| `tg100` | TG100 Tone Generator | Yamaha | 1991 | Sound module | yes |  | sound imperfect |
| `psr150` | PortaTone PSR-150 | Yamaha | 1992 | Keyboard |  |  | sound imperfect |
| `psr75` (psr150) | PortaTone PSR-75 | Yamaha | 1992 | Keyboard |  |  | sound imperfect |
| `pss11` (psr150) | PortaSound PSS-11 | Yamaha | 1992 | Keyboard |  |  | sound imperfect |
| `pss21` (psr150) | PortaSound PSS-21 | Yamaha | 1992 | Keyboard |  |  | sound imperfect |
| `pss31` (psr150) | PortaSound PSS-31 | Yamaha | 1992 | Keyboard |  |  | sound imperfect |
| `psr110` (psr150) | PortaTone PSR-110 | Yamaha | 1993 | Keyboard |  |  | sound imperfect |
| `dd9` | DD-9 Digital Percussion | Yamaha | 1994 | Drum pad |  |  | sound imperfect |
| `psr180` | PortaTone PSR-180 | Yamaha | 1994 | Keyboard |  |  | sound imperfect |
| `psr76` (psr180) | PortaTone PSR-76 | Yamaha | 1994 | Keyboard |  |  | sound imperfect |
| `pss12` | PortaSound PSS-12 | Yamaha | 1994 | Keyboard |  |  | sound imperfect |
| `pss6` (pss12) | PortaSound PSS-6 | Yamaha | 1994 | Keyboard |  |  | sound imperfect |
| `psr190` | PortaTone PSR-190 | Yamaha | 1996 | Keyboard |  |  | sound imperfect |
| `psr78` (psr190) | PortaTone PSR-78 | Yamaha | 1996 | Keyboard |  |  | sound imperfect |

## Not working, makes sound

The machine boots partly or not at all, but its sound hardware is emulated. These are the most promising candidates to finish.

| Machine | Name | Manufacturer | Year | Kind | MIDI in | Plugin | Problems |
|---|---|---|---|---|:-:|:-:|---|
| `s612` | S612 MIDI Digital Sampler | Akai | 1985 | Sampler | yes |  | sound imperfect |
| `s700` (x7000) | S700 MIDI Digital Sampler | Akai | 1986 | Sampler | yes |  | disk missing, sound imperfect |
| `s900` | S900 MIDI Digital Sampler | Akai | 1986 | Sampler | yes |  | sound imperfect |
| `x7000` | X7000 Sampling Keyboard | Akai | 1986 | Sampler | yes |  | disk missing, sound imperfect |
| `s1000` | S1000 MIDI Stereo Digital Sampler | Akai | 1988 | Sampler | yes |  | sound imperfect |
| `s1000pb` (s1000) | S1000PB MIDI Stereo Digital Sampler | Akai | 1988 | Sampler | yes |  | sound imperfect |
| `s950` | S950 MIDI Digital Sampler | Akai | 1988 | Sampler | yes |  | sound imperfect |
| `s950scsi` (s950) | S950 MIDI Digital Sampler (with SCSI) | Akai | 1988 | Sampler | yes |  | sound imperfect |
| `s1100` | S1100 MIDI Stereo Digital Sampler | Akai | 1990 | Sampler | yes |  | sound imperfect |
| `cd3000i` | CD3000i | Akai | 1993 | Sampler | yes |  |  |
| `s2000` | S2000 | Akai | 1993 | Sampler | yes |  |  |
| `s3000` | S3000 | Akai | 1993 | Sampler | yes |  |  |
| `cd3000xl` | CD3000XL | Akai | 1994 | Sampler | yes |  |  |
| `s3000xl` | S3000XL | Akai | 1994 | Sampler | yes |  |  |
| `mpc2000xl` | MPC 2000XL | Akai / Roger Linn | 1994 | Sampler / groovebox | yes |  |  |
| `mpc3000` | MPC3000 | Akai / Roger Linn | 1994 | Sampler / groovebox | yes |  |  |
| `mpc60` | MPC60 MIDI Production Center | Akai Electric | 1988 | Sampler / groovebox | yes |  | sound imperfect |
| `mpc60scsi` (mpc60) | MPC60 MIDI Production Center (with SCSI) | Akai Electric | 1988 | Sampler / groovebox | yes |  | sound imperfect |
| `vocalizer` | Vocalizer 1000 | Breakaway Music Systems | 1988 | Vocal synthesizer | yes |  | microphone missing |
| `ctmb1` | Casiotone MB-1 | Casio | 1983 | Sound module | yes |  | sound imperfect |
| `cps2000` | CPS-2000 | Casio | 1986 | Keyboard |  |  | sound imperfect |
| `dg10` (dg20) | DG-10 Digital Guitar | Casio | 1987 | Guitar synth |  |  | sound imperfect |
| `dg20` | DG-20 Digital Guitar | Casio | 1987 | Guitar synth |  |  | sound imperfect |
| `fz1` | FZ-1 Digital Sampling Synthesizer | Casio | 1987 | Sampler | yes |  | sound imperfect |
| `fz10m` (fz1) | FZ-10M Digital Sampling Synthesizer Module | Casio | 1987 | Sampler | yes |  | sound imperfect |
| `fz20m` (fz1) | FZ-20M Digital Sampling Synthesizer Module | Casio | 1989 | Sampler | yes |  | sound imperfect |
| `enmirage` | Mirage DMS-8 | Ensoniq | 1984 | Sampler | yes |  |  |
| `esq1` | ESQ-1 Digital Wave Synthesizer | Ensoniq | 1986 | Synthesizer | yes | yes |  |
| `esqm` (esq1) | ESQ-M Digital Wave Synthesizer Module | Ensoniq | 1986 | Synthesizer | yes | yes |  |
| `eps` | EPS | Ensoniq | 1988 | Sampler | yes |  |  |
| `sq80` | SQ-80 Cross Wave Synthesizer | Ensoniq | 1988 | Synthesizer | yes | yes |  |
| `eps16p` (eps) | EPS-16 Plus | Ensoniq | 1990 | Sampler | yes |  |  |
| `sq1` | SQ-1 | Ensoniq | 1990 | Synthesizer | yes |  |  |
| `sqrack` (sq1) | SQ-Rack | Ensoniq | 1990 | Sound module | yes |  |  |
| `sq2` | SQ-2 | Ensoniq | 1991 | Synthesizer | yes |  |  |
| `asr10` | ASR-10 | Ensoniq | 1992 | Sampler |  |  |  |
| `ks32` (sq2) | KS-32 | Ensoniq | 1992 | Synthesizer | yes |  |  |
| `ts10` | TS-10 | Ensoniq | 1993 | Synthesizer | yes |  | sound imperfect |
| `ts12` | TS-12 | Ensoniq | 1993 | Synthesizer | yes |  | sound imperfect |
| `mr61` | MR-61 Workstation | Ensoniq | 1996 | Synthesizer |  |  |  |
| `mrrack` | MR-Rack | Ensoniq | 1996 | Sound module |  |  |  |
| `asrx` | ASR-X | Ensoniq | 1997 | Sampler / groovebox |  |  |  |
| `dep5` | DEP-5 Digital Effects Processor | Roland | 1986 | Effects | yes |  | sound imperfect |
| `re3` | RE-3 Digital Space Echo | Roland | 1988 | Effects | yes |  | sound imperfect |
| `cm32p` | CM-32P PCM Sound Module | Roland | 1989 | Sound module |  |  | sound imperfect |
| `d70` | D-70 Super LA Synthesizer | Roland | 1991 | Synthesizer | yes |  | graphics imperfect, sound imperfect |
| `sc88vl` (sc88) | Sound Canvas SC-88VL | Roland | 1995 | Sound module | yes |  | sound imperfect |
| `vegspro` | VE-GSPro Voice Expansion Board | Roland | 1998 | Sound module | yes |  | sound imperfect |
| `sc8820` (sc8850) | Sound Canvas SC-8820 | Roland | 1999 | Sound module | yes |  | sound imperfect |
| `sc8850` | Sound Canvas SC-8850 | Roland | 1999 | Sound module | yes |  | sound imperfect |
| `wsa1r` | SX-WSA1R | Technics | 1995 | Sound module | yes |  | sound imperfect |
| `psr500` | PortaTone PSR-500 | Yamaha | 1991 | Keyboard |  |  | sound imperfect |
| `mu5` | MU5 Tone Generator | Yamaha | 1994 | Sound module | yes |  | sound imperfect |
| `mu80` | MU80 Tone Generator | Yamaha | 1994 | Sound module | yes |  |  |
| `psr340` | PortaTone PSR-340 | Yamaha | 1994 | Keyboard | yes |  |  |
| `mu90` | MU90 Tone Generator | Yamaha | 1996 | Sound module | yes |  |  |
| `vl70` | VL70-m Virtual Acoustic Tone Generator | Yamaha | 1996 | Sound module | yes |  |  |
| `an1x` | AN1x Control Synthesizer | Yamaha | 1997 | Synthesizer |  |  |  |
| `mu100` | MU100 Tone Generator | Yamaha | 1997 | Sound module | yes |  |  |
| `mu100r` (mu100) | MU100 Rackable version | Yamaha | 1997 | Sound module | yes |  |  |
| `qy70` | QY70 Music Sequencer | Yamaha | 1997 | Sequencer | yes |  | graphics imperfect |
| `mu100b` (mu100) | MU100 Screenless version | Yamaha | 1998 | Sound module | yes |  |  |
| `mu128` | MU128 Tone Generator | Yamaha | 1998 | Sound module | yes |  |  |
| `mu15` | MU15 Tone Generator | Yamaha | 1998 | Sound module | yes |  |  |
| `eosb900` (qs300) | EOS B900 Music Production Synthesizer | Yamaha | 1999 | Synthesizer | yes |  | graphics imperfect |
| `mu1000` (mu500) | MU1000 Tone Generator | Yamaha | 1999 | Sound module | yes |  |  |
| `mu2000` (mu500) | MU2000 Tone Generator | Yamaha | 1999 | Sound module | yes |  |  |
| `qs300` | QS300 Music Production Synthesizer | Yamaha | 1999 | Synthesizer | yes |  | graphics imperfect |
| `mu500` | MU500 Tone Generator | Yamaha | 2000 | Sound module | yes |  |  |
| `mu90b` (mu90) | MU90B Tone Generator | Yamaha | 2005 | Sound module | yes |  |  |

## Not working, no sound

Skeleton drivers or early work: the sound hardware is missing, so nothing can be heard yet.

| Machine | Name | Manufacturer | Year | Kind | MIDI in | Plugin | Problems |
|---|---|---|---|---|:-:|:-:|---|
| `virusa` | Virus A | Access | 1997 | Synthesizer | yes |  | sound missing |
| `virusb` | Virus B (Ver. T) | Access | 1999 | Synthesizer | yes |  | sound missing |
| `virusrck` | Virus Rack (Ver. T) | Access | 2001 | Synthesizer | yes |  | sound missing |
| `virusc` | Virus C | Access | 2002 | Synthesizer | yes |  | sound missing |
| `virusrckxl` | Virus Rack XL | Access | 2002 | Synthesizer | yes |  | sound missing |
| `viruscl` | Virus Classic | Access | 2004 | Synthesizer | yes |  | sound missing |
| `ax80` | AX80 Programmable Polyphonic Synthesizer | Akai | 1984 | Synthesizer |  |  | sound missing |
| `vx600` | VX600 Programmable Matrix Synthesizer | Akai | 1988 | Synthesizer |  |  | sound missing |
| `xr10` | XR10 16 Bit PCM Drum Machine | Akai | 1990 | Drum machine | yes |  | sound missing |
| `hr16` | HR-16 | Alesis | 1987 | Drum machine |  |  | sound missing |
| `mmt8` | MMT-8 | Alesis | 1987 | Sequencer |  |  | sound missing |
| `hr16b` (hr16) | HR-16B | Alesis | 1989 | Drum machine |  |  | sound missing |
| `sr16` | SR-16 (Alesis) | Alesis | 1990 | Drum machine |  |  | sound missing |
| `alesqs7` | Alesis QS7 musical keyboard | Alesis | 1996 | Synthesizer |  |  | sound missing |
| `ctrc1` | Casiotone RC-1 | Casio | 1983 | Keyboard |  |  | sound missing |
| `sk1` | SK-1 Sampling Keyboard | Casio | 1985 | Keyboard |  |  | sound missing |
| `ht6000` | HT-6000 Programmable Digital Synthesizer | Casio | 1987 | Synthesizer |  |  | sound missing |
| `sk10` | SK-10 Sampling Keyboard | Casio | 1987 | Keyboard |  |  | sound missing |
| `sk5` | SK-5 Sampling Keyboard | Casio | 1987 | Keyboard |  |  | sound missing |
| `sk2` | SK-2 Sampling Keyboard | Casio | 1988 | Keyboard |  |  | sound missing |
| `ld50` | LD-50 | Casio | 2002 | Drum pad |  |  | sound missing |
| `ctk2100` | CTK-2100 | Casio | 2009 | Keyboard |  |  | microphone missing, sound missing |
| `nordle2x` | Nord Lead 2X | Clavia | 2003 | Synthesizer |  |  | sound missing |
| `gsp5` | GSP 5 Guitar Effects Processor/Preamp | DigiTech | 1989 | Effects |  |  | sound missing |
| `mcc1` | MCC-1 MIDI Control Computer | Dynacord | 1986 | MIDI controller | yes |  |  |
| `emu2` | Emulator II | E-mu Systems | 1984 | Sampler |  |  | sound missing |
| `emax` | Emax Digital Sampling Keyboard | E-mu Systems | 1986 | Sampler |  |  | sound missing |
| `emu3` | Emulator Three Digital Sound Production System | E-mu Systems | 1987 | Sampler |  |  | sound missing |
| `emax2` | Emax II 16-Bit Digital Sound System | E-mu Systems | 1989 | Sampler |  |  | sound missing |
| `proteus1` | Proteus/1 16-Bit Multi-Timbral Digital Sound Module | E-mu Systems | 1989 | Sound module |  |  | sound missing |
| `proteusxr` | Proteus/1 XR 16-Bit Multi-Timbral Digital Sound Module | E-mu Systems | 1989 | Sound module |  |  | sound missing |
| `emaxp` (emax) | Emax Plus Digital Sampling Keyboard | E-mu Systems | 198? | Sampler |  |  | sound missing |
| `procuss` | Pro/Cussion Maximum Percussion Module | E-mu Systems | 1991 | Sound module |  |  | sound missing |
| `vintkeys` | Vintage Keys Classic Analog Keyboards | E-mu Systems | 1993 | Sound module |  |  | sound missing |
| `orbit9090` | Orbit 9090 - The Dance Planet | E-mu Systems | 1996 | Sound module |  |  | sound missing |
| `carnaval` | Carnaval - Jugando con Fuego | E-mu Systems | 1997 | Sound module |  |  | sound missing |
| `phatt` | Planet Phatt - The Swing System | E-mu Systems | 1997 | Sound module |  |  | sound missing |
| `monomach` | Monomachine SFX6 MK2 | Elektron | 2004 | Synthesizer |  |  | sound missing |
| `machdrum` | Machinedrum SPS-1 MK2 | Elektron | 2007 | Drum machine |  |  | sound missing |
| `synthex` | Synthex | Elka | 1981 | Synthesizer | yes |  | sound missing |
| `cmi2x` | CMI IIx | Fairlight | 1983 | Sampler | yes |  | sound missing |
| `rp200` | GEM RealPiano RP200 | Generalmusic | 1999 | Digital piano |  |  | sound missing |
| `hohnadam` | ADAM Advanced Digital/Analog Musical Instrument | Hohner | 1994 | Keyboard |  |  | sound missing |
| `korgm1p1` (korgm1) | M1 Plus+1 Music Workstation | InVision Interactive | 1993 | Synthesizer |  |  | sound missing |
| `xbase09` | XBase 09 Midi Controlled Analogue Drum Module | JoMoX | 1997 | Drum machine |  |  | sound missing |
| `airbase99` | AiRBase 99 | JoMoX | 1998 | Drum machine |  |  | sound missing |
| `sx240` | SX-240 8-Voice Programmable Polyphonic Synthesizer | Kawai Musical Instrument Manufacturing | 1984 | Synthesizer |  |  | sound missing |
| `k5` | K5 Digital Multi-Dimensional Synthesizer | Kawai Musical Instrument Manufacturing | 1987 | Synthesizer |  |  | graphics imperfect, sound missing |
| `k5m` (k5) | K5m Digital Multi-Dimensional Synthesizer Module | Kawai Musical Instrument Manufacturing | 1987 | Sound module |  |  | graphics imperfect, sound missing |
| `r100` | R-100 Digital Drum Machine | Kawai Musical Instrument Manufacturing | 1987 | Drum machine |  |  | sound missing |
| `k1` | K1 Digital Multi-Dimensional Synthesizer | Kawai Musical Instrument Manufacturing | 1988 | Synthesizer |  |  | sound missing |
| `k1m` (k1) | K1m Digital Multi-Dimensional Synthesizer Module | Kawai Musical Instrument Manufacturing | 1988 | Sound module |  |  | sound missing |
| `k1r` (k1) | K1r Digital Multi-Dimensional Synthesizer Module | Kawai Musical Instrument Manufacturing | 1988 | Sound module |  |  | sound missing |
| `k1rii` | K1rII Digital Multi-Dimensional Synthesizer Module | Kawai Musical Instrument Manufacturing | 1989 | Sound module |  |  | sound missing |
| `k4` | K4 16-bit Digital Synthesizer | Kawai Musical Instrument Manufacturing | 1989 | Synthesizer |  |  | sound missing |
| `k4r` (k4) | K4r 16-bit Digital Synthesizer Module | Kawai Musical Instrument Manufacturing | 1989 | Sound module |  |  | sound missing |
| `acr20` | ACR-20 Digital Accompaniment Center | Kawai Musical Instruments Manufacturing | 199? | Arranger |  |  | sound missing |
| `ksp10` | KSP10 Digital Piano | Kawai Musical Instruments Manufacturing | 199? | Digital piano |  |  | sound missing |
| `polysix` | Polysix Programmable Polyphonic Synthesizer | Korg | 1980 | Synthesizer |  |  | sound missing |
| `poly61` | Poly-61 Programmable Polyphonic Synthesizer | Korg | 1982 | Synthesizer |  |  | sound missing |
| `poly800` | Poly-800 Programmable Polyphonic Synthesizer | Korg | 1984 | Synthesizer | yes | yes | sound missing |
| `poly800mdk` | Poly-800 Programmable Polyphonic Synthesizer (MIDI Dump Kit) | Korg | 1984 | Synthesizer | yes | yes | sound missing |
| `dvp1` | DVP-1 Digital Voice Processor | Korg | 1985 | Vocoder / voice processor |  |  | sound missing |
| `dw8000` | DW-8000 Programmable Digital Waveform Synthesizer | Korg | 1985 | Synthesizer |  |  | sound missing |
| `ex8000` (dw8000) | EX-8000 Programmable Polyphonic Synthe Module | Korg | 1985 | Sound module |  |  | sound missing |
| `ds8` | DS-8 Digital Synthesizer | Korg | 1986 | Synthesizer |  |  | sound missing |
| `dss1` | DSS-1 Digital Sampling Synthesizer | Korg | 1986 | Synthesizer | yes |  | sound missing |
| `poly800ii` | Poly-800II Programmable Polyphonic Synthesizer | Korg | 1986 | Synthesizer | yes | yes | sound missing |
| `korg707` | 707 Performing Synthesizer | Korg | 1987 | Synthesizer |  |  | sound missing |
| `korgm1` | M1 Music Workstation (Rev 19) | Korg | 1988 | Synthesizer |  |  | sound missing |
| `korgm1ex` (korgm1) | M1 EX Music Workstation (v1.29) | Korg | 1988 | Synthesizer |  |  | sound missing |
| `korgm1r` (korgm1) | M1R Music Workstation (v1.06) | Korg | 1988 | Sound module |  |  | sound missing |
| `korgm1rex` (korgm1) | M1R EX Music Workstation (v1.12) | Korg | 1988 | Sound module |  |  | sound missing |
| `korgz3` | Z3 Guitar Synthesizer | Korg | 1988 | Guitar synth |  |  | sound missing |
| `korgwsad` | WaveStation A/D | Korg | 1991 | Sound module |  |  | sound missing |
| `korgwsex` | WaveStation EX | Korg | 1992 | Synthesizer |  |  | sound missing |
| `korgwssr` | WaveStation SR | Korg | 1992 | Sound module |  |  | sound missing |
| `korgtriton` | Triton Music Workstation/Sampler (v2.5.3) | Korg | 1999 | Synthesizer |  |  | sound missing |
| `korgtritona` (korgtriton) | Triton Music Workstation/Sampler (v2.5.0) | Korg | 1999 | Synthesizer |  |  | sound missing |
| `korgtritonb` (korgtriton) | Triton Music Workstation/Sampler (v2.0.0) | Korg | 1999 | Synthesizer |  |  | sound missing |
| `microkorg` | microKORG Synthesizer/Vocoder | Korg | 2002 | Synthesizer | yes |  | sound missing |
| `dw8000ex` (dw8000) | DW-8000-EX Programmable Digital Waveform Synthesizer | Korg / Musitronics | 1985 | Synthesizer |  |  | sound missing |
| `dssmsrk` (dss1) | DSS-1 Digital Sampling Synthesizer (Memory/SCSI Retrofit) | Korg / Sound Logic | 1987 | Sampler | yes |  | sound missing |
| `k2000` | K2000 | Kurzweil Music Systems | 1990 | Synthesizer |  |  | graphics imperfect, sound missing |
| `moogsource` | Moog Source | Moog Music | 1981 | Synthesizer |  |  | sound missing, tape missing |
| `memorymoog` | Memorymoog | Moog Music | 1982 | Synthesizer |  |  | sound missing |
| `bh1000` | Sound Saurus BH-1000 | Nihon Eniac Co., Ltd. | 1994 | Sound module |  |  | sound missing |
| `bassstr` | BassStation Rack Analogue Synthesizer Module | Novation | 1995 | Synthesizer |  |  | sound missing |
| `drumsta` | Drum Station | Novation | 1995 | Drum machine |  |  | sound missing |
| `sbasssta` | Super Bass Station | Novation | 1997 | Synthesizer |  |  | sound missing |
| `obsx` | OB-SX | Oberheim | 1980 | Synthesizer |  |  | sound missing |
| `ob8` | OB8 | Oberheim | 1983 | Synthesizer |  |  | sound missing |
| `xpander` | Xpander | Oberheim | 1984 | Synthesizer | yes |  | sound missing, tape missing |
| `matrix12` | Matrix-12 | Oberheim | 1985 | Synthesizer | yes |  | sound missing, tape missing |
| `matrix6` | Matrix-6 | Oberheim | 1985 | Synthesizer | yes |  | sound missing, tape missing |
| `matrix6r` | Matrix-6R | Oberheim | 1986 | Synthesizer | yes |  | sound missing, tape missing |
| `hk1000` | HK1000 | Orla | 198? | Keyboard |  |  | sound missing |
| `se41` (hk1000) | SE 41 | Orla | 198? | Keyboard |  |  | sound missing |
| `xm200` | XM200 Orchestra Module | Orla | 1990 | Sound module |  |  | sound missing |
| `fatman` | FatMan | PAiA Electronics | 1992 | Synthesizer | yes |  | sound missing |
| `qmquasar` | Quasimidi Quasar | Quasimidi Musikelektronik GmbH | 1993 | Synthesizer |  |  | sound missing |
| `technox` | TechnoX | Quasimidi Musikelektronik GmbH | 1995 | Synthesizer |  |  | sound missing |
| `qmrave` | Rave-O-Lution 309 | Quasimidi Musikelektronik GmbH | 1996 | Synthesizer / groovebox |  |  | sound missing |
| `qmsirius` | Quasimidi Sirius | Quasimidi Musikelektronik GmbH | 1998 | Synthesizer / groovebox |  |  | sound missing |
| `tr808` | TR-808 Rhythm Composer | Roland | 1980 | Drum machine |  |  | sound missing |
| `juno6` | Juno-6 (JU-6) Polyphonic Synthesizer | Roland | 1982 | Synthesizer |  |  | sound missing |
| `tb303` | TB-303 Bass Line | Roland | 1982 | Synthesizer |  |  | sound missing |
| `tr606` | TR-606 Drumatix | Roland | 1982 | Drum machine |  |  | sound missing |
| `jx3p` | JX-3P Programmable Preset Polyphonic Synthesizer | Roland | 1983 | Synthesizer |  |  | sound missing |
| `gr700` | GR-700 Guitar Synthesizer | Roland | 1984 | Guitar synth |  |  | sound missing |
| `juno106` | Juno-106 Programmable Polyphonic Synthesizer | Roland | 1984 | Synthesizer |  |  | sound missing |
| `mks30` | MKS-30 Planet-S MIDI Sound Module | Roland | 1984 | Sound module |  |  | sound missing |
| `tr909` | TR-909 Rhythm Composer | Roland | 1984 | Drum machine |  |  | sound missing |
| `ajuno1` | Alpha Juno-1 (JU-1) Programmable Polyphonic Synthesizer | Roland | 1985 | Synthesizer |  |  | sound missing |
| `jx8p` | JX-8P Polyphonic Synthesizer (Ver. 3.x) | Roland | 1985 | Synthesizer |  |  | sound missing |
| `jx8po` (jx8p) | JX-8P Polyphonic Synthesizer (Ver. 2.x) | Roland | 1985 | Synthesizer |  |  | sound missing |
| `mks7` | MKS-7 Super Quartet | Roland | 1985 | Sound module |  |  | sound missing |
| `tr727` | TR-727 Rhythm Composer | Roland | 1985 | Drum machine | yes |  | sound missing, tape missing |
| `ajuno2` | Alpha Juno-2 (JU-2) Programmable Polyphonic Synthesizer | Roland | 1986 | Synthesizer |  |  | sound missing |
| `hs80` (ajuno2) | HS-80 Programmable Polyphonic Synthesizer | Roland | 1986 | Synthesizer |  |  | sound missing |
| `jx10` | JX-10 Super JX Polyphonic Synthesizer | Roland | 1986 | Synthesizer |  |  | sound missing |
| `s10` | S-10 Digital Sampling Keyboard | Roland | 1986 | Sampler |  |  | disk missing, sound missing |
| `tr505` | TR-505 Rhythm Composer | Roland | 1986 | Drum machine |  |  | sound missing |
| `d50` | D-50 Linear Synthesizer (Ver. 2.xx) | Roland | 1987 | Synthesizer |  |  | sound missing |
| `d50o` (d50) | D-50 Linear Synthesizer (Ver. 1.xx) | Roland | 1987 | Synthesizer |  |  | sound missing |
| `d550` (d50) | D-550 Linear Synthesizer | Roland | 1987 | Sound module |  |  | sound missing |
| `mks100` (s10) | MKS-100 Digital Sampler | Roland | 1987 | Sampler |  |  | disk missing, sound missing |
| `mks50` | MKS-50 Synthesizer Module | Roland | 1987 | Sound module |  |  | sound missing |
| `mks70` (jx10) | MKS-70 Super JX Polyphonic Synthesizer | Roland | 1987 | Sound module |  |  | sound missing |
| `mt32` | MT-32 Multi Timbre Sound Module | Roland | 1987 | Sound module |  |  | sound missing |
| `pg1000` | PG-1000 Linear Synthesizer Programmer | Roland | 1987 | Programmer | yes |  |  |
| `pr100` | PR-100 Digital Sequencer (v2.02) | Roland | 1987 | Sequencer |  |  | disk missing, sound missing |
| `pr100_201` (pr100) | PR-100 Digital Sequencer (v2.01) | Roland | 1987 | Sequencer |  |  | disk missing, sound missing |
| `s220` | S-220 Digital Sampler | Roland | 1987 | Sampler |  |  | disk missing, sound missing |
| `s50` | S-50 Digital Sampling Keyboard | Roland | 1987 | Sampler |  |  | sound missing |
| `s550` (s50) | S-550 Digital Sampler | Roland | 1987 | Sampler |  |  | sound missing |
| `d10` | D-10 Multi Timbral Linear Synthesizer | Roland | 1988 | Synthesizer |  |  | sound missing |
| `d110` (d10) | D-110 Multi Timbral Sound Module | Roland | 1988 | Sound module |  |  | sound missing |
| `mc300` | MC-300 Micro Composer | Roland | 1988 | Sequencer |  |  | sound missing |
| `mt100` | MT-100 Digital Sequencer and Sound Module | Roland | 1988 | Sound module |  |  | sound missing |
| `u110` (u220) | U-110 PCM Sound Module | Roland | 1988 | Sound module |  |  | sound missing |
| `cm32l` | CM-32L LA Sound Module | Roland | 1989 | Sound module |  |  | sound missing |
| `r8` | R-8 Human Rhythm Composer (v2.02) | Roland | 1989 | Drum machine |  |  | sound missing |
| `u20` (u220) | U-20 RS-PCM Keyboard | Roland | 1989 | Keyboard |  |  | sound missing |
| `u220` | U-220 RS-PCM Sound Module | Roland | 1989 | Sound module |  |  | sound missing |
| `mc50` | MC-50 Micro Composer | Roland | 1990 | Sequencer |  |  | sound missing |
| `r8m` (r8) | R-8M Total Percussion Sound Module (v1.04) | Roland | 1990 | Drum module |  |  | sound missing |
| `cm300` (sc55) | Sound Canvas CM-300 | Roland | 1991 | Sound module |  |  | sound missing |
| `jd800` | JD-800 Programmable Synthesizer | Roland | 1991 | Synthesizer |  |  | sound missing |
| `sc55` | Sound Canvas SC-55 | Roland | 1991 | Sound module |  |  | sound missing |
| `jv880` | JV-880 Multi Timbral Synthesizer Module | Roland | 1992 | Sound module |  |  | sound missing |
| `mc50mk2` | MC-50mkII Micro Composer | Roland | 1992 | Sequencer |  |  | sound missing |
| `r8mk2` | R-8 Mk II Human Rhythm Composer (v1.0.3) | Roland | 1992 | Drum machine |  |  | sound missing |
| `sc155` (sc55) | Sound Canvas SC-155 | Roland | 1992 | Sound module |  |  | sound missing |
| `se70` | Boss SE-70 Super Effects Processor | Roland | 1993 | Effects |  |  | sound missing |
| `rd500` | RD-500 Digital Piano | Roland | 1994 | Digital piano |  |  | sound missing |
| `sc55mk2` | Sound Canvas SC-55mkii | Roland | 1994 | Sound module |  |  | sound missing |
| `mt80s` | MT 80s Music Player | Roland | 1995 | MIDI file player |  |  | sound missing |
| `ra30` | RA-30 Realtime Arranger | Roland | 1995 | Arranger |  |  | sound missing |
| `gx700` | Boss GX-700 Guitar Effects Processor | Roland | 1996 | Effects |  |  | sound missing |
| `sx700` | Boss SX-700 Studio Effects Processor | Roland | 1996 | Effects |  |  | sound missing |
| `prpht600` | Prophet-600 (set 1) | Sequential Circuits | 1983 | Synthesizer | yes |  | sound missing |
| `prpht600a` (prpht600) | Prophet-600 (set 2) | Sequential Circuits | 1983 | Synthesizer | yes |  | sound missing |
| `dpsd7` | DPS-D7 Digital Delay Unit | Sony | 1991 | Effects |  |  | graphics imperfect, sound missing |
| `gm1000` | GM-1000 GM Sound Module | Suzuki (Hammond license) | 1994 | Sound module |  |  | sound missing |
| `triplec` | Triple-C Stereo Channel Multiband Compressor & Envelope | TC Electronic | 2000 | Effects |  |  | sound missing |
| `kn5000` | SX-KN5000 | Technics | 1998 | Keyboard |  |  | sound missing |
| `kn6000` | SX-KN6000 | Technics | 1999 | Keyboard | yes |  | sound missing, timing imperfect |
| `kn2400` | SX-KN2400 | Technics | 2000 | Keyboard | yes |  | sound missing, timing imperfect |
| `kn2600` (kn2400) | SX-KN2600 | Technics | 2000 | Keyboard | yes |  | sound missing, timing imperfect |
| `kn6500` | SX-KN6500 | Technics | 2001 | Keyboard | yes |  | sound missing, timing imperfect |
| `kn7000` | SX-KN7000 | Technics | 2002 | Keyboard | yes |  | sound missing, timing imperfect |
| `ps400` | PortaSound PS-400 | Yamaha | 1982 | Keyboard |  |  | sound missing |
| `dx7` | DX7 Digital Programmable Algorithm Synthesizer | Yamaha | 1983 | Synthesizer |  |  | sound missing |
| `dx9` | DX9 Digital Programmable Algorithm Synthesizer | Yamaha | 1983 | Synthesizer | yes |  | sound missing |
| `pcs30` | PortaSound PCS-30 | Yamaha | 1984 | Keyboard |  |  | sound missing |
| `rx15` | RX15 Digital Rhythm Programmer | Yamaha | 1984 | Drum machine |  |  | sound missing |
| `psr40` | PortaTone PSR-40 | Yamaha | 1985 | Keyboard |  |  | sound missing |
| `dx11` | DX11 Digital Programmable Algorithm Synthesizer | Yamaha | 1988 | Synthesizer |  |  | sound missing |
| `psr16` | PortaTone PSR-16 | Yamaha | 1988 | Keyboard |  |  | sound missing |
| `psr36` | PortaTone PSR-36 | Yamaha | 1988 | Keyboard |  |  | sound missing |
| `pss480` | PortaSound PSS-480 / PSS-580 | Yamaha | 1988 | Keyboard |  |  | sound missing |
| `pss680` | PortaSound PSS-680 | Yamaha | 1988 | Keyboard |  |  | sound missing |
| `pss780` (pss680) | PortaSound PSS-780 | Yamaha | 1989 | Keyboard |  |  | sound missing |
| `sy35` | SY35 Music Synthesizer | Yamaha | 1992 | Synthesizer |  |  | sound missing |
| `vl1` | VL1 Virtual Acoustic Synthesizer | Yamaha | 1993 | Synthesizer |  |  | graphics imperfect, sound missing |
| `psr79` | PortaTone PSR-79 | Yamaha | 1998 | Keyboard |  |  | sound missing |
| `psr540` | PortaTone PSR-540 | Yamaha | 1999 | Keyboard | yes |  | sound missing |
| `psr160` (psr260) | PortaTone PSR-160 | Yamaha | 2000 | Keyboard |  |  | sound missing |
| `psr260` | PortaTone PSR-260 | Yamaha | 2000 | Keyboard |  |  | sound missing |
| `psr2000` | PortaTone PSR-2000 | Yamaha | 2001 | Keyboard |  |  | sound missing |

## Kinds by category

| Kind | Working | Working, with problems | Not working, sound | Not working, no sound |
|---|---:|---:|---:|---:|
| Arranger |  |  |  | 2 |
| Digital piano |  |  |  | 3 |
| Drum machine | 1 | 3 |  | 17 |
| Drum module |  |  |  | 1 |
| Drum pad |  | 1 |  | 1 |
| Effects | 2 |  | 2 | 6 |
| Guitar synth |  |  | 2 | 2 |
| Keyboard | 2 | 23 | 3 | 29 |
| MIDI controller |  |  |  | 1 |
| MIDI file player | 1 |  |  | 1 |
| MIDI-to-CV converter | 2 |  |  |  |
| Organ |  | 1 |  |  |
| Programmer |  |  |  | 1 |
| Sampler |  | 1 | 21 | 12 |
| Sampler / groovebox |  |  | 5 |  |
| Sequencer | 1 |  | 1 | 6 |
| Sound module | 4 | 4 | 22 | 36 |
| Synthesizer | 1 | 13 | 13 | 70 |
| Synthesizer / groovebox |  |  |  | 2 |
| Toy | 3 | 2 |  |  |
| Vocal synthesizer |  |  | 1 |  |
| Vocoder / voice processor |  |  |  | 1 |
| Workstation |  | 1 |  |  |
