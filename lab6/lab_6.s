	.data

;LIST OF SUBROUTINES
;================================================================
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global simple_read_character
	.global lab5
;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global uart_init
	.global output_string
	.global output_character
	.global portINIT
	.global gpio_btn_and_LED_init
	.global div_and_mod
	.global read_character
	.global output_character
;================================================================

;PROGRAM DATA
;================================================================
startUpPrompt:	.string 0x0D, 0x0A, "Hello! Lab 6 - Tom and Tim",0
scorePrompt:	.string "Score: ",0
gameBoard:		.string "----------------------",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "|                    |",0x0D, 0x0A,
				.string "----------------------",0x0D, 0x0A,0
playerDir:		.byte	0x00	; 0 up 1 right 2 down 3 left
xPos:			.byte	0x0A
yPos:			.byte	0x0A
score:			.byte	0x00

;================================================================

	.text
;POINTERS TO STRING
;================================================================
ptr_to_startUpPrompt:	.word startUpPrompt
ptr_to_scorePrompt:		.word scorePrompt
ptr_to_playerDir:		.word playerDir
ptr_to_xPos:			.word xPos
ptr_to_yPos:			.word ypos
ptr_to_score:			.word score
;================================================================

;LIST OF CONSTANTS
;================================================================
UARTIM: 			.equ 0x038		; UARTIM offset
UARTICR:			.equ 0x044  	;Interrupt clear register
ENO:				.equ 0x100		;Enable pin interupt offset
GPIOIS: 			.equ 0x404		;GPIO Interrupt Sense Register
GPIOIBE:			.equ 0x408 		;GPIO Interrupt Both Edges Register
GPIOIV:				.equ 0x40C		;GPIO Interrupt Event Register
GPIOIM:				.equ 0x410		;GPIO Interrupt Mask Register
GPIOICR:			.equ 0x41C		;GPIO Interrupt Clear Register
TIMER:				.equ 0xB2D05E00 ;THIS will be the timer for the countDOWN
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;LAB 5 MAIN
;----------------------------------------------------------------
lab5:								; This is your main routine which is called from
; your C wrapper.
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS

	;Set up connections and interupts
	bl uart_init
	bl gpio_btn_and_LED_init
	bl uart_interrupt_init
	bl gpio_interrupt_init
	bl timer_init
	;Start up sequence

progLoop:

	b progLoop				;burn condition

END_PROGRAM:
	POP {r4-r12,lr} 		; Restore registers to adhere to the AAPCS
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;update_screen - re-draws the screen with update values
;----------------------------------------------------------------
update_screen:
	PUSH {r4-r12,lr}
	;check the player position and directinos
	;check that game hasn't ended -> if ended handle
	;draw the new * on the map
	;update the score
	;draw score and map to screen

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;UART0_Handler - This is the interupt that is ran Once a signal f rom the UART ex
;----------------------------------------------------------------
UART0_Handler:
	PUSH {r0-r11,lr}


	;Uart handler needs to take in input, check if the WASD/ arrows keys were pressed and then update player direction


EXIT_UART_HANDLER:
	POP {r0-r11,lr}
	BX lr
;================================================================

;----------------------------------------------------------------
;Switch_Handler - handles interupt for sw1 being pressed
;----------------------------------------------------------------
Switch_Handler:
	PUSH {r0-r11,lr}

EXIT_SWITCH_HANDLER
	POP {r0-r11,lr}
	BX lr       	; Return

;================================================================

;----------------------------------------------------------------
;timer_init - conencts the timer to the interupt handler
;	takes no input
;----------------------------------------------------------------
timer_init:
	PUSH {r4-r12,lr}
	;Connect Clock to Timer
	MOV r4, #0xE000
	MOVT r4, #0x400F
	MOV r5, #0x604
	LDR r6, [r4,r5]
	ORR r6, #0x01
	STR r6, [r4,r5]
	;Configure Timer
	MOV r4, #0
	MOVT r4,#0x4003
	MOV r5, #0x00C
	;Enable Timer Interrupt
	;Enable Timer




	POP {r4-r12,lr}
	MOV pc, lr
;----------------------------------------------------------------
;Timer_Handler
;----------------------------------------------------------------
Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed for
	; Lab #5, but will be used in Lab #6.  It is referenced here because
	; the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	BX lr       	; Return


;Not sure why this is here
simple_read_character:

	MOV pc, lr	; Return




	.end

;Exit
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
