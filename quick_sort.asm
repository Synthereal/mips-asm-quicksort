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
		
	printString(newline)
.end_macro

.macro exit
	li $v0, 10 # exit program
	syscall
.end_macro


# variables
.data

# test arrays
array1: .word 12, 5, 17, 9, 4, 20, 8, 15, 3, 11	# len 10, all unique values
array2: .word 25, 18, 7, 14, 10, 18, 22, 13, 2, 9	# len 10, contains repeated values
array3: .word 30, 8, 19, 4, 13, 27, 16, 9, 22, 13, 8, 19, 3	# len 13, contains repeated values

prompt1: .asciiz "array1: "
prompt2: .asciiz "array2: "
prompt3: .asciiz "array3: "
promptSorted: .asciiz "sorted: "
programComplete: .asciiz "Program complete."
newline: .asciiz "\n"
space: .asciiz " "


# defines start of program
.text
main:
	
	# TEST CASE 1
	
	# print initial array
	printString(prompt1)
	printArray(array1, 10)
	
	# sort array1
	la $a0, array1	# arg 0 load base address of array to $a0
	addi $a1, $zero, 0	# arg 1, $a1 = low (index 0)
	addi $a2, $zero, 10	# arg 2, $a2 = high (index len-1)
	jal quicksort	# call quicksort function
	
	# print sorted array
	printString(promptSorted)
	printArray(array1, 10)
	printString(newline)
	
	# TEST CASE 2
	
	# print initial array
	printString(prompt2)
	printArray(array2, 10)
	
	# sort array1
	la $a0, array2	# arg 0 load base address of array to $a0
	addi $a1, $zero, 0	# arg 1, $a1 = low (index 0)
	addi $a2, $zero, 10	# arg 2, $a2 = high (index len-1)
	jal quicksort	# call quicksort function
	
	# print sorted array
	printString(promptSorted)
	printArray(array2, 10)
	printString(newline)
	
	# TEST CASE 3
	
	# print initial array
	printString(prompt3)
	printArray(array3, 13)
	
	# sort array1
	la $a0, array3	# arg 0 load base address of array to $a0
	addi $a1, $zero, 0	# arg 1, $a1 = low (index 0)
	addi $a2, $zero, 12	# arg 2, $a2 = high (index len-1)
	jal quicksort	# call quicksort function
	
	# print sorted array
	printString(promptSorted)
	printArray(array3, 13)
	printString(newline)
	
	# exit the program
	printString(programComplete)
	exit


# quicksort function sorts elements in place
# arg0: array
# arg1: low index
# arg2: high index
quicksort:
	
	# assign 4 variables to stack
	addi $sp, $sp, -16	# allocate space
    sw $a0, 0($sp)	# store array in stack
    sw $a1, 4($sp)	# store low in stack
    sw $a2, 8($sp)	# store high in stack
    sw $ra, 12($sp)	# store main return address in stack
    
    move $t0, $a2			# copy high to $t0
    
    slt $t1, $a1, $t0	# $t1 = low if low < high
    beq $t1, $zero, endsort		# if low >= high, jump to end sort
    
    # find pivot of current 
    jal partition	# call partition subroutine
    move $s0, $v0	# store returned pivot to $s0
    
    # recursively quicksort subarray left of pivot
    lw $a1, 4($sp)	# keep low
    addi $a2, $s0, -1	# high = pivot - 1
    jal quicksort	# call quicksort
    
    # recursively quicksort subarray right of pivot
    addi $a1, $s0, 1	# low = pivot + 1
    lw $a2, 8($sp)		# keep high
    jal quicksort	# call quicksort

	# end sort process
	endsort:
	
		# free stack
		lw $a0, 0($sp)	# restore array
 		lw $a1, 4($sp)	# restore low
 		lw $a2, 8($sp)	# restore high
 		lw $ra, 12($sp)	# restore main return address
 		addi $sp, $sp, 16	# free stack
	
		# return to parent function
		jr $ra


# swap function swaps in place 2 values in a specified array
# arg0: array
# arg1: index i
# arg2: index j
swap:
	
	# assign 3 variables to stack
	addi $sp, $sp, -12	# allocate space
	sw $a0, 0($sp)	# store array in stack
	sw $a1, 4($sp)	# store left index i in stack
	sw $a2, 8($sp)	# store right index j in stack
	
	# swap values in place
	lw $t6, 0($a1)	# int $t6 = array[i]
	lw $t7, 0($a2)	# int $t6 = array[j]
	sw $t6, 0($a2)	# array[j] = $t6
	sw $t7, 0($a1)	# array[i] = $t7
	
	addi $sp,$sp,12		# free stack
	jr $ra	# return to caller


# partition function selects pivot and sorts elements around pivot
# arg0: array
# arg1: left index i
# arg2: right index j
# return $v0: pivot
partition:

	# assign 4 variables to stack
	addi $sp, $sp, -16	# allocate space
    sw $a0, 0($sp)	# store array in stack
    sw $a1, 4($sp)	# store low in stack
    sw $a2, 8($sp)	# store high in stack
    sw $ra, 12($sp)	# store return address in stack
    
    # prepare partition
	mul $t0, $a1, 4		# $t0 = index i shift left 2 bits, i++
	add $t1, $t0, $a0	# $t1 = $t0 + array address
	move $s0, $a1	# i = low
	move $s1, $a2	# j = high
	lw $s3, 0($t1)	# pivot = array[i]
	lw $t3, 0($sp)	# $t3 = array adddress
	
	# while i < j
	while:
		bge $s0, $s1, endwhile
		
		whileRight:
			mul $t2, $s1, 4		# $t2 = index j shift left 2 bits, j+1
			add $s6, $t2, $t3	# $s6 = $t2 + array address
			lw $s4, 0($s6)		#$s4 = array[j]
			ble $s4,$s3, endWhileRight # end whileRight if array[j] <= pivot
			subi $s1,$s1,1		# j = j-1
			j whileRight
		endWhileRight:
		
		whileLeft:
			mul $t4, $s0, 4		# $t4 = index i shift left 2 bits, i+1
			add $s7, $t4, $t3	# $s7 = $t4 + array address
			lw $s5, 0($s7)		# $s5 = array[i]
			bge $s0, $s1, endWhileLeft		# end loop if i >= j
			bgt $s5, $s3, endWhileLeft		# end loop if aray[i] > pivot
			addi $s0,$s0,1		#left = left+1
			j whileLeft
		endWhileLeft:
		
		# swap elements if i < j
		if:
			bge $s0, $s1, endIf
			
			move $a0, $t3	# copy $a0 = $t3
			move $a1, $s7	# copy $a1 = array[i]
			move $a2, $s6	# copy $a2 = array[j]
			jal swap	# call swap function		
		endIf:
		
		j while
	
	# update array elements based on partition results
	endwhile:
	
		lw $s5, 0($s7)	# $s5 = array[left]
		lw $s4, 0($s6)	# $s4 = array[right]
		sw $s4 0($t1)	# array[i] = array[j]
		sw $s3, 0($s6)	# array[j] = pivot
		
		move $v0, $s1	# return $v0 = pivot
		
	lw $ra 12($sp)	# restore return address
	addi $sp, $sp,16	# free stack
	jr $ra	# return to caller
