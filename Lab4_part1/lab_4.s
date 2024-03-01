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
	.global int2string
	.global string2int
	.global portINIT
	.global ERRORFOUND
	.global LOOP
	.global colorPromptOUT
	.global printBits


colorPrompt:	.string "Enter number for color:",0x0D, 0x0A,"White: 1",0x0D, 0x0A,"Red: 2",0x0D, 0x0A,"Green: 3",0x0D, 0x0A,"Blue: 4",0x0D, 0x0A,"Purple: 5",0x0D, 0x0A,"Yellow: 6",0x0D, 0x0A, 0
programPrompt   .string "Enter number for program:",0x0D, 0x0A,"illuminate_RGB_LED: 1",0x0D, 0x0A,"illuminate_LEDs: 2 (Hold Alice button to toggle LEDs)",0x0D, 0x0A,"read_tiva_push_button: 3 (Hold button down)",0x0D, 0x0A,"read_from_push_btns: 4 (Hold buttons down)",0x0D, 0x0A,"Exit Program: 5",0
startPrompt:	.string "Lab 4 - Tom and Tim",0
answers			.string "Store answers here",0
askRunAgain:	.string "Would you like to run again Yes(Y) No(N)?", 0
extmsg:			.string "End of program ※\(^o^)/※", 0
btnPrompt: 		.string "Checking if button was pressed",0
btnPressed:		.string "You Pressed the button!",0
btnNotPressed:	.string "The button was untouched",0
usrInput:		.string "buffer for user input",0

	.text

ptr_to_colorPrompt:		.word colorPrompt
ptr_to_programPrompt:	.word programPrompt
ptr_to_startPromt:		.word startPrompt
ptr_to_answers:			.word answers
ptr_to_runAgin:			.word askRunAgain
ptr_to_extmsg:			.word extmsg
ptr_to_btnPrompt:		.word btnPrompt
ptr_to_btnPressed:		.word btnPressed
ptr_to_btnNotPressed:	.word btnNotPressed
ptr_to_usrInput:		.word usrInput

lab4:
	PUSH {r4-r12,lr}
	;INIT

	BL uart_init
	MOV r0,#0x1234
	MOV r1,#12
	BL printBits
	MOV r0,#0xFFFF
	MOV r1,#3
	BL printBits
	MOV r0,#0xF0F0
	MOV r1,#16
	BL printBits
	BL gpio_btn_and_LED_init

	LDR r0, ptr_to_startPromt
	MVN r1, #1					;new line at end of str
	BL output_string

	;We want to give the user the option to test functionality
LOOP:
	LDR r0, ptr_to_programPrompt
	MVN r1, #1					;new line at end of str
	BL output_string
	LDR r0, ptr_to_usrInput
	BL read_string
	LDR r0, ptr_to_usrInput
	MVN r1, #1
	BL output_string
	LDR r0, ptr_to_usrInput
	BL string2int			;Get usr input and convert it to a number

	CMP r0, #1
	BEQ colourSelector

	CMP r0, #2
	BEQ onBoardLEDsOUT

	CMP r0, #3
	BEQ buttonBitOUT

	CMP r0, #4
	BEQ sisterButtonsBitOUT

	CMP r0, #5
	BEQ exitRoutine
	B ERRORFOUND


colourSelector:
;Print list of colours, get usr input and update the led to the appropriate colour
	BL colorPromptOUT

	B LOOP

onBoardLEDsOUT:
;depending on the button currently held down it will power up LED's
	BL read_from_push_btns
	BL illuminate_LEDs

	B LOOP


buttonBitOUT:
;Prints out where button was printed was
	LDR r0, ptr_to_btnPrompt
	MVN r1, #1					;new line at end of str
	BL output_string
	BL read_tiva_push_button
	CMP r0, #1
	BEQ BUTTONPUSHED
	LDR r0, ptr_to_btnNotPressed
	B EXITBUTTONPUSHED
BUTTONPUSHED:
	LDR r0, ptr_to_btnPressed
	B EXITBUTTONPUSHED
EXITBUTTONPUSHED:
	MVN r1, #1					;new line at end of str
	BL output_string
	B LOOP
sisterButtonsBitOUT:
	BL read_from_push_btns
	MOV r1,#4
	BL printBits
	B LOOP

exitRoutine:
ENDOFLAB:
	LDR r0, ptr_to_extmsg
	MVN r1, #1				;new line at end of str
	BL output_string
	POP {r4-r12,lr}
	MOV pc, lr


;----------------------------------------------------------------
;colorPrompt - Prints the colorPrompt and reads a string from the user
;outputs a color number for the RGB lights to use
;----------------------------------------------------------------
colorPromptOUT:
	PUSH {r4-r12,lr} 				; Store any registers in the range of r4 through r12
	LDR r0, ptr_to_colorPrompt
	MVN r1, #1
	BL output_string				;the prompt being printed is in r0
	LDR r0, ptr_to_usrInput
	BL read_string
	LDR r0, ptr_to_usrInput
	MVN r1, #1
	BL output_string				;the number we want is in r0
	LDR r0, ptr_to_usrInput
	BL string2int					; the integer will be in r0
	MOV r4, r0 						;KEEP SAFE

	;Now that we have the users choice we are gonna print it out on the board
	MOV r0, #5
	BL portINIT						;address we want in r1
	MOV r0, r4						;color number we want

	;Now light up
	BL illuminate_RGB_LED

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

.end
