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
;================================================================

;PROGRAM DATA
;================================================================
startUpPrompt:	.string 0x0D, 0x0A, "Hello! Lab 5 - Tom and Tim",0
intructions:	.string 0x0D, 0x0A, "Game intructions: This is a 2 player game in which players test their reaction speed",0x0D, 0x0A,"The goal is to press your button faster than your oponent, but not too early",0x0D, 0x0A,"Player 1 - press space bar",0x0D, 0x0A,"Player 2 - press sw1" , 0
waiting:		.string "Waiting: ",0
press:			.string "<<< Press to Start >>>",0
ready:			.string 0x0D, 0x0A, "READY?..."
set:			.string 0x0D, 0x0A, "SET!..."
gogo:			.string 0x0D, 0x0A, "GOOOOO!!!"
state:			.byte	0x01
p1Score:		.byte	0x00
p2Score:		.byte	0x00
disqualified:	.byte	0x00 ;INSTEAD OF HANFLING IT HERE I AM GOING TO HAVE IT AT THE BOTTOM
space:			.string "space" ,0

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
ptr_to_state:			.word state
ptr_to_p1Score:			.word p1Score
ptr_to_p2Score:			.word p2Score
ptr_to_disqualified:	.word disqualified
ptr_to_space:			.word space
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

	;SETTING up the clock for later
	MOV r10, #0x0000
	MOVT r10, #0x00F0
	;This should give us a healthy clock of 3 billion(TEMP)

;~~~~~~~~~~~~~~~~~~~~~~~~~
;Game state table
;	1 - start mode
;	2 - round start (wait perdiod)
;	3 - reaction test
;	4 - calculation mode (don't accept input)
;~~~~~~~~~~~~~~~~~~~~~~~~~
GAMELOOP:

instructions:			;Print Instructions to screen

	MOV r4,#1
	LDR r5, ptr_to_state;set Program state to 1
	STRB r4, [r5]
	LDR r0, ptr_to_intructions
	MVN r1, #1
	BL output_string

waitforgametostart:	;waiting for user to press enter tostart the game

	MOV r3, #0			;counter
	MOV r1, #0x01

waitforgameLoop:		;wait for usr input loop - prints scrolling text to show program still running

	MOV r0, #0x0D
	MOV r1, #1
	BL output_character	;print cariage return
	LDR r0, ptr_to_waiting
	BL output_string
	MOV r4, #0

printPressLoop:

	ADD r4,r4,#1
	MOV r0, #0x20
	BL output_character
	CMP r4,r3
	BLT printPressLoop	;Loop to print spaces where r3 is the num to print
	ADD r3, #1			;after loop increment r3
	LDR r0, ptr_to_press
	BL output_string	;print press to start
	MOV r0,r3
	MOV r1,#100
	BL div_and_mod		;mod r3 by 100 to reset r3 to 0 for when it gets to 100
	MOV r3, r1
	MOV r7,#0			;count to a big number
	MOVT r7, #0x000F
	MOV r8, #0
burn:					;TIM: More comments would be appricated to narrate your thought process when you are not with me coding

	;TOMS CODE, I am adding a check because it seems to get stuck here after the first state needs to change
	LDR r0, ptr_to_state
	LDRB r1, [r0]		;state of program is stored in r1
	CMP r1, #2 			;This will let us know when it needs to switch
	BEQ game_startLOOP
	;TOMS CODE END, this is to make sure it switches to the countdown state


	add r8,r8, #1
	NOP
	CMP r8,r7
	BLE burn
	B waitforgameLoop

game_startLOOP: 		;This is gonna be the point where we do the READY... SET... GO...
;R10 will be reseved for clock time
;r9 will be the comparing adress represeing a huge number for the clock

	;First print READY 3 billion

THREE_BILL:
	MOV r9, #0x0000
	MOVT r9, #0x00F0
	CMP r10, r9
	BEQ print_ready

ONE_HALF_BILL:
	;HALF DONE print SET!, 1.5 billion
	MOV r9,  #0x0000
	MOVT r9, #0x0080
	CMP r10, r9
	BEQ print_set

ZERO_BILL:
	;DONE print gogo!!! 0 billion
	CMP r10, #0x0
	BEQ print_go
	;CHECK state
	LDR r0, ptr_to_state
	LDRB r1, [r0]
	;FINALLY just sub 1 and branch
	SUB r10, r10, #1
	B game_startLOOP

print_ready:
	LDR r0, ptr_to_ready
	MVN r1, #1
	BL output_string
	B ONE_HALF_BILL

print_set:
	LDR r0, ptr_to_set
	MVN r1, #1
	BL output_string
	B ZERO_BILL

print_go:
	LDR r0, ptr_to_gogo
	MVN r1, #1
	BL output_string

press_and_read:;THIS IS WHERE I AM WORKING AND IT IS NOT CORRECTLY EXICUTING THESE

	; This is where you should implement a loop, waiting for the u  ser to
	; enter a q, indicating they want to end the program.

	POP {lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr
;================================================================


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
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;UART0_Handler - This is the interupt that is ran Once a signal f rom the UART ex
 ;----------------------------------------------------------------
UART0_Handler:
	PUSH {r0-r12,lr}
	LDR r0, ptr_to_state
	LDRB r1, [r0]		;state of program is stored in r1
	;BL read_character					;if it return the space bar space was pressed P1 WINS
	CMP r0, #0x20
	;IF not space
	BNE FINISH_UART0_HANDLER
	;IF space
	LDR r0, ptr_to_space
	BL output_string

	CMP r1, #1

	CMP r1, #2

	CMP r1, #3

	CMP r1, #4

FINISH_UART0_HANDLER:
	MOV r0, #0xC000 					;This is the UART Base address
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTICR]				;This loads the base value of the UARTIM data and we need to update it
	ORR r1, r1, #0x10				;Should set the 4th bit to 0 to clear register
	STRB r1, [r0, #UARTICR]

	POP {r0-r12,lr}
	BX lr
;================================================================

;----------------------------------------------------------------
;Switch_Handler - handles interupt for sw1 being pressed
;----------------------------------------------------------------
Switch_Handler:
	PUSH {r0-r12,lr}
	LDR r0, ptr_to_state
	LDRB r1, [r0]		;state of program is stored in r1

	BL state_changer 	;Have all of the state discitions moved to here

	;Clear interupt value
	MOV r0, #0x5000
	MOVT r0, #0x4002
	LDRB r1, [r0,#GPIOICR]
	ORR r1,r1,#0x10
	STRB r1, [r0,#GPIOICR]

	POP {r0-r12,lr}
	BX lr       	; Return
;================================================================

;----------------------------------------------------------------
;state_changer - Takes in current state in r1
; 				 Then alters it depending on certian copnditions
;---------------------------------------------------------------
state_changer:
	PUSH {r4-r12,lr}
	;IF you are currently in state one
	CMP r1, #1
	BEQ FIRST_S

	;IF you are currently in state two
	CMP r1, #2
	BEQ SECOND_S

	;IF you are currently in state three
	CMP r1, #3
	BEQ THIRD_S

	;IF you are currently in state four
	CMP r1, #4
	BEQ FOURTH_S

FIRST_S:
	;Currently they should be in the press to start portion
	;All that is needed here is the to move up to the next
	MOV r1, #2
	STRB r1, [r0]				;This will alter the value of the state
	;MOV  pc, game_startLOOP		;I don't know if this will update the program counter but I need to update the location
	BL FINISH_state_changer

SECOND_S:
	BL FINISH_state_changer

THIRD_S:
	BL FINISH_state_changer

FOURTH_S:
	BL FINISH_state_changer

FINISH_state_changer:

	POP {r4-r12,lr}
	MOV pc, lr
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

;Exit
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
