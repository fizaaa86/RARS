.data
str: .asciz "Type (ENTER to quit): \n"
.text
.globl main
main:
	la a0,str
	li a7,4
	ecall
	
	li t0,10 #ascii
	li t6,0 #counter
	read_loop:
	li t1,0xFFFF0000 #keyboard control
	wait_r:
		lb t2,0(t1)
		beqz t2,wait_r
	li t1,0xFFFF0004 #keyboard data
	lb t3,0(t1) #read ascii
	beq t3,t0,exit
	addi t6,t6,1
	
	li t1,0xFFFF0008 #display control
	wait_d:
		lb t2,0(t1)
		beqz t2,wait_d
	li t1,0xFFFF000C #display data
	sb t3,0(t1)
	
	j read_loop
	
	exit: #print new line
	li t1,0xFFFF0008 #display control
	li t3,10
	wait_f:
		lb t2,0(t1)
		beqz t2,wait_f
	li t1,0xFFFF000C #display data
	sb t3,0(t1)
	  
	li t4,0 #t0 already has 10
	extract_digit:
		rem t5,t6,t0 #t5 = t6%t0
		addi sp,sp,-4 #push operation
		sw t5,0(sp)
		div t6,t6,t0 #t6=t6/t0
		addi t4,t4,1 #count of digits
		bnez t6,extract_digit
	print_num:
		li t1,0xFFFF0008 #display control
	wait_e:
		lb t2,0(t1)
		beqz t2,wait_e
	li t1,0xFFFF000C #display data
	lw t5,0(sp)
	addi sp,sp,4
	addi t5,t5,48
	sb t5,0(t1)
	addi t4,t4,-1
	bnez t4,print_num
		
	mv a0,t6

	li a7,10
	ecall
		
	