	.text

	.global lab3

U0FR: 	.equ 0x18	; UART0 Flag Register

lab3:
	PUSH {r4-r12,lr}


INFLOOP:
		BL read_character
		BL output_character
		B INFLOOP

		; Your test code ends here

	; After testing is complete, you can return to your C wrapper
	; using the POP & MOV instructions shown below.

	POP {r4-r12,lr}
	mov pc, lr


output_character: 	; Your code to output a character to be displayed in PuTTy
					; is placed here.  The character to be displayed is passed
					; into the routine in r0.
	PUSH {r4-r12,lr}
	MOV r4,#0xC000
	MOVT r4, #0x4000	;Load Memory address into r4

WAITFORCHAR:			;loop to keep waiting for flag to be flipped
	LDRB r5, [r4, #U0FR];load uart flag registor into r5
	AND r5, #32
	CMP r5, #0
	BNE WAITFORCHAR	;if flag is not flipped, keep waiting

	STRB r0, [r4]	;store the byte to ouptut in uart Data registor

	POP {r4-r12,lr}
	mov pc, lr

read_character: 	 ; Your code to receive a character obtained from the keyboard
					 ; in PuTTy is placed here.  The character is received in r0.
	PUSH {r4-r12,lr}
	MOV r4,#0xC000
	MOVT r4, #0x4000	;Load Memory address into r4

	;Start
	;/Load in value at UART address + 18
	;AND 5th bit in order to check if 1 or 0
	;if 0 read from UART address, STOP
	;if 1 loop and do it again

LOOPRC:
	LDRB r0, [r4, #U0FR];Flag register
	AND r0, r0, #0x0010;checks RxFE
	CMP r0, #0;checks if 0
	BNE LOOPRC
FINISHRC:
	LDRB r0, [r4] ;load char from uart data reg

	POP {r4-r12,lr}
	mov pc, lr


	.end
