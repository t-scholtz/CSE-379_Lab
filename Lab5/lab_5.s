	.data

	.global prompt
	.global mydata

prompt:	.string "Your prompt with instructions is place here", 0
mydata:	.byte	0x20	; This is where you can store data.
			; The .byte assembler directive stores a byte
			; (initialized to 0x20) at the label mydata.
			; Halfwords & Words can be stored using the
			; directives .half & .word

	.text

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler			; This is needed for Lab #6
	.global simple_read_character
	.global output_character		; This is from your Lab #4 Library
	.global read_string				; This is from your Lab #4 Library
	.global output_string			; This is from your Lab #4 Library
	.global uart_init					; This is from your Lab #4 Library
	.global lab5
<<<<<<< HEAD
	.global portINIT
	.global LOOP

=======
	 .global portINIT
	
>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2
ptr_to_prompt:		.word prompt
ptr_to_mydata:		.word mydata

UARTIM: 			.equ 0x038		; UARTIM offset
ENO:				.equ 0x100		;Enable pin interupt offset
GPIOIS: 			.equ 0x404	;GPIO Interrupt Sense Register
GPIOIBE:			.equ 0x408 	;GPIO Interrupt Both Edges Register
GPIOIV:				.equ 0x40C	;GPIO Interrupt Event Register
<<<<<<< HEAD
GPIOIM:				.equ 0x410	;GPIO Interrupt Mask Register
GPIOICR:			.equ 0x41C	;GPIO Interrupt Clear Register


lab5:								; This is your main routine which is called from
; your C wrapper.
=======
GPIOIS:				.equ 0x410	;GPIO Interrupt Mask Register
GPIOICR:			.equ 0x41C	;GPIO Interrupt Clear Register

lab5:								; This is your main routine which is called from 
; your C wrapper.  
>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS


 	bl uart_init
	bl uart_interrupt_init
	bl gpio_interrupt_init

<<<<<<< HEAD
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata

LOOP:

	BL LOOP
	; This is where you should implement a loop, waiting for the user to
=======
infLoopForTesting:

	BL infLoopForTesting
	; This is where you should implement a loop, waiting for the user to 
>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2
	; enter a q, indicating they want to end the program.

	POP {lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr



;----------------------------------------------------------------
;uart_interrupt_init: This subroutine will generate an interupt when a keystroke is generated
; by a user in PUTTY
;----------------------------------------------------------------
uart_interrupt_init:

	MOV r0, #0xc0000 ;This is the UART Base address
	MOVT r0, #0x4000

							;We need to access bit 5 at the UARTIM position
<<<<<<< HEAD
	LDR r1, [r0, #UARTIM]	;This loads the base value of the UARTIM data and we need to update it
	ORR r1, r1, #32			;Now we have the updated value to store back
	STR r1, [r0, #UARTIM]
=======
	LDR r1, [r0, UARTIM]	;This loads the base value of the UARTIM data and we need to update it
	OR r1, r1, #32			;Now we have the updated value to store back
	STR r1 [r0, UARTIM]
>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2

							;Now we need to set the ENABLE pin
	MOV r0, #0xE0000 		;This is the UART Base address
	MOVT r0, #0xE000

							;We need to access bit 5 at the ENABLE position
<<<<<<< HEAD
	LDR r1, [r0, #UARTIM]	;This loads the base value of the ENABLE data and we need to update it
	ORR r1, r1, #32			;Now we have the updated value to store back
	STR r1, [r0, #UARTIM]
=======
	LDR r1, [r0, UARTIM]	;This loads the base value of the ENABLE data and we need to update it
	OR r1, r1, #32			;Now we have the updated value to store back
	STR r1 [r0, UARTIM]
>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2

							;NOW both the UART should be set to take interupts along with the enable pin to allow the interups



	; Your code to initialize the UART0 interrupt goes here

	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;gpio_interrupt_init - initliase interupt for sw1
;----------------------------------------------------------------
gpio_interrupt_init:
	PUSH {r4-r12,lr}
	MOV r0,#5		;load port f
	BL portINIT
<<<<<<< HEAD
	LDRB r1, [r0,#GPIOIS]
	AND r1,r1,#0xF7
	STRB r1, [r0,#GPIOIS]
	LDRB r1, [r0,#GPIOIBE]	;set to trigger on single edge change
	AND r1,r1,#0xF7
	STRB r1, [r0,#GPIOIBE]
	LDRB r1, [r0,#GPIOIV]	;set to trigger on falling edge
	AND r1,r1,#0xF7
	STRB r1, [r0,#GPIOIV]
	LDRB r1, [r0,#GPIOIM]	;set to trigger on falling edge
	AND r1,r1,#0xFF
	STRB r1, [r0,#GPIOIM]
	MOV r0, #0xE000
	MOVT r0, #0xE000
	LDR r1, [r0,#0x100]
	MOVT r2, #0x4000
	ORR r1,r1,r2
	STR r1, [r0,#0x100]
=======
	LDRB r1, [r0,GPIOIS]
	AND r1,r1,#0xF7
	STRB r1, [r0,GPIOIS]
	LDRB r1, [r0,GPIOIBE]	;set to trigger on single edge change
	AND r1,r1,#0xF7
	STRB r1, [r0,GPIOIBE]
	LDRB r1, [r0,GPIOIV]	;set to trigger on falling edge
	AND r1,r1,#0xF7
	STRB r1, [r0,GPIOIV]
	LDRB r1, [r0,GPIOIM]	;set to trigger on falling edge
	AND r1,r1,#0xFF
	STRB r1, [r0,GPIOIM]
	MOV r0, #0xE000
	MOVT r0, #0xE000
	LDR r1 [r,#0x100]
	MOVT r2, #0x4000
	OR r1,r1,r2
	STR r1 [r,#0x100]
>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2

	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
<<<<<<< HEAD

UART0_Handler:
=======
>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	BX lr       	; Return

;----------------------------------------------------------------
;Switch_Handler - handles interupt for sw1 being pressed
;----------------------------------------------------------------
Switch_Handler:
	PUSH {r0-r12,lr}
	;Clear interupt value
	MOV r0, #0x5000
	MOVT r0, #0x4002
<<<<<<< HEAD
	LDRB r1, [r0,#GPIOICR]
	ORR r1,r1,#0x08
	STRB r1, [r0,#0x100]

	;print to screen btn was pushed
	LDR r0, ptr_to_prompt
	BL output_string

=======
	LDRB r1 [r0,GPIOICR]
	OR r1,r1,#0x08
	STRB r1 [r0,#0x100]
	
	;print to screen btn was pushed
	MOV r0, ptr_to_prompt
	BL output_string

>>>>>>> fdc1368180966dbb16aaf873fca258eb61451fa2


	POP {r0-r12,lr}
	BX lr       	; Return
;================================================================


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed for
	; Lab #5, but will be used in Lab #6.  It is referenced here because
	; the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	BX lr       	; Return


simple_read_character:

	MOV pc, lr	; Return

	.end
