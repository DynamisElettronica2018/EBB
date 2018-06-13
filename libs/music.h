//
// Created by Aaron Russo on 06/08/16.
//

#ifndef DP8_DISPLAY_CONTROLLER_MUSIC_H
#define DP8_DISPLAY_CONTROLLER_MUSIC_H

#include "basic.h"
#include "dsPIC.h"

char Music_hasToMakeSound(void);

void Music_tick(void);

void Music_setSongTime(unsigned int time);

void Music_playSong(unsigned char song[], unsigned int songLength);

void Music_playSongNextNote(void);

void Music_playNote(unsigned char note, unsigned char duration);

float Music_getActualNoteDuration(unsigned char duration);

float Music_getNoteFrequency(unsigned char note);

char music_isPlaying = FALSE;
char music_isPlayingNote = FALSE;
unsigned char *music_song;
unsigned int music_songTime, music_songLength;
const float MUSIC_NOTE_TABLE[] = {
        261.63, 277.18, 293.66, 311.13, 329.63, 349.23,
        369.99, 392.00, 415.30, 440.00, 466.16, 493.88, 523.25, 554.37,
        587.33, 622.25, 659.25, 698.46, 739.99, 783.99,
        830.61, 880.00, 932.33, 987.77, 1046.50, 1108.73,
        1174.66, 1244.51, 1318.51, 1396.91, 1479.98, 1567.98,
        1661.22, 1760.00, 1864.66, 1975.53};

#define TRENTADUESIMO 1
#define SEDICESIMO 2
#define SEDICESIMO_MEZZO 3
#define OTTAVO 4
#define OTTAVO_MEZZO 6
#define QUARTO 8
#define QUARTO_MEZZO 12
#define DOPPIOQUARTO 16
#define DOPPIOQUARTO_MEZZO 24

#define PAUSA 200
#define DO4 0
#define DO4_ 1
#define RE4 2
#define RE4_ 3
#define MI4 4
#define FA4 5
#define FA4_ 6
#define SOL4 7
#define SOL4_ 8
#define LA4 9
#define LA4_ 10
#define SI4 11
#define DO5 12
#define DO5_ 13
#define RE5 14
#define RE5_ 15
#define MI5 16
#define FA5 17
#define FA5_ 18
#define SOL5 19
#define SOL5_ 20
#define LA5 21
#define LA5_ 22
#define SI5 23
#define DO6 24
#define DO6_ 25
#define RE6 26
#define RE6_ 27
#define MI6 28
#define FA6 29
#define FA6_ 30
#define SOL6 31
#define SOL6_ 32
#define LA6 33
#define LA6_ 34
#define SI6 35

#endif //DP8_DISPLAY_CONTROLLER_MUSIC_H
