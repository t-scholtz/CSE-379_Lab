	.data

;PROGRAM DATA
;================================================================
startCount:			.byte 0x10
rotateCount:		.byte 0x02
menu:				.string 0x82,0x83,0x84,"*********************************",0x0D,0x0A,0x86
					.string " ____        _     _ _        ",0x0D,0x0A
					.string "|  _ \ _   _| |__ (_) | _____ ",0x0D,0x0A
					.string "| |_) | | | | '_ \| | |/ / __|",0x0D,0x0A
					.string "|  _ <| |_| | |_) | |   <\__ \ ",0x0D,0x0A
					.string "|_|_\_\\__,_|_.__/|_|_|\_\___/", 0x0D,0x0A,0x89
					.string "  ____      _          ",0x0D,0x0A
					.string " / ___|   _| |__   ___ ",0x0D,0x0A
					.string "| |__| |_| | |_) |  __/ ",0x0D,0x0A
					.string "| |__| |_| | |_) |  __/ ",0x0D,0x0A
					.string " \____\__,_|_.__/ \___| ",0x0D,0x0A,0x82, "*********************************"
					.string 0x80, 5,14,"Lab 7 - Tim and Tom",0x80, 5,16,"Game time selected:",0
menu_cont:			.string 0x80, 5,18,"Press <space> to start game"
					.string 0x80, 5,20,0x87,"Intructions:"
					.string 0x80, 5,21,"*Use WASD to move around the board"
					.string 0x80, 5,22,"*Use <space-bar> to pick up tiles"
					.string 0x80, 5,23,"*Use sw1 to pause the game",0



Victory:			.string 0x82,0x83,0x84,"*********************************",0x0D,0x0A,0x86
					.string" __      ___      _                   ",0x0D,0x0A
					.string" \ \    / (_)    | |                  ",0x0D,0x0A
					.string"  \ \  / / _  ___| |_ ___  _ __ _   _ ",0x0D,0x0A
					.string"   \ \/ / | |/ __| __/ _ \| '__| | | |",0x0D,0x0A
					.string"    \  /  | | (__| || (_) | |  | |_| |",0x0D,0x0A
					.string"     \/   |_|\___|\__\___/|_|   \__, |",0x0D,0x0A
					.string"                                 __/ |",0x0D,0x0A
					.string"                                |___/ ",0x0D,0x0A,0x89
					.string"*********************************",0x0D,0x0A,0x86,0

Fail:				.string  0x82,0x83,0x84,"*********************************",0x0D,0x0A,0x86
					.string"  ______    _ _ ",0x0D,0x0A
					.string" |  ____|  (_) |",0x0D,0x0A
					.string" | |__ __ _ _| |",0x0D,0x0A
					.string" |  __/ _` | | |",0x0D,0x0A
					.string" | | | (_| | | |",0x0D,0x0A
					.string" |_|  \__,_|_|_|",0x0D,0x0A
					.string" WOMP WOMP WOMP ",0x0D,0x0A,0x89
					.string"*********************************",0x0D,0x0A,0x86,0

Game_ENDING_score:	.string 0x80, 5,14,"FINAL SCORE: ", 0
Game_ENDING_time:	.string 0x80, 5,16,"TIME TAKEN : ", 0
Game_ENDING_choice:       .string 0x80, 5,18,"Press <space> to Restart game",0x80, 5,20,"Press <E> to Exit game",0

pause_menu:			.string 0x82,0x83,0x89 , "		*********************************************************************",0x82,0x0D,0x0A,0x0D,0x0A
					.string "		   _____                                                       _ "    ,0x0D,0x0A
					.string "		  / ____|                                                     | |"    ,0x0D,0x0A
 					.string "		 | |  __  __ _ _ __ ___   ___   _ __   __ _ _   _ ___  ___  __| |"      ,0x0D,0x0A
					.string "		 | | |_ |/ _` | '_ ` _ \ / _ \ | '_ \ / _` | | | / __|/ _ \/ _` | "     ,0x0D,0x0A
 					.string "		 | |__| | (_| | | | | | |  __/ | |_) | (_| | |_| \__ \  __/ (_| |   "   ,0x0D,0x0A
					.string "		  \_____|\__,_|_| |_|_|_|\___| | .__/ \__,_|\__,_|___/\___|\__,_|  ",0x0D,0x0A,0x0D,0x0A
					.string 0x8B,"					SW1 	- Pause game",0x0D,0x0A
					.string 0x8C,"					Space - Resart game",0x0D,0x0A,0x0D,0x0A
					.string 0x82,0x89 , "		*********************************************************************",0x82,0x84,0

game_head:			.string 0x82,0x83,0x84,0x0D,0x0A
					.string			" _____                                    ",0x0D,0x0A
					.string			"|  __ \                                   ",0x0D,0x0A
					.string			"| |  \/ __ _ _ __ ___   ___    ___  _ __  ",0x0D,0x0A
					.string			"| | __ / _` | '_ ` _ \ / _ \  / _ \| '_ \ ",0x0D,0x0A
					.string			"| |_\ \ (_| | | | | | |  __/ | (_) | | | |",0x0D,0x0A
					.string			" \____/\__,_|_| |_| |_|\___|  \___/|_| |_|",0x0D,0x0A
					.string			"		Score: ",0
score_loc:			.string			"							   ",0
lc:					.string			0x0D,0x0A,"		Time: ",0
time_loc:			.string			"							   "
tc:					.string			0x0D,0x0A,"		Max Time: "
max_loc:			.string 		"		"
game_board:			.string			"						"
					.string			0x0D,0x0A,0x0D,0x0A,"			+-----------------------------+",0x0D,0x0A
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
					.string			"			+-----------------------------+",0x0D,0x0A,0x0D,0x0A,0

logo:				.string 0x82,0x83,0x80,5,10,0x8B," ______    ____   ______   ",0x80,5,11,"/\__  _\ /|  _ \ /\__  _\  ",0x80,5,12,"\/_/\ \/ |/\   | \/_/\ \/  ",0x80,5,13,"   \ \ \  \// __`\/\\ \ \  ",0x80,5,14,"    \ \ \ /|  \L>  <_\ \ \ "
					.string 0x80,5,15,"     \ \_\| \_____/\/ \ \_\ ",0x80,5,16,"      \/_/ \/____/\/   \/_/",0x80,16,17,0x82,"Lab Games",0

square:				.string 0x84,"       ", 27, "[1B",27, "[7D       ",27, "[1B",27, "[7D       ", 0

plry:				.string 0x84,"   ",0x82,0x84,0

game_mode:			.string "100", 0x00


trans_A:			.string "			+---------------------------------+",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			+---------------------------------+",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			+---------------------------------+",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			|       |        |         |      |",0x0D,0x0A
					.string "			+---------------------------------+",0x0D,0x0A,0
trans_A_string:		.string 0x01,0x12

trans_B:			.string	"			+-------------------------------------+",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			+-------------------------------------+",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			+-------------------------------------+",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			|   |     |        |        |     |   |",0x0D,0x0A
					.string	"			+-------------------------------------+",0x0D,0x0A,0
trans_B_string:		.string 0x01,0x12

trans_C:			.string "			+---------------------------------+",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			+---------------------------------+",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			+---------------------------------+",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			|      |         |        |       |",0x0D,0x0A
					.string "			+---------------------------------+",0x0D,0x0A,0
trans_C_string:		.string 0x01,0x12




;temp space used to store value and such
temp:				.string "blank Space              ",0
;temp space used to hold current face on screen
rotated_face:		.string 0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x00
;temp space used to hold the orienation of face moving to
transition_face:	.string 0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x00
;rotation direction value
rotation_dir:		.byte 0x00 ; 1 - up | 2- down | 3  left-| 4 - right|
	.text




;POINTERS TO DATA
;================================================================
ptr_to_startCount:			.word startCount
ptr_to_logo:				.word logo
ptr_to_menu:				.word menu
ptr_to_Victory:				.word Victory
ptr_to_Fail:				.word Fail
ptr_to_Game_ENDING_score:	.word Game_ENDING_score
ptr_to_Game_ENDING_time:	.word Game_ENDING_time
ptr_to_Game_ENDING_choice:	.word Game_ENDING_choice
ptr_to_menu_cont:			.word menu_cont
ptr_to_pause_menu:			.word pause_menu
ptr_to_game_board:			.word game_board
ptr_to_game_head:			.word game_head
ptr_to_score_loc:			.word score_loc
ptr_to_time_loc:			.word time_loc
ptr_to_max_loc:				.word max_loc
ptr_to_lc:					.word lc
ptr_to_tc:					.word tc

ptr_to_square:				.word square
ptr_to_plry:				.word plry
ptr_to_temp:				.word temp
ptr_to_rotated_face:		.word rotated_face
ptr_to_transition_face:		.word transition_face
ptr_to_rotateCount:			.word rotateCount
ptr_to_rotation_dir:		.word rotation_dir
ptr_to_trans_A:				.word trans_A
ptr_to_trans_A_string:		.word trans_A_string
ptr_to_trans_B:				.word trans_B
ptr_to_trans_B_string:		.word trans_B_string
ptr_to_trans_C:				.word trans_C
ptr_to_trans_C_string:		.word trans_C_string

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
	.global rotation_setup
	.global rotation_anim
	.global print_game_header
	.global get_rotated_face
	.global print_Victory
	.global print_GameEND_Score
	.global print_GameEND_Time
	.global print_GameEND_Choice


;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global change_state
	.global ansi_print
	.global output_character
	.global int2string
	.global output_string
	.global get_plyr_data
	.global div_and_mod
	.global get_game_data
	.global get_face



;LIST OF CONSTANTS
;================================================================
	.global get_game_mode_str
	.global get_face
	.global change_state

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;print mass sqrs - r0 takes in a series of bytes in the order of
; square number, x value, y value and it repeats until 250, at
;which point it gets the values for the players postion and
;colour and prints that to screen
;----------------------------------------------------------------
print_mass_sqrs:
	PUSH {r4-r12,lr}
	MOV r5, r0 ; save pointer to byte data
PRINT_SQRS:
	LDRB r0, [r5], #1	;load first byte, check if value is 250 to change to print plr
	CMP r0, #250
	BGE PRINT_PLYR
			;r0 - tile number
	LDRB r1, [r5], #1		;r1 - x value
	LDRB r2, [r5], #1		;r2 - y value
	;check if we're printing for the first face or second face
	;1-9 first face 10-18 second face
	CMP r0, #10
	BGE SECOND_FACE
	SUB r0,r0,#1
	LDR r8, ptr_to_rotated_face
	LDRB r0, [r8,r0]			;load the tile colour from the tile number specified

	B PRINT_TILE
SECOND_FACE:
	SUB r0, r0, #10
	LDR r8, ptr_to_transition_face
	LDRB r0, [r8,r0]			;load the tile colour from the tile number specified

PRINT_TILE:

	BL print_sqr	 ;r0 - colour| r1 - Y pos|r2 - X pos
	B PRINT_SQRS
PRINT_PLYR:
	LDRB r0, [r5], #1 ;r0 - x value
	LDRB r1, [r5], #1 ;r0 - y value


	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
;----------------------------------------------------------------
;get rotated face- return memory address to rot string
;	OUTPUt r0 - address of string
;----------------------------------------------------------------
get_rotated_face:
	PUSH {lr}
	LDR r0, ptr_to_rotated_face
	POP {lr}
	MOV pc, lr
;================================================================



;----------------------------------------------------------------
;rotation_setup - sets up rotation animation and handles state
; change
;	Input:
;		r0 - starting face value
;		r1 - landing face value
;		r2 - direction of transition
;----------------------------------------------------------------
rotation_setup:
	PUSH {r4-r12,lr}
	;save input values
	MOV r5,r1
	MOV r6,r2
	;Store the primary face into memory
	BL get_face
	LDR r1, ptr_to_rotated_face
	MOV r2, #9			;counter
CPY_STR_1:				;make a local copy of the tile faces
	SUB r2,r2,#1
	LDRB r4,[r0],#1
	STRB r4,[r1],#1
	CMP r2, #0
	BGT CPY_STR_1
	;Store the transction face into memory
	MOV r0,r5
	BL get_face
	LDR r1, ptr_to_transition_face
	MOV r2, #9			;counter
CPY_STR_2:				;make a local copy of the tile faces
	SUB r2,r2,#1
	LDRB r4,[r0],#1
	STRB r4,[r1],#1
	CMP r2, #0
	BGT CPY_STR_2

	;store rotation direction into memory
	LDR r5, ptr_to_rotation_dir
	STRB r6, [r5]

	;reset animation timer to start value
	LDR r6, ptr_to_rotateCount
	MOV r7, #2
	STRB r7, [r6]

	;update game state to play animation
	MOV r0, #5
	BL change_state

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;rotation_anim - prints a startup animation and then changes game
;	state to 1
;----------------------------------------------------------------
rotation_anim:
	PUSH {r4-r12,lr}
	;TEMP skip rotation ANIMATION
	B FINAL_EXIT_ROT_ANIM
	;print the header
	BL print_game_header
	;load frame number, decriment and store again
	LDR r0, ptr_to_rotateCount
	LDRB r1, [r0]
	SUB r1,r1,#1
	STRB r1, [r0]
	;load rotation direction
	LDR r0 , ptr_to_rotation_dir
	LDRB r0, [r0]	;roation direction
	;check what frame we are on and print image accordingly
	CMP r1, #2
	BEQ FRAME_1
	CMP r1, #1
	BEQ FRAME_2
	CMP r1, #0
	BLE FRAME_3
FRAME_1:
	CMP r0, #2
	BEQ DOWN_1
	CMP r0, #3
	BEQ LEFT_1
	CMP r0, #4
	BGE RIGHT_1
UP_1:

DOWN_1:

LEFT_1:
	LDR r0, ptr_to_trans_A_string
	LDR r5 , ptr_to_trans_A
	B EXIT_ROT_ANIM
RIGHT_1:
	LDR r0, ptr_to_trans_C_string
	LDR r5 , ptr_to_trans_C
	B EXIT_ROT_ANIM

	B EXIT_ROT_ANIM
FRAME_2:
	CMP r0, #2
	BEQ DOWN_1
	CMP r0, #3
	BEQ LEFT_1
	CMP r0, #4
	BGE RIGHT_1

UP_2:

DOWN_2:

LEFT_2:
RIGHT_2:
	LDR r0, ptr_to_trans_B_string
	LDR r5 , ptr_to_trans_B
	B EXIT_ROT_ANIM

	B EXIT_ROT_ANIM
FRAME_3:
	CMP r0, #2
	BEQ DOWN_1
	CMP r0, #3
	BEQ LEFT_1
	CMP r0, #4
	BGE RIGHT_1
UP_3:

DOWN_3:

LEFT_3:
	LDR r0, ptr_to_trans_C_string
	LDR r5 , ptr_to_trans_C
	B FINAL_EXIT_ROT_ANIM
RIGHT_3:
	LDR r0, ptr_to_trans_A_string
	LDR r5 , ptr_to_trans_A
	B FINAL_EXIT_ROT_ANIM

FINAL_EXIT_ROT_ANIM:
	;return to play state of game
	MOV r6,r0
	MOV r0, #2
	BL change_state
	MOV r0,r6
EXIT_ROT_ANIM:
	LDR r0, ptr_to_trans_A_string
	;BL print_mass_sqrs
	;MOV r0,r5
	;BL ansi_print
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


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
	CMP r5, #9
	BLT ANIM_DONE
	MOV r0,#107
	MOV r1, #0x10
	SUB r1, r1,r5
	MOV r2, #5
	BL print_sqr
	B ANIM_COND
ANIM_DONE:
	MOV r0,#107
	MOV r1, #7
	MOV r2, #5
	BL print_sqr
	MOV r0,#102
	MOV r1, #7
	MOV r2, #14
	BL print_sqr
	MOV r0,#103
	MOV r1, #7
	MOV r2, #23
	BL print_sqr
	MOV r0,#104
	MOV r1, #19
	MOV r2, #5
	BL print_sqr
	MOV r0,#105
	MOV r1, #19
	MOV r2, #14
	BL print_sqr
	MOV r0,#106
	MOV r1, #19
	MOV r2, #23
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
;print_Victory - prints victory stats and menu
;				INPUT: r2, the victry or NOT flag
;----------------------------------------------------------------
print_Victory:
	PUSH {r4-r12,lr}
	CMP r2, #0
	BEQ print_Fail

	LDR r0, ptr_to_Victory			;loads in the VICTORY ACSII COMBO
	BL ansi_print					;prints the ASCII COMBO

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
;----------------------------------------------------------------
;print_Fail - prints Fail stats and menu
;----------------------------------------------------------------
print_Fail:
	PUSH {r4-r12,lr}

	LDR r0, ptr_to_Fail		;loads in the VICTORY ACSII COMBO
	BL ansi_print					;prints the ASCII COMBO

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
;----------------------------------------------------------------
;print_GameEND_Score - prints victory stats and menu
;----------------------------------------------------------------
print_GameEND_Score:
	PUSH {r4-r12,lr}

	LDR r0, ptr_to_Game_ENDING_score		;loads in the VICTORY ACSII COMBO
	BL ansi_print							;prints the ASCII COMBO

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
;----------------------------------------------------------------
;print_GameEND_Time - prints victory stats and menu
;----------------------------------------------------------------
print_GameEND_Time:
	PUSH {r4-r12,lr}

	LDR r0, ptr_to_Game_ENDING_time		;loads in the VICTORY ACSII COMBO
	BL ansi_print						;prints the ASCII COMBO

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
;----------------------------------------------------------------
;print_GameEND_Choice - prints victory stats and menu
;----------------------------------------------------------------
print_GameEND_Choice:
	PUSH {r4-r12,lr}

	LDR r0, ptr_to_Game_ENDING_choice		;loads in the VICTORY ACSII COMBO
	BL ansi_print							;prints the ASCII COMBO

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_game - prints game board + player + handles transistions
;----------------------------------------------------------------
print_game:
	PUSH {r4-r11,lr}
	BL print_game_header	; print game header + score values

	BL get_plyr_data ;r0 - face | r1 - face direction | r2 - tile being hled | r3 - player postion - num 1-9
	MOV r5, r1
	MOV r6, r2
	MOV r7, r3		;save data in reg
	BL get_face
	;Copy string into local temp copy
	LDR r1, ptr_to_rotated_face

	MOV r9, #8	;for loop counter
COPY_STR:			;r0 - face string data - r1 - temp space to store a copy of the face
	LDRB r2, [r0], #1
	STRB r2, [r1], #1
	CMP r9,#0
	SUB r9,r9,#1
	BGT COPY_STR

	SUB r0,r1,#9 ;string location to print - subtrac number of places incremented by
	MOV r1,r5
	BL print_face

	mov r0,r7				;move tile number to r0
	SUB r0,r0,#1			;sub tile numb by 1
	mov r1,#3
	BL div_and_mod			;div mod by 3| quotient in r0 | the remainder in r1|
	ADD r0,r0,#1
	ADD r1, r1,#1
	MOV r2, #10
	MUL r2, r1 	,r2			; x pos - mul by space and add constant offset
	ADD r2, r2 ,#19

	MOV r5, #4
	MUL r3, r0 ,r5			;  pos - mul by space and add constant offset
	ADD r3, r3, #10

	MOV r0,r6
	;r2 define ealier
	MOV r1,r3
	BL print_plyr	;print the player

	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_game header - prints game boards header + values
;----------------------------------------------------------------
print_game_header:
	PUSH {r4-r12,lr}
	BL get_game_data	;r0 - ptr to game mode string;			r1 - game time;			r2 - score
	MOV r6,r1
	MOV r7,r2
	LDR r1, ptr_to_max_loc
	;copy string to other sttring
HEADER_CPY:
	LDRB r2, [r0], #1
	CMP	r2, #0
	BEQ HEADER_CONT
	STRB r2, [r1] , #1
	B HEADER_CPY
HEADER_CONT:
	LDR r0, ptr_to_score_loc
	MOV r1, r7
	BL int2string
	LDR r0, ptr_to_time_loc
	MOV r1, r6
	BL int2string
	LDR r0, ptr_to_game_head
	BL ansi_print

	LDR r0, ptr_to_score_loc
	BL ansi_print

	LDR r0, ptr_to_lc
	BL ansi_print

	LDR r0, ptr_to_time_loc
	BL ansi_print

	LDR r0, ptr_to_tc
	BL ansi_print

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
	;LDR r0, ptr_to_game_board
	;BL ansi_print
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
