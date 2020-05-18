	MODULE menu

@MENU_TITLE
	push AF
	push BC
	push DE
	push HL

	ld A, 0
	out (#FE), A
	call CLEAR_PIXELS

	ld A, %01000111
	call CLEAR_ATTR

	ld HL, SCR_PIXELS
	ld DE, MENU_DATA
	ld B, 8
	ld C, 32

MN_LP1	ld a, (DE)
	or a
	jr z, MN_ELP

	push DE
	push HL

	and %00001111
	rlca
	rlca
	rlca

	ld HL, SPRITES
	ld D, 0
	ld E, A
	add HL, DE
	ex DE, HL

	pop HL
	push HL

	DUP 8
	ld a, (DE)
	inc DE
	ld (HL), a
	inc H
	EDUP

	pop HL
	pop DE

MN_ELP	inc DE
	inc L
	dec C
	jr nz, MN_LP1

	ld C, 32
	dec B
	jr nz, MN_LP1

	; Red apples :)
	ld HL, #0000
	call COORD_ATTR
	ld (HL), %01000010
	ld HL, #001F
	call COORD_ATTR
	ld (HL), %01000010
	ld HL, #0700
	call COORD_ATTR
	ld (HL), %01000010
	ld HL, #071F
	call COORD_ATTR
	ld (HL), %01000010

	;S
	ld A, %01000100
	ld BC, #0604
	ld HL, #0102
	call BOX_ATTR
	;N
	ld A, %01000110
	ld BC, #0605
	ld HL, #0107
	call BOX_ATTR
	;A
	ld A, %01000101
	ld HL, #010D
	call BOX_ATTR
	;K
	ld A, %01000011
	ld HL, #0113
	call BOX_ATTR
	;E
	ld A, %01000001
	ld HL, #0119
	call BOX_ATTR

	pop HL
	pop DE
	pop BC
	pop AF
	ret


@MENU_DRAW
	push AF
	push BC
	push DE
	push HL

	ld BC, FONT_ADDR

	; Print menu items
	or A
	jp z, MN_M
	dec A
	jp z, MN_KS
	jp MN_HS

	; Main menu
MN_M	ld DE, MENU_1
	ld HL, #0A08
	call PRINT_STR

	ld DE, MENU_2
	ld HL, #0C08
	call PRINT_STR

	ld DE, MENU_3
	ld HL, #1204
	call PRINT_STR

	ld A, %01000011
	ld BC, #0110
	ld HL, #0A08
	call BOX_ATTR

	ld A, %01000100
	ld HL, #0C08
	call BOX_ATTR

	ld A, %01000101
	ld BC, #0118
	ld HL, #1204
	call BOX_ATTR

	ld A, %01000010
	ld BC, #0104
	ld HL, #120A
	call BOX_ATTR

	jp MN_END

	; Redefine keys
MN_KS	ld DE, KEYS
	ld HL, #0A09
	call PRINT_STR

	ld DE, KEYS_U
	ld HL, #0C0C
	call PRINT_STR

	ld DE, KEYS_D
	ld HL, #0D0C
	call PRINT_STR

	ld DE, KEYS_L
	ld HL, #0E0C
	call PRINT_STR

	ld DE, KEYS_R
	ld HL, #0F0C
	call PRINT_STR

	ld DE, KEYS_F
	ld HL, #100C
	call PRINT_STR

	ld A, %0000111
	ld BC, #0505
	ld HL, #0C0C
	call BOX_ATTR

	jp MN_END

	; High scores
MN_HS	ld DE, SCORES
	ld HL, #0A0C
	call PRINT_STR

	ld DE, SC_TABLE
	ld HL, #0D09
	call PRINT_STR

	ld DE, SC_TABLE + 16
	ld HL, #0E09
	call PRINT_STR

	ld DE, SC_TABLE + 32
	ld HL, #0F09
	call PRINT_STR

	ld DE, SC_TABLE + 48
	ld HL, #1009
	call PRINT_STR

	ld DE, SC_TABLE + 64
	ld HL, #1109
	call PRINT_STR

	ld DE,SC_EXIT
	ld HL, #1507
	call PRINT_STR

	ld A, %01000110
	ld BC, #0114
	ld HL, #0D07
	call BOX_ATTR

	ld A, %01000101
	ld HL, #0E07
	call BOX_ATTR

	ld A, %01000100
	ld HL, #0F07
	call BOX_ATTR

	ld A, %01000011
	ld HL, #1007
	call BOX_ATTR

	ld A, %01000010
	ld HL, #1107
	call BOX_ATTR

	ld A, %01000001
	ld HL, #1507
	call BOX_ATTR

	; End
MN_END	pop HL
	pop DE
	pop BC
	pop AF
	ret


MENU_DATA
	DEFB #F,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#F
	DEFB #0,#0,#B,#9,#9,#1,#0,#B,#C,#0,#0,#3,#0,#0,#B,#9,#C,#0,#0,#7,#0,#B,#9,#1,#0,#B,#9,#9,#9,#5,#0,#0
	DEFB #0,#0,#A,#0,#0,#0,#0,#A,#E,#C,#0,#A,#0,#B,#D,#0,#E,#C,#0,#A,#B,#D,#0,#0,#0,#A,#0,#0,#0,#0,#0,#0
	DEFB #0,#0,#E,#9,#9,#C,#0,#A,#0,#A,#0,#A,#0,#A,#0,#0,#0,#A,#0,#E,#D,#0,#0,#0,#0,#E,#9,#9,#1,#0,#0,#0
	DEFB #0,#0,#0,#0,#0,#A,#0,#A,#0,#E,#C,#A,#0,#A,#2,#9,#5,#A,#0,#B,#9,#C,#0,#0,#0,#7,#0,#0,#0,#0,#0,#0
	DEFB #0,#0,#0,#0,#0,#A,#0,#A,#0,#0,#A,#A,#0,#A,#0,#0,#0,#A,#0,#A,#0,#E,#C,#0,#0,#A,#0,#0,#0,#0,#0,#0
	DEFB #0,#0,#6,#9,#9,#D,#0,#8,#0,#0,#E,#D,#0,#8,#0,#0,#0,#4,#0,#4,#0,#0,#E,#5,#0,#E,#9,#9,#9,#1,#0,#0
	DEFB #F,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#F

MENU_1	DEFB "1. Redefine keys",0
MENU_2	DEFB "2. Hi Scores",0
MENU_3	DEFB "Press FIRE to start game",0

KEYS	DEFB "Press key for:",0
KEYS_U	DEFB "   UP",0
KEYS_D	DEFB " DOWN",0
KEYS_L	DEFB " LEFT",0
KEYS_R	DEFB "RIGHT",0
KEYS_F	DEFB " FIRE",0

SCORES	DEFB "Hi Scores",0
SC_EXIT	DEFB "Press Space to exit", 0
SC_TABLE
	DEFB "BULKA       256",0
	DEFB "BETTY       128",0
	DEFB "FREEMAN     064",0
	DEFB "EMPTY       032",0
	DEFB "EMPTY       016",0

	ENDMODULE
