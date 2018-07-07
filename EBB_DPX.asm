
_Can_init:

;can.c,25 :: 		void Can_init() {
;can.c,26 :: 		unsigned int Can_Init_flags = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
;can.c,33 :: 		CAN1Initialize(2,4,3,4,2,Can_Init_flags);          // SJW,BRP,PHSEG1,PHSEG2,PROPSEG
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
;can.c,34 :: 		CAN1SetOperationMode(_CAN_MODE_CONFIG,0xFF);
	MOV	#255, W11
	MOV	#4, W10
	CALL	_CAN1SetOperationMode
;can.c,36 :: 		CAN1SetMask(_CAN_MASK_B1, EBB_MASK_SW_DAUFR, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
	MOV	#255, W13
	MOV	#2047, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetMask
;can.c,37 :: 		CAN1SetFilter(_CAN_FILTER_B1_F1, EBB_FILTER_SW, _CAN_CONFIG_STD_MSG);        //steering wheel commands
	MOV	#255, W13
	MOV	#1024, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetFilter
;can.c,38 :: 		CAN1SetFilter(_CAN_FILTER_B1_F2, EBB_FILTER_DAUFR, _CAN_CONFIG_STD_MSG);              //brake pressure
	MOV	#255, W13
	MOV	#1616, W11
	MOV	#0, W12
	MOV	#1, W10
	CALL	_CAN1SetFilter
;can.c,40 :: 		CAN1SetMask(_CAN_MASK_B2, ALL_MASK_AUX, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
	MOV	#255, W13
	MOV	#2032, W11
	MOV	#0, W12
	MOV	#1, W10
	CALL	_CAN1SetMask
;can.c,41 :: 		CAN1SetFilter(_CAN_FILTER_B2_F1, ALL_FILTER_AUX, _CAN_CONFIG_STD_MSG);     //auxiliary
	MOV	#255, W13
	MOV	#2032, W11
	MOV	#0, W12
	MOV	#2, W10
	CALL	_CAN1SetFilter
;can.c,43 :: 		CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);
	MOV	#255, W11
	CLR	W10
	CALL	_CAN1SetOperationMode
;can.c,45 :: 		Can_initInterrupt();
	CALL	_Can_initInterrupt
;can.c,46 :: 		Can_setWritePriority(CAN_PRIORITY_MEDIUM);
	MOV	#253, W10
	CALL	_Can_setWritePriority
;can.c,47 :: 		}
L_end_Can_init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Can_init

_Can_read:
	LNK	#2

;can.c,49 :: 		void Can_read(unsigned long int *id, char dataBuffer[], unsigned int *dataLength, unsigned int *inFlags) {
	PUSH	W13
	MOV	W13, [W14+0]
;can.c,50 :: 		if (Can_B0hasBeenReceived()) {
	CALL	_Can_B0hasBeenReceived
	CP0.B	W0
	BRA NZ	L__Can_read183
	GOTO	L_Can_read0
L__Can_read183:
;can.c,51 :: 		Can_clearB0Flag();
	CALL	_Can_clearB0Flag
;can.c,52 :: 		Can1Read(id, dataBuffer, dataLength, &inFlags);
	ADD	W14, #0, W0
	MOV	W0, W13
	CALL	_CAN1Read
;can.c,53 :: 		}
	GOTO	L_Can_read1
L_Can_read0:
;can.c,54 :: 		else if (Can_B1hasBeenReceived()) {
	CALL	_Can_B1hasBeenReceived
	CP0.B	W0
	BRA NZ	L__Can_read184
	GOTO	L_Can_read2
L__Can_read184:
;can.c,55 :: 		Can_clearB1Flag();
	CALL	_Can_clearB1Flag
;can.c,56 :: 		Can1Read(id, dataBuffer, dataLength, &inFlags);
	ADD	W14, #0, W0
	MOV	W0, W13
	CALL	_CAN1Read
;can.c,57 :: 		}
L_Can_read2:
L_Can_read1:
;can.c,58 :: 		}
L_end_Can_read:
	POP	W13
	ULNK
	RETURN
; end of _Can_read

_Can_writeByte:

;can.c,60 :: 		void Can_writeByte(unsigned long int id, unsigned char dataOut) {
;can.c,61 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;can.c,62 :: 		Can_addByteToWritePacket(dataOut);
	PUSH.D	W10
	MOV.B	W12, W10
	CALL	_Can_addByteToWritePacket
	POP.D	W10
;can.c,63 :: 		Can_write(id);
	CALL	_Can_write
;can.c,64 :: 		}
L_end_Can_writeByte:
	RETURN
; end of _Can_writeByte

_Can_writeInt:

;can.c,66 :: 		void Can_writeInt(unsigned long int id, int dataOut) {
;can.c,67 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;can.c,68 :: 		Can_addIntToWritePacket(dataOut);
	PUSH.D	W10
	MOV	W12, W10
	CALL	_Can_addIntToWritePacket
	POP.D	W10
;can.c,69 :: 		Can_write(id);
	CALL	_Can_write
;can.c,70 :: 		}
L_end_Can_writeInt:
	RETURN
; end of _Can_writeInt

_Can_addIntToWritePacket:

;can.c,72 :: 		void Can_addIntToWritePacket(int dataOut) {
;can.c,73 :: 		Can_addByteToWritePacket((unsigned char) (dataOut >> 8));
	PUSH	W10
	ASR	W10, #8, W0
	PUSH	W10
	MOV.B	W0, W10
	CALL	_Can_addByteToWritePacket
	POP	W10
;can.c,74 :: 		Can_addByteToWritePacket((unsigned char) (dataOut & 0xFF));
	MOV	#255, W0
	AND	W10, W0, W0
	MOV.B	W0, W10
	CALL	_Can_addByteToWritePacket
;can.c,75 :: 		}
L_end_Can_addIntToWritePacket:
	POP	W10
	RETURN
; end of _Can_addIntToWritePacket

_Can_addByteToWritePacket:

;can.c,77 :: 		void Can_addByteToWritePacket(unsigned char dataOut) {
;can.c,78 :: 		can_dataOutBuffer[can_dataOutLength] = dataOut;
	MOV	#lo_addr(_can_dataOutBuffer), W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], W0
	MOV.B	W10, [W0]
;can.c,79 :: 		can_dataOutLength += 1;
	MOV	#1, W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], [W0]
;can.c,80 :: 		}
L_end_Can_addByteToWritePacket:
	RETURN
; end of _Can_addByteToWritePacket

_Can_write:
	LNK	#2

;can.c,82 :: 		void Can_write(unsigned long int id) {
;can.c,84 :: 		do {
	PUSH	W12
	PUSH	W13
L_Can_write3:
;can.c,85 :: 		sent = CAN1Write(id, can_dataOutBuffer, can_dataOutLength, Can_getWriteFlags());
	CALL	_Can_getWriteFlags
	PUSH.D	W10
	MOV	_can_dataOutLength, W13
	MOV	#lo_addr(_can_dataOutBuffer), W12
	PUSH	W0
	CALL	_CAN1Write
	SUB	#2, W15
	POP.D	W10
;can.c,86 :: 		i += 1;
	MOV	#1, W2
	ADD	W14, #0, W1
	ADD	W2, [W1], [W1]
;can.c,87 :: 		} while ((sent == 0) && (i < CAN_RETRY_LIMIT));
	CP	W0, #0
	BRA Z	L__Can_write190
	GOTO	L__Can_write176
L__Can_write190:
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__Can_write191
	GOTO	L__Can_write175
L__Can_write191:
	GOTO	L_Can_write3
L__Can_write176:
L__Can_write175:
;can.c,88 :: 		if (i == CAN_RETRY_LIMIT) {
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA Z	L__Can_write192
	GOTO	L_Can_write8
L__Can_write192:
;can.c,89 :: 		can_err++;
	MOV	#1, W1
	MOV	#lo_addr(_can_err), W0
	ADD	W1, [W0], [W0]
;can.c,90 :: 		}
L_Can_write8:
;can.c,91 :: 		}
L_end_Can_write:
	POP	W13
	POP	W12
	ULNK
	RETURN
; end of _Can_write

_Can_setWritePriority:

;can.c,93 :: 		void Can_setWritePriority(unsigned int txPriority) {
;can.c,94 :: 		can_txPriority = txPriority;
	MOV	W10, _can_txPriority
;can.c,95 :: 		}
L_end_Can_setWritePriority:
	RETURN
; end of _Can_setWritePriority

_Can_resetWritePacket:

;can.c,97 :: 		void Can_resetWritePacket(void) {
;can.c,98 :: 		for (can_dataOutLength = 0; can_dataOutLength < CAN_PACKET_SIZE; can_dataOutLength += 1) {
	CLR	W0
	MOV	W0, _can_dataOutLength
L_Can_resetWritePacket9:
	MOV	_can_dataOutLength, W0
	CP	W0, #8
	BRA LTU	L__Can_resetWritePacket195
	GOTO	L_Can_resetWritePacket10
L__Can_resetWritePacket195:
;can.c,99 :: 		can_dataOutBuffer[can_dataOutLength] = 0;
	MOV	#lo_addr(_can_dataOutBuffer), W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;can.c,98 :: 		for (can_dataOutLength = 0; can_dataOutLength < CAN_PACKET_SIZE; can_dataOutLength += 1) {
	MOV	#1, W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], [W0]
;can.c,100 :: 		}
	GOTO	L_Can_resetWritePacket9
L_Can_resetWritePacket10:
;can.c,101 :: 		can_dataOutLength = 0;
	CLR	W0
	MOV	W0, _can_dataOutLength
;can.c,102 :: 		}
L_end_Can_resetWritePacket:
	RETURN
; end of _Can_resetWritePacket

_Can_getWriteFlags:

;can.c,104 :: 		unsigned int Can_getWriteFlags(void) {
;can.c,105 :: 		return CAN_DEFAULT_FLAGS & can_txPriority;
	MOV	#255, W1
	MOV	#lo_addr(_can_txPriority), W0
	AND	W1, [W0], W0
;can.c,106 :: 		}
L_end_Can_getWriteFlags:
	RETURN
; end of _Can_getWriteFlags

_Can_B0hasBeenReceived:

;can.c,108 :: 		unsigned char Can_B0hasBeenReceived(void) {
;can.c,109 :: 		return CAN_INTERRUPT_ONB0_OCCURRED == 1;
	CLR.B	W0
	BTSC	C1INTFbits, #0
	INC.B	W0
	CP.B	W0, #1
	CLR.B	W0
	BRA NZ	L__Can_B0hasBeenReceived198
	INC.B	W0
L__Can_B0hasBeenReceived198:
;can.c,110 :: 		}
L_end_Can_B0hasBeenReceived:
	RETURN
; end of _Can_B0hasBeenReceived

_Can_B1hasBeenReceived:

;can.c,112 :: 		unsigned char Can_B1hasBeenReceived(void) {
;can.c,113 :: 		return CAN_INTERRUPT_ONB1_OCCURRED == 1;
	CLR.B	W0
	BTSC	C1INTFbits, #1
	INC.B	W0
	CP.B	W0, #1
	CLR.B	W0
	BRA NZ	L__Can_B1hasBeenReceived200
	INC.B	W0
L__Can_B1hasBeenReceived200:
;can.c,114 :: 		}
L_end_Can_B1hasBeenReceived:
	RETURN
; end of _Can_B1hasBeenReceived

_Can_clearB0Flag:

;can.c,116 :: 		void Can_clearB0Flag(void) {
;can.c,117 :: 		CAN_INTERRUPT_ONB0_OCCURRED = 0;
	BCLR	C1INTFbits, #0
;can.c,118 :: 		}
L_end_Can_clearB0Flag:
	RETURN
; end of _Can_clearB0Flag

_Can_clearB1Flag:

;can.c,120 :: 		void Can_clearB1Flag(void) {
;can.c,121 :: 		CAN_INTERRUPT_ONB1_OCCURRED = 0;
	BCLR	C1INTFbits, #1
;can.c,122 :: 		}
L_end_Can_clearB1Flag:
	RETURN
; end of _Can_clearB1Flag

_Can_clearInterrupt:

;can.c,124 :: 		void Can_clearInterrupt(void) {
;can.c,125 :: 		CAN_INTERRUPT_OCCURRED = 0;
	BCLR	IFS1bits, #11
;can.c,126 :: 		}
L_end_Can_clearInterrupt:
	RETURN
; end of _Can_clearInterrupt

_Can_initInterrupt:

;can.c,128 :: 		void Can_initInterrupt(void) {
;can.c,130 :: 		INTERRUPT_PROTECT(IEC1BITS.C1IE = 1);
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
;can.c,131 :: 		INTERRUPT_PROTECT(C1INTEBITS.RXB0IE = 1); //An interrupt is generated everytime that a message passes through the mask in buffer 0
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
;can.c,132 :: 		INTERRUPT_PROTECT(C1INTEBITS.RXB1IE = 1); //Suddividere gli ID da ricevere nei due buffer
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
;can.c,134 :: 		}
L_end_Can_initInterrupt:
	RETURN
; end of _Can_initInterrupt

_setAllPinAsDigital:

;dspic.c,11 :: 		void setAllPinAsDigital(void) {
;dspic.c,12 :: 		ADPCFG = 0xFFFF;
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;dspic.c,13 :: 		}
L_end_setAllPinAsDigital:
	RETURN
; end of _setAllPinAsDigital

_setInterruptPriority:

;dspic.c,15 :: 		void setInterruptPriority(unsigned char device, unsigned char priority) {
;dspic.c,16 :: 		switch (device) {
	GOTO	L_setInterruptPriority12
;dspic.c,17 :: 		case INT0_DEVICE:
L_setInterruptPriority14:
;dspic.c,18 :: 		INT0_PRIORITY = priority;
	MOV.B	W11, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC0bits), W0
	MOV.B	W1, [W0]
;dspic.c,19 :: 		break;
	GOTO	L_setInterruptPriority13
;dspic.c,20 :: 		case INT1_DEVICE:
L_setInterruptPriority15:
;dspic.c,21 :: 		INT1_PRIORITY = priority;
	MOV.B	W11, W1
	MOV	#lo_addr(IPC4bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC4bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC4bits), W0
	MOV.B	W1, [W0]
;dspic.c,22 :: 		break;
	GOTO	L_setInterruptPriority13
;dspic.c,23 :: 		case INT2_DEVICE:
L_setInterruptPriority16:
;dspic.c,24 :: 		INT2_PRIORITY = priority;
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
;dspic.c,25 :: 		break;
	GOTO	L_setInterruptPriority13
;dspic.c,29 :: 		case TIMER1_DEVICE:
L_setInterruptPriority17:
;dspic.c,30 :: 		TIMER1_PRIORITY = priority;
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
;dspic.c,31 :: 		break;
	GOTO	L_setInterruptPriority13
;dspic.c,32 :: 		case TIMER2_DEVICE:
L_setInterruptPriority18:
;dspic.c,33 :: 		TIMER2_PRIORITY = priority;
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
;dspic.c,34 :: 		break;
	GOTO	L_setInterruptPriority13
;dspic.c,35 :: 		case TIMER4_DEVICE:
L_setInterruptPriority19:
;dspic.c,36 :: 		TIMER4_PRIORITY = priority;
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
;dspic.c,37 :: 		break;
	GOTO	L_setInterruptPriority13
;dspic.c,38 :: 		default:
L_setInterruptPriority20:
;dspic.c,39 :: 		break;
	GOTO	L_setInterruptPriority13
;dspic.c,40 :: 		}
L_setInterruptPriority12:
	CP.B	W10, #4
	BRA NZ	L__setInterruptPriority207
	GOTO	L_setInterruptPriority14
L__setInterruptPriority207:
	CP.B	W10, #5
	BRA NZ	L__setInterruptPriority208
	GOTO	L_setInterruptPriority15
L__setInterruptPriority208:
	CP.B	W10, #6
	BRA NZ	L__setInterruptPriority209
	GOTO	L_setInterruptPriority16
L__setInterruptPriority209:
	CP.B	W10, #1
	BRA NZ	L__setInterruptPriority210
	GOTO	L_setInterruptPriority17
L__setInterruptPriority210:
	CP.B	W10, #2
	BRA NZ	L__setInterruptPriority211
	GOTO	L_setInterruptPriority18
L__setInterruptPriority211:
	CP.B	W10, #3
	BRA NZ	L__setInterruptPriority212
	GOTO	L_setInterruptPriority19
L__setInterruptPriority212:
	GOTO	L_setInterruptPriority20
L_setInterruptPriority13:
;dspic.c,41 :: 		}
L_end_setInterruptPriority:
	RETURN
; end of _setInterruptPriority

_setExternalInterrupt:

;dspic.c,43 :: 		void setExternalInterrupt(unsigned char device, char edge) {
;dspic.c,44 :: 		setInterruptPriority(device, MEDIUM_PRIORITY);
	PUSH	W11
	MOV.B	#4, W11
	CALL	_setInterruptPriority
	POP	W11
;dspic.c,45 :: 		switch (device) {
	GOTO	L_setExternalInterrupt21
;dspic.c,46 :: 		case INT0_DEVICE:
L_setExternalInterrupt23:
;dspic.c,47 :: 		INT0_TRIGGER_EDGE = edge;
	BTSS	W11, #0
	BCLR	INTCON2, #0
	BTSC	W11, #0
	BSET	INTCON2, #0
;dspic.c,48 :: 		INT0_OCCURRED = FALSE;
	BCLR	IFS0, #0
;dspic.c,49 :: 		INT0_ENABLE = TRUE;
	BSET	IEC0, #0
;dspic.c,50 :: 		break;
	GOTO	L_setExternalInterrupt22
;dspic.c,51 :: 		case INT1_DEVICE:
L_setExternalInterrupt24:
;dspic.c,52 :: 		INT1_TRIGGER_EDGE = edge;
	BTSS	W11, #0
	BCLR	INTCON2, #1
	BTSC	W11, #0
	BSET	INTCON2, #1
;dspic.c,53 :: 		INT1_OCCURRED = FALSE;
	BCLR	IFS1, #0
;dspic.c,54 :: 		INT1_ENABLE = TRUE;
	BSET	IEC1, #0
;dspic.c,55 :: 		break;
	GOTO	L_setExternalInterrupt22
;dspic.c,56 :: 		case INT2_DEVICE:
L_setExternalInterrupt25:
;dspic.c,57 :: 		INT2_TRIGGER_EDGE = edge;
	BTSS	W11, #0
	BCLR	INTCON2, #2
	BTSC	W11, #0
	BSET	INTCON2, #2
;dspic.c,58 :: 		INT2_OCCURRED = FALSE;
	BCLR	IFS1, #7
;dspic.c,59 :: 		INT2_ENABLE = TRUE;
	BSET	IEC1, #7
;dspic.c,60 :: 		break;
	GOTO	L_setExternalInterrupt22
;dspic.c,65 :: 		default:
L_setExternalInterrupt26:
;dspic.c,66 :: 		break;
	GOTO	L_setExternalInterrupt22
;dspic.c,67 :: 		}
L_setExternalInterrupt21:
	CP.B	W10, #4
	BRA NZ	L__setExternalInterrupt214
	GOTO	L_setExternalInterrupt23
L__setExternalInterrupt214:
	CP.B	W10, #5
	BRA NZ	L__setExternalInterrupt215
	GOTO	L_setExternalInterrupt24
L__setExternalInterrupt215:
	CP.B	W10, #6
	BRA NZ	L__setExternalInterrupt216
	GOTO	L_setExternalInterrupt25
L__setExternalInterrupt216:
	GOTO	L_setExternalInterrupt26
L_setExternalInterrupt22:
;dspic.c,68 :: 		}
L_end_setExternalInterrupt:
	RETURN
; end of _setExternalInterrupt

_switchExternalInterruptEdge:

;dspic.c,70 :: 		void switchExternalInterruptEdge(unsigned char device) {
;dspic.c,71 :: 		switch (device) {
	GOTO	L_switchExternalInterruptEdge27
;dspic.c,72 :: 		case INT0_DEVICE:
L_switchExternalInterruptEdge29:
;dspic.c,73 :: 		if (INT0_TRIGGER_EDGE == NEGATIVE_EDGE) {
	CLR.B	W0
	BTSC	INTCON2, #0
	INC.B	W0
	CP.B	W0, #1
	BRA Z	L__switchExternalInterruptEdge218
	GOTO	L_switchExternalInterruptEdge30
L__switchExternalInterruptEdge218:
;dspic.c,74 :: 		INT0_TRIGGER_EDGE = POSITIVE_EDGE;
	BCLR	INTCON2, #0
;dspic.c,75 :: 		} else {
	GOTO	L_switchExternalInterruptEdge31
L_switchExternalInterruptEdge30:
;dspic.c,76 :: 		INT0_TRIGGER_EDGE = NEGATIVE_EDGE;
	BSET	INTCON2, #0
;dspic.c,77 :: 		}
L_switchExternalInterruptEdge31:
;dspic.c,78 :: 		break;
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,79 :: 		case INT1_DEVICE:
L_switchExternalInterruptEdge32:
;dspic.c,80 :: 		if (INT1_TRIGGER_EDGE == NEGATIVE_EDGE) {
	CLR.B	W0
	BTSC	INTCON2, #1
	INC.B	W0
	CP.B	W0, #1
	BRA Z	L__switchExternalInterruptEdge219
	GOTO	L_switchExternalInterruptEdge33
L__switchExternalInterruptEdge219:
;dspic.c,81 :: 		INT1_TRIGGER_EDGE = POSITIVE_EDGE;
	BCLR	INTCON2, #1
;dspic.c,82 :: 		} else {
	GOTO	L_switchExternalInterruptEdge34
L_switchExternalInterruptEdge33:
;dspic.c,83 :: 		INT1_TRIGGER_EDGE = NEGATIVE_EDGE;
	BSET	INTCON2, #1
;dspic.c,84 :: 		}
L_switchExternalInterruptEdge34:
;dspic.c,85 :: 		break;
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,86 :: 		case INT2_DEVICE:
L_switchExternalInterruptEdge35:
;dspic.c,87 :: 		if (INT2_TRIGGER_EDGE == NEGATIVE_EDGE) {
	CLR.B	W0
	BTSC	INTCON2, #2
	INC.B	W0
	CP.B	W0, #1
	BRA Z	L__switchExternalInterruptEdge220
	GOTO	L_switchExternalInterruptEdge36
L__switchExternalInterruptEdge220:
;dspic.c,88 :: 		INT2_TRIGGER_EDGE = POSITIVE_EDGE;
	BCLR	INTCON2, #2
;dspic.c,89 :: 		} else {
	GOTO	L_switchExternalInterruptEdge37
L_switchExternalInterruptEdge36:
;dspic.c,90 :: 		INT2_TRIGGER_EDGE = NEGATIVE_EDGE;
	BSET	INTCON2, #2
;dspic.c,91 :: 		}
L_switchExternalInterruptEdge37:
;dspic.c,92 :: 		break;
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,99 :: 		default:
L_switchExternalInterruptEdge38:
;dspic.c,100 :: 		break;
	GOTO	L_switchExternalInterruptEdge28
;dspic.c,101 :: 		}
L_switchExternalInterruptEdge27:
	CP.B	W10, #4
	BRA NZ	L__switchExternalInterruptEdge221
	GOTO	L_switchExternalInterruptEdge29
L__switchExternalInterruptEdge221:
	CP.B	W10, #5
	BRA NZ	L__switchExternalInterruptEdge222
	GOTO	L_switchExternalInterruptEdge32
L__switchExternalInterruptEdge222:
	CP.B	W10, #6
	BRA NZ	L__switchExternalInterruptEdge223
	GOTO	L_switchExternalInterruptEdge35
L__switchExternalInterruptEdge223:
	GOTO	L_switchExternalInterruptEdge38
L_switchExternalInterruptEdge28:
;dspic.c,102 :: 		}
L_end_switchExternalInterruptEdge:
	RETURN
; end of _switchExternalInterruptEdge

_getExternalInterruptEdge:

;dspic.c,104 :: 		char getExternalInterruptEdge(unsigned char device) {
;dspic.c,105 :: 		switch (device) {
	GOTO	L_getExternalInterruptEdge39
;dspic.c,106 :: 		case INT0_DEVICE:
L_getExternalInterruptEdge41:
;dspic.c,107 :: 		return INT0_TRIGGER_EDGE;
	CLR.B	W0
	BTSC	INTCON2, #0
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,108 :: 		case INT1_DEVICE:
L_getExternalInterruptEdge42:
;dspic.c,109 :: 		return INT1_TRIGGER_EDGE;
	CLR.B	W0
	BTSC	INTCON2, #1
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,110 :: 		case INT2_DEVICE:
L_getExternalInterruptEdge43:
;dspic.c,111 :: 		return INT2_TRIGGER_EDGE;
	CLR.B	W0
	BTSC	INTCON2, #2
	INC.B	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,114 :: 		default:
L_getExternalInterruptEdge44:
;dspic.c,115 :: 		return 0;
	CLR	W0
	GOTO	L_end_getExternalInterruptEdge
;dspic.c,116 :: 		}
L_getExternalInterruptEdge39:
	CP.B	W10, #4
	BRA NZ	L__getExternalInterruptEdge225
	GOTO	L_getExternalInterruptEdge41
L__getExternalInterruptEdge225:
	CP.B	W10, #5
	BRA NZ	L__getExternalInterruptEdge226
	GOTO	L_getExternalInterruptEdge42
L__getExternalInterruptEdge226:
	CP.B	W10, #6
	BRA NZ	L__getExternalInterruptEdge227
	GOTO	L_getExternalInterruptEdge43
L__getExternalInterruptEdge227:
	GOTO	L_getExternalInterruptEdge44
;dspic.c,117 :: 		}
L_end_getExternalInterruptEdge:
	RETURN
; end of _getExternalInterruptEdge

_clearExternalInterrupt:

;dspic.c,119 :: 		void clearExternalInterrupt(unsigned char device) {
;dspic.c,120 :: 		switch (device) {
	GOTO	L_clearExternalInterrupt45
;dspic.c,121 :: 		case INT0_DEVICE:
L_clearExternalInterrupt47:
;dspic.c,122 :: 		INT0_OCCURRED = FALSE;
	BCLR	IFS0, #0
;dspic.c,123 :: 		break;
	GOTO	L_clearExternalInterrupt46
;dspic.c,124 :: 		case INT1_DEVICE:
L_clearExternalInterrupt48:
;dspic.c,125 :: 		INT1_OCCURRED = FALSE;
	BCLR	IFS1, #0
;dspic.c,126 :: 		break;
	GOTO	L_clearExternalInterrupt46
;dspic.c,127 :: 		case INT2_DEVICE:
L_clearExternalInterrupt49:
;dspic.c,128 :: 		INT2_OCCURRED = FALSE;
	BCLR	IFS1, #7
;dspic.c,129 :: 		break;
	GOTO	L_clearExternalInterrupt46
;dspic.c,132 :: 		default:
L_clearExternalInterrupt50:
;dspic.c,133 :: 		break;
	GOTO	L_clearExternalInterrupt46
;dspic.c,134 :: 		}
L_clearExternalInterrupt45:
	CP.B	W10, #4
	BRA NZ	L__clearExternalInterrupt229
	GOTO	L_clearExternalInterrupt47
L__clearExternalInterrupt229:
	CP.B	W10, #5
	BRA NZ	L__clearExternalInterrupt230
	GOTO	L_clearExternalInterrupt48
L__clearExternalInterrupt230:
	CP.B	W10, #6
	BRA NZ	L__clearExternalInterrupt231
	GOTO	L_clearExternalInterrupt49
L__clearExternalInterrupt231:
	GOTO	L_clearExternalInterrupt50
L_clearExternalInterrupt46:
;dspic.c,135 :: 		}
L_end_clearExternalInterrupt:
	RETURN
; end of _clearExternalInterrupt

_setTimer:

;dspic.c,137 :: 		void setTimer(unsigned char device, double timePeriod) {
;dspic.c,139 :: 		setInterruptPriority(device, MEDIUM_PRIORITY);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W11
	PUSH	W12
	MOV.B	#4, W11
	CALL	_setInterruptPriority
	POP	W12
	POP	W11
;dspic.c,141 :: 		prescalerIndex = getTimerPrescaler(timePeriod);
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
;dspic.c,142 :: 		switch (device) {
	GOTO	L_setTimer51
;dspic.c,143 :: 		case TIMER1_DEVICE:
L_setTimer53:
;dspic.c,144 :: 		TIMER1_PRESCALER = prescalerIndex;
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
;dspic.c,145 :: 		TIMER1_PERIOD = getTimerPeriod(timePeriod, prescalerIndex);
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR1
;dspic.c,146 :: 		TIMER1_ENABLE_INTERRUPT = TRUE;
	BSET	IEC0bits, #3
;dspic.c,147 :: 		TIMER1_ENABLE = TRUE;
	BSET	T1CONbits, #15
;dspic.c,148 :: 		break;
	GOTO	L_setTimer52
;dspic.c,149 :: 		case TIMER2_DEVICE:
L_setTimer54:
;dspic.c,150 :: 		TIMER2_PRESCALER = prescalerIndex;
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
;dspic.c,151 :: 		TIMER2_PERIOD = getTimerPeriod(timePeriod, prescalerIndex);
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR2
;dspic.c,152 :: 		TIMER2_ENABLE_INTERRUPT = TRUE;
	BSET	IEC0bits, #6
;dspic.c,153 :: 		TIMER2_ENABLE = TRUE;
	BSET	T2CONbits, #15
;dspic.c,154 :: 		break;
	GOTO	L_setTimer52
;dspic.c,155 :: 		case TIMER4_DEVICE:
L_setTimer55:
;dspic.c,156 :: 		TIMER4_PRESCALER = prescalerIndex;
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
;dspic.c,157 :: 		TIMER4_PERIOD = getTimerPeriod(timePeriod, prescalerIndex);
	MOV	W11, W10
	MOV	W12, W11
; prescalerIndex end address is: 8 (W4)
	MOV.B	W4, W12
	CALL	_getTimerPeriod
	MOV	WREG, PR4
;dspic.c,158 :: 		TIMER4_ENABLE_INTERRUPT = TRUE;
	BSET	IEC1bits, #5
;dspic.c,159 :: 		TIMER4_ENABLE = TRUE;
	BSET	T4CONbits, #15
;dspic.c,160 :: 		break;
	GOTO	L_setTimer52
;dspic.c,161 :: 		}
L_setTimer51:
; prescalerIndex start address is: 8 (W4)
	CP.B	W10, #1
	BRA NZ	L__setTimer233
	GOTO	L_setTimer53
L__setTimer233:
	CP.B	W10, #2
	BRA NZ	L__setTimer234
	GOTO	L_setTimer54
L__setTimer234:
	CP.B	W10, #3
	BRA NZ	L__setTimer235
	GOTO	L_setTimer55
L__setTimer235:
; prescalerIndex end address is: 8 (W4)
L_setTimer52:
;dspic.c,162 :: 		}
L_end_setTimer:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _setTimer

_clearTimer:

;dspic.c,164 :: 		void clearTimer(unsigned char device) {
;dspic.c,165 :: 		switch (device) {
	GOTO	L_clearTimer56
;dspic.c,166 :: 		case TIMER1_DEVICE:
L_clearTimer58:
;dspic.c,167 :: 		TIMER1_OCCURRED = FALSE;
	BCLR	IFS0bits, #3
;dspic.c,168 :: 		break;
	GOTO	L_clearTimer57
;dspic.c,169 :: 		case TIMER2_DEVICE:
L_clearTimer59:
;dspic.c,170 :: 		TIMER2_OCCURRED = FALSE;
	BCLR	IFS0bits, #6
;dspic.c,171 :: 		break;
	GOTO	L_clearTimer57
;dspic.c,172 :: 		case TIMER4_DEVICE:
L_clearTimer60:
;dspic.c,173 :: 		TIMER4_OCCURRED = FALSE;
	BCLR	IFS1bits, #5
;dspic.c,174 :: 		break;
	GOTO	L_clearTimer57
;dspic.c,175 :: 		}
L_clearTimer56:
	CP.B	W10, #1
	BRA NZ	L__clearTimer237
	GOTO	L_clearTimer58
L__clearTimer237:
	CP.B	W10, #2
	BRA NZ	L__clearTimer238
	GOTO	L_clearTimer59
L__clearTimer238:
	CP.B	W10, #3
	BRA NZ	L__clearTimer239
	GOTO	L_clearTimer60
L__clearTimer239:
L_clearTimer57:
;dspic.c,176 :: 		}
L_end_clearTimer:
	RETURN
; end of _clearTimer

_turnOnTimer:

;dspic.c,178 :: 		void turnOnTimer(unsigned char device) {
;dspic.c,179 :: 		switch (device) {
	GOTO	L_turnOnTimer61
;dspic.c,180 :: 		case TIMER1_DEVICE:
L_turnOnTimer63:
;dspic.c,181 :: 		TIMER1_ENABLE = TRUE;
	BSET	T1CONbits, #15
;dspic.c,182 :: 		break;
	GOTO	L_turnOnTimer62
;dspic.c,183 :: 		case TIMER2_DEVICE:
L_turnOnTimer64:
;dspic.c,184 :: 		TIMER2_ENABLE = TRUE;
	BSET	T2CONbits, #15
;dspic.c,185 :: 		break;
	GOTO	L_turnOnTimer62
;dspic.c,186 :: 		case TIMER4_DEVICE:
L_turnOnTimer65:
;dspic.c,187 :: 		TIMER4_ENABLE = TRUE;
	BSET	T4CONbits, #15
;dspic.c,188 :: 		break;
	GOTO	L_turnOnTimer62
;dspic.c,189 :: 		}
L_turnOnTimer61:
	CP.B	W10, #1
	BRA NZ	L__turnOnTimer241
	GOTO	L_turnOnTimer63
L__turnOnTimer241:
	CP.B	W10, #2
	BRA NZ	L__turnOnTimer242
	GOTO	L_turnOnTimer64
L__turnOnTimer242:
	CP.B	W10, #3
	BRA NZ	L__turnOnTimer243
	GOTO	L_turnOnTimer65
L__turnOnTimer243:
L_turnOnTimer62:
;dspic.c,190 :: 		}
L_end_turnOnTimer:
	RETURN
; end of _turnOnTimer

_turnOffTimer:

;dspic.c,192 :: 		void turnOffTimer(unsigned char device) {
;dspic.c,193 :: 		switch (device) {
	GOTO	L_turnOffTimer66
;dspic.c,194 :: 		case TIMER1_DEVICE:
L_turnOffTimer68:
;dspic.c,195 :: 		TIMER1_ENABLE = FALSE;
	BCLR	T1CONbits, #15
;dspic.c,196 :: 		break;
	GOTO	L_turnOffTimer67
;dspic.c,197 :: 		case TIMER2_DEVICE:
L_turnOffTimer69:
;dspic.c,198 :: 		TIMER2_ENABLE = FALSE;
	BCLR	T2CONbits, #15
;dspic.c,199 :: 		break;
	GOTO	L_turnOffTimer67
;dspic.c,200 :: 		case TIMER4_DEVICE:
L_turnOffTimer70:
;dspic.c,201 :: 		TIMER4_ENABLE = FALSE;
	BCLR	T4CONbits, #15
;dspic.c,202 :: 		break;
	GOTO	L_turnOffTimer67
;dspic.c,203 :: 		}
L_turnOffTimer66:
	CP.B	W10, #1
	BRA NZ	L__turnOffTimer245
	GOTO	L_turnOffTimer68
L__turnOffTimer245:
	CP.B	W10, #2
	BRA NZ	L__turnOffTimer246
	GOTO	L_turnOffTimer69
L__turnOffTimer246:
	CP.B	W10, #3
	BRA NZ	L__turnOffTimer247
	GOTO	L_turnOffTimer70
L__turnOffTimer247:
L_turnOffTimer67:
;dspic.c,204 :: 		}
L_end_turnOffTimer:
	RETURN
; end of _turnOffTimer

_getTimerPeriod:
	LNK	#8

;dspic.c,206 :: 		unsigned int getTimerPeriod(double timePeriod, unsigned char prescalerIndex) {
;dspic.c,207 :: 		return (unsigned int) ((timePeriod * 1000000) / (INSTRUCTION_PERIOD * PRESCALER_VALUES[prescalerIndex]));
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
;dspic.c,208 :: 		}
L_end_getTimerPeriod:
	ULNK
	RETURN
; end of _getTimerPeriod

_getTimerPrescaler:

;dspic.c,210 :: 		unsigned char getTimerPrescaler(double timePeriod) {
;dspic.c,213 :: 		exactTimerPrescaler = getExactTimerPrescaler(timePeriod);
	CALL	_getExactTimerPrescaler
; exactTimerPrescaler start address is: 8 (W4)
	MOV.D	W0, W4
;dspic.c,214 :: 		for (i = 0; i < sizeof(PRESCALER_VALUES); i += 1) {
; i start address is: 6 (W3)
	CLR	W3
; i end address is: 6 (W3)
L_getTimerPrescaler71:
; i start address is: 6 (W3)
; exactTimerPrescaler start address is: 8 (W4)
; exactTimerPrescaler end address is: 8 (W4)
	CP.B	W3, #8
	BRA LTU	L__getTimerPrescaler250
	GOTO	L_getTimerPrescaler72
L__getTimerPrescaler250:
; exactTimerPrescaler end address is: 8 (W4)
;dspic.c,215 :: 		if ((int) exactTimerPrescaler < PRESCALER_VALUES[i]) {
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
	BRA LTU	L__getTimerPrescaler251
	GOTO	L_getTimerPrescaler74
L__getTimerPrescaler251:
; exactTimerPrescaler end address is: 8 (W4)
;dspic.c,216 :: 		return i;
	MOV.B	W3, W0
; i end address is: 6 (W3)
	GOTO	L_end_getTimerPrescaler
;dspic.c,217 :: 		}
L_getTimerPrescaler74:
;dspic.c,214 :: 		for (i = 0; i < sizeof(PRESCALER_VALUES); i += 1) {
; i start address is: 0 (W0)
; exactTimerPrescaler start address is: 8 (W4)
; i start address is: 6 (W3)
	ADD.B	W3, #1, W0
; i end address is: 6 (W3)
;dspic.c,218 :: 		}
; exactTimerPrescaler end address is: 8 (W4)
; i end address is: 0 (W0)
	MOV.B	W0, W3
	GOTO	L_getTimerPrescaler71
L_getTimerPrescaler72:
;dspic.c,219 :: 		i -= 1;
; i start address is: 6 (W3)
	ZE	W3, W0
; i end address is: 6 (W3)
	DEC	W0
;dspic.c,221 :: 		return i;
;dspic.c,222 :: 		}
L_end_getTimerPrescaler:
	RETURN
; end of _getTimerPrescaler

_getExactTimerPrescaler:

;dspic.c,224 :: 		double getExactTimerPrescaler(double timePeriod) {
;dspic.c,225 :: 		return (timePeriod * 1000000) / (INSTRUCTION_PERIOD * MAX_TIMER_PERIOD_VALUE);
	MOV.D	W10, W0
	MOV	#9216, W2
	MOV	#18804, W3
	CALL	__Mul_FP
	MOV	#65280, W2
	MOV	#17919, W3
	CALL	__Div_FP
;dspic.c,226 :: 		}
L_end_getExactTimerPrescaler:
	RETURN
; end of _getExactTimerPrescaler

_setupAnalogSampling:

;dspic.c,228 :: 		void setupAnalogSampling(void) {
;dspic.c,229 :: 		ANALOG_CONVERSION_TRIGGER_SOURCE = ACTS_AUTOMATIC;
	PUSH	W10
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	W1, [W0]
;dspic.c,230 :: 		ANALOG_DATA_OUTPUT_FORMAT = ADOF_UNSIGNED_INTEGER;
	MOV	ADCON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, ADCON1bits
;dspic.c,231 :: 		ANALOG_IDLE_ENABLE = FALSE;
	BCLR	ADCON1bits, #13
;dspic.c,232 :: 		ANALOG_CH0_SCAN_ENABLE = TRUE;
	BSET	ADCON2bits, #10
;dspic.c,233 :: 		ANALOG_BUFFER_SIZE = ABS_16BIT;
	BCLR	ADCON2bits, #1
;dspic.c,234 :: 		ANALOG_ENABLE_ALTERNATING_MULTIPLEXER = FALSE;
	BCLR	ADCON2bits, #0
;dspic.c,235 :: 		ANALOG_CLOCK_SOURCE = ACS_EXTERNAL;
	BCLR	ADCON3bits, #7
;dspic.c,236 :: 		ANALOG_CHANNEL_B_NEGATIVE_INPUT = ACNI_VREF;
	BCLR	ADCHSbits, #12
;dspic.c,237 :: 		ANALOG_CHANNEL_A_NEGATIVE_INPUT = ACNI_VREF;
	BCLR	ADCHSbits, #4
;dspic.c,238 :: 		ANALOG_CHANNEL_B_POSITIVE_INPUT = 0;
	MOV	ADCHSbits, W1
	MOV	#61695, W0
	AND	W1, W0, W0
	MOV	WREG, ADCHSbits
;dspic.c,239 :: 		ANALOG_CHANNEL_A_POSITIVE_INPUT = 0;
	MOV	#lo_addr(ADCHSbits), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(ADCHSbits), W0
	MOV.B	W1, [W0]
;dspic.c,242 :: 		ANALOG_CLOCK_CONVERSION = getMinimumAnalogClockConversion();
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
;dspic.c,243 :: 		ANALOG_AUTOMATIC_SAMPLING_TADS_INTERVAL = 1;
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, ADCON3bits
;dspic.c,245 :: 		ANALOG_MODE_PORT = 0b1111111111111111; //All analog inputs are disabled
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;dspic.c,246 :: 		ANALOG_SCAN_PORT = 0; //Skipping pin scan
	CLR	ADCSSL
;dspic.c,248 :: 		setAutomaticSampling();
	CALL	_setAutomaticSampling
;dspic.c,249 :: 		setAnalogVoltageReference(AVR_AVDD_AVSS);
	CLR	W10
	CALL	_setAnalogVoltageReference
;dspic.c,250 :: 		unsetAnalogInterrupt();
	CALL	_unsetAnalogInterrupt
;dspic.c,251 :: 		startSampling();
	CALL	_startSampling
;dspic.c,252 :: 		}
L_end_setupAnalogSampling:
	POP	W10
	RETURN
; end of _setupAnalogSampling

_turnOnAnalogModule:

;dspic.c,254 :: 		void turnOnAnalogModule() {
;dspic.c,255 :: 		ANALOG_SAMPLING_ENABLE = TRUE;
	BSET	ADCON1bits, #15
;dspic.c,256 :: 		}
L_end_turnOnAnalogModule:
	RETURN
; end of _turnOnAnalogModule

_turnOffAnalogModule:

;dspic.c,258 :: 		void turnOffAnalogModule() {
;dspic.c,259 :: 		ANALOG_SAMPLING_ENABLE = FALSE;
	BCLR	ADCON1bits, #15
;dspic.c,260 :: 		}
L_end_turnOffAnalogModule:
	RETURN
; end of _turnOffAnalogModule

_startSampling:

;dspic.c,262 :: 		void startSampling(void) {
;dspic.c,263 :: 		ANALOG_SAMPLING_STATUS = TRUE;
	BSET	ADCON1bits, #1
;dspic.c,264 :: 		}
L_end_startSampling:
	RETURN
; end of _startSampling

_getAnalogValue:

;dspic.c,266 :: 		unsigned int getAnalogValue(void) {
;dspic.c,267 :: 		return ANALOG_BUFFER0;
	MOV	ADCBUF0, WREG
;dspic.c,268 :: 		}
L_end_getAnalogValue:
	RETURN
; end of _getAnalogValue

_setAnalogPIN:

;dspic.c,270 :: 		void setAnalogPIN(unsigned char pin) {
;dspic.c,271 :: 		ANALOG_MODE_PORT = ANALOG_MODE_PORT & ~(int) (TRUE << pin);
	ZE	W10, W1
	MOV	#1, W0
	SL	W0, W1, W2
	MOV	W2, W0
	COM	W0, W1
	MOV	#lo_addr(ADPCFG), W0
	AND	W1, [W0], [W0]
;dspic.c,272 :: 		ANALOG_SCAN_PORT = ANALOG_SCAN_PORT | (TRUE << pin);
	MOV	#lo_addr(ADCSSL), W0
	IOR	W2, [W0], [W0]
;dspic.c,273 :: 		}
L_end_setAnalogPIN:
	RETURN
; end of _setAnalogPIN

_unsetAnalogPIN:

;dspic.c,275 :: 		void unsetAnalogPIN(unsigned char pin) {
;dspic.c,276 :: 		ANALOG_MODE_PORT = ANALOG_MODE_PORT | (TRUE << pin);
	ZE	W10, W1
	MOV	#1, W0
	SL	W0, W1, W1
	MOV	#lo_addr(ADPCFG), W0
	IOR	W1, [W0], [W0]
;dspic.c,277 :: 		ANALOG_SCAN_PORT = ANALOG_SCAN_PORT & ~(int) (TRUE << pin);
	MOV	W1, W0
	COM	W0, W1
	MOV	#lo_addr(ADCSSL), W0
	AND	W1, [W0], [W0]
;dspic.c,278 :: 		}
L_end_unsetAnalogPIN:
	RETURN
; end of _unsetAnalogPIN

_setAnalogInterrupt:

;dspic.c,280 :: 		void setAnalogInterrupt(void) {
;dspic.c,281 :: 		clearAnalogInterrupt();
	CALL	_clearAnalogInterrupt
;dspic.c,282 :: 		ANALOG_INTERRUPT_ENABLE = TRUE;
	BSET	IEC0bits, #11
;dspic.c,283 :: 		}
L_end_setAnalogInterrupt:
	RETURN
; end of _setAnalogInterrupt

_unsetAnalogInterrupt:

;dspic.c,285 :: 		void unsetAnalogInterrupt(void) {
;dspic.c,286 :: 		clearAnalogInterrupt();
	CALL	_clearAnalogInterrupt
;dspic.c,287 :: 		ANALOG_INTERRUPT_ENABLE = FALSE;
	BCLR	IEC0bits, #11
;dspic.c,288 :: 		}
L_end_unsetAnalogInterrupt:
	RETURN
; end of _unsetAnalogInterrupt

_clearAnalogInterrupt:

;dspic.c,290 :: 		void clearAnalogInterrupt(void) {
;dspic.c,291 :: 		ANALOG_INTERRUPT_OCCURRED = FALSE;
	BCLR	IFS0bits, #11
;dspic.c,292 :: 		}
L_end_clearAnalogInterrupt:
	RETURN
; end of _clearAnalogInterrupt

_setAutomaticSampling:

;dspic.c,294 :: 		void setAutomaticSampling(void) {
;dspic.c,295 :: 		AUTOMATIC_SAMPLING = TRUE;
	BSET	ADCON1bits, #2
;dspic.c,296 :: 		}
L_end_setAutomaticSampling:
	RETURN
; end of _setAutomaticSampling

_unsetAutomaticSampling:

;dspic.c,298 :: 		void unsetAutomaticSampling(void) {
;dspic.c,299 :: 		AUTOMATIC_SAMPLING = FALSE;
	BCLR	ADCON1bits, #2
;dspic.c,300 :: 		}
L_end_unsetAutomaticSampling:
	RETURN
; end of _unsetAutomaticSampling

_setAnalogVoltageReference:

;dspic.c,302 :: 		void setAnalogVoltageReference(unsigned char mode) {
;dspic.c,303 :: 		ANALOG_VOLTAGE_REFERENCE = mode;
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
;dspic.c,304 :: 		}
L_end_setAnalogVoltageReference:
	RETURN
; end of _setAnalogVoltageReference

_setAnalogDataOutputFormat:

;dspic.c,306 :: 		void setAnalogDataOutputFormat(unsigned char adof) {
;dspic.c,307 :: 		ANALOG_DATA_OUTPUT_FORMAT = adof;
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
;dspic.c,308 :: 		}
L_end_setAnalogDataOutputFormat:
	RETURN
; end of _setAnalogDataOutputFormat

_getMinimumAnalogClockConversion:

;dspic.c,310 :: 		int getMinimumAnalogClockConversion(void) {
;dspic.c,311 :: 		return (int) ((MINIMUM_TAD_PERIOD * OSC_FREQ_MHZ) / 500.0);
	MOV	#9, W0
;dspic.c,312 :: 		}
L_end_getMinimumAnalogClockConversion:
	RETURN
; end of _getMinimumAnalogClockConversion

_EEPROM_writeInt:

;eeprom.c,7 :: 		void EEPROM_writeInt(unsigned int address, unsigned int value) {
;eeprom.c,11 :: 		EEPROM_write(address, value);
	PUSH	W12
	MOV	W11, W12
	CLR	W11
	CALL	_EEPROM_Write
;eeprom.c,12 :: 		while(WR_bit);
L_EEPROM_writeInt75:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EEPROM_writeInt76
	GOTO	L_EEPROM_writeInt75
L_EEPROM_writeInt76:
;eeprom.c,14 :: 		}
L_end_EEPROM_writeInt:
	POP	W12
	RETURN
; end of _EEPROM_writeInt

_EEPROM_readInt:

;eeprom.c,16 :: 		unsigned int EEPROM_readInt(unsigned int address) {
;eeprom.c,17 :: 		return EEPROM_read(address);
	CLR	W11
	CALL	_EEPROM_Read
;eeprom.c,18 :: 		}
L_end_EEPROM_readInt:
	RETURN
; end of _EEPROM_readInt

_EEPROM_writeArray:

;eeprom.c,20 :: 		void EEPROM_writeArray(unsigned int address, unsigned int *values) {
;eeprom.c,22 :: 		for (i = 0; i < sizeof(values); i += 1) {
; i start address is: 2 (W1)
	CLR	W1
; i end address is: 2 (W1)
L_EEPROM_writeArray77:
; i start address is: 2 (W1)
	CP	W1, #2
	BRA LTU	L__EEPROM_writeArray271
	GOTO	L_EEPROM_writeArray78
L__EEPROM_writeArray271:
;eeprom.c,23 :: 		EEPROM_writeInt(address, values[i]);
	SL	W1, #1, W0
	ADD	W11, W0, W0
	PUSH	W11
	MOV	[W0], W11
	CALL	_EEPROM_writeInt
	POP	W11
;eeprom.c,22 :: 		for (i = 0; i < sizeof(values); i += 1) {
	INC	W1
;eeprom.c,24 :: 		}
; i end address is: 2 (W1)
	GOTO	L_EEPROM_writeArray77
L_EEPROM_writeArray78:
;eeprom.c,25 :: 		}
L_end_EEPROM_writeArray:
	RETURN
; end of _EEPROM_writeArray

_EEPROM_readArray:
	LNK	#2

;eeprom.c,27 :: 		void EEPROM_readArray(unsigned int address, unsigned int *values) {
;eeprom.c,29 :: 		for (i = 0; i < sizeof(values); i += 1) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_EEPROM_readArray80:
; i start address is: 4 (W2)
	CP	W2, #2
	BRA LTU	L__EEPROM_readArray273
	GOTO	L_EEPROM_readArray81
L__EEPROM_readArray273:
;eeprom.c,30 :: 		values[i] = EEPROM_read(address + i);
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
;eeprom.c,29 :: 		for (i = 0; i < sizeof(values); i += 1) {
	INC	W2
;eeprom.c,31 :: 		}
; i end address is: 4 (W2)
	GOTO	L_EEPROM_readArray80
L_EEPROM_readArray81:
;eeprom.c,32 :: 		}
L_end_EEPROM_readArray:
	ULNK
	RETURN
; end of _EEPROM_readArray

_CAN_routine:

;ebb_can_functions.c,4 :: 		void CAN_routine()  //CAN update routine
;ebb_can_functions.c,6 :: 		Can_resetWritePacket();  //Build the can packet -->
	PUSH	W10
	PUSH	W11
	CALL	_Can_resetWritePacket
;ebb_can_functions.c,7 :: 		Can_addIntToWritePacket(ebb_current_pos);
	MOV	_ebb_current_pos, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,8 :: 		Can_addIntToWritePacket(calibration_on_off);
	MOV	_calibration_on_off, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,9 :: 		Can_addIntToWritePacket(error_flag);
	MOV	_error_flag, W10
	CALL	_Can_addIntToWritePacket
;ebb_can_functions.c,10 :: 		Can_write(EBB_BIAS_ID);  //Send the can packet
	MOV	#1805, W10
	MOV	#0, W11
	CALL	_Can_write
;ebb_can_functions.c,11 :: 		}
L_end_CAN_routine:
	POP	W11
	POP	W10
	RETURN
; end of _CAN_routine

_Debug_UART_Write:

;motor.c,8 :: 		void Debug_UART_Write(char* text){
;motor.c,9 :: 		UART1_Write_Text(text);
	CALL	_UART1_Write_Text
;motor.c,10 :: 		}
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

;motor.c,14 :: 		void counter_quarter_turn_match() iv IVT_ADDR_QEIINTERRUPT ics ICS_AUTO {       //interrupt on match of MAXCNT or on match on 0
;motor.c,15 :: 		switch(DIRECTION_REGISTER){
	GOTO	L_counter_quarter_turn_match83
;motor.c,16 :: 		case 0:  //negative direction
L_counter_quarter_turn_match85:
;motor.c,17 :: 		motor_current_position--;
	MOV	#1, W1
	MOV	#lo_addr(_motor_current_position), W0
	SUBR	W1, [W0], [W0]
;motor.c,18 :: 		break;
	GOTO	L_counter_quarter_turn_match84
;motor.c,19 :: 		case 1:  //positive direction
L_counter_quarter_turn_match86:
;motor.c,20 :: 		motor_current_position++;
	MOV	#1, W1
	MOV	#lo_addr(_motor_current_position), W0
	ADD	W1, [W0], [W0]
;motor.c,21 :: 		break;
	GOTO	L_counter_quarter_turn_match84
;motor.c,22 :: 		default:
L_counter_quarter_turn_match87:
;motor.c,23 :: 		break;
	GOTO	L_counter_quarter_turn_match84
;motor.c,24 :: 		}
L_counter_quarter_turn_match83:
	CLR.B	W0
	BTSC	UPDN_bit, BitPos(UPDN_bit+0)
	INC.B	W0
	CP.B	W0, #0
	BRA NZ	L__counter_quarter_turn_match277
	GOTO	L_counter_quarter_turn_match85
L__counter_quarter_turn_match277:
	CLR.B	W0
	BTSC	UPDN_bit, BitPos(UPDN_bit+0)
	INC.B	W0
	CP.B	W0, #1
	BRA NZ	L__counter_quarter_turn_match278
	GOTO	L_counter_quarter_turn_match86
L__counter_quarter_turn_match278:
	GOTO	L_counter_quarter_turn_match87
L_counter_quarter_turn_match84:
;motor.c,25 :: 		if (motor_current_position == motor_target_position)                        //Check for target reached
	MOV	_motor_current_position, W1
	MOV	#lo_addr(_motor_target_position), W0
	CP	W1, [W0]
	BRA Z	L__counter_quarter_turn_match279
	GOTO	L_counter_quarter_turn_match88
L__counter_quarter_turn_match279:
;motor.c,27 :: 		brake_counter = 0;                                                      //Reset the counter for braking period lenght
	MOV	#lo_addr(_brake_counter), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,28 :: 		REVERSE = OFF;                          //Shorts the motor terminals
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,29 :: 		FORWARD = OFF;
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,30 :: 		ebb_current_state = EBB_BRAKING;                                        //Set the current state
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;motor.c,31 :: 		}
L_counter_quarter_turn_match88:
;motor.c,32 :: 		IFS2bits.QEIIF = 0;                                                         //Reset Interrupt Flag
	BCLR	IFS2bits, #8
;motor.c,33 :: 		}
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

;motor.c,37 :: 		void EBB_control()
;motor.c,39 :: 		switch(ebb_current_state)           //State machine
	PUSH	W10
	PUSH	W11
	PUSH	W12
	GOTO	L_EBB_control89
;motor.c,41 :: 		case EBB_OFF:                      //Off state
L_EBB_control91:
;motor.c,42 :: 		if(is_requested_movement)       //Check if the EBB is requested to move in a different position
	MOV	#lo_addr(_is_requested_movement), W0
	CP0.B	[W0]
	BRA NZ	L__EBB_control281
	GOTO	L_EBB_control92
L__EBB_control281:
;motor.c,44 :: 		switch(ebb_target_pos)  //Obtain the requested position in quarter of turns (maybe to be improved!!)
	GOTO	L_EBB_control93
;motor.c,46 :: 		case 0:
L_EBB_control95:
;motor.c,47 :: 		motor_target_position = POSITION_0;
	CLR	W0
	MOV	W0, _motor_target_position
;motor.c,48 :: 		break;
	GOTO	L_EBB_control94
;motor.c,49 :: 		case 1:
L_EBB_control96:
;motor.c,50 :: 		motor_target_position = POSITION_1;
	MOV	#2, W0
	MOV	W0, _motor_target_position
;motor.c,51 :: 		break;
	GOTO	L_EBB_control94
;motor.c,52 :: 		case 2:
L_EBB_control97:
;motor.c,53 :: 		motor_target_position = POSITION_2;
	MOV	#4, W0
	MOV	W0, _motor_target_position
;motor.c,54 :: 		break;
	GOTO	L_EBB_control94
;motor.c,55 :: 		case 3:
L_EBB_control98:
;motor.c,56 :: 		motor_target_position = POSITION_3;
	MOV	#6, W0
	MOV	W0, _motor_target_position
;motor.c,57 :: 		break;
	GOTO	L_EBB_control94
;motor.c,58 :: 		case 4:
L_EBB_control99:
;motor.c,59 :: 		motor_target_position = POSITION_4;
	MOV	#8, W0
	MOV	W0, _motor_target_position
;motor.c,60 :: 		break;
	GOTO	L_EBB_control94
;motor.c,61 :: 		case 5:
L_EBB_control100:
;motor.c,62 :: 		motor_target_position = POSITION_5;
	MOV	#10, W0
	MOV	W0, _motor_target_position
;motor.c,63 :: 		break;
	GOTO	L_EBB_control94
;motor.c,64 :: 		case 6:
L_EBB_control101:
;motor.c,65 :: 		motor_target_position = POSITION_6;
	MOV	#12, W0
	MOV	W0, _motor_target_position
;motor.c,66 :: 		break;
	GOTO	L_EBB_control94
;motor.c,67 :: 		case 7:
L_EBB_control102:
;motor.c,68 :: 		motor_target_position = POSITION_7;
	MOV	#14, W0
	MOV	W0, _motor_target_position
;motor.c,69 :: 		break;
	GOTO	L_EBB_control94
;motor.c,70 :: 		case 8:
L_EBB_control103:
;motor.c,71 :: 		motor_target_position = POSITION_8;
	MOV	#16, W0
	MOV	W0, _motor_target_position
;motor.c,72 :: 		break;
	GOTO	L_EBB_control94
;motor.c,73 :: 		case 9:
L_EBB_control104:
;motor.c,74 :: 		motor_target_position = POSITION_9;
	MOV	#18, W0
	MOV	W0, _motor_target_position
;motor.c,75 :: 		break;
	GOTO	L_EBB_control94
;motor.c,76 :: 		case 10:
L_EBB_control105:
;motor.c,77 :: 		motor_target_position = POSITION_10;
	MOV	#20, W0
	MOV	W0, _motor_target_position
;motor.c,78 :: 		break;
	GOTO	L_EBB_control94
;motor.c,79 :: 		case 11:
L_EBB_control106:
;motor.c,80 :: 		motor_target_position = POSITION_11;
	MOV	#22, W0
	MOV	W0, _motor_target_position
;motor.c,81 :: 		break;
	GOTO	L_EBB_control94
;motor.c,82 :: 		case 12:
L_EBB_control107:
;motor.c,83 :: 		motor_target_position = POSITION_12;
	MOV	#24, W0
	MOV	W0, _motor_target_position
;motor.c,84 :: 		break;
	GOTO	L_EBB_control94
;motor.c,85 :: 		case 13:
L_EBB_control108:
;motor.c,86 :: 		motor_target_position = POSITION_13;
	MOV	#26, W0
	MOV	W0, _motor_target_position
;motor.c,87 :: 		break;
	GOTO	L_EBB_control94
;motor.c,88 :: 		case 14:
L_EBB_control109:
;motor.c,89 :: 		motor_target_position = POSITION_14;
	MOV	#28, W0
	MOV	W0, _motor_target_position
;motor.c,90 :: 		break;
	GOTO	L_EBB_control94
;motor.c,91 :: 		case 15:
L_EBB_control110:
;motor.c,92 :: 		motor_target_position = POSITION_15;
	MOV	#30, W0
	MOV	W0, _motor_target_position
;motor.c,93 :: 		break;
	GOTO	L_EBB_control94
;motor.c,94 :: 		case 16:
L_EBB_control111:
;motor.c,95 :: 		motor_target_position = POSITION_16;
	MOV	#32, W0
	MOV	W0, _motor_target_position
;motor.c,96 :: 		break;
	GOTO	L_EBB_control94
;motor.c,97 :: 		}
L_EBB_control93:
	MOV	_ebb_target_pos, W0
	CP	W0, #0
	BRA NZ	L__EBB_control282
	GOTO	L_EBB_control95
L__EBB_control282:
	MOV	_ebb_target_pos, W0
	CP	W0, #1
	BRA NZ	L__EBB_control283
	GOTO	L_EBB_control96
L__EBB_control283:
	MOV	_ebb_target_pos, W0
	CP	W0, #2
	BRA NZ	L__EBB_control284
	GOTO	L_EBB_control97
L__EBB_control284:
	MOV	_ebb_target_pos, W0
	CP	W0, #3
	BRA NZ	L__EBB_control285
	GOTO	L_EBB_control98
L__EBB_control285:
	MOV	_ebb_target_pos, W0
	CP	W0, #4
	BRA NZ	L__EBB_control286
	GOTO	L_EBB_control99
L__EBB_control286:
	MOV	_ebb_target_pos, W0
	CP	W0, #5
	BRA NZ	L__EBB_control287
	GOTO	L_EBB_control100
L__EBB_control287:
	MOV	_ebb_target_pos, W0
	CP	W0, #6
	BRA NZ	L__EBB_control288
	GOTO	L_EBB_control101
L__EBB_control288:
	MOV	_ebb_target_pos, W0
	CP	W0, #7
	BRA NZ	L__EBB_control289
	GOTO	L_EBB_control102
L__EBB_control289:
	MOV	_ebb_target_pos, W0
	CP	W0, #8
	BRA NZ	L__EBB_control290
	GOTO	L_EBB_control103
L__EBB_control290:
	MOV	_ebb_target_pos, W0
	CP	W0, #9
	BRA NZ	L__EBB_control291
	GOTO	L_EBB_control104
L__EBB_control291:
	MOV	_ebb_target_pos, W0
	CP	W0, #10
	BRA NZ	L__EBB_control292
	GOTO	L_EBB_control105
L__EBB_control292:
	MOV	_ebb_target_pos, W0
	CP	W0, #11
	BRA NZ	L__EBB_control293
	GOTO	L_EBB_control106
L__EBB_control293:
	MOV	_ebb_target_pos, W0
	CP	W0, #12
	BRA NZ	L__EBB_control294
	GOTO	L_EBB_control107
L__EBB_control294:
	MOV	_ebb_target_pos, W0
	CP	W0, #13
	BRA NZ	L__EBB_control295
	GOTO	L_EBB_control108
L__EBB_control295:
	MOV	_ebb_target_pos, W0
	CP	W0, #14
	BRA NZ	L__EBB_control296
	GOTO	L_EBB_control109
L__EBB_control296:
	MOV	_ebb_target_pos, W0
	CP	W0, #15
	BRA NZ	L__EBB_control297
	GOTO	L_EBB_control110
L__EBB_control297:
	MOV	_ebb_target_pos, W0
	CP	W0, #16
	BRA NZ	L__EBB_control298
	GOTO	L_EBB_control111
L__EBB_control298:
L_EBB_control94:
;motor.c,98 :: 		ebb_current_state = EBB_START;          //Set the correct new ebb state (start moving)
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;motor.c,99 :: 		is_requested_movement = OFF;            //Switch off flag
	MOV	#lo_addr(_is_requested_movement), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,100 :: 		}else if(is_requested_calibration)          //Check if ebb is requested to enter calibration mode
	GOTO	L_EBB_control112
L_EBB_control92:
	MOV	#lo_addr(_is_requested_calibration), W0
	CP0.B	[W0]
	BRA NZ	L__EBB_control299
	GOTO	L_EBB_control113
L__EBB_control299:
;motor.c,102 :: 		ebb_current_state = EBB_CENTRAL_CALIBRATION;        //Set the correct new ebb state (calibration)
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;motor.c,103 :: 		is_requested_calibration = OFF;                     //Switch off flag
	MOV	#lo_addr(_is_requested_calibration), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,104 :: 		}
L_EBB_control113:
L_EBB_control112:
;motor.c,105 :: 		break;
	GOTO	L_EBB_control90
;motor.c,106 :: 		case EBB_START:                                             //Start a movement mode
L_EBB_control114:
;motor.c,107 :: 		if(motor_target_position > motor_current_position)      //Check if is necessary to screw or unscrew the balance bar
	MOV	_motor_target_position, W1
	MOV	#lo_addr(_motor_current_position), W0
	CP	W1, [W0]
	BRA GT	L__EBB_control300
	GOTO	L_EBB_control115
L__EBB_control300:
;motor.c,109 :: 		FORWARD = ON;                                         //Unscrew
	BSET	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,110 :: 		REVERSE = OFF;
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,111 :: 		}else if (motor_target_position < motor_current_position)
	GOTO	L_EBB_control116
L_EBB_control115:
	MOV	_motor_target_position, W1
	MOV	#lo_addr(_motor_current_position), W0
	CP	W1, [W0]
	BRA LT	L__EBB_control301
	GOTO	L_EBB_control117
L__EBB_control301:
;motor.c,113 :: 		motor_target_position--;
	MOV	#1, W1
	MOV	#lo_addr(_motor_target_position), W0
	SUBR	W1, [W0], [W0]
;motor.c,114 :: 		REVERSE = ON;                                       //Screw
	BSET	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,115 :: 		FORWARD = OFF;
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,116 :: 		}
L_EBB_control117:
L_EBB_control116:
;motor.c,117 :: 		ENABLE = ON;                                            //Turn on H-bridge
	BSET	LATE2_bit, BitPos(LATE2_bit+0)
;motor.c,118 :: 		PDC1 = PWM_SATURATION;                                  //Put the pwm at maximum (disabled pwm control)
	MOV	#4000, W0
	MOV	WREG, PDC1
;motor.c,120 :: 		ebb_current_state = EBB_MOVING;                         //Update State
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;motor.c,121 :: 		break;
	GOTO	L_EBB_control90
;motor.c,122 :: 		case EBB_MOVING:                               //EBB is trying to reach the requested position
L_EBB_control118:
;motor.c,123 :: 		blink_counter++;
	MOV.B	#1, W1
	MOV	#lo_addr(_blink_counter), W0
	ADD.B	W1, [W0], [W0]
;motor.c,124 :: 		if(blink_counter >= 20)
	MOV	#lo_addr(_blink_counter), W0
	MOV.B	[W0], W0
	CP.B	W0, #20
	BRA GEU	L__EBB_control302
	GOTO	L_EBB_control119
L__EBB_control302:
;motor.c,126 :: 		LED_G = ~LED_G;                        //Signal that the motor is turning with a blincking green led
	BTG	LATD3_bit, BitPos(LATD3_bit+0)
;motor.c,127 :: 		blink_counter = 0;
	MOV	#lo_addr(_blink_counter), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,128 :: 		}
L_EBB_control119:
;motor.c,129 :: 		break;
	GOTO	L_EBB_control90
;motor.c,130 :: 		case EBB_BRAKING:                              //EBB has reached the position and is now bhraking the motor shorting it
L_EBB_control120:
;motor.c,131 :: 		LED_G = OFF;
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;motor.c,132 :: 		LED_B = ON;                             //Turn on Blue led to signal motor Braking mode
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;motor.c,134 :: 		if(brake_counter >= BRAKE_TIME_LENGHT)          //check if the Braking period has passed
	MOV	#lo_addr(_brake_counter), W0
	MOV.B	[W0], W0
	CP.B	W0, #30
	BRA GEU	L__EBB_control303
	GOTO	L_EBB_control121
L__EBB_control303:
;motor.c,136 :: 		ebb_current_state = EBB_POSITION_REACHED;
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;motor.c,137 :: 		}
L_EBB_control121:
;motor.c,138 :: 		break;
	GOTO	L_EBB_control90
;motor.c,139 :: 		case EBB_POSITION_REACHED:                                                  //The ebb has correctly reached th requested position
L_EBB_control122:
;motor.c,140 :: 		LED_B = OFF;
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;motor.c,141 :: 		ENABLE = OFF;
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;motor.c,142 :: 		REVERSE = OFF;                                                          //Turn off the motor
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;motor.c,143 :: 		FORWARD = OFF;
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;motor.c,144 :: 		ebb_current_pos = ebb_target_pos;                                       //Update ebb cuurent position with the reached one (for robustness)
	MOV	_ebb_target_pos, W0
	MOV	W0, _ebb_current_pos
;motor.c,145 :: 		motor_current_position = motor_target_position;                         //Update motor position with the reached one (for robustness)
	MOV	_motor_target_position, W0
	MOV	W0, _motor_current_position
;motor.c,146 :: 		EEPROM_WRITE(ADDR_LAST_POSCNT, POSCNT);
	MOV	POSCNT, W12
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,147 :: 		sprintf(dstr, "EEPROM: %u\r\n", POSCNT);
	PUSH	POSCNT
	MOV	#lo_addr(?lstr_1_EBB_DPX), W0
	PUSH	W0
	MOV	#lo_addr(_dstr), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
;motor.c,148 :: 		Debug_UART_Write(dstr);
	MOV	#lo_addr(_dstr), W10
	CALL	_Debug_UART_Write
;motor.c,149 :: 		while(WR_bit);                                                             //Update EEPROM data
L_EBB_control123:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control124
	GOTO	L_EBB_control123
L_EBB_control124:
;motor.c,150 :: 		EEPROM_WRITE(ADDR_LAST_NUMBER_QUARTER_TURNS, motor_current_position);
	MOV	_motor_current_position, W12
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,151 :: 		while(WR_bit);
L_EBB_control125:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control126
	GOTO	L_EBB_control125
L_EBB_control126:
;motor.c,152 :: 		EEPROM_WRITE(ADDR_LAST_MAPPED_POSITION, ebb_current_pos);
	MOV	_ebb_current_pos, W12
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,153 :: 		while(WR_bit);
L_EBB_control127:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control128
	GOTO	L_EBB_control127
L_EBB_control128:
;motor.c,154 :: 		ebb_current_state = OFF;                                               //Going back to OFF state
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,155 :: 		break;
	GOTO	L_EBB_control90
;motor.c,156 :: 		case EBB_CENTRAL_CALIBRATION:
L_EBB_control129:
;motor.c,157 :: 		ebb_current_pos = 8;
	MOV	#8, W0
	MOV	W0, _ebb_current_pos
;motor.c,158 :: 		ebb_target_pos = ebb_current_pos;
	MOV	#8, W0
	MOV	W0, _ebb_target_pos
;motor.c,159 :: 		motor_current_position = POSITION_8;
	MOV	#16, W0
	MOV	W0, _motor_current_position
;motor.c,160 :: 		motor_target_position = motor_current_position;
	MOV	#16, W0
	MOV	W0, _motor_target_position
;motor.c,161 :: 		EEPROM_WRITE(ADDR_LAST_POSCNT, POSCNT);
	MOV	POSCNT, W12
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,162 :: 		while(WR_bit);                                                           //Update EEPROM data
L_EBB_control130:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control131
	GOTO	L_EBB_control130
L_EBB_control131:
;motor.c,163 :: 		EEPROM_WRITE(ADDR_LAST_NUMBER_QUARTER_TURNS, motor_current_position);
	MOV	_motor_current_position, W12
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,164 :: 		while(WR_bit);
L_EBB_control132:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control133
	GOTO	L_EBB_control132
L_EBB_control133:
;motor.c,165 :: 		EEPROM_WRITE(ADDR_LAST_MAPPED_POSITION, ebb_current_pos);
	MOV	_ebb_current_pos, W12
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;motor.c,166 :: 		while(WR_bit);
L_EBB_control134:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_control135
	GOTO	L_EBB_control134
L_EBB_control135:
;motor.c,167 :: 		CAN_routine();
	CALL	_CAN_routine
;motor.c,168 :: 		calibration_on_off = OFF;
	CLR	W0
	MOV	W0, _calibration_on_off
;motor.c,169 :: 		ebb_current_state = OFF;                                               //Going back to OFF state
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;motor.c,170 :: 		break;
	GOTO	L_EBB_control90
;motor.c,171 :: 		case EBB_DRIVER_BRAKING:                            //Driver is braking during a requested movement
L_EBB_control136:
;motor.c,172 :: 		buzzer_state = ON;                                     //Turn on buzzer for debugging
	MOV	#1, W0
	MOV	W0, _buzzer_state
;motor.c,173 :: 		if(brake_pressure_front < BRAKE_PRESSURE_TRIGGER && current_reading_motor < LSB_CURRENT_READING * MOTOR_CURRENT_TRIGGER)           //Checking brake pressures for the end of the braking action
	MOV	_brake_pressure_front, W1
	MOV	#3500, W0
	CP	W1, W0
	BRA LTU	L__EBB_control304
	GOTO	L_EBB_control138
L__EBB_control304:
	MOV	_current_reading_motor, W0
	CP	W0, #1
	BRA LTU	L__EBB_control305
	GOTO	L_EBB_control138
L__EBB_control305:
	GOTO	L_EBB_control137
L_EBB_control138:
L_EBB_control137:
;motor.c,175 :: 		buzzer_state = OFF;
	CLR	W0
	MOV	W0, _buzzer_state
;motor.c,176 :: 		ebb_current_state = EBB_START;              //Return to start mode to complete the movement
	MOV	#lo_addr(_ebb_current_state), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;motor.c,178 :: 		break;
	GOTO	L_EBB_control90
;motor.c,179 :: 		}
L_EBB_control89:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__EBB_control306
	GOTO	L_EBB_control91
L__EBB_control306:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__EBB_control307
	GOTO	L_EBB_control114
L__EBB_control307:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__EBB_control308
	GOTO	L_EBB_control118
L__EBB_control308:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__EBB_control309
	GOTO	L_EBB_control120
L__EBB_control309:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA NZ	L__EBB_control310
	GOTO	L_EBB_control122
L__EBB_control310:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA NZ	L__EBB_control311
	GOTO	L_EBB_control129
L__EBB_control311:
	MOV	#lo_addr(_ebb_current_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #7
	BRA NZ	L__EBB_control312
	GOTO	L_EBB_control136
L__EBB_control312:
L_EBB_control90:
;motor.c,180 :: 		}
L_end_EBB_control:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _EBB_control

_EBB_Init:

;initialization.c,5 :: 		void EBB_Init()  //Initialize all hardware peripherals and software variables
;initialization.c,8 :: 		if(EEPROM_Read(ADDR_FIRST_BOOT) == 0xFFFF)                           //First boot initialization  (Central position)
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#64976, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#65535, W1
	CP	W0, W1
	BRA Z	L__EBB_Init314
	GOTO	L_EBB_Init140
L__EBB_Init314:
;initialization.c,10 :: 		EEPROM_WRITE(ADDR_LAST_POSCNT, 0);
	CLR	W12
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,11 :: 		while(WR_bit);
L_EBB_Init141:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init142
	GOTO	L_EBB_Init141
L_EBB_Init142:
;initialization.c,12 :: 		EEPROM_WRITE(ADDR_LAST_MAPPED_POSITION, 8);
	MOV	#8, W12
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,13 :: 		while(WR_bit);
L_EBB_Init143:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init144
	GOTO	L_EBB_Init143
L_EBB_Init144:
;initialization.c,14 :: 		EEPROM_WRITE(ADDR_LAST_NUMBER_QUARTER_TURNS, 16);
	MOV	#16, W12
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,15 :: 		while(WR_bit);
L_EBB_Init145:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init146
	GOTO	L_EBB_Init145
L_EBB_Init146:
;initialization.c,16 :: 		EEPROM_WRITE(ADDR_FIRST_BOOT, 0);
	CLR	W12
	MOV	#64976, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;initialization.c,17 :: 		while(WR_bit);
L_EBB_Init147:
	BTSS	WR_bit, BitPos(WR_bit+0)
	GOTO	L_EBB_Init148
	GOTO	L_EBB_Init147
L_EBB_Init148:
;initialization.c,18 :: 		}
L_EBB_Init140:
;initialization.c,20 :: 		ADPCFG = 0b1111111111111110;                    //analog input on AN0 (Current Sense)
	MOV	#65534, W0
	MOV	WREG, ADPCFG
;initialization.c,21 :: 		TRISDbits.TRISD1 = 0;                           //green led;
	BCLR.B	TRISDbits, #1
;initialization.c,22 :: 		TRISDbits.TRISD3 = 0;                           //blue led;
	BCLR.B	TRISDbits, #3
;initialization.c,23 :: 		TRISDbits.TRISD2 = 0;                           //buzzer;
	BCLR.B	TRISDbits, #2
;initialization.c,24 :: 		TRISEbits.TRISE0 = 0;                           //PWM output
	BCLR	TRISEbits, #0
;initialization.c,25 :: 		TRISEbits.TRISE4 = 0;                           //Forward output
	BCLR	TRISEbits, #4
;initialization.c,26 :: 		TRISEbits.TRISE3 = 0;                           //Reverse output
	BCLR	TRISEbits, #3
;initialization.c,27 :: 		TRISEbits.TRISE2 = 0;                           //Enable output
	BCLR	TRISEbits, #2
;initialization.c,28 :: 		TRISBbits.TRISB0 = 1;                           //set ADC pin as input (Current sense: Vcsns = Iout x 3.1)
	BSET	TRISBbits, #0
;initialization.c,29 :: 		BUZZER = 0;                                                                                //Outputs at zero
	BCLR	LATD2_bit, BitPos(LATD2_bit+0)
;initialization.c,30 :: 		LED_B = 0;
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,31 :: 		LED_G = 0;
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,33 :: 		QEICON = 0b0000010110000010;                    //Set Quadrature Encoder
	MOV	#1410, W0
	MOV	WREG, QEICON
;initialization.c,35 :: 		POSCNT = EEPROM_Read(ADDR_LAST_POSCNT);              //Position Counter starter value (offset half register)
	MOV	#64928, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	WREG, POSCNT
;initialization.c,36 :: 		MAXCNT = QUARTER_TURN;                          //Set maxcounter to a quarter turn for interrupts
	MOV	#10048, W0
	MOV	WREG, MAXCNT
;initialization.c,37 :: 		IPC10bits.QEIIP = 4;                            //Set interrupt priority on 4 for MAXCNT match
	MOV.B	#4, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC10bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC10bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC10bits), W0
	MOV.B	W1, [W0]
;initialization.c,38 :: 		IFS2bits.QEIIF = 0;                             //Reset Interrupt Flag
	BCLR	IFS2bits, #8
;initialization.c,39 :: 		IEC2bits.QEIIE = 1;                             //Enable MAXCNT match interrupt
	BSET	IEC2bits, #8
;initialization.c,41 :: 		PWMCON1 = 0b0000000100000001;                   //independent mode, only PWM1L enabled
	MOV	#257, W0
	MOV	WREG, PWMCON1
;initialization.c,42 :: 		PTPER = 1999;                                   //PWM frequency = 10 kHz
	MOV	#1999, W0
	MOV	WREG, PTPER
;initialization.c,43 :: 		PDC1 = 0;                                       //initial 0% of duty cycle - motor is off;        MAX_Value = 4000;
	CLR	PDC1
;initialization.c,44 :: 		PTMR = 0;                                       //to clear the PWM time base
	CLR	PTMR
;initialization.c,45 :: 		PTCON = 0b1000000000000000;                     //prescaler 1:1, postscaler 1:1, free running mode, PWM on
	MOV	#32768, W0
	MOV	WREG, PTCON
;initialization.c,46 :: 		FORWARD = 0;                                                                        //all h-bridge input at zero
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;initialization.c,47 :: 		REVERSE = 0;
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;initialization.c,48 :: 		ENABLE = 0;
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;initialization.c,51 :: 		ebb_current_pos = EEPROM_Read(ADDR_LAST_MAPPED_POSITION);                       //Get the old mapped position
	MOV	#64960, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _ebb_current_pos
;initialization.c,52 :: 		ebb_target_pos = ebb_current_pos;                                               //Set target as reached
	MOV	W0, _ebb_target_pos
;initialization.c,53 :: 		motor_current_position = EEPROM_Read(ADDR_LAST_NUMBER_QUARTER_TURNS);           //Get the old quester turns number
	MOV	#64944, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _motor_current_position
;initialization.c,54 :: 		motor_target_position = motor_current_position;                                 //Set target as reached
	MOV	W0, _motor_target_position
;initialization.c,55 :: 		ebb_settings = 0;
	CLR	W0
	MOV	W0, _ebb_settings
;initialization.c,56 :: 		brake_pressure_front = 0;
	CLR	W0
	MOV	W0, _brake_pressure_front
;initialization.c,57 :: 		is_requested_calibration = 0;
	MOV	#lo_addr(_is_requested_calibration), W1
	CLR	W0
	MOV.B	W0, [W1]
;initialization.c,58 :: 		is_requested_movement = 0;
	MOV	#lo_addr(_is_requested_movement), W1
	CLR	W0
	MOV.B	W0, [W1]
;initialization.c,60 :: 		CAN_Init();                                     //initialize CAN module
	CALL	_Can_init
;initialization.c,62 :: 		CAN_routine();                                   //Send first CAN Packet
	CALL	_CAN_routine
;initialization.c,64 :: 		UART1_Init(9600);
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;initialization.c,66 :: 		ebb_current_state = EBB_OFF;
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;initialization.c,69 :: 		setTimer(TIMER4_DEVICE,0.003);                                        //Interrupt every 200uS
	MOV	#39846, W11
	MOV	#15172, W12
	MOV.B	#3, W10
	CALL	_setTimer
;initialization.c,72 :: 		buzzer_state = ON;
	MOV	#1, W0
	MOV	W0, _buzzer_state
;initialization.c,73 :: 		LED_B = ON;
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,74 :: 		LED_G = ON;
	BSET	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,75 :: 		delay_ms(1000);
	MOV	#102, W8
	MOV	#47563, W7
L_EBB_Init149:
	DEC	W7
	BRA NZ	L_EBB_Init149
	DEC	W8
	BRA NZ	L_EBB_Init149
	NOP
;initialization.c,76 :: 		buzzer_state = OFF;
	CLR	W0
	MOV	W0, _buzzer_state
;initialization.c,77 :: 		LED_B = OFF;
	BCLR	LATD1_bit, BitPos(LATD1_bit+0)
;initialization.c,78 :: 		LED_G = OFF;
	BCLR	LATD3_bit, BitPos(LATD3_bit+0)
;initialization.c,80 :: 		setTimer(TIMER1_DEVICE,0.01);                                         //Interrupt every 1mS
	MOV	#55050, W11
	MOV	#15395, W12
	MOV.B	#1, W10
	CALL	_setTimer
;initialization.c,81 :: 		setTimer(TIMER2_DEVICE,0.001 * CONTROL_ROUTINE_REFRESH);              //Interrupt every CONTROL_ROUTINE_REFRESH mS
	MOV	#55051, W11
	MOV	#15395, W12
	MOV.B	#2, W10
	CALL	_setTimer
;initialization.c,82 :: 		}
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

;EBB_DPX.c,97 :: 		onTimer1Interrupt {
;EBB_DPX.c,99 :: 		timer1_counter ++;
	MOV	#1, W1
	MOV	#lo_addr(_timer1_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,100 :: 		if (timer1_counter == 300){
	MOV	_timer1_counter, W1
	MOV	#300, W0
	CP	W1, W0
	BRA Z	L__timer1_interrupt316
	GOTO	L_timer1_interrupt151
L__timer1_interrupt316:
;EBB_DPX.c,101 :: 		ebb_current_state = EBB_OFF;
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;EBB_DPX.c,102 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,103 :: 		ebb_target_pos = 8;
	MOV	#8, W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,104 :: 		}
L_timer1_interrupt151:
;EBB_DPX.c,105 :: 		if (timer1_counter == 600){
	MOV	_timer1_counter, W1
	MOV	#600, W0
	CP	W1, W0
	BRA Z	L__timer1_interrupt317
	GOTO	L_timer1_interrupt152
L__timer1_interrupt317:
;EBB_DPX.c,106 :: 		ebb_current_state = EBB_OFF;
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;EBB_DPX.c,107 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,108 :: 		ebb_target_pos = 7;
	MOV	#7, W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,109 :: 		}
L_timer1_interrupt152:
;EBB_DPX.c,110 :: 		if (timer1_counter == 900){
	MOV	_timer1_counter, W1
	MOV	#900, W0
	CP	W1, W0
	BRA Z	L__timer1_interrupt318
	GOTO	L_timer1_interrupt153
L__timer1_interrupt318:
;EBB_DPX.c,111 :: 		ebb_current_state = EBB_OFF;
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;EBB_DPX.c,112 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,113 :: 		ebb_target_pos = 6;
	MOV	#6, W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,114 :: 		}
L_timer1_interrupt153:
;EBB_DPX.c,115 :: 		if (timer1_counter == 1200){
	MOV	_timer1_counter, W1
	MOV	#1200, W0
	CP	W1, W0
	BRA Z	L__timer1_interrupt319
	GOTO	L_timer1_interrupt154
L__timer1_interrupt319:
;EBB_DPX.c,116 :: 		ebb_current_state = EBB_OFF;
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;EBB_DPX.c,117 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,118 :: 		ebb_target_pos = 5;
	MOV	#5, W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,119 :: 		}
L_timer1_interrupt154:
;EBB_DPX.c,120 :: 		if (timer1_counter == 1500){
	MOV	_timer1_counter, W1
	MOV	#1500, W0
	CP	W1, W0
	BRA Z	L__timer1_interrupt320
	GOTO	L_timer1_interrupt155
L__timer1_interrupt320:
;EBB_DPX.c,121 :: 		ebb_current_state = EBB_OFF;
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;EBB_DPX.c,122 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,123 :: 		ebb_target_pos = 6;
	MOV	#6, W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,124 :: 		}
L_timer1_interrupt155:
;EBB_DPX.c,125 :: 		if (timer1_counter == 1800){
	MOV	_timer1_counter, W1
	MOV	#1800, W0
	CP	W1, W0
	BRA Z	L__timer1_interrupt321
	GOTO	L_timer1_interrupt156
L__timer1_interrupt321:
;EBB_DPX.c,126 :: 		ebb_current_state = EBB_OFF;
	MOV	#lo_addr(_ebb_current_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;EBB_DPX.c,127 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,128 :: 		ebb_target_pos = 7;
	MOV	#7, W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,129 :: 		timer1_counter = 0;
	CLR	W0
	MOV	W0, _timer1_counter
;EBB_DPX.c,130 :: 		}
L_timer1_interrupt156:
;EBB_DPX.c,142 :: 		clearTimer1();
	BCLR	IFS0bits, #3
;EBB_DPX.c,143 :: 		}
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

;EBB_DPX.c,145 :: 		onTimer2Interrupt {
;EBB_DPX.c,146 :: 		timer2_counter++;
	PUSH	W10
	MOV	#1, W1
	MOV	#lo_addr(_timer2_counter), W0
	ADD	W1, [W0], [W0]
;EBB_DPX.c,147 :: 		brake_counter++;
	MOV.B	#1, W1
	MOV	#lo_addr(_brake_counter), W0
	ADD.B	W1, [W0], [W0]
;EBB_DPX.c,148 :: 		EBB_control();
	CALL	_EBB_control
;EBB_DPX.c,149 :: 		if (timer2_counter >= 10)
	MOV	_timer2_counter, W0
	CP	W0, #10
	BRA GE	L__timer2_interrupt323
	GOTO	L_timer2_interrupt157
L__timer2_interrupt323:
;EBB_DPX.c,151 :: 		CAN_routine();  //Call the can update routine
	CALL	_CAN_routine
;EBB_DPX.c,152 :: 		timer2_counter = 0;
	CLR	W0
	MOV	W0, _timer2_counter
;EBB_DPX.c,153 :: 		}
L_timer2_interrupt157:
;EBB_DPX.c,155 :: 		sprintf(dstr, "POSCNT: %u\r\n", POSCNT);
	PUSH	POSCNT
	MOV	#lo_addr(?lstr_2_EBB_DPX), W0
	PUSH	W0
	MOV	#lo_addr(_dstr), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
;EBB_DPX.c,156 :: 		Debug_UART_Write(dstr);
	MOV	#lo_addr(_dstr), W10
	CALL	_Debug_UART_Write
;EBB_DPX.c,157 :: 		clearTimer2();
	BCLR	IFS0bits, #6
;EBB_DPX.c,158 :: 		}
L_end_timer2_interrupt:
	POP	W10
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

;EBB_DPX.c,160 :: 		onTimer4Interrupt {
;EBB_DPX.c,161 :: 		if(buzzer_state == ON){  //Sound routine
	MOV	_buzzer_state, W0
	CP	W0, #1
	BRA Z	L__timer4_interrupt325
	GOTO	L_timer4_interrupt158
L__timer4_interrupt325:
;EBB_DPX.c,162 :: 		BUZZER = !BUZZER;
	BTG	LATD2_bit, BitPos(LATD2_bit+0)
;EBB_DPX.c,163 :: 		}
L_timer4_interrupt158:
;EBB_DPX.c,164 :: 		clearTimer4();
	BCLR	IFS1bits, #5
;EBB_DPX.c,165 :: 		}
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

;EBB_DPX.c,168 :: 		void main() {
;EBB_DPX.c,169 :: 		EBB_Init();
	CALL	_EBB_Init
;EBB_DPX.c,170 :: 		while(1)
L_main159:
;EBB_DPX.c,172 :: 		}
	GOTO	L_main159
;EBB_DPX.c,174 :: 		}
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

;EBB_DPX.c,176 :: 		onCanInterrupt {
;EBB_DPX.c,182 :: 		Can_read(&CAN_id, CAN_datain, &CAN_dataLen, &CAN_flags);
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
;EBB_DPX.c,184 :: 		if (CAN_dataLen >= 2) {
	MOV	[W14+12], W0
	CP	W0, #2
	BRA GEU	L__CAN_Interrupt329
	GOTO	L_CAN_Interrupt161
L__CAN_Interrupt329:
;EBB_DPX.c,185 :: 		firstInt = (unsigned int) ((CAN_datain[0] << 8) | (CAN_datain[1] & 0xFF));
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
;EBB_DPX.c,186 :: 		}
L_CAN_Interrupt161:
;EBB_DPX.c,187 :: 		if (CAN_dataLen >= 4) {
	MOV	[W14+12], W0
	CP	W0, #4
	BRA GEU	L__CAN_Interrupt330
	GOTO	L_CAN_Interrupt162
L__CAN_Interrupt330:
;EBB_DPX.c,188 :: 		secondInt = (unsigned int) ((CAN_datain[2] << 8) | (CAN_datain[3] & 0xFF));
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
;EBB_DPX.c,189 :: 		}
L_CAN_Interrupt162:
;EBB_DPX.c,190 :: 		if (CAN_dataLen >= 6) {
	MOV	[W14+12], W0
	CP	W0, #6
	BRA GEU	L__CAN_Interrupt331
	GOTO	L_CAN_Interrupt163
L__CAN_Interrupt331:
;EBB_DPX.c,191 :: 		thirdInt = (unsigned int) ((CAN_datain[4] << 8) | (CAN_datain[5] & 0xFF));
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
;EBB_DPX.c,192 :: 		}
L_CAN_Interrupt163:
;EBB_DPX.c,193 :: 		if (CAN_dataLen >= 8) {
	MOV	[W14+12], W0
	CP	W0, #8
	BRA GEU	L__CAN_Interrupt332
	GOTO	L_CAN_Interrupt164
L__CAN_Interrupt332:
;EBB_DPX.c,195 :: 		}
L_CAN_Interrupt164:
;EBB_DPX.c,196 :: 		Can_clearInterrupt();
	CALL	_Can_clearInterrupt
;EBB_DPX.c,198 :: 		switch(CAN_id){
	GOTO	L_CAN_Interrupt165
;EBB_DPX.c,199 :: 		case SW_BRAKE_BIAS_EBB_ID:
L_CAN_Interrupt167:
;EBB_DPX.c,200 :: 		ebb_target_pos = ((unsigned int)firstInt);
	MOV	[W14+16], W0
	MOV	W0, _ebb_target_pos
;EBB_DPX.c,201 :: 		ebb_settings = ((unsigned int)secondInt);
	MOV	[W14+18], W0
	MOV	W0, _ebb_settings
;EBB_DPX.c,202 :: 		if ((ebb_target_pos != ebb_current_pos) && ebb_target_pos >= MIN_POSITION && ebb_target_pos <= MAX_POSITION)
	MOV	[W14+16], W1
	MOV	#lo_addr(_ebb_current_pos), W0
	CP	W1, [W0]
	BRA NZ	L__CAN_Interrupt333
	GOTO	L__CAN_Interrupt180
L__CAN_Interrupt333:
	MOV	_ebb_target_pos, W0
	CP	W0, #0
	BRA GEU	L__CAN_Interrupt334
	GOTO	L__CAN_Interrupt179
L__CAN_Interrupt334:
	MOV	_ebb_target_pos, W0
	CP	W0, #16
	BRA LEU	L__CAN_Interrupt335
	GOTO	L__CAN_Interrupt178
L__CAN_Interrupt335:
L__CAN_Interrupt177:
;EBB_DPX.c,204 :: 		is_requested_movement = ON;
	MOV	#lo_addr(_is_requested_movement), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,205 :: 		}else if (ebb_target_pos == CALIBRATION_POSITION)
	GOTO	L_CAN_Interrupt171
;EBB_DPX.c,202 :: 		if ((ebb_target_pos != ebb_current_pos) && ebb_target_pos >= MIN_POSITION && ebb_target_pos <= MAX_POSITION)
L__CAN_Interrupt180:
L__CAN_Interrupt179:
L__CAN_Interrupt178:
;EBB_DPX.c,205 :: 		}else if (ebb_target_pos == CALIBRATION_POSITION)
	MOV	#100, W1
	MOV	#lo_addr(_ebb_target_pos), W0
	CP	W1, [W0]
	BRA Z	L__CAN_Interrupt336
	GOTO	L_CAN_Interrupt172
L__CAN_Interrupt336:
;EBB_DPX.c,207 :: 		is_requested_calibration = ON;
	MOV	#lo_addr(_is_requested_calibration), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;EBB_DPX.c,208 :: 		}
L_CAN_Interrupt172:
L_CAN_Interrupt171:
;EBB_DPX.c,209 :: 		break;
	GOTO	L_CAN_Interrupt166
;EBB_DPX.c,210 :: 		case DAU_FR_ID:
L_CAN_Interrupt173:
;EBB_DPX.c,211 :: 		brake_pressure_front = ((unsigned int)thirdInt);
	MOV	[W14+20], W0
	MOV	W0, _brake_pressure_front
;EBB_DPX.c,212 :: 		break;
	GOTO	L_CAN_Interrupt166
;EBB_DPX.c,214 :: 		}
L_CAN_Interrupt165:
	MOV	#1024, W1
	MOV	#0, W2
	ADD	W14, #0, W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA NZ	L__CAN_Interrupt337
	GOTO	L_CAN_Interrupt167
L__CAN_Interrupt337:
	MOV	#1616, W1
	MOV	#0, W2
	ADD	W14, #0, W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA NZ	L__CAN_Interrupt338
	GOTO	L_CAN_Interrupt173
L__CAN_Interrupt338:
L_CAN_Interrupt166:
;EBB_DPX.c,215 :: 		}
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
