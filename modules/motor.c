
#include "motor.h"

//functions

void counter_quarter_turn_match() iv IVT_ADDR_QEIINTERRUPT ics ICS_AUTO {
    switch(DIRECTION_REGISTER){
        case 0:  //negative direction
        motor_current_position--;
        break;
        case 1:  //positive direction
        motor_current_position++;
        break;
    }
    if (motor_current_position == motor_target_position)
    {
        brake_counter = 0;
        ebb_current_state = EBB_BRAKING;
    }       

    IFS2bits.QEIIF = 0;  //Reset Interrupt Flag
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
                ebb_current_state = EBB_START;
            }else if(is_requested_calibration)
            {
                ebb_current_state = EBB_CENTRAL_CALIBRATION;
            }
        break;
        case EBB_START:
            if(motor_target_position > motor_current_position)
            {
              FORWARD = ON;
              REVERSE = OFF;
            }else if (motor_target_position < motor_current_position)
            {
                REVERSE = ON;
                FORWARD = OFF;
            }
            ENABLE = ON;
            PDC1 = PWM_SATURATION;
            is_requested_movement = OFF;

            ebb_current_state = EBB_MOVING;   //Update State
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
            if(brake_counter = 1)
            {
                LED_G = OFF;
                LED_B = ON;
                ENABLE = ON;
                REVERSE = OFF;
                FORWARD = OFF;
            }
            brake_counter++;
            if(brake_counter >= BRAKE_TIME_LENGHT)
            {
                LED_B = OFF;
                ENABLE = OFF;
                REVERSE = OFF;
                FORWARD = OFF;
                brake_counter = 0;
                ebb_current_state = OFF;
            }
        break;



    }
}








