	.data

;PROGRAM DATA
;================================================================
face:		.byte 0x03	;tile the player is currently on
face_dir:	.byte 0x00	;how many times rotated left (0-3)
tile_held:	.byte 0x00	;the colour of the tile the player is holding
x_pos:		.byte 0x02	;players x location
y_pos:		.byte 0x02	;players y location



	.text

;POINTERS TO DATA
;================================================================
ptr_to_face:		.word face
ptr_to_tile_held:	.word tile_held
ptr_to_x_pos:		.word x_pos
ptr_to_y_pos:		.word y_pos


;LIST OF SUBROUTINES
;================================================================
	.global pick_up
	.global plyr_mov

;IMPORTED SUB_ROUTINES
;_______________________________________________________________




;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;function template - function description
;----------------------------------------------------------------

;----------------------------------------------------------------
;pick_up - Player picks up tile
;Takes no inputs and has no output
;Updates the cube memory and the player memory to swap the tiles
;----------------------------------------------------------------
pick_up:
	PUSH {r0-r11,lr}



	POP {r4-r12,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;plyr_mov - Moves the player
;	Input - r0 direction player: 1-up | 2-left | 3-down | 4-right
;----------------------------------------------------------------
plyr_mov:
	PUSH {r0-r11,lr}

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
