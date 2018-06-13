//
// Created by Aaron Russo on 06/08/16.
//

#ifndef DP8_DISPLAY_CONTROLLER_INNOMAMELI_H
#define DP8_DISPLAY_CONTROLLER_INNOMAMELI_H

#include "../music.h"

const unsigned int INNO_MAMELI_TEMPO = 120;
const unsigned char INNO_MAMELI_SONG[] = {
        PAUSA, QUARTO,
        RE5, QUARTO,
        RE5, OTTAVO_MEZZO,
        MI5, SEDICESIMO,
        RE5, QUARTO,
        PAUSA, QUARTO,
        SI5, QUARTO,
        SI5, OTTAVO_MEZZO,
        DO6, SEDICESIMO,
        SI5, QUARTO,
        PAUSA, QUARTO,
        SI5, QUARTO,
        RE6, OTTAVO_MEZZO,
        DO6, SEDICESIMO,
        SI5, DOPPIOQUARTO,
        LA5, QUARTO,
        SI5, OTTAVO_MEZZO,
        LA5, SEDICESIMO,
        SOL5, QUARTO,
        PAUSA, QUARTO,

        RE5, QUARTO,
        RE5, OTTAVO_MEZZO,
        MI5, SEDICESIMO,
        RE5, QUARTO,
        PAUSA, QUARTO,
        SI5, QUARTO,
        SI5, OTTAVO_MEZZO,
        DO6, SEDICESIMO,
        SI5, QUARTO,
        PAUSA, QUARTO,
        SI5, QUARTO,
        RE6, OTTAVO_MEZZO,
        DO6, SEDICESIMO,
        SI5, DOPPIOQUARTO,
        LA5, QUARTO,
        SI5, OTTAVO_MEZZO,
        LA5, SEDICESIMO,
        SOL5, QUARTO,
        PAUSA, QUARTO,

        SI5, QUARTO,
        SI5, QUARTO,
        FA5_, DOPPIOQUARTO,
        SOL5, OTTAVO_MEZZO,
        LA5, SEDICESIMO,
        SOL5, OTTAVO_MEZZO,
        FA5_, SEDICESIMO,
        MI5, QUARTO,
        PAUSA, QUARTO,

        SOL5, QUARTO,
        FA5_, OTTAVO_MEZZO,
        SOL5, SEDICESIMO,
        LA5, QUARTO,
        PAUSA, QUARTO,
        SI4, QUARTO,
        SI5, DOPPIOQUARTO,
        DO6, QUARTO,
        RE5, QUARTO,
        RE5, OTTAVO_MEZZO,
        MI5, SEDICESIMO,
        RE5, QUARTO,
        PAUSA, QUARTO,
        SI5, QUARTO,
        SI5, OTTAVO_MEZZO,
        DO6, SEDICESIMO,
        SI5, DOPPIOQUARTO,
        SI5, QUARTO,
        RE6, OTTAVO_MEZZO,
        DO6, SEDICESIMO,
        SI5, QUARTO,
        SI5, OTTAVO,
        RE6, OTTAVO,
        LA5, OTTAVO,
        RE6, OTTAVO,
        SOL5, QUARTO
};
const unsigned int INNO_DI_MAMELI_LENGTH = sizeof(INNO_MAMELI_SONG);
#define INNO_DI_MAMELI  INNO_DI_MAMELI_SONG, INNO_DI_MAMELI_LENGTH

#endif //DP8_DISPLAY_CONTROLLER_INNOMAMELI_H
