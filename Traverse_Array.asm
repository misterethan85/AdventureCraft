#########################################################################
#   Description:
#       Demonstrate array traversal with offset and indirect addressing
#
#########################################################################

#########################################################################
#   Global constants (do not use global variables!)
#   By convention, constant names use all capital letters.
#########################################################################

# Common ASCII/ISO control characters

#ISO_EOT             =   4   # End of transmission (Ctrl+D)
#ISO_BEL             =   7   # Bell
#ISO_BS              =   8   # Backspace
#ISO_TAB             =   9   # Tab
#ISO_LF              =   10  # Line feed (newline)
#ISO_FF              =   12  # Form feed
#ISO_CR              =   13  # Carriage return

# System call constants

#SYS_PRINT_INT       =   1
#SYS_PRINT_FLOAT     =   2
#SYS_PRINT_DOUBLE    =   3
#SYS_PRINT_STRING    =   4
#SYS_READ_INT        =   5
#SYS_READ_FLOAT      =   6
#SYS_READ_DOUBLE     =   7
#SYS_READ_STRING     =   8
#SYS_SBRK            =   9
#SYS_EXIT            =   10
#SYS_PRINT_CHAR      =   11
#SYS_READ_CHAR       =   12

#########################################################################
#   Macro definitions and includes.
#########################################################################

#########################################################################
#   Sample macros
#   Use these as models to create others, such as print_word_reg,
#   read_word_reg, etc.
#########################################################################

# Save contents of an integer register on the stack
.macro  pushw($register)
	addi    $sp, $sp, -4
	sw      $register, ($sp)
.end_macro
	
# Retrieve top of stack to an integer register
.macro  popw($register)
	lw      $register, ($sp)
	addi    $sp, $sp, 4
.end_macro
	
# Example: print_char_const(ISO_LF)
.macro  print_char_const($const)
	pushw($a0)
	pushw($v0)
	
	li      $a0, $const
	li      $v0, #SYS_PRINT_CHAR
	syscall
	
	popw($v0)
	popw($a0)
	.end_macro
	
# Print the string at address $var
# $var must be a label
.macro  print_string_var($var)
	pushw($a0)
	pushw($v0)
	
	la      $a0, $var
	li      $v0, 
	syscall
	
	popw($v0)
	popw($a0)
.end_macro
	
# Print the integer in $var
# $var must be a label
.macro  print_word_var($var)
	pushw($a0)
	pushw($v0)
	
	lw      $a0, $var
	li      $v0, #SYS_PRINT_INT
	syscall
	
	popw($v0)
	popw($a0)
.end_macro
	
# Read an integer and store in $var
# $var must be a label
.macro  
	read_word_var($var)
	pushw($v0)
	
	li      $v0, #SYS_READ_INT
	syscall
	sw      $v0, $var
	popw($v0)

.end_macro


#########################################################################
#   Main program
#########################################################################

#LIST_SIZE       = 5
#ELEMENT_SIZE    = 4
#LIST_BYTES      = 20    # LIST_SIZE * ELEMENT_SIZE

# Variables for main
	.data
	.align 2
list:               .word   0
next_num:           .word   0
base_address:       .word   0
element_address:    .word   0
offset:             .word   0

number_prompt:  .asciiz "Please enter the next number.  Enter -1 when done: "
list_full_msg:  .asciiz "List array is full.  Bailing out...\n"
address_msg:    .asciiz "\nThe address of list is "
storing_msg:    .asciiz "Storing new value at list + "
value_at_msg:   .asciiz "Value at address "
is_msg:         .asciiz " is "

# Main body
.text

main:
	# Push stack frame
	pushw($ra)
    
	# Read list until sentinel value of -1 is entered
	# Demonstrate offset addressing
	li      $s0, 0
next_number:
	
	# Input next number
	print_string_var(number_prompt)
	read_word_var(next_num)
	lw      $t0, next_num
	
	# Store new value in array
	print_string_var(storing_msg)
	sw      $s0, offset
	print_word_var(offset)
	print_char_const(ISO_LF)
	sw      $t0, list($s0)
	
	# Sentinel value of -1 marks end of input
	beq     $t0, -1, done_reading
	
	# Next array position
	addi    $s0, $s0, ELEMENT_SIZE
	beq     $s0, LIST_BYTES, list_full  # Check for array overflow
	j       next_number
    
done_reading:
	# Print list backwards using a pointer
	# Add address of list to offset to get pointer to end of list
	la      $s1, list
	add     $s0, $s0, $s1
	
	print_string_var(address_msg)
	sw      $s1, base_address
	print_word_var(base_address)
	print_char_const(ISO_LF)

print_list:
	# Print address of element
	print_string_var(value_at_msg)
	sw      $s0, element_address
	print_word_var(element_address)
	print_string_var(is_msg)
	
	# Print element from list
	lw      $t0, ($s0)
	sw      $t0, next_num
	print_word_var(next_num)
	print_char_const(ISO_LF)
	
	# Back up to previous element
	sub     $s0, $s0, ELEMENT_SIZE
	bge     $s0, $s1, print_list
	
	# Pop stack frame
	popw($ra)
	
	# Return to calling program
	jr      $ra

list_full:
	sub     $s0, $s0, ELEMENT_SIZE  # Back to last element
	print_string_var(list_full_msg)
	j       done_reading

