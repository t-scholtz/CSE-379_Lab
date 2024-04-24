	.data

;PROGRAM DATA
;================================================================
face:		.byte 0x03	;tile the player is currently on
face_dir:	.byte 0x01	;how many times rotated left (0-3)
tile_held:	.byte 0x01	;the colour of the tile the player is holding
x_pos:		.byte 0x02	;players x location (1-3)
y_pos:		.byte 0x02	;players y location (1-3)
game_mode:	.byte 0x01 ;Number between 1-4 (1-100| 2-200|3- 300| 4-400
game_time:	.word 0x00000000
score:		.word 0x00000000


mode1_str:	.string "100",0
mode1_val:	.word	0x00000064
mode2_str:	.string	"200",0
mode2_val:	.word	0x000000c8
mode3_str:	.string	"300",0
mode3_val:	.word	0x0000012c
mode4_str:	.string	"Unlimated",0
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

ptr_to_mode1_str:	.word mode1_str
ptr_to_mode1_val:	.word mode1_val
ptr_to_mode2_str:	.word mode2_str
ptr_to_mode2_val:	.word mode2_val
ptr_to_mode3_str:	.word mode3_str
ptr_to_mode3_val:	.word mode3_val
ptr_to_mode4_str:	.word mode4_str
ptr_to_mode5_val:	.word mode4_val

;LIST OF SUBROUTINES
;================================================================
	.global pick_up
	.global plyr_mov
	.global get_game_mode_str
	.global set_game_mode
	.global get_plyr_data
	.global get_game_data
	.global game_reset

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global int2string
	.global get_adj_face
	.global rotation_setup
	.global Generate


;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
;set_game_mode - function description
;	Input - r0 - value for game mode - eg, 100, 200, 300, 400, 0
;----------------------------------------------------------------
set_game_mode:
	PUSH {r4-r11,lr}
	LDR r1, ptr_to_game_mode
	STR r0, [r1]
	POP {r4-r12,lr}
	MOV pc, lr
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
	LDR r0, ptr_to_game_mode
	LDRB r0, [r0]
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
;			r1 - face direction (1-4)
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
	LDR r4, ptr_to_x_pos
	LDRB r4, [r4]
	SUB r4,r4,#1
	MUL r3, r4,r5	;multiple y pos by 3
	LDR r4, ptr_to_y_pos
	LDRB r4, [r4]
	ADD r3,r3,r4	; add x value to y*3
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
	;new value is valid - save and exit
	STRB r0,[r4]
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
	;new value is valid - save and exit
	STRB r0,[r4]
	B EXIT_PLYR_MOVE

	;Load the direction of the roation
	;pre-pare to update players address value - but only do after setting up rotation animation, otherwise might result in glitch where plyaer jumps acroos board before the rotation happneds
ROTATE_UP:
	MOV r1, #0
	LDR r8, ptr_to_x_pos
	MOV r9, #3
	B ROTATE_HANDLER
ROTATE_RIGHT:
	MOV r1, #0
	LDR r8, ptr_to_y_pos
	MOV r9, #1
	B ROTATE_HANDLER
ROTATE_DOWN:
	MOV r1, #0
	LDR r8, ptr_to_x_pos
	MOV r9, #1
	B ROTATE_HANDLER
ROTATE_LEFT:
	MOV r1, #0
	LDR r8, ptr_to_y_pos
	MOV r9, #3
	B ROTATE_HANDLER
ROTATE_HANDLER:
	LDR r0, ptr_to_face
	LDRB r0, [r0]
	MOV r5,r0			;save a copy of the face value for later in r5
	MOV r6, r1			;save copy dir
	BL	get_adj_face 	;get the value of the face we are rotating to
;		r0 - starting face value
;		r1 - landing face value
;		r2 - direction of transition
	MOV r1, r0
	MOV r0, r5
	MOV r2, r6
	BL rotation_setup

	;update players postion and face value number at last second
	LDR r6, ptr_to_face
	STRB r9, [r8]
	STRB r7, [r6]
EXIT_PLYR_MOVE:
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
