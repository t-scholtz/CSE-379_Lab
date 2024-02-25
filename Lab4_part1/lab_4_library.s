	.text
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global div_and_mod

U0FR: 	.equ 0x18	; UART0 Flag Register
;----------------------------------------------------------------
;Uart init - handles setting up connection to Uart
;----------------------------------------------------------------
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
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;GPIO Button and LED INI - initliase on board button and led for
;use
;----------------------------------------------------------------
gpio_btn_and_LED_init:
	PUSH {r4-r12,lr}
	;SET BUTTON - SW1 - Port F Pin 4 - read | SET LED - Port F pin 1,2,3 - write
	MOV r0, #5			;port f
	Mov r1, #0x5000		;port f memory address
	MOVT r1 , #0x4002
	MOV r2, #0x07		;Pin 4 will be read - set 0 | pin 1,2,3 will be write - set 1
	MOV r3, #0x0F		;Pin 1,2,3,4 set active
	BL gpio_setup
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;GPIO setup - help method to setup gpio communication
;Input: r0 - port (A-F|0-5)
;		r1 - port memory address
;		r2 - set pins as read or write (8bit input)[0-read 1-write]
;		r3 - set which pins are active (8bit input)[0-off  1-on]
;----------------------------------------------------------------
gpio_setup:
	PUSH {r4-r12,lr}
	;SET CLOCK
	MOV r4,#0xE608
	MOVT r4, #0x400F	;load clck memeory address
	STRB r0, [r4]		;store new settings
	;SET DIRECTION FOR EACH PIN
	MOV r6, #0x400		;offset for data direction
	STRB r2, [r1,r6]	;store new settings
	;SET EACH GPIO PIN AS DIGITAL
	MOV r6, #0x051C		;offset for data direction
	STRB r3, [r1,r6]	;store new settings
	;SET PULL UP RESIGIOR FOR  READ REGISTORS ***May remove this part from this subroutine in future***
	MOV r6 , #0x510
	MVN r7,r2			;invert read/write pins
	AND r3,r3,r7		;isolate just read pins to select for pull up registors
	STRB r3, [r1,r6]
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;Output Char - Takes an ascii byte in r0 and outputs to terminal
;----------------------------------------------------------------
output_character:
	PUSH {r4-r12,lr}
    MOVT r4, #0x4000	;Load Memory address into r4
WAIT2OUTPUT:			;loop to keep waiting for flag to be flipped
	LDRB r5, [r4, #U0FR];load uart flag registor into r5
	AND r5, #32
	CMP r5, #0
	BNE WAIT2OUTPUT	;if flag is not flipped, keep waiting
	STRB r0, [r4]	;store the byte to ouptut in uart Data registor
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;Read Char - Takes ascii char from uart and stores in r0
;----------------------------------------------------------------
read_character:
	PUSH {r4-r12,lr}
    MOV r4,#0xC000
	MOVT r4, #0x4000	;Load Memory address into r4
WAIT4INPUT:
	LDRB r0, [r4, #U0FR];Flag register
	AND r0, r0, #0x0010;checks RxFE
	CMP r0, #0;checks if 0
	BNE WAIT4INPUT
	LDRB r0, [r4] ;load char from uart data reg
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;Read String - Takes address in r0 and stores a string from term
;at memory location null terminated
;----------------------------------------------------------------
read_string:
	PUSH {r4-r12,lr}
    MOV r4, r0 ;Address of passed through string
READLOOP:
	BL read_character
	CMP r0, #13
	BEQ EXITREAD
	STRB r0, [r4]
	ADD r4, #1	;incrementing 1 byte
	B READLOOP
EXITREAD:
	MOV r0, #0
	STRB r0, [r4]
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;Output String - Takes address in r0 and outputs null terminated
;string stored at memory location to term
;----------------------------------------------------------------
output_string:
	PUSH {r4-r12,lr}
	MOV r4,r0
PRINTLOOP:
 	LDRB r0, [r4]
	CMP r0, #0x00
	BEQ PRINTEXIT
	BL output_character
	ADD r4,r4 ,#1		;1 = byte not bits
	B PRINTLOOP
PRINTEXIT:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;XXX - ABCDE
;----------------------------------------------------------------
read_from_push_btns:
	PUSH {r4-r12,lr}


	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;XXX - ABCDE
;----------------------------------------------------------------
illuminate_LEDs:
	PUSH {r4-r12,lr}


	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;XXX - ABCDE
;----------------------------------------------------------------
illuminate_RGB_LED:
	PUSH {r4-r12,lr}


	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;Read SW1 button - return value in r0 - 1 if button is pressed
;----------------------------------------------------------------
read_tiva_push_button:
	PUSH {r4-r12,lr}
	MOV r4, #0x5000		;port f memory address
	MOVT r4 , #0x4002
	MOV r5, #0x3FC
	LDRB r0, [r4,r5]
	AND r0, #0x4
	EOR r0,r0, #0xFFFFFFFF
	LSR r0,r0,#3

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;DIV and MOD -  r0/r1 = r0 remainder r1
;Accepts a dividend in r0 and a divsor in r1and an integer
;returns the quotient in r0 and the remainder in r1.
;----------------------------------------------------------------
div_and_mod:
	PUSH {r4-r12,lr}
        MOV r4, r1 ;Sets the temp vals, this is the divisor
        MOV r5, r0 ;Sets the temp vals, this is the number to divide, the remainder is stored in r1
        MOV r2, #0 ;resets this the counter returned in r0
        MOV r6, #0 ;resets
        MOV r7, #0xFFFF	;all ones
        MOVT r7, #0xFFFF	;all ones
        CMP r4, #0 ;comparing it to zero
        BGT NEGCHECK
        EOR r4, r4, r7 ;flips bits for the divisor
        ADD r4, r4, #1 ;adds 1 for twos comp
        ADD r6, r6, #1 ;For the negative sign
NEGCHECK:
        CMP r5, #0
        BGT MOD_DIV_LOOP
        EOR r5, r5, r7 ;flips bits for the divided
        ADD r5, r5, #1
        ADD r6, r6, #1 ;For the negative sign
MOD_DIV_LOOP:
        CMP r5, r4
        BLT MOD_DIV_DONE
        SUB r5, r5, r4
        ADD r2, r2, #1;counting up everytime something divides
        B MOD_DIV_LOOP
MOD_DIV_DONE:;checks for negative in and flip to get correct output
        CMP r6, #1
        BNE MOD_DIV_NOT_NEG
        EOR r2, r2, r7 ;flips bits for the divisor
        ADD r2, r2, #1 ;adds 1 for twos comp
MOD_DIV_NOT_NEG:
        MOV r0, r2
        MOV r1, r5
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

	.end
