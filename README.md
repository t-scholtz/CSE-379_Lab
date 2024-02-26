# CSE 379 Lab Projects

## Description
Tim and Thomas's 379 Lab Project

## Table of Contents

1. [TODO](#todo)
2. [Lab 3](#lab-3)
3. [Lab 4](#lab-4)
    - [Gpio Setup](#gpio-setup)
4. [Libary](#libary)

## TODO
### PortINIT
A function is given a number 1-5(A->F) in r0
The function returns the address of the PORT we want in r1

### ColorPrompt
prints the prompt and reads the string until it gets input from the user
The sub-routine will return the string address in r1


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


