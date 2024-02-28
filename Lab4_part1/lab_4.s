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
	.global lab4

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
