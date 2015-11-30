	.data 
list:			.space 2048 
size:			.word 512 
buffer:			.space 20 	# Max input size 
Isize:			.word 5		# Max input characters 
star: 			.word 5 
x: 				.word 0 
y:				.word 0 
z: 				.word 0 
 sandwiches:		.word 0		# 5 Max in inventory 
 mustard:		.word 0		# 5 Max in inventory 
 health:			.word 10 
 

 # List of Commands 
 left:		.asciiz "l\n" 
 right:		.asciiz "r\n" 
 up:			.asciiz "u\n" 
 down:		.asciiz "d\n" 
 forward:	.asciiz "f\n" 
 backward:	.asciiz "b\n" 
 sleep:		.asciiz "s\n" 
 quit:		.asciiz "q\n" 
 inventory: 	.asciiz "i\n" 
 checkh:		.asciiz	"h\n" 
 rules:		.asciiz "rules" 
 

 

 # Strings used by game 
 starting: 	.asciiz "Your starting location is (" 
 newlocp:	.asciiz "Your current location is (" 
 sep:		.asciiz " , " 
 closer:		.asciiz ")" 
 newline:	.asciiz "\n\n" 
 omessage:	.asciiz "Welcome to the game! You are going to be put into a 8 x 8 x 8 board, you must find the diamond to win! You begin with (x) health. If you get bit by a snake you lose (x) health. There are burgers scattered thoughout the board that you may eat to regain health. The inputs that are acceptable are as followed:\n u: Move Up\n d: Move Down\n l: Move Left\n r: Move Right\n f: Move Forward\n b: Move Backwards\n s: Sleep\n q: Quit\n" 
 badinput:	.asciiz "THAT INPUT IS INVALID!!" 
 bound:		.asciiz "I'm sorry, you can not move that way!" 
 prompt:		.asciiz "Please enter your move: " 
 lp:			.asciiz "You went left" 
 rp:			.asciiz "You went right" 
 upr:		.asciiz "You went up" 
 dp: 		.asciiz "You went down" 
 fp: 		.asciiz "You went forward" 
 bp:			.asciiz "You went backwards" 
 sp:			.asciiz "You went to sleep" 
 qp:			.asciiz "You quit" 
 snakep:		.asciiz "SnakeTime" 
 sandp:		.asciiz "You found a sandwich! It has been added to your inventory." 
 sandp2:		.asciiz "You now have " 
 sandp3:		.asciiz	" sandwiches in your inventory." 
 maxsand:	.asciiz "Sorry, but you can only carry 5 sandwhiches at once, eat some to make room." 
 mustp:		.asciiz "TurdTime" 
 safep:		.asciiz "SafeTime" 
 diamondp:	.asciiz "You won mothafucka" 
  
 #rulesp:		.asciiz "Enter prompt for rules" 
 #controlsp		prompt that tells user controls, if forgotten. 
  
 # Prompts for testarray 
 rmsg:		.asciiz "Enter row: " 
 cmsg:		.asciiz "Enter cloumn: " 
 lmsg:		.asciiz "Enter level: " 
 valp:		.asciiz "The value in this location is: " 
  
  
 	.text 
 main: 
 	lw $s0, size  		# Load in array length 
 	la $s1, list 		# Load in list start 
 	li $t0, 0 			# Elemant counter 
 	jal poparray 
 	lw $s1, star 
 	jal hidestar 
 	li $a3, 0			# Initialize Pointer Function 
 	 
 	la $a0, omessage 	# Print opening message 
 	li $v0, 4 
 	syscall 
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
 	jal startingloc		# Enter funtion that tells starting location 
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
 	la $a0, prompt		# Print prompt 
 	li $v0, 4 
 	syscall 
 	la $a0, buffer 
 	la $a1, Isize 
 	li $v0, 8 
 	syscall 
 	la $a0, buffer 
 	jal loadl 
 	 
  
 	 
  
 	  
 	# Jump to funtion that asks for action 
  
 	 
  
 	 
  
 	li $v0, 10 
 	syscall 
  
 poparray: 
 	beq $t0, $s0, return 
 	li $v0, 42 
 	li $a1, 4 
 	syscall 
 	sw $a0, ($s1) # Put value in MemAddr $s1 
 	addi $s1, $s1, 4 
 	addi $t0, $t0, 1 
 	j poparray 
  
 hidestar: 
 	li, $a0, 1 # Lower bound for random placement 
 	li, $a1, 513 # Upper bound for random placement 
 	li $v0, 42 
 	syscall 
 	li $a1, 4 
 	mult $a0, $a1 # Mult placement by 4 for memory 
 	mflo $a0 
 	la $a1, list 
 	add $a1, $a1, $a0 
 	sw $s1, ($a1) # Store star in memory locatioin 
  
 	jr $ra 
  
 startingloc: 
 	li $v0, 42	# Random starting row 
 	li $a1, 8 
 	syscall 
 	addi $a0, $a0, 1 
 	sw $a0, x 
  
  
 	li $v0, 42	# Random starting Column 
 	li $a1, 8 
 	syscall 
 	addi $a0, $a0, 1 
 	sw $a0, y 
  
 	li $v0, 42	# Random starting level 
 	li $a1, 8 
 	syscall 
 	addi $a0, $a0, 1 
 	sw $a0, z 
  
 	la $a0, starting 
 	li $v0, 4 
 	syscall 
  
 	lw $a0, x 
 	li $v0, 1 
 	syscall 
  
 	la $a0, sep 
 	li $v0, 4 
 	syscall 
  
 	lw $a0, y 
 	li $v0, 1 
 	syscall 
  
 	la $a0, sep 
 	li $v0, 4 
 	syscall 
  
 	lw $a0, z 
 	li $v0, 1 
 	syscall 
  
 	la $a0, closer 
 	li $v0, 4 
 	syscall 
  
 	jr $ra 
  
 #testarray: 
 #	li $t6, 1 
 #	la $s1, list 
 #	la $a0, rmsg  # Collect row number for test 
 #	li $v0, 4 
 #	syscall 
 #	li $v0, 5 
 #	syscall 
 #	beq $v0, $zero, return 
  
 #	sub $t0, $v0, $t6 
 #	la $a0, cmsg	# Collect column number for test 
 #	li $v0, 4 
 #	syscall 
 #	li $v0, 5 
 #	syscall 
 #	beq $v0, $zero, return 
 #	sub $t1, $v0, $t6 
  
 #	la $a0, lmsg	# Collect level number for test 
 #	li $v0, 4 
 #	syscall 
 #	li $v0, 5 
 #	syscall 
 #	beq $v0, $zero, return 
 #	sub $t2, $v0, $t6 
  
 #	li $t3, 32 
 #	mult $t0, $t3 
 #	mflo $t0 
  
 #	li $t3, 4 
 #	mult $t1, $t3 
 #	mflo $t1 
  
 #	li $t3, 256 
 #	mult $t2, $t3 
 #	mflo $t2 
  
 #	add $t0, $t0, $t1 
 #	add $t0, $t0, $t2 
  
 #	add $s1, $s1, $t0 
  
 #	la $a0, valp 
 #	li $v0, 4 
 #	syscall 
  
 #	lw $a0, ($s1) 
 #	li $v0, 1 
 #	syscall 
  
 #	la $a0, newline 
 #	li $v0, 4 
 #	syscall 
  
 #	j testarray 
  
  
 loadl: 
 	la $a1, left 
 	j comparestr_l 
  
 loadr: 
 	la $a1, right 
 	j comparestr_r 
  
 loadu: 
 	la $a1, up 
 	j comparestr_u 
  
 loadd: 
 	la $a1, down 
 	j comparestr_d 
  
 loadf: 
 	la $a1, forward 
 	j comparestr_f 
  
 loadb: 
 	la $a1, backward 
 	j comparestr_b 
  
 loadq: 
 	la $a1, quit 
 	j comparestr_q 
  
 loads: 
 	la $a1, sleep 
 	j comparestr_s 
  
 comparestr_l: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, loadr 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, goleft 
 	j comparestr_l 
  
 comparestr_r: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, loadu 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, goright 
 	j comparestr_r 
  
 comparestr_u: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, loadd 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, goup 
 	j comparestr_u 
  
 comparestr_d: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, loadf 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, godown 
 	j comparestr_d 
  
 comparestr_f: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, loadb 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, goforward 
 	j comparestr_f 
  
 comparestr_b: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, loads 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, gobackward 
 	j comparestr_b 
  
 comparestr_s: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, loadq 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, gosleep 
 	j comparestr_s 
  
 comparestr_q: 
 	lbu $t0, ($a0) 
 	lbu $t1, ($a1) 
 	bne $t0, $t1, noinput 
 	addi $a0, $a0, 1 
 	addi $a1, $a1, 1 
 	beq $t0, $zero, goquit 
 	j comparestr_q 
  
 goleft: 
 	la $s1, list 
 	li $t1, 1 
 	li $t2, 32 
 	li $t3, 4 
 	li $t4, 256 
 	lw $a0, x 
 	lw $a1, y 
 	lw $a2, z 
 	sub $a1, $a1, $t1			# Move player coordinates left 1 
 	blt $a1, $t1, outofbounds 
 	sw $a1, y 					# Store new location to y 
 	sub $a0, $a0, $t1	 
 	sub $a1, $a1, $t1			# Set up values for new location 
 	sub $a2, $a2, $t1 
  
 	mult $a0, $t2 
 	mflo $a0 
  
 	mult $a1, $t3 
 	mflo $a1 
  
 	mult $a2, $t4 
 	mflo $a2 
  
 	add $a0, $a0, $a1 
 	add $a0, $a0, $a2 
  
 	add $s1, $s1, $a0 
 	lw $a0, ($s1) 
  
 	li $t1, 0			# Value of snake 
 	li $t2, 1 			# Value of sandwich 
 	li $t3, 2 			# Value of mustard 
 	li $t4, 3 			# Value of Safe 
 	li $t5, 5 			# Value of Diamond 
  
 	beq $a0, $t1, foundsnake 
 	beq $a0, $t2, foundsandwich 
 	beq $a0, $t3, foundmustard 
 	beq $a0, $t4, foundsafe 
 	beq $a0, $t5, founddiamond 
  
 goright: 
 	la $s1, list 
 	li $t1, 1 
 	li $t2, 32 
 	li $t3, 4 
 	li $t4, 256 
 	li $t5, 8 
 	lw $a0, x 
 	lw $a1, y 
 	lw $a2, z 
 	add $a1, $a1, $t1			# Move player coordinates right 1 
 	bgt $a1, $t5, outofbounds	# Jump if out of bounds 
 	sw $a1, y 					# Store new location to y 
 	sub $a0, $a0, $t1	 
 	sub $a1, $a1, $t1			# Set up values for new location 
 	sub $a2, $a2, $t1 
  
 	mult $a0, $t2 
 	mflo $a0 
  
 	mult $a1, $t3 
 	mflo $a1 
  
 	mult $a2, $t4 
 	mflo $a2 
  
 	add $a0, $a0, $a1 
 	add $a0, $a0, $a2 
  
 	add $s1, $s1, $a0 
 	lw $a0, ($s1) 
  
 	li $t1, 0			# Value of snake 
 	li $t2, 1 			# Value of sandwich 
 	li $t3, 2 			# Value of mustard 
 	li $t4, 3 			# Value of Safe 
 	li $t5, 5 			# Value of Diamond 
  
 	beq $a0, $t1, foundsnake 
 	beq $a0, $t2, foundsandwich 
 	beq $a0, $t3, foundmustard 
 	beq $a0, $t4, foundsafe 
 	beq $a0, $t5, founddiamond 
  
 goup: 
 	la $s1, list 
 	li $t1, 1 
 	li $t2, 32 
 	li $t3, 4 
 	li $t4, 256 
 	li $t5, 8 
 	lw $a0, x 
 	lw $a1, y 
 	lw $a2, z 
 	add $a2, $a2, $t1			# Move player coordinates up 1 
 	bgt $a2, $t5, outofbounds	# Jump if out of bounds 
 	sw $a2, z 					# Store new location to z 
 	sub $a0, $a0, $t1	 
 	sub $a1, $a1, $t1			# Set up values for new location 
 	sub $a2, $a2, $t1 
  
 	mult $a0, $t2 
 	mflo $a0 
  
 	mult $a1, $t3 
 	mflo $a1 
  
 	mult $a2, $t4 
 	mflo $a2 
  
 	add $a0, $a0, $a1 
 	add $a0, $a0, $a2 
  
 	add $s1, $s1, $a0 
 	lw $a0, ($s1) 
  
 	li $t1, 0			# Value of snake 
 	li $t2, 1 			# Value of sandwich 
 	li $t3, 2 			# Value of mustard 
 	li $t4, 3 			# Value of Safe 
 	li $t5, 5 			# Value of Diamond 
  
 	beq $a0, $t1, foundsnake 
 	beq $a0, $t2, foundsandwich 
 	beq $a0, $t3, foundmustard 
 	beq $a0, $t4, foundsafe 
 	beq $a0, $t5, founddiamond 
  
 godown: 
 	la $s1, list 
 	li $t1, 1 
 	li $t2, 32 
 	li $t3, 4 
 	li $t4, 256 
 	lw $a0, x 
 	lw $a1, y 
 	lw $a2, z 
 	sub $a2, $a2, $t1			# Move player coordinates down 1 
 	blt $a2, $t1, outofbounds 
 	sw $a2, z 					# Store new location to z 
 	sub $a0, $a0, $t1	 
 	sub $a1, $a1, $t1			# Set up values for new location 
 	sub $a2, $a2, $t1 
  
 	mult $a0, $t2 
 	mflo $a0 
  
 	mult $a1, $t3 
 	mflo $a1 
  
 	mult $a2, $t4 
 	mflo $a2 
  
 	add $a0, $a0, $a1 
 	add $a0, $a0, $a2 
  
 	add $s1, $s1, $a0 
 	lw $a0, ($s1) 
  
 	li $t1, 0			# Value of snake 
 	li $t2, 1 			# Value of sandwich 
 	li $t3, 2 			# Value of mustard 
 	li $t4, 3 			# Value of Safe 
 	li $t5, 5 			# Value of Diamond 
  
 	beq $a0, $t1, foundsnake 
 	beq $a0, $t2, foundsandwich 
 	beq $a0, $t3, foundmustard 
 	beq $a0, $t4, foundsafe 
 	beq $a0, $t5, founddiamond 
  
 goforward: 
 	la $s1, list 
 	li $t1, 1 
 	li $t2, 32 
 	li $t3, 4 
 	li $t4, 256 
 	li $t5, 8 
 	lw $a0, x 
 	lw $a1, y 
 	lw $a2, z 
 	add $a0, $a0, $t1			# Move player coordinates forward 1 
 	bgt $a0, $t5, outofbounds	# Jump if out of bounds 
 	sw $a0, x 					# Store new location to x 
 	sub $a0, $a0, $t1	 
 	sub $a1, $a1, $t1			# Set up values for new location 
 	sub $a2, $a2, $t1 
  
 	mult $a0, $t2 
 	mflo $a0 
  
 	mult $a1, $t3 
 	mflo $a1 
  
 	mult $a2, $t4 
 	mflo $a2 
  
 	add $a0, $a0, $a1 
 	add $a0, $a0, $a2 
  
 	add $s1, $s1, $a0 
 	lw $a0, ($s1) 
  
 	li $t1, 0			# Value of snake 
 	li $t2, 1 			# Value of sandwich 
 	li $t3, 2 			# Value of mustard 
 	li $t4, 3 			# Value of Safe 
 	li $t5, 5 			# Value of Diamond 
  
 	beq $a0, $t1, foundsnake 
 	beq $a0, $t2, foundsandwich 
 	beq $a0, $t3, foundmustard 
 	beq $a0, $t4, foundsafe 
 	beq $a0, $t5, founddiamond 
  
 gobackward: 
 	la $s1, list 
 	li $t1, 1 
 	li $t2, 32 
 	li $t3, 4 
 	li $t4, 256 
 	lw $a0, x 
 	lw $a1, y 
 	lw $a2, z 
 	sub $a0, $a0, $t1			# Move player coordinates backwards 1 
 	blt $a0, $t1, outofbounds 
 	sw $a0, x 					# Store new location to x 
 	sub $a0, $a0, $t1	 
 	sub $a1, $a1, $t1			# Set up values for new location 
 	sub $a2, $a2, $t1 
  
 	mult $a0, $t2 
 	mflo $a0 
  
 	mult $a1, $t3 
 	mflo $a1 
  
 	mult $a2, $t4 
 	mflo $a2 
  
 	add $a0, $a0, $a1 
 	add $a0, $a0, $a2 
  
 	add $s1, $s1, $a0 
 	lw $a0, ($s1) 
  
 	li $t1, 0			# Value of snake 
 	li $t2, 1 			# Value of sandwich 
 	li $t3, 2 			# Value of mustard 
 	li $t4, 3 			# Value of Safe 
 	li $t5, 5 			# Value of Diamond 
  
 	beq $a0, $t1, foundsnake 
 	beq $a0, $t2, foundsandwich 
 	beq $a0, $t3, foundmustard 
 	beq $a0, $t4, foundsafe 
 	beq $a0, $t5, founddiamond 
  
 gosleep: 
 	la $a0, sp 
 	li $v0, 4 
 	syscall 
  
 	jr $ra 
  
 #spray: 
 foundsnake: 
 	la $a0, snakep 
 	li $v0, 4 
 	syscall 
  
 	j newloc 
  
 foundsandwich: 
 	lw $t0, sandwiches 
 	li $t1, 1 
 	li $t2, 5 
 	la $a0, sandp 
 	li $v0, 4 
 	syscall 
  
 	add $t3, $t0, $t1			# Add 1 to total sandwiches 
 	bgt $t3, $t2, sandfull 
 	add $t0, $t1, $t0 
 	sw $t0, sandwiches 
  
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
  
 	la $a0, sandp2 
 	li $v0, 4 
 	syscall 
  
 	la $a0, ($t0) 
 	li $v0, 1 
 	syscall 
  
 	la $a0, sandp3 
 	li $v0, 4 
 	syscall 
  
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
  
  
 	j newloc 
  
 foundmustard: 
 	la $a0, mustp 
 	li $v0, 4 
 	syscall 
  
 	j newloc 
  
 foundsafe: 
 	la $a0, safep 
 	li $v0, 4 
 	syscall 
  
 	j newloc 
  
 founddiamond: 
 	la $a0, diamondp 
 	li $v0, 4 
 	syscall 
  
 	jr $ra 
  
 noinput: 
 	la $a0, badinput 
 	li $v0, 4 
 	syscall 
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
 	la $a0, prompt	# Print prompt 
 	li $v0, 4 
 	syscall 
 	la $a0, buffer 
 	la $a1, Isize 
 	li $v0, 8 
 	syscall 
 	la $a0, buffer 
 	j loadl 
  
 newloc: 
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
  
 	la $a0, newlocp 
 	li $v0, 4 
 	syscall 
  
 	lw $a0, x 
 	li $v0, 1 
 	syscall 
  
 	la $a0, sep 
 	li $v0, 4 
 	syscall 
  
 	lw $a0, y 
 	li $v0, 1 
 	syscall 
  
 	la $a0, sep 
 	li $v0, 4 
 	syscall 
  
 	lw $a0, z 
 	li $v0, 1 
 	syscall 
  
 	la $a0, closer 
 	li $v0, 4 
 	syscall 
  
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
 	la $a0, prompt		# Print prompt 
 	li $v0, 4 
 	syscall 
 	la $a0, buffer 
 	la $a1, Isize 
 	li $v0, 8 
 	syscall 
 	la $a0, buffer 
 	j loadl 
  
 sandfull: 
 	la $a0, newline 
 	li $v0, 4 
 	syscall 
  
 	la $a0, maxsand 
 	li $v0, 4 
 	syscall 
  
 	j newloc 
  
 goquit: 
 	la $a0, qp 
 	li $v0, 4 
 	syscall 
  
 	jr $ra 
  
 outofbounds: 
 	la $a0, bound 
 	li $v0, 4 
 	syscall 
  
 	j newloc 
  
 return: 
 	jr $ra 
  
