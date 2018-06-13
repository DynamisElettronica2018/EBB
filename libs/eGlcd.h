//
// Created by Aaron Russo on 10/06/16.
//
// Enhanced Glcd library
// This expansion takes advantage of the already existing
// MikroC Glcd and xGlcd libraries, enabling compatibility
// with fast devices

// GRAPHICAL ARTIFACTS
// Compatibility with fast devices:
// In order to unlock bugged glcd library for faster frequencies (>54Mhz) this library starts a timer that has
// the effect to slow down data transmission.
// The perfect timer period is calculated automatically so you shouldn't be worried about anything! :)
// These values have been calculated empirically, assuming a linear relation it has been noticed that
// @80Mhz a 4uS timer is needed while @64Mhz needs a 6,2uS timer.

// You can adjust the following coefficient if you find graphical artifacts by decreasing it, if you want to speed
// up your application you can try increasing this coefficient until you get artifacts.
// 4 Is the default value that will act on the timer as described above.
// @80Mhz
// 3.9 -> 3.9uS
// 4.0 -> 4.0uS
// 4.1 -> 4.1uS
// 4.2 -> 4.2uS
// @64Mhz
// 3.9 -> 6.05uS
// 4.0 -> 6.20uS
// 4.1 -> 6.35uS
// 4.2 -> 6.51uS

#ifndef DP8_DISPLAY_CONTROLLER_GLCD_H
#define DP8_DISPLAY_CONTROLLER_GLCD_H

float EGLCD_TIMER_COEFFICIENT = 4;

#ifndef OSC_FREQ_MHZ
#define OSC_FREQ_MHZ 32
#endif

#define OSC_FREQ_THRESHOLD 80
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define PIXEL_ON 1
#define PIXEL_OFF 0
#define PIXEL_INVERT 2

#if OSC_FREQ_MHZ > OSC_FREQ_THRESHOLD
#define eGlcd(x) turnOnTimer4();x;turnOffTimer4();
#else
#define eGlcd(x) x
#endif

#define eGlcd_setFont xGlcd_Set_Font

unsigned char BLACK, WHITE;
const unsigned char INVERT = PIXEL_INVERT;

#define EGLCD_F_SLOPE ((6.2 - 4) / (80 - 64))
#define EGLCD_F_MAX (4/EGLCD_F_SLOPE) + 80
#define EGLCD_TIMER_PERIOD_US (EGLCD_F_SLOPE * (0.025 * EGLCD_TIMER_COEFFICIENT * 10)  * (EGLCD_F_MAX - OSC_FREQ_MHZ))

void eGlcd_init(void);

void eGlcd_invertColors(void);

void eGlcd_clear(void);

void eGlcd_fill(unsigned char color);

void eGlcd_overwriteChar(char oldChar, char newChar, unsigned char x, unsigned char y);

void eGlcd_clearChar(char letter, unsigned char x, unsigned char y);

void eGlcd_writeChar(char letter, unsigned char x, unsigned char y);

void eGlcd_overwriteText(char *oldText, char *newText, unsigned char x, unsigned char y);

void eGlcd_clearText(char *text, unsigned char x, unsigned char y);

void eGlcd_writeText(char *text, unsigned char x, unsigned char y);

void eGlcd_setupTimer(void);

void eGlcd_setTimerCoefficient(float coefficient);

unsigned int eGlcd_getTextPixelLength(char *text);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*'
' Adapted xGlcd lib
' */

void xGlcd_Set_Font(const char *ptrFontTbl, unsigned short font_width,
                    unsigned short font_height, unsigned int font_offset);

void xGLCD_Write_Data(unsigned short pX, unsigned short pY, unsigned short pData);

unsigned short xGlcd_Write_Char(unsigned short ch, unsigned short x, unsigned short y, unsigned short color);

unsigned short xGlcd_Char_Width(unsigned short ch);

void xGlcd_Write_Text(char *text, unsigned short x, unsigned short y, unsigned short color);

unsigned short xGlcd_Text_Width(char *text);

void xGLCD_Set_Transparency(char active);

#include "basic.h"
#include "dsPIC.h"
#include "glcdPins.c"

#endif //DP8_DISPLAY_CONTROLLER_GLCD_H
