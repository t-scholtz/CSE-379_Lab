	.data

;PROGRAM DATA
;================================================================
startCount:			.byte 0x10

logo_pos:			.string 27,"[10;10H"
logo:				.string 27,"[101m   ",27,"[0m|",27,"[102m   ",27,"[0m|" ,27,"[103m   ",0
					.string 27,"[0m|",0
					.string 27,"[104m   ",27,"[0m|",27,"[105m   ",27,"[0m|" ,27,"[106m   ",0

square:				.string "   ", 27, "[3B",27, "[3D   ",27, "[3B",27, "[3D   ",80,81, 0

temp:				.string "blank Space",0
	.text

;POINTERS TO DATA
;================================================================
ptr_to_startCount:		.word startCount
ptr_to_logo_pos:		.word logo_pos
ptr_to_logo:			.word logo


ptr_to_square:			.word square
ptr_to_temp:			.word temp

;LIST OF SUBROUTINES
;================================================================
	.global startCount

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global change_state
	.global ansi_print


;LIST OF CONSTANTS
;================================================================

;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;start_up_anim - plays a strart up animation
;----------------------------------------------------------------
start_up_anim:
	PUSH {r4-r12,lr}
	LDR r0, ptr_to_startCount
	LDRB r1, [r0]
	SUB r1,r1,#1
	STRB r1,[r0]
	CMP r1, #0
	BGT BEGGING_ANIM
	MOV r0,#1
	BL change_state
	B EXIT_SRT_UP
BEGGING_ANIM:



EXIT_SRT_UP:
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
	MOV r8,r0 				;save colour value

	MOV r0, #27
	BL output_character
	MOV r0, #91
	BL output_character		;print ESC[

	LDR r0, ptr_to_temp
	BL int2String
	LDR r0, ptr_to_temp
	BL output_string		;print num down

	MOV r0, #59
	BL output_character		;print ;

	LDR r0, ptr_to_temp
	MOV r1,r2
	BL int2String
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
	BL int2String
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
