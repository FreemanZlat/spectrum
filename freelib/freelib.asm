	MODULE freelib

@SCR_PIXELS	EQU #4000
@SCR_PIXELS_S	EQU #1800
@SCR_ATTR	EQU #5800
@SCR_ATTR_S	EQU #300
@FONT_ADDR	EQU #3D00
@FONT_FIRST	EQU #20

@KEY2_1		EQU #01F7
@KEY2_2		EQU #02F7
@KEY2_3		EQU #04F7
@KEY2_4		EQU #08F7
@KEY2_5		EQU #10F7
@KEY2_6		EQU #10EF
@KEY2_7		EQU #08EF
@KEY2_8		EQU #04EF
@KEY2_9		EQU #02EF
@KEY2_0		EQU #01EF
@KEY2_Q		EQU #01FB
@KEY2_W		EQU #02FB
@KEY2_E		EQU #04FB
@KEY2_R		EQU #08FB
@KEY2_T		EQU #10FB
@KEY2_Y		EQU #10DF
@KEY2_U		EQU #08DF
@KEY2_I		EQU #04DF
@KEY2_O		EQU #02DF
@KEY2_P		EQU #01DF
@KEY2_A		EQU #01FD
@KEY2_S		EQU #02FD
@KEY2_D		EQU #04FD
@KEY2_F		EQU #08FD
@KEY2_G		EQU #10FD
@KEY2_H		EQU #10BF
@KEY2_J		EQU #08BF
@KEY2_K		EQU #04BF
@KEY2_L		EQU #02BF
@KEY2_ENTER	EQU #01BF
@KEY2_CS	EQU #01FE
@KEY2_Z		EQU #02FE
@KEY2_X		EQU #04FE
@KEY2_C		EQU #08FE
@KEY2_V		EQU #10FE
@KEY2_B		EQU #107F
@KEY2_N		EQU #087F
@KEY2_M		EQU #047F
@KEY2_SS	EQU #027F
@KEY2_SPACE	EQU #017F

@KEY_1		EQU %00000000
@KEY_0		EQU %00000001
@KEY_Q		EQU %00000010
@KEY_P		EQU %00000011
@KEY_A		EQU %00000100
@KEY_ENTER	EQU %00000101
@KEY_CS		EQU %00000110
@KEY_SPACE	EQU %00000111
@KEY_2		EQU %00001000
@KEY_9		EQU %00001001
@KEY_W		EQU %00001010
@KEY_O		EQU %00001011
@KEY_S		EQU %00001100
@KEY_L		EQU %00001101
@KEY_Z		EQU %00001110
@KEY_SS		EQU %00001111
@KEY_3		EQU %00010000
@KEY_8		EQU %00010001
@KEY_E		EQU %00010010
@KEY_I		EQU %00010011
@KEY_D		EQU %00010100
@KEY_K		EQU %00010101
@KEY_X		EQU %00010110
@KEY_M		EQU %00010111
@KEY_4		EQU %00011000
@KEY_7		EQU %00011001
@KEY_R		EQU %00011010
@KEY_U		EQU %00011011
@KEY_F		EQU %00011100
@KEY_J		EQU %00011101
@KEY_C		EQU %00011110
@KEY_N		EQU %00011111
@KEY_5		EQU %00100000
@KEY_6		EQU %00100001
@KEY_T		EQU %00100010
@KEY_Y		EQU %00100011
@KEY_G		EQU %00100100
@KEY_H		EQU %00100101
@KEY_V		EQU %00100110
@KEY_B		EQU %00100111


@SWAP_BUFFER:
	push BC
	ld A, (PORT_7FFD)
	xor %00001010
	ld (PORT_7FFD), A
	ld BC, #7FFD
	out (C), A
	pop BC
	ret


PORT_7FFD	DEFB %00010101


@INIT_INT
	push AF
	push DE
	push HL

	di
	ld A, I
	ld (RES_I), A
	ld A, H
	ld I, A
	ld (HL), E
	inc HL
	ld (HL), D

	im 2
	ei

	pop HL
	pop DE
	pop AF
	ret


@RESTORE_INT
	push AF
	di
RES_I	ld A, #00
	ld I, A
	im 1
	EI
	pop AF
	ret


; Result:
; H - key mask
; L - key addr
@READ_KEY
	push AF
	push BC

	ld HL, KEYS_ADDRS
	ld C, #FE

RK_LP	ld A, (HL)
	or A
	jr z, RK_END

	ld B, A
	in A, (C)
	and %00011111
	xor %00011111
	jr nz, RK_END

	inc HL
	jr RK_LP

RK_END  ld H, A
	ld L, B

	pop BC
	pop AF
	ret


KEYS_ADDRS	DEFB #F7, #EF, #FB, #DF, #FD, #BF, #FE, #7F, 0


; B - key mask
; C - key addr
; HL - result of READ_KEY
; Result
; A - pressed
@KEY_PRESSED
	ld A, C
	xor L
	jr z, KP_NXT

	xor A
	ret

KP_NXT	ld A, B
	and H
	ret


; BC - Font address
; DE - String address
; HL - Pixels address
; (IX) - Counter: lower 3 bits - shift, other bits - char in str
; IY - 8 bytes buffer
@RUN_STR
	push AF
	push BC
	push DE
	push HL

	ex AF, AF'
	push AF
	ex AF, AF'

	ld (RS_FNT + 1), BC

	; Load counter
	ld C, (IX)
	ld B, (IX + 1)
	; Check if need next char
RS_NS0	push BC
	push DE
	ld A, C
	and %00000111
	jr nz, RS_N1

	; Get next char
	ld A, C
	and %11111000
	ld C, A
	rr B				;BC/8
	rr C
	rr B
	rr C
	rr B
	rr C

	ex DE, HL
	add HL, BC
	ld A, (HL)

	; Check end of string
	or A
	jr nz, RS_NS1

	; If yes, reset counter and go to get first char
	ex DE, HL
	pop DE
	pop BC
	ld BC, #0000
	jp RS_NS0

	; Calculate font offset
RS_NS1	sub FONT_FIRST
	ld B, 0
	ld C, A
	rl C			;BC*8
	rl B
	rl C
	rl B
	rl C
	rl B

RS_FNT	ld HL, #0000
	add HL, BC
	ex DE, HL

	; Get buf address
	push HL
	push IY
	pop HL

	; Send font data to buf
	ld B, 8
RS_LP0	ld A, (DE)
	ld (HL), A
	inc DE
	inc HL
	dec B
	jr nz, RS_LP0
	pop HL

	; Buffer ready!

RS_N1	pop DE
	pop BC
	inc BC

	; Save counter
	ld (IX), C
	ld (IX + 1), B

	; Outer loop
	ld B, 8
	ld C, 0
	; Do RL to byte in buf and save F[C] in A'
RS_LP1	ld A, B
	ex AF, AF'
	push IY
	pop DE
	ld B, 0
	ex DE, HL
	add HL, BC
	rl (HL)
	ex AF, AF'
	ex DE, HL
	ld B, A

	push HL

	; Move HL to end of line
	ld DE, #001F
	add HL, DE

	; Inner loop
	ex AF, AF'
	DUP 32
	rl (HL)
	dec L
	EDUP
	ex AF, AF'

	pop HL

	; Move HL to next line
	inc H
	inc C

	; End of outer loop
	dec B
	jr nz, RS_LP1

	ex AF, AF'
	pop AF
	ex AF, AF'

	pop HL
	pop DE
	pop BC
	pop AF
	ret


; HL - pixel coord
@DOWN_HL_8
	push AF

	ld A, L
	add %00100000
	jr nc, DHL8_1
	ex AF, AF'
	ld A, H
	add A, %00001000
	ld H, A
	ex AF, AF'

DHL8_1	ld L, A

	pop AF
	ret


; B - size y
; C - size x
; DE - char address
; H - y
; L - x
@BOX_CHAR
	push AF
	push BC
	push DE
	push HL

	ld (BA_DE + 1), DE

	call COORD_PIX

BA_LP0	push HL
	push BC

BA_LP1	push HL

BA_DE	ld DE, #0000
	DUP 8
	ld A, (DE)
	inc DE
	ld (HL), A
	inc H
	EDUP

	pop HL
	inc L
	dec C
	jr nz, BA_LP1

	pop BC
	pop HL

	call DOWN_HL_8
	dec B
	jr nz, BA_LP0

	pop HL
	pop DE
	pop BC
	pop AF
	ret


; A - attribute
; B - size y
; C - size x
; H - y
; L - x
@BOX_ATTR
	push AF
	push BC
	push DE
	push HL

	call COORD_ATTR

	ex AF, AF'
	ld A, C
	ld (BA_C + 1), A
	ld A, 32
	sub C
	ld D, #00
	ld E, A
	ex AF, AF'

BA_LP	ld (HL), A
	inc L
	dec C
	jr nz, BA_LP
BA_C	ld C, #00
	add HL, DE
	dec B
	jr nz, BA_LP

	pop HL
	pop DE
	pop BC
	pop AF
	ret


; H - y
; L - x
@COORD_PIX
	push AF

	ld A, H
	and %00000111
	rrca
	rrca
	rrca
	or L
	ld L, A

	ld A, H
	and %00011000
	ld H, A

	push DE
	ld DE, SCR_PIXELS
	add HL, DE
	pop DE

	pop AF
	ret


; H - y
; L - x
@COORD_ATTR
	push AF

	ld A, H
	rrca
	rrca
	rrca

	push AF

	and %00000011
	ld H, A

	pop AF

	and %11100000
	or L
	ld L, A

	push DE
	ld DE, SCR_ATTR
	add HL, DE
	pop DE

	pop AF
	ret


; BC - FONT ADDRESS
; DE - String address
; H - y
; L - x
@PRINT_STR
	push AF
	push DE
	push HL

	call COORD_PIX

	; Check end of string
PRS_LP	ld A, (DE)
	or A
	jr z, PRS_RT

	; Print char
	call PRINT_CHAR

	inc DE
	inc HL
	jp PRS_LP

PRS_RT	pop HL
	pop DE
	pop AF
	ret


; A  - Char
; BC - Font address
; HL - Pixels address
@PRINT_CHAR
	push AF
	push BC
	push DE
	push HL

	ld (PRC_FNT+1), BC

	; Calculate font offset
	sub FONT_FIRST
	ld B, 0
	ld C, A
	rl C			;BC*8
	rl B
	rl C
	rl B
	rl C
	rl B

	push HL
PRC_FNT	ld HL, #0000
	add HL, BC
	ex DE, HL
	pop HL

	; Move bytes from font to screen
	DUP 8
	ld A, (DE)
	ld (HL), A
	inc DE
	inc H
	EDUP

	pop HL
	pop DE
	pop BC
	pop AF
	ret

; D - Attributes and border
; E - Pixels
@CLEAR_SCR
	push AF
	push BC
	push HL

	; Border color
	ld A, D
	and %00111000
	rrca
	rrca
	rrca
	out (#FE), A

	ld (CS_RESP+1), SP

	; Clear pixels
	ld SP, SCR_PIXELS+SCR_PIXELS_S
	ld BC, SCR_PIXELS_S/128
	ld H, E
	ld L, E
CS_PIX	DUP 64
	push HL
	EDUP
	dec BC
	ld A, B
	or C
	jp nz, CS_PIX

	; Clear attributes
	ld SP, SCR_ATTR+SCR_ATTR_S
	ld BC, SCR_ATTR_S/128
	ld H, D
	ld L, D
CS_ATR	DUP 64
	push HL
	EDUP
	dec BC
	ld A, B
	or C
	jp nz, CS_ATR

CS_RESP	ld SP, #0000

	pop HL
	pop BC
	pop AF
	ret

	ENDMODULE
