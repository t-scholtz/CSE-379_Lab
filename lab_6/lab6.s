	.data

;PROGRAM DATA
;================================================================
playerDir:		.byte	0x00	; 0 up 1 right 2 down 3 left
xPos:			.byte	0x0A
yPos:			.byte	0x0A
score:			.byte	0x00
scoreStr:		.string "12345",0
paused:			.byte	0x00	; 0 -> not puased | 1 pauesed
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
;================================================================

	.text

;POINTERS TO STRING
;================================================================
ptr_to_playerDir:		.word playerDir
ptr_to_xPos:			.word xPos
ptr_to_yPos:			.word yPos
ptr_to_score:			.word score
ptr_to_scoreStr:		.word scoreStr
ptr_to_paused:			.word paused
ptr_to_startUpPrompt:	.word startUpPrompt
ptr_to_scorePrompt:		.word scorePrompt
ptr_to_gameBoard:		.word gameBoard
;================================================================


;LIST OF SUBROUTINES
;================================================================
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global simple_read_character
	.global lab6
;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global uart_init
	.global output_string
	.global output_character
	.global portINIT
	.global div_and_mod
	.global read_character
	.global output_character
	.global int2string
	.global switch_init
;================================================================


;LIST OF CONSTANTS
;================================================================
GPTMICR: 			.equ 0x024		; UARTIM offset
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
;LAB 6 MAIN
;----------------------------------------------------------------

;----------------------------------------------------------------
;LAB 5 MAIN
;----------------------------------------------------------------
lab6:								; This is your main routine which is called from
; your C wrapper.
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS

	;Set up connections and interupts
	bl uart_init
	bl uart_interrupt_init
	bl switch_init
	bl gpio_interrupt_init
	bl timer_init


	;Start up sequence
	LDR r0, ptr_to_startUpPrompt
	MOV r1, #1
	BL output_string
	MOV r0, #1
LOOP:
	ADD r0, r0, #1
	B LOOP

END_PROGRAM:
	POP {r4-r12,lr} 		; Restore registers to adhere to the AAPCS
	MOV pc, lr
;================================================================



;----------------------------------------------------------------
;timer_init - conencts the timer to the interupt handler
;	takes no input
;----------------------------------------------------------------
timer_init:
	PUSH {r4-r12,lr}
	MOV r0, #0xE604
	MOVT r0, #0x400F
	LDRB r1, [r0]
	ORR r1,r1,#1		;activate bits 0-5 if not work
	STRB r1, [r0]

	MOV r0, #0xC
	MOVT r0, #0x4003
	LDRB r1,[r0]
	AND r1, r1,#0xFE
	STRB r1, [r0]

	MOV r0,#0
	MOVT r0, #0x4003
	LDRB r1,[r0]
	AND r1, r1, #0xF8
	STRB r1, [r0]

	MOV r0, #4
	MOVT r0, #0x4003
	LDRB r1, [r0]
	AND r1, r1, #0xFC
	ORR r1, r1, #2
	STRB r1, [r0]

	MOV r0,#0x28
	MOVT r0, #0x4003
	MOVT r1, #0x0040
	STR r1, [r0]

	MOV r0,#0x18
	MOVT r0, #0x4003
	LDRB r1,[r0]
	ORR r1, r1, #0x01
	STRB r1, [r0]

	MOV r0,#0xE100
	MOVT r0, #0xE000
	LDR r1, [r0]
	MOV r2, #0
	MOVT r2, #0x0008
	ORR r1, r1, r2
	STR r1, [r0]

	MOV r0,#0x18
	MOVT r0, #0x4003
	LDRB r1,[r0]
	ORR r1, r1, #0x01
	STRB r1, [r0]

	MOV r0,#0xC
	MOVT r0, #0x4003
	LDRB r1,[r0]
	ORR r1, r1, #0x01
	STRB r1, [r0]

	MOV r4, #0x0000
	MOVT r4, #0x4003
	LDRB r6, [r4, #GPTMICR]
	ORR r6,r6, #0x01
	STRB r6, [r4, #GPTMICR]

	POP {r4-r12,lr} 		; Restore registers to adhere to the AAPCS
	MOV pc, lr
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

	MOV r0, #0x21
	BL output_character

	POP {r0-r11,lr}
	BX lr       	; Return
;================================================================


simple_read_character:

	MOV pc, lr	; Return

	.end
	;Exit
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

