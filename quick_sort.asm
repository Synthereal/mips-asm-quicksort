# Garrett Lo, Darshil Sheth, Diego Perez-Carlos, Cathy Ko
# CS 2640 Final Project
# Quick Sort Algorithm


# macros
.macro printString(%str)
    li $v0, 4
    la $a0, %str
    syscall
.end_macro

.macro printArray(%array, %length)
	la $s0, %array # load base address of array to $s0
	li $t1, %length # set loop counter to length
	
	loop:
		lw $t0, 0($s0) # load current array element
		li $v0, 1
		move $a0, $t0 # move array element to $a0
		syscall # print element

		li $v0, 4
		la $a0, space # print a space
		syscall

		addi $s0, $s0, 4 # move to the next element in the array
		addi $t1, $t1, -1 # decrease loop counter
		bnez $t1, loop # branch back to loop start if value is not 0
.end_macro

.macro exit
	li $v0, 10 # exit program
	syscall
.end_macro


# variables
.data
array: .word 1, 2, 3, 4, 5
prompt1: .asciiz "Array: "
prompt2: .asciiz "New Array: "
newline: .asciiz "\n"
space: .asciiz " "

newArray: .space 20


# defines start of program
.text
main:

	# print initial array
	printString(prompt1)
	printArray(array, 5)
	printString(newline)
	
	# quick sort shenanigans
	# quickSort(array)
	
	# print sorted array
	printString(prompt2)
	printArray(array, 5)
	printString(newline)
	
	# exit the program
	exit
