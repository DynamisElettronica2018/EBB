


#include "initialization.h"


void EBB_Init()  //Initialize all hardware peripherals and software variables
{
        //Ports initialization
        ADPCFG = 0b1111111111111110;                    //analog input on AN0 (Current Sense)
        TRISDbits.TRISD1 = 0;                           //green led;
        TRISDbits.TRISD3 = 0;                           //blue led;
        TRISDbits.TRISD2 = 0;                           //buzzer;
        TRISEbits.TRISE0 = 0;                           //PWM output
        TRISEbits.TRISE4 = 0;                           //Forward output
        TRISEbits.TRISE2 = 0;                           //Reverse output
        TRISEbits.TRISE1 = 0;                           //Enable output
        TRISBbits.TRISB0 = 1;                           //set ADC pin as input (Current sense: Vcsns = Iout x 3.1)
        BUZZER = 0;                                                                                //Outputs at zero
        LED_B = 0;
        LED_G = 0;
        // Quadrature Encoder initialization
        QEICON = 0b0000010100000010;                    //Set Quadrature Encoder
        POSCNT = EEPROM_Read(LAST_POSCNT);              //Position Counter starter value (offset half register)
        MAXCNT = QUARTER_TURN;                          //Set maxcounter to a quarter turn for interrupts
        IPC10bits.QEIIP = 4;                            //Set interrupt priority on 4 for MAXCNT match
        IFS2bits.QEIIF = 0;                             //Reset Interrupt Flag
        IEC2bits.QEIIE = 1;                             //Enable MAXCNT match interrupt
        //PWM Init
        PWMCON1 = 0b0000000100000001;                   //independent mode, only PWM1L enabled
        PTPER = 1999;                                   //PWM frequency = 10 kHz
        PDC1 = 0;                                       //initial 0% of duty cycle - motor is off;        MAX_Value = 4000;
        PTMR = 0;                                       //to clear the PWM time base
        PTCON = 0b1000000000000000;                     //prescaler 1:1, postscaler 1:1, free running mode, PWM on
        FORWARD = 0;                                                                        //all h-bridge input at zero
        REVERSE = 0;
        ENABLE = 0;
        
        //Variables initialization
        ebb_current_pos = EEPROM_Read(ADDR_LAST_MAPPED_POSITION);
        ebb_target_pos = ebb_current_pos;

        CAN_Init();

        CAN_routine();

        //TImers initialization
        setTimer(TIMER1_DEVICE,0.001);                                        //Interrupt every 1mS
        setTimer(TIMER2_DEVICE,0.1);                    //Interrupt every 100mS
        setTimer(TIMER4_DEVICE,0.003);                                        //Interrupt every 200uS

        //Signal correct initialization
        buzzer_state = ON;
        LED_B = ON;
        LED_G = ON;
        delay_ms(800);
        buzzer_state = OFF;
        LED_B = OFF;
        LED_G = OFF;


}