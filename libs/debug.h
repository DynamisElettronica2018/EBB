
#ifdef _DEBUG_

extern char dstr[100];

void Debug_UART_Init();
void Debug_Timer4_Init();
void Debug_UART_Write(char* text);
void printf(char* string);
void initTimer32(void);
void resetTimer32(void);
double getExecTime(void);
void stopTimer32();
void startTimer32();

#endif