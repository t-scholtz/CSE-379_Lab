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

lab4:
	;THIS IS THE WORKING GUI
	;sense there is 4 push buttons and 4 LED's we will give the user 4 chances to do something before we ask if they would like to continue or not
	PUSH {r4-r12,lr}
	BL uart_init
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
LOOP:
	BL read_tiva_push_button
	B LOOP
	POP {r4-r12,lr}
	MOV pc, lr

	.end
