#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include "grove_buzzer.h"

/* -------------------------------------------------------
 * Pin configuration
 * P2.1 = buzzer signal pin
 * ------------------------------------------------------- */
#define BUZZER_PORT     GPIO_PORT_P2
#define BUZZER_PIN      GPIO_PIN1

/* -------------------------------------------------------
 * Song data — Twinkle Twinkle Little Star
 * ------------------------------------------------------- */
static const int  length  = 15;
static const char notes[] = "ccggaagffeeddc ";
static const int  beats[] = { 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 4 };
static const int  tempo   = 200;

static const char names[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C' };
static const int  tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956 };

/* -------------------------------------------------------
 * delay_ms() / delay_us()
 *
 * MSP432P401R default DCO = 3MHz at reset
 * 1ms = 3000 cycles
 * 1us = 3 cycles
 *
 * If you call CS_setDCOFrequency() in main() to change
 * the clock, update these multipliers to match.
 * ------------------------------------------------------- */
static void delay_ms(int ms)
{
    int i;
    for (i = 0; i < ms; i++)
    {
        __delay_cycles(3000);   /* 3000 cycles = 1ms @ 3MHz DCO */
    }
}

static void delay_us(int us)
{
    int i;
    for (i = 0; i < us; i++)
    {
        __delay_cycles(3);      /* 3 cycles = 1us @ 3MHz DCO */
    }
}

/* -------------------------------------------------------
 * playTone()
 * Bit-bangs the buzzer pin to produce a square wave.
 *
 * tone_us  = half-period in microseconds
 * duration_ms = total duration in milliseconds
 * ------------------------------------------------------- */
static void playTone(int tone_us, int duration_ms)
{
    long total_us = (long)duration_ms * 1000L;
    long elapsed  = 0;

    while (elapsed < total_us)
    {
        /* HIGH half of square wave */
        GPIO_setOutputHighOnPin(BUZZER_PORT, BUZZER_PIN);
        delay_us(tone_us);

        /* LOW half of square wave */
        GPIO_setOutputLowOnPin(BUZZER_PORT, BUZZER_PIN);
        delay_us(tone_us);

        elapsed += (long)tone_us * 2;
    }
}

/* -------------------------------------------------------
 * playNote()
 * ------------------------------------------------------- */
static void playNote(char note, int duration_ms)
{
    int i;
    for (i = 0; i < 8; i++)
    {
        if (names[i] == note)
        {
            playTone(tones[i], duration_ms);
            return;
        }
    }
}

/* -------------------------------------------------------
 * grove_buzzer_init()
 * Call once from main() before grove_buzzer_play()
 * ------------------------------------------------------- */
void grove_buzzer_init(void)
{
    GPIO_setAsOutputPin(BUZZER_PORT, BUZZER_PIN);
    GPIO_setOutputLowOnPin(BUZZER_PORT, BUZZER_PIN);
}

/* -------------------------------------------------------
 * grove_buzzer_play()
 * Plays one full pass of the melody. Call from main loop.
 * ------------------------------------------------------- */
void grove_buzzer_play(void)
{
    int i;
    for (i = 0; i < length; i++)
    {
        if (notes[i] == ' ')
        {
            delay_ms(beats[i] * tempo);
        }
        else
        {
            playNote(notes[i], beats[i] * tempo);
        }
        delay_ms(tempo / 2);
    }
}