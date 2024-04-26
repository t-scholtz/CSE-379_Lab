	.data

;PROGRAM DATA
;================================================================
face:		.byte 0x03	;tile the player is currently on
face_dir:	.byte 0x00	;how many times rotated left (0-3)
tile_held:	.byte 0x65	;the colour of the tile the player is holding
x_pos:		.byte 0x02	;players x location (1-3)
y_pos:		.byte 0x02	;players y location (1-3)
game_mode:	.byte 0x01 ;Number between 1-4 (1-100| 2-200|3- 300| 4-400
game_time:	.word 0x00000000
score:		.word 0x00000000

rotation_tracker:	.byte 0x00

rot_str:	.string 0x01,0x02,0x03,0x02,0


mode1_str:	.string "100     ",0
mode1_val:	.word	0x00000064
mode2_str:	.string	"200     ",0
mode2_val:	.word	0x000000c8
mode3_str:	.string	"300     ",0
mode3_val:	.word	0x0000012c
mode4_str:	.string	"Unlimted",0
mode4_val:	.word	0x0FFFFFFF



temp:		.string "temp spcae used for storage and cacl",0
unlimated:	.string "unlimited",0

	.text

;POINTERS TO DATA
;================================================================
ptr_to_face:		.word face
ptr_to_face_dir:	.word face_dir
ptr_to_tile_held:	.word tile_held
ptr_to_x_pos:		.word x_pos
ptr_to_y_pos:		.word y_pos
ptr_to_game_mode:	.word game_mode
ptr_to_game_time:	.word game_time
ptr_to_temp:		.word temp
ptr_to_score:		.word score
ptr_to_rotation_tracker: .word rotation_tracker

ptr_to_mode1_str:	.word mode1_str
ptr_to_mode1_val:	.word mode1_val
ptr_to_mode2_str:	.word mode2_str
ptr_to_mode2_val:	.word mode2_val
ptr_to_mode3_str:	.word mode3_str
ptr_to_mode3_val:	.word mode3_val
ptr_to_mode4_str:	.word mode4_str
ptr_to_mode4_val:	.word mode4_val
ptr_to_rot_str:		.word rot_str


;LIST OF SUBROUTINES
;================================================================
	.global pick_up
	.global plyr_mov
	.global get_game_mode_str
	.global get_plyr_data
	.global get_game_data
	.global game_reset
	.global game_Time_Score
	.global get_pylr_abs
	.global get_game_mode_val
	.global rot_tile
	.global get_pylr_absB
	.global set_game_mode

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global int2string
	.global get_adj_face
	.global rotation_setup
	.global Generate
	.global get_rotated_face
	.global get_tile

;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;----------------------------------------------------------------
;get pylr abs - returns the player absolute postion
;	Take no input
;	Output - r3 - returns a value 1-9 of the player abs position
;----------------------------------------------------------------
get_pylr_abs:
	PUSH {r4-r11,lr}
	LDR r4, ptr_to_y_pos
	LDRB r4, [r4]
	SUB r4,r4,#1
	MOV r5, #3
	MUL r3, r4,r5	;multiple y pos by 3
	LDR r4, ptr_to_x_pos
	LDRB r4, [r4]
	ADD r3,r3,r4	; add x value to y*3

	LDR r5, ptr_to_face_dir
	LDRB r5, [r5]
ABS_LOOP:
 	CMP r5, #0
	BLE EXIT_ABS_LOOP
	BL rot_tile
	SUB r5,r5,#1
	B ABS_LOOP
EXIT_ABS_LOOP:
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;get pylr absB - rotates player backwards amout
;	Take no input
;	Output - r3 - returns a value 1-9 of the player abs position
;----------------------------------------------------------------
get_pylr_absB:
	PUSH {r4-r11,lr}
	LDR r4, ptr_to_y_pos
	LDRB r4, [r4]
	SUB r4,r4,#1
	MOV r5, #3
	MUL r3, r4,r5	;multiple y pos by 3
	LDR r4, ptr_to_x_pos
	LDRB r4, [r4]
	ADD r3,r3,r4	; add x value to y*3

	LDR r5, ptr_to_face_dir
	LDRB r5, [r5]
	CMP r5, #1
	BEQ fix1
	CMP r5 , #3
	BEQ fix2
ABS_LOOP2:
 	CMP r5, #0
	BLE EXIT_ABS_LOOP2
	BL rot_tile
	SUB r5,r5,#1
	B ABS_LOOP2
EXIT_ABS_LOOP2:
	POP {r4-r11,lr}
	MOV pc, lr

fix1:
	MOV r5, #3
	B ABS_LOOP2
fix2:
	MOV r5, #1
	B ABS_LOOP2
;================================================================

;----------------------------------------------------------------
;rot tile - returns in a tile num (1-9) and rot number and
;calculates rotated number
;	input r3 - input tile
;	output r3 - new tile number
;----------------------------------------------------------------
rot_tile:
	PUSH {r4-r11,lr}
	CMP r3,#1
	BEQ rt13
	CMP r3,#2
	BEQ rt26
	CMP r3,#3
	BEQ rt39
	CMP r3,#4
	BEQ rt42
	CMP r3,#5
	BEQ EXIT_ROT_TILE
	CMP r3,#6
	BEQ rt68
	CMP r3,#7
	BEQ rt71
	CMP r3,#8
	BEQ rt84
	CMP r3,#9
	BEQ rt97
	B EXIT_ROT_TILE

rt13:
	MOV r3, #3
	B EXIT_ROT_TILE
rt26:
	MOV r3, #6
	B EXIT_ROT_TILE
rt39:
	MOV r3, #9
	B EXIT_ROT_TILE
rt42:
	MOV r3, #2
	B EXIT_ROT_TILE
rt68:
	MOV r3, #8
	B EXIT_ROT_TILE
rt71:
	MOV r3, #1
	B EXIT_ROT_TILE
rt84:
	MOV r3, #4
	B EXIT_ROT_TILE
rt97:
	MOV r3, #7
EXIT_ROT_TILE:
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;game_reset - Resets the game to the start - presevers time setting
;but generate a new game board and everything else
;	Input - none
;	Output -none
;----------------------------------------------------------------
game_reset:
	PUSH {r4-r11,lr}
	;Reset player states
	LDR r0, ptr_to_face
	MOV r1, #3
	STRB r1, [r0]	;set start face to 3 for defauly - May need to change?
	LDR r0, ptr_to_face_dir
	MOV r1, #0
	STRB r1, [r0]	;set rotation to 0
	LDR r0, ptr_to_game_time
	MOV r1, #0
	STRB r1, [r0]	;Set game time to 0
	LDR r0, ptr_to_x_pos
	MOV r1, #2
	STRB r1, [r0]	;Set x to 2 mid tile
	LDR r0, ptr_to_y_pos
	MOV r1, #2
	STRB r1, [r0]	;Set y to 2 mid tile

	;generate a new game boards - get Thomas to add here
	BL Generate
	;make sure that player tile value gets updated

	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;get_game_mode_str - returns a string of the selected game mode
;	Input - none
;	Output - r0 - pointer to address of string storing the game mode
;----------------------------------------------------------------
get_game_mode_str:
	PUSH {r4-r11,lr}
	LDR r0, ptr_to_game_mode
	LDRB r1, [r0]	;game mode value
	CMP r1, #1
	BEQ MODE1
	CMP r1, #2
	BEQ MODE2
	CMP r1, #3
	BEQ MODE3
MODE4:
	LDR r0,ptr_to_mode4_str
	B EXIT_GGMS
MODE1:
	LDR r0,ptr_to_mode1_str
	B EXIT_GGMS
MODE2:
	LDR r0,ptr_to_mode2_str
	B EXIT_GGMS
MODE3:
	LDR r0,ptr_to_mode3_str
EXIT_GGMS:
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;get_game_mode_val - returns the value of the selected game mode
;	Input - none
;	Output - r0 - pointer to address of string storing the game mode
;----------------------------------------------------------------
get_game_mode_val:
	PUSH {r4-r11,lr}
	LDR r0, ptr_to_game_mode
	LDRB r1, [r0]	;game mode value
	CMP r1, #1
	BEQ MODE1V
	CMP r1, #2
	BEQ MODE2V
	CMP r1, #3
	BEQ MODE3V
	LDR r0, ptr_to_mode4_val
	B EXIT_GGMSV
MODE1V:
	LDR r0, ptr_to_mode1_val
	B EXIT_GGMSV
MODE2V:
	LDR r0,ptr_to_mode2_val
	B EXIT_GGMSV
MODE3V:
	LDR r0,ptr_to_mode3_val
EXIT_GGMSV:
	LDRB r0,[r0]
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================



;----------------------------------------------------------------
;set_game_mode - function description
;	Input - r0 - value for game mode - eg, 100, 200, 300, 400, 0
;----------------------------------------------------------------
;set_game_mode:;
;	PUSH {r4-r11,lr}
;	LDR r1, ptr_to_game_mode
;	STR r0, [r1]
;	POP {r4-r12,lr}
;	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;get_game_data - returns the game info so that it can be used
;to render the game screen
;	No input
;	Output:
;			r0 - game mode
;			r1 - game time
;			r2 - score
;----------------------------------------------------------------
get_game_data:
	PUSH {r4-r11,lr}
	BL get_game_mode_str
	LDR r1, ptr_to_game_time
	LDR r1, [r1]
	LDR r2, ptr_to_score
	LDR r2, [r2]
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;get_plyr_data - returns the player info so that it can be used
;to render the game screen
;	No input
;	Output:
;			r0 - face (1-6)
;			r1 - face direction (0-3)
;			r2 - tile being hled byte
;			r3 - player postion - num 1-9
;----------------------------------------------------------------
get_plyr_data:
	PUSH {r4-r11,lr}
	LDR r0, ptr_to_face
	LDRB r0, [r0]
	LDR r1, ptr_to_face_dir
	LDRB r1, [r1]
	LDR r2, ptr_to_tile_held
	LDRB r2, [r2]
	MOV r5, #3
	LDR r4, ptr_to_y_pos
	LDRB r4, [r4]
	SUB r4,r4,#1
	MOV r5, #3
	MUL r3, r4,r5	;multiple y pos by 3
	LDR r5, ptr_to_x_pos
	LDRB r5,[r5]
	ADD r3,r3,r5;Player tile number
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;pick_up - Player picks up tile
;Takes no inputs and has no output
;Updates the cube memory and the player memory to swap the tiles
;----------------------------------------------------------------
pick_up:
	PUSH {r4-r11,lr}



	POP {r4-r11,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;plyr_mov - Moves the player
;	Input - r0 direction player: up down (-1)| left right (1)
;		  - r1 value (-1 or 1)
;----------------------------------------------------------------
plyr_mov:
	PUSH {r4-r11,lr}
	;check if move x or y
	CMP r0, #0
	BLT MOVE_Y
MOVE_X:
	LDR r4, ptr_to_x_pos
	LDRB r0, [r4]
	ADD r0,r0,r1
	;check if new value is valid (1-3)
	CMP r0,#0
	BLE ROTATE_LEFT
	CMP r0,#4
	BGE ROTATE_RIGHT
	;check if tile would be same colour as players colour
	LDR r6, ptr_to_tile_held
	LDRB r6, [r6] ;players colour
	LDR r4, ptr_to_y_pos
	LDRB r4, [r4]
	SUB r4,r4,#1
	MOV r5, #3
	MUL r3, r4,r5	;multiple y pos by 3
	ADD r3,r0,r3;Player tile number
	SUB r3,r3,#1
	MOV r7, r0	;save r0
	BL get_rotated_face	;r0 have string ptr to rotated tile face
	LDRB r5,[r0,r3]
	CMP r5,r6
	BEQ	EXIT_PLYR_MOVE		;if values are eqaul don;t move their
SAVE_X:
	;new value is valid - save and exit
	LDR r4, ptr_to_x_pos
	STRB r7,[r4]
	B EXIT_PLYR_MOVE

MOVE_Y:
	LDR r4, ptr_to_y_pos
	LDRB r0, [r4]
	ADD r0,r0,r1
	;check if new value is valid (1-3)
	CMP r0,#0
	BLE ROTATE_UP
	CMP r0,#4
	BGE ROTATE_DOWN
	;check if tile would be same colour as players colour
	LDR r6, ptr_to_tile_held
	LDRB r6, [r6] ;players colour
	SUB r4,r0,#1	;new y pos
	MOV r5, #3
	MUL r3, r4,r5	;multiple y pos by 3
	LDR r4, ptr_to_x_pos
	LDRB r4, [r4]
	ADD r3,r3,r4	;New Player tile number
	SUB r3,r3,#1
	MOV r7, r0 	;save r0
	BL get_rotated_face	;r0 have string ptr to rotated tile face
	LDRB r5,[r0,r3]
	CMP r5,r6
	BEQ	EXIT_PLYR_MOVE		;if values are eqaul don;t move their
SAVE_Y:
	;new value is valid - save and exit
	LDR r4, ptr_to_y_pos
	STRB r7,[r4]
	B EXIT_PLYR_MOVE

	;Load the direction of the roation
	;pre-pare to update players address value - but only do after setting up rotation animation, otherwise might result in glitch where plyaer jumps acroos board before the rotation happneds
ROTATE_UP:
	;apply rotation tracker and reset it
	MOV r1, #0
	LDR r11, ptr_to_y_pos
	MOV r9, #3
	LDR r10,  ptr_to_x_pos	;new x
	LDRB r10, [r10]
	MOV r12, #3		;new Y
	B ROTATE_HANDLER
ROTATE_RIGHT:
	;update rotation tracker
	MOV r1, #3
	LDR r11, ptr_to_x_pos
	MOV r9, #1
	MOV r10,#1		;new x
	LDR r12, ptr_to_y_pos		;new Y
	LDRB r12,[r12]
	B ROTATE_HANDLER
ROTATE_DOWN:
	;update rotation tracker
	MOV r1, #2
	LDR r11, ptr_to_y_pos
	MOV r9, #1
	LDR r10,  ptr_to_x_pos	;new x
	LDRB r10, [r10]
	MOV r12, #1		;new Y
	B ROTATE_HANDLER
ROTATE_LEFT:
	MOV r1, #1
	LDR r11, ptr_to_x_pos
	MOV r9, #3
	MOV r10,#3		;new x
	LDR r12, ptr_to_y_pos		;new Y
	LDRB r12,[r12]
	B ROTATE_HANDLER
ROTATE_HANDLER:
	;NOTE _ DO NOT TOUCH R11 OR R9 OR SOMEBODY"S GONNA LOOSE FINGERS!
	;We have our current rotation value
	LDR r4, ptr_to_face
	LDRB r4, [r4]		;side of face we are currently on
	LDR r5, ptr_to_face_dir
	LDRB r5, [r5]		;our current rotation value
	MOV r6,r1 			;direction we're moving in the cube


	MOV r0,r4
	MOV r1,r5
	MOV r2,r6
	BL	get_adj_face	;get the new rotaion and face side we are moving to
	MOV r7,r0			;new face number
	MOV r8,r1			;new rotation on the new face

	;TODO
	;check if move will cuase the player to step on their own colour, if so don't move
	;get the value of the tile the player will step on

	;convert the new X and Y to tile number relative to new rotated value
	;r10 - new x r12 - new y
	MOV r0,#3
	SUB r12,r12,#1
	MUL r3, r12,r0	;multiple y pos by 3
	ADD r3,r3,r10	; add x value to y*3

	MOV r10,r8
	CMP r10,#1
	BEQ ROTBACK1
	CMP r10,#3
	BEQ ROTBACK2
	B MOVCONT
ROTBACK1:
	MOV r10,#3
		B MOVCONT
ROTBACK2:
	MOV r10,#1

MOVCONT:
	MOV r0,r3
	MOV r12,r3
MOV_LOOP:
	CMP r10, #0
	BLE EXIT_MOV_LOOP
	BL rot_tile
	SUB r10,r10,#1
	B MOV_LOOP
EXIT_MOV_LOOP:
	MOV r0,r3
	;r0 - is now the correct tile number ofr the face
	MOV r1,r0
	MOV r0,r7
	BL get_tile	;r0 - face number - r1 tile number

	LDR r1, ptr_to_tile_held
	LDRB r1,[r1]	;Players current tile value
	CMP r0,r1
	BEQ EXIT_PLYR_MOVE

	;TODO
	;BL rotation_setup
	;TODO

	;update players postion, face value, and rotation number at the last second
	LDR r0, ptr_to_face
	STRB r7, [r0]
	LDR r0, ptr_to_face_dir
	STRB r8, [r0]
	STRB r9, [r11]
EXIT_PLYR_MOVE:
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;game_Time_Score -> this is a simple function that is meant to give me access to the score and timer
;					INPUT: NONE
;					OUTPUT: r0- game_time address
;							r1- score address
;							r2- player color address
;
;----------------------------------------------------------------
game_Time_Score:
	PUSH {r4-r11,lr}
	
	LDR r0, ptr_to_game_time
	LDR r1, ptr_to_score
	LDR r2, ptr_to_tile_held
	
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;set_game_mode - takes in value 1-4 in r0 and updates game timer
;----------------------------------------------------------------
set_game_mode:
	PUSH {r4-r11,lr}

	LDR r1, ptr_to_game_mode
	STRB r0, [r1]

	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
