.data
msg: .asciz "Type ENTER to QUIT \n"
.text
.globl main
main:
	la a0,msg
	li a7,4
	ecall
	
	li t0,10 #ascii for enter
	li s0,32 #ascii for space
	li t4,0 #word count
	read_loop:
	li t1,0xFFFF0000 #keyboard control
	wait_a:
		lb t2,0(t1)
		beqz t2,wait_a
	li t1,0xFFFF0004	#keyboard data
	lb t3,0(t1)
	bne t3,s0,check
	addi t4,t4,1
	check:beq t0,t3,exit
	j read_loop
	li t6,0 #digit count
	mv s1,t4
	exit:addi t4,t4,1
	extract_digit:
		rem t5,t4,t0
		div t4,t4,t0
		addi sp,sp,-4 #push to stack
		sw t5,0(sp)
		addi t6,t6,1
		bnez t4,extract_digit
		
	print_loop:
		li t1,0xFFFF0008 #display control
		wait_b:
			lb t2,0(t1)
			beqz t2,wait_b
		li t1,0xFFFF000C #display data
		lb t5,0(sp)
		addi sp,sp,4
		addi t5,t5,48
		sb t5,0(t1)
		addi t6,t6,-1
		bnez t6,print_loop
	mv a0,s1
	li a7,1
	ecall
	li a7,10
	ecall
	
 	