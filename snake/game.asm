	MODULE game

@START_GAME
	push BC
	push DE
	push HL

	ld A, 0
	out (#FE), A
	call CLEAR_PIXELS

	ld A, %01000111
	call CLEAR_ATTR

	; Draw screen
	; ...

	ld A, 0
	ld (SCORE), A
	ld (SCORE + 1), A
	ld (SCORE + 2), A

	ld A, 1
	ld (LEVEL), A
	ld A, 50
	ld (SPEED), A

	; Init field
	; ...

	; Init snake and apple
	; ...

	ld (CONTROL_STATE), A
	ld (FRAME_TICK), A

	; Game loop
	; ...

	pop HL
	pop DE
	pop BC
	ret


LEVEL		DEFB #00
SPEED		DEFB #00

SNAKE_HEAD	DEFW #0000
SNAKE_TAIL	DEFW #0000

FIELD
	DUP 20*30
		DEFB #00
	EDUP

	ENDMODULE
