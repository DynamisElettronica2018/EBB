#line 1 "C:/Users/sofia/Desktop/GIT REPO/EBB/modules/initialization.c"
#line 1 "c:/users/sofia/desktop/git repo/ebb/modules/initialization.h"



void EBB_Init();
#line 5 "C:/Users/sofia/Desktop/GIT REPO/EBB/modules/initialization.c"
void EBB_Init()
{

 if(EEPROM_Read(ADDR_FIRST_BOOT) == 0)
 {
 EEPROM_WRITE(ADDR_LAST_POSCNT, QUARTER_TURN/2);
 while(WR_bit);
 EEPROM_WRITE(ADDR_LAST_MAPPED_POSITION, 8);
 while(WR_bit);
 EEPROM_WRITE(ADDR_LAST_NUMBER_QUARTER_TURNS, 16);
 while(WR_bit);
 EEPROM_WRITE(ADDR_FIRST_BOOT, 1);
 while(WR_bit);
 }

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
 POSCNT = EEPROM_Read(ADDR_LAST_POSCNT);
 MAXCNT = QUARTER_TURN;
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


 ebb_current_pos = EEPROM_Read(ADDR_LAST_MAPPED_POSITION);
 ebb_target_pos = ebb_current_pos;
 motor_current_position = EEPROM_Read(ADDR_LAST_NUMBER_QUARTER_TURNS);
 motor_target_position = motor_current_position;
 ebb_settings = 0;
 brake_pressure_front = 0;
 is_requested_calibration = 0;
 is_requested_movement = 0;

 CAN_Init();

 CAN_routine();

 ebb_current_state = EBB_OFF;


 setTimer(TIMER1_DEVICE,0.01);
 setTimer(TIMER2_DEVICE,0.001 * CONTROL_ROUTINE_REFRESH);
 setTimer(TIMER4_DEVICE,0.003);


 buzzer_state = ON;
 LED_B = ON;
 LED_G = ON;
 delay_ms(800);
 buzzer_state = OFF;
 LED_B = OFF;
 LED_G = OFF;


}
