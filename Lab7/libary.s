	.data

;LIST OF SUBROUTINES
;================================================================
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global illuminate_RGB_LED
	.global illuminate_LEDs
	.global read_tiva_push_button
	.global div_and_mod
	.global int2string
	.global string2int
	.global portINIT
	.global printBits
	.global ERRORFOUND
	.global gpio_interrupt_init
	.global uart_interrupt_init
	.global timer_init
	.global ansi_print


;PROGRAM DATA
;================================================================
errorPrompt:	.string "Error with subroutine", 0 ;Question to see if we can do this in this file
newLine:		.byte 0x0D, 0x0A , 0x00,  0x00
lookUpTbl:		;80 - move cur pos(x,y) ; 81 mov cur spaces
				.string 27,"[0m",0,0,0,0,0,0,0,0; 82 - reset seetings to normal ;This is the look up table for ansi print.
				.string 27,"[2J",27,"[1;1H",0,0	; 83 - clear screen and move cursor top right
				.string 27,"[25l",0,0,0,0,0,0,0	; 84 - hide cursor
				.string 27,"[25h",0,0,0,0,0,0,0	; 85 - show curso
				.string 27,"[91m",0,0,0,0,0,0,0	; 86 - HI Red
				.string 27,"[92m",0,0,0,0,0,0,0	; 87 - HI Green
				.string 27,"[93m",0,0,0,0,0,0,0	; 88 - HI Yellow
				.string 27,"[94m",0,0,0,0,0,0,0	; 89 - HI Blue
				.string 27,"[95m",0,0,0,0,0,0,0	; 8A - HI Pink
				.string 27,"[96m",0,0,0,0,0,0,0	; 8B - HI Turquie
				.string 27,"[97m",0,0,0,0,0,0,0	; 8C - Hi White
				.string 27,"[97m",0,0,0,0,0,0,0	; 8C - Move cursor by X (you mst specify x value afterwards)
				.string 27,"[97m",0,0,0,0,0,0,0	; 8C - Hi White
temp:			.string "blank Space",0
;================================================================

	.text

;POINTERS TO STRING
;================================================================
ptr_to_errorPrompt:		.word errorPrompt
ptr_to_newLine:			.word newLine
ptr_to_lookUpTbl:		.word lookUpTbl
ptr_to_temp:			.word temp
;================================================================

;LIST OF CONSTANTS
;================================================================
U0FR: 				.equ 0x18	; UART0 Flag Register
GPIODATA:			.equ 0x3FC 	;data location
GPIODIG:			.equ 0x51C 	;Pin activation location
GPIODIR:			.equ 0x400  ;Pin Direction location
GPIOPUR: 			.equ 0x510	;Pull-Up Resistor
UARTIM: 			.equ 0x038		; UARTIM offset
UARTICR:			.equ 0x044  	;Interrupt clear register
ENO:				.equ 0x100		;Enable pin interupt offset
GPIOIS: 			.equ 0x404		;GPIO Interrupt Sense Register
GPIOIBE:			.equ 0x408 		;GPIO Interrupt Both Edges Register
GPIOIV:				.equ 0x40C		;GPIO Interrupt Event Register
GPIOIM:				.equ 0x410		;GPIO Interrupt Mask Register
GPIOICR:			.equ 0x41C		;GPIO Interrupt Clear Register


;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;Ansi_print - prints a string, and looks for our escape
;commands in the string, check docs for defintions
;	input r0 - string to print memory address
;----------------------------------------------------------------
ansi_print:
	PUSH {r4-r12,lr}
	MOV r4,r0			;r4 is reseverd to keep track of string index
ANSILOOP:
 	LDRB r0, [r4],#1
	CMP r0, #0x00
	BEQ ANSIEXIT
	CMP r0, #0x81
	BGT LOADANSI
	CMP r0, #0x80
	BEQ MOV_CUR_POS
	CMP r0, #0x81
	BEQ MOV_CUR_SPC
	BL output_character
	B ANSILOOP
LOADANSI:
	MOV r5, r0			;save a copy of the value of r0 in r5
	SUB r1, r0,#0x82	;r1 is the offset value
	MOV r2,	#12			;r2 - size of row in lookup table
	MUL r1,r1,r2		;calulate offset
	LDR r2, ptr_to_lookUpTbl
	ADD	r0,r1,r2		;add the memory address plus offset together
	MOV r1, #1			;don't print new line
	BL output_string
	B ANSILOOP
MOV_CUR_POS:
	LDRSB r1, [r4],#1	;x val
	LDRSB r2, [r4],#1	;y val
	MOV r5, r1			;save x
	MOV r6, r2			;save y
	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[
	LDR r0, ptr_to_temp
	MOV r1,r6
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string		;print num down
	MOV r0, #59
	BL output_character		;print ;
	LDR r0, ptr_to_temp
	MOV r1,r5
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string		;print num right
	MOV r0, #72
	BL output_character		;print H
	B ANSILOOP

MOV_CUR_SPC:
	LDRSB r1, [r4],#1	;left/right val
	LDRSB r2, [r4],#1	;up/down val

	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[

	LDR r0, ptr_to_temp
	CMP r1,#0
	BLT MOV_RIGHT
MOV_LEFT:
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string
	MOV r0, #67
	B MOV_UD
MOV_RIGHT:
	MVN r1, r1
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string
	MOV r0, #68
MOV_UD:
	BL output_character

	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[

	LDR r0, ptr_to_temp
	CMP r2, #0
	BLT MOV_UP
MOV_DOWN:
	MOV r1,r2
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string
	MOV r0, #64
	BL output_character
	B ANSILOOP
MOV_UP:
	MVN r1, r2
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string
	MOV r0, #63
	BL output_character
	B ANSILOOP

ANSIEXIT:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;GPIO Button and LED INI - initliase on board button and led for
;use
;----------------------------------------------------------------
gpio_btn_and_LED_init:
	PUSH {r4-r12,lr}
	;SET CLCK TO 000
	MOV r4,#0xE608
	MOVT r4, #0x400F	;load clck memeory address
	MOV r0, #0x0000
	STRB r0, [r4]
	;SET BUTTON - SW1 - Port F Pin 4 - read | SET LED - Port F pin 1,2,3 - write
	MOV r0, #32			;port f
	MOV r1, #0x5000		;port f memory address
	MOVT r1 , #0x4002
	MOV r2, #0x0E		;Pin 4 will be read - set 0 | pin 1,2,3 will be write - set 1
	MOV r3, #0x1E		;Pin 1,2,3,4 set active
	BL gpio_setup
	MOV r0, #0x10		;pull up registors
	STRB r3, [r1,#GPIOPUR]

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
	LDRB r9, [r4]
	ORR r0,r0,r9
	NOP
	STRB r0, [r4]		;store new settings
	NOP
	NOP
	;SET DIRECTION FOR EACH PIN		;offset for data direction
	STRB r2, [r1, #GPIODIR]	;store new settings
	;SET EACH GPIO PIN AS DIGITAL
	STRB r3, [r1,#GPIODIG]	;store new settings
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;illuminate_RGB_LED: - illuminates the RBG LED
;	input - R1 will be the address of the colors number passed through.//NEEDS TO BE F FOR THIS ONE
;		  - R0 input color
;----------------------------------------------------------------
illuminate_RGB_LED:
	PUSH {r4-r12,lr};The color from the colorPrompt is passed into r0 ;WE will need a color prompt sub routine too
	CMP r0, #0;checks error ;Decide with tim if we should loop in here or only print out the message and continue
	BLS ERRORFOUND;This should be an end of the road subroutine so it will stop us if there is an issue
	;If white
	CMP r0, #1
	BEQ whiteOUT
	;If red
	CMP r0, #2
	BEQ redOUT
	;If green
	CMP r0, #3
	BEQ greenOUT
	;If blue
	CMP r0, #4
	BEQ blueOUT
	;If purple
	CMP r0, #5
	BEQ purpleOUT
	;If yellow
	CMP r0, #6
	BEQ yellowOUT
	B ERRORFOUND;this is if no options were found; Mabye create a user error sub???
whiteOUT:
	MOV r0, #0xE ;should be 1110
	B FINALilluminate_RGB_LED
redOUT:
	MOV r0, #0x2 ;should be 0010
	B FINALilluminate_RGB_LED
greenOUT:
	MOV r0, #0x8 ;should be 1000
	B FINALilluminate_RGB_LED
blueOUT:
	MOV r0, #0x4 ;should be 0100
	B FINALilluminate_RGB_LED
purpleOUT:
	MOV r0, #0x6 ;should be 0110
	B FINALilluminate_RGB_LED
yellowOUT:
	MOV r0, #0xA ;should be 1100 ;i have NO CLUE IF I AM ACCESSING THE PINS CORRECTLY
	B FINALilluminate_RGB_LED
FINALilluminate_RGB_LED:
	STRB r0, [r1, #GPIODATA]
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
	LDRB r0, [r4,#GPIODATA]
	AND r0, #0x10 		;convert it so 1 is off and 0 is on
	EOR r0,r0, #0x10
	LSR r0,r0,#4
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
    CMP r4, #0 ;comparing it to zero
    BGT NEGCHECK
    EOR r4, r4, #0xFFFFFFFF ;flips bits for the divisor
    ADD r4, r4, #1 ;adds 1 for twos comp
    ADD r6, r6, #1 ;For the negative sign
NEGCHECK:
    CMP r5, #0
    BGT MOD_DIV_LOOP
    EOR r5, r5, #0xFFFFFFFF ;flips bits for the divided
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
    EOR r2, r2, #0xFFFFFFFF ;flips bits for the divisor
    ADD r2, r2, #1 ;adds 1 for twos comp
MOD_DIV_NOT_NEG:
    MOV r0, r2
    MOV r1, r5
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;INT 2 STRING - converts an int to a string
;	input - r1 - int to convert
;		  - r0 - address to strore string as null terminalted
;----------------------------------------------------------------
int2string:
	PUSH {r4-r12,lr}
	MOV r4, r1	;Storing the original integer
	MOV r5, r0	;Storing the Strings address
	CMP r4, #0 ;comparing r4 to zero to see if we need to deal with -
    BGE INT2STRING_NEG_SKIP
    EOR r4, r4, #0xFFFFFFFF ;flips bits for the string output to make it easy
    ADD r4, r4, #1 ;adds 1 for twos comp
    MOV r1, #0x2D;this is a - for negative
    STRB r1, [r5], #1 ;store the string character to string address
INT2STRING_NEG_SKIP:
	;divide by 100 to start
	MOV r0, r4 ;setting divised
	MOV r1, #100;setting divisor ;it will allow us to get the least sig decimal and change it one by one into strings
	BL div_and_mod
	ADD r0, r0, #48;takes divided and adjusts the value to represent the character so we can store this number correctly
	MOV r4, r1;this is the division output to continue the cycle
	STRB r0, [r5], #1;store the string character to string address
	;Now divide by 10 to get our last 2 digits
	MOV r0, r4 ;setting divised
	MOV r1, #10;setting divisor ;it will allow us to get the least sig decimal and change it one by one into strings
	BL div_and_mod
	ADD r0, r0, #48;takes divided counter and adjusts the value to represent the character
	ADD r1, r1, #48;takes remainder and adjusts the value to represent the character
	STRB r0, [r5], #1;store the string character to string address
	STRB r1, [r5], #1;store the string character to string address
	MOV r4, #0x00
	STRB r4, [r5];stores a NULL at the string address to stop the end of the string
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;STRING 2 INT - converts the NULL terminated ASCII string pointed
;to by the address passed into the routine in r0 to an integer.
;The integer should be returned in r0
;----------------------------------------------------------------
string2int:
	PUSH {r4-r12,lr} ; Store any registers in the range of r4 through r12
	MOV r4, r0 		;Address of passed through string
	MOV r5,#1
	MOV r10, #10
	MOV r6 , #0 	;accumnator
	SUB r4,r4,#1
negFlag:
	EOR r5, #1		;neg flag
	ADD r4,r4,#1
stringIntLoop:
	LDRB r0, [r4], #1
	CMP r0, #00		;Check for null terminator
	BEQ ExitstringIntLoop
	;STRB r0, [r4]	;load char
	CMP r0, #0x2D	;check for neg
	BEQ negFlag
  	SUB r0, r0, #0x30
  	MUL r6, r6, r10
  	ADD r6,r6, r0
	B stringIntLoop
ExitstringIntLoop:
	CMP r5, #0x01
	BNE stringIntSkip
	EOR	r6, r6, #0xFFFFFFFF
	ADD  r6, r6, #1
stringIntSkip:
	MOV r0, r6
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;portINIT - SUBroutine given 0-5(A->F) to represent ports
; The function returns the address of the port in R1
;----------------------------------------------------------------
portINIT:
	PUSH {r4-r12,lr}
	CMP r0, #0
	BLE ERRORFOUND
	CMP r0, #4
	BLE A2D
	CMP r0, #6
	BLE E2F
	BL ERRORFOUND;in the case that we passed in a bad choice
A2D:
	MOV r1, #0x4000 ; Getting port D loaded up
	ADD r1,r1 ,r0, LSL #12
	MOVT r1, #0x4000
	B FINALportINIT
E2F:
	MOV r1, #0x0000 ; Getting port F loaded up
	ADD r1,r1 ,r0, LSL #12
	MOVT r1, #0x4002
	B FINALportINIT
FINALportINIT:;comes here once we are all done and we use r1 as the port address
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;printBits -prints the bits inside of a registor
;Input	   r0 - value to print
;		   r1 - num of bits to print
;----------------------------------------------------------------
printBits:
	PUSH {r4-r12,lr}
	MOV r4,r0
	MOV r5,r1
	CMP r5, #0
	BLE ERRORFOUND	;input valid check - if less than 0 throw error
	MOV r9,#1 		;bit mask
	SUB r1,r1,#1
	LSL r9, r1		;starting point of the mask
	CMP r5, #32		;					 if more that 32 set to 32
	BLE BITLOOP
	MOV r5, #32
BITLOOP:
	AND r6, r4,r9	;load bit to print
	CMP r5,#0
	BEQ BITEXIT
	LSR r9,r9,#1	;update mask
	SUB r5,r5,#1
	CMP r6, #0
	BEQ PRINT0
PRINT1:
	MOV r0,#0x31
	BL output_character
	B BITLOOP
PRINT0:
	MOV r0,#0x30
	BL output_character
	B BITLOOP
BITEXIT:
	LDR r0, ptr_to_newLine
	BL output_string
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;ERRORFOUND - Exits code safetly
;----------------------------------------------------------------

ERRORFOUND:
	LDR r0, ptr_to_errorPrompt
	BL output_string;the prompt being printed is in r0
;================================================================

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
;Output Char - Takes an ascii byte in r0 and outputs to terminal
;----------------------------------------------------------------
output_character:
	PUSH {r4-r12,lr}
	MOV r4,#0xC000
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
	STRB r0, [r4], #1
	B READLOOP
EXITREAD:
	MOV r0, #0
	STRB r0, [r4]
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;Output String -
;input	- r0 - address of null terminated string
;	  	- r1 - new line conidtion - set to neg value to turn on
;string stored at memory location to term
;----------------------------------------------------------------
output_string:
	PUSH {r4-r12,lr}
	MOV r4,r0
PRINTLOOP:
 	LDRB r0, [r4],#1
	CMP r0, #0x00
	BEQ PRINTEXIT
	BL output_character
	B PRINTLOOP
PRINTEXIT:
	cmp r1 , #0
	BGE NONEWLINE
	MOV r2,r1
	MOV r1, #1
	LDR r0, ptr_to_newLine
	BL output_string
	MOV r1,r2
NONEWLINE:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;uart_interrupt_init: This subroutine will generate an interupt
;when a keystroke is generated by a user in PUTTY
;----------------------------------------------------------------
uart_interrupt_init:

	MOV r0, #0xC000 ;This is the UART Base address
	MOVT r0, #0x4000
	LDR r1, [r0, #UARTIM]	;This loads the base value of the UARTIM data and we need to update it
	ORR r1, r1, #16			;Now we have the updated value to store back
	STR r1, [r0, #UARTIM]
							;Now we need to set the ENABLE pin
	MOV  r0, #0xE000 		;This is the UART Base address
	MOVT r0, #0xE000
							;We need to access bit 5 at the ENABLE position
	LDR r1, [r0, #ENO]	;This loads the base value of the ENABLE data and we need to update it
	ORR r1, r1, #32			;Now we have the updated value to store back
	STR r1, [r0, #ENO]

	MOV r0, #0xC000 					;This is the UART Base address
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTICR]				;This loads the base value of the UARTIM data and we need to update it
	ORR r1, r1, #0x10			;Should set the 4th bit to 0 to clear register
	STRB r1, [r0, #UARTICR]
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;gpio_interrupt_init - initliase interupt for sw1
;----------------------------------------------------------------
gpio_interrupt_init:
	PUSH {r4-r12,lr}
	MOV r0,#5		;load port f
	BL portINIT
	MOV r0,r1
	LDRB r1, [r0,#GPIOIS]
	AND r1,r1,#0xEF
	STRB r1, [r0,#GPIOIS]
	LDRB r1, [r0,#GPIOIBE]	;set to trigger on single edge change
	AND r1,r1,#0xEF
	STRB r1, [r0,#GPIOIBE]
	LDRB r1, [r0,#GPIOIV]	;set to trigger on falling edge
	ORR r1,r1,#0x10
	STRB r1, [r0,#GPIOIV]
	LDRB r1, [r0,#GPIOIM]	;
	ORR r1,r1,#0x10
	STRB r1, [r0,#GPIOIM]
	MOV r0, #0xE000
	MOVT r0, #0xE000
	LDR r1, [r0,#0x100]
	MOV r2, #0
	MOVT r2, #0x4000
	ORR r1,r1,r2
	STR r1, [r0,#0x100]
	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0,#GPIOICR]
	ORR r1,r1,#16
	STRB r1, [r0,#GPIOICR]
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;timer_init - conencts the timer to the interupt handler
;	r0 - time between interupts
;----------------------------------------------------------------
timer_init:
	PUSH {r4-r12,lr}
	MOV r5,r0 ;save timer period
	MOV r0, #0xE604
	MOVT r0, #0x400F
	LDRB r1, [r0]
	ORR r1,r1,#1
	STRB r1, [r0]

	MOV r0, #0xC
	MOVT r0, #0x4003
	LDRB r1,[r0]
	AND r1, r1,#0xFE
	STRB r1, [r0]

	MOV r0,#0
	MOVT r0, #0x4003
	LDRB r1,[r0]
	AND r1, r1, #0xF8
	STRB r1, [r0]

	MOV r0, #4
	MOVT r0, #0x4003
	LDRB r1, [r0]
	AND r1, r1, #0xFC
	ORR r1, r1, #2
	STRB r1, [r0]
	;Set timer lenght here -- stored in R0
	MOV r0,#0x28
	MOVT r0, #0x4003
	STR r5, [r0]

	MOV r0,#0x18
	MOVT r0, #0x4003
	LDRB r1,[r0]
	ORR r1, r1, #0x01
	STRB r1, [r0]

	MOV r0,#0xE100
	MOVT r0, #0xE000
	LDR r1, [r0]
	MOV r2, #0
	MOVT r2, #0x0008
	ORR r1, r1, r2
	STR r1, [r0]

	MOV r0,#0x18
	MOVT r0, #0x4003
	LDRB r1,[r0]
	ORR r1, r1, #0x01
	STRB r1, [r0]

	MOV r0,#0xC
	MOVT r0, #0x4003
	LDRB r1,[r0]
	ORR r1, r1, #0x01
	STRB r1, [r0]

	MOV r4, #0x0000
	MOVT r4, #0x4003
	LDRB r6, [r4, #0x024]
	ORR r6,r6, #0x01
	STRB r6, [r4, #0x024]

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;illuminate_LEDs:	-illuminates the sister board LEDs
;			input   -half a byte in r0 describing what LEDs to light up
;			output	-LED light
;----------------------------------------------------------------
illuminate_LEDs:
	PUSH {r4-r12,lr}
	MOV r4, r0			;keep safe this is the half byte
	MOV r0, #1			;port B
	BL portINIT			;B address in reg R1
	;Store LED data
	LDRB r2, [r1, #GPIODATA] ;grabs data
	EOR r2, r2, r4			   ;this will give us new pins to be lit up or not
	STRB r2, [r1, #GPIODATA] ;stores the data to the same place

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
