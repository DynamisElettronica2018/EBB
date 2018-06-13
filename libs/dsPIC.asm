
_setAllPinAsDigital:

;dsPIC.c,11 :: 		void setAllPinAsDigital(void) {
;dsPIC.c,12 :: 		ADPCFG = 0xFFFF;
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;dsPIC.c,13 :: 		}
L_end_setAllPinAsDigital:
	RETURN
; end of _setAllPinAsDigital

_setInterruptPriority:

;dsPIC.c,15 :: 		void setInterruptPriority(unsigned char device, unsigned char priority) {
;dsPIC.c,16 :: 		switch (device) {
	GOTO	L_setInterruptPriority0
;dsPIC.c,17 :: 		case INT0_DEVICE:
L_setInterruptPriority2:
;dsPIC.c,18 :: 		INT0_PRIORITY = priority;
	MOV.B	W11, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC0bits), W0
	MOV.B	W1, [W0]
;dsPIC.c,19 :: 		break;
	GOTO	L_setInterruptPriority1
;dsPIC.c,20 :: 		case INT1_DEVICE:
L_setInterruptPriority3:
;dsPIC.c,21 :: 		INT1_PRIORITY = priority;
	MOV.B	W11, W1
	MOV	#lo_addr(IPC4bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC4bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC4bits), W0
	MOV.B	W1, [W0]
;dsPIC.c,22 :: 		break;
	GOTO	L_setInterruptPriority1
;dsPIC.c,23 :: 		case INT2_DEVICE:
L_setInterruptPriority4:
;dsPIC.c,24 :: 		INT2_PRIORITY = priority;
	ZE	W11, W0
	MOV	W0, W1
	MOV.B	#12, W0
	SE	W0, W0
	SL	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC5bits
;dsPIC.c,25 :: 		break;
	GOTO	L_setInterruptPriority1
;dsPIC.c,29 :: 		case TIMER1_DEVICE:
L_setInterruptPriority5:
;dsPIC.c,30 :: 		TIMER1_PRIORITY = priority;
	ZE	W11, W0
	MOV	W0, W1
	MOV.B	#12, W0
	SE	W0, W0
	SL	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;dsPIC.c,31 :: 		break;
	GOTO	L_setInterruptPriority1
;dsPIC.c,32 :: 		case TIMER2_DEVICE:
L_setInterruptPriority6:
;dsPIC.c,33 :: 		TIMER2_PRIORITY = priority;
	ZE	W11, W0
	MOV	W0, W1
	MOV.B	#8, W0
	SE	W0, W0
	SL	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC1bits
;dsPIC.c,34 :: 		break;
	GOTO	L_setInterruptPriority1
;dsPIC.c,35 :: 		case TIMER4_DEVICE:
L_setInterruptPriority7:
;dsPIC.c,36 :: 		TIMER4_PRIORITY = priority;
	MOV.B	W11, W3
	MOV.B	#4, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#112, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W3, [W0]
;dsPIC.c,37 :: 		break;
	GOTO	L_setInterruptPriority1
;dsPIC.c,38 :: 		default:
L_setInterruptPriority8:
;dsPIC.c,39 :: 		break;
	GOTO	L_setInterruptPriority1
;dsPIC.c,40 :: 		}
L_setInterruptPriority0:
	CP.B	W10, #4
	BRA NZ	L__setInterruptPriority65
	GOTO	L_setInterruptPriority2
L__setInterruptPriority65:
	CP.B	W10, #5
	BRA NZ	L__setInterruptPriority66
	GOTO	L_setInterruptPriority3
L__setInterruptPriority66:
	CP.B	W10, #6
	BRA NZ	L__setInterruptPriority67
	GOTO	L_setInterruptPriority4
L__setInterruptPriority67:
	CP.B	W10, #1
	BRA NZ	L__setInterruptPriority68
	GOTO	L_setInterruptPriority5
L__setInterruptPriority68:
	CP.B	W10, #2
	BRA NZ	L__setInterruptPriority69
	GOTO	L_setInterruptPriority6
L__setInterruptPriority69:
	CP.B	W10, #3
	BRA NZ	L__setInterruptPriority70
	GOTO	L_setInterruptPriority7
L__setInterruptPriority70:
	GOTO	L_setInterruptPriority8
L_setInterruptPriority1:
;dsPIC.c,41 :: 		}
L_end_setInterruptPriority:
	RETURN
; end of _setInterruptPriority

_setExternalInterrupt:

;dsPIC.c,43 :: 		void setExternalInterrupt(unsigned char device, char edge) {
;dsPIC.c,44 :: 		setInterruptPriority(device, MEDIUM_PRIORITY);
	PUSH	W11
	MOV.B	#4, W11
	CALL	_setInterruptPriority
	POP	W11
;dsPIC.c,45 :: 		switch (device) {
	GOTO	L_setExternalInterrupt9
;dsPIC.c,46 :: 		case INT0_DEVICE:
L_setExternalInterrupt11:
;dsPIC.c,47 :: 		INT0_TRIGGER_EDGE = edge;
	BTSS	W11, #0
	BCLR	INTCON2, #0
	BTSC	W11, #0
	BSET	INTCON2, #0
;dsPIC.c,48 :: 		INT0_OCCURRED = FALSE;
	BCLR	IFS0, #0
;dsPIC.c,49 :: 		INT0_ENABLE = TRUE;
	BSET	IEC0, #0
;dsPIC.c,50 :: 		break;
	GOTO	L_setExternalInterrupt10
;dsPIC.c,51 :: 		case INT1_DEVICE:
L_setExternalInterrupt12:
;dsPIC.c,52 :: 		INT1_TRIGGER_EDGE = edge;
	BTSS	W11, #0
	BCLR	INTCON2, #1
	BTSC	W11, #0
	BSET	INTCON2, #1
;dsPIC.c,53 :: 		INT1_OCCURRED = FALSE;
	BCLR	IFS1, #0
;dsPIC.c,54 :: 		INT1_ENABLE = TRUE;
	BSET	IEC1, #0
;dsPIC.c,55 :: 		break;
	GOTO	L_setExternalInterrupt10
;dsPIC.c,56 :: 		case INT2_DEVICE:
L_setExternalInterrupt13:
;dsPIC.c,57 :: 		INT2_TRIGGER_EDGE = edge;
	BTSS	W11, #0
	BCLR	INTCON2, #2
	BTSC	W11, #0
	BSET	INTCON2, #2
;dsPIC.c,58 :: 		INT2_OCCURRED = FALSE;
	BCLR	IFS1, #7
;dsPIC.c,59 :: 		INT2_ENABLE = TRUE;
	BSET	IEC1, #7
;dsPIC.c,60 :: 		break;
	GOTO	L_setExternalInterrupt10
;dsPIC.c,65 :: 		default:
L_setExternalInterrupt14:
;dsPIC.c,66 :: 		break;
	GOTO	L_setExternalInterrupt10
;dsPIC.c,67 :: 		}
L_setExternalInterrupt9:
	CP.B	W10, #4
	BRA NZ	L__setExternalInterrupt72
	GOTO	L_setExternalInterrupt11
L__setExternalInterrupt72:
	CP.B	W10, #5
	BRA NZ	L__setExternalInterrupt73
	GOTO	L_setExternalInterrupt12
L__setExternalInterrupt73:
	CP.B	W10, #6
	BRA NZ	L__setExternalInterrupt74
	GOTO	L_setExternalInterrupt13
L__setExternalInterrupt74:
	GOTO	L_setExternalInterrupt14
L_setExternalInterrupt10:
;dsPIC.c,68 :: 		}
L_end_setExternalInterrupt:
	RETURN
; end of _setExternalInterrupt

_switchExternalInterruptEdge:

;dsPIC.c,70 :: 		void switchExternalInterruptEdge(unsigned char device) {
;dsPIC.c,71 :: 		switch (device) {
	GOTO	L_switchExternalInterruptEdge15
;dsPIC.c,72 :: 		case INT0_DEVICE:
L_switchExternalInterruptEdge17:
;dsPIC.c,73 :: 		if (INT0_TRIGGER_EDGE == NEGATIVE_EDGE) {
	BTSS	INTCON2, #0
	GOTO	L_switchExternalInterruptEdge18
;dsPIC.c,74 :: 		INT0_TRIGGER_EDGE = POSITIVE_EDGE;
	BCLR	INTCON2, #0
;dsPIC.c,75 :: 		} else {
	GOTO	L_switchExternalInterruptEdge19
L_switchExternalInterruptEdge18:
;dsPIC.c,76 :: 		INT0_TRIGGER_EDGE = NEGATIVE_EDGE;
	BSET	INTCON2, #0
;dsPIC.c,77 :: 		}
L_switchExternalInterruptEdge19:
;dsPIC.c,78 :: 		break;
	GOTO	L_switchExternalInterruptEdge16
;dsPIC.c,79 :: 		case INT1_DEVICE:
L_switchExternalInterruptEdge20:
;dsPIC.c,80 :: 		if (INT1_TRIGGER_EDGE == NEGATIVE_EDGE) {
	BTSS	INTCON2, #1
	GOTO	L_switchExternalInterruptEdge21
;dsPIC.c,81 :: 		INT1_TRIGGER_EDGE = POSITIVE_EDGE;
	BCLR	INTCON2, #1
;dsPIC.c,82 :: 		} else {
	GOTO	L_switchExternalInterruptEdge22
L_switchExternalInterruptEdge21:
;dsPIC.c,83 :: 		INT1_TRIGGER_EDGE = NEGATIVE_EDGE;
	BSET	INTCON2, #1
;dsPIC.c,84 :: 		}
L_switchExternalInterruptEdge22:
;dsPIC.c,85 :: 		break;
	GOTO	L_switchExternalInterruptEdge16
;dsPIC.c,86 :: 		case INT2_DEVICE:
L_switchExternalInterruptEdge23:
;dsPIC.c,87 :: 		if (INT2_TRIGGER_EDGE == NEGATIVE_EDGE) {
	BTSS	INTCON2, #2
	GOTO	L_switchExternalInterruptEdge24
;dsPIC.c,88 :: 		INT2_TRIGGER_EDGE = POSITIVE_EDGE;
	BCLR	INTCON2, #2
;dsPIC.c,89 :: 		} else {
	GOTO	L_switchExternalInterruptEdge25
L_switchExternalInterruptEdge24:
;dsPIC.c,90 :: 		INT2_TRIGGER_EDGE = NEGATIVE_EDGE;
	BSET	INTCON2, #2
;dsPIC.c,91 :: 		}
L_switchExternalInterruptEdge25:
;dsPIC.c,92 :: 		break;
	GOTO	L_switchExternalInterruptEdge16
;dsPIC.c,99 :: 		default:
L_switchExternalInterruptEdge26:
;dsPIC.c,100 :: 		break;
	GOTO	L_switchExternalInterruptEdge16
;dsPIC.c,101 :: 		}
L_switchExternalInterruptEdge15:
	CP.B	W10, #4
	BRA NZ	L__switchExternalInterruptEdge76
	GOTO	L_switchExternalInterruptEdge17
L__switchExternalInterruptEdge76:
	CP.B	W10, #5
	BRA NZ	L__switchExternalInterruptEdge77
	GOTO	L_switchExternalInterruptEdge20
L__switchExternalInterruptEdge77:
	CP.B	W10, #6
	BRA NZ	L__switchExternalInterruptEdge78
	GOTO	L_switchExternalInterruptEdge23
L__switchExternalInterruptEdge78:
	GOTO	L_switchExternalInterruptEdge26
L_switchExternalInterruptEdge16:
;dsPIC.c,102 :: 		}
L_end_switchExternalInterruptEdge:
	RETURN
; end of _switchExternalInterruptEdge

_getExternalInterruptEdge:

;dsPIC.c,104 :: 		char getExternalInterruptEdge(unsigned char device) {
;dsPIC.c,105 :: 		switch (device) {
	GOTO	L_getExternalInterruptEdge27
;dsPIC.c,106 :: 		case INT0_DEVICE:
L_getExternalInterruptEdge29:
;dsPIC.c,107 :: 		return INT0_TRIGGER_EDGE;
	CLR.B	W0
	BTSC	INTCON2, #0
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dsPIC.c,108 :: 		case INT1_DEVICE:
L_getExternalInterruptEdge30:
;dsPIC.c,109 :: 		return INT1_TRIGGER_EDGE;
	CLR.B	W0
	BTSC	INTCON2, #1
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dsPIC.c,110 :: 		case INT2_DEVICE:
L_getExternalInterruptEdge31:
;dsPIC.c,111 :: 		return INT2_TRIGGER_EDGE;
	CLR.B	W0
	BTSC	INTCON2, #2
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dsPIC.c,114 :: 		default:
L_getExternalInterruptEdge32:
;dsPIC.c,115 :: 		return 0;
	CLR	W0
	GOTO	L_end_getExternalInterruptEdge
;dsPIC.c,116 :: 		}
L_getExternalInterruptEdge27:
	CP.B	W10, #4
	BRA NZ	L__getExternalInterruptEdge80
	GOTO	L_getExternalInterruptEdge29
L__getExternalInterruptEdge80:
	CP.B	W10, #5
	BRA NZ	L__getExternalInterruptEdge81
	GOTO	L_getExternalInterruptEdge30
L__getExternalInterruptEdge81:
	CP.B	W10, #6
	BRA NZ	L__getExternalInterruptEdge82
	GOTO	L_getExternalInterruptEdge31
L__getExternalInterruptEdge82:
	GOTO	L_getExternalInterruptEdge32
;dsPIC.c,117 :: 		}
L_end_getExternalInterruptEdge:
	RETURN
; end of _getExternalInterruptEdge

_clearExternalInterrupt:

;dsPIC.c,119 :: 		void clearExternalInterrupt(unsigned char device) {
;dsPIC.c,120 :: 		switch (device) {
	GOTO	L_clearExternalInterrupt33
;dsPIC.c,121 :: 		case INT0_DEVICE:
L_clearExternalInterrupt35:
;dsPIC.c,122 :: 		INT0_OCCURRED = FALSE;
	BCLR	IFS0, #0
;dsPIC.c,123 :: 		break;
	GOTO	L_clearExternalInterrupt34
;dsPIC.c,124 :: 		case INT1_DEVICE:
L_clearExternalInterrupt36:
;dsPIC.c,125 :: 		INT1_OCCURRED = FALSE;
	BCLR	IFS1, #0
;dsPIC.c,126 :: 		break;
	GOTO	L_clearExternalInterrupt34
;dsPIC.c,127 :: 		case INT2_DEVICE:
L_clearExternalInterrupt37:
;dsPIC.c,128 :: 		INT2_OCCURRED = FALSE;
	BCLR	IFS1, #7
;dsPIC.c,129 :: 		break;
	GOTO	L_clearExternalInterrupt34
;dsPIC.c,132 :: 		default:
L_clearExternalInterrupt38:
;dsPIC.c,133 :: 		break;
	GOTO	L_clearExternalInterrupt34
;dsPIC.c,134 :: 		}
L_clearExternalInterrupt33:
	CP.B	W10, #4
	BRA NZ	L__clearExternalInterrupt84
	GOTO	L_clearExternalInterrupt35
L__clearExternalInterrupt84:
	CP.B	W10, #5
	BRA NZ	L__clearExternalInterrupt85
	GOTO	L_clearExternalInterrupt36
L__clearExternalInterrupt85:
	CP.B	W10, #6
	BRA NZ	L__clearExternalInterrupt86
	GOTO	L_clearExternalInterrupt37
L__clearExternalInterrupt86:
	GOTO	L_clearExternalInterrupt38
L_clearExternalInterrupt34:
;dsPIC.c,135 :: 		}
L_end_clearExternalInterrupt:
	RETURN
; end of _clearExternalInterrupt

_setTimer:

;dsPIC.c,137 :: 		void setTimer(unsigned char device, double timePeriod) {
;dsPIC.c,139 :: 		setInterruptPriority(device, MEDIUM_PRIORITY);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W11
	PUSH	W12
	MOV.B	#4, W11
	CALL	_setInterruptPriority
	POP	W12
	POP	W11
;dsPIC.c,141 :: 		prescalerIndex = getTimerPrescaler(timePeriod);
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	W11, W10
	MOV	W12, W11
	CALL	_getTimerPrescaler
	POP	W10
	POP	W12
	POP	W11
; prescalerIndex start address is: 8 (W4)
	MOV.B	W0, W4
;dsPIC.c,142 :: 		switch (device) {
	GOTO	L_setTimer39
;dsPIC.c,143 :: 		case TIMER1_DEVICE:
L_setTimer41:
;dsPIC.c,144 :: 		TIMER1_PRESCALER = prescalerIndex;
	MOV.B	W4, W3
	MOV.B	#4, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(T1CONbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#48, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(T1CONbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(T1CONbits), W0
	MOV.B	W3, [W0]
;dsPIC.c,145 :: 		TIMER1_PERIOD = getTimerPeriod(timePeriod, prescalerIndex);
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR1
;dsPIC.c,146 :: 		TIMER1_ENABLE_INTERRUPT = TRUE;
	BSET	IEC0bits, #3
;dsPIC.c,147 :: 		TIMER1_ENABLE = TRUE;
	BSET	T1CONbits, #15
;dsPIC.c,148 :: 		break;
	GOTO	L_setTimer40
;dsPIC.c,149 :: 		case TIMER2_DEVICE:
L_setTimer42:
;dsPIC.c,150 :: 		TIMER2_PRESCALER = prescalerIndex;
; prescalerIndex start address is: 8 (W4)
	MOV.B	W4, W3
	MOV.B	#4, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(T2CONbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#48, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(T2CONbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(T2CONbits), W0
	MOV.B	W3, [W0]
;dsPIC.c,151 :: 		TIMER2_PERIOD = getTimerPeriod(timePeriod, prescalerIndex);
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR2
;dsPIC.c,152 :: 		TIMER2_ENABLE_INTERRUPT = TRUE;
	BSET	IEC0bits, #6
;dsPIC.c,153 :: 		TIMER2_ENABLE = TRUE;
	BSET	T2CONbits, #15
;dsPIC.c,154 :: 		break;
	GOTO	L_setTimer40
;dsPIC.c,155 :: 		case TIMER4_DEVICE:
L_setTimer43:
;dsPIC.c,156 :: 		TIMER4_PRESCALER = prescalerIndex;
; prescalerIndex start address is: 8 (W4)
	MOV.B	W4, W3
	MOV.B	#4, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(T4CONbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#48, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(T4CONbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(T4CONbits), W0
	MOV.B	W3, [W0]
;dsPIC.c,157 :: 		TIMER4_PERIOD = getTimerPeriod(timePeriod, prescalerIndex);
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR4
;dsPIC.c,158 :: 		TIMER4_ENABLE_INTERRUPT = TRUE;
	BSET	IEC1bits, #5
;dsPIC.c,159 :: 		TIMER4_ENABLE = TRUE;
	BSET	T4CONbits, #15
;dsPIC.c,160 :: 		break;
	GOTO	L_setTimer40
;dsPIC.c,161 :: 		}
L_setTimer39:
; prescalerIndex start address is: 8 (W4)
	CP.B	W10, #1
	BRA NZ	L__setTimer88
	GOTO	L_setTimer41
L__setTimer88:
	CP.B	W10, #2
	BRA NZ	L__setTimer89
	GOTO	L_setTimer42
L__setTimer89:
	CP.B	W10, #3
	BRA NZ	L__setTimer90
	GOTO	L_setTimer43
L__setTimer90:
; prescalerIndex end address is: 8 (W4)
L_setTimer40:
;dsPIC.c,162 :: 		}
L_end_setTimer:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _setTimer

_clearTimer:

;dsPIC.c,164 :: 		void clearTimer(unsigned char device) {
;dsPIC.c,165 :: 		switch (device) {
	GOTO	L_clearTimer44
;dsPIC.c,166 :: 		case TIMER1_DEVICE:
L_clearTimer46:
;dsPIC.c,167 :: 		TIMER1_OCCURRED = FALSE;
	BCLR	IFS0bits, #3
;dsPIC.c,168 :: 		break;
	GOTO	L_clearTimer45
;dsPIC.c,169 :: 		case TIMER2_DEVICE:
L_clearTimer47:
;dsPIC.c,170 :: 		TIMER2_OCCURRED = FALSE;
	BCLR	IFS0bits, #6
;dsPIC.c,171 :: 		break;
	GOTO	L_clearTimer45
;dsPIC.c,172 :: 		case TIMER4_DEVICE:
L_clearTimer48:
;dsPIC.c,173 :: 		TIMER4_OCCURRED = FALSE;
	BCLR	IFS1bits, #5
;dsPIC.c,174 :: 		break;
	GOTO	L_clearTimer45
;dsPIC.c,175 :: 		}
L_clearTimer44:
	CP.B	W10, #1
	BRA NZ	L__clearTimer92
	GOTO	L_clearTimer46
L__clearTimer92:
	CP.B	W10, #2
	BRA NZ	L__clearTimer93
	GOTO	L_clearTimer47
L__clearTimer93:
	CP.B	W10, #3
	BRA NZ	L__clearTimer94
	GOTO	L_clearTimer48
L__clearTimer94:
L_clearTimer45:
;dsPIC.c,176 :: 		}
L_end_clearTimer:
	RETURN
; end of _clearTimer

_turnOnTimer:

;dsPIC.c,178 :: 		void turnOnTimer(unsigned char device) {
;dsPIC.c,179 :: 		switch (device) {
	GOTO	L_turnOnTimer49
;dsPIC.c,180 :: 		case TIMER1_DEVICE:
L_turnOnTimer51:
;dsPIC.c,181 :: 		TIMER1_ENABLE = TRUE;
	BSET	T1CONbits, #15
;dsPIC.c,182 :: 		break;
	GOTO	L_turnOnTimer50
;dsPIC.c,183 :: 		case TIMER2_DEVICE:
L_turnOnTimer52:
;dsPIC.c,184 :: 		TIMER2_ENABLE = TRUE;
	BSET	T2CONbits, #15
;dsPIC.c,185 :: 		break;
	GOTO	L_turnOnTimer50
;dsPIC.c,186 :: 		case TIMER4_DEVICE:
L_turnOnTimer53:
;dsPIC.c,187 :: 		TIMER4_ENABLE = TRUE;
	BSET	T4CONbits, #15
;dsPIC.c,188 :: 		break;
	GOTO	L_turnOnTimer50
;dsPIC.c,189 :: 		}
L_turnOnTimer49:
	CP.B	W10, #1
	BRA NZ	L__turnOnTimer96
	GOTO	L_turnOnTimer51
L__turnOnTimer96:
	CP.B	W10, #2
	BRA NZ	L__turnOnTimer97
	GOTO	L_turnOnTimer52
L__turnOnTimer97:
	CP.B	W10, #3
	BRA NZ	L__turnOnTimer98
	GOTO	L_turnOnTimer53
L__turnOnTimer98:
L_turnOnTimer50:
;dsPIC.c,190 :: 		}
L_end_turnOnTimer:
	RETURN
; end of _turnOnTimer

_turnOffTimer:

;dsPIC.c,192 :: 		void turnOffTimer(unsigned char device) {
;dsPIC.c,193 :: 		switch (device) {
	GOTO	L_turnOffTimer54
;dsPIC.c,194 :: 		case TIMER1_DEVICE:
L_turnOffTimer56:
;dsPIC.c,195 :: 		TIMER1_ENABLE = FALSE;
	BCLR	T1CONbits, #15
;dsPIC.c,196 :: 		break;
	GOTO	L_turnOffTimer55
;dsPIC.c,197 :: 		case TIMER2_DEVICE:
L_turnOffTimer57:
;dsPIC.c,198 :: 		TIMER2_ENABLE = FALSE;
	BCLR	T2CONbits, #15
;dsPIC.c,199 :: 		break;
	GOTO	L_turnOffTimer55
;dsPIC.c,200 :: 		case TIMER4_DEVICE:
L_turnOffTimer58:
;dsPIC.c,201 :: 		TIMER4_ENABLE = FALSE;
	BCLR	T4CONbits, #15
;dsPIC.c,202 :: 		break;
	GOTO	L_turnOffTimer55
;dsPIC.c,203 :: 		}
L_turnOffTimer54:
	CP.B	W10, #1
	BRA NZ	L__turnOffTimer100
	GOTO	L_turnOffTimer56
L__turnOffTimer100:
	CP.B	W10, #2
	BRA NZ	L__turnOffTimer101
	GOTO	L_turnOffTimer57
L__turnOffTimer101:
	CP.B	W10, #3
	BRA NZ	L__turnOffTimer102
	GOTO	L_turnOffTimer58
L__turnOffTimer102:
L_turnOffTimer55:
;dsPIC.c,204 :: 		}
L_end_turnOffTimer:
	RETURN
; end of _turnOffTimer

_getTimerPeriod:
	LNK	#8

;dsPIC.c,206 :: 		unsigned int getTimerPeriod(double timePeriod, unsigned char prescalerIndex) {
;dsPIC.c,207 :: 		return (unsigned int) ((timePeriod * 1000000) / (INSTRUCTION_PERIOD * PRESCALER_VALUES[prescalerIndex]));
	PUSH	W12
	MOV.D	W10, W0
	MOV	#9216, W2
	MOV	#18804, W3
	CALL	__Mul_FP
	POP	W12
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	ZE	W12, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_PRESCALER_VALUES), W0
	ADD	W0, W1, W2
	MOV	[W2], W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#15872, W3
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Div_FP
	POP.D	W2
	CALL	__Float2Longint
;dsPIC.c,208 :: 		}
L_end_getTimerPeriod:
	ULNK
	RETURN
; end of _getTimerPeriod

_getTimerPrescaler:

;dsPIC.c,210 :: 		unsigned char getTimerPrescaler(double timePeriod) {
;dsPIC.c,213 :: 		exactTimerPrescaler = getExactTimerPrescaler(timePeriod);
	CALL	_getExactTimerPrescaler
; exactTimerPrescaler start address is: 8 (W4)
	MOV.D	W0, W4
;dsPIC.c,214 :: 		for (i = 0; i < sizeof(PRESCALER_VALUES); i += 1) {
; i start address is: 6 (W3)
	CLR	W3
; i end address is: 6 (W3)
L_getTimerPrescaler59:
; i start address is: 6 (W3)
; exactTimerPrescaler start address is: 8 (W4)
; exactTimerPrescaler end address is: 8 (W4)
	CP.B	W3, #8
	BRA LTU	L__getTimerPrescaler105
	GOTO	L_getTimerPrescaler60
L__getTimerPrescaler105:
; exactTimerPrescaler end address is: 8 (W4)
;dsPIC.c,215 :: 		if ((int) exactTimerPrescaler < PRESCALER_VALUES[i]) {
; exactTimerPrescaler start address is: 8 (W4)
	PUSH.D	W4
	PUSH	W3
	PUSH.D	W10
	MOV.D	W4, W0
	CALL	__Float2Longint
	POP.D	W10
	POP	W3
	POP.D	W4
	ZE	W3, W1
	SL	W1, #1, W2
	MOV	#lo_addr(_PRESCALER_VALUES), W1
	ADD	W1, W2, W2
	MOV	#___Lib_System_DefaultPage, W1
	MOV	W1, 52
	MOV	[W2], W1
	CP	W0, W1
	BRA LTU	L__getTimerPrescaler106
	GOTO	L_getTimerPrescaler62
L__getTimerPrescaler106:
; exactTimerPrescaler end address is: 8 (W4)
;dsPIC.c,216 :: 		return i;
	MOV.B	W3, W0
; i end address is: 6 (W3)
	GOTO	L_end_getTimerPrescaler
;dsPIC.c,217 :: 		}
L_getTimerPrescaler62:
;dsPIC.c,214 :: 		for (i = 0; i < sizeof(PRESCALER_VALUES); i += 1) {
; i start address is: 0 (W0)
; exactTimerPrescaler start address is: 8 (W4)
; i start address is: 6 (W3)
	ADD.B	W3, #1, W0
; i end address is: 6 (W3)
;dsPIC.c,218 :: 		}
; exactTimerPrescaler end address is: 8 (W4)
; i end address is: 0 (W0)
	MOV.B	W0, W3
	GOTO	L_getTimerPrescaler59
L_getTimerPrescaler60:
;dsPIC.c,219 :: 		i -= 1;
; i start address is: 6 (W3)
	ZE	W3, W0
; i end address is: 6 (W3)
	DEC	W0
;dsPIC.c,221 :: 		return i;
;dsPIC.c,222 :: 		}
L_end_getTimerPrescaler:
	RETURN
; end of _getTimerPrescaler

_getExactTimerPrescaler:

;dsPIC.c,224 :: 		double getExactTimerPrescaler(double timePeriod) {
;dsPIC.c,225 :: 		return (timePeriod * 1000000) / (INSTRUCTION_PERIOD * MAX_TIMER_PERIOD_VALUE);
	MOV.D	W10, W0
	MOV	#9216, W2
	MOV	#18804, W3
	CALL	__Mul_FP
	MOV	#65280, W2
	MOV	#17919, W3
	CALL	__Div_FP
;dsPIC.c,226 :: 		}
L_end_getExactTimerPrescaler:
	RETURN
; end of _getExactTimerPrescaler

_setupAnalogSampling:

;dsPIC.c,228 :: 		void setupAnalogSampling(void) {
;dsPIC.c,229 :: 		ANALOG_CONVERSION_TRIGGER_SOURCE = ACTS_AUTOMATIC;
	PUSH	W10
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	W1, [W0]
;dsPIC.c,230 :: 		ANALOG_DATA_OUTPUT_FORMAT = ADOF_UNSIGNED_INTEGER;
	MOV	ADCON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, ADCON1bits
;dsPIC.c,231 :: 		ANALOG_IDLE_ENABLE = FALSE;
	BCLR	ADCON1bits, #13
;dsPIC.c,232 :: 		ANALOG_CH0_SCAN_ENABLE = TRUE;
	BSET	ADCON2bits, #10
;dsPIC.c,233 :: 		ANALOG_BUFFER_SIZE = ABS_16BIT;
	BCLR	ADCON2bits, #1
;dsPIC.c,234 :: 		ANALOG_ENABLE_ALTERNATING_MULTIPLEXER = FALSE;
	BCLR	ADCON2bits, #0
;dsPIC.c,235 :: 		ANALOG_CLOCK_SOURCE = ACS_EXTERNAL;
	BCLR	ADCON3bits, #7
;dsPIC.c,236 :: 		ANALOG_CHANNEL_B_NEGATIVE_INPUT = ACNI_VREF;
	BCLR	ADCHSbits, #12
;dsPIC.c,237 :: 		ANALOG_CHANNEL_A_NEGATIVE_INPUT = ACNI_VREF;
	BCLR	ADCHSbits, #4
;dsPIC.c,238 :: 		ANALOG_CHANNEL_B_POSITIVE_INPUT = 0;
	MOV	ADCHSbits, W1
	MOV	#61695, W0
	AND	W1, W0, W0
	MOV	WREG, ADCHSbits
;dsPIC.c,239 :: 		ANALOG_CHANNEL_A_POSITIVE_INPUT = 0;
	MOV	#lo_addr(ADCHSbits), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(ADCHSbits), W0
	MOV.B	W1, [W0]
;dsPIC.c,242 :: 		ANALOG_CLOCK_CONVERSION = getMinimumAnalogClockConversion();
	CALL	_getMinimumAnalogClockConversion
	MOV.B	W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(ADCON3bits), W0
	MOV.B	W1, [W0]
;dsPIC.c,243 :: 		ANALOG_AUTOMATIC_SAMPLING_TADS_INTERVAL = 1;
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, ADCON3bits
;dsPIC.c,245 :: 		ANALOG_MODE_PORT = 0b1111111111111111; //All analog inputs are disabled
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;dsPIC.c,246 :: 		ANALOG_SCAN_PORT = 0; //Skipping pin scan
	CLR	ADCSSL
;dsPIC.c,248 :: 		setAutomaticSampling();
	CALL	_setAutomaticSampling
;dsPIC.c,249 :: 		setAnalogVoltageReference(AVR_AVDD_AVSS);
	CLR	W10
	CALL	_setAnalogVoltageReference
;dsPIC.c,250 :: 		unsetAnalogInterrupt();
	CALL	_unsetAnalogInterrupt
;dsPIC.c,251 :: 		startSampling();
	CALL	_startSampling
;dsPIC.c,252 :: 		}
L_end_setupAnalogSampling:
	POP	W10
	RETURN
; end of _setupAnalogSampling

_turnOnAnalogModule:

;dsPIC.c,254 :: 		void turnOnAnalogModule() {
;dsPIC.c,255 :: 		ANALOG_SAMPLING_ENABLE = TRUE;
	BSET	ADCON1bits, #15
;dsPIC.c,256 :: 		}
L_end_turnOnAnalogModule:
	RETURN
; end of _turnOnAnalogModule

_turnOffAnalogModule:

;dsPIC.c,258 :: 		void turnOffAnalogModule() {
;dsPIC.c,259 :: 		ANALOG_SAMPLING_ENABLE = FALSE;
	BCLR	ADCON1bits, #15
;dsPIC.c,260 :: 		}
L_end_turnOffAnalogModule:
	RETURN
; end of _turnOffAnalogModule

_startSampling:

;dsPIC.c,262 :: 		void startSampling(void) {
;dsPIC.c,263 :: 		ANALOG_SAMPLING_STATUS = TRUE;
	BSET	ADCON1bits, #1
;dsPIC.c,264 :: 		}
L_end_startSampling:
	RETURN
; end of _startSampling

_getAnalogValue:

;dsPIC.c,266 :: 		unsigned int getAnalogValue(void) {
;dsPIC.c,267 :: 		return ANALOG_BUFFER0;
	MOV	ADCBUF0, WREG
;dsPIC.c,268 :: 		}
L_end_getAnalogValue:
	RETURN
; end of _getAnalogValue

_setAnalogPIN:

;dsPIC.c,270 :: 		void setAnalogPIN(unsigned char pin) {
;dsPIC.c,271 :: 		ANALOG_MODE_PORT = ANALOG_MODE_PORT & ~(int) (TRUE << pin);
	ZE	W10, W1
	MOV	#1, W0
	SL	W0, W1, W2
	MOV	W2, W0
	COM	W0, W1
	MOV	#lo_addr(ADPCFG), W0
	AND	W1, [W0], [W0]
;dsPIC.c,272 :: 		ANALOG_SCAN_PORT = ANALOG_SCAN_PORT | (TRUE << pin);
	MOV	#lo_addr(ADCSSL), W0
	IOR	W2, [W0], [W0]
;dsPIC.c,273 :: 		}
L_end_setAnalogPIN:
	RETURN
; end of _setAnalogPIN

_unsetAnalogPIN:

;dsPIC.c,275 :: 		void unsetAnalogPIN(unsigned char pin) {
;dsPIC.c,276 :: 		ANALOG_MODE_PORT = ANALOG_MODE_PORT | (TRUE << pin);
	ZE	W10, W1
	MOV	#1, W0
	SL	W0, W1, W1
	MOV	#lo_addr(ADPCFG), W0
	IOR	W1, [W0], [W0]
;dsPIC.c,277 :: 		ANALOG_SCAN_PORT = ANALOG_SCAN_PORT & ~(int) (TRUE << pin);
	MOV	W1, W0
	COM	W0, W1
	MOV	#lo_addr(ADCSSL), W0
	AND	W1, [W0], [W0]
;dsPIC.c,278 :: 		}
L_end_unsetAnalogPIN:
	RETURN
; end of _unsetAnalogPIN

_setAnalogInterrupt:

;dsPIC.c,280 :: 		void setAnalogInterrupt(void) {
;dsPIC.c,281 :: 		clearAnalogInterrupt();
	CALL	_clearAnalogInterrupt
;dsPIC.c,282 :: 		ANALOG_INTERRUPT_ENABLE = TRUE;
	BSET	IEC0bits, #11
;dsPIC.c,283 :: 		}
L_end_setAnalogInterrupt:
	RETURN
; end of _setAnalogInterrupt

_unsetAnalogInterrupt:

;dsPIC.c,285 :: 		void unsetAnalogInterrupt(void) {
;dsPIC.c,286 :: 		clearAnalogInterrupt();
	CALL	_clearAnalogInterrupt
;dsPIC.c,287 :: 		ANALOG_INTERRUPT_ENABLE = FALSE;
	BCLR	IEC0bits, #11
;dsPIC.c,288 :: 		}
L_end_unsetAnalogInterrupt:
	RETURN
; end of _unsetAnalogInterrupt

_clearAnalogInterrupt:

;dsPIC.c,290 :: 		void clearAnalogInterrupt(void) {
;dsPIC.c,291 :: 		ANALOG_INTERRUPT_OCCURRED = FALSE;
	BCLR	IFS0bits, #11
;dsPIC.c,292 :: 		}
L_end_clearAnalogInterrupt:
	RETURN
; end of _clearAnalogInterrupt

_setAutomaticSampling:

;dsPIC.c,294 :: 		void setAutomaticSampling(void) {
;dsPIC.c,295 :: 		AUTOMATIC_SAMPLING = TRUE;
	BSET	ADCON1bits, #2
;dsPIC.c,296 :: 		}
L_end_setAutomaticSampling:
	RETURN
; end of _setAutomaticSampling

_unsetAutomaticSampling:

;dsPIC.c,298 :: 		void unsetAutomaticSampling(void) {
;dsPIC.c,299 :: 		AUTOMATIC_SAMPLING = FALSE;
	BCLR	ADCON1bits, #2
;dsPIC.c,300 :: 		}
L_end_unsetAutomaticSampling:
	RETURN
; end of _unsetAutomaticSampling

_setAnalogVoltageReference:

;dsPIC.c,302 :: 		void setAnalogVoltageReference(unsigned char mode) {
;dsPIC.c,303 :: 		ANALOG_VOLTAGE_REFERENCE = mode;
	ZE	W10, W0
	MOV	W0, W1
	MOV.B	#13, W0
	SE	W0, W0
	SL	W1, W0, W1
	MOV	#lo_addr(ADCON2bits), W0
	XOR	W1, [W0], W1
	MOV	#57344, W0
	AND	W1, W0, W1
	MOV	#lo_addr(ADCON2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, ADCON2bits
;dsPIC.c,304 :: 		}
L_end_setAnalogVoltageReference:
	RETURN
; end of _setAnalogVoltageReference

_setAnalogDataOutputFormat:

;dsPIC.c,306 :: 		void setAnalogDataOutputFormat(unsigned char adof) {
;dsPIC.c,307 :: 		ANALOG_DATA_OUTPUT_FORMAT = adof;
	ZE	W10, W0
	MOV	W0, W1
	MOV.B	#8, W0
	SE	W0, W0
	SL	W1, W0, W1
	MOV	#lo_addr(ADCON1bits), W0
	XOR	W1, [W0], W1
	MOV	#768, W0
	AND	W1, W0, W1
	MOV	#lo_addr(ADCON1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, ADCON1bits
;dsPIC.c,308 :: 		}
L_end_setAnalogDataOutputFormat:
	RETURN
; end of _setAnalogDataOutputFormat

_getMinimumAnalogClockConversion:

;dsPIC.c,310 :: 		int getMinimumAnalogClockConversion(void) {
;dsPIC.c,311 :: 		return (int) ((MINIMUM_TAD_PERIOD * OSC_FREQ_MHZ) / 500.0);
	MOV	#9, W0
;dsPIC.c,312 :: 		}
L_end_getMinimumAnalogClockConversion:
	RETURN
; end of _getMinimumAnalogClockConversion
