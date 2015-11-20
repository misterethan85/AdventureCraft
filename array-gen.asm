#####################ARRAY GENERATOR######################################
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
