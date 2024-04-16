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


block_generation:		   ;1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;UP_1
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Bottom_2
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Front_3
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Back_4
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Left_5
					.string 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00;Right_6
					.string 0x0 ;This is a finaly NULL incase we wanted it
					;it will store the number of the color 1-6 Green, Yellow, Blue, Pink, Turquoise, White
	.text

;POINTERS TO DATA
;================================================================
ptr_to_Direction_Cube:					.word Direction_Cube
ptr_to_Face_generation:					.word Face_generation
ptr_to_Color_Used:						.word Color_Used
ptr_to_block_generation:				.word block_generation



;LIST OF SUBROUTINES
;================================================================

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global div_and_mod

;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;get tile - returns the value of tile
;	Input:
;		r0 - face number
;		r1 - tile number
;		r2 - rotation
;	Output:
;		r0 - value of tile colour
;----------------------------------------------------------------
get_tile:
	PUSH {r0-r11,lr}
	LDR r4, ptr_to_block_generation
	MOV r6, #9						;constat 9
	MUL r5,r6,r0					;mul 9 by face number ;r5 offset value
	ADD r5, r6, r1					;add tile number to offset
	SUB r5,r5,#9					;sub 9 from offset
	LDRB r0, [r4,r5]				;load tile value
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;set tile - updates the value of a tile
;	Input:
;		r0 - face number
;		r1 - tile number
;		r2 - rotation
;		r3 - new tile colour
;	Output:	no output
;----------------------------------------------------------------
set_tile:
	PUSH {r0-r11,lr}
	LDR r4, ptr_to_block_generation
	MOV r6, #9						;constat 9
	MUL r5,r6,r0					;mul 9 by face number ;r5 offset value
	ADD r5, r6, r1					;add tile number to offset
	SUB r5,r5,#9					;sub 9 from offset
	STRB r2, [r4,r5]				;store new value
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;Generate - Reads the clock to generate color, face, player start color, all use MOD 6
;INPUT: NONE
;OUTPUT: NONE-> but edits a lot of memory that is set above
;USES: r7 -> number of tile on, r6-> number of face on
;----------------------------------------------------------------
	PUSH {r4-r12,lr}

	;MOV r7, #1			;#tiles per faces
	MOV r6, #1			;#faces

BIG_GEN:
	BL load_face

	;Once all faces are full pick a color for the player to start on


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

	;initializing the value so we can coundown and keep track

LOADING_face_LOOP:
	;doing a check to see if we can finish
	MOV r7, #1						;#tiles per faces
	CMP r6, #6
	BEQ load_face_FINISH

	;if there is a face left to fill keep going
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
	LDRB r5, [r2]						;This will start us off in block 1 tile 1

	MOV r2, r6							;puts the number of face into r2
	MOV r9, #0x0						;Once this one get's to 9 the face is all done

face_load_LOOP:
	CMP r2, #1							;checks to see if we have decremented to the beggining
	BEQ tile_load_LOOP

	;if Not down to one, degrement the counter and increment the memory
	SUB r2, r2, #1						;This is the counter to get us to the correct face
	ADD r5, r5, #9 						;This will take up to the next face to work on
	B face_load_LOOP

	;create a loop that will take you to the cube tile and set that to r4
tile_load_LOOP:
	CMP r9, #0x9
	ITTE EQ
	MOVEQ r9, #0xFF						;this will be our ending flag
	ADDNE r9, r9, #1
		;Generate a color for the tile
Random_GEN_JUMP:
	BL Random_Gen
		;store that color in mem
	LDR r3, ptr_to_Color_Used
Verify_tile_color:
	;once we have the value in r1 we need to make sure we have a space for that
	;if
	CMP r1, #0							;This will tell us if we are in need of switching colors that we check
	BEQ Verify_Finish
	;if not
	SUB r1, r1, #1
	ADD r3, r3, #1						;Change to incoming color
	B Verify_tile _color

Verify_Finish:
	LDRB r8, [r3]
	CMP r8, #9
	BEQ Random_GEN_JUMP

	BGT Verify_Finish					;forced into infinite loop if it can't resolve it's color

Set_Value:
	;convert the color into a number for you to correctly store!!!!
	STRB r1, [r5]
	;make sure we still need to loop
	CMP r9, #0x9
	ADD r5, r5, #1
	BLT tile_load_LOOP:

tile_load_FINISH						;The entire face we are on should be complete


	POP {r4-r12,lr} ;ASK the TA's and look at the notes if we can replce the lr with the pc like we learned in class
	MOV pc, lr

;================================================================

;----------------------------------------------------------------
;Random_Gen - reads the clock value and generates a number 1-6
;Returns: 1-6 in r1
;USES: r6-> number of faces left,
;	   r5-> memory address of the face we are on, r4->memory adress of what tile we are on in respect to face
;	   r3-> the color of the tile, r2/r9-> is used for fast computations or load/storing
;----------------------------------------------------------------
Random_Gen:
	PUSH {r4-r12,lr}

	MOV r0,  #0x0050
	MOVT r0, #0x4003	;this is the memory address of the clock value at any point in time     ;divided
	MOV r1, #6																					;divisor

	BL div_and_mod		;return a number 0-5 in r1
	;ADD r1, r1, #1		;This is adjusting out value to be 1-6

	POP {r4-r12,lr}
	MOV pc, lr

;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
