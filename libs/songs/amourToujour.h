//
// Created by Aaron Russo on 09/08/16.
//

#ifndef DP8_DISPLAY_CONTROLLER_AMOURTOUJOUR_H
#define DP8_DISPLAY_CONTROLLER_AMOURTOUJOUR_H

#include "../music.h"

const unsigned int AMOR_TOUJOUR_TEMPO = 120;
const unsigned char AMOR_TOUJOUR_SONG[] = {
        SOL5, QUARTO,
        PAUSA, DOPPIOQUARTO,
        SOL5, QUARTO,
        SOL5, OTTAVO,
        RE6_, OTTAVO,
        RE6, QUARTO,
        PAUSA, QUARTO,
        RE6, QUARTO,
        RE6, OTTAVO,
        RE6_, OTTAVO,
        DO6, QUARTO,
        PAUSA, QUARTO
};
const unsigned int AMOR_TOUJOUR_LENGTH = sizeof(AMOR_TOUJOUR_SONG);
#define AMOR_TOUJOUR    AMOR_TOUJOUR_SONG, AMOR_TOUJOUR_LENGTH

#endif //DP8_DISPLAY_CONTROLLER_AMOURTOUJOUR_H
