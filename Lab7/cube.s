
	.data

;PROGRAM DATA
;================================================================
;We will have 4 bytes, up, left, down, right

Direction_Cube:
					.string 0x4,0x5,0x3,0x6;UP_1
					.string 0x3,0x5,0x2,0x6;Bottom_2
					.string 0x1,0x5,0x2,0x3;Front_3
					.string 0x2,0x5,0x1,0x6;Back_4
					.string 0x1,0x4,0x2,0x3;Left_5
					.string 0x1,0x3,0x2,0x4;Right_6

Face_generation:	.string 0x09,0x09,0x09,0x09,0x09,0x09	;This will help us realize if we are using a used face yet
															;how many tiles are left on each face

						   ;Green, Yellow, Blue, Pink, Turquoise, White, we allow this until they have a value of 9
Color_Used:			.string 0x0,   0x0,    0x0,  0x0,  0x0,       0x0


		  				    ;1   ,2   ,3   ,4   ,5   ,6   ,7   ,8   ,9
block_generation:	.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;UP_1
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Bottom_2
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Front_3
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Back_4
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Left_5
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Right_6
					.string 0x0 ;This is a finaly NULL incase we wanted it
					;it will store the number of the color 0-5, 102-107 Green, Yellow, Blue, Pink, Turquoise, White
	.text

;POINTERS TO DATA
;================================================================
ptr_to_Direction_Cube:					.word Direction_Cube
ptr_to_Face_generation:					.word Face_generation
ptr_to_Color_Used:						.word Color_Used
ptr_to_block_generation:				.word block_generation



;LIST OF SUBROUTINES
;================================================================
	.global set_tile
	.global get_tile
	.global get_adj_face
	.global get_face
	.global Generate
	.global CUBE_process


;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global div_and_mod
	.global get_plyr_data

;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;get tile - returns the value of tile
;	Input:
;		r0 - face number
;		r1 - tile number
;	Output:
;		r0 - value of tile colour
;----------------------------------------------------------------
get_tile:
	PUSH {r4-r11,lr}
	LDR r4, ptr_to_block_generation
	MOV r5, #9						;constat 9
	MUL r5,r5,r0					;mul 9 by face number ;r5 offset value
	ADD r5, r5, r1					;add tile number to offset
	SUB r5,r5,#10					;sub 9 from offset
	LDRB r0, [r4,r5]				;load tile value
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;set tile - updates the value of a tile
;	Input:
;		r0 - face number
;		r1 - tile number
;		r3 - new tile colour
;	Output:	no output
;----------------------------------------------------------------
set_tile:
	PUSH {r4-r11,lr}
	LDR r4, ptr_to_block_generation
	MOV r5, #9						;constat 9
	MUL r5,r5,r0					;mul 9 by face number ;r5 offset value
	ADD r5, r5, r1					;add tile number to offset
	SUB r5,r5,#10					;sub 10 from offset
	;SUB r5,r5,#9					;sub 9 from offset
	STRB r3, [r4,r5]				;store new value
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;get  face - returns the face in a direction to current
;face
;	Input:
;		r0 - face number
;	Output:
;		r0 - pointer to face string
;----------------------------------------------------------------
get_face:
	PUSH {r4-r11,lr}
	SUB r0, r0, #1				;sub face number to give range (0-5)
	MOV r2,#9
	MUL r0,r0,r2
	LDR r4, ptr_to_block_generation
	ADD r0, r4,r0
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;get adj face - returns the face in a direction to current
;face
;	Input:
;		r0 - face number
;		r1 - direction
;	Output:
;		r0 - new face number
;----------------------------------------------------------------
get_adj_face:
	PUSH {r4-r11,lr}
	MOV r3, #4					;const value to multiply by
	SUB r0, r0, #1				;sub face number to give range (0-5)
	MUL r0,r0,r3
	ADD r0,r0,r1				;calculate relvant offset
	LDR r4, ptr_to_Direction_Cube
	LDRB r0, [r4,r0]			;load face value byte
	POP {r4-r11,lr}
	MOV pc, lr
;================================================================


;----------------------------------------------------------------
;Generate - Reads the clock to generate color, face, player start color, all use MOD 6
;INPUT: NONE
;OUTPUT: NONE-> but edits a lot of memory that is set above
;USES: r7 -> number of tile on, r6-> number of face on
;----------------------------------------------------------------
Generate:
	PUSH {r4-r12,lr}

;WE NEED TO RESET THE COLOR COUNT HERE TO MAKE SURE THEY ARE ALL SET TO 0 BEFORE GENERATE
	MOV r0, #0
	MOV r3, #0
	LDR r1, ptr_to_Color_Used
COLOR_RESET:
	ADD r0, r0, #1
	;LDR r1, ptr_to_Color_Used
	STRB r3, [r1], #1	;will this add the one after?
	CMP r0, #6
	BEQ BIG_GEN
	B COLOR_RESET		;GO OVER LOGIC WITH TIM+

BIG_GEN:
	BL load_face

;Generate player color
	BL get_plyr_data	;r2 will be our address to the player color
	MOV r4, r2			;r4 will be our address to the player color

	BL Random_Gen		;r1 will have our random color
	ADD r1, r1, #102
	MOV r5, r1			;r5 will now be our player color

	;load in tile at tile 5 face 3
	LDR r1, ptr_to_block_generation
	ADD r1, r1, #18		;move 2 faces down to face 3
	ADD r1, r1, #4		;move 4 tiles to get to tile 5

	LDRB r6, [r1]		;r6 will be starting tile color

	CMP r6, r5			;if equal do this
	IT EQ
	ADDEQ r5, r5, #2

	CMP r5, #107		;if greater than 107 adjust number
	IT EQ
	SUBEQ r5, r5, #4

	STRB r5, [r4]			;changed the player color as needed



	POP {r4-r12,lr}
	MOV pc, lr

;================================================================

;----------------------------------------------------------------
;load_face - keeps looping until it finds availible face, and until all faces are used up
;INPUT: NONE
;OUTPUT: NONE-> but edits a lot of memory that is set above
;USES: r7 -> number of tile on, r6-> number of faces left
;----------------------------------------------------------------
load_face:
	PUSH {r4-r12,lr}
	MOV r6, #0
	;initializing the value so we can coundown and keep track

LOADING_face_LOOP:
	;doing a check to see if we can finish
	CMP r6, #6
	BEQ load_face_FINISH

	;if there is a face left to fill keep going
	MOV r1, r6
	BL load_tiles
	ADD r6, r6, #1					;Once the tiles are loaded we take on face out of the equation

	;Go back to the top until all faces are used
	B LOADING_face_LOOP


load_face_FINISH:

	POP {r4-r12,lr}
	MOV pc, lr

;================================================================

;----------------------------------------------------------------
;load_tiles - loops through the tiles and generates and verify those colors can be used
;INPUT: NONE
;OUTPUT: NONE-> but edits a lot of memory that is set above
;USES:
;	   r5-> memory address of the face we are on, r4->memory adress of what tile we are on in respect to face
;	   r3-> the color of the tile, r2/r9/r6-> is used for fast computations or load/storing
;----------------------------------------------------------------
load_tiles:
	PUSH {r4-r12,lr}
	;loading in what colors are usedvis

	;create a loop that will take you to the cube face and set that to r5
	LDR r2, ptr_to_block_generation
	MOV r5, r2						;This will start us off in block 1 tile 1

	MOV r2, r1							;puts the number of face into r2
	MOV r9, #0x0						;Once this one get's to 9 the tiles is all done

face_load_LOOP:
	CMP r2, #0							;checks to see if we have decremented to the beggining
	BEQ tile_load_LOOP

	;if Not down to one, degrement the counter and increment the memory
	SUB r2, r2, #1						;This is the counter to get us to the correct face
	ADD r5, r5, #9 						;This will take up to the next face to work on
	B face_load_LOOP

	;create a loop that will take you to the cube tile and set that to r4
tile_load_LOOP:
	CMP r9, #0x9
	ITE EQ
	MOVEQ r9, #0xFF						;this will be our ending flag
	ADDNE r9, r9, #1
		;Generate a color for the tile
Random_GEN_JUMP:
	BL Random_Gen
	MOV r7, r1							;storing r1 in r7 temporarly
		;store that color in mem

Verify_Finish:
	LDR r3, ptr_to_Color_Used
	ADD r3, r3, r1
	LDRB r8, [r3]
	CMP r8, #9							;if 9 jump to color switch
	BEQ COLOR_SWITCH
	BGT	Verify_Finish


Set_Value:
	;convert the color into a number for you to correctly store!!!!
	ADD r7, r7, #102
	STRB r7, [r5], #1
	;make sure we still need to loop
	CMP r9, #0x9
	;ADD r9, r9, #1
	BLT tile_load_LOOP

tile_load_FINISH						;The entire face we are on should be complete


	POP {r4-r12,lr} ;ASK the TA's and look at the notes if we can replce the lr with the pc like we learned in class
	MOV pc, lr

COLOR_SWITCH:
	CMP r1, #5			;This representing the last color
	ITE EQ
	MOVEQ r1, #0		;set it to the first color if it's at the last one
	ADDNE r1, r1, #1	;increment color if it's not at the last one
	B Verify_Finish

;================================================================

;----------------------------------------------------------------
;Random_Gen - reads the clock value and generates a number 1-6
;Returns: 0-5 in r1 (ADD 102 to get the value of the color)
;USES: r6-> number of faces left,
;	   r5-> memory address of the face we are on, r4->memory adress of what tile we are on in respect to face
;	   r3-> the color of the tile, r2/r9-> is used for fast computations or load/storing
;----------------------------------------------------------------
Random_Gen:
	PUSH {r4-r12,lr}

	MOV r6,  #0x0050
	MOVT r6, #0x4003
	LDRH r0, [r6]	;this is the memory address of the clock value at any point in time     ;divided
	MOV r1, #6																				;divisor

	BL div_and_mod		;return a number 0-5 in r1
	;ADD r1, r1, #1		;This is adjusting out value to be 1-6

	POP {r4-r12,lr}
	MOV pc, lr

;================================================================

;----------------------------------------------------------------
;CUBE_process - checks cube completness and return a value of 0-5 to show how complete the cube is
; 				r0 will be used as the block address
;  				r1 will be used for the tile check
;				r2 will grab values from r0
;				r3 will be a stagnant register to check the colors from r2 against
;				r4 will be the completed sides
;				r5 will be the tiles that are equal, we want that to be 9 before we add 1 to r4
;				r6 wiil be the face counter
;
;RETURNS 0-5 in r0
;----------------------------------------------------------------
CUBE_process:
	PUSH {r4-r12,lr}
	;CUBE_check:
	;loads up the cube
	LDR r0, ptr_to_block_generation
	;setting the side count to zero
	MOV r4, #0
	;Setting the face count to 6
	MOV r6, #6

CUBE_check:
	CMP r6, #0
	BEQ CUBE_process_FINISH

	;sets up number of times it needs to run which is 8 because we check one first
	MOV r1, #8
	;get the first color of the face
	LDRB r2, [r0], #1
	;sets the first color to a stagnant register
	MOV r3, r2
	;The start of the count
	MOV r5, #1
	;change face count
	SUB r6, r6, #1

ROW_check:
	LDRB r2, [r0], #1
	CMP r2, r3
	ITTE EQ
	ADDEQ r5, r5, #1					;ADD one to the correct counter when the colors are equal
	SUBEQ r1, r1, #1					;DROPS one of our tile count
	MOVNE r1, #0						;stop the count if the colors are not equal

	;Checks if we have one full cube yet
	CMP r5, #9
	IT EQ
	ADDEQ r4, r4, #1

	;Checks if we are done check this face
	CMP r1, #0
	BEQ CUBE_check
	BGT ROW_check

CUBE_process_FINISH:
	MOV r0, r4

	POP {r4-r12,lr}
	MOV pc, lr
;================================================================
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
