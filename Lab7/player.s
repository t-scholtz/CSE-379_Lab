	.data

;PROGRAM DATA
;================================================================
face:		.byte 0x03	;tile the player is currently on
face_dir:	.byte 0x00	;how many times rotated left (0-3)
tile_held:	.byte 0x00	;the colour of the tile the player is holding
x_pos:		.byte 0x02	;players x location (0-2)
y_pos:		.byte 0x02	;players y location (0-2)
game_mode:	.word 0x00000064 ;If 0 or neg, will take to be unlimated
game_time:	.word 0x00000000

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



;LIST OF SUBROUTINES
;================================================================
	.global pick_up
	.global plyr_mov
	.global get_game_mode_str
	.global set_game_mode
	.global get_plyr_data

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global int2string


;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;get_game_mode_str - returns a string of the selected game mode
;	Input - none
;	Output - r0 - pointer to address of string storing the game mode
;----------------------------------------------------------------
get_game_mode_str:
	PUSH {r4-r11,lr}
	LDR r0, ptr_to_game_mode
	LDR r1, [r0]
	CMP r1, #0		;If 0 or neg, will take to be unlimated
	BLE UNLIMATED
	LDR r0, ptr_to_temp
	BL int2string
	LDR r0, ptr_to_temp
	B EXIT_GGMS
UNLIMATED:
	;LDR r0, ptr_to_unlimated
EXIT_GGMS:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;set_game_mode - function description
;	Input - r0 - value for game mode - eg, 100, 200, 300, 400, 0
;----------------------------------------------------------------
	PUSH {r4-r11,lr}
	LDR r1, ptr_to_game_mode
	STR r0, [r1]
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;get_plyr_data - returns the player info so that it can be used
;to render the game screen
;	No input
;	Output:
;			r0 - face
;			r1 - face direction
;			r2 - tile being hled
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
	MUL r3, r4,r5	;multiple y pos by 3
	LDR r4, ptr_to_x_pos
	LDR r4, [r4]
	ADD r3,r3,r4	; add x value to y*3
	POP {r4-r12,lr}
	MOV pc, lr
;----------------------------------------------------------------
;pick_up - Player picks up tile
;Takes no inputs and has no output
;Updates the cube memory and the player memory to swap the tiles
;----------------------------------------------------------------
pick_up:
	PUSH {r4-r11,lr}



	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;plyr_mov - Moves the player
;	Input - r0 direction player: 1-up | 2-left | 3-down | 4-right
;----------------------------------------------------------------
plyr_mov:
	PUSH {r4-r11,lr}

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
