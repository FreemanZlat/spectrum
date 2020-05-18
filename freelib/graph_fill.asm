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
