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
	.global portINIT

lab4:
	PUSH {r4-r12,lr}
	BL uart_init
	;TESTING LOOP
	BL gpio_btn_and_LED_init

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
