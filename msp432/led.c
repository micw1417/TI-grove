#include "led.h"
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

void led_init(void)
{
    GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);
    GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);
}

void led_toggle(void)
{
    GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);
}