

#ifdef _DEBUG_

#include "debug.h"

char dstr[100] = "";

void Debug_UART_Init()
{
     UART1_Init(9600);
     delay_ms(100);
}

void Debug_Timer4_Init(){
     setTimer(TIMER4_DEVICE, 0.001);
}

void Debug_UART_Write(char* text){
     UART1_Write_Text(text);
}

//incremented every 3.2us
void initTimer32(){
    PR2 = 0xFFFF;
    PR3 = 0xFFFF;
    T2CONbits.T32 = 1;
    T2CONbits.TCS = 0;
    T2CONbits.TGATE = 0;
    T2CONbits.TCKPS = 2;
    //IFS0bits.T3IF = 0;
    //IPC1bits.T3IP = 5;
    //IEC0bits.T3IE = 1;

}

void resetTimer32()
{
     T2CONbits.TON = 0;
     TMR3HLD = 0;
     TMR2 = 0;
     T2CONbits.TON = 1;
}

//up to 13 seconds
double getExecTime()
{
     unsigned long a=0;
     unsigned int b=0;
     double c = 0;
     b = TMR2;
     a = TMR3HLD;
     a = a<<16;
     a += b;
     c = a*3.2e-6;
     return c;
}

void stopTimer32()
{
     T2CONbits.TON = 0;
}

void startTimer32()
{
     T2CONbits.TON = 1;
}

#endif