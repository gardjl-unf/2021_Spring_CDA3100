#################################################################
# CDA3100 - Assignment 2			       		#
#						       		#
# DO NOT MODIFY any code above the STUDENT_CODE label. 		#
#################################################################
	.data
	.align 0
msg0:	.asciiz "Statistical Calculator!\n"
msg1:	.asciiz "-----------------------\n"
msg2:	.asciiz "Average: "
msg3:	.asciiz "Maximum: "
msg4:	.asciiz "Median:  "
msg5:	.asciiz "Minimum: "
msg6:	.asciiz "Sum:     "
msg7:	.asciiz "\n"
	.align 2
array:	.word 91, 21, 10, 56, 35, 21, 99, 33, 13, 80, 79, 66, 52, 6, 4, 53, 67, 91, 67, 90
size:	.word 20
	.text
	.globl main
	# Display the floating-point (%double) value in register (%register) to the user
	.macro display_double (%register)
		li $v0, 3		# Prepare the system for output
		mov.d $f12, %register	# Set the integer to display
		syscall			# System displays the specified integer
	.end_macro
	
	# Display the %integer value to the user
	.macro display_integer (%integer)
		li $v0, 1			# Prepare the system for output
		add $a0, $zero, %integer	# Set the integer to display
		syscall				# System displays the specified integer
	.end_macro
	
	# Display the %string to the user
	.macro display_string (%string)
		li $v0, 4		# Prepare the system for output
		la $a0, %string		# Set the string to display
		syscall			# System displays the specified string
	.end_macro

	# Perform floating-point division %value1 / %value2
	# Result stored in register specified by %register
        .macro fp_div (%register, %value1, %value2)
 		mtc1.d %value1, $f28		# Copy integer %value1 to floating-point processor
		mtc1.d %value2, $f30		# Copy integer %value2 to floating-point processor
		cvt.d.w $f28, $f28		# Convert integer %value1 to double
		cvt.d.w $f30, $f30		# Convert integer %value2 to double
		div.d %register, $f28, $f30	# Divide %value1 by %value2 (%value1 / %value2)
	.end_macro				# Quotient stored in the specified register (%register)
	
main:
	la $a0, array		# Store memory address of array in register $a0
	lw $a1, size		# Store value of size in register $a1
	jal getMax		# Call the getMax procedure
	add $s0, $v0, $zero	# Move maximum value to register $s0
	jal getMin		# Call the getMin procedure
	add $s1, $v0, $zero	# Move minimum value to register $s1
	jal calcSum		# Call the calcSum procedure
	add $s2, $v0, $zero	# Move sum value to register $s2
	jal calcAverage		# Call the calcAverage procedure (result is stored in floating-point register $f2
	jal sort		# Call the sort procedure
	jal calcMedian		# Call the calcMedian procedure (result is stored in floating-point register $f4
	add $a1, $s0, $zero	# Add maximum value to the argumetns for the displayStatistics procedure
	add $a2, $s1, $zero	# Add minimum value to the argumetns for the displayStatistics procedure
	add $a3, $s2, $zero	# Add sum value to the argumetns for the displayStatistics procedure
	jal displayStatistics	# Call the displayResults procedure
exit:	li $v0, 10		# Prepare to terminate the program
	syscall			# Terminate the program
	
# Display the computed statistics
# $a1 - Maximum value in the array
# $a2 - Minimum value in the array
# $a3 - Sum of the values in the array
displayStatistics:
	display_string msg0
	display_string msg1
	display_string msg6
	display_integer	$a3	# Sum
	display_string msg7
	display_string msg5
	display_integer $a2	# Minimum
	display_string msg7
	display_string msg3
	display_integer $a1	# Maximum
	display_string msg7
	display_string msg2
	display_double $f2	# Average
	display_string msg7
extra_credit:
	display_string msg4
	display_double $f4	# Median
	display_string msg7
	jr $ra
#################################################################
# DO NOT MODIFY any code above the STUDENT_CODE label. 		#
#################################################################

# Place all your code in the procedures provided below the student_code label
student_code:
#author:	Jason Gardner
#modified:	07MAR2021

# Calculate the average of the values stored in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in floating-point register $f2
calcAverage:
	fp_div($f2,$s2,$a1)
	#fp_div $f2, $rs, $rt	# Perform floating-point division on registers $rs and $rt ($rs / $rt)
	
	jr $ra	# Return to calling procedure
	
################################################################################

# Calculate the median of the values stored in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in floating-point register $f4
calcMedian:
	li	$t0, 2						#denominator=2				$t0
	divu	$a1, $t0					#array.length/denominator		hi/lo
	mfhi	$t0						#remainder				$t0
	mflo	$t2						#indexLo=divisor			$t2
	subiu	$t2, $t2, 1					#indexLo=divisor-1
	sll	$t2, $t2, 2					#offsetLo=indexLo*4			$t2
	addu	$t2, $t2, $a0					#*pLo=*array+offsetLo			$t2
	addiu	$t1, $t2, 4					#*pHi=*pLo+4
	lw	$t2, ($t2)					#valueHi=&*pHi				$t2
	bnez	$t0, median
	
	# Add the value at next index if odd number of values in array, also divide by two.
	addiu	$t0, $t0, 2					#denominator=2	
	lw	$t1, ($t1)					#valueLo=&*pLo				$t1
	addu	$t2, $t2, $t1					#value=valueLo+valueHi			$t2

	median:
		fp_div($f4, $t2, $t0)					#value/denominator		$f4
		#fp_div $f4, $rs, $rt	# Perform floating-point division on registers $rs and $rt ($rs / $rt)

	jr $ra			# Return to calling procedure
	
################################################################################

# Calculate the sum of the values stored in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in register $v0
calcSum:
	li	$t0, 0						#index=0				$t0
	la	$t1, ($a0)					#*pIndex=*array				$t1
	li	$v0, 0						#sum=0					$v0
	sum_loop:
		lw	$t2, ($t1)				#value=&*pIndex				$t2
		addu 	$v0, $v0, $t2				#sum+=value				$v0
		addiu  	$t0, $t0, 1				#counter++				$t0
		addiu 	$t1, $t1, 4				#*pIndex++				$t1
		blt	$t0, $a1, sum_loop			#if(counter<array.length){:sum_loop()}	$t0

	jr $ra	# Return to calling procedure
	
################################################################################

# Return the maximum value in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in register $v0
getMax:
	li	$t0, 0					#index=0				$t0
	la	$t1, ($a0)				#*pIndex=*array				$t1
	lw	$v0, ($a0)				#max=&*array
	
	max_loop:
		addiu	$t0, $t0, 1			#index++				$t0
		addiu	$t1, $t1, 4			#*pIndex++				$t1
		lw	$t2, ($t1)			#value=&*pIndex				$t2
		blt	$t2, $v0, max_check		#if(value<max){:max_check()}
		max_set:
			addu	$v0, $t2, $zero		#max=value
		max_check:
			blt	$t0, $a1, max_loop	#if(counter<array.length){:max_loop()}

	jr $ra	# Return to calling procedure
	
################################################################################

# Return the minimum value in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in register $v0
getMin:
	li	$t0, 0					#index=0				$t0
	la	$t1, ($a0)				#*pIndex=*array				$t1
	lw	$v0, ($a0)				#min=&*array
	
	min_loop:
		addiu	$t0, $t0, 1			#index++				$t0
		addiu	$t1, $t1, 4			#*pIndex++				$t1
		lw	$t2, ($t1)			#value=&*pIndex				$t2
		bgt	$t2, $v0, min_check		#if(value<min){:min_check()}
		min_set:
			addu	$v0, $t2, $zero		#min=value
		min_check:
			blt	$t0, $a1, min_loop	#if(counter<array.length){:min_loop()}
			
	jr $ra	# Return to calling procedure
	
################################################################################

# Perform the Selection Sort algorithm to sort the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
sort:
	# Selection Sort
	# $a1 - Outer loop index (y)
	# $a2 - Minimum index (min)
	# $t0 - Inner loop stop (array.length)
	# $t1 - Outer loop stop (array.length-1)
	# $t2 - Pointer to array value at index x (*pX)
	# $t3 - Pointer to array value at index min (*pMin)
	# $t4 - Value at index x (&*pX)
	# $t5 - Value at index min (&*pMin)
	# $t6 - Inner loop index (x)
	# $t7 - Return address ($ra saved here during subroutine)
	
	addu	$t0, $a1, $zero							#array.length				$t0 (20)
	subiu	$t1, $t0, 1							#array.length-1				$t1 (19)
	li	$a1, 0								#y=0					$a1 (y)
	addu	$t2, $a0, $zero							#*pX=array				$t2 (*pX)	
	addiu	$t3, $a0, 4							#*pMin=array+1				$t3 (*pMin)
	addu	$t6, $a1, $zero							#x=0					$t6 (x)
	loop_outer_sort:	
		add	$a2, $a1, $zero						#min=y					$a2 (min)
		loop_inner_sort:
			reset_inner:
				addiu	$t6, $a1, 1				#x=y+1
			start_inner:
				bgt	$t6, $t0, reset_inner			#if(x>20){set_inner}
				sll	$t2, $t6, 2				#*pX=x*4
				addu	$t2, $t2, $a0				#*pX=x*4+array
				sll	$t3, $a2, 2				#*pMin=min*4
				addu	$t3, $t3, $a0				#*pMin=min*4+array
				lw	$t4, ($t2)				#array[x]				$t4 (array[x])	
				lw	$t5, ($t3)				#array[min]				$t5 (array[min])
				blt	$t4, $t5, setmin			#if(array[x]<array[min]){:setmin()}
				bc1f	check_inner				#else{:check_inner()}
			setmin:
				addu	$a2, $t6, $zero				#min=x
			check_inner:
				addiu	$t6, $t6, 1				#x++
				blt	$t6, $t0, start_inner			#if(x<array.length){:loop_inner_sort()
			bne	$a1, $a2, swap_values				#if(min!=y){:swap_values()}
			bc1f	check_outer					#else{:check_outer}	
		swap_values:
			addu	$t7, $ra, $zero				#save  return address				$t7 (sort_return)
			subiu	$sp, $sp, 12				#allocate stack(12 bytes)
			sw	$t1, 12($sp)				#copy registers to stack
			sw	$t2, 8($sp)
			sw	$t3, 4($sp)
			sw	$t4, 0($sp)
			jal swap					#jump-link(swap)
			lw	$t1, 12($sp)				#copy stack to registers
			lw	$t2, 8($sp)
			lw	$t3, 4($sp)
			lw	$t4, 0($sp)
			addiu	$sp, $sp, 16				#unallocate stack
			addu	$ra, $t7, $zero				#restore return address
		check_outer:
		addiu	$a1, $a1, 1					#y++
		blt	$a1, $t1, loop_outer_sort			#if y<array.length-1{:loop_outer_sort()}
			
	move	$a1, $t0						#put array.length back in $a1
	jr $ra	# Return to calling procedure

################################################################################

# Swap the values in the specified positions of the array
# $a0 - Memory address of the array
# $a1 - Index position of first value to swap
# $a2 - Index position of second value to swap

swap:
	# $t1 - Pointer to first value (at index $a1)
	sll	$t1, $a1, 2
	addu	$t1, $t1, $a0						#*p1=(idx1*align)+array
	
	# $t2 - Pointer to second value (at index $a2)
	sll	$t2, $a2, 2
	addu	$t2, $t2, $a0						#*p2=(idx2*align)+array
	
	# Swap values
	lw	$t3, ($t1)
	lw	$t4, ($t2)
	sw	$t3, ($t2)
	sw	$t4, ($t1)
	jr $ra	# Return to calling procedure
