
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
	.global int2string
;================================================================

;PROGRAM DATA
;================================================================
startUpPrompt:	.string 0x0D, 0x0A, "Hello! Lab 6 - Tom and Tim",0
scorePrompt:	.string "Score: ",0
gameBoard:		.string "----------------------",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "----------------------",0x0D, 0x0A,0
PAUSEBoard:		.string "----------------------",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|     GAME PAUSED    |",0x0D, 0x0A
				.string "|PRESS SW1 to RESUME |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "|                    |",0x0D, 0x0A
				.string "----------------------",0x0D, 0x0A,0
playerDir:		.byte	0x00	; 0 up 1 right 2 down 3 left
xPos:			.byte	0x0A
yPos:			.byte	0x0A
score:			.byte	0x00
scoreStr:		.string "12345",0
paused:			.byte	0x00	; 0 -> not puased | 1 pauesed
pausePrompt:	.string "TODO",0x0D, 0x0A
				.string "TODO",0x0D, 0x0A
				.string "TODO",0x0D, 0x0A
				.string "TODO",0

;================================================================

	.text
;POINTERS TO STRING
;================================================================
ptr_to_startUpPrompt:	.word startUpPrompt
ptr_to_scorePrompt:		.word scorePrompt
ptr_to_gameBoard:		.word gameBoard
ptr_to_playerDir:		.word playerDir
ptr_to_xPos:			.word xPos
ptr_to_yPos:			.word yPos
ptr_to_score:			.word score
ptr_to_scoreStr:		.word scoreStr
ptr_to_paused:			.word paused
ptr_to_pausePrompt:		.word pausePrompt
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
RCGCTIMER:			.equ 0x604		;General purpose timer run mode clock gating control register
GPTMCTL:			.equ 0x00C		;General purpose timer control register
GPTMCFG:			.equ 0x0		;General Purpose Timer configuration Register
GPTMTAMR:			.equ 0x4		;General Purpose TImer Timer A Mode Register
CLC_Interrupt:		.equ 0x7A1200	;This is the rate that our clock will interupt
GPTMTAILR:			.equ 0x028		;General Purpose Timer inteval load Register
GPTMIMR:			.equ 0x018		;General Purpose Timer Interrupt Mask Register
GPTMCTL:			.equ 0x00C		;General Purpose Timer Control Reg

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
	MOV r0, #12
	BL output_character		;clear the screen
	LDR r0, ptr_to_scorePrompt
	MVN r1, #1
	BL output_string		;print score prompt to screen
	LDR r1, ptr_to_score
	LDR r0 ,ptr_to_scoreStr
	BL int2string			;convert the score num to a str value
	LDR r0, ptr_to_scoreStr
	MOV r1, #1
	BL output_string		;print score value followed by a new line
	LDR r0, ptr_to_gameBoard
	BL output_string 		;print game map to screen

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

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

	;Check if Game is paused - skip if paused
	LDR r0, ptr_to_paused
	LDRB r1, [r0]
	CMP r1, #0x00
	BNE EXIT_UART_HANDLER

	;Grab player input
	BL read_character
	CMP r0, #0x64 ;w
	BEQ DIR_UP
	CMP r0, #0x57 ;W
	BEQ DIR_UP
	CMP r0, #0x64 ;d
	BEQ DIR_R
	CMP r0, #0x44 ;D
	BEQ DIR_R
	CMP r0, #0x73 ;s
	BEQ DIR_DOWN
	CMP r0, #0x43 ;S
	BEQ DIR_DOWN
	CMP r0, #0x61 ;a
	BEQ DIR_L
	CMP r0, #0x41 ;A
	BEQ DIR_L
	;Uart handler needs to take in input, check if the WASD/ arrows keys were pressed and then update player direction
DIR_UP:
	MOV r6, #0
	B UPDATE_DIR
DIR_R:
	MOV r6, #1
	B UPDATE_DIR
DIR_DOWN:
	MOV r6, #2
	B UPDATE_DIR
DIR_L:
	MOV r6, #3
	B UPDATE_DIR
UPDATE_DIR:
	LDR r5, ptr_to_playerDir
	STRB r6, [r5]
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

	;toggle puase game value
	LDR r4, ptr_to_paused
	LDRB r5, [r4]
	EOR r5, #1
	STRB r5, [r4]

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
	MOV r4, #0xE000 			;Clock register address
	MOVT r4, #0x400F			;Clock register address
	LDR r6, [r4,#RCGCTIMER]		;Get the value of that address
	ORR r6, #0x01				;Set 1 to bit 0 to ENABLE clock
	STR r6, [r4,#RCGCTIMER]
	;Disable Timer
	MOV r4, #0x0				;Clock register address
	MOVT r4,#0x4003				;Clock register address
	LDRB r6, [r4,#GPTMCTL]
	AND r6, #0xFE				;Preserving everything besides 0 bit
	STRB r6, [r4,#GPTMCTL]
	;Configuration 0 as 32-bit timer
	MOV r4, #0x0000				;Clock register address
	MOVT r4,#0x4003				;Clock register address
	LDRB r6, [r4]				;This is not changed
	MOV r8, #0xFFF8
	AND r6, r6, r8			;Preserving everything besides 0 bit
	STRB r6, [r4]
	;Timer A Mode Register
	MOV r4, #0x0				;Clock register address
	MOVT r4,#0x4003				;Clock register address
	LDRB r6, [r4,#GPTMTAMR]	    ;This is not changed
	ORR r6, #0x2				;Preserving everything besides 0 bit
	STRB r6, [r4,#GPTMTAMR]
	;Clock interval
	MOV r4, #0x0				;Clock register address
	MOVT r4,#0x4003				;Clock register address
	LDRB r6, [r4,#GPTMTAILR]	    ;This is not changed
	MOV r6, #0x1200		;ASK tim if this will put the correct value that we want in the register
	MOV r6, #0x007A
	STRB r6, [r4,#GPTMTAILR]
	;Interrupt Mask Reg
	MOV r4, #0x0				;Clock register address
	MOVT r4,#0x4003				;Clock register address
	LDRB r6, [r4,#GPTMIMR]	    ;This is not changed
	ORR r6, #0x01				;This will set bit 0
	STRB r6, [r4,#GPTMIMR]
	;Enable Register
	MOV r4, #0xE000				;Clock register address
	MOVT r4,#0xE000				;Clock register address
	LDRB r6, [r4,#ENO]	    	;This is not changed
	MOV r7, #0xFFFF			;This is setting r7 to AND it with r6 later
	MOVT r7, #0xFFF7
	AND r6, r6, r7				;We want to set Bit 19 to 0 bit position
	STRB r6, [r4,#ENO]
	;Time Control Reg
	MOV r4, #0x0				;Clock register address
	MOVT r4,#0x4003				;Clock register address
	LDRB r6, [r4,#GPTMCTL]	    ;This is not changed
	ORR r6, #0x01				;This will set bit 0
	STRB r6, [r4,#GPTMCTL]

	POP {r4-r12,lr}
	MOV pc, lr
;----------------------------------------------------------------
;Timer_Handler
;----------------------------------------------------------------
Timer_Handler:

	MOV r0, #0x21
	BL output_character


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
