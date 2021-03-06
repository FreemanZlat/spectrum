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
