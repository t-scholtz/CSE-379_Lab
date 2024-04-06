
	.data

;PROGRAM DATA
;================================================================
helloworld:		.string 0x82,0x83,0x86,"H",0x87,"E",0x88,"L",0x89
				.string "L",0x8A,"O ",0x8B,"WOR",0x8C,"LD",0x82,0x0D, 0x0A , 0x00 ;This is a test string which tests colour + screen clear + sylte reset
nrm:			.string "n T",0x81,0x5,0x5,"this will move the cursor",0x80,0x5,0x5,0
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
	;
	MOV r0, #101
	MOV r1, #10
	MOV r2, #10
	BL print_sqr
	LDR r0, ptr_to_test_face
	BL print_face

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
