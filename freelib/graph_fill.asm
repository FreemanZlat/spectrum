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

	ld (BC_DE + 1), DE

	call COORD_PIX

BC_LP0	push HL
	push BC

BC_LP1	push HL

BC_DE	ld DE, #0000
	DUP 8
	ld A, (DE)
	inc DE
	ld (HL), A
	inc H
	EDUP

	pop HL
	inc L
	dec C
	jr nz, BC_LP1

	pop BC
	pop HL

	call DOWN_HL_8
	dec B
	jr nz, BC_LP0

	pop HL
	pop DE
	pop BC
	pop AF
	ret


; A - byte to fill
; B - size y
; C - size x
; H - y
; L - x
@BOX_BYTE
	push AF
	push BC
	push DE
	push HL

	call COORD_PIX

	ld D, C
BB_LP0	push HL
	ld E, H

BB_LP1	DUP 8
	ld (HL), A
	inc H
	EDUP

	ld H, E
	inc L
	dec C
	jr nz, BB_LP1

	ld C, D
	pop HL

	call DOWN_HL_8
	dec B
	jr nz, BB_LP0

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


; A - byte to fill
@CLEAR_PIXELS
	push AF
	push BC
	push HL
	ld (CP_RESP + 1), SP

	ld SP, SCR_PIXELS+SCR_PIXELS_S
	ld BC, SCR_PIXELS_S/128
	ld H, A
	ld L, A
CP_LP	DUP 64
	push HL
	EDUP
	dec BC
	ld A, B
	or C
	jp nz, CP_LP

CP_RESP	ld SP, #0000

	pop HL
	pop BC
	pop AF
	ret


; A - attr
@CLEAR_ATTR
	push AF
	push BC
	push HL
	ld (CA_RESP + 1), SP

	ld SP, SCR_ATTR+SCR_ATTR_S
	ld BC, SCR_ATTR_S/128
	ld H, A
	ld L, A
CA_LP	DUP 64
	push HL
	EDUP
	dec BC
	ld A, B
	or C
	jp nz, CA_LP

CA_RESP	ld SP, #0000

	pop HL
	pop BC
	pop AF
	ret
