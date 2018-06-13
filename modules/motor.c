
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
        int target_reached_flag;
        int position_difference;
        int proportional_error;
        int integral_error;
        int pi_pwm;
        LED_B = ON;
        motor_state = ON;
        EEPROM_WRITE(ADDR_MOTOR_STATE, ON);
        while(WR_bit){};
        ebb_current_pos = EBB_STATE_ROTATING;
        //ebb_newpos_flag = ON;
        PDC1 = 0;   //Max 4000
        ENABLE = ON;  //Turn on theh_bridge
        target_reached_flag = OFF;
        position_difference = 0;
        proportional_error = 0;
        integral_error = 0;
        pi_pwm = 0;
        while (target_reached_flag == OFF)
        {
                position_difference = encoder_target_position - POSCNT;
                //PID (circa) controller
                if(ebb_overcurrent_flag == ON )
                {   
                    while(current_counter < OVERCURRENT_CUTOFF_TIME)
                        PDC1 = 0;
                    current_counter = 0;
                    ebb_overcurrent_flag = OFF;
                } 
                if(pid_counter > TIMING_PID){
                        if(position_difference > 0)  //If i need to screw the balance bar
                        {
                                proportional_error = K_PROPORTIONAL * position_difference;
                                if(proportional_error <= INTEGRAL_TRIGGER) 
                                {
                                integral_error = integral_error + (position_difference/K_INTEGRAL);
                                }else
                                integral_error = 0; //Calculate the integral error
                        }else{
                                proportional_error = K_PROPORTIONAL * (-1*position_difference);  //Calculate the proportional error
                                if(proportional_error <= INTEGRAL_TRIGGER) 
                                {
                                integral_error = integral_error + ((-1*position_difference)/K_INTEGRAL);
                                }else
                                integral_error = 0; //Calculate the integral error 
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
                        target_reached_flag = ON;
                }
                //ebb_newpos_flag = ON;
        }
       
        if(target_reached_flag = ON)
        {
                PDC1 = 0;
                ENABLE = OFF;
                ebb_current_pos = ebb_target_pos;
                EEPROM_WRITE(ADDR_MAPPED_POS, ebb_current_pos);
                while(WR_bit);
                EEPROM_WRITE(ADDR_REAL_POS, POSCNT);
                while(WR_bit);
                motor_state = OFF;
                EEPROM_WRITE(ADDR_MOTOR_STATE, OFF);
                while(WR_bit);
        }else
        {
                //ERROR 
        }
        LED_B = OFF;
        
}










void central_calibration_control()  //function for setting the zero position of the balnce bar
{
        int i;
        LED_G = ON;  //Turn on led to indicate calibration
        for(i=0; i <= 4; i++)  //Sound insication of calibration
        {
                BUZZER = ON;
                delay_ms(200);
                BUZZER = OFF;
                delay_ms(200);
        }
        motor_state = M_STATE_CALIBRATING;
        EEPROM_WRITE(ADDR_MOTOR_STATE, M_STATE_CALIBRATING);
        while(WR_bit);
        ebb_current_pos = EBB_STATE_CALIBRATION;
        //ebb_newpos_flag = ON;
        while(ebb_target_pos >= CALIBRATION_DOWN && ebb_target_pos <= CALIBRATION_UP)
        {
                switch(ebb_target_pos)
                {
                        case CALIBRATION_DOWN:  //Unscrew the balance bar
                        ENABLE = 1;
                        FORWARD = 0;
                        REVERSE = 1;
                        PDC1 = 3000;
                        break;
                        case CALIBRATION_UP:  //Screw the balance bar
                        ENABLE = 1;
                        FORWARD = 1;
                        REVERSE = 0;
                        PDC1 = 3000;
                        break;
                        default:  //Stop moving balance bar
                        ENABLE = 0;
                        FORWARD = 0;
                        REVERSE = 0;
                        PDC1 = 0;                        
                }
        }
        ENABLE = OFF;
        ebb_current_pos = EEPROM_Read(ADDR_MAPPED_POS);
        POSCNT = EEPROM_Read(ADDR_REAL_POS);
        EEPROM_WRITE(ADDR_MOTOR_STATE, OFF);
        while(WR_bit);
        motor_state = OFF;
        LED_G = OFF;
}










void zero_position_control()  //Function for setting the zero position
{
        int i;
        LED_G = ON;  //Turn on led to indicate calibration
        for(i=0; i <= 8; i++)  //Sound insication of calibration
        {
                BUZZER = ON;
                delay_ms(200);
                BUZZER = OFF;
                delay_ms(200);
        }
        motor_state = M_STATE_CALIBRATING;
        EEPROM_WRITE(ADDR_MOTOR_STATE, M_STATE_CALIBRATING);
        while(WR_bit);
        POSCNT = CENTRAL;  //Set the encoder position to central position
        ebb_current_pos = 4;
        EEPROM_WRITE(ADDR_MAPPED_POS, 4);
        while(WR_bit);
        EEPROM_WRITE(ADDR_REAL_POS, CENTRAL);
        while(WR_bit);
        //ebb_newpos_flag = ON;
        EEPROM_WRITE(ADDR_MOTOR_STATE, OFF);
        while(WR_bit);
        motor_state = OFF;
        LED_G = OFF;
}





void motor_brake()
{

}