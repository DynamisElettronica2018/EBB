//
// Created by Aaron Russo on 15/03/16.
//

#ifndef TEST_BUTTONS_BOARD_H
#define TEST_BUTTONS_BOARD_H

#include "dsPIC.h"

#define BUTTON_ACTIVE_STATE 0
#define INTERRUPT_EDGE  NEGATIVE_EDGE

#define BUTTON_R1   0
#define BUTTON_R2   1
#define BUTTON_R3   2
#define BUTTON_L1   3
#define BUTTON_L2   4
#define BUTTON_L3   5
#define BUTTON_BR   6
#define BUTTON_BL   7
#define BUTTON_C    8

#define BUTTON_R1_Pin   RB9_bit
#define BUTTON_R2_Pin   RB10_bit
#define BUTTON_R3_Pin   RG3_bit
#define BUTTON_L1_Pin   RB11_bit
#define BUTTON_L2_Pin   RB12_bit
#define BUTTON_L3_Pin   RG2_bit
#define BUTTON_BR_Pin   RF3_bit
#define BUTTON_BL_Pin   RF2_bit

#define BUTTON_R1_Direction TRISB9_bit
#define BUTTON_R2_Direction TRISB10_bit
#define BUTTON_R3_Direction TRISG3_bit
#define BUTTON_L1_Direction TRISB11_bit
#define BUTTON_L2_Direction TRISB12_bit
#define BUTTON_L3_Direction TRISG2_bit
#define BUTTON_BR_Direction TRISF3_bit
#define BUTTON_BL_Direction TRISF2_bit

#define onRightInterrupt    onExternal2Interrupt
#define onLeftInterrupt onExternal1Interrupt
#define onBottomInterrupt   onExternal0Interrupt
#define onCenterInterrupt   onExternal4Interrupt
#define RightInterrupt  INT2_DEVICE
#define LeftInterrupt   INT1_DEVICE
#define BottomInterrupt INT0_DEVICE
#define CenterInterrupt INT4_DEVICE

void button_onR1Down(void);

void button_onR2Down(void);

void button_onR3Down(void);

void button_onL1Down(void);

void button_onL2Down(void);

void button_onL3Down(void);

void button_onBRDown(void);

void button_onBLDown(void);

void button_onCDown(void);

void Buttons_init(void);

void Buttons_protractPress(unsigned char button, unsigned int milliseconds);

void Buttons_tick(void);

char Buttons_isPressureProtracted(void);

void Buttons_clearPressureProtraction(void);

#endif //TEST_BUTTONS_BOARD_H
