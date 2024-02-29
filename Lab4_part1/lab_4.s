	.data
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global output_string
	.global read_character
	.global read_string
	.global read_tiva_push_button
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global div_and_mod
	.global string2int
	.global int2string
	.global lab4

colorPrompt:	.string "Enter number for color:\r\nWhite: 1\r\nRed: 2\r\nGreen: 3\r\nBlue: 4\r\nPurple: 5\r\nYellow: 6\r\n", 0
buttonPrompt: 	.string "Press a button, this will be done 4 times before reset availible"
startPrompt:	.string "Lab 4 - Tom and Tim"
askRunAgain:	.string "Would you like to run again Yes(Y) No(N)?", 0
extmsg:			.string "End of program ※\(^o^)/※", 0

	.text

ptr_to_colorPrompt:		.word colorPrompt
ptr_to_buttonPrompt:	.word buttonPrompt
ptr_to_startPrompt:		.word startPrompt
ptr_to_runAgin:			.word askRunAgain
ptr_to_extmsg:			.word extmsg

lab4:
	PUSH {r4-r12,lr}
	BL uart_init			;INIT
	BL gpio_btn_and_LED_init

	LDR r0, ptr_to_startPrompt;INIT messeges
	MOV r1, #0 				;newline
	BL output_string
	MOV r8, #0 				;R8 WILL BE OUR COUNTER

LOOPlab4:
	LDR r0, ptr_to_buttonPrompt;tell them to click a button
	MOV r1, #0 				;newline
	BL output_string

LOOPbutton:
	BL read_tiva_push_button;checks the on board button first that will control color
	CMP r0, #1				;checks to see if on board button is clicked first
	BEQ colorChoice

	BL read_from_push_btns
	CMP r0, #0				;see if any buttons were pressed
	BGT LEDchoice			;two things, I am assuming you flipped the bits like your note says in the subRoutine
							;I am going to assume button 2 is LDB and button 5 is MSB, this can be chnaged in my LED sub
	B LOOPbutton

colorChoice:
	BL colorPromptOUT		;has input in r0
	BL illuminate_RGB_LED	;lights up on board LED

	CMP r8, #4
	BEQ userCheck
	ADD r8, r8, #1
	B LOOPbutton

LEDchoice:
	BL illuminate_LEDs		;outputs the lights being pressed

	CMP r8, #4				;check to see how many they have pressed
	BEQ userCheck			;checks to see if they are done
	ADD r8, r8, #1			;if not increment and keep going
	B LOOPbutton

userCheck:
	MOV r8, #0					;resetCounter
	LDR r0, ptr_to_runAgin
	MOV r1, #0 					;newline
	BL output_string			;Print run again option


	BL read_character
	CMP r0, #0x59				;check for yes
	BEQ	LOOPlab4
	CMP r0, #0x79				;check for yes
	BEQ	LOOPlab4


ENDOFLAB:
	LDR r0, ptr_to_extmsg
	MVN r1, #1				;new line at end of str
	BL output_string

	POP {r4-r12,lr}
	MOV pc, lr

.end


;----------------------------------------------------------------
;colorPrompt - Prints the colorPrompt and reads a string from r0
;			   outputs a color number for the RGB lights
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
