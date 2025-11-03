# AS2650v2 on wafer.space

Recreation of the [AS2650v2](https://github.com/AvalonSemiconductors/AS2650) on the wafer.space template. This is meant to be a reference design to show an example of a CPU, multi-macro layout and usage of the fab SRAM macros.

Additionally includes a demonstration of using the high-performance DFFs from [gf180mcu_as_ex_mcu7t5v0](https://github.com/AvalonSemiconductors/gf180mcu_as_ex_mcu7t5v0).

> [!NOTE]
> This repo needs to be cloned recursively.

## Build macros

Before building the top-level, the individual macros need to be built. They are located in `macros/` and a bash script is provided to build all, but each can also be built individually by going to its directory and running `make`.

The AS2650 macro uses the high-performance DFFs from gf180mcu_as_ex_mcu7t5v0, but this can be disabled by removing some lines from its configuration file, as indicated by the comments there.

## Pad-out and documentation

The pad-out is shown below. [The documentation for the version taped out on GFMPW-1](https://avalonsemiconductors.github.io/AS2650/index.html) mostly applies, except for the pinout being different and there being no wishbone registers. Instead, the configuration options for the AS2650-2 have been greatly reduced. Two input-only pins on the wafer.space AS2650v2 called "RAM Enable" and "ROM Enable" can be used to enable the internal RAM and the boot-ROM respectively. If the boot-ROM is enabled, it is now hard-wired to initialize only the internal RAM.

ROM Enable is sampled once at reset and RAM Enable is sampled at every clock edge.

Note that the wafer.space template has more pads than efabless caravel had pins. Therefore, a large amount of extra pins went unused during the port to wafer.space. Additional peripherals could be hooked up to these theoretically.

![](padout.png)
