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

	.text

;POINTERS TO DATA
;================================================================



;LIST OF SUBROUTINES
;================================================================

;IMPORTED SUB_ROUTINES
;_______________________________________________________________




;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;Generate - Reads the clock to generate color, face, player start color, all use MOD 6
;----------------------------------------------------------------
	PUSH {r4-r12,lr}

	;Make a loop that will load the face/ load tile/ Set tile
	;Once all faces are full pick a color for the player to start on

	POP {r4-r12,lr}
	MOV pc, lr

;================================================================

;----------------------------------------------------------------
;load_face - reads the clock value and generates a face number, keeps looping until it finds availible face
;			 Think about check the total number of tiles made so we can make sure this never infinite loops
;
;----------------------------------------------------------------
	PUSH {r4-r12,lr}

	;Check the number of tiles that has been made so far, if it is less than 54 than this is alowed to run
	;Read the value for the clock, if tiles are availible on that face output int r1 the face using

	POP {r4-r12,lr}
	MOV pc, lr

;================================================================

;----------------------------------------------------------------
;load_tile - reads the clock value and generates a face number, keeps looping until it finds availible face
;			 Think about check the total number of tiles made so we can make sure this never infinite loops
;
;----------------------------------------------------------------
	PUSH {r4-r12,lr}

	;Check the number of tiles that has been made so far, if it is less than 54 than this is alowed to run
	;Read the value for the clock, if tiles are availible on that face output int r1 the face using

	POP {r4-r12,lr}
	MOV pc, lr

;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
