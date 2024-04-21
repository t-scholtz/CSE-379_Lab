
	.data

;PROGRAM DATA
;================================================================
helloworld:		.string 0x82,0x83,0x86,"H",0x87,"E",0x88,"L",0x89
				.string "L",0x8A,"O ",0x8B,"WOR",0x8C,"LD",0x82,0x0D, 0x0A , 0x00 ;This is a test string which tests colour + screen clear + sylte reset
nrm:			.string "n T",0x81,0x5,0x5,"this will move the cursor",0x80,0x5,0x5," last bit of text", 0x82, 0
test_face:		.string 101,102,103,104,105,106,105,104,103,0
	.text

;POINTERS TO DATA
;================================================================
ptr_to_helloworld:		.word helloworld
ptr_to_nrm:				.word nrm
ptr_to_test_face:		.word test_face

;LIST OF SUBROUTINES
;================================================================
	.global lab7

;IMPORTED SUB_ROUTINES
;_______________________________________________________________
	.global uart_init
	.global uart_interrupt_init
	.global gpio_btn_and_LED_init
	.global gpio_interrupt_init
	.global timer_init
	;IMPORTED FOR TESTING, CAN DELETE LATER
	.global ansi_print
	.global print_sqr
	.global print_face
	.global print_plyr
	.global div_and_mod

;LIST OF CONSTANTS
;================================================================



;CODE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;----------------------------------------------------------------
;LAB 7 MAIN
;----------------------------------------------------------------
lab7:
	PUSH {r4-r12,lr}
	;run all connection code
	bl init_all

	;Maybe run some tests before game start


	;TEST CODE - CAN DELETE
	LDR r0, ptr_to_helloworld
	bl ansi_print
	LDR r0, ptr_to_nrm
	bl ansi_print

	LDR r0, ptr_to_test_face
	MOV r1, #0
	BL print_face


	MOV r0, #100
	MOV r1, #5
	MOV r2, #5
	BL print_plyr

	LDR r0, ptr_to_test_face
	MOV r1, #2
	BL print_face

	mov r0,#8				;move tile number to r0
	mov r1,#3
	BL div_and_mod			;div mod by 3| quotient in r0 | the remainder in r1|
	ADD r0,r0,#1
	ADD r1, r1,#1
	MOV r2, #10
	MUL r2, r1 	,r2			; x pos - mul by space and add constant offset
	ADD r2, r2 ,#18

	MOV r5, #4
	MUL r3, r0 ,r5			; x pos - mul by space and add constant offset
	ADD r3, r3, #10

	MOV r0, #102
	MOV r1,r3
	BL print_plyr	;print the player

	mov r0,#7				;move tile number to r0
	mov r1,#3
	BL div_and_mod			;div mod by 3| quotient in r0 | the remainder in r1|
	ADD r0,r0,#1
	ADD r1, r1,#1
	MOV r2, #10
	MUL r2, r1 	,r2			; x pos - mul by space and add constant offset
	ADD r2, r2 ,#20

	MOV r5, #4
	MUL r3, r0 ,r5			; x pos - mul by space and add constant offset
	ADD r3, r3, #10

	MOV r0, #102
	MOV r1,r3
	BL print_plyr	;print the player

	mov r0,#6				;move tile number to r0
	mov r1,#3
	BL div_and_mod			;div mod by 3| quotient in r0 | the remainder in r1|
	ADD r0,r0,#1
	ADD r1, r1,#1
	MOV r2, #10
	MUL r2, r1 	,r2			; x pos - mul by space and add constant offset
	ADD r2, r2 ,#20

	MOV r5, #4
	MUL r3, r0 ,r5			; x pos - mul by space and add constant offset
	ADD r3, r3, #10

	MOV r0, #102
	MOV r1,r3
	BL print_plyr	;print the player

	mov r0,#5				;move tile number to r0
	mov r1,#3
	BL div_and_mod			;div mod by 3| quotient in r0 | the remainder in r1|
	ADD r0,r0,#1
	ADD r1, r1,#1
	MOV r2, #10
	MUL r2, r1 	,r2			; x pos - mul by space and add constant offset
	ADD r2, r2 ,#20

	MOV r5, #4
	MUL r3, r0 ,r5			; x pos - mul by space and add constant offset
	ADD r3, r3, #10

	MOV r0, #102
	MOV r1,r3
	BL print_plyr	;print the player




	LDR r0, ptr_to_test_face
	MOV r1, #3
	BL print_face
	mov r5,#0

	mov r0,#8				;move tile number to r0
	mov r1,#3
	BL div_and_mod			;div mod by 3| quotient in r0 | the remainder in r1|


	MOV r2, #9
	MUL r2, r0 	,r2			; x pos - mul by space and add constant offset
	ADD r2, r2 ,#20

	MOV r5, #4
	MUL r3, r1 ,r5			; x pos - mul by space and add constant offset
	ADD r3, r3, #10

	MOV r0, #102
	MOV r1,r3
	BL print_plyr	;print the player

	LDR r0, ptr_to_test_face
	MOV r1, #1
	BL print_face
	mov r5,#0

	LDR r0, ptr_to_test_face
	MOV r1, #1
	BL print_face
	mov r5,#0

LOOP:
	MOV r0, #0x48
	MOVT r0, #0x4003
	LDR r1,[r0]
	B LOOP


	;Exit routine
END_PROGRAM:
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

;----------------------------------------------------------------
;init_all - initialse all hardware, uart, and timer functionality
;----------------------------------------------------------------
init_all:
	PUSH {r4-r12,lr}
	bl uart_init
	bl uart_interrupt_init
	bl gpio_btn_and_LED_init
	bl gpio_interrupt_init
	;Choose timer peroid
	MOV r0,#0x1200
	MOVT r0, #0x007A
	bl timer_init
	POP {r4-r12,lr}
	MOV pc, lr
;================================================================

	.end
	;Exit
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
