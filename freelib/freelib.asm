	MODULE freelib

@SCR_PIXELS	EQU #4000
@SCR_PIXELS_S	EQU #1800
@SCR_ATTR	EQU #5800
@SCR_ATTR_S	EQU #300
@FONT_ADDR	EQU #3D00
@FONT_FIRST	EQU #20


; @SWAP_BUFFER:
; 	push BC
; 	ld A, (PORT_7FFD)
; 	xor %00001010
; 	ld (PORT_7FFD), A
; 	ld BC, #7FFD
; 	out (C), A
; 	pop BC
; 	ret
;
;
; PORT_7FFD	DEFB %00010101


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


	INCLUDE "keyboard.asm"
	INCLUDE "running_str.asm"
	INCLUDE "print.asm"
	INCLUDE "coord.asm"
	INCLUDE "graph_fill.asm"


	ENDMODULE
