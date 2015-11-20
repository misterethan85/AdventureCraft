#####################ARRAY GENERATOR######################################
# Grant
	.data
list:   .space  1000
listsz: .word	250          # using as array of integers
	
	.text
main:   lw	$s0, listsz    # $s0 = array dimension
	la	$s1, list      # $s1 = array address
	li	$t0, 0         # $t0 = # elems init'd

initlp: beq	$t0, $s0, initdn
	sw	$s1, ($s1)     # list[i] = addr of list[i]
	addi	$s1, $s1, 4    # step to next array cell
	addi	$t0, $t0, 1    # count elem just init'd
	b	initlp
initdn:
	li	$v0, 10

	syscall 

##################RANDOMNUMBERGENERATOR#####################################
	
	.text
    li $a1, 1000 #set parameters  
    li $v0, 42  #get number
    syscall
    add $a0, $a0, 100  #add the lowest bound
    li $v0, 1   #print
    syscall	#exit 


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

##########################USERCONTROLS####################################
	.kdata					# kernel data
s1:	.word 10
s2:	.word 11

new_line: 
	.asciiz "\n"

	.text
	.globl main
main:
	mfc0 $a0, $12			# read from the status register
	ori $a0, 0xff11			# enable all interrupts
	mtc0 $a0, $12			# write back to the status register

	lui $t0, 0xFFFF			# $t0 = 0xFFFF0000;
	ori $a0, $0, 2				# enable keyboard interrupt
	sw $a0, 0($t0)			# write back to 0xFFFF0000;
		
here: 
	j here				# stay here forever
	
	li $v0, 10				# exit,if it ever comes here
	syscall


.ktext 0x80000180				# kernel code starts here
	
	.set noat				# tell the assembler not to use $at, not needed here actually, just to illustrae the use of the .set noat
	move $k1, $at			# save $at. User prorams are not supposed to touch $k0 and $k1 
	.set at				# tell the assembler okay to use $at
	
	sw $v0, s1				# We need to use these registers
	sw $a0, s2				# not using the stack because the interrupt might be triggered by a memory reference 
					# using a bad value of the stack pointer

	mfc0 $k0, $13			# Cause register
	srl $a0, $k0, 2				# Extract ExcCode Field
	andi $a0, $a0, 0x1f

    bne $a0, $zero, kdone			# Exception Code 0 is I/O. Only processing I/O here

	lui $v0, 0xFFFF			# $t0 = 0xFFFF0000;
	lw $a0, 4($v0)			# get the input key
	li $v0,1				# print it here. 
					# Note: interrupt routine should return very fast, so doing something like 
					# print is NOT a good practice, actually!
	syscall

	li $v0,4				# print the new line
	la $a0, new_line
	syscall

kdone:
	mtc0 $0, $13				# Clear Cause register
	mfc0 $k0, $12			# Set Status register
	andi $k0, 0xfffd			# clear EXL bit
	ori  $k0, 0x11				# Interrupts enabled
	mtc0 $k0, $12			# write back to status

	lw $v0, s1				# Restore other registers
	lw $a0, s2

	.set noat				# tell the assembler not to use $at
	move $at, $k1			# Restore $at
	.set at					# tell the assembler okay to use $at

	eret					# return to EPC



