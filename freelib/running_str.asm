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
