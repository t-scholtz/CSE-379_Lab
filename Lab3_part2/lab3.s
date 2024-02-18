	.data

	.global prompt
	.global dividend
	.global divisor
	.global quotient
	.global remainder

prompt:		.string "Enter 2 integers", 0
dividend: 	.string "Place holder string for your dividend", 0
divisor:  	.string "Place holder string for your divisor", 0
quotient:	.string "Your quotient is stored here", 0
remainder:	.string "Your remainder is stored here", 0


	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt:			.word prompt
ptr_to_dividend:		.word dividend
ptr_to_divisor:		.word divisor
ptr_to_quotient:		.word quotient
ptr_to_remainder:		.word remainder


;LAB 3 - function call
;*****************************************************************************
lab3:
		PUSH {r4-r12,lr}

	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_dividend
	ldr r6, ptr_to_divisor
	ldr r7, ptr_to_quotient
	ldr r8, ptr_to_remainder

		; Your code is placed here.  This is your main routine for
		; Lab #3.  This should call your other routines such as
		; uart_init, read_string, output_string, int2string, &
		; string2int
lab3_end:

	POP {r4-r12,lr}
	mov pc, lr
;*****************************************************************************

;UART INIT - initializes the user UART
;*****************************************************************************
uart_init:
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
;*****************************************************************************

;READ CHARACTER - reads a character which is received by the UART and outputs it to ro
;*****************************************************************************
read_character:  			;The character is received in r0.
	PUSH {r4-r12,lr}

	MOV r4,#0xC000
	MOVT r4, #0x4000	;Load Memory address into r4
LOOPRC:
	LDRB r0, [r4, #U0FR];Flag register
	AND r0, r0, #0x0010;checks RxFE
	CMP r0, #0;checks if 0
	BNE LOOPRC
FINISHRC:
	LDRB r0, [r4] ;load char from uart data reg

	POP {r4-r12,lr}
	mov pc, lr
;*****************************************************************************


;READ STRING - reads a string entered in PuTTy and stores it as a NULL-terminated ASCII string in memory, base address passed in ro
;*****************************************************************************
read_string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your read_string routine is placed here

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr
;*****************************************************************************

;OUTPUT CHARACTER - The character to be displayed is passed into the routine in r0.
;*****************************************************************************
output_character:
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
;*****************************************************************************

;OUTPUT STRING - transmits a NULL-terminated ASCII string, for display in PuTT, pass in mem address to r0
;*****************************************************************************
output_string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
	MOV r4,r0
	MOV r5, #0
outputLoop:
	LDRB r0, [r5, r4]
	CMP r0, #0x00
	BEQ exitOutLoop
	BL output_character
	ADD r4, #8
	B outputLoop
exitOutLoop:
	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
	mov pc, lr
;*****************************************************************************


;INT 2 STRING - stores the integer passed into the routine in r1 as a NULL terminated ASCII string in memory at the address passed into the routine in r0.
;*****************************************************************************
int2string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your int2string routine is placed here

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr
;*****************************************************************************


;STRING 2 INT - converts the NULL terminated ASCII string pointed to by the address passed into the routine in r0 to an integer. The integer should be returned in r0
;*****************************************************************************
string2int:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
	MOV r4, #0			;Cursor

	LDRB r5, [r0, r4]
	SUB r5, #0x30
	ADD r4, #8

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr
;*****************************************************************************


:DIV AND MOD - Accepts a dividend in r0 and a divsor in r1and an integer returns the quotient in r0 and the remainder in r1.
;*****************************************************************************
div_and_mod:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
	CMP r0, #0
	BEQ zero		;check if we're diving by 0 and if so special case - return 0 and 0
	MOV r3, r0		;check if r0 is negative, if so inverts it
	CMP r3, #0
	BGT pos1
	BL invert
	MOV r4,r2		;Move flag to r4
	MOV r0,r3		;move inverted value back to r0
pos1:
	MOV r3, r1		; check if r0 is negative, if so inverts
	CMP r3, #0
	BGT pos2
	BL invert
	MOV r5,r2		;move flag to r5
	MOV r1,r3		;move inverted value back to r1
pos2:
	MOV r2,#0		;Clear r2

div:				;Division Time! LETS GO!!!!!!!
	CMP r1,r0		;Keeps subractinb while dividor number is bigger than divosor or somthing
	BGT div_done
	ADD r2,r2,#1
	SUB r0,r0,r1
	B div

div_done:
	cmp r4,r5		;Check if one value was neg and if we need to invert answer accoringly
	BEQ skip
	MOV r3, r1
	BL invert
	MOV r1,r3
skip:
	MOV r3, r0		;Move values around to put returned values where they are expected to go
	MOV r0, r1
	MOV r1, r3
	POP {r4-r12,lr}
	MOV pc, lr		;Exit the divider program
zero:				; Divde by zero edge case
	MOV r0, #0
	MOV r1, #0
	POP {r4-r12,lr}
	MOV pc, lr
invert:				;Pass a value in r3 and returns the complement of that value + returns a flag in marker in r4
	PUSH {r4-r12,lr}
	MOV r2,#1
	MOV r4, #0xFFFF
	MOVT r4,# 0xFFFF
	EOR	r3, r3, r4
	ADD  r3, r3, #1
	POP {r4-r12,lr}
	MOV pc, lrr your div_and_mod routine is placed here
;*****************************************************************************

	.end
