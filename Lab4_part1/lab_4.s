.text;IS THIS SUPPOSED TO BE UP HERE?
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
	.global portINIT
	.global colorPromptOUT
	.global newLinePromptOUT
	.global askRunAgainPromptOUT
	.global extmsgPromptOut
	.global startPromptOUT
	.global startOUT

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
	;THIS IS THE WORKING GUI
	;sense there is 4 push buttons and 4 LED's we will give the user 4 chances to do something before we ask if they would like to continue or not
	PUSH {r4-r12,lr}
	BL uart_init
<<<<<<< HEAD
	LDR r0, ptr_to_startPromt
	MVN r1,# 1				;new line at end of str
	BL output_string
	;TESTING LOOP
	BL gpio_btn_and_LED_init
=======
	BL gpio_btn_and_LED_init;initilization complete

	;Starting up
	BL startOUT
	BL newLinePromptOUT
	BL startPromptOUT
	
	;IlluminationLoop
	MOV r9, #0;Reset the counter to make sure nothing is in it
illuminationLoop:
	;BEFORE I CONTINUE WE NEED TO FIGURE OUT HOW TO ACCESS THE OTHER ON BOARD LED's AND BUTTONS
	;BL colorPromptOUT
	
	ADD r9, r9, #1;increment counter
	
	

	

	;THIS IS THE TEST STUFF
	MOV r0, #6
	BL portINIT ;port adress in r1 currently
	MOV r0, r1	;swaps port address to be in r0
	MOV r1, #5	;Sets color to be white
	BL illuminate_RGB_LED
	MOV r1, #5	;Sets color to be white
	BL illuminate_RGB_LED
>>>>>>> 1f945365c892ea954ba58ee91aa8e1c0c530b494
LOOP:
	BL read_tiva_push_button
	B LOOP
	POP {r4-r12,lr}
	MOV pc, lr

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
