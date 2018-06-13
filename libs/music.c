//
// Created by Aaron Russo on 06/08/16.
//

#include "music.h"
#include "songs/amourToujour.h"

unsigned int music_tickCounter = 0;
unsigned int music_currentNote = 0;
unsigned int music_trentaduesimoTicks = 0;

char Music_hasToMakeSound(void) {
    return music_isPlayingNote && (music_tickCounter > music_trentaduesimoTicks);
}

void Music_tick(void) {
    if (music_tickCounter > 0) {
        music_tickCounter -= 1;
        if (music_tickCounter == 0) {
            Music_playSongNextNote();
        }
    }
}

void Music_setSongTime(unsigned int time) {
    music_songTime = time;
}

void Music_playSong(unsigned char song[], unsigned int songLength) {
    music_song = song;
    music_songLength = songLength;
    music_isPlaying = TRUE;
    music_currentNote = 0;
    Music_playSongNextNote();
}

void Music_playSongNextNote(void) {
    unsigned char note, duration;
    if (music_currentNote < music_songLength) {
        note = *(music_song + music_currentNote);
        duration = *(music_song + music_currentNote + 1);
        Music_playNote(note, duration);
        music_currentNote += 2;
    } else {
        music_isPlaying = FALSE;
    }
}

void Music_playNote(unsigned char note, unsigned char duration) {
    float timerPeriod;
    if (note == PAUSA) {
        music_isPlayingNote = FALSE;
        timerPeriod = 0.001;
    } else {
        music_isPlayingNote = TRUE;
        timerPeriod = 1.0 / Music_getNoteFrequency(note);
    }
    music_tickCounter = (unsigned int) (Music_getActualNoteDuration(duration) / timerPeriod);
    music_trentaduesimoTicks = (unsigned int) (Music_getActualNoteDuration(TRENTADUESIMO) / timerPeriod);
    setTimer(TIMER4_DEVICE, timerPeriod);
}

float Music_getActualNoteDuration(unsigned char duration) {
    return ((float) duration / (float) music_songTime) * 7.5; //60 / 8
}

float Music_getNoteFrequency(unsigned char note) {
    return MUSIC_NOTE_TABLE[note];
}
