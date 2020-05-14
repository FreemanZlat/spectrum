;(C)1991,92	Graphic	 Library V1.1
;Mednonogov V.S.
NOP_   EQU  0
OR_    EQU  #B6
XOR_   EQU  #AE
AND_   EQU  #A6
NEG_   EQU  #2F

PUTATR PUSH    HL
       PUSH    DE
       PUSH    BC
       LD      A,31
       SUB  L
       JR   C,RETPAT
       INC  A
       CP   B
       JR   C,PUTAT0
       LD   A,B
PUTAT0 SUB  B
       NEG
       LD   (PUTAT4+1),A
       SUB  B
       NEG
       LD   (PUTAT2+1),A
       LD   A,H
       RRCA
       RRCA
       RRCA
       LD   B,A
       AND  #E0	  ;%11100000
       OR   L
       LD   L,A
       LD   A,B
       AND  #03	  ;%0000011
       OR   #58
       LD   H,A
PUTAT1 LD   A,H
       CP   #5B
       JR   NC,RETPAT
       PUSH HL
PUTAT2 LD   B,#FF
PUTAT3 LD   A,(DE)
       INC  DE
       LD   (HL),A
       INC  HL
       DJNZ PUTAT3
PUTAT4 LD   HL,0
       ADD  HL,DE
       EX   DE,HL
       POP  HL
       LD   A,L
       ADD  A,#20    ;%00100000
       LD   L,A
       JR   NC,PUTAT7
       INC  H
PUTAT7 DEC  C
       JR   NZ,PUTAT1
RETPAT POP     BC
       POP     DE
       POP     HL
       RET

PUTSIM PUSH    HL    ;HL(0-23,0-31)
       PUSH    DE
       PUSH    BC
       LD   A,31
       SUB  L
       JR   C,RETSIM
       INC  A
       CP   B
       JP   C,	 PUTSI0
       LD   A,B
PUTSI0 SUB  B
       NEG
       LD   (PUTSI4+1),A
       SUB  B
       NEG
       LD   (PUTSI2+1),A
PUTSI1 LD   A,H
       CP   24
       JR   NC,RETSIM
       PUSH HL
       PUSH DE
       EX   DE,HL
       CALL SCOORD
       POP  DE
PUTSI2 LD   B,0
       PUSH HL
PUTSI3 LD   A,(DE)
       INC  DE
PUTSID OR   (HL)
       LD   (HL),A
       INC  L
       DJNZ PUTSI3
PUTSI4 LD   HL,0
       ADD  HL,DE
       EX   DE,HL
       POP  HL
       INC  H
       LD   A,#07     ;%00000111
       AND  H
       JR   NZ,PUTSI2
       POP  HL
       INC  H
       DEC  C
       JR   NZ,PUTSI1
RETSIM POP     BC
       POP     DE
       POP     HL
       RET

PRINBT DEFB 0
PRINT  PUSH AF
       LD   (PRINBT),A
       LD   A,D
       CP   24
       JR   NC,RETPRI
PRIN2  LD   A,E
       CP   32
       JR   C,PRIN9
       LD   E,0
       INC  D
       LD   A,D
       CP   24
       JR   NC,RETPRI
PRIN9  PUSH    HL
       PUSH    DE
       PUSH    BC
PRIN8  LD      L,(HL)
       LD   H,0
       ADD  HL,HL
       ADD  HL,HL
       ADD  HL,HL
       ADD  HL,BC
       PUSH HL
       CALL SCOORD
       POP  DE
       LD   B,8
PRIN1  LD   A,(DE)
PRINCD OR   (HL)
       LD   (HL),A
       INC  DE
       INC  H
       DJNZ PRIN1
       POP     BC
       POP     DE
       POP     HL
       INC  HL
       INC  E
       LD   A,(PRINBT)
       DEC  A
       LD   (PRINBT),A
       JR   NZ,PRIN2
RETPRI POP  AF
       RET

AT2SCR PUSH    HL
       PUSH    DE
       PUSH    BC
       LD      DE,#5800
       LD   BC,768
       LDIR
       POP     BC
       POP     DE
       POP     HL

GETSIM PUSH    HL
       PUSH    DE
       PUSH    BC

       LD     A,B
       LD   (GETSI2+1),A
GETSI1 PUSH HL
       PUSH DE
       EX   DE,HL
       CALL SCOORD
       POP  DE
GETSI2 LD   B,0
       PUSH HL
GETSI3 LD   A,(HL)
       LD   (DE),A
       INC  DE
       INC  L
       DJNZ GETSI3
       POP  HL
       INC  H
       LD   A,#07     ;%00000111
       AND  H
       JR   NZ,GETSI2
       POP  HL
       INC  H
       DEC  C
       JR   NZ,GETSI1
       POP     BC
       POP     DE
       POP     HL
       RET

GETATR PUSH    HL
       PUSH    DE
       PUSH    BC
       LD      A,B
       LD   (GETAT2+1),A
       LD   A,H
       RRCA
       RRCA
       RRCA
       LD   B,A
       AND  #E0	     ;%11100000
       OR   L
       LD   L,A
       LD   A,B
       AND  #03	     ;%00000011
       OR   #58
       LD   H,A
GETAT2 LD   B,#FF
       PUSH HL
GETAT3 LD   A,(HL)
       LD   (DE),A
       INC  DE
       INC  HL
       DJNZ GETAT3
       POP  HL
GETAT6 LD   A,L
       ADD  A,#20     ;%00100000
       LD   L,A
       JR   NC,GETAT7
       INC  H
GETAT7 DEC  C
       JR   NZ,GETAT2
       POP     BC
       POP     DE
       POP     HL
       RET

SELSCR LD   (SCOSCR+1),A ;A-screen address
       LD   (BCOSCR+1),A
       LD   (PCOSCR+1),A
       RET

PUTSPR PUSH    HL     ;(de)--(hl)(0-191,0-255):b*c
       PUSH    DE
       PUSH    BC
       LD   A,L
       AND  #07	      ;%00000111
       LD   (SHIFTS+1),A
       LD   A,L
       AND  #F8	      ;%11111000
       RRCA
       RRCA
       RRCA
       LD   L,A
       LD   A,B
PUTSP0 LD   (PUTSP2+1),A
PUTSP2 LD   B,0
       LD   A,H
       CP   #C0	       ;%11000000
       JR   NC,RETPSP
       PUSH HL
       PUSH DE
       EX   DE,HL
       CALL BCOORD
       POP  DE
PUTSP1 PUSH BC
       XOR  A
       LD   C,A
SHIFTS OR   0
       LD   B,A
       LD   A,(DE)
       JR   Z,PTSPD1
SHFTDO RRA
       RR   C
       DJNZ SHFTDO
PTSPD1 OR   (HL)
       LD   (HL),A
       LD   A,L
       AND  #18	       ;%00011111
       CP   #18	       ;%00011111
       JR   NC,PUTSP6
       LD   A,C
       INC  L
PTSPD2 OR   (HL)
       LD   (HL),A
       INC  DE
       POP  BC
       DJNZ PUTSP1
PUTSP3 POP  HL
       INC  H
       DEC  C
       JR   NZ,PUTSP2
RETPSP POP     BC
       POP     DE
       POP     HL
       RET
PUTSP6 POP  BC
PUTSP7 INC  DE
       DJNZ PUTSP7
       JR   PUTSP3

BCOORD LD   A,D	;de(0-191,0-31)	-- hl
       RRCA
       RRCA
       RRCA
       AND  #18		;%00011000
BCOSCR ADD  A,#40	;%01000000
       LD   H,A
       LD   A,D
       AND  #07		;%00000111
       ADD  A,H
       LD   H,A
       LD   A,D
       RLA
       RLA
       AND  #E0		;%11100000
       OR   E
       LD   L,A
       RET

PUTSCR PUSH    HL  ;(de)--(hl)(0-191,0-31):b*c
       PUSH    DE
       PUSH    BC
       LD   A,31
       SUB  L
       JR   C,RETPTS
       INC  A
       CP   B
       JR   C,PUTSCB
       LD   A,B
PUTSCB SUB  B
       NEG
       LD   (PUTSC4+1),A
       SUB  B
       NEG
       LD   (PUTSC2+1),A
PUTSC2 LD   B,0
       LD   A,H
       CP   #C0		 ;%11000000
       JR   NC,RETPTS
       PUSH HL
       PUSH DE
       EX   DE,HL
       CALL BCOORD
       POP  DE
PUTSC1 LD   A,(DE)
PUTSCD OR   (HL)
       LD   (HL),A
       INC  DE
       INC  L
       DJNZ PUTSC1
PUTSC4 LD   HL,0
       ADD  HL,DE
       EX   DE,HL
       POP  HL
       INC  H
       DEC  C
       JR   NZ,PUTSC2
RETPTS POP     BC
       POP     DE
       POP     HL
       RET

SCOORD LD   A,D	;de(0-23,0-31)--hl
       AND  #18		   ;%00011000
SCOSCR ADD  A,#40	   ;%01000000
       LD   H,A
       LD   A,D
       RRCA
       RRCA
       RRCA
       AND  #E0		   ;%11100000
       OR   E
       LD   L,A
       RET

MV1TO3 PUSH    HL
       PUSH    DE
       PUSH    BC
       LD      E,0 ;1/3(h)--1/3(d)
       LD   L,E
       LD   BC,#800
       LDIR
       POP     BC
       POP     DE
       POP     HL
       RET

MV2SCR LD   DE,#4000 ;(hl) -- screen
       PUSH BC
       LD   BC,#1800
       LDIR
       POP  BC
       RET

LINE   PUSH    HL   ; line from	p1(l,h)	to p2(e,d)
       PUSH    DE
       PUSH    BC
       PUSH IX
       LD   IX,DATA01
       LD   B,#15
       LD   C,#1D
       LD   A,E
       SUB  L
       JR   NC,M1LIN
       NEG
       EX   DE,HL
M1LIN  LD   L,A
       LD   A,D
       SUB  H
       JR   NC,M2LIN
       NEG
       DEC  B
M2LIN  LD   H,A
       CP   L
       JR   C,M3LIN
       LD   A,B
       LD   B,C
       LD   C,A
       LD   A,H
       LD   H,L
       LD   L,A
M3LIN  LD   A,B
       LD   (DEPENC),A
       LD   A,C
       LD   (INDEPC),A
       PUSH DE
       LD   C,L
       LD   E,L
       LD   L,H
       CALL DIVB
       LD   A,E
       LD   (SIMLIN+1),A
       LD   L,C
       LD   A,L
       LD   (LDLIN+1),A
       LD   A,D
       LD   (DECLIN+1),A
       OR   A
       LD   B,E
       RR   B
       INC  B
       OR   A
       RR   C
       POP  DE
       INC  L
       JR   L4LIN
SIMLIN LD   B,#FF
L4LIN  PUSH HL
       CALL DOT
       POP  HL
INDEPC DEC  D
       DEC  L
       JR   Z,RETLIN
       LD   A,C
DECLIN SUB  #02
       LD   C,A
       JR   C,LDLIN
       DJNZ L4LIN
DEPENC DEC  E
       JR   SIMLIN
LDLIN  ADD  A,#FF
       LD   C,A
       JR   L4LIN
RETLIN POP  IX
       POP     BC
       POP     DE
       POP     HL
       RET

PCOORD LD   A,D	;de(0-191,0-255) -- hl
       RRCA
       RRCA
       RRCA
       LD   L,A
       AND  #18		 ;%00011000
PCOSCR ADD  A,#40	 ;%01000000
       LD   H,A
       LD   A,D
       AND  #07		 ;%00000111
       ADD  A,H
       LD   H,A
       LD   A,L
       LD   L,E
       RRA
       RR   L
       RRA
       RR   L
       RRA
       RR   L
       RET

DATA01 DEFB 128,64,32,16,8,4,2,1
OUTBT  OR   (HL)
       LD   (HL),A
       RET

DOT    LD   A,D	 ;POINT(X:=E,Y:=D)
       CP   #C0		  ;%11000000
       RET  NC
       LD   A,E
       AND  #07		  ;%00000111
       LD   (DCDOT+2),A
       CALL PCOORD
DCDOT  LD   A,(IX+0)
DOTREG OR   (HL)
       LD   (HL),A
       RET

CHNGRG LD   (OUTBT),A
       LD   (PUTSCD),A
       LD   (DOTREG),A
       LD   (PTSPD1),A
       LD   (PTSPD2),A
       LD   (PUTSID),A
       LD   (PRINCD),A
       RET

PLOT   PUSH IX ;*********PLOT E,D
       PUSH HL
       LD   IX,DATA01
       CALL DOT
       POP  HL
       POP  IX
       RET

;MATHEMATICAL LIBRARY  MATH-ZX
FREE16 DEFS 16
MULB2  PUSH HL	     ;HL*E--DE	(C)
       JR   MULENT
MULB   PUSH HL	     ;L*E--DE
       LD   H,0
MULENT LD   A,E
       LD   E,0
       LD   D,E
       JR   MMULB2
MMULB1 ADD  HL,HL
       JR   C,ENDMUL
MMULB2 OR   A
       JR   Z,ENDMUL
       RRA
       JR   NC,MMULB1
       EX   DE,HL
       ADD  HL,DE
       EX   DE,HL
       JR   MMULB1
ENDMUL POP  HL
       RET
MUL    PUSH HL ;HL*DE--DE
       XOR  A
       OR   D
       JR   Z,MULENT
       EX   DE,HL
       XOR  A
       OR   D
       JR   Z,MULENT
       SCF
       POP  HL
       RET
DIVB   LD   D,0	;E/L--E	(MOD in	D)
DIVB2  PUSH HL ;DE/L--E
       PUSH BC
       LD   B,8
       EX   DE,HL
       LD   D,E
       LD   E,0
DIV1B  OR   A
       RR   D
       RR   E
       SBC  HL,DE
       JR   NC,MDIVB
       ADD  HL,DE
MDIVB  RLA
       DJNZ DIV1B
       CPL
       LD   D,L
       LD   E,A
       POP  BC
       POP  HL
       RET

SYMBOL PUSH HL;in L -sym.code
       LD   H,L
       LD   L,#21
       LD   (PRIN8),HL
       CALL PRINT
       LD   HL,#266E
       LD   (PRIN8),HL
       POP  HL
       RET

STRLEN PUSH HL;c-CR nc-NULL
       PUSH BC
       LD   B,#FF
STRLE1 LD   A,(HL)
       INC  HL
       INC  B
       OR   A
       JR   Z,STRLE4
       CP   13
       JR   NZ,STRLE1
       SCF
STRLE4 LD   A,B
       POP  BC
       POP  HL
       RET

ATRBAR PUSH HL;	A -ATTR
       LD   H,A
       LD   L,#3E
       LD   (PUTAT3),HL
       POP  HL
       CALL PUTATR
       PUSH HL
       LD   HL,#131A
       LD   (PUTAT3),HL
       POP  HL
       RET

SIMBAR PUSH HL
       LD   H,A	; A-filled byte
       LD   L,#3E
       LD   (PUTSI3),HL
       POP  HL
       CALL PUTSIM
       PUSH HL
       LD   HL,#131A
       LD   (PUTSI3),HL
       POP  HL
       RET

; GrLib	end
