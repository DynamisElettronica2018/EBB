
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
	MOV	#2047, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetMask
;can.c,37 :: 		
	MOV	#255, W13
	MOV	#1024, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetFilter
;can.c,38 :: 		
	MOV	#255, W13
	MOV	#1616, W11
	MOV	#0, W12
	MOV	#1, W10
	CALL	_CAN1SetFilter
;can.c,40 :: 		
	MOV	#255, W13
	MOV	#2032, W11
	MOV	#0, W12
	MOV	#1, W10
	CALL	_CAN1SetMask
;can.c,41 :: 		
	MOV	#255, W13
	MOV	#2032, W11
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
	BRA NZ	L__Can_read204
	GOTO	L_Can_read0
L__Can_read204:
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
	BRA NZ	L__Can_read205
	GOTO	L_Can_read2
L__Can_read205:
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
	BRA Z	L__Can_write211
	GOTO	L__Can_write189
L__Can_write211:
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__Can_write212
	GOTO	L__Can_write188
L__Can_write212:
	GOTO	L_Can_write3
L__Can_write189:
L__Can_write188:
;can.c,88 :: 		
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA Z	L__Can_write213
	GOTO	L_Can_write8
L__Can_write213:
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
	BRA LTU	L__Can_resetWritePacket216
	GOTO	L_Can_resetWritePacket10
L__Can_resetWritePacket216:
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
	BRA NZ	L__Can_B0hasBeenReceived219
	INC.B	W0
L__Can_B0hasBeenReceived219:
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
	BRA NZ	L__Can_B1hasBeenReceived221
	INC.B	W0
L__Can_B1hasBeenReceived221:
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
	BRA NZ	L__setInterruptPriority228
	GOTO	L_setInterruptPriority14
L__setInterruptPriority228:
	CP.B	W10, #5
	BRA NZ	L__setInterruptPriority229
	GOTO	L_setInterruptPriority15
L__setInterruptPriority229:
	CP.B	W10, #6
	BRA NZ	L__setInterruptPriority230
	GOTO	L_setInterruptPriority16
L__setInterruptPriority230:
	CP.B	W10, #1
	BRA NZ	L__setInterruptPriority231
	GOTO	L_setInterruptPriority17
L__setInterruptPriority231:
	CP.B	W10, #2
	BRA NZ	L__setInterruptPriority232
	GOTO	L_setInterruptPriority18
L__setInterruptPriority232:
	CP.B	W10, #3
	BRA NZ	L__setInterruptPriority233
	GOTO	L_setInterruptPriority19
L__setInterruptPriority233:
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
	BRA NZ	L__setExternalInterrupt235
	GOTO	L_setExternalInterrupt23
L__setExternalInterrupt235:
	CP.B	W10, #5
	BRA NZ	L__setExternalInterrupt236
	GOTO	L_setExternalInterrupt24
L__setExternalInterrupt236:
	CP.B	W10, #6
	BRA NZ	L__setExternalInterrupt237
	GOTO	L_setExternalInterrupt25
L__setExternalInterrupt237:
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
	BRA Z	L__switchExternalInterruptEdge239
	GOTO	L_switchExternalInterruptEdge30
L__switchExternalInterruptEdge239:
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
	BRA Z	L__switchExternalInterruptEdge240
	GOTO	L_switchExternalInterruptEdge33
L__switchExternalInterruptEdge240:
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
	BRA Z	L__switchExternalInterruptEdge241
	GOTO	L_switchExternalInterruptEdge36
L__switchExternalInterruptEdge241:
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
	BRA NZ	L__switchExternalInterruptEdge242
	GOTO	L_switchExternalInterruptEdge29
L__switchExternalInterruptEdge242:
	CP.B	W10, #5
	BRA NZ	L__switchExternalInterruptEdge243
	GOTO	L_switchExternalInterruptEdge32
L__switchExternalInterruptEdge243:
	CP.B	W10, #6
	BRA NZ	L__switchExternalInterruptEdge244
	GOTO	L_switchExternalInterruptEdge35
L__switchExternalInterruptEdge244:
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
	BRA NZ	L__getExternalInterruptEdge246
	GOTO	L_getExternalInterruptEdge41
L__getExternalInterruptEdge246:
	CP.B	W10, #5
	BRA NZ	L__getExternalInterruptEdge247
	GOTO	L_getExternalInterruptEdge42
L__getExternalInterruptEdge247:
	CP.B	W10, #6
	BRA NZ	L__getExternalInterruptEdge248
	GOTO	L_getExternalInterruptEdge43
L__getExternalInterruptEdge248:
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
	BRA NZ	L__clearExternalInterrupt250
	GOTO	L_clearExternalInterrupt47
L__clearExternalInterrupt250:
	CP.B	W10, #5
	BRA NZ	L__clearExternalInterrupt251
	GOTO	L_clearExternalInterrupt48
L__clearExternalInterrupt251:
	CP.B	W10, #6
	BRA NZ	L__clearExternalInterrupt252
	GOTO	L_clearExternalInterrupt49
L__clearExternalInterrupt252:
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
	BRA NZ	L__setTimer254
	GOTO	L_setTimer53
L__setTimer254:
	CP.B	W10, #2
	BRA NZ	L__setTimer255
	GOTO	L_setTimer54
L__setTimer255:
	CP.B	W10, #3
	BRA NZ	L__setTimer256
	GOTO	L_setTimer55
L__setTimer256:
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
	BRA NZ	L__clearTimer258
	GOTO	L_clearTimer58
L__clearTimer258:
	CP.B	W10, #2
	BRA NZ	L__clearTimer259
	GOTO	L_clearTimer59
L__clearTimer259:
	CP.B	W10, #3
	BRA NZ	L__clearTimer260
	GOTO	L_clearTimer60
L__clearTimer260:
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
	BRA NZ	L__turnOnTimer262
	GOTO	L_turnOnTimer63
L__turnOnTimer262:
	CP.B	W10, #2
	BRA NZ	L__turnOnTimer263
	GOTO	L_turnOnTimer64
L__turnOnTimer263:
	CP.B	W10, #3
	BRA NZ	L__turnOnTimer264
	GOTO	L_turnOnTimer65
L__turnOnTimer264:
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
	BRA NZ	L__turnOffTimer266
	GOTO	L_turnOffTimer68
L__turnOffTimer266:
	CP.B	W10, #2
	BRA NZ	L__turnOffTimer267
	GOTO	L_turnOffTimer69
L__turnOffTimer267:
	CP.B	W10, #3
	BRA NZ	L__turnOffTimer268
	GOTO	L_turnOffTimer70
L__turnOffTimer268:
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
	BRA LTU	L__getTimerPrescaler271
	GOTO	L_getTimerPrescaler72
L__getTimerPrescaler271:
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
	BRA LTU	L__getTimerPrescaler272
	GOTO	L_getTimerPrescaler74
L__getTimerPrescaler272:
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
	BRA LTU	L__EEPROM_writeArray292
	GOTO	L_EEPROM_writeArray78
L__EEPROM_writeArray292:
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
	BRA LTU	L__EEPROM_readArray294
	GOTO	L_EEPROM_readArray81
L__EEPROM_readArray294:
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

;ebb_can_functions.c,4 :: 		
;ebb_can_functions.c,6 :: 		
	PUSH	W10
	PUSH	W11
	CALL	_Can_resetWritePacket
;ebb_can_functions.c,7 :: 		
	MOV	_ebb_current_pos, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,8 :: 		
	MOV	_calibration_on_off, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,9 :: 		
	MOV	_error_flag, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,10 :: 		
	MOV	#1805, W10
	MOV	#0, W11
	CALL	_Can_write
;ebb_can_functions.c,11 :: 		
L_end_CAN_routine:
	POP	W11
	POP	W10
	RETURN
; end of _CAN_routine

_CAN_debug_routine:

;ebb_can_functions.c,13 :: 		
;ebb_can_functions.c,15 :: 		
	PUSH	W10
	CALL	_Can_resetWritePacket
;ebb_can_functions.c,16 :: 		
	MOV	_ebb_temp, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,17 :: 		
	MOV	_ebb_current, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,18 :: 		
	MOV	_ebb_motor_current, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,19 :: 		
L_end_CAN_debug_routine:
	POP	W10
	RETURN
; end of _CAN_debug_routine

_Debug_UART_Write:

;motor.c,8 :: 		
;motor.c,9 :: 		
	CALL	_UART1_Write_Text
;motor.c,10 :: 		
L_end_Debug_UART_Write:
	RETURN
; end of _Debug_UART_Write

_counter_quarter_turn_match:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;motor.c,14 :: 		
;motor.c,15 :: 		
	GOTO	L_counter_quarter_turn_match83
;motor.c,16 :: 		
L_counter_quarter_turn_match85:
;motor.c,17 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_motor_current_position), W0
	SUBR	W1, [W0], [W0]
;motor.c,18 :: 		
	GOTO	L_counter_quarter_turn_match84
;motor.c,19 :: 		
L_counter_quarter_turn_match86:
;motor.c,20 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_motor_current_position), W0
	ADD	W1, [W0], [W0]
;motor.c,21 :: 		
	GOTO	L_counter_quarter_turn_match84
;motor.c,22 :: 		
L_counter_quarter_turn_match87:
;motor.c,23 :: 		
	GOTO	L_counter_quarter_turn_match84
;motor.c,24 :: 		
L_counter_quarter_turn_match83:
	CLR.B	W0
	BTSC	UPDN_bit, BitPos(UPDN_bit+0)
	INC.B	W0
	CP.B	W0, #0
	BRA NZ	L__counter_quarter_turn_match299
	GOTO	L_counter_quarter_turn_match85
L__counter_quarter_turn_match299:
	CLR.B	W0
	BTSC	UPDN_bit, BitPos(UPDN_bit+0)
	INC.B	W0
	CP.B	W0, #1
	BRA NZ	L__counter_quarter_turn_match300
	GOTO	L_counter_quarter_turn_match86
L__counter_quarter_turn_match300:
	GOTO	L_counter_quarter_turn_match87
L_counter_quarter_turn_match84:
;motor.c,25 :: 		
	MOV	_motor_current_position, W1
	MOV	#lo_addr(_motor_target_position), W0
	CP	W1, [W0]
	BRA Z	L__counter_quarter_turn_match301
	GOTO	L_counter_quarter_turn_match88
L__counter_quarter_turn_match301:
;motor.c,27 :: 		
	MOV	#lo_addr(_brake_counter), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,28 :: 		
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,29 :: 		
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,30 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;motor.c,31 :: 		
L_counter_quarter_turn_match88:
;motor.c,32 :: 		
	BCLR	IFS2bits, #8
;motor.c,33 :: 		
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

;motor.c,37 :: 		
;motor.c,39 :: 		
	PUSH	W10
	PUSH	W11
	PUSH	W12
	GOTO	L_EBB_control89
;motor.c,41 :: 		
L_EBB_control91:
;motor.c,42 :: 		
	MOV	#lo_addr(_is_requested_movement), W0
	CP0.B	[W0]
	BRA NZ	L__EBB_control303
	GOTO	L_EBB_control92
L__EBB_control303:
;motor.c,44 :: 		
	GOTO	L_EBB_control93
;motor.c,46 :: 		
L_EBB_control95:
;motor.c,47 :: 		
	CLR	W0
	MOV	W0, _motor_target_position
;motor.c,48 :: 		
	GOTO	L_EBB_control94
;motor.c,49 :: 		
L_EBB_control96:
;motor.c,50 :: 		
	MOV	#2, W0
	MOV	W0, _motor_target_position
;motor.c,51 :: 		
	GOTO	L_EBB_control94
;motor.c,52 :: 		
L_EBB_control97:
;motor.c,53 :: 		
	MOV	#4, W0
	MOV	W0, _motor_target_position
;motor.c,54 :: 		
	GOTO	L_EBB_control94
;motor.c,55 :: 		
L_EBB_control98:
;motor.c,56 :: 		
	MOV	#6, W0
	MOV	W0, _motor_target_position
;motor.c,57 :: 		
	GOTO	L_EBB_control94
;motor.c,58 :: 		
L_EBB_control99:
;motor.c,59 :: 		
	MOV	#8, W0
	MOV	W0, _motor_target_position
;motor.c,60 :: 		
	GOTO	L_EBB_control94
;motor.c,61 :: 		
L_EBB_control100:
;motor.c,62 :: 		
	MOV	#10, W0
	MOV	W0, _motor_target_position
;motor.c,63 :: 		
	GOTO	L_EBB_control94
;motor.c,64 :: 		
L_EBB_control101:
;motor.c,65 :: 		
	MOV	#12, W0
	MOV	W0, _motor_target_position
;motor.c,66 :: 		
	GOTO	L_EBB_control94
;motor.c,67 :: 		
L_EBB_control102:
;motor.c,68 :: 		
	MOV	#14, W0
	MOV	W0, _motor_target_position
;motor.c,69 :: 		
	GOTO	L_EBB_control94
;motor.c,70 :: 		
L_EBB_control103:
;motor.c,71 :: 		
	MOV	#16, W0
	MOV	W0, _motor_target_position
;motor.c,72 :: 		
	GOTO	L_EBB_control94
;motor.c,73 :: 		
L_EBB_control104:
;motor.c,74 :: 		
	MOV	#18, W0
	MOV	W0, _motor_target_position
;motor.c,75 :: 		
	GOTO	L_EBB_control94
;motor.c,76 :: 		
L_EBB_control105:
;motor.c,77 :: 		
	MOV	#20, W0
	MOV	W0, _motor_target_position
;motor.c,78 :: 		
	GOTO	L_EBB_control94
;motor.c,79 :: 		
L_EBB_control106:
;motor.c,80 :: 		
	MOV	#22, W0
	MOV	W0, _motor_target_position
;motor.c,81 :: 		
	GOTO	L_EBB_control94
;motor.c,82 :: 		
L_EBB_control107:
;motor.c,83 :: 		
	MOV	#24, W0
	MOV	W0, _motor_target_position
;motor.c,84 :: 		
	GOTO	L_EBB_control94
;motor.c,85 :: 		
L_EBB_control108:
;motor.c,86 :: 		
	MOV	#26, W0
	MOV	W0, _motor_target_position
;motor.c,87 :: 		
	GOTO	L_EBB_control94
;motor.c,88 :: 		
L_EBB_control109:
;motor.c,89 :: 		
	MOV	#28, W0
	MOV	W0, _motor_target_position
;motor.c,90 :: 		
	GOTO	L_EBB_control94
;motor.c,91 :: 		
L_EBB_control110:
;motor.c,92 :: 		
	MOV	#30, W0
	MOV	W0, _motor_target_position
;motor.c,93 :: 		
	GOTO	L_EBB_control94
;motor.c,94 :: 		
L_EBB_control111:
;motor.c,95 :: 		
	MOV	#32, W0
	MOV	W0, _motor_target_position
;motor.c,96 :: 		
	GOTO	L_EBB_control94
;motor.c,97 :: 		
L_EBB_control93:
	MOV	_ebb_target_pos, W0
	CP	W0, #0
	BRA NZ	L__EBB_control304
	GOTO	L_EBB_control95
L__EBB_control304:
	MOV	_ebb_target_pos, W0
	CP	W0, #1
	BRA NZ	L__EBB_control305
	GOTO	L_EBB_control96
L__EBB_control305:
	MOV	_ebb_target_pos, W0
	CP	W0, #2
	BRA NZ	L__EBB_control306
	GOTO	L_EBB_control97
L__EBB_control306:
	MOV	_ebb_target_pos, W0
	CP	W0, #3
	BRA NZ	L__EBB_control307
	GOTO	L_EBB_control98
L__EBB_control307:
	MOV	_ebb_target_pos, W0
	CP	W0, #4
	BRA NZ	L__EBB_control308
	GOTO	L_EBB_control99
L__EBB_control308:
	MOV	_ebb_target_pos, W0
	CP	W0, #5
	BRA NZ	L__EBB_control309
	GOTO	L_EBB_control100
L__EBB_control309:
	MOV	_ebb_target_pos, W0
	CP	W0, #6
	BRA NZ	L__EBB_control310
	GOTO	L_EBB_control101
L__EBB_control310:
	MOV	_ebb_target_pos, W0
	CP	W0, #7
	BRA NZ	L__EBB_control311
	GOTO	L_EBB_control102
L__EBB_control311:
	MOV	_ebb_target_pos, W0
	CP	W0, #8
	BRA NZ	L__EBB_control312
	GOTO	L_EBB_control103
L__EBB_control312:
	MOV	_ebb_target_pos, W0
	CP	W0, #9
	BRA NZ	L__EBB_control313
	GOTO	L_EBB_control104
L__EBB_control313:
	MOV	_ebb_target_pos, W0
	CP	W0, #10
	BRA NZ	L__EBB_control314
	GOTO	L_EBB_control105
L__EBB_control314:
	MOV	_ebb_target_pos, W0
	CP	W0, #11
	BRA NZ	L__EBB_control315
	GOTO	L_EBB_control106
L__EBB_control315:
	MOV	_ebb_target_pos, W0
	CP	W0, #12
	BRA NZ	L__EBB_control316
	GOTO	L_EBB_control107
L__EBB_control316:
	MOV	_ebb_target_pos, W0
	CP	W0, #13
	BRA NZ	L__EBB_control317
	GOTO	L_EBB_control108
L__EBB_control317:
	MOV	_ebb_target_pos, W0
	CP	W0, #14
	BRA NZ	L__EBB_control318
	GOTO	L_EBB_control109
L__EBB_control318:
	MOV	_ebb_target_pos, W0
	CP	W0, #15
	BRA NZ	L__EBB_control319
	GOTO	L_EBB_control110
L__EBB_control319:
	MOV	_ebb_target_pos, W0
	CP	W0, #16
	BRA NZ	L__EBB_control320
	GOTO	L_EBB_control111
L__EBB_control320:
L_EBB_control94:
;motor.c,98 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;motor.c,99 :: 		
	MOV	#lo_addr(_is_requested_movement), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,100 :: 		
	GOTO	L_EBB_control112
L_EBB_control92:
	MOV	#lo_addr(_is_requested_calibration), W0
	CP0.B	[W0]
	BRA NZ	L__EBB_control321
	GOTO	L_EBB_control113
L__EBB_control321:
;motor.c,102 :: 		
	MOV	#1, W0
	MOV	W0, _calibration_on_off
;motor.c,103 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;motor.c,104 :: 		
	MOV	#lo_addr(_is_requested_calibration), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,105 :: 		
L_EBB_control113:
L_EBB_control112:
;motor.c,106 :: 		
	GOTO	L_EBB_control90
;motor.c,107 :: 		
L_EBB_control114:
;motor.c,108 :: 		
	MOV	_motor_target_position, W1
	MOV	#lo_addr(_motor_current_position), W0
	CP	W1, [W0]
	BRA GT	L__EBB_control322
	GOTO	L_EBB_control115
L__EBB_control322:
;motor.c,110 :: 		
	BSET	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,111 :: 		
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,112 :: 		
	GOTO	L_EBB_control116
L_EBB_control115:
	MOV	_motor_target_position, W1
	MOV	#lo_addr(_motor_current_position), W0
	CP	W1, [W0]
	BRA LT	L__EBB_control323
	GOTO	L_EBB_control117
L__EBB_control323:
;motor.c,114 :: 		
	MOV	#1, W1
	MOV	#lo_addr(_motor_target_position), W0
	SUBR	W1, [W0], [W0]
;motor.c,115 :: 		
	BSET	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,116 :: 		
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,117 :: 		
L_EBB_control117:
L_EBB_control116:
;motor.c,118 :: 		
	BSET	LATE2_bit, BitPos(LATE2_bit+0)
;motor.c,119 :: 		
	MOV	#4000, W0
	MOV	WREG, PDC1
;motor.c,121 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;motor.c,122 :: 		
	GOTO	L_EBB_control90
;motor.c,123 :: 		
L_EBB_control118:
;motor.c,124 :: 		
	MOV.B	#1, W1
	MOV	#lo_addr(_blink_counter), W0
	ADD.B	W1, [W0], [W0]
;motor.c,125 :: 		
	MOV	#lo_addr(_blink_counter), W0
	MOV.B	[W0], W0
	CP.B	W0, #20
	BRA GEU	L__EBB_control324
	GOTO	L_EBB_control119
L__EBB_control324:
;motor.c,127 :: 		
	BTG	LATD3_bit, BitPos(LATD3_bit+0)
;motor.c,128 :: 		
	MOV	#lo_addr(_blink_counter), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,129 :: 		
L_EBB_control119:
;motor.c,130 :: 		
	GOTO	L_EBB_control90
;motor.c,131 :: 		
L_EBB_control120:
;motor.c,132 :: 		
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;motor.c,133 :: 		
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;motor.c,135 :: 		
	MOV	#lo_addr(_brake_counter), W0
	MOV.B	[W0], W0
	CP.B	W0, #30
	BRA GEU	L__EBB_control325
	GOTO	L_EBB_control121
L__EBB_control325:
;motor.c,137 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;motor.c,138 :: 		
L_EBB_control121:
;motor.c,139 :: 		
	GOTO	L_EBB_control90
;motor.c,140 :: 		
L_EBB_control122:
;motor.c,141 :: 		
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;motor.c,142 :: 		
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;motor.c,143 :: 		
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,144 :: 		
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,145 :: 		
	MOV	_ebb_target_pos, W0
	MOV	W0, _ebb_current_pos
;motor.c,146 :: 		
	MOV	_motor_target_position, W0
	MOV	W0, _motor_current_position
;motor.c,147 :: 		
	MOV	POSCNT, W12
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,148 :: 		
L_EBB_control123:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control124
	GOTO	L_EBB_control123
L_EBB_control124:
;motor.c,155 :: 		
	MOV	_motor_current_position, W12
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,156 :: 		
L_EBB_control125:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control126
	GOTO	L_EBB_control125
L_EBB_control126:
;motor.c,157 :: 		
	MOV	_ebb_current_pos, W12
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,158 :: 		
L_EBB_control127:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control128
	GOTO	L_EBB_control127
L_EBB_control128:
;motor.c,159 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,160 :: 		
	GOTO	L_EBB_control90
;motor.c,161 :: 		
L_EBB_control129:
;motor.c,162 :: 		
	MOV	#8, W0
	MOV	W0, _ebb_current_pos
;motor.c,163 :: 		
	MOV	#8, W0
	MOV	W0, _ebb_target_pos
;motor.c,164 :: 		
	MOV	#16, W0
	MOV	W0, _motor_current_position
;motor.c,165 :: 		
	MOV	#16, W0
	MOV	W0, _motor_target_position
;motor.c,166 :: 		
	MOV	POSCNT, W12
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,167 :: 		
L_EBB_control130:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control131
	GOTO	L_EBB_control130
L_EBB_control131:
;motor.c,168 :: 		
	MOV	_motor_current_position, W12
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,169 :: 		
L_EBB_control132:
	CLR.B	W0
	BTSC	P_bit, BitPos(P_bit+0)
	INC.B	W0
	ZE	W0, W0
	SUBR	W0, #15, W0
	BRA NZ	L__EBB_control326
	GOTO	L_EBB_control133
L__EBB_control326:
	GOTO	L_EBB_control132
L_EBB_control133:
;motor.c,170 :: 		
	MOV	_ebb_current_pos, W12
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,171 :: 		
L_EBB_control134:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control135
	GOTO	L_EBB_control134
L_EBB_control135:
;motor.c,172 :: 		
	CALL	_CAN_routine
;motor.c,173 :: 		
	CLR	W0
	MOV	W0, _calibration_on_off
;motor.c,174 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,175 :: 		
	GOTO	L_EBB_control90
;motor.c,176 :: 		
L_EBB_control136:
;motor.c,177 :: 		
	MOV	#8, W0
	MOV	W0, _ebb_current_pos
;motor.c,178 :: 		
	MOV	#8, W0
	MOV	W0, _ebb_target_pos
;motor.c,179 :: 		
	MOV	#16, W0
	MOV	W0, _motor_current_position
;motor.c,180 :: 		
	MOV	#16, W0
	MOV	W0, _motor_target_position
;motor.c,181 :: 		
	MOV	POSCNT, W12
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,182 :: 		
L_EBB_control137:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control138
	GOTO	L_EBB_control137
L_EBB_control138:
;motor.c,183 :: 		
	MOV	_motor_current_position, W12
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,184 :: 		
L_EBB_control139:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control140
	GOTO	L_EBB_control139
L_EBB_control140:
;motor.c,185 :: 		
	MOV	_ebb_current_pos, W12
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,186 :: 		
L_EBB_control141:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control142
	GOTO	L_EBB_control141
L_EBB_control142:
;motor.c,187 :: 		
	CALL	_CAN_routine
;motor.c,188 :: 		
	CLR	W0
	MOV	W0, _calibration_on_off
;motor.c,189 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,190 :: 		
	GOTO	L_EBB_control90
;motor.c,191 :: 		
L_EBB_control143:
;motor.c,192 :: 		
	MOV	#1, W0
	MOV	W0, _buzzer_state
;motor.c,193 :: 		
	MOV	_brake_pressure_front, W1
	MOV	#430, W0
	CP	W1, W0
	BRA LTU	L__EBB_control327
	GOTO	L__EBB_control192
L__EBB_control327:
	MOV	_current_reading_motor, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#21299, W2
	MOV	#17417, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__EBB_control328
	INC.B	W0
L__EBB_control328:
	CP0.B	W0
	BRA NZ	L__EBB_control329
	GOTO	L__EBB_control191
L__EBB_control329:
L__EBB_control190:
;motor.c,195 :: 		
	CLR	W0
	MOV	W0, _buzzer_state
;motor.c,196 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;motor.c,193 :: 		
L__EBB_control192:
L__EBB_control191:
;motor.c,203 :: 		
	GOTO	L_EBB_control90
;motor.c,204 :: 		
L_EBB_control147:
;motor.c,205 :: 		
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;motor.c,206 :: 		
	BSET	LATD3_bit, BitPos(LATD3_bit+0)
;motor.c,207 :: 		
	MOV	#1, W0
	MOV	W0, _error_flag
;motor.c,208 :: 		
	MOV	#64992, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	CP	W0, #0
	BRA Z	L__EBB_control330
	GOTO	L_EBB_control148
L__EBB_control330:
;motor.c,210 :: 		
	MOV	#1, W12
	MOV	#64992, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,211 :: 		
L_EBB_control148:
;motor.c,212 :: 		
	GOTO	L_EBB_control90
;motor.c,214 :: 		
L_EBB_control89:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__EBB_control331
	GOTO	L_EBB_control91
L__EBB_control331:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__EBB_control332
	GOTO	L_EBB_control114
L__EBB_control332:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__EBB_control333
	GOTO	L_EBB_control118
L__EBB_control333:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__EBB_control334
	GOTO	L_EBB_control120
L__EBB_control334:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA NZ	L__EBB_control335
	GOTO	L_EBB_control122
L__EBB_control335:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA NZ	L__EBB_control336
	GOTO	L_EBB_control129
L__EBB_control336:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA NZ	L__EBB_control337
	GOTO	L_EBB_control136
L__EBB_control337:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #7
	BRA NZ	L__EBB_control338
	GOTO	L_EBB_control143
L__EBB_control338:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #6
	BRA NZ	L__EBB_control339
	GOTO	L_EBB_control147
L__EBB_control339:
L_EBB_control90:
;motor.c,215 :: 		
L_end_EBB_control:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _EBB_control

_EBB_Init:

;initialization.c,5 :: 		
;initialization.c,8 :: 		
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#64976, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#65535, W1
	CP	W0, W1
	BRA Z	L__EBB_Init341
	GOTO	L_EBB_Init149
L__EBB_Init341:
;initialization.c,10 :: 		
	CLR	W12
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,11 :: 		
L_EBB_Init150:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init151
	GOTO	L_EBB_Init150
L_EBB_Init151:
;initialization.c,12 :: 		
	MOV	#8, W12
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,13 :: 		
L_EBB_Init152:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init153
	GOTO	L_EBB_Init152
L_EBB_Init153:
;initialization.c,14 :: 		
	MOV	#16, W12
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,15 :: 		
L_EBB_Init154:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init155
	GOTO	L_EBB_Init154
L_EBB_Init155:
;initialization.c,16 :: 		
	CLR	W12
	MOV	#64976, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,17 :: 		
L_EBB_Init156:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init157
	GOTO	L_EBB_Init156
L_EBB_Init157:
;initialization.c,18 :: 		
	CLR	W12
	MOV	#64992, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,19 :: 		
L_EBB_Init158:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init159
	GOTO	L_EBB_Init158
L_EBB_Init159:
;initialization.c,20 :: 		
L_EBB_Init149:
;initialization.c,22 :: 		
	MOV	#65150, W0
	MOV	WREG, ADPCFG
;initialization.c,23 :: 		
	BCLR.B	TRISDbits, #1
;initialization.c,24 :: 		
	BCLR.B	TRISDbits, #3
;initialization.c,25 :: 		
	BCLR.B	TRISDbits, #2
;initialization.c,26 :: 		
	BCLR	TRISEbits, #0
;initialization.c,27 :: 		
	BCLR	TRISEbits, #4
;initialization.c,28 :: 		
	BCLR	TRISEbits, #3
;initialization.c,29 :: 		
	BCLR	TRISEbits, #2
;initialization.c,30 :: 		
	BSET	TRISBbits, #0
;initialization.c,31 :: 		
	BCLR	LATD2_bit, BitPos(LATD2_bit+0)
;initialization.c,32 :: 		
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,33 :: 		
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,35 :: 		
	MOV	#1410, W0
	MOV	WREG, QEICON
;initialization.c,37 :: 		
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	WREG, POSCNT
;initialization.c,38 :: 		
	MOV	#10048, W0
	MOV	WREG, MAXCNT
;initialization.c,39 :: 		
	MOV.B	#4, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC10bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC10bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC10bits), W0
	MOV.B	W1, [W0]
;initialization.c,40 :: 		
	BCLR	IFS2bits, #8
;initialization.c,41 :: 		
	BSET	IEC2bits, #8
;initialization.c,43 :: 		
	MOV	#257, W0
	MOV	WREG, PWMCON1
;initialization.c,44 :: 		
	MOV	#1999, W0
	MOV	WREG, PTPER
;initialization.c,45 :: 		
	CLR	PDC1
;initialization.c,46 :: 		
	CLR	PTMR
;initialization.c,47 :: 		
	MOV	#32768, W0
	MOV	WREG, PTCON
;initialization.c,48 :: 		
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;initialization.c,49 :: 		
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;initialization.c,50 :: 		
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;initialization.c,53 :: 		
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _ebb_current_pos
;initialization.c,54 :: 		
	MOV	W0, _ebb_target_pos
;initialization.c,55 :: 		
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _motor_current_position
;initialization.c,56 :: 		
	MOV	W0, _motor_target_position
;initialization.c,57 :: 		
	CLR	W0
	MOV	W0, _ebb_settings
;initialization.c,58 :: 		
	CLR	W0
	MOV	W0, _brake_pressure_front
;initialization.c,59 :: 		
	CLR	W0
	MOV	W0, _current_reading_motor
;initialization.c,60 :: 		
	MOV	#lo_addr(_is_requested_calibration), W1
	CLR	W0
	MOV.B	W0, [W1]
;initialization.c,61 :: 		
	MOV	#lo_addr(_is_requested_movement), W1
	CLR	W0
	MOV.B	W0, [W1]
;initialization.c,63 :: 		
	CALL	_Can_init
;initialization.c,65 :: 		
	CALL	_CAN_routine
;initialization.c,67 :: 		
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;initialization.c,69 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;initialization.c,70 :: 		
	MOV	#64992, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	CP	W0, #0
	BRA NZ	L__EBB_Init342
	GOTO	L_EBB_Init160
L__EBB_Init342:
;initialization.c,72 :: 		
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#6, W0
	MOV.B	W0, [W1]
;initialization.c,73 :: 		
L_EBB_Init160:
;initialization.c,76 :: 		
	MOV	#39846, W11
	MOV	#15172, W12
	MOV.B	#3, W10
	CALL	_setTimer
;initialization.c,79 :: 		
	MOV	#1, W0
	MOV	W0, _buzzer_state
;initialization.c,80 :: 		
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,81 :: 		
	BSET	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,82 :: 		
	MOV	#102, W8
	MOV	#47563, W7
L_EBB_Init161:
	DEC	W7
	BRA NZ	L_EBB_Init161
	DEC	W8
	BRA NZ	L_EBB_Init161
	NOP
;initialization.c,83 :: 		
	CLR	W0
	MOV	W0, _buzzer_state
;initialization.c,84 :: 		
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,85 :: 		
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,87 :: 		
	MOV	#55050, W11
	MOV	#15395, W12
	MOV.B	#1, W10
	CALL	_setTimer
;initialization.c,88 :: 		
	MOV	#55051, W11
	MOV	#15395, W12
	MOV.B	#2, W10
	CALL	_setTimer
;initialization.c,89 :: 		
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

;EBB_DPX.c,120 :: 		onTimer1Interrupt {
;EBB_DPX.c,121 :: 		timer1_counter ++;
	PUSH	W10
	MOV	#1, W1
	MOV	#lo_addr(_timer1_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,122 :: 		error_counter++;
	MOV	#1, W1
	MOV	#lo_addr(_error_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,123 :: 		error_bip_counter++;
	MOV	#1, W1
	MOV	#lo_addr(_error_bip_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,124 :: 		debug_counter++;
	MOV	#1, W1
	MOV	#lo_addr(_debug_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,168 :: 		current_reading_motor = ADC1_Read(MOTOR_CURRENT_PIN);
	CLR	W10
	CALL	_ADC1_Read
	MOV	W0, _current_reading_motor
;EBB_DPX.c,170 :: 		(current_reading_motor >= ((unsigned int)(LSB_CURRENT_READING * MOTOR_CURRENT_TRIGGER)) ||  brake_pressure_front >= BRAKE_PRESSURE_TRIGGER))
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__timer1_interrupt344
	GOTO	L__timer1_interrupt197
L__timer1_interrupt344:
	MOV	_current_reading_motor, W1
	MOV	#549, W0
	CP	W1, W0
	BRA LTU	L__timer1_interrupt345
	GOTO	L__timer1_interrupt196
L__timer1_interrupt345:
	MOV	_brake_pressure_front, W1
	MOV	#430, W0
	CP	W1, W0
	BRA LTU	L__timer1_interrupt346
	GOTO	L__timer1_interrupt195
L__timer1_interrupt346:
	GOTO	L_timer1_interrupt167
L__timer1_interrupt196:
L__timer1_interrupt195:
L__timer1_interrupt193:
;EBB_DPX.c,172 :: 		ENABLE = OFF;  //Turn off the motor
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;EBB_DPX.c,173 :: 		error_counter = 0;
	CLR	W0
	MOV	W0, _error_counter
;EBB_DPX.c,174 :: 		ebb_current_state = EBB_DRIVER_BRAKING;  //Enter corresponding mode
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#7, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,175 :: 		}
L_timer1_interrupt167:
;EBB_DPX.c,170 :: 		(current_reading_motor >= ((unsigned int)(LSB_CURRENT_READING * MOTOR_CURRENT_TRIGGER)) ||  brake_pressure_front >= BRAKE_PRESSURE_TRIGGER))
L__timer1_interrupt197:
;EBB_DPX.c,176 :: 		if(error_bip_counter >= 1000)
	MOV	_error_bip_counter, W1
	MOV	#1000, W0
	CP	W1, W0
	BRA GE	L__timer1_interrupt347
	GOTO	L_timer1_interrupt168
L__timer1_interrupt347:
;EBB_DPX.c,178 :: 		error_bip_counter = 0;
	CLR	W0
	MOV	W0, _error_bip_counter
;EBB_DPX.c,179 :: 		}
L_timer1_interrupt168:
;EBB_DPX.c,181 :: 		if(debug_counter >= 1000)
	MOV	_debug_counter, W1
	MOV	#1000, W0
	CP	W1, W0
	BRA GE	L__timer1_interrupt348
	GOTO	L_timer1_interrupt169
L__timer1_interrupt348:
;EBB_DPX.c,183 :: 		ebb_temp = (ADC1_Read(TEMPERATURE_SENSOR_PIN) * LSB_VOLTAGE_READING * 100000 - 50);
	MOV	#8, W10
	CALL	_ADC1_Read
	CLR	W1
	CALL	__Long2Float
	MOV	#31457, W2
	MOV	#16540, W3
	CALL	__Mul_FP
	MOV	#20480, W2
	MOV	#18371, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#16968, W3
	CALL	__Sub_FP
	CALL	__Float2Longint
	MOV	W0, _ebb_temp
;EBB_DPX.c,184 :: 		CAN_debug_routine();
	CALL	_CAN_debug_routine
;EBB_DPX.c,185 :: 		}
L_timer1_interrupt169:
;EBB_DPX.c,186 :: 		clearTimer1();
	BCLR	IFS0bits, #3
;EBB_DPX.c,187 :: 		}
L_end_timer1_interrupt:
	POP	W10
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

;EBB_DPX.c,192 :: 		onTimer2Interrupt {
;EBB_DPX.c,193 :: 		timer2_counter++;
	MOV	#1, W1
	MOV	#lo_addr(_timer2_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,194 :: 		brake_counter++;
	MOV.B	#1, W1
	MOV	#lo_addr(_brake_counter), W0
	ADD.B	W1, [W0], [W0]
;EBB_DPX.c,195 :: 		EBB_control();
	CALL	_EBB_control
;EBB_DPX.c,196 :: 		if (timer2_counter >= 10)
	MOV	_timer2_counter, W0
	CP	W0, #10
	BRA GE	L__timer2_interrupt350
	GOTO	L_timer2_interrupt170
L__timer2_interrupt350:
;EBB_DPX.c,198 :: 		CAN_routine();  //Call the can update routine
	CALL	_CAN_routine
;EBB_DPX.c,199 :: 		timer2_counter = 0;
	CLR	W0
	MOV	W0, _timer2_counter
;EBB_DPX.c,200 :: 		}
L_timer2_interrupt170:
;EBB_DPX.c,206 :: 		clearTimer2();
	BCLR	IFS0bits, #6
;EBB_DPX.c,207 :: 		}
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

;EBB_DPX.c,212 :: 		onTimer4Interrupt {
;EBB_DPX.c,213 :: 		if(buzzer_state == ON){  //Sound routine
	MOV	_buzzer_state, W0
	CP	W0, #1
	BRA Z	L__timer4_interrupt352
	GOTO	L_timer4_interrupt171
L__timer4_interrupt352:
;EBB_DPX.c,214 :: 		BUZZER = !BUZZER;
	BTG	LATD2_bit, BitPos(LATD2_bit+0)
;EBB_DPX.c,215 :: 		}
L_timer4_interrupt171:
;EBB_DPX.c,216 :: 		clearTimer4();
	BCLR	IFS1bits, #5
;EBB_DPX.c,217 :: 		}
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

;EBB_DPX.c,221 :: 		void main() {
;EBB_DPX.c,222 :: 		EBB_Init();
	CALL	_EBB_Init
;EBB_DPX.c,223 :: 		while(1)
L_main172:
;EBB_DPX.c,225 :: 		}
	GOTO	L_main172
;EBB_DPX.c,227 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_CAN_Interrupt:
	LNK	#22
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;EBB_DPX.c,230 :: 		onCanInterrupt {
;EBB_DPX.c,236 :: 		Can_read(&CAN_id, CAN_datain, &CAN_dataLen, &CAN_flags);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	ADD	W14, #14, W3
	ADD	W14, #12, W2
	ADD	W14, #4, W1
	ADD	W14, #0, W0
	MOV	W3, W13
	MOV	W2, W12
	MOV	W1, W11
	MOV	W0, W10
	CALL	_Can_read
;EBB_DPX.c,238 :: 		if (CAN_dataLen >= 2) {
	MOV	[W14+12], W0
	CP	W0, #2
	BRA GEU	L__CAN_Interrupt356
	GOTO	L_CAN_Interrupt174
L__CAN_Interrupt356:
;EBB_DPX.c,239 :: 		firstInt = (unsigned int) ((CAN_datain[0] << 8) | (CAN_datain[1] & 0xFF));
	ADD	W14, #4, W1
	MOV.B	[W1], W0
	ZE	W0, W0
	SL	W0, #8, W2
	ADD	W1, #1, W0
	ZE	[W0], W1
	MOV	#255, W0
	AND	W1, W0, W1
	ADD	W14, #16, W0
	IOR	W2, W1, [W0]
;EBB_DPX.c,240 :: 		}
L_CAN_Interrupt174:
;EBB_DPX.c,241 :: 		if (CAN_dataLen >= 4) {
	MOV	[W14+12], W0
	CP	W0, #4
	BRA GEU	L__CAN_Interrupt357
	GOTO	L_CAN_Interrupt175
L__CAN_Interrupt357:
;EBB_DPX.c,242 :: 		secondInt = (unsigned int) ((CAN_datain[2] << 8) | (CAN_datain[3] & 0xFF));
	ADD	W14, #4, W1
	ADD	W1, #2, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W2
	ADD	W1, #3, W0
	ZE	[W0], W1
	MOV	#255, W0
	AND	W1, W0, W1
	ADD	W14, #18, W0
	IOR	W2, W1, [W0]
;EBB_DPX.c,243 :: 		}
L_CAN_Interrupt175:
;EBB_DPX.c,244 :: 		if (CAN_dataLen >= 6) {
	MOV	[W14+12], W0
	CP	W0, #6
	BRA GEU	L__CAN_Interrupt358
	GOTO	L_CAN_Interrupt176
L__CAN_Interrupt358:
;EBB_DPX.c,245 :: 		thirdInt = (unsigned int) ((CAN_datain[4] << 8) | (CAN_datain[5] & 0xFF));
	ADD	W14, #4, W1
	ADD	W1, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W2
	ADD	W1, #5, W0
	ZE	[W0], W1
	MOV	#255, W0
	AND	W1, W0, W1
	ADD	W14, #20, W0
	IOR	W2, W1, [W0]
;EBB_DPX.c,246 :: 		}
L_CAN_Interrupt176:
;EBB_DPX.c,247 :: 		if (CAN_dataLen >= 8) {
	MOV	[W14+12], W0
	CP	W0, #8
	BRA GEU	L__CAN_Interrupt359
	GOTO	L_CAN_Interrupt177
L__CAN_Interrupt359:
;EBB_DPX.c,249 :: 		}
L_CAN_Interrupt177:
;EBB_DPX.c,250 :: 		Can_clearInterrupt();
	CALL	_Can_clearInterrupt
;EBB_DPX.c,252 :: 		switch(CAN_id){
	GOTO	L_CAN_Interrupt178
;EBB_DPX.c,253 :: 		case SW_BRAKE_BIAS_EBB_ID:
L_CAN_Interrupt180:
;EBB_DPX.c,254 :: 		ebb_target_pos = ((unsigned int)firstInt);
	MOV	[W14+16], W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,255 :: 		ebb_settings = ((unsigned int)secondInt);
	MOV	[W14+18], W0
	MOV	W0, _ebb_settings
;EBB_DPX.c,256 :: 		if ((ebb_target_pos != ebb_current_pos) && ebb_target_pos >= MIN_POSITION && ebb_target_pos <= MAX_POSITION)
	MOV	[W14+16], W1
	MOV	#lo_addr(_ebb_current_pos), W0
	CP	W1, [W0]
	BRA NZ	L__CAN_Interrupt360
	GOTO	L__CAN_Interrupt201
L__CAN_Interrupt360:
	MOV	_ebb_target_pos, W0
	CP	W0, #5
	BRA GEU	L__CAN_Interrupt361
	GOTO	L__CAN_Interrupt200
L__CAN_Interrupt361:
	MOV	_ebb_target_pos, W0
	CP	W0, #11
	BRA LEU	L__CAN_Interrupt362
	GOTO	L__CAN_Interrupt199
L__CAN_Interrupt362:
L__CAN_Interrupt198:
;EBB_DPX.c,258 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,260 :: 		}else if (ebb_target_pos == CALIBRATION_POSITION)
	GOTO	L_CAN_Interrupt184
;EBB_DPX.c,256 :: 		if ((ebb_target_pos != ebb_current_pos) && ebb_target_pos >= MIN_POSITION && ebb_target_pos <= MAX_POSITION)
L__CAN_Interrupt201:
L__CAN_Interrupt200:
L__CAN_Interrupt199:
;EBB_DPX.c,260 :: 		}else if (ebb_target_pos == CALIBRATION_POSITION)
	MOV	#100, W1
	MOV	#lo_addr(_ebb_target_pos), W0
	CP	W1, [W0]
	BRA Z	L__CAN_Interrupt363
	GOTO	L_CAN_Interrupt185
L__CAN_Interrupt363:
;EBB_DPX.c,262 :: 		buzzer_state = ON;
	MOV	#1, W0
	MOV	W0, _buzzer_state
;EBB_DPX.c,263 :: 		is_requested_calibration = ON;
	MOV	#lo_addr(_is_requested_calibration), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,264 :: 		}
L_CAN_Interrupt185:
L_CAN_Interrupt184:
;EBB_DPX.c,265 :: 		break;
	GOTO	L_CAN_Interrupt179
;EBB_DPX.c,266 :: 		case DAU_FR_ID:
L_CAN_Interrupt186:
;EBB_DPX.c,267 :: 		brake_pressure_front = ((unsigned int)thirdInt);
	MOV	[W14+20], W0
	MOV	W0, _brake_pressure_front
;EBB_DPX.c,268 :: 		break;
	GOTO	L_CAN_Interrupt179
;EBB_DPX.c,270 :: 		}
L_CAN_Interrupt178:
	MOV	#1024, W1
	MOV	#0, W2
	ADD	W14, #0, W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA NZ	L__CAN_Interrupt364
	GOTO	L_CAN_Interrupt180
L__CAN_Interrupt364:
	MOV	#1616, W1
	MOV	#0, W2
	ADD	W14, #0, W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA NZ	L__CAN_Interrupt365
	GOTO	L_CAN_Interrupt186
L__CAN_Interrupt365:
L_CAN_Interrupt179:
;EBB_DPX.c,271 :: 		}
L_end_CAN_Interrupt:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	ULNK
	RETFIE
; end of _CAN_Interrupt
