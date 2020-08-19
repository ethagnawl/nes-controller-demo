# NES Controller Demo

![screenshot](./screenshot.png)

[Screencap on YouTube](https://youtu.be/aEUPRPAZDXE)

## What?
This repository contains the source code and ROM for a "game" I put together in
order to learn more about 6502 Assembly and the NES platform.

The "game" contains a mock NES controller which reacts to button presses.

## Why
This isn't a very _fun_ game but it covered enough ground for me to get a feel
for what writing and NES game is like:
- starting the system in a clean state
- creating and configuring color palettes
- creating and configuring sprites and background images
- reading from a controller
- updating the UI in response to controller input

## How?

#### Dependencies
- [cc65](https://www.cc65.org/) compiler/toolchain
- [FCEUX](http://fceux.com/web/home.html) emulator (any emulator should do but this one is assumed)
- [nestool](https://github.com/jpwhiting/nestool)

#### Build
##### `make`
The default make target will compile and link the source files and generate a
ROM file.
##### `make run`
The `run` make target will build the ROM and open it in the FCEUX emulator

## TODO
- add sound effect(s)
- add button press counters
- add start screen
- experiment with scrolling/interactive background

## Resources
The souce code borrows heavily from portions of the Zero Pages and Nerdy Nights
tutorials. Both appear to be unlicensed, so I've added credits where
appropriate (setup, memclear, palette and background loading, for Zero Pages
and controller input handling from Nerdy Nights) These resources and the others
linked below are very accessible and I highly recommend people give them a
look. (If any of the authors of the aforementioned tutorials have other
preferences regarding credits or licensing, please let me know and I'll be
happy to accommodate you!)

- [Famicom Party](https://famicom.party/)
- [Intro to Game Hacking on the NES - HOPE 2020](https://archive.org/details/hopeconf2020/20200731_2300_Intro_to_Game_Hacking_on_the_NES.mp4)
- [Masswerk 6502 instruction set guide](https://www.masswerk.at/6502/6502_instruction_set.html)
- [NESDev Wiki](http://wiki.nesdev.com/w/index.php/Nesdev_Wiki)
- [Nerdy Nights](https://nerdy-nights.nes.science/)
- [Zero Pages](https://www.youtube.com/watch?v=JgdcGcJga4w&list=PL29OkqO3wUxzOmjc0VKcdiNPqwliHEuEk)
