
#include "libs/macro.c"
#include "libs/d_can.h"
#include "libs/dsPIC.c"
#include "libs/eeprom.c"

//Digital i/o pins
sbit REVERSE at LATE2_bit;  //Reverse input of the h-bridge
sbit FORWARD at LATE4_bit;  //Forward input of the h-bridge
sbit ENABLE at LATE1_bit;  //Enable pin of h-bridge ( h-bridge on if HIGH )
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
//Constants
#define QUARTER_TURN 5024
#define TURN 20096

#define ADDR_LAST_POSCNT 0x7FFDA0 //Last POSCNT record
#define ADDR_LAST_NUMBER_QUARTER_TURNS 0x7FFDB0 //Last record of quarter turns (from completely screw-on balance bar)
#define ADDR_LAST_MAPPED_POSITION 0x7FFDC0 //Last record of mapped position

#define CONTROL_ROUTINE_REFRESH 10 //Refresh in ms
#define BRAKE_TIME_LENGHT 50
#define PWM_SATURATION 4000



//Global variables declaration
unsigned int ebb_target_pos;
unsigned int ebb_current_pos;

int buzzer_state = OFF;
int sound = OFF;
int motor_target_position;  //quarter turns
int motor_current_position;  //quarter turns

char is_requested_calibration = 0;
char is_requested_movement = 0;
unsigned int calibration_on_off = OFF;
unsigned int error_flag = OFF;

int timer1_counter = 0;


//External program blocks
#include "modules/EBB_can_functions.h"
#include "modules/motor.c"
#include "modules/initialization.c"




//Timers routines

onTimer1Interrupt {
    timer1_counter++;
    //Check for overcurrent
    if (timer1_counter >= CONTROL_ROUTINE_REFRESH)
    {
        EBB_control();
        timer1_counter = 0;
    }
}

onTimer2Interrupt {
    CAN_routine();  //Call the can update routine
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