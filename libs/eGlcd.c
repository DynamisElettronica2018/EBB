//
// Created by Aaron Russo on 10/06/16.
//

#include <string.h>
#include "eGlcd.h"

#if OSC_FREQ_MHZ > OSC_FREQ_THRESHOLD

onTimer4Interrupt{
    clearTimer4();
}

#endif

/*'
' Adapted xGlcd lib
' */

const unsigned short xColorClear = 0;
const unsigned short xColorSet = 1;
const unsigned short xColorInvert = 2;


const char *xGlcdSelFont;

unsigned short xGlcdX, xGlcdY, xGlcdSelFontHeight,
        xGlcdSelFontWidth, xGlcdSelFontOffset,
        xGlcdSelFontNbRows;

char xGLCD_Transparency;

void eGlcd_init() {
    BLACK = PIXEL_ON;
    WHITE = PIXEL_OFF;
    Glcd_Init();
    if (OSC_FREQ_MHZ > OSC_FREQ_THRESHOLD) {
        eGlcd_setupTimer();
    }
}

void eGlcd_invertColors(void) {
    if (BLACK == PIXEL_OFF) {
        BLACK = PIXEL_ON;
        WHITE = PIXEL_OFF;
    } else {
        BLACK = PIXEL_OFF;
        WHITE = PIXEL_ON;
    }
}

void eGlcd_clear(void) {
    eGlcd_fill(WHITE);
}

void eGlcd_fill(unsigned char color) {
    if (color) {
        eGlcd(Glcd_Fill(0xFF));
    } else {
        eGlcd(Glcd_Fill(0x00));
    }
}


void eGlcd_overwriteChar(char oldChar, char newChar, unsigned char x, unsigned char y) {
    eGlcd_clearChar(oldChar, x, y);
    eGlcd_writeChar(newChar, x, y);
}

void eGlcd_clearChar(char letter, unsigned char x, unsigned char y) {
    if (BLACK) {
        xGlcd_Write_Char(letter, x, y, WHITE);
    } else {
        xGLCD_Set_Transparency(TRUE);
        xGlcd_Write_Char(letter, x, y, WHITE);
        xGLCD_Set_Transparency(FALSE);
    }
}

void eGlcd_writeChar(char letter, unsigned char x, unsigned char y) {
    if (BLACK) {
        xGlcd_Write_Char(letter, x, y, BLACK);
    } else {
        xGlcd_Write_Char(letter, x, y, INVERT);
    }
}

void eGlcd_overwriteText(char *oldText, char *newText, unsigned char x, unsigned char y) {
    eGlcd_clearText(oldText, x, y);
    eGlcd_writeText(newText, x, y);
}

void eGlcd_clearText(char *text, unsigned char x, unsigned char y) {
    if (BLACK) {
        xGlcd_Write_Text(text, x, y, WHITE);
    } else {
        xGLCD_Set_Transparency(TRUE);
        xGlcd_Write_Text(text, x, y, WHITE);
        xGLCD_Set_Transparency(FALSE);
    }
}

void eGlcd_writeText(char *text, unsigned char x, unsigned char y) {
    if (BLACK) {
        xGlcd_Write_Text(text, x, y, BLACK);
    } else {
        xGlcd_Write_Text(text, x, y, INVERT);
    }
}

void eGlcd_setupTimer(void) {
    setTimer(TIMER4_DEVICE, EGLCD_TIMER_PERIOD_US * 0.000001);
    setInterruptPriority(TIMER4_DEVICE, LOW_PRIORITY);
    turnOffTimer(TIMER4_DEVICE);
}

void eGlcd_setTimerCoefficient(float coefficient) {
    EGLCD_TIMER_COEFFICIENT = coefficient;
}

unsigned int eGlcd_getTextPixelLength(char *text) {
    unsigned int textPixelLength, i;
    textPixelLength = 0;
    for (i = 0; i < strlen(text); i += 1) {
        textPixelLength = textPixelLength + xGlcd_Char_Width(text[i]);
    }
    return textPixelLength;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void xGlcd_Set_Font(const char *ptrFontTbl, unsigned short font_width,
                    unsigned short font_height, unsigned int font_offset) {
    xGlcdSelFont = ptrFontTbl;
    xGlcdSelFontWidth = font_width;
    xGlcdSelFontHeight = font_height;
    xGlcdSelFontOffset = font_offset;
    xGLCD_Transparency = FALSE;  //Transparency of Text is set to False !!!
    xGlcdSelFontNbRows = xGlcdSelFontHeight / 8;
    if (xGlcdSelFontHeight % 8) xGlcdSelFontNbRows++;
}


void xGLCD_Write_Data(unsigned short pX, unsigned short pY, unsigned short pData) {
    unsigned short tmp, tmpY, gData, dataR, xx, yy;

    if ((pX > 127) || (pY > 63)) return;
    xx = pX % 64;
    tmp = pY / 8;
    if (tmp > 7) return;
    tmpY = pY % 8;
    if (tmpY) {
        //Write first group
        gData = pData << tmpY;
        eGlcd(Glcd_Set_Side(pX);
                      Glcd_Set_X(xx);
                      Glcd_Set_Page(tmp);
                      dataR = Glcd_Read_Data();
                      dataR = Glcd_Read_Data(););
        if (!xGLCD_Transparency)
            dataR = dataR & (0xff >> (8 - tmpY));
        dataR = gData | dataR;
        eGlcd(Glcd_Set_X(xx);
                      Glcd_Write_Data(dataR););
        //Write Second group
        tmp++;
        if (tmp > 7) return;
        eGlcd(Glcd_Set_X(xx);
                      Glcd_Set_Page(tmp);
                      gData = pData >> (8 - tmpY);
                      dataR = Glcd_Read_Data();
                      dataR = Glcd_Read_Data(););
        if (!xGLCD_Transparency)
            dataR = dataR & (0xff << tmpY);
        dataR = gData | dataR;
        eGlcd(Glcd_Set_X(xx);
                      Glcd_Write_Data(dataR););
    }
    else {
        eGlcd(Glcd_Set_Side(pX);
                      Glcd_Set_X(xx);
                      Glcd_Set_Page(tmp););
        if (xGLCD_Transparency) {
            eGlcd(dataR = Glcd_Read_Data();
                          dataR = Glcd_Read_Data();
                          dataR = pData | dataR;);
        }
        else
            dataR = pData;
        eGlcd(Glcd_Set_X(xx);
                      Glcd_Write_Data(dataR););
    }
}

unsigned short xGlcd_Write_Char(unsigned short ch, unsigned short x, unsigned short y, unsigned short color) {
    const char *CurCharData;
    unsigned short i, j, CharWidth, CharData;
    unsigned long cOffset;

    cOffset = xGlcdSelFontWidth * xGlcdSelFontNbRows + 1;
    cOffset = cOffset * (ch - xGlcdSelFontOffset);
    CurCharData = xGlcdSelFont + cOffset;
    CharWidth = *CurCharData;
    cOffset++;
    for (i = 0; i < CharWidth; i++)
        for (j = 0; j < xGlcdSelFontNbRows; j++) {
            CurCharData = xGlcdSelFont + (i * xGlcdSelFontNbRows) + j + cOffset;
            switch (color) {
                case 0 :
                    CharData = 0;
                    break;
                case 1 :
                    CharData = *CurCharData;
                    break;
                case 2 :
                    CharData = ~(*CurCharData);
                    break;
            }
            xGLCD_Write_Data(x + i, y + j * 8, CharData);
        };
    return CharWidth;
}

unsigned short xGlcd_Char_Width(unsigned short ch) {
    const char *CurCharDt;
    unsigned long cOffset;
    cOffset = xGlcdSelFontWidth * xGlcdSelFontNbRows + 1;
    cOffset = cOffset * (ch - xGlcdSelFontOffset);
    CurCharDt = xGlcdSelFont + cOffset;
    return *CurCharDt;
}

void xGlcd_Write_Text(char *text, unsigned short x, unsigned short y, unsigned short color) {
    unsigned short i, l, posX;
    char *curChar;
    l = strlen(text);
    posX = x;
    curChar = text;
    for (i = 0; i < l; i++) {
        posX = posX + xGlcd_Write_Char(*curChar, posX, y, color) + 1; //add 1 blank column
        curChar++;
    }
}

unsigned short xGlcd_Text_Width(char *text) {
    unsigned short i, l, w;
    l = strlen(text);
    w = 0;
    for (i = 0; i < l; i++)
        w = w + xGlcd_Char_Width(text[i]) + 1; //add 1 blank column
    return w;
}

void xGLCD_Set_Transparency(char active) {
    xGLCD_Transparency = active;
}
