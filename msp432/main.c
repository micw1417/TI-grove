#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include "grove/grove_buzzer.h"
#include "led.h"

/**
 * main.c
 */
int main(void)
{
	WDT_A_holdTimer();	// stop watchdog timer
	volatile unsigned int i;

	led_init();
	grove_buzzer_init();

	while(1) {
	    led_toggle();
	    grove_buzzer_play();
	    for (i=10000; i>0; i--);
	}
}
