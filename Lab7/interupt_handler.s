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
	.global change_state

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global start_up_anim
	.global print_menu
	.global print_game
	.global print_pause


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
change_state:
	LDR r1, ptr_to_state
	STRB r0,[r1]
	BX lr
;----------------------------------------------------------------
;UART0_Handler - handle interupt from keyboard
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

	LDR r0, ptr_to_state
	LDRB r1, [r0]		;load the state value
	cmp r1, #2
	BEQ PAUSE_GAME
	cmp r1, #3
	BEQ RESUME_GAME
	B EXIT_SWITCH_HANDLER
PAUSE_GAME:				;update game state and print pause menu
	MOV r1, #3
	STRB r1, [r0]
	B print_pause
	B EXIT_SWITCH_HANDLER
RESUME_GAME:			;update game state and print game board
	MOV r1, #2
	STRB r1, [r0]
	B print_game
EXIT_SWITCH_HANDLER:
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

	LDR r0, ptr_to_state
	LDRB r0, [r0]		;load the state value
	CMP r0, #0
	BEQ RENDER_STARTUP
	cmp r0,#1
	BEQ RENDER_MENU
	cmp r0, #2
	BEQ RENDER_GAME
	cmp r0, #3
	BEQ RENDER_PAUSE

RENDER_STARTUP:
	BL start_up_anim
	B EXIT_TIMER_HANDLER

RENDER_MENU:
	BL print_menu
	B EXIT_TIMER_HANDLER

RENDER_GAME:
	BL print_game
	B EXIT_TIMER_HANDLER

RENDER_PAUSE:
	BL print_pause
	B EXIT_TIMER_HANDLER

EXIT_TIMER_HANDLER:
	POP {r0-r11,lr}
	BX lr
;================================================================


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
