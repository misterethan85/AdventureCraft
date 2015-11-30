.data 


list:	.space 400 
stew: .word 100 
msg: .asciiz "Print Integer (0-9): " 
location: .asciiz "The location of your number is (row, column): " 
first: .asciiz "(" 
second: .asciiz ")" 
sep: .asciiz ", " 
 counter: .word 1 
 

 	.text 
 

main: 
	lw $s0, stew 
	la $s1, list 
	li $t0, 0 
	jal random 
	lw $s2, ($a1) 
	la $t0, list 
	lw $a3, counter     # Load counter in $a3 
	jal find 




	li $v0, 10 
	syscall 


random: 
	li $v0, 42 
	li $a1, 99 
	syscall 
	li $a1, 4 
	mult $a0, $a1 
	mflo $a0 


	la $a1, list 
	add $a1, $a1, $a0 
	la $a0, msg  
	li $v0, 4 					# Print prompt user for Integer 
	syscall 
	li $v0, 5 					# Collect Integer 
	syscall 
	sw $v0, ($a1) 


	jr $ra 




find: 
	 
	 
	lw $t1, ($t0)  
	beq $s2, $t1, loc 
	addi $t0, $t0, 4 
	addi $a3, $a3, 1         # Add 1 to counter 
	j find 


loc: 
	li $t6, 10 
	div $a3, $t6 
	mflo $t5    
	mfhi $t4            # Remainder 


	beq $t4, $zero, row    #If remainder is 0, jump to row function 


	li $t7, 1 
	add $t5, $t5, $t7	# If remainder is not 0, must add 1 to the row 


	la $a0, location 
	li $v0, 4 
	syscall 


	la $a0, first 
	li $v0, 4 
	syscall 


	la $a0, ($t5) 
	li $v0, 1 
	syscall 


	la $a0, sep 
	li $v0, 4 
	syscall 


	la $a0, ($t4) 
	li $v0, 1 
	syscall 


	la $a0, second 
	li $v0, 4 
	syscall 


	jr $ra 


row:						 
	li $t7, 10 
	add $t4, $t7, $t4		# Add 10 to the column (if remainder was 0, number is in column 10) 




	la $a0, location 
 	li $v0, 4 
 	syscall 
 

 	la $a0, first 
 	li $v0, 4 
 	syscall 
 

 	la $a0, ($t5) 
 	li $v0, 1 
 	syscall 
 

 	la $a0, sep 
 	li $v0, 4 
 	syscall 
 

 	la $a0, ($t4) 
 	li $v0, 1 
 	syscall 
 

 	la $a0, second 
 	li $v0, 4 
 	syscall 
 

 	jr $ra 
 

 

  
