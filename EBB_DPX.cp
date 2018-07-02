#line 1 "C:/Users/nicol/Documents/git_codes/EBB/EBB_DPX.c"
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/d_can.h"
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/can.c"
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/can.h"
#line 48 "c:/users/nicol/documents/git_codes/ebb/libs/can.h"
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
#line 14 "c:/users/nicol/documents/git_codes/ebb/libs/can.c"
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

 CAN1SetMask(_CAN_MASK_B1,  0b11111111111 , _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
 CAN1SetFilter(_CAN_FILTER_B1_F1,  0b10000000000 , _CAN_CONFIG_STD_MSG);
 CAN1SetFilter(_CAN_FILTER_B1_F2,  0b11001010000 , _CAN_CONFIG_STD_MSG);

 CAN1SetMask(_CAN_MASK_B2,  0b11111110000 , _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
 CAN1SetFilter(_CAN_FILTER_B2_F1,  0b11111110000 , _CAN_CONFIG_STD_MSG);

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
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/macro.c"
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.c"
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.h"
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/basic.h"
#line 16 "c:/users/nicol/documents/git_codes/ebb/libs/basic.h"
void unsignedIntToString(unsigned int number, char *text);

void signedIntToString(int number, char *text);

unsigned char getNumberDigitCount(unsigned char number);

void emptyString(char* myString);
#line 171 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.h"
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
#line 7 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.c"
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
#line 29 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.c"
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
#line 65 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.c"
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
#line 99 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.c"
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
#line 114 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.c"
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
#line 132 "c:/users/nicol/documents/git_codes/ebb/libs/dspic.c"
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
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/eeprom.c"
#line 1 "c:/users/nicol/documents/git_codes/ebb/libs/eeprom.h"









void EEPROM_writeInt(unsigned int address, unsigned int value);

unsigned int EEPROM_readInt(unsigned int address);

void EEPROM_writeArray(unsigned int address, unsigned int *values);

void EEPROM_readArray(unsigned int address, unsigned int *values);
#line 7 "c:/users/nicol/documents/git_codes/ebb/libs/eeprom.c"
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
#line 9 "C:/Users/nicol/Documents/git_codes/EBB/EBB_DPX.c"
sbit REVERSE at LATE3_bit;
sbit FORWARD at LATE4_bit;
sbit ENABLE at LATE2_bit;
sbit DISABLE at LATE0_bit;
sbit LED_B at LATD1_bit;
sbit LED_G at LATD3_bit;
sbit BUZZER at LATD2_bit;
sbit DIRECTION_REGISTER at UPDN_bit;
#line 63 "C:/Users/nicol/Documents/git_codes/EBB/EBB_DPX.c"
unsigned int ebb_target_pos;
unsigned int ebb_current_pos;
unsigned int ebb_settings;
unsigned int brake_pressure_front;

int buzzer_state =  0 ;
int motor_target_position;
int motor_current_position;

char is_requested_calibration = 0;
char is_requested_movement = 0;
unsigned int calibration_on_off =  0 ;
unsigned int error_flag =  0 ;

int timer2_counter = 0, timer1_counter = 0;
#line 1 "c:/users/nicol/documents/git_codes/ebb/modules/ebb_can_functions.h"



void CAN_routine();
#line 1 "c:/users/nicol/documents/git_codes/ebb/modules/ebb_can_functions.c"



void CAN_routine()
{
 Can_resetWritePacket();
 Can_addIntToWritePacket(ebb_current_pos);
 Can_addIntToWritePacket(calibration_on_off);
 Can_addIntToWritePacket(error_flag);
 Can_write( 0b11100001101 );
}
#line 1 "c:/users/nicol/documents/git_codes/ebb/modules/motor.c"
#line 1 "c:/users/nicol/documents/git_codes/ebb/modules/motor.h"

typedef enum{
 EBB_OFF,
 EBB_START,
 EBB_MOVING,
 EBB_BRAKING,
 EBB_POSITION_REACHED,
 EBB_CENTRAL_CALIBRATION,
 EBB_ERROR,
 EBB_DRIVER_BRAKING
}ebb_states;


char blink_counter = 0;
char brake_counter = 0;

ebb_states ebb_current_state = EBB_OFF;




void EBB_control(void);
void normal_motor_control(void);
void central_calibration_control(void);
void zero_position_control(void);
void motor_brake(void);
#line 6 "c:/users/nicol/documents/git_codes/ebb/modules/motor.c"
char dstr[100] = "";

void Debug_UART_Write(char* text){
 UART1_Write_Text(text);
}



void counter_quarter_turn_match() iv IVT_ADDR_QEIINTERRUPT ics ICS_AUTO {
 switch(DIRECTION_REGISTER){
 case 0:
 motor_current_position--;
 break;
 case 1:
 motor_current_position++;
 break;
 default:
 break;
 }
 if (motor_current_position == motor_target_position)
 {
 brake_counter = 0;
 REVERSE =  0 ;
 FORWARD =  0 ;
 ebb_current_state = EBB_BRAKING;
 }
 IFS2bits.QEIIF = 0;
}



void EBB_control()
{
 switch(ebb_current_state)
 {
 case EBB_OFF:
 if(is_requested_movement)
 {
 switch(ebb_target_pos)
 {
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
 ebb_current_state = EBB_START;
 is_requested_movement =  0 ;
 }else if(is_requested_calibration)
 {
 ebb_current_state = EBB_CENTRAL_CALIBRATION;
 is_requested_calibration =  0 ;
 }
 break;
 case EBB_START:
 if(motor_target_position > motor_current_position)
 {
 FORWARD =  1 ;
 REVERSE =  0 ;
 }else if (motor_target_position < motor_current_position)
 {
 motor_target_position--;
 REVERSE =  1 ;
 FORWARD =  0 ;
 }
 ENABLE =  1 ;
 PDC1 =  4000 ;

 ebb_current_state = EBB_MOVING;
 break;
 case EBB_MOVING:
 blink_counter++;
 if(blink_counter >= 20)
 {
 LED_G = ~LED_G;
 blink_counter = 0;
 }
 break;
 case EBB_BRAKING:
 LED_G =  0 ;
 LED_B =  1 ;

 if(brake_counter >=  30 )
 {
 ebb_current_state = EBB_POSITION_REACHED;
 }
 break;
 case EBB_POSITION_REACHED:
 LED_B =  0 ;
 ENABLE =  0 ;
 REVERSE =  0 ;
 FORWARD =  0 ;
 ebb_current_pos = ebb_target_pos;
 motor_current_position = motor_target_position;
 EEPROM_WRITE( 0x7FFDA0 , POSCNT);
 sprintf(dstr, "EEPROM: %u\r\n", POSCNT);
 Debug_UART_Write(dstr);
 while(WR_bit);
 EEPROM_WRITE( 0x7FFDB0 , motor_current_position);
 while(WR_bit);
 EEPROM_WRITE( 0x7FFDC0 , ebb_current_pos);
 while(WR_bit);
 ebb_current_state =  0 ;
 break;
 case EBB_DRIVER_BRAKING:
 buzzer_state =  1 ;
 if(brake_pressure_front <  1000 )
 {
 buzzer_state =  0 ;
 ebb_current_state = EBB_START;
 }
 break;
 }
}
#line 1 "c:/users/nicol/documents/git_codes/ebb/modules/initialization.c"
#line 1 "c:/users/nicol/documents/git_codes/ebb/modules/initialization.h"



void EBB_Init();
#line 5 "c:/users/nicol/documents/git_codes/ebb/modules/initialization.c"
void EBB_Init()
{

 if(EEPROM_Read( 0x7FFDD0 ) == 0xFFFF)
 {
 EEPROM_WRITE( 0x7FFDA0 , 0);
 while(WR_bit);
 EEPROM_WRITE( 0x7FFDC0 , 8);
 while(WR_bit);
 EEPROM_WRITE( 0x7FFDB0 , 16);
 while(WR_bit);
 EEPROM_WRITE( 0x7FFDD0 , 0);
 while(WR_bit);
 }

 ADPCFG = 0b1111111111111110;
 TRISDbits.TRISD1 = 0;
 TRISDbits.TRISD3 = 0;
 TRISDbits.TRISD2 = 0;
 TRISEbits.TRISE0 = 0;
 TRISEbits.TRISE4 = 0;
 TRISEbits.TRISE3 = 0;
 TRISEbits.TRISE2 = 0;
 TRISBbits.TRISB0 = 1;
 BUZZER = 0;
 LED_B = 0;
 LED_G = 0;

 QEICON = 0b0000010110000010;

 POSCNT = EEPROM_Read( 0x7FFDA0 );
 MAXCNT =  10048 ;
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
 motor_current_position = EEPROM_Read( 0x7FFDB0 );
 motor_target_position = motor_current_position;
 ebb_settings = 0;
 brake_pressure_front = 0;
 is_requested_calibration = 0;
 is_requested_movement = 0;

 CAN_Init();

 CAN_routine();

 UART1_Init(9600);

 ebb_current_state = EBB_OFF;


 setTimer( 3 ,0.003);


 buzzer_state =  1 ;
 LED_B =  1 ;
 LED_G =  1 ;
 delay_ms(1000);
 buzzer_state =  0 ;
 LED_B =  0 ;
 LED_G =  0 ;

 setTimer( 1 ,0.01);
 setTimer( 2 ,0.001 *  10 );
}
#line 92 "C:/Users/nicol/Documents/git_codes/EBB/EBB_DPX.c"
 void timer1_interrupt() iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO  {
 timer1_counter ++;
 if (timer1_counter == 300){
 ebb_current_state = EBB_OFF;
 is_requested_movement =  1 ;
 ebb_target_pos = 8;
 }
 if (timer1_counter == 600){
 ebb_current_state = EBB_OFF;
 is_requested_movement =  1 ;
 ebb_target_pos = 7;
 }
 if (timer1_counter == 900){
 ebb_current_state = EBB_OFF;
 is_requested_movement =  1 ;
 ebb_target_pos = 6;
 }
 if (timer1_counter == 1200){
 ebb_current_state = EBB_OFF;
 is_requested_movement =  1 ;
 ebb_target_pos = 5;
 }
 if (timer1_counter == 1500){
 ebb_current_state = EBB_OFF;
 is_requested_movement =  1 ;
 ebb_target_pos = 6;
 }
 if (timer1_counter == 1800){
 ebb_current_state = EBB_OFF;
 is_requested_movement =  1 ;
 ebb_target_pos = 7;
 timer1_counter = 0;
 }



 if(ebb_current_state !=  0  && brake_pressure_front >=  1000 )
 {
 ENABLE =  0 ;
 ebb_current_state = EBB_DRIVER_BRAKING;
 }

  IFS0bits.T1IF  = 0 ;
}

 void timer2_interrupt() iv IVT_ADDR_T2INTERRUPT ics ICS_AUTO  {
 timer2_counter++;
 brake_counter++;
 EBB_control();
 if (timer2_counter >= 10)
 {
 CAN_routine();
 timer2_counter = 0;
 }

 sprintf(dstr, "POSCNT: %u\r\n", POSCNT);
 Debug_UART_Write(dstr);
  IFS0bits.T2IF  = 0 ;
}

 void timer4_interrupt() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO  {
 if(buzzer_state ==  1 ){
 BUZZER = !BUZZER;
 }
  IFS1bits.T4IF  = 0 ;
}


void main() {
 EBB_Init();
 while(1)
 {
 }

}

 void CAN_Interrupt() iv IVT_ADDR_C1INTERRUPT  {
 unsigned long int CAN_id;
 char CAN_datain[8];
 unsigned int CAN_dataLen, CAN_flags;
 unsigned int firstInt, secondInt, thirdInt, fourthInt;

 Can_read(&CAN_id, CAN_datain, &CAN_dataLen, &CAN_flags);

 if (CAN_dataLen >= 2) {
 firstInt = (unsigned int) ((CAN_datain[0] << 8) | (CAN_datain[1] & 0xFF));
 }
 if (CAN_dataLen >= 4) {
 secondInt = (unsigned int) ((CAN_datain[2] << 8) | (CAN_datain[3] & 0xFF));
 }
 if (CAN_dataLen >= 6) {
 thirdInt = (unsigned int) ((CAN_datain[4] << 8) | (CAN_datain[5] & 0xFF));
 }
 if (CAN_dataLen >= 8) {
 fourthInt = (unsigned int) ((CAN_datain[6] << 8) | (CAN_datain[7] & 0xFF));
 }
 Can_clearInterrupt();

 switch(CAN_id){
 case  0b10000000000 :
 ebb_target_pos = ((unsigned int)firstInt);
 ebb_settings = ((unsigned int)secondInt);
 if ((ebb_target_pos != ebb_current_pos) && ebb_target_pos >=  0  && ebb_target_pos <=  16 )
 {
 is_requested_movement =  1 ;
 }else if (ebb_target_pos ==  100 )
 {
 is_requested_calibration =  1 ;
 }
 break;
 case  0b11001010000 :
 brake_pressure_front = ((unsigned int)thirdInt);
 break;

 }
}
