
#include "motor.h"

//Debug Functions

char dstr[100] = "";

void Debug_UART_Write(char* text){
     UART1_Write_Text(text);
}

//functions

void counter_quarter_turn_match() iv IVT_ADDR_QEIINTERRUPT ics ICS_AUTO {       //interrupt on match of MAXCNT or on match on 0
    switch(DIRECTION_REGISTER){
        case 0:  //negative direction
           motor_current_position--;
           break;
        case 1:  //positive direction
           motor_current_position++;
           break;
        default:
           break;
    }
    if (motor_current_position == motor_target_position)                        //Check for target reached
    {
        brake_counter = 0;                                                      //Reset the counter for braking period lenght
        REVERSE = OFF;                          //Shorts the motor terminals
        FORWARD = OFF;
        ebb_current_state = EBB_BRAKING;                                        //Set the current state
    }       
    IFS2bits.QEIIF = 0;                                                         //Reset Interrupt Flag
}



void EBB_control()
{
    switch(ebb_current_state)           //State machine
    {
        case EBB_OFF:                      //Off state
            if(is_requested_movement)       //Check if the EBB is requested to move in a different position
            {
                switch(ebb_target_pos)  //Obtain the requested position in quarter of turns (maybe to be improved!!)
                {
                    case 0:
                        motor_target_position = POSITION_0;
                        break;
                    case 1:
                        motor_target_position = POSITION_1;
                        break;
                    case 2:
                        motor_target_position = POSITION_2;
                        break;
                    case 3:
                        motor_target_position = POSITION_3;
                        break;
                    case 4:
                        motor_target_position = POSITION_4;
                        break;
                    case 5:
                        motor_target_position = POSITION_5;
                        break;
                    case 6:
                        motor_target_position = POSITION_6;
                        break;
                    case 7:
                        motor_target_position = POSITION_7;
                        break;
                    case 8:
                        motor_target_position = POSITION_8;
                        break;
                    case 9:
                        motor_target_position = POSITION_9;
                        break;
                    case 10:
                        motor_target_position = POSITION_10;
                        break;
                    case 11:
                        motor_target_position = POSITION_11;
                        break;
                    case 12:
                        motor_target_position = POSITION_12;
                        break;
                    case 13:
                        motor_target_position = POSITION_13;
                        break;
                    case 14:
                        motor_target_position = POSITION_14;
                        break;
                    case 15:
                        motor_target_position = POSITION_15;
                        break;
                    case 16:
                        motor_target_position = POSITION_16;
                        break;
                }
                ebb_current_state = EBB_START;          //Set the correct new ebb state (start moving)
                is_requested_movement = OFF;            //Switch off flag
            }else if(is_requested_calibration)          //Check if ebb is requested to enter calibration mode
            {
                ebb_current_state = EBB_CENTRAL_CALIBRATION;        //Set the correct new ebb state (calibration)
                is_requested_calibration = OFF;                     //Switch off flag
            }
            break;
        case EBB_START:                                             //Start a movement mode
            if(motor_target_position > motor_current_position)      //Check if is necessary to screw or unscrew the balance bar
            {
              FORWARD = ON;                                         //Unscrew
              REVERSE = OFF;
            }else if (motor_target_position < motor_current_position)
            {
                motor_target_position--;
                REVERSE = ON;                                       //Screw
                FORWARD = OFF;
            }
            ENABLE = ON;                                            //Turn on H-bridge
            PDC1 = PWM_SATURATION;                                  //Put the pwm at maximum (disabled pwm control)          

            ebb_current_state = EBB_MOVING;                         //Update State
            break;
        case EBB_MOVING:                               //EBB is trying to reach the requested position
            blink_counter++;
            if(blink_counter >= 20)
            {
                LED_G = ~LED_G;                        //Signal that the motor is turning with a blincking green led
                blink_counter = 0;
            }
            break;
        case EBB_BRAKING:                              //EBB has reached the position and is now bhraking the motor shorting it
            LED_G = OFF;
            LED_B = ON;                             //Turn on Blue led to signal motor Braking mode
            //ENABLE = ON;
            if(brake_counter >= BRAKE_TIME_LENGHT)          //check if the Braking period has passed
            {
                ebb_current_state = EBB_POSITION_REACHED;
            }
            break;
        case EBB_POSITION_REACHED:                                                  //The ebb has correctly reached th requested position
            LED_B = OFF;
            ENABLE = OFF;
            REVERSE = OFF;                                                          //Turn off the motor
            FORWARD = OFF;
            ebb_current_pos = ebb_target_pos;                                       //Update ebb cuurent position with the reached one (for robustness)
            motor_current_position = motor_target_position;                         //Update motor position with the reached one (for robustness)
            EEPROM_WRITE(ADDR_LAST_POSCNT, POSCNT);
            sprintf(dstr, "EEPROM: %u\r\n", POSCNT);
            Debug_UART_Write(dstr);
            while(WR_bit);                                                             //Update EEPROM data 
            EEPROM_WRITE(ADDR_LAST_NUMBER_QUARTER_TURNS, motor_current_position);
            while(WR_bit);
            EEPROM_WRITE(ADDR_LAST_MAPPED_POSITION, ebb_current_pos);
            while(WR_bit);
            ebb_current_state = OFF;                                               //Going back to OFF state
            break;
        case EBB_CENTRAL_CALIBRATION:
            ebb_current_pos = 8;
            ebb_target_pos = ebb_current_pos;
            motor_current_position = POSITION_8;
            motor_target_position = motor_current_position;
            EEPROM_WRITE(ADDR_LAST_POSCNT, POSCNT);
            while(WR_bit);                                                           //Update EEPROM data
            EEPROM_WRITE(ADDR_LAST_NUMBER_QUARTER_TURNS, motor_current_position);
            while(WR_bit);
            EEPROM_WRITE(ADDR_LAST_MAPPED_POSITION, ebb_current_pos);
            while(WR_bit);
            CAN_routine();
            calibration_on_off = OFF;
            ebb_current_state = OFF;                                               //Going back to OFF state
            break;
        case EBB_DRIVER_BRAKING:                            //Driver is braking during a requested movement
            buzzer_state = ON;                                     //Turn on buzzer for debugging
            if(brake_pressure_front < BRAKE_PRESSURE_TRIGGER && current_reading_motor < LSB_CURRENT_READING * MOTOR_CURRENT_TRIGGER)           //Checking brake pressures for the end of the braking action
            {
                buzzer_state = OFF;
                ebb_current_state = EBB_START;              //Return to start mode to complete the movement
            }
            break;
    }
}