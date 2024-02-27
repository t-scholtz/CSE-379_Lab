# CSE 379 Lab Projects

## Description
Tim and Thomas's 379 collection of lab projects plus ongoing libary of functions

## Table of Contents

1. [TODO](#todo)
2. [Lab 3](#lab-3)
3. [Lab 4](#lab-4)
    - [Gpio Setup](#gpio-setup)
4. [Libary](#libary)
    - [Div and Mod](#div-and-mod)
    - [Read String](#read-string)
    - [Output_String](#output-string)
    - [Int 2 String](#int2string)
    - [String 2 Int](#string-2-int)

## TODO
### PortINIT
A function is given a number 1-5(A->F) in r0
The function returns the address of the PORT we want in r1

### ColorPrompt
prints the prompt and reads the string until it gets input from the user
The sub-routine will return the string address in r1

### ERRORFOUND
simple subroutine that will let us know when there is an error found in our code by using an infinite loop
//think about outputting X to the terminal repeatedly so we know as well.


## Lab 3

## Lab 4

### Gpio Setup
gpio_setup - Allows you top setup a connection to ports.

Input:  
* r0 - port (A-F|0-5)
* r1 - port memory address
* r2 - set pins as read or write (8bit input)[0-read 1-write]
* r3 - set which pins are active (8bit input)[0-off  1-on]

## Libary

### Div and Mod
div_and_mod which accepts two signed integers: a
dividend in r0 and a divsor in r1and an integer returns the quotient in r0 and the remainder in r1. For
example, if 37,192 is passed in r0 and 26 in r1, the subroutine should return 1,430 in r0 and 12 in r1. The
remainder you return should always be positive, but the quotient should be signed. For example, if
292,382,173 is passed in r0 and -1,894 in r1, -154,372 is returned in r0 and 1,605 is returned in r1. You
may assume that all integers passed into the routine in r1 will be nonzero integers. 

### Read String
Reads a string entered in PuTTy and stores it as a null-terminated string in memory.
The user terminates the string by hitting Enter. The base address of the string should be passed
into the routine in r0. The carriage return should NOT be stored in the string

### Output String
Displays a null-terminated string in PuTTy. The base address of the string should be
passed into the routine in r0

### Int 2 String
Stores the integer passed into the routine in r1 as a NULL terminated ASCII string in memory
at the address passed into the routine in r0.

### String 2 Int
Converts the NULL terminated ASCII string pointed to by the address passed into the routine in
r0 to an integer. The integer should be returned in r0. The string should not be modified by the routine.
