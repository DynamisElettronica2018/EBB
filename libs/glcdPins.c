
            sbit GLCD_D0 at RB8_bit;
            sbit GLCD_D1 at RB0_bit;
            sbit GLCD_D2 at RB1_bit;
            sbit GLCD_D3 at RB2_bit;
            sbit GLCD_D4 at RB3_bit;
            sbit GLCD_D5 at RB4_bit;
            sbit GLCD_D6 at RB5_bit;
            sbit GLCD_D7 at RG9_bit;

            sbit GLCD_D0_Direction at TRISB8_bit;
            sbit GLCD_D1_Direction at TRISB0_bit;
            sbit GLCD_D2_Direction at TRISB1_bit;
            sbit GLCD_D3_Direction at TRISB2_bit;
            sbit GLCD_D4_Direction at TRISB3_bit;
            sbit GLCD_D5_Direction at TRISB4_bit;
            sbit GLCD_D6_Direction at TRISB5_bit;
            sbit GLCD_D7_Direction at TRISG9_bit;

            sbit GLCD_CS1 at LATG8_bit;
            sbit GLCD_CS2 at LATG7_bit;
            sbit GLCD_RST at LATG6_bit;
            sbit GLCD_RW at LATC2_bit;
            sbit GLCD_RS at LATC1_bit;
            sbit GLCD_EN at LATG15_bit;

            sbit GLCD_CS1_Direction at TRISG8_bit;
            sbit GLCD_CS2_Direction at TRISG7_bit;
            sbit GLCD_RST_Direction at TRISG6_bit;
            sbit GLCD_RW_Direction at TRISC2_bit;
            sbit GLCD_RS_Direction at TRISC1_bit;
            sbit GLCD_EN_Direction at TRISG15_bit;