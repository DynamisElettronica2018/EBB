
#include "libs/d_can.h"
#include "libs/can.c"
#include "libs/macro.c"
#include "libs/dsPIC.c"
#include "libs/eeprom.c"

//Digital i/o pins
sbit REVERSE at LATE3_bit;  //Reverse input of the h-bridge
sbit FORWARD at LATE4_bit;  //Forward input of the h-bridge
sbit ENABLE at LATE2_bit;  //Enable pin of h-bridge ( h-bridge on if HIGH )
sbit DISABLE at LATE0_bit;  //Disable pin ( capable of PWM )
sbit LED_G at LATD1_bit;
sbit LED_B at LATD3_bit;  //LEDs
sbit BUZZER at LATD2_bit;  //buzzer pin
sbit DIRECTION_REGISTER at UPDN_bit;  //register for direction

//Defines
#define ON 1
#define OFF 0

//Positions (quarter of turns)
#define POSITION_0 0
#define POSITION_1 2
#define POSITION_2 4
#define POSITION_3 6
#define POSITION_4 8
#define POSITION_5 10
#define POSITION_6 12
#define POSITION_7 14
#define POSITION_8 16
#define POSITION_9 18
#define POSITION_10 20
#define POSITION_11 22
#define POSITION_12 24
#define POSITION_13 26
#define POSITION_14 28
#define POSITION_15 30
#define POSITION_16 32
#define MIN_POSITION 0
#define MAX_POSITION 16
#define CALIBRATION_POSITION 100
//Constants
#define QUARTER_TURN 5024
#define TURN 20096

#define ADDR_FIRST_BOOT 0x7FFDD0
#define ADDR_LAST_POSCNT 0x7FFDA0 //Last POSCNT record
#define ADDR_LAST_NUMBER_QUARTER_TURNS 0x7FFDB0 //Last record of quarter turns (from completely screw-on balance bar)
#define ADDR_LAST_MAPPED_POSITION 0x7FFDC0 //Last record of mapped position

#define CONTROL_ROUTINE_REFRESH 20 //Refresh in ms
#define BRAKE_TIME_LENGHT 100
#define PWM_SATURATION 4000

#define BRAKE_PRESSURE_TRIGGER 1000  //Trigger value when driver is braking
#define OVERCURRENT_TRIGGER    //Trigger valure for overcurrent detection



//Global variables declaration
unsigned int ebb_target_pos;
unsigned int ebb_current_pos;
unsigned int ebb_settings;
unsigned int brake_pressure_front;

int buzzer_state = OFF;
int sound = OFF;
int motor_target_position;  //quarter turns
int motor_current_position;  //quarter turns

char is_requested_calibration = 0;
char is_requested_movement = 0;
unsigned int calibration_on_off = OFF;
unsigned int error_flag = OFF;

int timer2_counter = 0, timer1_counter = 0;


//External program blocks
#include "modules/EBB_can_functions.h"
#include "modules/motor.c"
#include "modules/initialization.c"



//Timers routines



onTimer1Interrupt {
    timer1_counter ++;
    if (timer1_counter == 100){
       ebb_current_state = EBB_OFF;
       ebb_target_pos = 7;
    }
    if (timer1_counter == 250){
       ebb_current_state = EBB_OFF;
       ebb_target_pos = 6;
    }
    if (timer1_counter == 400){
       ebb_current_state = EBB_OFF;
       ebb_target_pos = 5;
    }
    if (timer1_counter == 550){
       ebb_current_state = EBB_OFF;
       ebb_target_pos = 8;
       timer1_counter = 0;
    }
    

    if(ebb_current_state != OFF && brake_pressure_front >= BRAKE_PRESSURE_TRIGGER)
    {
        ENABLE = OFF;  //Turn off the motor
        ebb_current_state = EBB_DRIVER_BRAKING;  //Enter corresponding mode
    }
    //Check for overcurrent
}

onTimer2Interrupt {
    timer2_counter++;
    EBB_control();
    if (timer2_counter >= 5) 
    {
        CAN_routine();  //Call the can update routine
        timer2_counter = 0;
    }    
    clearTimer2();
}

onTimer4Interrupt {
    if(buzzer_state == ON){  //Sound routine
         BUZZER = !BUZZER;
         }
    clearTimer4();
}


void main() {
        EBB_Init();
    while(1)
    {
    }

}

onCanInterrupt {
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
        case SW_BRAKE_BIAS_EBB_ID: 
            ebb_target_pos = ((unsigned int)firstInt);
            ebb_settings = ((unsigned int)secondInt);
            if ((ebb_target_pos != ebb_current_pos) && ebb_target_pos >= MIN_POSITION && ebb_target_pos <= MAX_POSITION)
            {
                is_requested_movement = ON;
            }else if (ebb_target_pos == CALIBRATION_POSITION)
            {
                is_requested_calibration = ON;
            }
        break;
        case DAU_FR_ID:       
            brake_pressure_front = ((unsigned int)thirdInt);
        break;

     }
}