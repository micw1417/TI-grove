#ifndef LED_H
#define LED_H

// ==============================================================
// LED Driver — EK-TM4C123GXL (Tiva C LaunchPad)
// TivaWare driverlib API
//
// CRITICAL INCLUDE ORDER:
//   1. stdint.h  — uint32_t, uint8_t, int32_t etc.
//   2. stdbool.h — bool, true, false
//   3. inc/hw_memmap.h  — peripheral base addresses (GPIO_PORTF_BASE etc.)
//   4. inc/hw_types.h   — HWREG() macro
//   5. driverlib/*.h    — TivaWare API functions
//
// TivaWare headers intentionally do NOT include stdint/stdbool
// themselves — you must always include them first.
// This is standard practice in bare-metal embedded C.
// ==============================================================

#include <stdint.h>     // uint32_t, uint8_t, int32_t
#include <stdbool.h>    // bool, true, false

#include "inc/hw_memmap.h"    // GPIO_PORTF_BASE, UART0_BASE, etc.
#include "inc/hw_types.h"     // HWREG() macro and basic register types
#include "driverlib/gpio.h"   // GPIOPinTypeGPIOOutput, GPIOPinWrite, GPIOPinRead
#include "driverlib/sysctl.h" // SysCtlPeripheralEnable, SysCtlPeripheralReady

// ==============================================================
// Hardware pin mapping — EK-TM4C123GXL onboard RGB LED
// PF1 = Red, PF2 = Blue, PF3 = Green
// ==============================================================
#define LED_PORT   GPIO_PORTF_BASE
uint8_t LED_PIN = GPIO_PIN_2;   // Red LED — change to PIN_2/PIN_3 for blue/green

void led_init(void);
void led_toggle(void);
void led_on(void);
void led_off(void);

#endif // LED_H