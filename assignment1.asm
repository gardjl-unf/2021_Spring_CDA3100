#################################################################
# CDA3100 - Assignment 1			       		#
#						       		#
# The following code is provided by the professor.     	#
# DO NOT MODIFY any code above the STUDENT_CODE label. 	#
#						       		#
# The professor will not troubleshoot any changes to this code. #
#################################################################

	.data
	.align 0

	# Define strings used in each of the printf statements
msg1:	.asciiz "Welcome to Prime Tester\n\n"
msg2:	.asciiz "Enter a number between 0 and 100: "
msg3:	.asciiz "Error: Invalid input for Prime Tester\n"
msg4:	.asciiz "The entered number is prime\n"
msg5:	.asciiz "The entered number is not prime\n"
ec_msg:	.asciiz " is prime\n" 		# Reserved for use in extra credit

	.align 2	
	.text
	.globl main

	# The following macros are provided to simplify the program code
	# A macro can be thought of as a cross between a function and a constant
	# The assembler will copy the macro's code to each use in the program code
	
	# Display the %integer to the user
	# Reserved for extra credit
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
	
	# Compute the square root of the %value
	# Result stored in the floating-point register $f2
	.macro calc_sqrt (%value)
		mtc1.d %value, $f2	# Copy integer %value to floating-point processor
		cvt.d.w $f2, $f2	# Convert integer %value to double
		sqrt.d $f2, $f2		# Calculate the square root of the %value
	.end_macro 
	
	# Determine if the %value is less-than or equal-to the current square root value in register $f2
	# Result stored in the register $v1
	.macro slt_sqrt (%value)
		mtc1.d %value, $f4	# Copy integer %value to floating-point processor
		cvt.d.w $f4, $f4	# Convert integer %value to double
		c.lt.d $f4, $f2		# Test if %value is less-than square root
		bc1t less_than_or_equal	# If less-than, go to less_than_or_equal label
		c.eq.d $f4, $f2		# Test if %value is equal-to square root
		bc1t less_than_or_equal	# If equal-to, go to less_than_or_equal label
		li $v1, 0		# Store a 0 in register $v1 to indicate greater-than condition
		j end_macro		# Go to the end_macro label
less_than_or_equal: 	
		li $v1, 1		# Store a 1 in register $v1 to indicate less-than or equal-to condition
end_macro: 
	.end_macro

main:
	# This series of instructions
	# 1. Displays the welcome message
	# 2. Displays the input prompt
	# 3. Reads input from the user
	display_string msg1	# Display welcome message
	display_string msg2	# Display input prompt
	li $v0, 5		# Prepare the system for keyboard input
	syscall			# System reads user input from keyboard
	move $a1, $v0		# Store the user input in register $a0
	j student_code 		# Go to the student_code label

error:	
	display_string msg3	# Display error message
	j exit
isprime:
	display_string msg4	# Display is prime message
	j exit
notprime:
	display_string msg5	# Display not prime message
exit:
	li $v0, 10	# Prepare to terminate the program
	syscall		# Terminate the program
	
#################################################################
# The code above is provided by the professor.     		#
# DO NOT MODIFY any code above the STUDENT_CODE label. 	#
#						       		#
# The professor will not troubleshoot any changes to this code. #
#################################################################

# Place all your code below the student_code label
student_code:
	li 	$t1, 1					#mask=1	
	li	$t3, 0					#flag_ec=0
	li	$t4, 2					#loop_increment=2
	
	# Toggles the flag value at %value via xor using our mask value (1)
	.macro toggle_flag (%value)
		xor 	%value, %value, $t1		#value=value(xor)mask
	.end_macro
	
	beq	$a1, -1, ec_mode			#if(input==-1){:ec_mode()}
	blt 	$a1, 0, error				#if(input<0||input>100){:error()}
	bgt	$a1, 100, error	
	start:
		li	$t2, 1				#counter=1
		li	$t0, 1				#flag_prime=1
		bge	$a1, $t4, test_even		#if(input>=2){:test_even()}
		toggle_flag($t0)			#toggle_flag(flag_prime)
		j	output				#:output()
	test_even:
		divu	$a1, $t4			#input/2
		mfhi	$a2				#remainder [->$a2]
		bnez	$a2, test_odd			#if(!remainder){:test_odd()}
		beq	$a1, $t4, output		#if(input==2){:output()}
		toggle_flag($t0)			#toggle_flag(flag_prime)
		j	output				#:output()
	test_odd:		
		addu	$t2, $t2, $t4			#counter+=2
		calc_sqrt($a1)				#calc_sqrt(input) [->$f2]
		slt_sqrt($t2)				#flag_loop=slt_sqrt(counter) [->$v1]
		beqz	$v1, output			#if(!flag_loop){:output()}
		divu	$a1, $t2			#input/counter
		mfhi	$a2				#remainder [->$a2]
		bnez	$a2, test_odd			#if(!remainder){:test_odd()}
		toggle_flag($t0)			#toggle_flag(flag_prime)
		j	output				#:output()			
	output:
		beq	$t3, 1, ec_output		#if(flag_ec){:ec_output()}
		beqz	$t0, notprime			#if(!flag_prime){:notprime()}
		bc1f	isprime				#else{:isprime()}
	ec_output:
		beqz	$t0, ec_loop			#if(!flag_prime){:ec_loop()}
		display_integer($a1)			#display_integer(input)
		display_string(ec_msg)			#display_string(ec_msg)
	ec_loop:
		add	$a1, $a1, 1			#input++
		beq	$a1, 101, exit			#if(input==101){:exit()}
		j	start				#:start()
	ec_mode:
		toggle_flag($t3)			#toggle_flag(flag_ec)
		j	ec_loop				#:ec_loop()
