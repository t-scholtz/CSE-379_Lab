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
startUpPrompt:	.string 0x0D, 0x0A, "Hello! Lab 5 - Tom and Tim",0
intructions:	.string 0x0D, 0x0A, "Game intructions: This is a 2 player game in which players test their reaction speed",0x0D, 0x0A,"The goal is to press your button faster than your oponent, but not too early",0x0D, 0x0A,"The text, ready, set, go, will appear, and only after go should you press your button",0x0D, 0x0A,"Player 1 - press space bar",0x0D, 0x0A,"Player 2 - press sw1",0x0D, 0x0A , 0
waiting:		.string "Waiting: ",0
press:			.string "<<< Press Enter to Start / Q to Exit >>>",0x0D, 0x0A,0
ready:			.string 0x0D, 0x0A, "READY?...",0
set:			.string 0x0D, 0x0A, "SET!...",0
gogo:			.string 0x0D, 0x0A, "GOOOOO!!!",0
askRunAgain:	.string "Would you like to run again Yes(Y) No(N)?", 0
extmsg:			.string "End of program â€»\(^o^)/â€»", 0
state:			.byte	0x01
p1Score:		.byte	0x00
p1WINS:			.string 0x0D, 0x0A, "Player 1 WINS", 0
p2Score:		.byte	0x00
p2WINS:			.string 0x0D, 0x0A, "Player 2 WINS", 0
disqualified:	.byte	0x00
change:			.byte	0x00
space:			.string "space" ,0
bothDis:		.string "Both players were disqualified, no one scores this round",0
scorePromt:		.string 0x0D, 0x0A,"The scores are:",0
p1ScorePrompt:	.string	"Player 1: ",0
p2ScorePrompt:	.string	"Player 2: ",0
playIntruct:	.string	"Ply 1 - press space | Ply 2 - press SW1",0
nextRound:		.string "Press Enter to start the next round",0

;================================================================

	.text
;POINTERS TO STRING
;================================================================
ptr_to_startUpPrompt:	.word startUpPrompt
ptr_to_intructions:		.word intructions
ptr_to_waiting:			.word waiting
ptr_to_press:			.word press
ptr_to_ready:			.word ready
ptr_to_set:				.word set
ptr_to_gogo:			.word gogo
ptr_to_askRunAgain		.word askRunAgain
ptr_to_extmsg			.word extmsg
ptr_to_state:			.word state
ptr_to_p1Score:			.word p1Score
ptr_to_p1WINS:			.word p1WINS
ptr_to_p2Score:			.word p2Score
ptr_to_p2WINS:			.word p2WINS
ptr_to_change:			.word change
ptr_to_disqualified:	.word disqualified
ptr_to_space:			.word space
ptr_to_bothDis:			.word bothDis
ptr_to_scorePromt:		.word scorePromt
ptr_to_p1ScorePrompt:	.word p1ScorePrompt
ptr_to_p2ScorePrompt:	.word p2ScorePrompt
ptr_to_playIntruct:		.word playIntruct
ptr_to_nextRound:		.word nextRound
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
	;Start up sequence
	LDR r0, ptr_to_startUpPrompt
	MVN r1, #1
	BL output_string


;================================================================;~~~~~~~~~~~~~~~~~~~~~~~~~
;Game state table
;	1 - start mode
;	2 - round start (wait perdiod)
;	3 - reaction test
;	4 - next round loop
;	5 - transition state (if things start breaking)
;~~~~~~~~~~~~~~~~~~~~~~~~~

;-------------------------------
;Start menu
;------------------------------
GAMELOOP:
	MOV r6, #0
	LDR r5, ptr_to_p1Score		;RESET player scores to zero and dis statues
	STRB r6, [r5]
	LDR r5, ptr_to_p2Score		;RESET player scores to zero and dis statues
	STRB r6, [r5]
	LDR r5, ptr_to_disqualified		;RESET player scores to zero and dis statues
	STRB r6, [r5]
	LDR r5, ptr_to_change
	MOV r6,#0
	STRB r6 , [r5]
instructions:	;Print Instructions to screen
	MOV r4,#1
	LDR r5, ptr_to_state	;set Program state to 1
	STRB r4, [r5]
	LDR r0, ptr_to_intructions
	MVN r1, #1
	BL output_string
	LDR r0, ptr_to_press
	BL output_string	;print press to start
waitforgametostart:	;waiting for user to press enter tostart the game
	MOV r3, #0			;counter
	MOV r1, #0x01
waitforgameLoop:		;wait for usr input loop - prints scrolling text to show program still running
	MOV r0, #0x0C
	BL output_character		;clear screen
	MOV r0, #0x0D
	BL output_character		;print cariage return
	MOV r0, #0x0C
	BL output_character		;clear screen
	MOV r1, #1
	LDR r0, ptr_to_waiting	;printing waiting
	BL output_string
	MOV r4, #0
printPressLoop:
	LDR r5, ptr_to_change
	LDRB r6 , [r5]
	CMP r6,#1
	BEQ round_Loop
	CMP r6,#2
	BEQ END_PROGRAM
	ADD r4,r4,#1
	MOV r0, #0x2E
	BL output_character
	CMP r4,r3
	BLT printPressLoop	;Loop to print spaces where r3 is the num to print
	ADD r3, #1			;after loop increment r3
	MOV r0,r3
	MOV r1,#12
	BL div_and_mod		;mod r3 by 8 to reset r3 to 0 for when it gets to 8
	MOV r3, r1
	MOV r7,#0			;count to a big number
	MOVT r7, #0x000F
	MOV r8, #0
burn:					;TIM: More comments would be appricated to narrate your thought process when you are not with me coding
	LDR r5, ptr_to_change
	LDRB r6 , [r5]
	CMP r6,#1
	BEQ round_Loop
	CMP r6,#2
	BEQ END_PROGRAM
	add r8,r8, #1
	NOP
	CMP r8,r7
	BLE burn
	B waitforgameLoop
;------------------------
;End of start menu
;------------------------


;-------------------------
;Round start
;set game state to 2
;print scores
;check if a player one
;reset disqualifed status
;---------------
round_Loop:				;This is the round loop - prints the round number + player scores
	LDR r5, ptr_to_change
	MOV r6,#0
	STRB r6 , [r5]
	LDR r0, ptr_to_state		;load stateProgram
	MOV r1, #2					;update state of program - state 2
	STRB r1, [r0]
	LDR r5, ptr_to_disqualified
	MOV r6, #0
	STRB r6, [r5]		;Reset disqualifed status of both players

	;SETTING up the clock for later
	MOV r10, #0x0000
	MOVT r10, #0x0080


game_startLOOP: 		;This is gonna be the point where we do the READY... SET... GO...
;R10 will be reseved for clock time
;r9 will be the comparing adress represeing a huge number for the clock
	MVN r1,#1 	;move neg one onto r1 so print stings will print neg numbres
THREE_BILL:
	MOV r9, #0x0000
	MOVT r9, #0x0080
	CMP r10, r9
	BEQ print_ready
ONE_HALF_BILL:
	MOV r9,  #0x0000
	MOVT r9, #0x0040
	CMP r10, r9
	BEQ print_set
;DONE print gogo!!! 0 billion
;JUMPS to press and read which prints GO! plus updates to state 3 and waits for user input
	CMP r10, #0x0
	BEQ press_and_read
	;FINALLY just sub 1 and branch
	SUB r10, r10, #1
	B game_startLOOP

;these need to stay at the end so they don't accidently get called
print_ready:		;r0 used to store val
					;r1 is the newline flag
	MOV r0, #12
	BL output_character
	LDR r0, ptr_to_ready
	MVN r1, #1
	BL output_string
	SUB r10, r10, #1
	B game_startLOOP

print_set:			;r0 used to store val
					;r1 is the newline flag
	LDR r0, ptr_to_set
	MVN r1, #1
	BL output_string
	SUB r10, r10, #1
	B game_startLOOP

press_and_read:
	;print go
	LDR r0, ptr_to_gogo
	MVN r1, #1
	BL output_string

	;check if both players have disqualified themselves
	LDR r5, ptr_to_disqualified
	LDRB r6, [r5]				;load disqualfied memory address and set bit 0 to 1
	CMP r6, #3
	BEQ BOTH_DISQUALIFIED

	;print instructions
	LDR r0, ptr_to_playIntruct
	BL output_string

	;change to state 3
	LDR r0, ptr_to_state		;load stateProgram
	MOV r1, #3					;update state of program
	STRB r1, [r0]
reactionWaitTime:
	LDR r5, ptr_to_change
	LDRB r6 , [r5]
	CMP r6,#1
	BEQ WaitnextRound
	B reactionWaitTime

BOTH_DISQUALIFIED:
	LDR r0, ptr_to_bothDis
	MVN r1, #1
	BL output_string
	B round_Loop

P1Wins:				;r0 used to store val
					;r1 is the newline flag
	LDR r0, ptr_to_p1WINS
	MVN r1, #1
	BL output_string
	B GAMELOOP

P2Wins: 			;r0 used to store val
					;r1 is the newline flag
	LDR r0, ptr_to_p2WINS
	MVN r1, #1
	BL output_string
	B GAMELOOP

WaitnextRound:						;state 4
	LDR r5, ptr_to_change
	MOV r6, #0
	STRB r6, [r5]
	LDR r0, ptr_to_state		;load stateProgram
	MOV r1, #4					;update state of program to state 4
	STRB r1, [r0]
	MVN r1, #1					;print and load scores
	LDR r0, ptr_to_scorePromt
	BL output_string
	LDR r0, ptr_to_p1ScorePrompt	;load plr 1 score
	MOV r1, #1
	BL output_string
	LDR r9, ptr_to_p1Score
	LDRB r0, [r9]
	MOV r6, r0					;store ply 1 socre in r6
	ADD r0,r0, #0x30
	BL output_character			;print plr 1 scores
	MOV r0, #10					;new line
	BL output_character
	MOV r0, #13
	BL output_character			;return char
	LDR r0,  ptr_to_p2ScorePrompt	;load plr 2 score
	MOV r1, #1
	BL output_string
	LDR r9, ptr_to_p2Score
	LDRB r0, [r9]
	MOV r7, r0					;store ply 2 socre in r7
	ADD r0,r0, #0x30
	BL output_character
	MOV r0, #10
	BL output_character			;print new line
	MOV r0, #13
	BL output_character			;return char
	CMP r6, #3
	BGE	P1Wins					;check if player 1 one
	CMP r7, #3
	BGE	P2Wins					;check if player 2 one

	LDR r0, ptr_to_nextRound
	BL output_string

waitForPlayStartRound:
	LDR r5, ptr_to_change
	LDRB r6 , [r5]
	CMP r6,#1
	BEQ round_Loop
	B waitForPlayStartRound

Lab5FINAL:
	LDR r0, ptr_to_extmsg			;see's if the user wants to go again
	MVN r1, #1
	BL output_string


END_PROGRAM:
	POP {r4-r12,lr} 		; Restore registers to adhere to the AAPCS
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;UART0_Handler - This is the interupt that is ran Once a signal f rom the UART ex
 ;----------------------------------------------------------------
UART0_Handler:
	PUSH {r0-r11,lr}
	MOV r0, #0xC000 					;This is the UART Base address
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTICR]				;This loads the base value of the UARTIM data and we need to update it
	ORR r1, r1, #0x10			;Should set the 4th bit to 0 to clear register
	STRB r1, [r0, #UARTICR]

	LDR r0, ptr_to_state
	LDRB r1, [r0]		;state of program is stored in r1
	BL read_character					;if it return the space bar space was pressed P1 WINS
	MOV r4,r0			;copy value read to r4
	BL output_character
	CMP r1, #1			;Check what state the code is in and act acorindly
	BEQ U_STATE1
	CMP r1, #2
	BEQ U_STATE2
	CMP r1, #3
	BEQ U_STATE3
	CMP r1, #4
	BEQ U_STATE4
EXIT_UART_HANDLER:
	POP {r0-r11,lr}
	BX lr

EXIT_ROUTINE:
	LDR r5, ptr_to_change
	MOV r6, #2
	STRB r6, [r5]
	POP {r0-r11,lr}
	BX lr

U_STATE1:
	CMP r4,#0x71	;check if q was pressed and if so exit
	BEQ EXIT_ROUTINE
	CMP r4,#0x51 	;check if Q was pressed and if so exit
	BEQ EXIT_ROUTINE
	CMP r4,#0x0D
	BNE EXIT_UART_HANDLER
	LDR r0, ptr_to_state		;load stateProgram
	MOV r1, #2					;update state of program
	STRB r1, [r0]
	LDR r5, ptr_to_change
	MOV r6, #1
	STRB r6, [r5]
	B EXIT_UART_HANDLER			;jump to start of next part of program
U_STATE2:
	CMP r4,#0x20 				;If user pressed space - disqualife them
	BNE EXIT_UART_HANDLER
	LDR r5, ptr_to_disqualified
	LDRB r6, [r5]				;load disqualfied memory address and set bit 0 to 1
	ORR r6,r6,#1
	STRB r6, [r5]
	B EXIT_UART_HANDLER
U_STATE3:
	CMP r4, #0x20
	BNE EXIT_UART_HANDLER	;update player socre and move to wait for next round thing
	;check if disqualfied
	LDR r5, ptr_to_disqualified
	LDRB r6, [r5]				;load disqualfied memory address and set bit 0 to 1
	CMP r6, #1
	BEQ EXIT_UART_HANDLER
	LDR r5, ptr_to_p1Score
	LDRB r6, [r5]				;load disqualfied memory address and set bit 0 to 1
	ADD r6,r6,#1
	STRB r6, [r5]
	LDR r5, ptr_to_change
	MOV r6, #1
	STRB r6, [r5]
	B EXIT_UART_HANDLER

U_STATE4:
	CMP r4,#0x0D
	BNE EXIT_UART_HANDLER	;check if enter pressed to start the next rou d
	LDR r5, ptr_to_change
	MOV r6, #1
	STRB r6, [r5]
	B EXIT_UART_HANDLER
;================================================================

;----------------------------------------------------------------
;Switch_Handler - handles interupt for sw1 being pressed
;----------------------------------------------------------------
Switch_Handler:
	PUSH {r0-r11,lr}
	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0,#GPIOICR]
	ORR r1,r1,#16
	STRB r1, [r0,#GPIOICR]
	LDR r0, ptr_to_state
	LDRB r1, [r0]		;state of program is stored in r1

	CMP r1, #1
	BEQ EXIT_SWITCH_HANDLER	;No action required for state 1
	CMP r1, #2
	BEQ S_STATE2
	CMP r1, #3
	BEQ S_STATE3
	CMP r1, #4
	BEQ EXIT_SWITCH_HANDLER	;No action required for state 4
EXIT_SWITCH_HANDLER
	POP {r0-r11,lr}
	BX lr       	; Return


S_STATE2:
	LDR r5, ptr_to_disqualified
	LDRB r6, [r5]				;load disqualfied memory address and set bit 1 to 1
	ORR r6,r6,#2
	STRB r6, [r5]
	B EXIT_SWITCH_HANDLER
S_STATE3:
	LDR r5, ptr_to_disqualified
	LDRB r6, [r5]				;load disqualfied memory address and set bit 0 to 1
	CMP r6, #2
	BEQ EXIT_SWITCH_HANDLER
	LDR r5, ptr_to_p2Score
	LDRB r6, [r5]				;load disqualfied memory address and set bit 0 to 1
	ADD r6,r6,#1
	STRB r6, [r5]
	LDR r5, ptr_to_change
	MOV r6, #1
	STRB r6, [r5]
	B EXIT_SWITCH_HANDLER

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

;----------------------------------------------------------------
;uart_interrupt_init: This subroutine will generate an interupt
;when a keystroke is generated by a user in PUTTY
;----------------------------------------------------------------
uart_interrupt_init:

	MOV r0, #0xC000 ;This is the UART Base address
	MOVT r0, #0x4000

	LDR r1, [r0, #UARTIM]	;This loads the base value of the UARTIM data and we need to update it
	ORR r1, r1, #16			;Now we have the updated value to store back
	STR r1, [r0, #UARTIM]

							;Now we need to set the ENABLE pin
	MOV  r0, #0xE000 		;This is the UART Base address
	MOVT r0, #0xE000
							;We need to access bit 5 at the ENABLE position
	LDR r1, [r0, #ENO]	;This loads the base value of the ENABLE data and we need to update it
	ORR r1, r1, #32			;Now we have the updated value to store back
	STR r1, [r0, #ENO]

	MOV r0, #0xC000 					;This is the UART Base address
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTICR]				;This loads the base value of the UARTIM data and we need to update it
	ORR r1, r1, #0x10			;Should set the 4th bit to 0 to clear register
	STRB r1, [r0, #UARTICR]
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;gpio_interrupt_init - initliase interupt for sw1
;----------------------------------------------------------------
gpio_interrupt_init:
	PUSH {r4-r12,lr}
	MOV r0,#5		;load port f
	BL portINIT
	MOV r0,r1
	LDRB r1, [r0,#GPIOIS]
	AND r1,r1,#0xEF
	STRB r1, [r0,#GPIOIS]
	LDRB r1, [r0,#GPIOIBE]	;set to trigger on single edge change
	AND r1,r1,#0xEF
	STRB r1, [r0,#GPIOIBE]
	LDRB r1, [r0,#GPIOIV]	;set to trigger on falling edge
	ORR r1,r1,#0x10
	STRB r1, [r0,#GPIOIV]
	LDRB r1, [r0,#GPIOIM]	;
	ORR r1,r1,#0x10
	STRB r1, [r0,#GPIOIM]
	MOV r0, #0xE000
	MOVT r0, #0xE000
	LDR r1, [r0,#0x100]
	MOV r2, #0
	MOVT r2, #0x4000
	ORR r1,r1,r2
	STR r1, [r0,#0x100]
	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0,#GPIOICR]
	ORR r1,r1,#16
	STRB r1, [r0,#GPIOICR]
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


	.end

;Exit
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
