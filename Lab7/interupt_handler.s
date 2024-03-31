	.data

;PROGRAM DATA
;================================================================
state:				.byte 0x00 ;State machine: 0 - startup ; 1 - menu ; 2 - game ; 3 - pause ; 4 - vicotry/defeat ; 5 - ;

	.text

;POINTERS TO DATA
;================================================================
ptr_to_state:		.word state


;LIST OF SUBROUTINES
;================================================================
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler

;IMPORTED SUB_ROUTINES
;_______________________________________________________________




;LIST OF CONSTANTS
;================================================================
UARTICR:			.equ 0x044  	;Interrupt clear register
GPIOICR:			.equ 0x41C		;GPIO Interrupt Clear Register
GPTMICR:			.equ 0x024		;Interrupt Servicing in the Handler

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;change_state - updates state value to value in r0
;----------------------------------------------------------------
	PUSH {r0-r11,lr}
	LDR r1, ptr_to_state
	STRB r0
	POP {r0-r11,lr}
	BX lr
;----------------------------------------------------------------
;UART0_Handler - This is the interupt that is ran Once a signal f rom the UART ex
;----------------------------------------------------------------
UART0_Handler:
	PUSH {r0-r11,lr}
	;Clear uart hanlder flag reg
	MOV r0, #0xC000
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTICR]
	ORR r1, r1, #0x10
	STRB r1, [r0, #UARTICR]


EXIT_UART_HANDLER:
	POP {r0-r11,lr}
	BX lr
;================================================================

;----------------------------------------------------------------
;Switch_Handler - handles interupt for sw1 being pressed
;----------------------------------------------------------------
Switch_Handler:
	PUSH {r0-r11,lr}
	;rest switch interupt reg
	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0,#GPIOICR]
	ORR r1,r1,#16
	STRB r1, [r0,#GPIOICR]



EXIT_SWITCH_HANDLER
	POP {r0-r11,lr}
	BX lr       	; Return

;================================================================

;----------------------------------------------------------------
;Timer_Handler
;----------------------------------------------------------------
Timer_Handler:
	PUSH {r0-r11,lr}
	;Clear interupt
	MOV r4, #0x0000
	MOVT r4, #0x4003
	LDRB r6, [r4, #GPTMICR]
	ORR r6,r6, #0x01
	STRB r6, [r4, #GPTMICR]

	POP {r0-r11,lr}
	BX lr
;================================================================


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
