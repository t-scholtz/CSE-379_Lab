

	.data

;PROGRAM DATA
;================================================================
state:				.byte 0x00 ;State machine: 0 - startup ; 1 - menu ; 2 - game ; 3 - pause ; 4 - vicotry/defeat; 5- Animation/idle
To_BE_dir:			.byte 0x00 ;this will be 1-UP, 2-Down, 3-left, 4-right
Color_pickup:		.byte 0x00 ; this will be 0-don't pick up, 1- pick up

	.text

;POINTERS TO DATA
;================================================================
ptr_to_state:		.word state
ptr_to_To_BE_dir:	.word To_BE_dir
ptr_to_Color_pickup:	.word Color_pickup


;LIST OF SUBROUTINES
;================================================================
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global change_state
	.global CUBE_process

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global start_up_anim
	.global print_menu
	.global print_game
	.global print_pause
	.global read_character
	.global plyr_mov
	.global rotation_anim
	.global CUBE_process
	.global game_reset
	.global illuminate_LEDs
	.global div_and_mod


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
	MOV pc, lr
;----------------------------------------------------------------
;UART0_Handler - handle interupt from keyboard
;----------------------------------------------------------------
UART0_Handler:
	PUSH {r0-r11,lr}
	;Clear uart hanlder flag reg
	MOV r0, #0xC000
	MOVT r0, #0x4000
	LDRB r1, [r0, #UARTICR]		;load in using the offset 0x044
	ORR r1, r1, #0x10
	STRB r1, [r0, #UARTICR]

	;loading in the pointer to the state  State machine: 0 - startup ; 1 - menu ; 2 - game ; 3 - pause ; 4 - vicotry/defeat
	LDR r0, ptr_to_state
	LDRB r1, [r0]				;load the state value
	;check menu
	cmp r1, #1
	BEQ MENU_MODE
	;check game mode
	cmp r1, #2
	BEQ GAME_MODE
	;check the pause mode
	cmp r1, #3
	BEQ PAUSED_MODE
	;if we are in startup, or in victory/defeat
	B EXIT_UART_HANDLER

MENU_MODE:
	BL read_character
	CMP r0, #32
	BEQ START_GAME
	B EXIT_UART_HANDLER

GAME_MODE:
	BL read_character
	LDR r1, ptr_to_To_BE_dir			;this will be the current direction that we the player is traveling that we might have to adjust
	;The player can only click w,a,s,d, or space in order to be valid, check all of these.

	;check W
	CMP r0, #0x57
	BEQ handle_W
	CMP r0, #0x77
	BEQ handle_W

	;check A
	CMP r0, #0x41
	BEQ handle_A
	CMP r0, #0x61
	BEQ handle_A

	;check S
	CMP r0, #0x53
	BEQ handle_S
	CMP r0, #0x73
	BEQ handle_S

	;check D
	CMP r0, #0x44
	BEQ handle_D
	CMP r0, #0x64
	BEQ handle_D

	CMP r0, #0x20
	BEQ handle_Space


	B EXIT_UART_HANDLER

PAUSED_MODE:					;it will edit the same constant as when the player normally hit space
								;we want to do this so we make sure they only effect reset while they are paused
	BL handle_Space
	B EXIT_UART_HANDLER

EXIT_UART_HANDLER:
	POP {r0-r11,lr}
	BX lr

START_GAME:
	BL game_reset
	MOV r0, #2
	BL change_state
	B EXIT_UART_HANDLER

handle_W:
	MVN r0, #1
	MVN r1, #1
	BL plyr_mov
	MOV r2, #1
	LDRB r2, [r1]
	B EXIT_UART_HANDLER

handle_A:
	MOV r0, #1
	MVN r1, #1
	BL plyr_mov
	MOV r2, #3
	LDRB r2, [r1]
	B EXIT_UART_HANDLER

handle_S:
	MVN r0, #1
	MOV r1, #1
	BL plyr_mov
	MOV r2, #2
	LDRB r2, [r1]
	B EXIT_UART_HANDLER

handle_D:
	MOV r0, #1
	MOV r1, #1
	BL plyr_mov
	MOV r2, #4
	LDRB r2, [r1]
	B EXIT_UART_HANDLER

handle_Space:;If the player hits space it will set the value to the pick up as 1 to tell our timer the player can now pick up
	LDR r1, ptr_to_Color_pickup
	MOV r2, #1
	STRB r2, [r1]
	B EXIT_UART_HANDLER
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

	;load the state value
	LDR r0, ptr_to_state
	LDRB r1, [r0]

	;checks game mode
	cmp r1, #2
	BEQ GAME_MODE_switch

	;checks game mode
	cmp r1, #3
	BEQ PAUSE_MODE_switch
	B EXIT_SWITCH_HANDLER

GAME_MODE_switch:			;this will be used to be paused
	MOV r0, #3
	BL change_state
	BL print_pause
	B EXIT_SWITCH_HANDLER

PAUSE_MODE_switch:			;This is going to be used to resume
	MOV r0, #2
	BL print_game

EXIT_SWITCH_HANDLER:
	POP {r0-r11,lr}
	BX lr       	; Return
;================================================================

;----------------------------------------------------------------
;Timer_Handler
;----------------------------------------------------------------
Timer_Handler:  ;State machine: 0 - startup ; 1 - menu ; 2 - game ; 3 - pause ; 4 - vicotry/defeat; 5- Animation/idle
	PUSH {r0-r11,lr}
	;Clear interupt
	MOV r4, #0x0000
	MOVT r4, #0x4003
	LDRB r6, [r4, #GPTMICR]
	ORR r6,r6, #0x01
	STRB r6, [r4, #GPTMICR]

	;Disable timer for testing purposes - delete later
	;B EXIT_TIMER_HANDLER

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

	CMP r0, #4
	BEQ RENDER_VICTORY_FAIL

	CMP r0, #5
	BEQ RENDER_ANIM

RENDER_STARTUP:
	BL start_up_anim
	B EXIT_TIMER_HANDLER

RENDER_MENU:
	BL print_menu
	B EXIT_TIMER_HANDLER

RENDER_GAME:
	;BL Render_game_color_pickup		;Allows us to see if a color should be change on the players current
	BL print_game					;gives our player a view of current everything
	BL CUBE_process					;checks if we need to change the lights
	;take it's value and illuminate the colors
	MOV r4, r0

RENDER_GAME_LIGHT_CHECKS:
	B Render_game_light_checks

RENDER_GAME_FINISH:
	BL illuminate_LEDs
	B EXIT_TIMER_HANDLER

RENDER_PAUSE:
	BL print_pause
	B EXIT_TIMER_HANDLER

RENDER_VICTORY_FAIL:
	; print_victory_fail
	B Render_game_light_checks
	B EXIT_TIMER_HANDLER

RENDER_ANIM:
	BL rotation_anim
	B EXIT_TIMER_HANDLER

EXIT_TIMER_HANDLER:
	POP {r0-r11,lr}
	BX lr
;================================================================


;----------------------------------------------------------------
;Render_game_light_checks ->this is taken out of the handler to make room
;----------------------------------------------------------------
Render_game_light_checks:
	;check if zero faces are finished
	CMP r4, #0
	BEQ RENDER_GAME_0

	;checks if 1 face is finished
	CMP r4, #1
	BEQ RENDER_GAME_1

	;checks if 2 faces are finished
	CMP r4, #2
	BEQ RENDER_GAME_2

	;checks if 3 faces are finished
	CMP r4, #3
	BEQ RENDER_GAME_3

	;checks if 4 faces are finished
	CMP r4, #4
	BEQ RENDER_GAME_4

	;check if we need to do light finish animation
	CMP r4, #5
	BEQ Dancing_LIGHTS

	B Render_game_light_checks			;error check

RENDER_GAME_0:
	MOV r0, #0	;NO LIGHTS 0000
	B RENDER_GAME_FINISH

RENDER_GAME_1:
	MOV r0, #1	;ONE LIGHTS 0001
	B RENDER_GAME_FINISH

RENDER_GAME_2:
	MOV r0, #3	;TWO LIGHTS 0011
	B RENDER_GAME_FINISH

RENDER_GAME_3:
	MOV r0, #7	;THREE LIGHTS 0111
	B RENDER_GAME_FINISH

RENDER_GAME_4:
	MOV r0, #15	;FOUR LIGHTS 1111
	B RENDER_GAME_FINISH

Dancing_LIGHTS:
	MOV r6,  #0x0050
	MOVT r6, #0x4003
	LDRB r0, [r6]				;this is the memory address of the clock value at any point in time     ;divided
	MOV r1, #5																							;divisor

	BL div_and_mod				;return a number 0-4 in r1
	MOV r4, r1
	B Render_game_light_checks	;This will pick a random number of lights to light up

;================================================================

;----------------------------------------------------------------
;Render_game_color_pickup ->this is taken out of the handler to make room
;----------------------------------------------------------------
Render_game_color_pickup:

;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
