#define DISABLE_IT asm DISI #0X3FF

#define SET_CPU_IPL(ipl){ \
int DISI_save; \
\
DISI_save = DISICNT; \
DISABLE_IT;\
SRbits.IPL = ipl; \
asm {nop}; \
asm {nop}; \
DISICNT = DISI_save; } (void) 0;

#define SET_AND_SAVE_CPU_IPL(save_to, ipl){ \
save_to = SRbits.IPL; \
SET_CPU_IPL(ipl); } (void) 0;
#define RESTORE_CPU_IPL(saved_to) SET_CPU_IPL(saved_to)

#define INTERRUPT_PROTECT(x) { \
int save_sr; \
SET_AND_SAVE_CPU_IPL(save_sr, 7);\
x; \
RESTORE_CPU_IPL(save_sr); } (void) 0;