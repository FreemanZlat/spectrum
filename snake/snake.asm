	DEVICE ZXSPECTRUM48

	MODULE main

START_ADDRESS	EQU #8800
INT_ADDRESS	EQU #80FF

MENU_MAIN	EQU #00
MENU_KEYS	EQU #01
MENU_SCORES	EQU #02
MENU_GAME	EQU #03
MENU_GAMEOVER	EQU #04
MENU_NAME	EQU #05


	ORG START_ADDRESS
@MAIN	ld (RES_SP+1), SP
	ld SP, START_ADDRESS
	push AF
	push BC
	push DE
	push HL
	push IX
	push IY

	ld HL, INT_ADDRESS
	ld DE, INTERRUPTION
	call INIT_INT

START	call MENU_TITLE

	ld HL, #0000
	ld (MENU_STR_CNT), HL
	ld A, MENU_MAIN
	ld (MENU_TYPE), A


MENU_GO	ld A, 0
	ld BC, #0F20
	ld HL, #0800
	call BOX_BYTE

	ld A, (MENU_TYPE)
	call MENU_DRAW

	; Menu loop
MN_LP	HALT

	; Running str
	ld BC, FONT_ADDR
	ld DE, MENU_STR
	ld HL, #1700
	call COORD_PIX
	ld IX, MENU_STR_CNT
	ld IY, MENU_STR_BUF
	call RUN_STR

	call READ_KEY

	ld A, (MENU_TYPE)
	or A
	jp z, MN_M
	dec A
	jp z, MN_KS
	jp MN_HS

	; Main menu
MN_M	ld BC, KEY2_1
	call KEY_PRESSED
	or A
	jr z, MN_M1
	ld A, MENU_KEYS
	jp MN_CHNG

MN_M1	ld BC, KEY2_2
	call KEY_PRESSED
	or A
	jr z, MN_M2
	ld A, MENU_SCORES
	jp MN_CHNG

MN_M2	ld BC, (KEYS + 12)
	call KEY_PRESSED
	or A
	jr z, MN_END
	ld A, MENU_GAME
	ld (MENU_TYPE), A
	call START_GAME

	jp START

	; Redefine keys
MN_KS	ld BC, KEY2_SPACE
	call KEY_PRESSED
	or A
	jr z, MN_END
	ld A, MENU_MAIN
	jp MN_CHNG

	; High scores
MN_HS	ld BC, KEY2_SPACE
	call KEY_PRESSED
	or A
	jr z, MN_END
	ld A, MENU_MAIN
	jp MN_CHNG

MN_END	ld A, %00000000
	out (#FE), A

	jp MN_LP

MN_CHNG	ld (MENU_TYPE), A
	HALT
	HALT
	HALT
	jp MENU_GO

EXIT	call RESTORE_INT

	pop IY
	pop IX
	pop HL
	pop DE
	pop BC
	pop AF

RES_SP	ld SP, #0000
	ret


MENU_TYPE	DEFB MENU_MAIN
MENU_STATE	DEFB #00

MENU_STR	DEFB "- = - = Game by Ivan Maklyakov, 2020 = ", 0
MENU_STR_BUF	DEFB 0, 0, 0, 0, 0, 0, 0, 0
MENU_STR_CNT	DEFW #0000

KEYS_TYPE	DEFB #00		; 0 - keyboard, 1 - kempston

KEYS		DEFB #DF, #01, #01	; P
		DEFB #DF, #02, #02	; O
		DEFB #FD, #01, #04	; A
		DEFB #FB, #01, #08	; Q
		DEFB #7F, #01, #10	; Sp


INTERRUPTION:
	di
	push AF

	ld A, %00000100
	out (#FE), A

	pop AF
	ei
	reti

	ENDMODULE


	INCLUDE "menu.asm"
	INCLUDE "game.asm"
	INCLUDE "sprites.asm"
	INCLUDE "freelib.asm"

SCORE		DEFB #00, #00, #00

CONTROL_STATE	DEFB #00
FRAME_TICK	DEFB #00

	SAVETAP  "snake.tap", MAIN

