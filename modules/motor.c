
#include "motor.h"

//functions

void EBB_control()
{
       
                
    if (ebb_target_pos != ebb_current_pos && motor_state == OFF && ebb_target_pos >= 0 && ebb_target_pos <= 16)  //Do only if EBB is required to move and motor is off at the moment
    {
        //Set the defined encoder position target
        switch(ebb_target_pos){
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
        
        normal_motor_control();
       //ENTER NORMAL EBB OPERATION MODE
    }
    else if (ebb_target_pos == SET_CENTRAL_CALIBRATION_MODE && motor_state == OFF) 
    {
            
            central_calibration_control();  //ENTER SET ZERO MODE
    }
    else if (ebb_target_pos == SET_ZERO_POSITION_MODE && motor_state == OFF)
    {
            
            zero_position_control();
    }
    else if (motor_state == OFF)
    {
            ebb_target_pos = ebb_current_pos;  //If position requested is wrong reset ebb_target_pos
    }
}










void normal_motor_control()  //function turning on the motor in the correct direction
{
    motor_state = ON;
    FORWARD = OFF;
    REVERSE = OFF;
    ENABLE = ON;
    PDC1 = PWM_SATURATION;
    if(motor_target_position > motor_current_position){
        FORWARD = ON;
    }else if (motor_target_position < motor_current_position){
        REVERSE = ON;
    }

    while(!motor_reached_position_flag)
    {
    }
    ENABLE = OFF;
    PDC1 = 0;  
    motor_state = OFF;        
}










void central_calibration_control()  //function for setting the zero position of the balnce bar
{
        
}










void zero_position_control()  //Function for setting the zero position
{

}





void motor_brake()
{
    ENABLE = 1;
    PDC1 = PWM_SATURATION;
    FORWARD = 0;
    REVERSE = 0;
}