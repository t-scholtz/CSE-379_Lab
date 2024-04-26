

	.data

;PROGRAM DATA
;================================================================
state:					.byte 0x00 ;State machine: 0 - startup ; 1 - menu ; 2 - game ; 3 - pause ; 4 - vicotry/defeat; 5- Animation/idle
To_BE_dir:				.byte 0x00 ;this will be 1-UP, 2-Down, 3-left, 4-right
Color_pickup:			.byte 0x00 ; this will be 0-don't pick up, 1- pick up

Internal_timer:			.byte 0x00 ;this timer will need to be reset at the beggining of every game
Internal_score:			.byte 0x00 ;This is simply a flag to see if someting was pressed so that the update to the score will occur

Victory_fail_LOOP		.byte 0x00 ;A way to slowly build up the final screen to look cool
Victory_fail_flag		.byte 0x00 ;this is how we will know if we print Fail or Vicotry

	.text

;POINTERS TO DATA
;================================================================
ptr_to_state:				.word state
ptr_to_To_BE_dir:			.word To_BE_dir
ptr_to_Color_pickup:		.word Color_pickup
ptr_to_Internal_timer		.word Internal_timer
ptr_to_Internal_score		.word Internal_score
ptr_to_Victory_fail_LOOP	.word Victory_fail_LOOP
ptr_to_Victory_fail_flag	.word Victory_fail_flag


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
	.global game_Time_Score
	.global set_tile
	.global get_tile
	.global get_plyr_data
	.global illuminate_RGB_LED
	.global print_Victory
	.global print_GameEND_Score
	.global print_GameEND_Time
	.global print_GameEND_Choice


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
	;THE SECOND WE KNOW IT IS IN GAMEMODE we can increment the score
	LDR r1, ptr_to_Internal_score
	MOV r2, #0x1
	STRB r2, [r1]

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
	BL read_character				;we want to do this so we make sure they only effect reset while they are paused
	CMP r0, #0x20
	BEQ reset_game
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
	MOV r2, #1
	STRB r2, [r1]
	B EXIT_UART_HANDLER

handle_A:
	MOV r2, #3
	STRB r2, [r1]
	B EXIT_UART_HANDLER

handle_S:
	MOV r2, #2
	STRB r2, [r1]
	B EXIT_UART_HANDLER

handle_D:
	MOV r2, #4
	STRB r2, [r1]
	B EXIT_UART_HANDLER

handle_Space:;If the player hits space it will set the value to the pick up as 1 to tell our timer the player can now pick up
	LDR r1, ptr_to_Color_pickup
	MOV r2, #1
	STRB r2, [r1]
	MOV r0, #2
	BL change_state
	B EXIT_UART_HANDLER

reset_game:
	BL game_reset
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
	BL change_state
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
	;Resetting my internal timer to make sure it can be reused
	LDR r0, ptr_to_Internal_timer
	MOV r1, #0
	STRB r1, [r0]
	LDR r0, ptr_to_Victory_fail_flag
	MOV r1, #0
	STRB r1, [r0]


	BL print_menu
	B EXIT_TIMER_HANDLER

RENDER_GAME:
	;Move player
	LDR r2, ptr_to_To_BE_dir
	LDRB r1, [r2]
	MOV r0,#0
	STRB r0, [r2]
	CMP r1,#1
	BEQ MOVE_UP
	CMP r1,#2
	BEQ MOVE_DOWN
	CMP r1,#3
	BEQ MOVE_LEFT
	CMP r1,#4
	BEQ MOVE_RIGHT

RENDER_CONT:
	;UPDATE the timer value
	LDR r1, ptr_to_Internal_timer		;grab the internal timer address
	LDRB r0, [r1]						;r1 grabs the timer value  		;divided
	ADD r0, r0, #1
	STRB r0, [r1]						;storing the old value back before we mess with it
	MOV r1, #2															;divisor
	;run div and mod to see if even or ODD
	BL div_and_mod						;r1 is the remainder  r0 will be the divided value
	MOV r3, r0							;put the divided value in r3

	BL game_Time_Score				;timer address in r0
									;Score address in r1
	STRB r3, [r0]					;Store our new time

	LDR r0, ptr_to_Internal_score	;get the score bit flag
	LDRB r2, [r0]
	LDRB r4, [r1]					;loading the actual score

	CMP r2, #1						;checks if the bit is active
	ITTTT EQ
	LDRBEQ r4, [r1]
	ADDEQ r4, r4, #1				;adding and storing the score back if true
	STRBEQ r4, [r1]

	MOVEQ r2, #0					;resetting the score flag
	STRB r2, [r0]


	BL Render_game_color_pickup		;Allows us to see if a color should be change on the players current
	BL print_game					;gives our player a view of current everything
	BL CUBE_process					;checks if we need to change the lights
	;take it's value and illuminate the colors
	MOV r4, r0
	;quickly checking if we need to set it to the finish state

RENDER_GAME_STATE_POSSIBLE_CHANGE:
	CMP r4, #5
	ITTT GE
	LDRGE r1, ptr_to_state			;loads the states
	MOVGE r2, #4
	STRBGE r2, [r1]					;stored 4 back in to change the state

RENDER_GAME_LIGHT_CHECKS:
	BL Render_game_light_checks

RENDER_VICTORY_FAIL:
	LDR r0, ptr_to_Victory_fail_LOOP
	LDRB r1, [r0]					;gets the state of the victory and fail loop
	LDR r0, ptr_to_Victory_fail_flag
	LDRB r2, [r0]					;gets to see if we are failing or VICTORY we will use this to print_Victory

	CMP r1, #0
	B RENDER_GAME_FINISH_1			;just prints Victory

	CMP r1, #1
	B RENDER_GAME_FINISH_2			;this will print victory with score

	CMP r1, #2
	B RENDER_GAME_FINISH_3			;this will print victory with score and time

	CMP r1, #3
	B RENDER_GAME_FINISH_4			;this will print victory with everything else

RENDER_GAME_FINISH_1:
	BL print_Victory
	BL illuminate_LEDs
	B EXIT_TIMER_HANDLER

RENDER_GAME_FINISH_2:
	BL print_Victory
	BL print_GameEND_Score
	BL illuminate_LEDs
	B EXIT_TIMER_HANDLER

RENDER_GAME_FINISH_3:
	BL print_Victory
	BL print_GameEND_Score
	BL print_GameEND_Time
	BL illuminate_LEDs
	B EXIT_TIMER_HANDLER

RENDER_GAME_FINISH_4:

	BL print_Victory
	BL print_GameEND_Score
	BL print_GameEND_Time
	BL print_GameEND_Choice
	BL illuminate_LEDs
	B EXIT_TIMER_HANDLER

RENDER_PAUSE:
	BL print_pause
	B EXIT_TIMER_HANDLER

RENDER_GAME_FINISH:
	; print_victory_fail
	;B Render_game_light_checks
	B EXIT_TIMER_HANDLER

RENDER_ANIM:
	BL rotation_anim
	B EXIT_TIMER_HANDLER

EXIT_TIMER_HANDLER:
	POP {r0-r11,lr}
	BX lr

MOVE_UP:
	MVN r0, #0
	MVN r1, #0
	BL plyr_mov
	B RENDER_CONT

MOVE_LEFT:
	MOV r0, #1
	MVN r1, #0
	BL plyr_mov
	B RENDER_CONT

MOVE_DOWN:
	MVN r0, #0
	MOV r1, #1
	BL plyr_mov
	B RENDER_CONT

MOVE_RIGHT:
	MOV r0, #1
	MOV r1, #1
	BL plyr_mov
	B RENDER_CONT
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
;Render_game_color_pickup ->So if the player hits space
;----------------------------------------------------------------
Render_game_color_pickup:
	PUSH {r4-r11,lr}

	LDR r1, ptr_to_Color_pickup
	LDRB r2, [r1]					;Gets the value of either 1 or 0 to see if the color of the player and the square need to be switched

INITIAL_Render_game_color_pickup:
	CMP r2, #0
	BEQ Render_game_color_pickup_FINISH
	;otherwise it should be greater than

	;resetting the value to 0
 	MOV r2, #0
	STRB r2, [r1]

	;Grab the tile and the current player color //TALK TO TIM ABOUT CHANGING LINE 378 FOR THE PLAYER DATA
	BL get_plyr_data				;r2 will be the player color
    MOV r4, r2					;r4 player color held, r0 will be the face held, r3 is the tile num
	MOV r5, r0						;r5 will be the face held
	MOV r6, r3						;r6 will be the tile num held

	;get the tile color that the player is on
	MOV r1, r3						;tile num is now also in r1
	BL get_tile						;tile color will be in r0
	MOV r7, r0						;r7 tile color currently

	;SET tile	r0 - face number   r1 - tile number   r3 - new tile colour
	MOV r0, r5
	MOV r1, r6
	MOV r3, r4
	BL set_tile

	;Here, we can update what we are picking up for the on board LED
	MOV r1, #0x5000
	MOVT r1, #0x4002
	SUB r0, r7, #101		;this should properly calculate what the new player LED should be
	BL illuminate_RGB_LED

	;SET player color
	BL game_Time_Score		;r0- game_time address
							;r1- score address
							;r2- player color address
	STRB r7, [r2]

Render_game_color_pickup_FINISH:

	POP {r4-r11,lr}
	MOV pc, lr


;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
