.section .reset, "ax"
.global _start
_start:


/* {{{ Crystal Oscillator Setup

By default, the rpi pico uses the ring oscillator, which is fine, but we can use the crystal oscillator for a more accurate clock.

STEP 1: We will set the startup delay for the crystal oscillator
STEP 2: We will enable the crystal oscillator and define the use of the 12MHz crystal
STEP 3: We need to wait for the crystal oscillator to start up. We will check if the stable bit in the status register for the xosc is set. Looping if not.
STEP 4: Finally, we can switch from the ROSC to the XOSC. We do this by glitchless swapping the reference clock to use the XOSC. Since the reference clock is the default clock for the system clock, this means that the system clock will also use the XOSC.
STEP 5: Keep checking to ensure that the XOSC is swapped to

params:
    xosc_ctrl: Control register for the crystal oscillator. (Is also the base for xosc)
    xosc_startup: Register for xosc that handles the startup delay
    clk_ref_ctrl: Control register for the reference clock (the system clock uses the reference clock as a default)
*/

.equ xosc_ctrl, 0x40024000 
.equ xosc_startup, xosc_ctrl + 0xc
.equ clk_ref_ctrl, 0x40008000 + 0x30

// STEP 1
    ldr r7, =xosc_startup
    mov r6, #47
    str r6, [r7]

// STEP 2
    ldr r7, =xosc_ctrl
    ldr r6, =(0xfab<<12 + 0xaa0)
    str r6, [r7]

// STEP 3
xosc_rdy:
    ldr r6, [r7, #0x4]
    lsr r6, #31
    beq xosc_rdy

// STEP 4
    ldr r7, =clk_ref_ctrl
    mov r6, #0x2
    str r6, [r7]

// STEP 5 (Not Implemented)

// }}}

/* {{{ Ring Oscillator Stop

I want to disable to ring oscillator as it is no longer needed. We will be using the XOSC for now.

params:
    rosc_ctrl: Control register for the ring oscillator.
*/

.equ rosc_ctrl, 0x40060000 

    ldr r7, =rosc_ctrl
    ldr r6, =(0xd1e<<12 + 0xaa0)
    str r6, [r7]

// }}}

/* {{{ Reset Controller 

Initially, the peripherals on the rp2040 not required to boot are held in a reset state. We can interact with the reset controller to control this behavior.

In STEP 1, we will clear the reset on iobank_0 as this has the controls for all the gpio pins.
In STEP 2, we will check whether the reset on iobank_0 was successful, and infinite loop if not

params:
    rst_base: base register for clearing reset controller
    rst_clr: atomic register for clearing reset controller
    rst_done: register to check for successful reset done
*/

.equ rst_base, 0x4000c000
.equ rst_clr, rst_base + 0x3000 
.equ rst_done, rst_base + 0x8

// STEP 1
    ldr r7, =rst_clr
    mov r6, #0b100000
    str r6, [r7]

// STEP 2
    ldr r7, =rst_done
rst:
    ldr r5, [r7]
    and r5, r6
    beq rst

// }}}

/* {{{ GPIO Control Register

We will need to edit the GPIO Control Registers so that they are enabled and controllable by the SIO.

params:
    gpio0_ctrl: control register for gpio0
*/

.equ gpio0_ctrl, 0x40014000 + 0x4
    ldr r7, =gpio0_ctrl
    mov r6, #5
    str r6, [r7]

// }}}

/* {{{ SIO GPIO Output Enable and Set

Now, we will enable the GPIO Output on the specified pin and then we will turn it the output on (or set it).

// STEP 1: Output Enable
// STEP 2: Output Set

params:
    sio_base: base register for SIO control
    gpio_oe: output enable register for gpio through SIO
    gpio_out_set: output set register for gpio through SIO
*/

.equ sio_base, 0xd0000000
.equ gpio_oe, sio_base + 0x20
.equ gpio_out, sio_base + 0x10

// STEP 1
    ldr r7, =gpio_oe
    mov r6, #0b1
    str r6, [r7]

// STEP 2
    ldr r7, =gpio_out
    mov r6, #0b1
    str r6, [r7]

// }}}

/* {{{ Enter Dormant state

params:
    xosc_dormant: control register for dormant state on XOSC
*/
.equ xosc_dormant, xosc_ctrl + 0x08

    ldr r7, =xosc_dormant
    ldr r6, =0x636f6d61
    str r6, [r7]

/// }}}

// {{{ Processor Sleep
    // wfi

    mov r6, #0b0
    str r6, [r7]
// }}}
