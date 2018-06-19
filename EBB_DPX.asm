
_Can_init:

;can.c,25 :: 		
;can.c,26 :: 		
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
;can.c,33 :: 		
	MOV	#4, W13
	MOV	#3, W12
	MOV	#4, W11
	MOV	#2, W10
	MOV	#251, W0
	PUSH	W0
	MOV	#2, W0
	PUSH	W0
	CALL	_CAN1Initialize
	SUB	#4, W15
;can.c,34 :: 		
	MOV	#255, W11
	MOV	#4, W10
	CALL	_CAN1SetOperationMode
;can.c,36 :: 		
	MOV	#255, W13
	MOV	#703, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetMask
;can.c,37 :: 		
	MOV	#255, W13
	MOV	#781, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetFilter
;can.c,38 :: 		
	MOV	#255, W13
	MOV	#1613, W11
	MOV	#0, W12
	MOV	#1, W10
	CALL	_CAN1SetFilter
;can.c,40 :: 		
	MOV	#255, W13
	MOV	#65535, W11
	MOV	#65535, W12
	MOV	#1, W10
	CALL	_CAN1SetMask
;can.c,41 :: 		
	MOV	#255, W13
	MOV	#1280, W11
	MOV	#0, W12
	MOV	#2, W10
	CALL	_CAN1SetFilter
;can.c,43 :: 		
	MOV	#255, W11
	CLR	W10
	CALL	_CAN1SetOperationMode
;can.c,45 :: 		
	CALL	_Can_initInterrupt
;can.c,46 :: 		
	MOV	#253, W10
	CALL	_Can_setWritePriority
;can.c,47 :: 		
L_end_Can_init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Can_init

_Can_read:
	LNK	#2

;can.c,49 :: 		
	PUSH	W13
	MOV	W13, [W14+0]
;can.c,50 :: 		
	CALL	_Can_B0hasBeenReceived
	CP0.B	W0
	BRA NZ	L__Can_read133
	GOTO	L_Can_read0
L__Can_read133:
;can.c,51 :: 		
	CALL	_Can_clearB0Flag
;can.c,52 :: 		
	ADD	W14, #0, W0
	MOV	W0, W13
	CALL	_CAN1Read
;can.c,53 :: 		
	GOTO	L_Can_read1
L_Can_read0:
;can.c,54 :: 		
	CALL	_Can_B1hasBeenReceived
	CP0.B	W0
	BRA NZ	L__Can_read134
	GOTO	L_Can_read2
L__Can_read134:
;can.c,55 :: 		
	CALL	_Can_clearB1Flag
;can.c,56 :: 		
	ADD	W14, #0, W0
	MOV	W0, W13
	CALL	_CAN1Read
;can.c,57 :: 		
L_Can_read2:
L_Can_read1:
;can.c,58 :: 		
L_end_Can_read:
	POP	W13
	ULNK
	RETURN
; end of _Can_read

_Can_writeByte:

;can.c,60 :: 		
;can.c,61 :: 		
	CALL	_Can_resetWritePacket
;can.c,62 :: 		
	PUSH.D	W10
	MOV.B	W12, W10
	CALL	_Can_addByteToWritePacket
	POP.D	W10
;can.c,63 :: 		
	CALL	_Can_write
;can.c,64 :: 		
L_end_Can_writeByte:
	RETURN
; end of _Can_writeByte

_Can_writeInt:

;can.c,66 :: 		
;can.c,67 :: 		
	CALL	_Can_resetWritePacket
;can.c,68 :: 		
	PUSH.D	W10
	MOV	W12, W10
	CALL	_Can_addIntToWritePacket
	POP.D	W10
;can.c,69 :: 		
	CALL	_Can_write
;can.c,70 :: 		
L_end_Can_writeInt:
	RETURN
; end of _Can_writeInt

_Can_addIntToWritePacket:

;can.c,72 :: 		
;can.c,73 :: 		
	PUSH	W10
	ASR	W10, #8, W0
	PUSH	W10
	MOV.B	W0, W10
	CALL	_Can_addByteToWritePacket
	POP	W10
;can.c,74 :: 		
	MOV	#255, W0
	AND	W10, W0, W0
	MOV.B	W0, W10
	CALL	_Can_addByteToWritePacket
;can.c,75 :: 		
L_end_Can_addIntToWritePacket:
	POP	W10
	RETURN
; end of _Can_addIntToWritePacket

_Can_addByteToWritePacket:

;can.c,77 :: 		
;can.c,78 :: 		
	MOV	#lo_addr(_can_dataOutBuffer), W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], W0
	MOV.B	W10, [W0]
;can.c,79 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], [W0]
;can.c,80 :: 		
L_end_Can_addByteToWritePacket:
	RETURN
; end of _Can_addByteToWritePacket

_Can_write:
	LNK	#2

;can.c,82 :: 		
;can.c,84 :: 		
	PUSH	W12
	PUSH	W13
L_Can_write3:
;can.c,85 :: 		
	CALL	_Can_getWriteFlags
	PUSH.D	W10
	MOV	_can_dataOutLength, W13
	MOV	#lo_addr(_can_dataOutBuffer), W12
	PUSH	W0
	CALL	_CAN1Write
	SUB	#2, W15
	POP.D	W10
;can.c,86 :: 		
	MOV	#1, W2
	ADD	W14, #0, W1
	ADD	W2, [W1], [W1]
;can.c,87 :: 		
	CP	W0, #0
	BRA Z	L__Can_write140
	GOTO	L__Can_write130
L__Can_write140:
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__Can_write141
	GOTO	L__Can_write129
L__Can_write141:
	GOTO	L_Can_write3
L__Can_write130:
L__Can_write129:
;can.c,88 :: 		
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA Z	L__Can_write142
	GOTO	L_Can_write8
L__Can_write142:
;can.c,89 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_can_err), W0
	ADD	W1, [W0], [W0]
;can.c,90 :: 		
L_Can_write8:
;can.c,91 :: 		
L_end_Can_write:
	POP	W13
	POP	W12
	ULNK
	RETURN
; end of _Can_write

_Can_setWritePriority:

;can.c,93 :: 		
;can.c,94 :: 		
	MOV	W10, _can_txPriority
;can.c,95 :: 		
L_end_Can_setWritePriority:
	RETURN
; end of _Can_setWritePriority

_Can_resetWritePacket:

;can.c,97 :: 		
;can.c,98 :: 		
	CLR	W0
	MOV	W0, _can_dataOutLength
L_Can_resetWritePacket9:
	MOV	_can_dataOutLength, W0
	CP	W0, #8
	BRA LTU	L__Can_resetWritePacket145
	GOTO	L_Can_resetWritePacket10
L__Can_resetWritePacket145:
;can.c,99 :: 		
	MOV	#lo_addr(_can_dataOutBuffer), W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;can.c,98 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], [W0]
;can.c,100 :: 		
	GOTO	L_Can_resetWritePacket9
L_Can_resetWritePacket10:
;can.c,101 :: 		
	CLR	W0
	MOV	W0, _can_dataOutLength
;can.c,102 :: 		
L_end_Can_resetWritePacket:
	RETURN
; end of _Can_resetWritePacket

_Can_getWriteFlags:

;can.c,104 :: 		
;can.c,105 :: 		
	MOV	#255, W1
	MOV	#lo_addr(_can_txPriority), W0
	AND	W1, [W0], W0
;can.c,106 :: 		
L_end_Can_getWriteFlags:
	RETURN
; end of _Can_getWriteFlags

_Can_B0hasBeenReceived:

;can.c,108 :: 		
;can.c,109 :: 		
	CLR.B	W0
	BTSC	C1INTFbits, #0
	INC.B	W0
	CP.B	W0, #1
	CLR.B	W0
	BRA NZ	L__Can_B0hasBeenReceived148
	INC.B	W0
L__Can_B0hasBeenReceived148:
;can.c,110 :: 		
L_end_Can_B0hasBeenReceived:
	RETURN
; end of _Can_B0hasBeenReceived

_Can_B1hasBeenReceived:

;can.c,112 :: 		
;can.c,113 :: 		
	CLR.B	W0
	BTSC	C1INTFbits, #1
	INC.B	W0
	CP.B	W0, #1
	CLR.B	W0
	BRA NZ	L__Can_B1hasBeenReceived150
	INC.B	W0
L__Can_B1hasBeenReceived150:
;can.c,114 :: 		
L_end_Can_B1hasBeenReceived:
	RETURN
; end of _Can_B1hasBeenReceived

_Can_clearB0Flag:

;can.c,116 :: 		
;can.c,117 :: 		
	BCLR	C1INTFbits, #0
;can.c,118 :: 		
L_end_Can_clearB0Flag:
	RETURN
; end of _Can_clearB0Flag

_Can_clearB1Flag:

;can.c,120 :: 		
;can.c,121 :: 		
	BCLR	C1INTFbits, #1
;can.c,122 :: 		
L_end_Can_clearB1Flag:
	RETURN
; end of _Can_clearB1Flag

_Can_clearInterrupt:

;can.c,124 :: 		
;can.c,125 :: 		
	BCLR	IFS1bits, #11
;can.c,126 :: 		
L_end_Can_clearInterrupt:
	RETURN
; end of _Can_clearInterrupt

_Can_initInterrupt:

;can.c,128 :: 		
;can.c,130 :: 		
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W0
	MOV.B	W0, W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	ZE	W1, W0
	LSR	W0, #5, W1
; save_sr start address is: 4 (W2)
	ZE	W1, W2
; DISI_save start address is: 6 (W3)
	MOV	DISICNT, W3
	DISI	#1023
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(SRbits), W0
	MOV.B	W1, [W0]
	NOP
	NOP
	MOV	W3, DISICNT
; DISI_save end address is: 6 (W3)
	BSET	IEC1bits, #11
; DISI_save start address is: 8 (W4)
	MOV	DISICNT, W4
	DISI	#1023
	MOV.B	W2, W3
; save_sr end address is: 4 (W2)
	MOV.B	#5, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#224, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(SRbits), W0
	MOV.B	W3, [W0]
	NOP
	NOP
	MOV	W4, DISICNT
; DISI_save end address is: 8 (W4)
;can.c,131 :: 		
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W0
	MOV.B	W0, W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	ZE	W1, W0
	LSR	W0, #5, W1
; save_sr start address is: 4 (W2)
	ZE	W1, W2
; DISI_save start address is: 6 (W3)
	MOV	DISICNT, W3
	DISI	#1023
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(SRbits), W0
	MOV.B	W1, [W0]
	NOP
	NOP
	MOV	W3, DISICNT
; DISI_save end address is: 6 (W3)
	BSET.B	C1INTEbits, #0
; DISI_save start address is: 8 (W4)
	MOV	DISICNT, W4
	DISI	#1023
	MOV.B	W2, W3
; save_sr end address is: 4 (W2)
	MOV.B	#5, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#224, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(SRbits), W0
	MOV.B	W3, [W0]
	NOP
	NOP
	MOV	W4, DISICNT
; DISI_save end address is: 8 (W4)
;can.c,132 :: 		
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W0
	MOV.B	W0, W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	ZE	W1, W0
	LSR	W0, #5, W1
; save_sr start address is: 4 (W2)
	ZE	W1, W2
; DISI_save start address is: 6 (W3)
	MOV	DISICNT, W3
	DISI	#1023
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(SRbits), W0
	MOV.B	W1, [W0]
	NOP
	NOP
	MOV	W3, DISICNT
; DISI_save end address is: 6 (W3)
	BSET.B	C1INTEbits, #1
; DISI_save start address is: 8 (W4)
	MOV	DISICNT, W4
	DISI	#1023
	MOV.B	W2, W3
; save_sr end address is: 4 (W2)
	MOV.B	#5, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#224, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(SRbits), W0
	MOV.B	W3, [W0]
	NOP
	NOP
	MOV	W4, DISICNT
; DISI_save end address is: 8 (W4)
;can.c,134 :: 		
L_end_Can_initInterrupt:
	RETURN
; end of _Can_initInterrupt

_setAllPinAsDigital:

;dspic.c,11 :: 		
;dspic.c,12 :: 		
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;dspic.c,13 :: 		
L_end_setAllPinAsDigital:
	RETURN
; end of _setAllPinAsDigital

_setInterruptPriority:

;dspic.c,15 :: 		
;dspic.c,16 :: 		
	GOTO	L_setInterruptPriority12
;dspic.c,17 :: 		
L_setInterruptPriority14:
;dspic.c,18 :: 		
	MOV.B	W11, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC0bits), W0
	MOV.B	W1, [W0]
;dspic.c,19 :: 		
	GOTO	L_setInterruptPriority13
;dspic.c,20 :: 		
L_setInterruptPriority15:
;dspic.c,21 :: 		
	MOV.B	W11, W1
	MOV	#lo_addr(IPC4bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC4bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC4bits), W0
	MOV.B	W1, [W0]
;dspic.c,22 :: 		
	GOTO	L_setInterruptPriority13
;dspic.c,23 :: 		
L_setInterruptPriority16:
;dspic.c,24 :: 		
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
;dspic.c,25 :: 		
	GOTO	L_setInterruptPriority13
;dspic.c,29 :: 		
L_setInterruptPriority17:
;dspic.c,30 :: 		
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
;dspic.c,31 :: 		
	GOTO	L_setInterruptPriority13
;dspic.c,32 :: 		
L_setInterruptPriority18:
;dspic.c,33 :: 		
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
;dspic.c,34 :: 		
	GOTO	L_setInterruptPriority13
;dspic.c,35 :: 		
L_setInterruptPriority19:
;dspic.c,36 :: 		
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
;dspic.c,37 :: 		
	GOTO	L_setInterruptPriority13
;dspic.c,38 :: 		
L_setInterruptPriority20:
;dspic.c,39 :: 		
	GOTO	L_setInterruptPriority13
;dspic.c,40 :: 		
L_setInterruptPriority12:
	CP.B	W10, #4
	BRA NZ	L__setInterruptPriority157
	GOTO	L_setInterruptPriority14
L__setInterruptPriority157:
	CP.B	W10, #5
	BRA NZ	L__setInterruptPriority158
	GOTO	L_setInterruptPriority15
L__setInterruptPriority158:
	CP.B	W10, #6
	BRA NZ	L__setInterruptPriority159
	GOTO	L_setInterruptPriority16
L__setInterruptPriority159:
	CP.B	W10, #1
	BRA NZ	L__setInterruptPriority160
	GOTO	L_setInterruptPriority17
L__setInterruptPriority160:
	CP.B	W10, #2
	BRA NZ	L__setInterruptPriority161
	GOTO	L_setInterruptPriority18
L__setInterruptPriority161:
	CP.B	W10, #3
	BRA NZ	L__setInterruptPriority162
	GOTO	L_setInterruptPriority19
L__setInterruptPriority162:
	GOTO	L_setInterruptPriority20
L_setInterruptPriority13:
;dspic.c,41 :: 		
L_end_setInterruptPriority:
	RETURN
; end of _setInterruptPriority

_setExternalInterrupt:

;dspic.c,43 :: 		
;dspic.c,44 :: 		
	PUSH	W11
	MOV.B	#4, W11
	CALL	_setInterruptPriority
	POP	W11
;dspic.c,45 :: 		
	GOTO	L_setExternalInterrupt21
;dspic.c,46 :: 		
L_setExternalInterrupt23:
;dspic.c,47 :: 		
	BTSS	W11, #0
	BCLR	INTCON2, #0
	BTSC	W11, #0
	BSET	INTCON2, #0
;dspic.c,48 :: 		
	BCLR	IFS0, #0
;dspic.c,49 :: 		
	BSET	IEC0, #0
;dspic.c,50 :: 		
	GOTO	L_setExternalInterrupt22
;dspic.c,51 :: 		
L_setExternalInterrupt24:
;dspic.c,52 :: 		
	BTSS	W11, #0
	BCLR	INTCON2, #1
	BTSC	W11, #0
	BSET	INTCON2, #1
;dspic.c,53 :: 		
	BCLR	IFS1, #0
;dspic.c,54 :: 		
	BSET	IEC1, #0
;dspic.c,55 :: 		
	GOTO	L_setExternalInterrupt22
;dspic.c,56 :: 		
L_setExternalInterrupt25:
;dspic.c,57 :: 		
	BTSS	W11, #0
	BCLR	INTCON2, #2
	BTSC	W11, #0
	BSET	INTCON2, #2
;dspic.c,58 :: 		
	BCLR	IFS1, #7
;dspic.c,59 :: 		
	BSET	IEC1, #7
;dspic.c,60 :: 		
	GOTO	L_setExternalInterrupt22
;dspic.c,65 :: 		
L_setExternalInterrupt26:
;dspic.c,66 :: 		
	GOTO	L_setExternalInterrupt22
;dspic.c,67 :: 		
L_setExternalInterrupt21:
	CP.B	W10, #4
	BRA NZ	L__setExternalInterrupt164
	GOTO	L_setExternalInterrupt23
L__setExternalInterrupt164:
	CP.B	W10, #5
	BRA NZ	L__setExternalInterrupt165
	GOTO	L_setExternalInterrupt24
L__setExternalInterrupt165:
	CP.B	W10, #6
	BRA NZ	L__setExternalInterrupt166
	GOTO	L_setExternalInterrupt25
L__setExternalInterrupt166:
	GOTO	L_setExternalInterrupt26
L_setExternalInterrupt22:
;dspic.c,68 :: 		
L_end_setExternalInterrupt:
	RETURN
; end of _setExternalInterrupt

_switchExternalInterruptEdge:

;dspic.c,70 :: 		
;dspic.c,71 :: 		
	GOTO	L_switchExternalInterruptEdge27
;dspic.c,72 :: 		
L_switchExternalInterruptEdge29:
;dspic.c,73 :: 		
	CLR.B	W0
	BTSC	INTCON2, #0
	INC.B	W0
	CP.B	W0, #1
	BRA Z	L__switchExternalInterruptEdge168
	GOTO	L_switchExternalInterruptEdge30
L__switchExternalInterruptEdge168:
;dspic.c,74 :: 		
	BCLR	INTCON2, #0
;dspic.c,75 :: 		
	GOTO	L_switchExternalInterruptEdge31
L_switchExternalInterruptEdge30:
;dspic.c,76 :: 		
	BSET	INTCON2, #0
;dspic.c,77 :: 		
L_switchExternalInterruptEdge31:
;dspic.c,78 :: 		
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,79 :: 		
L_switchExternalInterruptEdge32:
;dspic.c,80 :: 		
	CLR.B	W0
	BTSC	INTCON2, #1
	INC.B	W0
	CP.B	W0, #1
	BRA Z	L__switchExternalInterruptEdge169
	GOTO	L_switchExternalInterruptEdge33
L__switchExternalInterruptEdge169:
;dspic.c,81 :: 		
	BCLR	INTCON2, #1
;dspic.c,82 :: 		
	GOTO	L_switchExternalInterruptEdge34
L_switchExternalInterruptEdge33:
;dspic.c,83 :: 		
	BSET	INTCON2, #1
;dspic.c,84 :: 		
L_switchExternalInterruptEdge34:
;dspic.c,85 :: 		
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,86 :: 		
L_switchExternalInterruptEdge35:
;dspic.c,87 :: 		
	CLR.B	W0
	BTSC	INTCON2, #2
	INC.B	W0
	CP.B	W0, #1
	BRA Z	L__switchExternalInterruptEdge170
	GOTO	L_switchExternalInterruptEdge36
L__switchExternalInterruptEdge170:
;dspic.c,88 :: 		
	BCLR	INTCON2, #2
;dspic.c,89 :: 		
	GOTO	L_switchExternalInterruptEdge37
L_switchExternalInterruptEdge36:
;dspic.c,90 :: 		
	BSET	INTCON2, #2
;dspic.c,91 :: 		
L_switchExternalInterruptEdge37:
;dspic.c,92 :: 		
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,99 :: 		
L_switchExternalInterruptEdge38:
;dspic.c,100 :: 		
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,101 :: 		
L_switchExternalInterruptEdge27:
	CP.B	W10, #4
	BRA NZ	L__switchExternalInterruptEdge171
	GOTO	L_switchExternalInterruptEdge29
L__switchExternalInterruptEdge171:
	CP.B	W10, #5
	BRA NZ	L__switchExternalInterruptEdge172
	GOTO	L_switchExternalInterruptEdge32
L__switchExternalInterruptEdge172:
	CP.B	W10, #6
	BRA NZ	L__switchExternalInterruptEdge173
	GOTO	L_switchExternalInterruptEdge35
L__switchExternalInterruptEdge173:
	GOTO	L_switchExternalInterruptEdge38
L_switchExternalInterruptEdge28:
;dspic.c,102 :: 		
L_end_switchExternalInterruptEdge:
	RETURN
; end of _switchExternalInterruptEdge

_getExternalInterruptEdge:

;dspic.c,104 :: 		
;dspic.c,105 :: 		
	GOTO	L_getExternalInterruptEdge39
;dspic.c,106 :: 		
L_getExternalInterruptEdge41:
;dspic.c,107 :: 		
	CLR.B	W0
	BTSC	INTCON2, #0
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,108 :: 		
L_getExternalInterruptEdge42:
;dspic.c,109 :: 		
	CLR.B	W0
	BTSC	INTCON2, #1
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,110 :: 		
L_getExternalInterruptEdge43:
;dspic.c,111 :: 		
	CLR.B	W0
	BTSC	INTCON2, #2
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,114 :: 		
L_getExternalInterruptEdge44:
;dspic.c,115 :: 		
	CLR	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,116 :: 		
L_getExternalInterruptEdge39:
	CP.B	W10, #4
	BRA NZ	L__getExternalInterruptEdge175
	GOTO	L_getExternalInterruptEdge41
L__getExternalInterruptEdge175:
	CP.B	W10, #5
	BRA NZ	L__getExternalInterruptEdge176
	GOTO	L_getExternalInterruptEdge42
L__getExternalInterruptEdge176:
	CP.B	W10, #6
	BRA NZ	L__getExternalInterruptEdge177
	GOTO	L_getExternalInterruptEdge43
L__getExternalInterruptEdge177:
	GOTO	L_getExternalInterruptEdge44
;dspic.c,117 :: 		
L_end_getExternalInterruptEdge:
	RETURN
; end of _getExternalInterruptEdge

_clearExternalInterrupt:

;dspic.c,119 :: 		
;dspic.c,120 :: 		
	GOTO	L_clearExternalInterrupt45
;dspic.c,121 :: 		
L_clearExternalInterrupt47:
;dspic.c,122 :: 		
	BCLR	IFS0, #0
;dspic.c,123 :: 		
	GOTO	L_clearExternalInterrupt46
;dspic.c,124 :: 		
L_clearExternalInterrupt48:
;dspic.c,125 :: 		
	BCLR	IFS1, #0
;dspic.c,126 :: 		
	GOTO	L_clearExternalInterrupt46
;dspic.c,127 :: 		
L_clearExternalInterrupt49:
;dspic.c,128 :: 		
	BCLR	IFS1, #7
;dspic.c,129 :: 		
	GOTO	L_clearExternalInterrupt46
;dspic.c,132 :: 		
L_clearExternalInterrupt50:
;dspic.c,133 :: 		
	GOTO	L_clearExternalInterrupt46
;dspic.c,134 :: 		
L_clearExternalInterrupt45:
	CP.B	W10, #4
	BRA NZ	L__clearExternalInterrupt179
	GOTO	L_clearExternalInterrupt47
L__clearExternalInterrupt179:
	CP.B	W10, #5
	BRA NZ	L__clearExternalInterrupt180
	GOTO	L_clearExternalInterrupt48
L__clearExternalInterrupt180:
	CP.B	W10, #6
	BRA NZ	L__clearExternalInterrupt181
	GOTO	L_clearExternalInterrupt49
L__clearExternalInterrupt181:
	GOTO	L_clearExternalInterrupt50
L_clearExternalInterrupt46:
;dspic.c,135 :: 		
L_end_clearExternalInterrupt:
	RETURN
; end of _clearExternalInterrupt

_setTimer:

;dspic.c,137 :: 		
;dspic.c,139 :: 		
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W11
	PUSH	W12
	MOV.B	#4, W11
	CALL	_setInterruptPriority
	POP	W12
	POP	W11
;dspic.c,141 :: 		
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
;dspic.c,142 :: 		
	GOTO	L_setTimer51
;dspic.c,143 :: 		
L_setTimer53:
;dspic.c,144 :: 		
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
;dspic.c,145 :: 		
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR1
;dspic.c,146 :: 		
	BSET	IEC0bits, #3
;dspic.c,147 :: 		
	BSET	T1CONbits, #15
;dspic.c,148 :: 		
	GOTO	L_setTimer52
;dspic.c,149 :: 		
L_setTimer54:
;dspic.c,150 :: 		
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
;dspic.c,151 :: 		
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR2
;dspic.c,152 :: 		
	BSET	IEC0bits, #6
;dspic.c,153 :: 		
	BSET	T2CONbits, #15
;dspic.c,154 :: 		
	GOTO	L_setTimer52
;dspic.c,155 :: 		
L_setTimer55:
;dspic.c,156 :: 		
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
;dspic.c,157 :: 		
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR4
;dspic.c,158 :: 		
	BSET	IEC1bits, #5
;dspic.c,159 :: 		
	BSET	T4CONbits, #15
;dspic.c,160 :: 		
	GOTO	L_setTimer52
;dspic.c,161 :: 		
L_setTimer51:
; prescalerIndex start address is: 8 (W4)
	CP.B	W10, #1
	BRA NZ	L__setTimer183
	GOTO	L_setTimer53
L__setTimer183:
	CP.B	W10, #2
	BRA NZ	L__setTimer184
	GOTO	L_setTimer54
L__setTimer184:
	CP.B	W10, #3
	BRA NZ	L__setTimer185
	GOTO	L_setTimer55
L__setTimer185:
; prescalerIndex end address is: 8 (W4)
L_setTimer52:
;dspic.c,162 :: 		
L_end_setTimer:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _setTimer

_clearTimer:

;dspic.c,164 :: 		
;dspic.c,165 :: 		
	GOTO	L_clearTimer56
;dspic.c,166 :: 		
L_clearTimer58:
;dspic.c,167 :: 		
	BCLR	IFS0bits, #3
;dspic.c,168 :: 		
	GOTO	L_clearTimer57
;dspic.c,169 :: 		
L_clearTimer59:
;dspic.c,170 :: 		
	BCLR	IFS0bits, #6
;dspic.c,171 :: 		
	GOTO	L_clearTimer57
;dspic.c,172 :: 		
L_clearTimer60:
;dspic.c,173 :: 		
	BCLR	IFS1bits, #5
;dspic.c,174 :: 		
	GOTO	L_clearTimer57
;dspic.c,175 :: 		
L_clearTimer56:
	CP.B	W10, #1
	BRA NZ	L__clearTimer187
	GOTO	L_clearTimer58
L__clearTimer187:
	CP.B	W10, #2
	BRA NZ	L__clearTimer188
	GOTO	L_clearTimer59
L__clearTimer188:
	CP.B	W10, #3
	BRA NZ	L__clearTimer189
	GOTO	L_clearTimer60
L__clearTimer189:
L_clearTimer57:
;dspic.c,176 :: 		
L_end_clearTimer:
	RETURN
; end of _clearTimer

_turnOnTimer:

;dspic.c,178 :: 		
;dspic.c,179 :: 		
	GOTO	L_turnOnTimer61
;dspic.c,180 :: 		
L_turnOnTimer63:
;dspic.c,181 :: 		
	BSET	T1CONbits, #15
;dspic.c,182 :: 		
	GOTO	L_turnOnTimer62
;dspic.c,183 :: 		
L_turnOnTimer64:
;dspic.c,184 :: 		
	BSET	T2CONbits, #15
;dspic.c,185 :: 		
	GOTO	L_turnOnTimer62
;dspic.c,186 :: 		
L_turnOnTimer65:
;dspic.c,187 :: 		
	BSET	T4CONbits, #15
;dspic.c,188 :: 		
	GOTO	L_turnOnTimer62
;dspic.c,189 :: 		
L_turnOnTimer61:
	CP.B	W10, #1
	BRA NZ	L__turnOnTimer191
	GOTO	L_turnOnTimer63
L__turnOnTimer191:
	CP.B	W10, #2
	BRA NZ	L__turnOnTimer192
	GOTO	L_turnOnTimer64
L__turnOnTimer192:
	CP.B	W10, #3
	BRA NZ	L__turnOnTimer193
	GOTO	L_turnOnTimer65
L__turnOnTimer193:
L_turnOnTimer62:
;dspic.c,190 :: 		
L_end_turnOnTimer:
	RETURN
; end of _turnOnTimer

_turnOffTimer:

;dspic.c,192 :: 		
;dspic.c,193 :: 		
	GOTO	L_turnOffTimer66
;dspic.c,194 :: 		
L_turnOffTimer68:
;dspic.c,195 :: 		
	BCLR	T1CONbits, #15
;dspic.c,196 :: 		
	GOTO	L_turnOffTimer67
;dspic.c,197 :: 		
L_turnOffTimer69:
;dspic.c,198 :: 		
	BCLR	T2CONbits, #15
;dspic.c,199 :: 		
	GOTO	L_turnOffTimer67
;dspic.c,200 :: 		
L_turnOffTimer70:
;dspic.c,201 :: 		
	BCLR	T4CONbits, #15
;dspic.c,202 :: 		
	GOTO	L_turnOffTimer67
;dspic.c,203 :: 		
L_turnOffTimer66:
	CP.B	W10, #1
	BRA NZ	L__turnOffTimer195
	GOTO	L_turnOffTimer68
L__turnOffTimer195:
	CP.B	W10, #2
	BRA NZ	L__turnOffTimer196
	GOTO	L_turnOffTimer69
L__turnOffTimer196:
	CP.B	W10, #3
	BRA NZ	L__turnOffTimer197
	GOTO	L_turnOffTimer70
L__turnOffTimer197:
L_turnOffTimer67:
;dspic.c,204 :: 		
L_end_turnOffTimer:
	RETURN
; end of _turnOffTimer

_getTimerPeriod:
	LNK	#8

;dspic.c,206 :: 		
;dspic.c,207 :: 		
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
;dspic.c,208 :: 		
L_end_getTimerPeriod:
	ULNK
	RETURN
; end of _getTimerPeriod

_getTimerPrescaler:

;dspic.c,210 :: 		
;dspic.c,213 :: 		
	CALL	_getExactTimerPrescaler
; exactTimerPrescaler start address is: 8 (W4)
	MOV.D	W0, W4
;dspic.c,214 :: 		
; i start address is: 6 (W3)
	CLR	W3
; i end address is: 6 (W3)
L_getTimerPrescaler71:
; i start address is: 6 (W3)
; exactTimerPrescaler start address is: 8 (W4)
; exactTimerPrescaler end address is: 8 (W4)
	CP.B	W3, #8
	BRA LTU	L__getTimerPrescaler200
	GOTO	L_getTimerPrescaler72
L__getTimerPrescaler200:
; exactTimerPrescaler end address is: 8 (W4)
;dspic.c,215 :: 		
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
	BRA LTU	L__getTimerPrescaler201
	GOTO	L_getTimerPrescaler74
L__getTimerPrescaler201:
; exactTimerPrescaler end address is: 8 (W4)
;dspic.c,216 :: 		
	MOV.B	W3, W0
; i end address is: 6 (W3)
	GOTO	L_end_getTimerPrescaler
;dspic.c,217 :: 		
L_getTimerPrescaler74:
;dspic.c,214 :: 		
; i start address is: 0 (W0)
; exactTimerPrescaler start address is: 8 (W4)
; i start address is: 6 (W3)
	ADD.B	W3, #1, W0
; i end address is: 6 (W3)
;dspic.c,218 :: 		
; exactTimerPrescaler end address is: 8 (W4)
; i end address is: 0 (W0)
	MOV.B	W0, W3
	GOTO	L_getTimerPrescaler71
L_getTimerPrescaler72:
;dspic.c,219 :: 		
; i start address is: 6 (W3)
	ZE	W3, W0
; i end address is: 6 (W3)
	DEC	W0
;dspic.c,221 :: 		
;dspic.c,222 :: 		
L_end_getTimerPrescaler:
	RETURN
; end of _getTimerPrescaler

_getExactTimerPrescaler:

;dspic.c,224 :: 		
;dspic.c,225 :: 		
	MOV.D	W10, W0
	MOV	#9216, W2
	MOV	#18804, W3
	CALL	__Mul_FP
	MOV	#65280, W2
	MOV	#17919, W3
	CALL	__Div_FP
;dspic.c,226 :: 		
L_end_getExactTimerPrescaler:
	RETURN
; end of _getExactTimerPrescaler

_setupAnalogSampling:

;dspic.c,228 :: 		
;dspic.c,229 :: 		
	PUSH	W10
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	W1, [W0]
;dspic.c,230 :: 		
	MOV	ADCON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, ADCON1bits
;dspic.c,231 :: 		
	BCLR	ADCON1bits, #13
;dspic.c,232 :: 		
	BSET	ADCON2bits, #10
;dspic.c,233 :: 		
	BCLR	ADCON2bits, #1
;dspic.c,234 :: 		
	BCLR	ADCON2bits, #0
;dspic.c,235 :: 		
	BCLR	ADCON3bits, #7
;dspic.c,236 :: 		
	BCLR	ADCHSbits, #12
;dspic.c,237 :: 		
	BCLR	ADCHSbits, #4
;dspic.c,238 :: 		
	MOV	ADCHSbits, W1
	MOV	#61695, W0
	AND	W1, W0, W0
	MOV	WREG, ADCHSbits
;dspic.c,239 :: 		
	MOV	#lo_addr(ADCHSbits), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(ADCHSbits), W0
	MOV.B	W1, [W0]
;dspic.c,242 :: 		
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
;dspic.c,243 :: 		
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, ADCON3bits
;dspic.c,245 :: 		
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;dspic.c,246 :: 		
	CLR	ADCSSL
;dspic.c,248 :: 		
	CALL	_setAutomaticSampling
;dspic.c,249 :: 		
	CLR	W10
	CALL	_setAnalogVoltageReference
;dspic.c,250 :: 		
	CALL	_unsetAnalogInterrupt
;dspic.c,251 :: 		
	CALL	_startSampling
;dspic.c,252 :: 		
L_end_setupAnalogSampling:
	POP	W10
	RETURN
; end of _setupAnalogSampling

_turnOnAnalogModule:

;dspic.c,254 :: 		
;dspic.c,255 :: 		
	BSET	ADCON1bits, #15
;dspic.c,256 :: 		
L_end_turnOnAnalogModule:
	RETURN
; end of _turnOnAnalogModule

_turnOffAnalogModule:

;dspic.c,258 :: 		
;dspic.c,259 :: 		
	BCLR	ADCON1bits, #15
;dspic.c,260 :: 		
L_end_turnOffAnalogModule:
	RETURN
; end of _turnOffAnalogModule

_startSampling:

;dspic.c,262 :: 		
;dspic.c,263 :: 		
	BSET	ADCON1bits, #1
;dspic.c,264 :: 		
L_end_startSampling:
	RETURN
; end of _startSampling

_getAnalogValue:

;dspic.c,266 :: 		
;dspic.c,267 :: 		
	MOV	ADCBUF0, WREG
;dspic.c,268 :: 		
L_end_getAnalogValue:
	RETURN
; end of _getAnalogValue

_setAnalogPIN:

;dspic.c,270 :: 		
;dspic.c,271 :: 		
	ZE	W10, W1
	MOV	#1, W0
	SL	W0, W1, W2
	MOV	W2, W0
	COM	W0, W1
	MOV	#lo_addr(ADPCFG), W0
	AND	W1, [W0], [W0]
;dspic.c,272 :: 		
	MOV	#lo_addr(ADCSSL), W0
	IOR	W2, [W0], [W0]
;dspic.c,273 :: 		
L_end_setAnalogPIN:
	RETURN
; end of _setAnalogPIN

_unsetAnalogPIN:

;dspic.c,275 :: 		
;dspic.c,276 :: 		
	ZE	W10, W1
	MOV	#1, W0
	SL	W0, W1, W1
	MOV	#lo_addr(ADPCFG), W0
	IOR	W1, [W0], [W0]
;dspic.c,277 :: 		
	MOV	W1, W0
	COM	W0, W1
	MOV	#lo_addr(ADCSSL), W0
	AND	W1, [W0], [W0]
;dspic.c,278 :: 		
L_end_unsetAnalogPIN:
	RETURN
; end of _unsetAnalogPIN

_setAnalogInterrupt:

;dspic.c,280 :: 		
;dspic.c,281 :: 		
	CALL	_clearAnalogInterrupt
;dspic.c,282 :: 		
	BSET	IEC0bits, #11
;dspic.c,283 :: 		
L_end_setAnalogInterrupt:
	RETURN
; end of _setAnalogInterrupt

_unsetAnalogInterrupt:

;dspic.c,285 :: 		
;dspic.c,286 :: 		
	CALL	_clearAnalogInterrupt
;dspic.c,287 :: 		
	BCLR	IEC0bits, #11
;dspic.c,288 :: 		
L_end_unsetAnalogInterrupt:
	RETURN
; end of _unsetAnalogInterrupt

_clearAnalogInterrupt:

;dspic.c,290 :: 		
;dspic.c,291 :: 		
	BCLR	IFS0bits, #11
;dspic.c,292 :: 		
L_end_clearAnalogInterrupt:
	RETURN
; end of _clearAnalogInterrupt

_setAutomaticSampling:

;dspic.c,294 :: 		
;dspic.c,295 :: 		
	BSET	ADCON1bits, #2
;dspic.c,296 :: 		
L_end_setAutomaticSampling:
	RETURN
; end of _setAutomaticSampling

_unsetAutomaticSampling:

;dspic.c,298 :: 		
;dspic.c,299 :: 		
	BCLR	ADCON1bits, #2
;dspic.c,300 :: 		
L_end_unsetAutomaticSampling:
	RETURN
; end of _unsetAutomaticSampling

_setAnalogVoltageReference:

;dspic.c,302 :: 		
;dspic.c,303 :: 		
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
;dspic.c,304 :: 		
L_end_setAnalogVoltageReference:
	RETURN
; end of _setAnalogVoltageReference

_setAnalogDataOutputFormat:

;dspic.c,306 :: 		
;dspic.c,307 :: 		
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
;dspic.c,308 :: 		
L_end_setAnalogDataOutputFormat:
	RETURN
; end of _setAnalogDataOutputFormat

_getMinimumAnalogClockConversion:

;dspic.c,310 :: 		
;dspic.c,311 :: 		
	MOV	#9, W0
;dspic.c,312 :: 		
L_end_getMinimumAnalogClockConversion:
	RETURN
; end of _getMinimumAnalogClockConversion

_EEPROM_writeInt:

;eeprom.c,7 :: 		
;eeprom.c,11 :: 		
	PUSH	W12
	MOV	W11, W12
	CLR	W11
	CALL	_EEPROM_Write
;eeprom.c,12 :: 		
L_EEPROM_writeInt75:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EEPROM_writeInt76
	GOTO	L_EEPROM_writeInt75
L_EEPROM_writeInt76:
;eeprom.c,14 :: 		
L_end_EEPROM_writeInt:
	POP	W12
	RETURN
; end of _EEPROM_writeInt

_EEPROM_readInt:

;eeprom.c,16 :: 		
;eeprom.c,17 :: 		
	CLR	W11
	CALL	_EEPROM_Read
;eeprom.c,18 :: 		
L_end_EEPROM_readInt:
	RETURN
; end of _EEPROM_readInt

_EEPROM_writeArray:

;eeprom.c,20 :: 		
;eeprom.c,22 :: 		
; i start address is: 2 (W1)
	CLR	W1
; i end address is: 2 (W1)
L_EEPROM_writeArray77:
; i start address is: 2 (W1)
	CP	W1, #2
	BRA LTU	L__EEPROM_writeArray221
	GOTO	L_EEPROM_writeArray78
L__EEPROM_writeArray221:
;eeprom.c,23 :: 		
	SL	W1, #1, W0
	ADD	W11, W0, W0
	PUSH	W11
	MOV	[W0], W11
	CALL	_EEPROM_writeInt
	POP	W11
;eeprom.c,22 :: 		
	INC	W1
;eeprom.c,24 :: 		
; i end address is: 2 (W1)
	GOTO	L_EEPROM_writeArray77
L_EEPROM_writeArray78:
;eeprom.c,25 :: 		
L_end_EEPROM_writeArray:
	RETURN
; end of _EEPROM_writeArray

_EEPROM_readArray:
	LNK	#2

;eeprom.c,27 :: 		
;eeprom.c,29 :: 		
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_EEPROM_readArray80:
; i start address is: 4 (W2)
	CP	W2, #2
	BRA LTU	L__EEPROM_readArray223
	GOTO	L_EEPROM_readArray81
L__EEPROM_readArray223:
;eeprom.c,30 :: 		
	SL	W2, #1, W0
	ADD	W11, W0, W0
	MOV	W0, [W14+0]
	ADD	W10, W2, W0
	PUSH.D	W10
	MOV	W0, W10
	CLR	W11
	CALL	_EEPROM_Read
	POP.D	W10
	MOV	[W14+0], W1
	MOV	W0, [W1]
;eeprom.c,29 :: 		
	INC	W2
;eeprom.c,31 :: 		
; i end address is: 4 (W2)
	GOTO	L_EEPROM_readArray80
L_EEPROM_readArray81:
;eeprom.c,32 :: 		
L_end_EEPROM_readArray:
	ULNK
	RETURN
; end of _EEPROM_readArray

_CAN_routine:

;ebb_can_functions.c,6 :: 		
;ebb_can_functions.c,8 :: 		
	PUSH	W10
	PUSH	W11
	CALL	_Can_resetWritePacket
;ebb_can_functions.c,9 :: 		
	MOV	_ebb_current_pos, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,10 :: 		
	MOV	_calibration_on_off, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,11 :: 		
	MOV	_error_flag, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,12 :: 		
	MOV	#1638, W10
	MOV	#0, W11
	CALL	_Can_write
;ebb_can_functions.c,13 :: 		
L_end_CAN_routine:
	POP	W11
	POP	W10
	RETURN
; end of _CAN_routine

_counter_quarter_turn_match:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;motor.c,6 :: 		
;motor.c,7 :: 		
	GOTO	L_counter_quarter_turn_match83
;motor.c,8 :: 		
L_counter_quarter_turn_match85:
;motor.c,9 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_motor_current_position), W0
	SUBR	W1, [W0], [W0]
;motor.c,10 :: 		
	GOTO	L_counter_quarter_turn_match84
;motor.c,11 :: 		
L_counter_quarter_turn_match86:
;motor.c,12 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_motor_current_position), W0
	ADD	W1, [W0], [W0]
;motor.c,13 :: 		
	GOTO	L_counter_quarter_turn_match84
;motor.c,14 :: 		
L_counter_quarter_turn_match83:
	CLR.B	W0
	BTSC	UPDN_bit, BitPos(UPDN_bit+0)
	INC.B	W0
	CP.B	W0, #0
	BRA NZ	L__counter_quarter_turn_match226
	GOTO	L_counter_quarter_turn_match85
L__counter_quarter_turn_match226:
	CLR.B	W0
	BTSC	UPDN_bit, BitPos(UPDN_bit+0)
	INC.B	W0
	CP.B	W0, #1
	BRA NZ	L__counter_quarter_turn_match227
	GOTO	L_counter_quarter_turn_match86
L__counter_quarter_turn_match227:
L_counter_quarter_turn_match84:
;motor.c,15 :: 		
	MOV	_motor_current_position, W1
	MOV	#lo_addr(_motor_target_position), W0
	CP	W1, [W0]
	BRA Z	L__counter_quarter_turn_match228
	GOTO	L_counter_quarter_turn_match87
L__counter_quarter_turn_match228:
;motor.c,17 :: 		
	MOV	#lo_addr(_brake_counter), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,18 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;motor.c,19 :: 		
L_counter_quarter_turn_match87:
;motor.c,21 :: 		
	BCLR	IFS2bits, #8
;motor.c,22 :: 		
L_end_counter_quarter_turn_match:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _counter_quarter_turn_match

_EBB_control:

;motor.c,30 :: 		
;motor.c,32 :: 		
	GOTO	L_EBB_control88
;motor.c,34 :: 		
L_EBB_control90:
;motor.c,35 :: 		
	MOV	#lo_addr(_is_requested_movement), W0
	CP0.B	[W0]
	BRA NZ	L__EBB_control230
	GOTO	L_EBB_control91
L__EBB_control230:
;motor.c,37 :: 		
	GOTO	L_EBB_control92
;motor.c,39 :: 		
L_EBB_control94:
;motor.c,40 :: 		
	CLR	W0
	MOV	W0, _motor_target_position
;motor.c,41 :: 		
	GOTO	L_EBB_control93
;motor.c,42 :: 		
L_EBB_control95:
;motor.c,43 :: 		
	MOV	#2, W0
	MOV	W0, _motor_target_position
;motor.c,44 :: 		
	GOTO	L_EBB_control93
;motor.c,45 :: 		
L_EBB_control96:
;motor.c,46 :: 		
	MOV	#4, W0
	MOV	W0, _motor_target_position
;motor.c,47 :: 		
	GOTO	L_EBB_control93
;motor.c,48 :: 		
L_EBB_control97:
;motor.c,49 :: 		
	MOV	#6, W0
	MOV	W0, _motor_target_position
;motor.c,50 :: 		
	GOTO	L_EBB_control93
;motor.c,51 :: 		
L_EBB_control98:
;motor.c,52 :: 		
	MOV	#8, W0
	MOV	W0, _motor_target_position
;motor.c,53 :: 		
	GOTO	L_EBB_control93
;motor.c,54 :: 		
L_EBB_control99:
;motor.c,55 :: 		
	MOV	#10, W0
	MOV	W0, _motor_target_position
;motor.c,56 :: 		
	GOTO	L_EBB_control93
;motor.c,57 :: 		
L_EBB_control100:
;motor.c,58 :: 		
	MOV	#12, W0
	MOV	W0, _motor_target_position
;motor.c,59 :: 		
	GOTO	L_EBB_control93
;motor.c,60 :: 		
L_EBB_control101:
;motor.c,61 :: 		
	MOV	#14, W0
	MOV	W0, _motor_target_position
;motor.c,62 :: 		
	GOTO	L_EBB_control93
;motor.c,63 :: 		
L_EBB_control102:
;motor.c,64 :: 		
	MOV	#16, W0
	MOV	W0, _motor_target_position
;motor.c,65 :: 		
	GOTO	L_EBB_control93
;motor.c,66 :: 		
L_EBB_control103:
;motor.c,67 :: 		
	MOV	#18, W0
	MOV	W0, _motor_target_position
;motor.c,68 :: 		
	GOTO	L_EBB_control93
;motor.c,69 :: 		
L_EBB_control104:
;motor.c,70 :: 		
	MOV	#20, W0
	MOV	W0, _motor_target_position
;motor.c,71 :: 		
	GOTO	L_EBB_control93
;motor.c,72 :: 		
L_EBB_control105:
;motor.c,73 :: 		
	MOV	#22, W0
	MOV	W0, _motor_target_position
;motor.c,74 :: 		
	GOTO	L_EBB_control93
;motor.c,75 :: 		
L_EBB_control106:
;motor.c,76 :: 		
	MOV	#24, W0
	MOV	W0, _motor_target_position
;motor.c,77 :: 		
	GOTO	L_EBB_control93
;motor.c,78 :: 		
L_EBB_control107:
;motor.c,79 :: 		
	MOV	#26, W0
	MOV	W0, _motor_target_position
;motor.c,80 :: 		
	GOTO	L_EBB_control93
;motor.c,81 :: 		
L_EBB_control108:
;motor.c,82 :: 		
	MOV	#28, W0
	MOV	W0, _motor_target_position
;motor.c,83 :: 		
	GOTO	L_EBB_control93
;motor.c,84 :: 		
L_EBB_control109:
;motor.c,85 :: 		
	MOV	#30, W0
	MOV	W0, _motor_target_position
;motor.c,86 :: 		
	GOTO	L_EBB_control93
;motor.c,87 :: 		
L_EBB_control110:
;motor.c,88 :: 		
	MOV	#32, W0
	MOV	W0, _motor_target_position
;motor.c,89 :: 		
	GOTO	L_EBB_control93
;motor.c,90 :: 		
L_EBB_control92:
	MOV	_ebb_target_pos, W0
	CP	W0, #0
	BRA NZ	L__EBB_control231
	GOTO	L_EBB_control94
L__EBB_control231:
	MOV	_ebb_target_pos, W0
	CP	W0, #1
	BRA NZ	L__EBB_control232
	GOTO	L_EBB_control95
L__EBB_control232:
	MOV	_ebb_target_pos, W0
	CP	W0, #2
	BRA NZ	L__EBB_control233
	GOTO	L_EBB_control96
L__EBB_control233:
	MOV	_ebb_target_pos, W0
	CP	W0, #3
	BRA NZ	L__EBB_control234
	GOTO	L_EBB_control97
L__EBB_control234:
	MOV	_ebb_target_pos, W0
	CP	W0, #4
	BRA NZ	L__EBB_control235
	GOTO	L_EBB_control98
L__EBB_control235:
	MOV	_ebb_target_pos, W0
	CP	W0, #5
	BRA NZ	L__EBB_control236
	GOTO	L_EBB_control99
L__EBB_control236:
	MOV	_ebb_target_pos, W0
	CP	W0, #6
	BRA NZ	L__EBB_control237
	GOTO	L_EBB_control100
L__EBB_control237:
	MOV	_ebb_target_pos, W0
	CP	W0, #7
	BRA NZ	L__EBB_control238
	GOTO	L_EBB_control101
L__EBB_control238:
	MOV	_ebb_target_pos, W0
	CP	W0, #8
	BRA NZ	L__EBB_control239
	GOTO	L_EBB_control102
L__EBB_control239:
	MOV	_ebb_target_pos, W0
	CP	W0, #9
	BRA NZ	L__EBB_control240
	GOTO	L_EBB_control103
L__EBB_control240:
	MOV	_ebb_target_pos, W0
	CP	W0, #10
	BRA NZ	L__EBB_control241
	GOTO	L_EBB_control104
L__EBB_control241:
	MOV	_ebb_target_pos, W0
	CP	W0, #11
	BRA NZ	L__EBB_control242
	GOTO	L_EBB_control105
L__EBB_control242:
	MOV	_ebb_target_pos, W0
	CP	W0, #12
	BRA NZ	L__EBB_control243
	GOTO	L_EBB_control106
L__EBB_control243:
	MOV	_ebb_target_pos, W0
	CP	W0, #13
	BRA NZ	L__EBB_control244
	GOTO	L_EBB_control107
L__EBB_control244:
	MOV	_ebb_target_pos, W0
	CP	W0, #14
	BRA NZ	L__EBB_control245
	GOTO	L_EBB_control108
L__EBB_control245:
	MOV	_ebb_target_pos, W0
	CP	W0, #15
	BRA NZ	L__EBB_control246
	GOTO	L_EBB_control109
L__EBB_control246:
	MOV	_ebb_target_pos, W0
	CP	W0, #16
	BRA NZ	L__EBB_control247
	GOTO	L_EBB_control110
L__EBB_control247:
L_EBB_control93:
;motor.c,91 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;motor.c,92 :: 		
	GOTO	L_EBB_control111
L_EBB_control91:
	MOV	#lo_addr(_is_requested_calibration), W0
	CP0.B	[W0]
	BRA NZ	L__EBB_control248
	GOTO	L_EBB_control112
L__EBB_control248:
;motor.c,94 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;motor.c,95 :: 		
L_EBB_control112:
L_EBB_control111:
;motor.c,96 :: 		
	GOTO	L_EBB_control89
;motor.c,97 :: 		
L_EBB_control113:
;motor.c,98 :: 		
	MOV	_motor_target_position, W1
	MOV	#lo_addr(_motor_current_position), W0
	CP	W1, [W0]
	BRA GT	L__EBB_control249
	GOTO	L_EBB_control114
L__EBB_control249:
;motor.c,100 :: 		
	BSET	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,101 :: 		
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;motor.c,102 :: 		
	GOTO	L_EBB_control115
L_EBB_control114:
	MOV	_motor_target_position, W1
	MOV	#lo_addr(_motor_current_position), W0
	CP	W1, [W0]
	BRA LT	L__EBB_control250
	GOTO	L_EBB_control116
L__EBB_control250:
;motor.c,104 :: 		
	BSET	LATE2_bit, BitPos(LATE2_bit+0)
;motor.c,105 :: 		
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,106 :: 		
L_EBB_control116:
L_EBB_control115:
;motor.c,107 :: 		
	BSET	LATE1_bit, BitPos(LATE1_bit+0)
;motor.c,108 :: 		
	MOV	#4000, W0
	MOV	WREG, PDC1
;motor.c,109 :: 		
	MOV	#lo_addr(_is_requested_movement), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,111 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;motor.c,112 :: 		
	GOTO	L_EBB_control89
;motor.c,113 :: 		
L_EBB_control117:
;motor.c,114 :: 		
	MOV.B	#1, W1
	MOV	#lo_addr(_blink_counter), W0
	ADD.B	W1, [W0], [W0]
;motor.c,115 :: 		
	MOV	#lo_addr(_blink_counter), W0
	MOV.B	[W0], W0
	CP.B	W0, #20
	BRA GEU	L__EBB_control251
	GOTO	L_EBB_control118
L__EBB_control251:
;motor.c,117 :: 		
	BTG	LATD1_bit, BitPos(LATD1_bit+0)
;motor.c,118 :: 		
	MOV	#lo_addr(_blink_counter), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,119 :: 		
L_EBB_control118:
;motor.c,120 :: 		
	GOTO	L_EBB_control89
;motor.c,121 :: 		
L_EBB_control119:
;motor.c,122 :: 		
	MOV	#lo_addr(_brake_counter), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;motor.c,124 :: 		
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;motor.c,125 :: 		
	BSET	LATD3_bit, BitPos(LATD3_bit+0)
;motor.c,126 :: 		
	BSET	LATE1_bit, BitPos(LATE1_bit+0)
;motor.c,127 :: 		
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;motor.c,128 :: 		
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,130 :: 		
	MOV	#lo_addr(_brake_counter), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;motor.c,139 :: 		
L_EBB_control121:
;motor.c,140 :: 		
	GOTO	L_EBB_control89
;motor.c,144 :: 		
L_EBB_control88:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__EBB_control252
	GOTO	L_EBB_control90
L__EBB_control252:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__EBB_control253
	GOTO	L_EBB_control113
L__EBB_control253:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__EBB_control254
	GOTO	L_EBB_control117
L__EBB_control254:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__EBB_control255
	GOTO	L_EBB_control119
L__EBB_control255:
L_EBB_control89:
;motor.c,145 :: 		
L_end_EBB_control:
	RETURN
; end of _EBB_control

_EBB_Init:

;initialization.c,7 :: 		
;initialization.c,10 :: 		
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#65534, W0
	MOV	WREG, ADPCFG
;initialization.c,11 :: 		
	BCLR.B	TRISDbits, #1
;initialization.c,12 :: 		
	BCLR.B	TRISDbits, #3
;initialization.c,13 :: 		
	BCLR.B	TRISDbits, #2
;initialization.c,14 :: 		
	BCLR	TRISEbits, #0
;initialization.c,15 :: 		
	BCLR	TRISEbits, #4
;initialization.c,16 :: 		
	BCLR	TRISEbits, #2
;initialization.c,17 :: 		
	BCLR	TRISEbits, #1
;initialization.c,18 :: 		
	BSET	TRISBbits, #0
;initialization.c,19 :: 		
	BCLR	LATD2_bit, BitPos(LATD2_bit+0)
;initialization.c,20 :: 		
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,21 :: 		
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,23 :: 		
	MOV	#1282, W0
	MOV	WREG, QEICON
;initialization.c,24 :: 		
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	WREG, POSCNT
;initialization.c,25 :: 		
	MOV	#5024, W0
	MOV	WREG, MAXCNT
;initialization.c,26 :: 		
	MOV.B	#4, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC10bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC10bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC10bits), W0
	MOV.B	W1, [W0]
;initialization.c,27 :: 		
	BCLR	IFS2bits, #8
;initialization.c,28 :: 		
	BSET	IEC2bits, #8
;initialization.c,30 :: 		
	MOV	#257, W0
	MOV	WREG, PWMCON1
;initialization.c,31 :: 		
	MOV	#1999, W0
	MOV	WREG, PTPER
;initialization.c,32 :: 		
	CLR	PDC1
;initialization.c,33 :: 		
	CLR	PTMR
;initialization.c,34 :: 		
	MOV	#32768, W0
	MOV	WREG, PTCON
;initialization.c,35 :: 		
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;initialization.c,36 :: 		
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;initialization.c,37 :: 		
	BCLR	LATE1_bit, BitPos(LATE1_bit+0)
;initialization.c,40 :: 		
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _ebb_current_pos
;initialization.c,41 :: 		
	MOV	W0, _ebb_target_pos
;initialization.c,43 :: 		
	CALL	_Can_init
;initialization.c,45 :: 		
	CALL	_CAN_routine
;initialization.c,47 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;initialization.c,50 :: 		
	MOV	#4719, W11
	MOV	#14979, W12
	MOV.B	#1, W10
	CALL	_setTimer
;initialization.c,51 :: 		
	MOV	#52429, W11
	MOV	#15820, W12
	MOV.B	#2, W10
	CALL	_setTimer
;initialization.c,52 :: 		
	MOV	#39846, W11
	MOV	#15172, W12
	MOV.B	#3, W10
	CALL	_setTimer
;initialization.c,55 :: 		
	MOV	#1, W0
	MOV	W0, _buzzer_state
;initialization.c,56 :: 		
	BSET	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,57 :: 		
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,58 :: 		
	MOV	#82, W8
	MOV	#24943, W7
L_EBB_Init122:
	DEC	W7
	BRA NZ	L_EBB_Init122
	DEC	W8
	BRA NZ	L_EBB_Init122
	NOP
;initialization.c,59 :: 		
	CLR	W0
	MOV	W0, _buzzer_state
;initialization.c,60 :: 		
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,61 :: 		
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,64 :: 		
L_end_EBB_Init:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _EBB_Init

_timer1_interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;EBB_DPX.c,83 :: 		onTimer1Interrupt {
;EBB_DPX.c,84 :: 		timer1_counter++;
	MOV	#1, W1
	MOV	#lo_addr(_timer1_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,86 :: 		if (timer1_counter >= CONTROL_ROUTINE_REFRESH)
	MOV	_timer1_counter, W0
	CP	W0, #10
	BRA GE	L__timer1_interrupt258
	GOTO	L_timer1_interrupt124
L__timer1_interrupt258:
;EBB_DPX.c,88 :: 		EBB_control();
	CALL	_EBB_control
;EBB_DPX.c,89 :: 		timer1_counter = 0;
	CLR	W0
	MOV	W0, _timer1_counter
;EBB_DPX.c,90 :: 		}
L_timer1_interrupt124:
;EBB_DPX.c,91 :: 		}
L_end_timer1_interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _timer1_interrupt

_timer2_interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;EBB_DPX.c,93 :: 		onTimer2Interrupt {
;EBB_DPX.c,94 :: 		CAN_routine();  //Call the can update routine
	CALL	_CAN_routine
;EBB_DPX.c,95 :: 		clearTimer2();
	BCLR	IFS0bits, #6
;EBB_DPX.c,96 :: 		}
L_end_timer2_interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _timer2_interrupt

_timer4_interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;EBB_DPX.c,98 :: 		onTimer4Interrupt {
;EBB_DPX.c,99 :: 		if(buzzer_state == ON){  //Sound routine
	MOV	_buzzer_state, W0
	CP	W0, #1
	BRA Z	L__timer4_interrupt261
	GOTO	L_timer4_interrupt125
L__timer4_interrupt261:
;EBB_DPX.c,100 :: 		BUZZER = !BUZZER;
	BTG	LATD2_bit, BitPos(LATD2_bit+0)
;EBB_DPX.c,101 :: 		}
L_timer4_interrupt125:
;EBB_DPX.c,102 :: 		clearTimer4();
	BCLR	IFS1bits, #5
;EBB_DPX.c,103 :: 		}
L_end_timer4_interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _timer4_interrupt

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;EBB_DPX.c,106 :: 		void main() {
;EBB_DPX.c,107 :: 		EBB_Init();
	CALL	_EBB_Init
;EBB_DPX.c,108 :: 		while(1)
L_main126:
;EBB_DPX.c,110 :: 		}
	GOTO	L_main126
;EBB_DPX.c,112 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
