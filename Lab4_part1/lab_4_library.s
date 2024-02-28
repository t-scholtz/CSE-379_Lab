	.data

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
	.global lab4

<<<<<<< HEAD
errorPrompt:	.string "Error with subroutine", 0 ;Question to see if we can do this in this file
newLine:		.byte 0x0D, 0x0A , 0x00,  0x00

	.text

ptr_to_errorPrompt:		.word errorPrompt
ptr_to_newLine:			.word newLine

U0FR: 		.equ 0x18	; UART0 Flag Register
GPIODATA:	.equ 0x3FC ;data location
GPIODIG:	.equ 0x51C ;Pin activation location
GPIODIR:	.equ 0x400  ;Pin Direction location
GPIOPUR 	.equ 0x510	;Pull-Up Resistor


;----------------------------------------------------------------
;GPIO Button and LED INI - initliase on board button and led for
;use
;----------------------------------------------------------------
gpio_btn_and_LED_init:
	PUSH {r4-r12,lr}
	;SET BUTTON - SW1 - Port F Pin 4 - read | SET LED - Port F pin 1,2,3 - write
	MOV r0, #32			;port f
	MOV r1, #0x5000		;port f memory address
	MOVT r1 , #0x4002
	MOV r2, #0x0E		;Pin 4 will be read - set 0 | pin 1,2,3 will be write - set 1
	MOV r3, #0x1E		;Pin 1,2,3,4 set active
	BL gpio_setup
	;SET BUTTONS ON ALICE Swithes 2-5 - port D Pins 0-3
	MOV r0, #8			;port d
	MOV r1, #0x7000		;port d memory address
	MOVT r1 , #0x4000
	MOV r2, #0x00		;Pin 2-5 will be read - set 0
	MOV r3, #0x3C		;Pin 2-5 set active
	BL gpio_setup
	;SET LEDS ON ALICE - port B Pins 0-3
	MOV r0, #2			;port b
	MOV r1, #0x5000		;port b memory address
	MOVT r1 , #0x4000
	MOV r2, #0x0F		;Pin 0-3 will be write - set 1
	MOV r3, #0x0F		;Pin 0-3 set active
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
	MOV r6, #GPIODIR		;offset for data direction
	STRB r2, [r1,r6]	;store new settings
	;SET EACH GPIO PIN AS DIGITAL
	MOV r6, #GPIODIG	;offset for data direction
	STRB r3, [r1,r6]	;store new settings
	;SET PULL UP RESIGIOR FOR  READ REGISTORS ***May remove this part from this subroutine in future***
	MOV r6 ,#GPIOPUR
	MVN r7,r2			;invert read/write pins
	AND r3,r3,r7		;isolate just read pins to select for pull up registors
	STRB r3, [r1,r6]
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;read_from_push_btns - reads the momentary push buttons
;Output: r0 - 4bit value with MSB -> button 2, LSB -> button 5
;----------------------------------------------------------------
read_from_push_btns:
	PUSH {r4-r12,lr}
	MOV r0,#3
	BL portINIT
	MOV r5, #GPIODATA
	LDRB r0, [r4,r5]
	AND r0, #0x3C 		;convert it so 1 is off and 0 is on
	EOR r0,r0, #0x3C
	LSR r0,r0,#2
	;TODO flip bits around right now 5,4,3,2  - need 2,3,4,5
	POP {r4-r12,lr}
	MOV pc, lr
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
;illuminate_RGB_LED: - illuminates the RBG LED
;	input - R0 will be the address of the colors number passed through.//NEEDS TO BE F FOR THIS ONE
;			R1 will be the number of the color
;----------------------------------------------------------------
illuminate_RGB_LED:
	PUSH {r4-r12,lr};The color from the colorPrompt is passed into r0 ;WE will need a color prompt sub routine too

	CMP r0, #0;checks error ;Decide with tim if we should loop in here or only print out the message and continue
	BLS ERRORFOUND;This should be an end of the road subroutine so it will stop us if there is an issue

	;If white
	CMP r1, #1
	BEQ whiteOUT
	;If red
	CMP r1, #2
	BEQ redOUT
	;If green
	CMP r1, #3
	BEQ greenOUT
	;If blue
	CMP r1, #4
	BEQ blueOUT
	;If purple
	CMP r1, #5
	BEQ purpleOUT
	;If yellow
	CMP r1, #6
	BEQ yellowOUT
	B ERRORFOUND;this is if no options were found; Mabye create a user error sub???

whiteOUT:
	MOV r1, #0xE ;should be 1110
	B FINALilluminate_RGB_LED

redOUT:
	MOV r1, #0x2 ;should be 0010
	B FINALilluminate_RGB_LED

greenOUT:
	MOV r1, #0x8 ;should be 1000
	B FINALilluminate_RGB_LED

blueOUT:
	MOV r1, #0x4 ;should be 0100
	B FINALilluminate_RGB_LED

purpleOUT:
	MOV r1, #0x6 ;should be 0110
	B FINALilluminate_RGB_LED

yellowOUT:
	MOV r1, #0xC ;should be 1100 ;i have NO CLUE IF I AM ACCESSING THE PINS CORRECTLY
	B FINALilluminate_RGB_LED

FINALilluminate_RGB_LED:
	STRB r1, [r0, #GPIODATA]
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
	MOV r5, #GPIODATA
	LDRB r0, [r4,r5]
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
	MOV r6 , #0 	;accumnator'
	SUB r4,r4,#1
negFlag:
	EOR r5, #1		;neg flag
	ADD r4,r4,#1
stringIntLoop:
	LDRB r0, [r4], #1
	CMP r0, #00		;Check for null terminator
	BEQ ExitstringIntLoop
	STRB r0, [r4]	;load char
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
;portINIT - SUBroutine given 1-6(A->F) to represent ports
; The function returns the address of the port in R1
;----------------------------------------------------------------
portINIT:
	PUSH {r4-r12,lr}
	CMP r0, #0
	BL ERRORFOUND
	CMP r0, #4
	BLE A2D
	CMP r0, #6
	BEQ E2F
	BL ERRORFOUND;in the case that we passed in a bad choice
A2D;
	MOV r1, #0x4000 ; Getting port D loaded up
	ADD r1,r1 ,r0, LSL #3
	MOVT r1, #0x4000
	B FINALportINIT
E2F:
	MOV r1, #0x0000 ; Getting port F loaded up
	ADD r1,r1 ,r0, LSL #3
	MOVT r1, #0x4002
	B FINALportINIT
FINALportINIT:;comes here once we are all done and we use r1 as the port address
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================



;----------------------------------------------------------------
;ERRORFOUND - creates an infinite loop that will never finish
;----------------------------------------------------------------

ERRORFOUND:
	LDR r0, ptr_to_errorPrompt
	BL output_string;the prompt being printed is in r0

ERRORLOOP_RUT_ROE_RAGGY
	ADD r1, r1, #1
	B ERRORLOOP_RUT_ROE_RAGGY

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
;	  	- r1 - new line conidtion - set to neg value to turn off
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
	BGT NONEWLINE
	MOV r1,#1
	LDR r0, ptr_to_newLine
	BL output_string
NONEWLINE:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
=======
colorPrompt:	.string "Enter number for color:\r\nWhite: 1\r\nRed: 2\r\nGreen: 3\r\nBlue: 4\r\nPurple: 5\r\nYellow: 6\r\n", 0
startPrompt:	.string "Lab 4 - Tom and Tim"
askRunAgain:	.string "Would you like to run again Yes(Y) No(N)?", 0
extmsg:			.string "End of program ※\(^o^)/※", 0

	.text

ptr_to_colorPrompt:		.word colorPrompt
ptr_to_startPromt:		.word startPrompt
ptr_to_runAgin:			.word askRunAgain
ptr_to_extmsg:			.word extmsg

lab4:
	PUSH {r4-r12,lr}
	BL uart_init
	LDR r0, ptr_to_startPromt
	MVN r1,# 1				;new line at end of str
	BL output_string
	;TESTING LOOP
	BL gpio_btn_and_LED_init
LOOP:
	BL read_tiva_push_button
	B LOOP
	POP {r4-r12,lr}
	MOV pc, lr
>>>>>>> 1f945365c892ea954ba58ee91aa8e1c0c530b494

ENDOFLAB:
	LDR r0, ptr_to_extmsg
	MVN r1, #1				;new line at end of str
	BL output_string
	.end


;----------------------------------------------------------------
;colorPrompt - Prints the colorPrompt and reads a string from the user
;outputs a color number for the RGB lights to use
;----------------------------------------------------------------
colorPromptOUT:
	PUSH {r4-r12,lr} ; Store any registers in the range of r4 through r12
	LDR r0, ptr_to_colorPrompt
	BL output_string;the prompt being printed is in r0
	BL read_string;the number we want is in r0
	BL string2int; the integer will be in r0
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
