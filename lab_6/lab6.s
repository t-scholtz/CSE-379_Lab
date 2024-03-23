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
pauseMsg:		.string "Paused",0
pausePosX:		.byte	0x08
pausePosY:		.byte	0x0A
pauseDirX:		.byte 	0x01
pauseDirY:		.byte 	0x02
pauseMenu:		.string "----------------------",0x0D, 0x0A
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
movCurTp:		.string 0x1B, 0x5B, 0x32 ,0x32, 0x41, 0x00
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
ptr_to_pauseMsg:		.word pauseMsg
ptr_to_pausePosX:		.word pausePosX
ptr_to_pausePosY:		.word pausePosY
ptr_to_pauseDirX:		.word pauseDirX
ptr_to_pauseDirY:		.word pauseDirY
ptr_to_pauseMenu:		.word pauseMenu
ptr_to_movCurTp:		.word movCurTp
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
; your C wrapper.
lab6:
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
	;Inf Loop
LOOP:
	ADD r0, r0, #1
	B LOOP

	;Exit routine
END_PROGRAM:
	POP {r4-r12,lr}
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
	BEQ EXIT_UART_HANDLER

	;Grab player input and update dir to up/down/left/right
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
	BEQ DIR_D
	CMP r0, #0x43 ;S
	BEQ DIR_D
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
DIR_D:
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
	;clear game screen and mov cur to start
	MOV r0, #0x0C
	BL output_character
	MOV r0, #0x0D
	BL output_character

	;check if game is paused
	LDR r4, ptr_to_paused
	LDRB r5, [r4]
	CMP r5, #0
	BNE Pause_Screen
	;if game not paused update player info and screen
	B Update_Game
	B EXIT_TIMER_HANDLER

EXIT_TIMER_HANDLER:
	POP {r0-r11,lr}
	BX lr       	; Return
;================================================================


;----------------------------------------------------------------
;Update Game - the main game screen
;Updates the point * depening on the game settings
;only access from Timer Handler
;----------------------------------------------------------------
Update_Game:
	;load player date
	LDR r0, ptr_to_playerDir
	LDRB r4, [r0]
	LDR r0, ptr_to_xPos
	LDRB r5, [r0]
	LDR r0, ptr_to_yPos
	LDRB r6, [r0]



	;check for colisiont -> handle if Case
	CMP r5, #0
	BLE COLISION
	CMP r5, #22
	BGE COLISION
	CMP r6, #0
	BLE COLISION
	CMP r6, #22
	BGE COLISION

	;Update game map and score

	;print game map and score

	;update player values


COLISION:



	B EXIT_TIMER_HANDLER

;================================================================

;----------------------------------------------------------------
;Pause Screen - pause screen to show game is paused
;shows the word paused getting bounced around the playing box
;only access from Timer Handler
;----------------------------------------------------------------
Pause_Screen:						;game paused state - have moveing puause string across page
	;print Paused - (replaces player score)
	LDR r0, ptr_to_pauseMsg
	MOV r1, #1
	BL output_string
	;print pause box
	LDR r0, ptr_to_pauseMenu
	MOV r1, #1
	BL output_string
	LDR r0 , ptr_to_movCurTp		;move cursor to top of screen using ansi commands
	BL output_string
	;print current positon of pause
	LDR r10, ptr_to_pausePosX
	LDRB r3, [r10]
	LDR r10, ptr_to_pausePosY
	LDRB r4, [r10]

	MOV r0, #0x0D
	BL output_character
	MOV r0, #0x0A
	BL output_character				;charige ruetnr and mov on line down from the ceiling
	MOV r1, r4						;make a copy of posY


	;the pause word has the attrubutes of position - x,y, - and velecity which is stored as x and y
	;when pause encounters a wall its velcoty chnages to the complement value
	;y moves 2 per screen and x moves 1
movDownY:
	MOV r0, #0x0A
	BL output_character
	SUB r1,r1,#1
	CMP r1,#1
	BGT movDownY

	;Mov the cursor and print pause at correct loaction
	MOV r0, #0x7C			;print wall
	BL output_character
	MOV r1, r3						;make a copy of poxX
movRightX:
	MOV r0, #0x20
	BL output_character
	SUB r1,r1,#1
	CMP r1,#1
	BGT movRightX

	LDR r0, ptr_to_pauseMsg
	BL output_string

	;update pause location and velcotiry
	LDR r10, ptr_to_pauseDirX
	LDRSB r5, [r10]
	LDR r10, ptr_to_pauseDirY
	LDRSB r6, [r10]
	;update x value of pause
updateX:
	ADD r3, r3, r5
	cmp r3, #2
	BLE leftWall
	cmp r3, #16
	BGE rightWall
	LDR r10, ptr_to_pausePosX
	STRB r3, [r10]
	B updateY
leftWall:
	MOV r3,#2
	LDR r10, ptr_to_pausePosX
	STRB r3, [r10]
	MOV r5, #1
	LDR r10, ptr_to_pauseDirX
	STRB r5, [r10]
	B updateY

rightWall:
	MOV r3,#16
	LDR r10, ptr_to_pausePosX
	STRB r3, [r10]
	MVN r5, #1
	LDR r10, ptr_to_pauseDirX
	STRB r5, [r10]
	B updateY

	;updateYVal of pause
updateY:
	ADD r4, r4, r6
	cmp r4, #2
	BLE top
	cmp r4, #21
	BGE bottom
	LDR r10, ptr_to_pausePosY
	STRB r4, [r10]
	B EXIT_TIMER_HANDLER
top:
	MOV r4,#2
	LDR r10, ptr_to_pausePosY
	STRB r4, [r10]
	MOV r6, #2
	LDR r10, ptr_to_pauseDirY
	STRB r6, [r10]
	B EXIT_TIMER_HANDLER

bottom:
	MOV r4,#21
	LDR r10, ptr_to_pausePosY
	STRB r4, [r10]
	MVN r6, #2
	LDR r10, ptr_to_pauseDirY
	STRB r6, [r10]
	B EXIT_TIMER_HANDLER
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
	ORR r1,r1,#1
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
	;Set timer lenght here -- stored in R0
	MOV r0,#0x28
	MOVT r0, #0x4003
	MOV r1, #0x1200
	MOVT r1, #0x007A
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

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

	.end
	;Exit
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

