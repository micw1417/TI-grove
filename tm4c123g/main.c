#include <stdint.h>
#include <stdbool.h>

// TivaWare system control — needed for SysCtlClockSet and SysCtlDelay
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "driverlib/sysctl.h"

// Your board drivers
#include "led.h"
#include "grove/grove_buzzer.h"

// ==============================================================
// System clock configuration
//
// The TM4C123G boots using the internal 16MHz precision oscillator
// (PIOSC) by default. For most projects you want to run at the
// full 80MHz using the PLL fed by the external 16MHz crystal.
//
// SysCtlClockSet() breakdown:
//   SYSCTL_SYSDIV_2_5  — PLL output (400MHz) / 2 / 2.5 = 80MHz
//                         Note: the PLL always outputs 400MHz,
//                         and there is a mandatory /2 divider,
//                         so: 400 / 2 / SYSDIV = target freq
//   SYSCTL_USE_PLL     — use the PLL as clock source
//   SYSCTL_XTAL_16MHZ  — tell the PLL the crystal is 16MHz
//   SYSCTL_OSC_MAIN    — use the main oscillator (external crystal)
// ==============================================================
#define SYSTEM_CLOCK_HZ  80000000UL   // 80 MHz

// ==============================================================
// Delay helper
//
// SysCtlDelay(n) executes exactly 3*n CPU cycles.
// So for a 1ms delay at 80MHz:
//   cycles_per_ms = 80,000,000 / 1000 = 80,000
//   n = 80,000 / 3 = 26,667
//
// DELAY_MS(x) macro calculates this for any clock and duration.
// ==============================================================
#define DELAY_MS(ms)  SysCtlDelay((SYSTEM_CLOCK_HZ / 3000) * (ms))

int main(void)
{
    // ----------------------------------------------------------
    // Step 1: Configure system clock to 80MHz via PLL
    // On MSP432 this wasn't needed — it defaulted to a usable
    // speed. On TM4C you should always set this explicitly or
    // SysCtlDelay timing and UART baud rates will be wrong.
    // ----------------------------------------------------------
    SysCtlClockSet(
        SYSCTL_SYSDIV_2_5  |   // 400MHz PLL / 2 / 2.5 = 80MHz
        SYSCTL_USE_PLL     |   // engage the PLL
        SYSCTL_XTAL_16MHZ  |   // external crystal is 16MHz
        SYSCTL_OSC_MAIN        // use main oscillator as PLL input
    );

    // ----------------------------------------------------------
    // Step 2: Watchdog
    // On TM4C123G the watchdog timer is DISABLED by default after
    // reset — no action needed. This is different from some other
    // microcontrollers (like older MSP430s) where the watchdog
    // starts enabled and will reset the chip after ~32ms if you
    // don't stop it immediately.
    //
    // If you later enable the watchdog intentionally, you would
    // use: WatchdogEnable(WATCHDOG0_BASE)
    //      WatchdogReloadSet(WATCHDOG0_BASE, reload_value)
    // ----------------------------------------------------------

    // ----------------------------------------------------------
    // Step 3: Initialize peripherals
    // ----------------------------------------------------------
    led_init();
    // grove_buzzer_init();

    // ----------------------------------------------------------
    // Step 4: Main loop
    // ----------------------------------------------------------
    while (1)
    {
        led_toggle();

        // SysCtlDelay is far better than a volatile counter loop:
        //   - It's implemented in assembly so it won't be optimized away
        //   - Each call is exactly 3 CPU cycles — predictable timing
        //   - Works correctly at any clock speed via the macro
        //
        // Old MSP432 style (avoid this on TM4C):
        //   volatile unsigned int i;
        //   for (i = 10000; i > 0; i--);   <- timing depends on clock + optimizer
        DELAY_MS(500);   // 500ms toggle = 1Hz blink
    }
}