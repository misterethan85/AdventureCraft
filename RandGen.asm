	.text

li $a1, 9 #set parameters  

li $v0, 42  #get number

syscall

#add $a0, $a0, 0  #add the lowest bound

li $v0, 1   #print
syscall	#exit 

