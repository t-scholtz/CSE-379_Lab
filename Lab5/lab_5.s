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
	
ptr_to_prompt:		.word prompt
ptr_to_mydata:		.word mydata
UARTIM: 			.equ 0x038		; UARTIM offset
ENO:				.equ 0x100		;Enable pin interupt offset

lab5:								; This is your main routine which is called from 
; your C wrapper.  
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata

 	bl uart_init
	bl uart_interrupt_init
	bl gpio_interrupt_init

	; This is where you should implement a loop, waiting for the user to 
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
	LDR r1, [r0, UARTIM]	;This loads the base value of the UARTIM data and we need to update it
	OR r1, r1, #32			;Now we have the updated value to store back
	STR r1 [r0, UARTIM]

							;Now we need to set the ENABLE pin
	MOV r0, #0xE0000 		;This is the UART Base address
	MOVT r0, #0xE000

							;We need to access bit 5 at the ENABLE position
	LDR r1, [r0, UARTIM]	;This loads the base value of the ENABLE data and we need to update it
	OR r1, r1, #32			;Now we have the updated value to store back
	STR r1 [r0, UARTIM]

							;NOW both the UART should be set to take interupts along with the enable pin to allow the interups



	; Your code to initialize the UART0 interrupt goes here

	MOV pc, lr
;================================================================

gpio_interrupt_init:
		
	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.

	MOV pc, lr


UART0_Handler: 
	
	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping 
	; them to & from the stack at the beginning & end of the handler

	BX lr       	; Return


Switch_Handler:
	
	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping 
	; them to & from the stack at the beginning & end of the handler

	BX lr       	; Return


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
