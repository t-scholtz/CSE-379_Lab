	.data

;PROGRAM DATA
;================================================================
startCount:			.byte 0x10
menu:				.string 0x82,0x83,0x84,"*********************************",0x0D,0x0A,0x86," ____        _     _ _        ",0x0D,0x0A,"|  _ \ _   _| |__ (_) | _____ ",0x0D,0x0A,"| |_) | | | | '_ \| | |/ / __|",0x0D,0x0A,"|  _ <| |_| | |_) | |   <\__ \ ",0x0D,0x0A,"|_|_\_\\__,_|_.__/|_|_|\_\___/"
					.string 0x0D,0x0A,0x89,"  ____      _          ",0x0D,0x0A," / ___|   _| |__   ___ ",0x0D,0x0A,"| |__| |_| | |_) |  __/ ",0x0D,0x0A,"| |__| |_| | |_) |  __/ ",0x0D,0x0A," \____\__,_|_.__/ \___| ",0x0D,0x0A,0x82,"*********************************"
					.string 0x80, 5,14,"Lab 7 - Tim and Tom",0x80, 5,16,"Game time selected: ",0
menu_cont:			.string 0x80, 5,18,"Press <space> to start game",0

pause_menu:			.string 0x82,0x83,0x84,0x89 , "*********************************",0x82,0x80,0x6,0x6,"Paused",0x80,0x0,0x12 ,0x89 , "*********************************",0

game_board:			.string 0x82,0x83,0x84,0x0D,0x0A
					.string			" _____                                    ",0x0D,0x0A
					.string			"|  __ \                                   ",0x0D,0x0A
					.string			"| |  \/ __ _ _ __ ___   ___    ___  _ __  ",0x0D,0x0A
					.string			"| | __ / _` | '_ ` _ \ / _ \  / _ \| '_ \ ",0x0D,0x0A
					.string			"| |_\ \ (_| | | | | | |  __/ | (_) | | | |",0x0D,0x0A
					.string			" \____/\__,_|_| |_| |_|\___|  \___/|_| |_|",0x0D,0x0A
					.string			"		Score:"
score_loc:			.string									"							   ",0x0D,0x0A
					.string			"		Time:"
time_loc:			.string					"							   ",0x0D,0x0A
					.string			"		Max Time"
max_loc:			.string 		":						   ",0x0D,0x0A
					.string			"										   ",0x0D,0x0A
					.string			"			+-----------------------------+",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			+-----------------------------+",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			+-----------------------------+",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			|         |         |         |",0x0D,0x0A
					.string			"			+-----------------------------+",0x0D,0x0A ,0

logo:				.string 0x82,0x83,0x80,5,10,0x8B," ______    ____   ______   ",0x80,5,11,"/\__  _\ /|  _ \ /\__  _\  ",0x80,5,12,"\/_/\ \/ |/\   | \/_/\ \/  ",0x80,5,13,"   \ \ \  \// __`\/\\ \ \  ",0x80,5,14,"    \ \ \ /|  \L>  <_\ \ \ "
					.string 0x80,5,15,"     \ \_\| \_____/\/ \ \_\ ",0x80,5,16,"      \/_/ \/____/\/   \/_/",0x80,10,17,0x82,"Lab Games",0

square:				.string 0x84,"       ", 27, "[1B",27, "[7D       ",27, "[1B",27, "[7D       ", 0

plry:				.string 0x84, "   ",0x80, 0

game_mode:			.string "100", 0x00

;temp space used to store value and such
temp:				.string "blank Space",0
;temp space used to hold current face on screen
rotated_face:		.string 0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x00
;temp space used to hold the orienation of face moving to
transition_face:	.string 0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x00
	.text




;POINTERS TO DATA
;================================================================
ptr_to_startCount:		.word startCount
ptr_to_logo:			.word logo
ptr_to_menu:			.word menu
ptr_to_menu_cont:		.word menu_cont
ptr_to_pause_menu:		.word pause_menu
ptr_to_game_board:		.word game_board

ptr_to_square:			.word square
ptr_to_plry:			.word plry
ptr_to_temp:			.word temp
ptr_to_rotated_face:	.word rotated_face
ptr_to_transition_face:	.word transition_face

;LIST OF SUBROUTINES
;================================================================
	.global startCount
	.global print_face
	.global print_sqr
	.global start_up_anim
	.global print_menu
	.global print_game
	.global print_pause
	.global print_plyr
	.global ptr_to_rotated_face

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global change_state
	.global ansi_print
	.global output_character
	.global int2string
	.global output_string
	.global get_plyr_data
	.global div_and_mod

;LIST OF CONSTANTS
;================================================================
	.global get_game_mode_str
	.global get_face

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;start_up_anim - prints a startup animation and then changes game
;	state to 1
;----------------------------------------------------------------
start_up_anim:
	PUSH {r4-r12,lr}
	LDR r0, ptr_to_logo
	BL ansi_print
	LDR r4, ptr_to_startCount	;r4 store ref to frames left
	LDRB r5, [r4]				;r5 num of frames left
	CMP r5, #10
	BLT ANIM_DONE
	MOV r0,#101
	MOV r1, #0x10
	SUB r1, r1, r5
	MOV r2, #5
	BL print_sqr
	B ANIM_COND
ANIM_DONE:
	MOV r0,#101
	MOV r1, #7
	MOV r2, #5
	BL print_sqr
	MOV r0,#102
	MOV r1, #7
	MOV r2, #13
	BL print_sqr
	MOV r0,#103
	MOV r1, #7
	MOV r2, #21
	BL print_sqr
	MOV r0,#104
	MOV r1, #19
	MOV r2, #5
	BL print_sqr
	MOV r0,#105
	MOV r1, #19
	MOV r2, #13
	BL print_sqr
	MOV r0,#106
	MOV r1, #19
	MOV r2, #21
	BL print_sqr
ANIM_COND:
	SUB r5,r5,#1
	STRB r5,[r4]
	CMP r5, #0			;when start up animation is finished,
	BGT END_STARTUP		;change state to 1 (menu)
	MOV r0, #1
	BL  change_state
END_STARTUP:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_menu - prints game menu
;----------------------------------------------------------------
print_menu:
	PUSH {r4-r12,lr}
	LDR r0, ptr_to_menu
	BL ansi_print
	BL get_game_mode_str
	BL ansi_print
	LDR r0, ptr_to_menu_cont
	BL ansi_print
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_game - prints game board + player + handles transistions
;----------------------------------------------------------------
print_game:
	PUSH {r4-r12,lr}
	BL get_plyr_data ;r0 - face | r1 - face direction | r2 - tile being hled | r3 - player postion - num 1-9
	MOV r6, r2
	MOV r7, r3		;save data in reg
	;Copy string into local temp copy
	LDR r1, ptr_to_rotated_face
	MOV r9, #9		;for loop counter
COPY_STR:			;r0 - face string data - r1 - temp space to store a copy of the face
	LDRB r2, [r0], #1
	STRB r2, [r1], #1
	CMP r9,#0
	BGT COPY_STR
	BL print_sqr

	mov r0,r7				;move tile number to r0
	SUB r0,r0,#1			;sub tile numb by 1
	mov r1,#3
	BL div_and_mod			;div mod by 3| quotient in r0 | the remainder in r1|
	ADD r0,r0,#1
	ADD r1, r1,#1
	MOV r2, #10
	MUL r2, r1 	,r2			; x pos - mul by space and add constant offset
	ADD r2, r2 ,#18

	MOV r5, #4
	MUL r3, r0 ,r5			; x pos - mul by space and add constant offset
	ADD r3, r3, #10

	MOV r0,r6
	MOV r1,r3
	BL print_plyr	;print the player

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_pause - prints pause menu
;----------------------------------------------------------------
print_pause:
	PUSH {r4-r12,lr}
	LDR r0, ptr_to_pause_menu
	BL ansi_print
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print face- prints a side of the cube to screen
;	input:	r0 - Take a memory address of a string consisting of 9 bytes, each with a value between(0-5)
;		   	r1 - Orientation which a value from (0-3)
;----------------------------------------------------------------
print_face:
	PUSH {r4-r12,lr}
	BL rotate_face
	BL print_face_helper
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;Rotate face- rotates face
;	input:	r0 - Take a memory address of a string consisting of 9 bytes, each with a value between(0-5)
;		   	r1 - Orientation which a value from (0-3)
;	output:	r0 - memoery addres to change face
;----------------------------------------------------------------
rotate_face:
	PUSH {r4-r12,lr}
	MOV r10, r0				;make a copy of the string location so we can re-write it
	MOV r11, r1				;make copy
	CMP r11, #0
	BEQ ROTATE_SKIP
	LDRB r1, [r0] , #1		;load the entire face into registors
	LDRB r2, [r0] , #1
	LDRB r3, [r0] , #1
	LDRB r4, [r0] , #1
	LDRB r5, [r0] , #1
	LDRB r6, [r0] , #1
	LDRB r7, [r0] , #1
	LDRB r8, [r0] , #1
	LDRB r9, [r0] , #1
	MOV r0,r10
	CMP r11, #1
	BEQ ROTATE_1
	CMP r11, #2
	BEQ ROTATE_2
	CMP r11, #3
	BEQ	ROTATE_3
ROTATE_1:
	STRB r7, [r0] , #1		;load the entire face into registors
	STRB r4, [r0] , #1
	STRB r1, [r0] , #1
	STRB r8, [r0] , #1
	STRB r5, [r0] , #1
	STRB r2, [r0] , #1
	STRB r9, [r0] , #1
	STRB r6, [r0] , #1
	STRB r3, [r0] , #1
	B ROTATE_SKIP
ROTATE_2:
	STRB r9, [r0] , #1		;load the entire face into registors
	STRB r8, [r0] , #1
	STRB r7, [r0] , #1
	STRB r6, [r0] , #1
	STRB r5, [r0] , #1
	STRB r4, [r0] , #1
	STRB r3, [r0] , #1
	STRB r2, [r0] , #1
	STRB r1, [r0] , #1
	B ROTATE_SKIP
ROTATE_3:
	STRB r3, [r0] , #1		;load the entire face into registors
	STRB r6, [r0] , #1
	STRB r9, [r0] , #1
	STRB r2, [r0] , #1
	STRB r5, [r0] , #1
	STRB r8, [r0] , #1
	STRB r1, [r0] , #1
	STRB r4, [r0] , #1
	STRB r7, [r0] , #1
	B ROTATE_SKIP
ROTATE_SKIP:
	MOV r0, r10
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;print face helper -
;	input: r0 - takes in a null terminated string of 9 bytes
;----------------------------------------------------------------
print_face_helper:
	PUSH {r4-r12,lr}
	MOV r4,r0	;copy string into r1, freeing r0 to pass colours to print sqr | r4 = input string
	MOV r5, #0	;used in a nested for loop - 3 across - 3 down 	: r5 = i =0
	MOV r8, #4		;storing constant for multipication[5 for block width because square is 3x3 with extra layer between
	MOV r9, #10		;storing constant for multipication[4 because square is 3x3 with extra layer between
	LDR r0, ptr_to_game_board
	BL ansi_print
PFH_LOOP_I:
	MOV r6, #0	;r6 = j = 0
	ADD r5, r5, #1	;i++
	CMP r5, #3
	BGT PFH_EXITLOOP
PFH_LOOP_J:
	ADD r6, r6, #1	;j++
	MOV r1, #0		;x pos for sqaure - reset value
	MUL r1, r5, r8	;how many blocks right is this square
	ADD r1, r1, #9	;constant offest for position sqare
	MUL r2, r6, r9	;how many blocks right is this square
	ADD r2, r2, #17	;constant offest for position sqare
	LDRB r0,[r4],#1	;load byte colour to be printed
	BL print_sqr	;print sqr to screen
	CMP r6, #3
	BGE PFH_LOOP_I
	B PFH_LOOP_J
PFH_EXITLOOP:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;print_plyr - Prints the player on the board
;	Input - r0 - colour
;		  - r1 - x pos
;		  - r2 - y pos
;	No Output
;----------------------------------------------------------------
print_plyr:
	PUSH {r4-r12,lr}
	MOV r8,r0 				;save input values
	MOV r9, r1
	MOV r10,r2

	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[

	LDR r0, ptr_to_temp
	MOV r1,r9
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string		;print num down

	MOV r0, #59
	BL output_character		;print ;

	LDR r0, ptr_to_temp
	MOV r1,r10
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string		;print num right

	MOV r0, #72
	BL output_character		;print H

	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[

	LDR r0, ptr_to_temp
	MOV r1,r8
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string

	MOV r0, #109
	BL output_character		;print m

	LDR r0, ptr_to_plry
	BL ansi_print			;print coloured square and then reset everything back to default

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_sqr - prints a 3x3 square - colour must be between 101-107
;	input r0 - colour
;		  r1 - Y pos
;		  r2 - X pos
;----------------------------------------------------------------
print_sqr:
	PUSH {r4-r12,lr}
	MOV r8,r0 				;save input values
	MOV r9,r1
	MOV r10,r2

	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[

	LDR r0, ptr_to_temp
	MOV r1,r9
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string		;print num down

	MOV r0, #59
	BL output_character		;print ;

	LDR r0, ptr_to_temp
	MOV r1,r10
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string		;print num right

	MOV r0, #72
	BL output_character		;print H

	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[

	LDR r0, ptr_to_temp
	MOV r1,r8
	BL int2string
	LDR r0, ptr_to_temp
	BL output_string

	MOV r0, #109
	BL output_character		;print m

	LDR r0, ptr_to_square
	BL ansi_print			;print coloured square and then reset everything back to default

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
