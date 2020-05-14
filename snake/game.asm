	MODULE game

@START_GAME
	push BC
	push DE
	push HL

	ld D, %01000111
	ld E, %00000000
	call CLEAR_SCR

	pop HL
	pop DE
	pop BC
	ret

	ENDMODULE
