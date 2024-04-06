	.data

;PROGRAM DATA
;================================================================
startCount:			.byte 0x10
start_up:			.string "Lab 7 - Tim and Tom",0

pause_menu:			.string 0x82,0x83,0x89 , "**************************************",0x82,0x80,0x6,0x6,"Paused",0x80,0x0,0x12 ,0x89 , "**************************************",0

logo_pos:			.string 27,"[10;10H"
logo:				.string 27,"[101m   ",27,"[0m|",27,"[102m   ",27,"[0m|" ,27,"[103m   ",0
					.string 27,"[0m|",0
					.string 27,"[104m   ",27,"[0m|",27,"[105m   ",27,"[0m|" ,27,"[106m   ",0

square:				.string "   ", 27, "[1B",27, "[3D   ",27, "[1B",27, "[3D   ",0x80, 0

temp:				.string "blank Space",0
	.text

;POINTERS TO DATA
;================================================================
ptr_to_startCount:		.word startCount
ptr_to_logo_pos:		.word logo_pos
ptr_to_logo:			.word logo
ptr_to_start_up:		.word start_up
ptr_to_pause_menu:		.word pause_menu

ptr_to_square:			.word square
ptr_to_temp:			.word temp

;LIST OF SUBROUTINES
;================================================================
	.global startCount
	.global print_face
	.global print_sqr
	.global start_up_anim
	.global print_menu
	.global print_game
	.global print_pause

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global change_state
	.global ansi_print
	.global output_character
	.global int2string
	.global output_string

;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;start_up_anim - prints a startup animation and then changes game
;	state to 1
;----------------------------------------------------------------
start_up_anim:
	PUSH {r4-r12,lr}
	LDR r0, ptr_to_start_up
	BL ansi_print
	LDR r0, ptr_to_startCount
	LDRB r1, [r0]
	SUB r1,r1,#1
	STRB r1,[r0]
	CMP r1, #0
	BGT END_STARTUP
	MOV r0, #0
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

	BL print_face_helper
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_game - prints game board + player + handles transistions
;----------------------------------------------------------------
print_game:
	PUSH {r4-r12,lr}
	LDR r0, ptr_to_temp
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

	BL print_face_helper
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
PFH_LOOP_I:
	MOV r6, #0	;r6 = j = 0
	ADD r5, r5, #1	;i++
	CMP r5, #3
	BGT PFH_EXITLOOP
PFH_LOOP_J:
	ADD r6, r6, #1	;j++
	MOV r1, #0		;x pos for sqaure - reset value
	MOV r8, #4		;storing constant for multipication[4 because square is 3x3 with extra layer between
	MUL r1, r6, r8	;how many blocks right is this square
	ADD r1, r1, #5	;constant offest for position sqare
	MUL r2, r5, r8	;how many blocks right is this square
	ADD r2, r2, #20	;constant offest for position sqare
	LDRB r0,[r4],#1	;load byte colour to be printed
	BL print_sqr	;print sqr to screen
	CMP r6, #3
	BGE PFH_LOOP_I
	B PFH_LOOP_J
PFH_EXITLOOP:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;print_sqr - prints a 3x3 square - colour must be between 101-107
;	input r0 - colour
;		  r1 - x pos
;		  r2 - y pos
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
