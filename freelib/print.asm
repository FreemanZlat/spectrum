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
