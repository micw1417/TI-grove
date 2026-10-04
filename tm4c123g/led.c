#include "led.h"
#include "utils/uartstdio.h"
#include <driverlib/pin_map.h>
#include <stdint.h>

// ==============================================================
// led_init
// Enables Port F clock, waits for it to stabilize,
// then configures LED pin as a push-pull digital output.
// ==============================================================

void uart_init(void)
{
    // Enable UART0 and its GPIO port (Port A, pins PA0=RX, PA1=TX)
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_UART0)) {}
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOA)) {}

    // Configure PA0 and PA1 for UART function
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    // UARTStdioConfig(port, baud, system clock)
    // 115200 baud is standard for serial terminals
    UARTStdioConfig(0, 115200, SysCtlClockGet());
}

void led_init(void)
{
    // Enable the GPIO Port F peripheral clock.
    // TM4C gates ALL peripheral clocks off by default to save power.
    // Accessing any GPIO register before this = guaranteed hard fault.
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);

    // Spin until the peripheral clock is stable (~3 CPU cycles).
    // Never skip this — it causes intermittent crashes that are
    // very hard to debug because they only happen at cold boot.
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOF))
    {
    }

    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOF)) {}

    // --- UART replacement for scanf ---
    char inputBuf[16];              // Buffer to hold raw input string
    uint32_t pinValue = 0;

    UARTprintf("Enter LED pin (hex, e.g. 0002): ");
    UARTgets(inputBuf, sizeof(inputBuf));         // Reads a line from UART terminal
    sscanf(inputBuf, "%04x", &pinValue);          // Parse hex just like scanf would
    LED_PIN = (uint8_t)pinValue;

    // Configure LED pin as push-pull digital output.
    // This sets both the DIR register (output direction)
    // and the DEN register (digital enable — required on TM4C).
    GPIOPinTypeGPIOOutput(LED_PORT, LED_PIN);
    
    // Start with LED off — drive pin LOW.
    GPIOPinWrite(LED_PORT, LED_PIN, 0);
}

// ==============================================================
// led_toggle
// TivaWare has no toggle function — must read-modify-write.
// GPIOPinRead returns the full 8-bit port byte, so always
// mask with LED_PIN to isolate your specific bit.
// ==============================================================
void led_toggle(void)
{
    if (GPIOPinRead(LED_PORT, LED_PIN) & LED_PIN)
    {
        GPIOPinWrite(LED_PORT, LED_PIN, 0);
    }
    else
    {
        GPIOPinWrite(LED_PORT, LED_PIN, LED_PIN);
    }
}

void led_on(void)
{
    GPIOPinWrite(LED_PORT, LED_PIN, LED_PIN);
}

void led_off(void)
{
    GPIOPinWrite(LED_PORT, LED_PIN, 0);
}