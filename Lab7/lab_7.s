
	.data

;PROGRAM DATA
;================================================================

	.text

;POINTERS TO DATA
;================================================================

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
