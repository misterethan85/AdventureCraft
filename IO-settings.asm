##########################IOSETTING##########################################
	.text
	.globl main
main:			#NOTE key numbers are as follows asdw = 97,115,100,119
	addi $s0, $0, 113 # q key
	lui $t0, 0xFFFF # $t0 = 0xFFFF0000;
	
waitloop: 
	lw $t1, ($t0) 
	andi $t1, $t1, 0x0001
	beq $t1, $zero, waitloop 

	lw $a0, 4($t0)

	beq $a0, $s0, done
	
	li $v0,1
	syscall

	li $v0,4
	la $a0, new_line
	syscall

	j waitloop 
	
done:
	li $v0, 10 # exit
	syscall


	.data
new_line: .asciiz "\nâ€?