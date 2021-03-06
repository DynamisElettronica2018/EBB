#line 1 "D:/Google Drive/REPARTO ELETTRONICA 2018/EBB/FIRMWARE DPX/EBB_DPX.c"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/macro.c"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/d_can.h"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/can.c"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/can.h"
#line 48 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/can.h"
void Can_init(void);

void Can_read(unsigned long int *id, char dataBuffer[], unsigned int *dataLength, unsigned int *inFlags);

void Can_writeByte(unsigned long int id, unsigned char dataOut);

void Can_writeInt(unsigned long int id, int dataOut);

void Can_addIntToWritePacket(int dataOut);

void Can_addByteToWritePacket(unsigned char dataOut);

void Can_write(unsigned long int id);

void Can_setWritePriority(unsigned int txPriority);

void Can_resetWritePacket(void);

unsigned int Can_getWriteFlags(void);

unsigned char Can_B0hasBeenReceived(void);

unsigned char Can_B1hasBeenReceived(void);

void Can_clearB0Flag(void);

void Can_clearB1Flag(void);

void Can_clearInterrupt(void);

void Can_initInterrupt(void);
#line 14 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/can.c"
unsigned long int can_readId = 0;
 char can_dataInBuffer[ 8 ];
unsigned char can_dataOutBuffer[ 8 ];
unsigned char can_dataInPointer = 0;

unsigned int can_dataInLength = 0;
unsigned int can_dataOutLength = 0;
unsigned int can_inFlags = 0;
unsigned int can_txPriority =  _CAN_TX_PRIORITY_1 ;
unsigned int can_err = 0;

void Can_init() {
 unsigned int Can_Init_flags = 0;
 Can_Init_flags = _CAN_CONFIG_STD_MSG &
 _CAN_CONFIG_DBL_BUFFER_ON &
 _CAN_CONFIG_MATCH_MSG_TYPE &
 _CAN_CONFIG_LINE_FILTER_ON &
 _CAN_CONFIG_SAMPLE_THRICE &
 _CAN_CONFIG_PHSEG2_PRG_ON;
 CAN1Initialize(2,4,3,4,2,Can_Init_flags);
 CAN1SetOperationMode(_CAN_MODE_CONFIG,0xFF);

 CAN1SetMask(_CAN_MASK_B1, 0b01010111111, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
 CAN1SetFilter(_CAN_FILTER_B1_F1,  0b01100001101 , _CAN_CONFIG_STD_MSG);
 CAN1SetFilter(_CAN_FILTER_B1_F2,  0b11001001101 , _CAN_CONFIG_STD_MSG);

 CAN1SetMask(_CAN_MASK_B2, -1, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
 CAN1SetFilter(_CAN_FILTER_B2_F1,  0b10100000000 , _CAN_CONFIG_STD_MSG);

 CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);

 Can_initInterrupt();
 Can_setWritePriority( _CAN_TX_PRIORITY_1 );
}

void Can_read(unsigned long int *id, char dataBuffer[], unsigned int *dataLength, unsigned int *inFlags) {
 if (Can_B0hasBeenReceived()) {
 Can_clearB0Flag();
 Can1Read(id, dataBuffer, dataLength, &inFlags);
 }
 else if (Can_B1hasBeenReceived()) {
 Can_clearB1Flag();
 Can1Read(id, dataBuffer, dataLength, &inFlags);
 }
}

void Can_writeByte(unsigned long int id, unsigned char dataOut) {
 Can_resetWritePacket();
 Can_addByteToWritePacket(dataOut);
 Can_write(id);
}

void Can_writeInt(unsigned long int id, int dataOut) {
 Can_resetWritePacket();
 Can_addIntToWritePacket(dataOut);
 Can_write(id);
}

void Can_addIntToWritePacket(int dataOut) {
 Can_addByteToWritePacket((unsigned char) (dataOut >> 8));
 Can_addByteToWritePacket((unsigned char) (dataOut & 0xFF));
}

void Can_addByteToWritePacket(unsigned char dataOut) {
 can_dataOutBuffer[can_dataOutLength] = dataOut;
 can_dataOutLength += 1;
}

void Can_write(unsigned long int id) {
 unsigned int sent, i;
 do {
 sent = CAN1Write(id, can_dataOutBuffer, can_dataOutLength, Can_getWriteFlags());
 i += 1;
 } while ((sent == 0) && (i <  50 ));
 if (i ==  50 ) {
 can_err++;
 }
}

void Can_setWritePriority(unsigned int txPriority) {
 can_txPriority = txPriority;
}

void Can_resetWritePacket(void) {
 for (can_dataOutLength = 0; can_dataOutLength <  8 ; can_dataOutLength += 1) {
 can_dataOutBuffer[can_dataOutLength] = 0;
 }
 can_dataOutLength = 0;
}

unsigned int Can_getWriteFlags(void) {
 return  _CAN_TX_STD_FRAME & _CAN_TX_NO_RTR_FRAME  & can_txPriority;
}

unsigned char Can_B0hasBeenReceived(void) {
 return  C1INTFBITS.RXB0IF  == 1;
}

unsigned char Can_B1hasBeenReceived(void) {
 return  C1INTFBITS.RXB1IF  == 1;
}

void Can_clearB0Flag(void) {
  C1INTFBITS.RXB0IF  = 0;
}

void Can_clearB1Flag(void) {
  C1INTFBITS.RXB1IF  = 0;
}

void Can_clearInterrupt(void) {
  IFS1BITS.C1IF  = 0;
}

void Can_initInterrupt(void) {

  { int save_sr; { save_sr = SRbits.IPL; { int DISI_save; DISI_save = DISICNT; asm DISI #0X3FF ;SRbits.IPL = 7; asm {nop}; asm {nop}; DISICNT = DISI_save; } (void) 0; ; } (void) 0; ;IEC1BITS.C1IE = 1; { int DISI_save; DISI_save = DISICNT; asm DISI #0X3FF ;SRbits.IPL = save_sr; asm {nop}; asm {nop}; DISICNT = DISI_save; } (void) 0; ; } (void) 0; ;
  { int save_sr; { save_sr = SRbits.IPL; { int DISI_save; DISI_save = DISICNT; asm DISI #0X3FF ;SRbits.IPL = 7; asm {nop}; asm {nop}; DISICNT = DISI_save; } (void) 0; ; } (void) 0; ;C1INTEBITS.RXB0IE = 1; { int DISI_save; DISI_save = DISICNT; asm DISI #0X3FF ;SRbits.IPL = save_sr; asm {nop}; asm {nop}; DISICNT = DISI_save; } (void) 0; ; } (void) 0; ;
  { int save_sr; { save_sr = SRbits.IPL; { int DISI_save; DISI_save = DISICNT; asm DISI #0X3FF ;SRbits.IPL = 7; asm {nop}; asm {nop}; DISICNT = DISI_save; } (void) 0; ; } (void) 0; ;C1INTEBITS.RXB1IE = 1; { int DISI_save; DISI_save = DISICNT; asm DISI #0X3FF ;SRbits.IPL = save_sr; asm {nop}; asm {nop}; DISICNT = DISI_save; } (void) 0; ; } (void) 0; ;

 }
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.c"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.h"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/basic.h"
#line 16 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/basic.h"
void unsignedIntToString(unsigned int number, char *text);

void signedIntToString(int number, char *text);

unsigned char getNumberDigitCount(unsigned char number);

void emptyString(char* myString);
#line 171 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.h"
void setAllPinAsDigital(void);

void setInterruptPriority(unsigned char device, unsigned char priority);

void setExternalInterrupt(unsigned char device, char edge);

void switchExternalInterruptEdge(unsigned char);

char getExternalInterruptEdge(unsigned char);

void clearExternalInterrupt(unsigned char);

void setTimer(unsigned char device, double timePeriod);

void clearTimer(unsigned char device);

void turnOnTimer(unsigned char device);

void turnOffTimer(unsigned char device);

unsigned int getTimerPeriod(double timePeriod, unsigned char prescalerIndex);

unsigned char getTimerPrescaler(double timePeriod);

double getExactTimerPrescaler(double timePeriod);

void setupAnalogSampling(void);

void turnOnAnalogModule();

void turnOffAnalogModule();

void startSampling(void);

unsigned int getAnalogValue(void);

void setAnalogPIN(unsigned char pin);

void unsetAnalogPIN(unsigned char pin);

void setAnalogInterrupt(void);

void unsetAnalogInterrupt(void);

void clearAnalogInterrupt(void);


void setAutomaticSampling(void);

void unsetAutomaticSampling(void);


void setAnalogVoltageReference(unsigned char mode);

void setAnalogDataOutputFormat(unsigned char adof);

int getMinimumAnalogClockConversion(void);
#line 7 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.c"
const double INSTRUCTION_PERIOD = 4.0 /  32 ;
const unsigned int PRESCALER_VALUES[] = {1, 8, 64, 256};


void setAllPinAsDigital(void) {
 ADPCFG = 0xFFFF;
}

void setInterruptPriority(unsigned char device, unsigned char priority) {
 switch (device) {
 case  4 :
  IPC0bits.INT0IP  = priority;
 break;
 case  5 :
  IPC4bits.INT1IP  = priority;
 break;
 case  6 :
  IPC5bits.INT2IP  = priority;
 break;
#line 29 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.c"
 case  1 :
  IPC0bits.T1IP  = priority;
 break;
 case  2 :
  IPC1bits.T2IP  = priority;
 break;
 case  3 :
  IPC5bits.T4IP  = priority;
 break;
 default:
 break;
 }
}

void setExternalInterrupt(unsigned char device, char edge) {
 setInterruptPriority(device,  4 );
 switch (device) {
 case  4 :
  INTCON2.INT0EP  = edge;
  IFS0.INT0IF  =  0 ;
  IEC0.INT0IE  =  1 ;
 break;
 case  5 :
  INTCON2.INT1EP  = edge;
  IFS1.INT1IF  =  0 ;
  IEC1.INT1IE  =  1 ;
 break;
 case  6 :
  INTCON2.INT2EP  = edge;
  IFS1.INT2IF  =  0 ;
  IEC1.INT2IE  =  1 ;
 break;
#line 65 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.c"
 default:
 break;
 }
}

void switchExternalInterruptEdge(unsigned char device) {
 switch (device) {
 case  4 :
 if ( INTCON2.INT0EP  ==  1 ) {
  INTCON2.INT0EP  =  0 ;
 } else {
  INTCON2.INT0EP  =  1 ;
 }
 break;
 case  5 :
 if ( INTCON2.INT1EP  ==  1 ) {
  INTCON2.INT1EP  =  0 ;
 } else {
  INTCON2.INT1EP  =  1 ;
 }
 break;
 case  6 :
 if ( INTCON2.INT2EP  ==  1 ) {
  INTCON2.INT2EP  =  0 ;
 } else {
  INTCON2.INT2EP  =  1 ;
 }
 break;
#line 99 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.c"
 default:
 break;
 }
}

char getExternalInterruptEdge(unsigned char device) {
 switch (device) {
 case  4 :
 return  INTCON2.INT0EP ;
 case  5 :
 return  INTCON2.INT1EP ;
 case  6 :
 return  INTCON2.INT2EP ;
#line 114 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.c"
 default:
 return 0;
 }
}

void clearExternalInterrupt(unsigned char device) {
 switch (device) {
 case  4 :
  IFS0.INT0IF  =  0 ;
 break;
 case  5 :
  IFS1.INT1IF  =  0 ;
 break;
 case  6 :
  IFS1.INT2IF  =  0 ;
 break;
#line 132 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/dspic.c"
 default:
 break;
 }
}

void setTimer(unsigned char device, double timePeriod) {
 unsigned char prescalerIndex;
 setInterruptPriority(device,  4 );

 prescalerIndex = getTimerPrescaler(timePeriod);
 switch (device) {
 case  1 :
  T1CONbits.TCKPS  = prescalerIndex;
  PR1  = getTimerPeriod(timePeriod, prescalerIndex);
  IEC0bits.T1IE  =  1 ;
  T1CONbits.TON  =  1 ;
 break;
 case  2 :
  T2CONbits.TCKPS  = prescalerIndex;
  PR2  = getTimerPeriod(timePeriod, prescalerIndex);
  IEC0bits.T2IE  =  1 ;
  T2CONbits.TON  =  1 ;
 break;
 case  3 :
  T4CONbits.TCKPS  = prescalerIndex;
  PR4  = getTimerPeriod(timePeriod, prescalerIndex);
  IEC1bits.T4IE  =  1 ;
  T4CONbits.TON  =  1 ;
 break;
 }
}

void clearTimer(unsigned char device) {
 switch (device) {
 case  1 :
  IFS0bits.T1IF  =  0 ;
 break;
 case  2 :
  IFS0bits.T2IF  =  0 ;
 break;
 case  3 :
  IFS1bits.T4IF  =  0 ;
 break;
 }
}

void turnOnTimer(unsigned char device) {
 switch (device) {
 case  1 :
  T1CONbits.TON  =  1 ;
 break;
 case  2 :
  T2CONbits.TON  =  1 ;
 break;
 case  3 :
  T4CONbits.TON  =  1 ;
 break;
 }
}

void turnOffTimer(unsigned char device) {
 switch (device) {
 case  1 :
  T1CONbits.TON  =  0 ;
 break;
 case  2 :
  T2CONbits.TON  =  0 ;
 break;
 case  3 :
  T4CONbits.TON  =  0 ;
 break;
 }
}

unsigned int getTimerPeriod(double timePeriod, unsigned char prescalerIndex) {
 return (unsigned int) ((timePeriod * 1000000) / (INSTRUCTION_PERIOD * PRESCALER_VALUES[prescalerIndex]));
}

unsigned char getTimerPrescaler(double timePeriod) {
 unsigned char i;
 double exactTimerPrescaler;
 exactTimerPrescaler = getExactTimerPrescaler(timePeriod);
 for (i = 0; i < sizeof(PRESCALER_VALUES); i += 1) {
 if ((int) exactTimerPrescaler < PRESCALER_VALUES[i]) {
 return i;
 }
 }
 i -= 1;

 return i;
}

double getExactTimerPrescaler(double timePeriod) {
 return (timePeriod * 1000000) / (INSTRUCTION_PERIOD *  65535 );
}

void setupAnalogSampling(void) {
  ADCON1bits.SSRC  =  7 ;
  ADCON1bits.FORM  =  0 ;
  ADCON1bits.ADSIDL  =  0 ;
  ADCON2bits.CSCNA  =  1 ;
  ADCON2bits.BUFM  =  0 ;
  ADCON2bits.ALTS  =  0 ;
  ADCON3bits.ADRC  =  0 ;
  ADCHSbits.CH0NB  =  0 ;
  ADCHSbits.CH0NA  =  0 ;
  ADCHSbits.CH0SB  = 0;
  ADCHSbits.CH0SA  = 0;


  ADCON3bits.ADCS  = getMinimumAnalogClockConversion();
  ADCON3bits.SAMC  = 1;

  ADPCFG  = 0b1111111111111111;
  ADCSSL  = 0;

 setAutomaticSampling();
 setAnalogVoltageReference( 0 );
 unsetAnalogInterrupt();
 startSampling();
}

void turnOnAnalogModule() {
  ADCON1bits.ADON  =  1 ;
}

void turnOffAnalogModule() {
  ADCON1bits.ADON  =  0 ;
}

void startSampling(void) {
  ADCON1bits.SAMP  =  1 ;
}

unsigned int getAnalogValue(void) {
 return  ADCBUF0 ;
}

void setAnalogPIN(unsigned char pin) {
  ADPCFG  =  ADPCFG  & ~(int) ( 1  << pin);
  ADCSSL  =  ADCSSL  | ( 1  << pin);
}

void unsetAnalogPIN(unsigned char pin) {
  ADPCFG  =  ADPCFG  | ( 1  << pin);
  ADCSSL  =  ADCSSL  & ~(int) ( 1  << pin);
}

void setAnalogInterrupt(void) {
 clearAnalogInterrupt();
  IEC0bits.ADIE  =  1 ;
}

void unsetAnalogInterrupt(void) {
 clearAnalogInterrupt();
  IEC0bits.ADIE  =  0 ;
}

void clearAnalogInterrupt(void) {
  IFS0bits.ADIF  =  0 ;
}

void setAutomaticSampling(void) {
  ADCON1bits.ASAM  =  1 ;
}

void unsetAutomaticSampling(void) {
  ADCON1bits.ASAM  =  0 ;
}

void setAnalogVoltageReference(unsigned char mode) {
  ADCON2bits.VCFG  = mode;
}

void setAnalogDataOutputFormat(unsigned char adof) {
  ADCON1bits.FORM  = adof;
}

int getMinimumAnalogClockConversion(void) {
 return (int) (( 154  *  32 ) / 500.0);
}
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/eeprom.c"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/eeprom.h"









void EEPROM_writeInt(unsigned int address, unsigned int value);

unsigned int EEPROM_readInt(unsigned int address);

void EEPROM_writeArray(unsigned int address, unsigned int *values);

void EEPROM_readArray(unsigned int address, unsigned int *values);
#line 7 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/libs/eeprom.c"
void EEPROM_writeInt(unsigned int address, unsigned int value) {
 unsigned int currentValue;


 EEPROM_write(address, value);
 while(WR_bit);

}

unsigned int EEPROM_readInt(unsigned int address) {
 return EEPROM_read(address);
}

void EEPROM_writeArray(unsigned int address, unsigned int *values) {
 unsigned int i;
 for (i = 0; i < sizeof(values); i += 1) {
 EEPROM_writeInt(address, values[i]);
 }
}

void EEPROM_readArray(unsigned int address, unsigned int *values) {
 unsigned int i;
 for (i = 0; i < sizeof(values); i += 1) {
 values[i] = EEPROM_read(address + i);
 }
}
#line 11 "D:/Google Drive/REPARTO ELETTRONICA 2018/EBB/FIRMWARE DPX/EBB_DPX.c"
sbit REVERSE at LATE2_bit;
sbit FORWARD at LATE4_bit;
sbit ENABLE at LATE1_bit;
sbit DISABLE at LATE0_bit;
sbit LED_G at LATD1_bit;
sbit LED_B at LATD3_bit;
sbit BUZZER at LATD2_bit;
sbit DIRECTION_REGISTER at UPDN_bit;
#line 53 "D:/Google Drive/REPARTO ELETTRONICA 2018/EBB/FIRMWARE DPX/EBB_DPX.c"
unsigned int ebb_target_pos;
unsigned int ebb_current_pos;
unsigned int calibration_on_off =  0 ;
unsigned int error_flag =  0 ;
int EBB_call_control_routine =  0 ;

int buzzer_state =  0 ;
int sound =  0 ;
int motor_state =  0 ;
int motor_target_position;
int motor_current_position;
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/ebb_can_functions.h"





void CAN_routine();
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/ebb_can_functions.c"





void CAN_routine()
{
 Can_resetWritePacket();
 Can_addIntToWritePacket(ebb_current_pos);
 Can_addIntToWritePacket(calibration_on_off);
 Can_addIntToWritePacket(error_flag);
 Can_write( 0b11001100110 );
}
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/initialization.c"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/initialization.h"





void EBB_Init();
#line 7 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/initialization.c"
void EBB_Init()
{

 ADPCFG = 0b1111111111111110;
 TRISDbits.TRISD1 = 0;
 TRISDbits.TRISD3 = 0;
 TRISDbits.TRISD2 = 0;
 TRISEbits.TRISE0 = 0;
 TRISEbits.TRISE4 = 0;
 TRISEbits.TRISE2 = 0;
 TRISEbits.TRISE1 = 0;
 TRISBbits.TRISB0 = 1;
 BUZZER = 0;
 LED_B = 0;
 LED_G = 0;

 QEICON = 0b0000010100000010;
 POSCNT = EEPROM_Read(LAST_POSCNT);
 MAXCNT =  5024 ;
 IPC10bits.QEIIP = 4;
 IFS2bits.QEIIF = 0;
 IEC2bits.QEIIE = 1;

 PWMCON1 = 0b0000000100000001;
 PTPER = 1999;
 PDC1 = 0;
 PTMR = 0;
 PTCON = 0b1000000000000000;
 FORWARD = 0;
 REVERSE = 0;
 ENABLE = 0;


 ebb_current_pos = EEPROM_Read( 0x7FFDC0 );
 ebb_target_pos = ebb_current_pos;

 CAN_Init();

 CAN_routine();


 setTimer( 1 ,0.001);
 setTimer( 2 ,0.1);
 setTimer( 3 ,0.003);


 buzzer_state =  1 ;
 LED_B =  1 ;
 LED_G =  1 ;
 delay_ms(800);
 buzzer_state =  0 ;
 LED_B =  0 ;
 LED_G =  0 ;


}
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/motor.c"
#line 1 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/motor.h"





void EBB_control(void);
void normal_motor_control(void);
void central_calibration_control(void);
void zero_position_control(void);
#line 6 "d:/google drive/reparto elettronica 2018/ebb/firmware dpx/modules/motor.c"
void EBB_control()
{


 if (ebb_target_pos != ebb_current_pos && motor_state ==  0  && ebb_target_pos >= 0 && ebb_target_pos <= 16)
 {

 switch(ebb_target_pos){
 case 0:
 motor_target_position =  0 ;
 break;
 case 1:
 motor_target_position =  2 ;
 break;
 case 2:
 motor_target_position =  4 ;
 break;
 case 3:
 motor_target_position =  6 ;
 break;
 case 4:
 motor_target_position =  8 ;
 break;
 case 5:
 motor_target_position =  10 ;
 break;
 case 6:
 motor_target_position =  12 ;
 break;
 case 7:
 motor_target_position =  14 ;
 break;
 case 8:
 motor_target_position =  16 ;
 break;
 case 9:
 motor_target_position =  18 ;
 break;
 case 10:
 motor_target_position =  20 ;
 break;
 case 11:
 motor_target_position =  22 ;
 break;
 case 12:
 motor_target_position =  24 ;
 break;
 case 13:
 motor_target_position =  26 ;
 break;
 case 14:
 motor_target_position =  28 ;
 break;
 case 15:
 motor_target_position =  30 ;
 break;
 case 16:
 motor_target_position =  32 ;
 break;
 }

 normal_motor_control();

 }
 else if (ebb_target_pos == SET_CENTRAL_CALIBRATION_MODE && motor_state ==  0 )
 {

 central_calibration_control();
 }
 else if (ebb_target_pos == SET_ZERO_POSITION_MODE && motor_state ==  0 )
 {

 zero_position_control();
 }
 else if (motor_state ==  0 )
 {
 ebb_target_pos = ebb_current_pos;
 }
}










void normal_motor_control()
{
 int target_reached_flag;
 int position_difference;
 int proportional_error;
 int integral_error;
 int pi_pwm;
 LED_B =  1 ;
 motor_state =  1 ;
 EEPROM_WRITE(ADDR_MOTOR_STATE,  1 );
 while(WR_bit){};
 ebb_current_pos = EBB_STATE_ROTATING;

 PDC1 = 0;
 ENABLE =  1 ;
 target_reached_flag =  0 ;
 position_difference = 0;
 proportional_error = 0;
 integral_error = 0;
 pi_pwm = 0;
 while (target_reached_flag ==  0 )
 {
 position_difference = encoder_target_position - POSCNT;

 if(ebb_overcurrent_flag ==  1  )
 {
 while(current_counter < OVERCURRENT_CUTOFF_TIME)
 PDC1 = 0;
 current_counter = 0;
 ebb_overcurrent_flag =  0 ;
 }
 if(pid_counter > TIMING_PID){
 if(position_difference > 0)
 {
 proportional_error = K_PROPORTIONAL * position_difference;
 if(proportional_error <= INTEGRAL_TRIGGER)
 {
 integral_error = integral_error + (position_difference/K_INTEGRAL);
 }else
 integral_error = 0;
 }else{
 proportional_error = K_PROPORTIONAL * (-1*position_difference);
 if(proportional_error <= INTEGRAL_TRIGGER)
 {
 integral_error = integral_error + ((-1*position_difference)/K_INTEGRAL);
 }else
 integral_error = 0;
 }

 pi_pwm = proportional_error + integral_error;
 if(pi_pwm < MIN_PWM) pi_pwm = MIN_PWM;
 if(pi_pwm > MAX_PWM) pi_pwm = MAX_PWM;
 PDC1 = pi_pwm;
 pid_counter = 0;
 }

 if(position_difference > POSITION_TOLERANCE)
 {
 FORWARD = 1;
 REVERSE = 0;
 }else if(position_difference < -1*(POSITION_TOLERANCE))
 {
 FORWARD = 0;
 REVERSE = 1;
 }else
 {
 target_reached_flag =  1 ;
 }

 }

 if(target_reached_flag =  1 )
 {
 PDC1 = 0;
 ENABLE =  0 ;
 ebb_current_pos = ebb_target_pos;
 EEPROM_WRITE(ADDR_MAPPED_POS, ebb_current_pos);
 while(WR_bit);
 EEPROM_WRITE(ADDR_REAL_POS, POSCNT);
 while(WR_bit);
 motor_state =  0 ;
 EEPROM_WRITE(ADDR_MOTOR_STATE,  0 );
 while(WR_bit);
 }else
 {

 }
 LED_B =  0 ;

}










void central_calibration_control()
{
 int i;
 LED_G =  1 ;
 for(i=0; i <= 4; i++)
 {
 BUZZER =  1 ;
 delay_ms(200);
 BUZZER =  0 ;
 delay_ms(200);
 }
 motor_state = M_STATE_CALIBRATING;
 EEPROM_WRITE(ADDR_MOTOR_STATE, M_STATE_CALIBRATING);
 while(WR_bit);
 ebb_current_pos = EBB_STATE_CALIBRATION;

 while(ebb_target_pos >= CALIBRATION_DOWN && ebb_target_pos <= CALIBRATION_UP)
 {
 switch(ebb_target_pos)
 {
 case CALIBRATION_DOWN:
 ENABLE = 1;
 FORWARD = 0;
 REVERSE = 1;
 PDC1 = 3000;
 break;
 case CALIBRATION_UP:
 ENABLE = 1;
 FORWARD = 1;
 REVERSE = 0;
 PDC1 = 3000;
 break;
 default:
 ENABLE = 0;
 FORWARD = 0;
 REVERSE = 0;
 PDC1 = 0;
 }
 }
 ENABLE =  0 ;
 ebb_current_pos = EEPROM_Read(ADDR_MAPPED_POS);
 POSCNT = EEPROM_Read(ADDR_REAL_POS);
 EEPROM_WRITE(ADDR_MOTOR_STATE,  0 );
 while(WR_bit);
 motor_state =  0 ;
 LED_G =  0 ;
}










void zero_position_control()
{
 int i;
 LED_G =  1 ;
 for(i=0; i <= 8; i++)
 {
 BUZZER =  1 ;
 delay_ms(200);
 BUZZER =  0 ;
 delay_ms(200);
 }
 motor_state = M_STATE_CALIBRATING;
 EEPROM_WRITE(ADDR_MOTOR_STATE, M_STATE_CALIBRATING);
 while(WR_bit);
 POSCNT = CENTRAL;
 ebb_current_pos = 4;
 EEPROM_WRITE(ADDR_MAPPED_POS, 4);
 while(WR_bit);
 EEPROM_WRITE(ADDR_REAL_POS, CENTRAL);
 while(WR_bit);

 EEPROM_WRITE(ADDR_MOTOR_STATE,  0 );
 while(WR_bit);
 motor_state =  0 ;
 LED_G =  0 ;
}
#line 74 "D:/Google Drive/REPARTO ELETTRONICA 2018/EBB/FIRMWARE DPX/EBB_DPX.c"
 void timer2_interrupt() iv IVT_ADDR_T2INTERRUPT ics ICS_AUTO  {
 CAN_routine();
 EBB_call_control_routine =  1 ;
  IFS0bits.T2IF  = 0 ;
}

 void timer4_interrupt() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO  {
 if(buzzer_state ==  1 ){
 BUZZER = !BUZZER;
 }
  IFS1bits.T4IF  = 0 ;
}







void counter_quarter_turn_match() iv IVT_ADDR_QEIINTERRUPT ics ICS_AUTO {


 IFS2bits.QEIIF = 0;
}


void main() {
 EBB_Init();
 while(1)
 {
 if (EBB_call_control_routine)
 {
 EBB_control();
 EBB_call_control_routine =  0 ;
 }
 }

}
