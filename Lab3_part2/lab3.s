	.data

	.global prompt
	.global dividend
	.global divisor
	.global quotient
	.global remainder

prompt:		.string "Enter 2 integers, first dividend then divsor", 0
dividend: 	.string "Place holder string for your dividend", 0
divisor:  	.string "Place holder string for your divisor", 0
quotient:	.string "Your quotient is stored here", 0
remainder:	.string "Your remainder is stored here", 0
newLine:	.string "\r\n", 0
askRunAgain:.string "Would you like to run again Yes(Y) No(N)?", 0
start:	.string "Lab 3 - Tim and Tom!", 0
extmsg:	.string "End of program ※\(^o^)/※", 0



	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt:			.word prompt
ptr_to_dividend:		.word dividend
ptr_to_divisor:			.word divisor
ptr_to_quotient:		.word quotient
ptr_to_remainder:		.word remainder
ptr_to_newLine:			.word newLine
ptr_to_runAgin:			.word askRunAgain
ptr_to_start:			.word start
ptr_to_extmsg:			.word extmsg


;LAB 3 - function call
;*****************************************************************************
lab3:

	BL uart_init				;Init uart connection
	LDR r0, ptr_to_newLine
	MOV r1,#13
	STRB r1 ,[r0]				;Load new line into memory /r/n
	ADD r0,r0,#1
	MOV r1,#10
	STRB r1,[r0]
	ADD r0,r0,#1
	MOV r1,#00
	STRB r1,[r0]
	LDR r0, ptr_to_newLine
	BL output_string			;newLine
	LDR r0, ptr_to_start
	BL output_string			;Print Start
	LDR r0, ptr_to_newLine
	BL output_string			;newLine

USRLOOP:
	LDR r0, ptr_to_prompt
	BL output_string			;Print prompt
	LDR r0, ptr_to_newLine
	BL output_string			;newLine

	LDR r0, ptr_to_dividend
	BL read_string				;Get dividend
	LDR r0, ptr_to_dividend
	BL output_string			;echo back user input
	LDR r0, ptr_to_newLine
	BL output_string			;newLine
	LDR r0, ptr_to_divisor
	BL read_string				;Get divisor
	LDR r0, ptr_to_divisor
	BL output_string			;echo back user input
	LDR r0, ptr_to_newLine
	BL output_string			;newLine

	LDR r0, ptr_to_dividend		;Convert divend to a number
	BL string2int
	MOV r5, r0					;Store divend in r5
	LDR r0, ptr_to_divisor		;Convert divsort to a number
	BL string2int
	MOV r6, r0					;Store divend in r5

	MOV r0,r5					;Div and mod
	MOV r1,r6
	BL div_and_mod				;quotient in r0 and the remainder in r1.

	MOV r8,r1

	MOV r1,r0
	LDR r0, ptr_to_quotient
	BL int2string
	LDR r0, ptr_to_quotient
	BL output_string
	LDR r0, ptr_to_newLine
	BL output_string			;newLine

	MOV r1,r8
	LDR r0, ptr_to_remainder
	BL int2string
	LDR r0, ptr_to_remainder
	BL output_string
	LDR r0, ptr_to_newLine
	BL output_string			;newLine

	LDR r0, ptr_to_runAgin
	BL output_string			;Print Start
	LDR r0, ptr_to_newLine
	BL output_string			;newLine

	BL read_character
	CMP r0, #0x4E
	BEQ	lab3_end
	CMP r0, #0x6E
	BEQ	lab3_end

	B USRLOOP
lab3_end:
	LDR r0, ptr_to_extmsg
	BL output_string

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
	PUSH {r4-r12,lr} 	;
	MOV r4, r0 ;Address of passed through string
inputLoop:
	BL read_character	;output a character ;r0 is now the character
	CMP r0, #13
	BEQ exitInLoop
	STRB r0, [r4]
	ADD r4, #1	;incrementing 1 byte
	B inputLoop
exitInLoop:
	MOV r0, #0
	STRB r0, [r4]
	POP {r4-r12,lr}
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
outputLoop:
	LDRB r0, [r4]
	CMP r0, #0x00
	BEQ exitOutLoop
	BL output_character
	ADD r4,r4 ,#1		;1 = byte not bits
	B outputLoop
exitOutLoop:
	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
	mov pc, lr
;*****************************************************************************


;INT 2 STRING - stores the integer passed into the routine in r1 as a NULL terminated ASCII string in memory at the address passed into the routine in r0.
;*****************************************************************************
int2string:
	PUSH {r4-r12,lr} 	;
	;r1 int
	;r0 string address
	MOV r4, r1	;Storing the original integer
	MOV r5, r0	;Storing the Strings address

	;take care of negatives for divided
	CMP r4, #0 ;comparing r4 to zero to see if we need to deal with -
    BGT div_store

    EOR r4, r4, #0xFFFFFFFF ;flips bits for the string output to make it easy
    ADD r4, r4, #1 ;adds 1 for twos comp
    MOV r1, #0x2D;this is a - for negative
    STRB r1, [r5];store the string character to string address
	ADD r5, r5, #1;increment the address by a byte

div_store:
	;divide by 100 to start
	MOV r0, r4 ;setting divised
	MOV r1, #100;setting divisor ;it will allow us to get the least sig decimal and change it one by one into strings
	BL div_and_mod2

	ADD r0, r0, #48;takes divided and adjusts the value to represent the character so we can store this number correctly
	MOV r4, r1;this is the division output to continue the cycle
	STRB r0, [r5];store the string character to string address
	ADD r5, r5, #1;increment the address by a byte

	;Now divide by 10 to get our last 2 digits
	MOV r0, r4 ;setting divised
	MOV r1, #10;setting divisor ;it will allow us to get the least sig decimal and change it one by one into strings
	BL div_and_mod2

	ADD r0, r0, #48;takes divided counter and adjusts the value to represent the character
	ADD r1, r1, #48;takes remainder and adjusts the value to represent the character
	STRB r0, [r5];store the string character to string address
	ADD r5, r5, #1;increment the address by a byte
	STRB r1, [r5];store the string character to string address
	ADD r5, r5, #1;increment the address by a byte

	MOV r4, #0x00
	STRB r4, [r5];stores a NULL at the string address to stop the end of the string

	MOV	r0, r5


		; Your code for your int2string routine is placed here

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr
;*****************************************************************************


;STRING 2 INT - converts the NULL terminated ASCII string pointed to by the address passed into the routine in r0 to an integer. The integer should be returned in r0
;*****************************************************************************
string2int:
	PUSH {r4-r12,lr} ; Store any registers in the range of r4 through r12
	MOV r4, r0 		;Address of passed through string
	MOV r5,#1
	MOV r10, #10
	EOR r6 , #0 	;accumnator
negFlag:
	EOR r5, #1		;neg flag
stringIntLoop:
	LDRB r0, [r4]
	CMP r0, #00		;Check for null terminator
	BEQ ExitstringIntLoop
	STRB r0, [r4]	;load char
	CMP r0, #0x2D	;check for neg
	BEQ negFlag
  	SUB r0, r0, #0x30
  	MUL r6, r6, r10
  	ADD r6,r6, r0
	ADD r4, #1	;incrementing 1 byte
	B stringIntLoop
ExitstringIntLoop:
	MOV r3,r6
	CMP r5, #0x01
	BEQ invert
	MOV r0, r3
	POP {r4-r12,lr}
	mov pc, lr
;*****************************************************************************


;DIV AND MOD TIMS ED. - Accepts a dividend in r0 and a divsor in r1and an integer returns the quotient in r0 and the remainder in r1.
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
	MOV r0, r2
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
	MOV pc, lr ; your div_and_mod routine is placed here
;*****************************************************************************

;DIV AND MOD TOMS ED. - Accepts a dividend in r0 and a divsor in r1and an integer returns the quotient in r0 and the remainder in r1.
;*****************************************************************************
div_and_mod2:
        PUSH {r4-r12,lr};This line stores register, more explination at the top of the file.

        ; Your code for the div_and_mod routine goes here.
        ;r0 is the divised
        ;r1 is the divisor
        ;r2 is the div output until it gets put into r1
        ;r4 is the temp divisor
        ;r5 is the temp divided
        ;r6 negative bit sign
        MOV r4, r1 ;Sets the temp vals, this is the divisor
        MOV r5, r0 ;Sets the temp vals, this is the number to divide, the remainder is stored in r1
        MOV r2, #0 ;resets this the counter returned in r0
        MOV r6, #0 ;resets


divisorNegCheck0:
        CMP r4, #0 ;comparing it to zero
        BGT dividedNegCheck1

        EOR r4, r4, #0xFFFFFFFF ;flips bits for the divisor
        ADD r4, r4, #1 ;adds 1 for twos comp
        ADD r6, r6, #1 ;For the negative sign


dividedNegCheck1:
        CMP r5, #0
        BGT LOOP

        EOR r5, r5, #0xFFFFFFFF ;flips bits for the divided
        ADD r5, r5, #1
        ADD r6, r6, #1 ;For the negative sign

LOOP:
        CMP r5, r4
        BLT FINISH
        SUB r5, r5, r4
        ADD r2, r2, #1;counting up everytime something divides

        B LOOP

FINISH:;checks for negative in and flip to get correct output
        CMP r6, #1
        BNE TRANSFER

        ;this is the divided answer as well as r4 should be the MOD answer
        EOR r2, r2, #0xFFFFFFFF ;flips bits for the divisor
        ADD r2, r2, #1 ;adds 1 for twos comp

TRANSFER:
        MOV r0, r2
        MOV r1, r5

        POP {r4-r12,lr};This line loads back our registers, more explination at the top of the file.

        ; The following line is used to return from the subroutine
        ; and should be the last line in your subroutine.
        MOV pc, lr
	.end
;*****************************************************************************
