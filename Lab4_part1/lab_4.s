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

lab4:
	PUSH {r4-r12,lr}

	MOV r1, #0x0x5000	;load address port f
	MOVT r1, #0x4002

	POP {r4-r12,lr}
	MOV pc, lr

	.end
