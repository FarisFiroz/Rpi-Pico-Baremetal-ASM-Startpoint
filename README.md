# What is this?
This is a startpoint for using baremetal assembly (ARMv6-M Instruction set) on the raspberry pi pico.

It includes a variety of things to make new projects as simple as possible such as:
- A linker script made for the raspberry pi pico's memory map.
- Required boot files such as the stage 2 bootloader and vector table.
- A main.s file with an example on how to enable a GPIO pin and then sleep the core.
    - The main file also has example code for setting the RP2040 into a dormant state.
- A clocks.s file that is able to set up the crystal oscillator and disable the ring oscillator
- A makefile that dynamically adds new .s files in the src/program or src/required directories to the dependency tree for builds
    - The makefile is also capable of flashing the pico using the debug probe and opening gdb with the debug server properly running.

# Readability and Documentation
Bare metal programming is complex. Documentation and Readability of code is an important factor in ensuring quick development time.

Assembly code is split into different sections and documented to make understanding the code simple.
- The code itself uses assembler tricks to ensure that readability is maintained. These assembler tricks ensure that memory savings will be the same regardless of if the code itself may not prioritize them. 

Linker Scripts are also documented as much as possible.
TODO - (Document makefile)

## Recommended Reading
- It is recommended to read the raspberry pi pico RP2040 datasheet to learn what the different memory locations are if you are unsure what is going on.
- It is also recommended to use an ARMv6-M architecture reference manual to delve into a deep understanding of arm thumbv1.

Both of these files will be linked in the references.

# Requirements
There are two hard requirements and three optional requirements for this project based on your choice of microcontroller flashing method and/or use of debuggers.

The hard requirements are:
- gnumake
- gcc-arm-embedded

If you would like to use openocd to flash the chip, there is an optional requirement:
- openocd

Additionally, if you would like to also use a debugger and already have openocd, there is an optional requirement:
- gdb

If you would like to use the UF2 method of flashing the rpi pico, you can install:
- elf2uf2-rs
**Warning for the UF2 method, this is not supported by the makefile currently. You will have to use the function manually and move the file manually unless you modify the makefile.**

# References
[Life with david: BMA 04](https://github.com/LifeWithDavid/RaspberryPiPico-BareMetalAdventures/tree/main/Chapter%2004)

[RP2040 Datasheet](https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf)

[Rpi Pico Pinout](https://www.raspberrypi.com/documentation/microcontrollers/images/pico-pinout.svg)

[Rpi Pico W Pinout](https://www.raspberrypi.com/documentation/microcontrollers/images/picow-pinout.svg)

[Rpi Pico SDK](https://github.com/raspberrypi/pico-sdk)

[ARMv6-M Architecture Reference Manual](https://documentation-service.arm.com/static/5f8ff05ef86e16515cdbf826)
