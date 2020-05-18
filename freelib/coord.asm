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
