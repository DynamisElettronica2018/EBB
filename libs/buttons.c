//
// Created by Aaron Russo on 15/03/16.
//

#include "buttons.h"
#include "../modules/input-output/d_signalLed.h"

#define STRANGE_BUTTON_DELAY 1

onBottomInterrupt{
    Delay_ms(STRANGE_BUTTON_DELAY);
    if (BUTTON_BR_Pin == BUTTON_ACTIVE_STATE) {
        button_onBRDown();
    } else if (BUTTON_BL_Pin == BUTTON_ACTIVE_STATE) {
        button_onBLDown();
    }
    clearExternalInterrupt(BottomInterrupt);
}

onLeftInterrupt{
    Delay_ms(STRANGE_BUTTON_DELAY);
    if (BUTTON_L1_Pin == BUTTON_ACTIVE_STATE) {
        button_onL1Down();
    } else if (BUTTON_L2_Pin == BUTTON_ACTIVE_STATE) {
        button_onL2Down();
    } else if (BUTTON_L3_Pin == BUTTON_ACTIVE_STATE) {
        button_onL3Down();
    }
    clearExternalInterrupt(LeftInterrupt);
}

onRightInterrupt{
    Delay_ms(STRANGE_BUTTON_DELAY);
    if (BUTTON_R1_Pin == BUTTON_ACTIVE_STATE) {
        button_onR1Down();
    } else if (BUTTON_R2_Pin == BUTTON_ACTIVE_STATE) {
        button_onR2Down();
    } else if (BUTTON_R3_Pin == BUTTON_ACTIVE_STATE) {
        button_onR3Down();
    }
    clearExternalInterrupt(RightInterrupt);
}

onCenterInterrupt{
    Delay_ms(STRANGE_BUTTON_DELAY);
    button_onCDown();
    clearExternalInterrupt(CenterInterrupt);
}

void Buttons_init(void) {
    BUTTON_R1_Direction = INPUT;
    BUTTON_R2_Direction = INPUT;
    BUTTON_R3_Direction = INPUT;
    BUTTON_L1_Direction = INPUT;
    BUTTON_L2_Direction = INPUT;
    BUTTON_L3_Direction = INPUT;
    BUTTON_BL_Direction = INPUT;
    BUTTON_BR_Direction = INPUT;

    setExternalInterrupt(INT0_DEVICE, INTERRUPT_EDGE);
    setExternalInterrupt(INT1_DEVICE, INTERRUPT_EDGE);
    setExternalInterrupt(INT2_DEVICE, INTERRUPT_EDGE);
    setExternalInterrupt(INT4_DEVICE, INTERRUPT_EDGE);
}

unsigned int buttons_pressureProtraction = 0;
unsigned char buttons_pressureProtractionButton;
char buttons_pressureProtractionFlag = FALSE;

void Buttons_protractPress(unsigned char button, unsigned int milliseconds) {
    if (!Buttons_isPressureProtracted()) {
        buttons_pressureProtraction = milliseconds;
        buttons_pressureProtractionButton = button;
        buttons_pressureProtractionFlag = TRUE;
    }
}

void Buttons_tick(void) {
    if (buttons_pressureProtraction > 0) {
        buttons_pressureProtraction -= 1;
        if (buttons_pressureProtraction == 0) {
            switch (buttons_pressureProtractionButton) {
                case BUTTON_R1:
                    button_onR1Down();
                    break;
                case BUTTON_R2:
                    button_onR2Down();
                    break;
                case BUTTON_R3:
                    button_onR3Down();
                    break;
                case BUTTON_L1:
                    button_onL1Down();
                    break;
                case BUTTON_L2:
                    button_onL2Down();
                    break;
                case BUTTON_L3:
                    button_onL3Down();
                    break;
                case BUTTON_BL:
                    button_onBLDown();
                    break;
                case BUTTON_BR:
                    button_onBRDown();
                    break;
                default:
                    break;
            }
        } else {
            switch (buttons_pressureProtractionButton) {
                case BUTTON_R1:
                    if (BUTTON_R1_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                case BUTTON_R2:
                    if (BUTTON_R2_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                case BUTTON_R3:
                    if (BUTTON_R3_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                case BUTTON_L1:
                    if (BUTTON_L1_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                case BUTTON_L2:
                    if (BUTTON_L2_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                case BUTTON_L3:
                    if (BUTTON_L3_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                case BUTTON_BL:
                    if (BUTTON_BL_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                case BUTTON_BR:
                    if (BUTTON_BR_Pin != BUTTON_ACTIVE_STATE) {
                        buttons_pressureProtraction = 0;
                        Buttons_clearPressureProtraction();
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

char Buttons_isPressureProtracted(void) {
    return buttons_pressureProtractionFlag;
}

void Buttons_clearPressureProtraction(void) {
    buttons_pressureProtractionFlag = FALSE;
}