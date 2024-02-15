	.text

	.global lab3

U0FR: 	.equ 0x18	; UART0 Flag Register

lab3:
	PUSH {r4-r12,lr}

		; Your test code starts here.
		; For example, the following two lines read a character from the
		; user and then print it to PuTTy.

		BL Uart_init
INFLOOP:
		BL read_character
		BL output_character
		B INFLOOP

		; Your test code ends here

	; After testing is complete, you can return to your C wrapper
	; using the POP & MOV instructions shown below.

	POP {r4-r12,lr}
	mov pc, lr

Uart_init:	;sub routine handles setting up connection to Uart
	PUSH {r4-r12,lr}

	MOV r4, #0xE618
	MOVT r4,#0x400F
	MOV r5, #1
	STR r5,[r4]		;Provide clock to UART0

	MOV r4, #0xE608
	MOVT r4,#0x400F
	MOV r5, #1
	STR r5,[r4]		;Enable clock to PortA

	MOV r4, #0xC030
	MOVT r4,#0x4000
	MOV r5, #0
	STR r5, [r4]		; Disable UART0 Control

	MOV r4, #0xC024
	MOVT r4,#0x4000
	MOV r5, #8
	STR r5,[r4]		; Set UART0_IBRD_R for 115,200 baud

	MOV r4, #0xC028
	MOVT r4,#0x4000
	MOV r5, #44
	STR  r5,[r4]		; Set UART0_FBRD_R for 115,200 baud

	MOV r4, #0xCFC8
	MOVT r4,#0x4000
	MOV r5, #0
	STR r5,[r4]		; * Use System Clock

	MOV r4, #0xC02C
	MOVT r4,#0x4000
	MOV r5, #0x60
	STR r5,[r4]		;Use 8-bit word length, 1 stop bit, no parity

	MOV r4, #0xC030
	MOVT r4,#0x4000
	MOV r5,#0x301
	STR  r5,[r4]		;Enable UART0 Control

	;OR operational setup
	MOV r4,#0x451C
	MOVT r4, #0x4000	;Load Memory address

	LDR r5, [r4] ;make P0 and PA1 as a Digital Ports
	ORR r5, r5, #0x03
	STR r5, [r4]

	MOV r4,#0x4420
	MOVT r4, #0x4000

	LDR r5, [r4] ;change P0, PA1 to use alternate function
	ORR r5, r5, #0x03
	STR r5, [r4]

	MOV r4,#0x452C
	MOVT r4, #0x4000

	LDR r5, [r4] ;configure P0, PA1 for UART
	ORR r5, r5, #0x11
	STR r5, [r4]

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
