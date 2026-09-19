.data
msg: .asciz "Sum = "
array: .word 10,20,30,40
.text
.globl main
main:
	la t0,array
	li t1,0
	li t2 4
	li t6,0
	loop: 
		beq t1,t2,end
		slli t3,t1,2
		mv t4,t0
		add t4,t4,t3
		lw t5,0(t4)
		add t6,t6,t5
		addi t1,t1,1
		j loop
	end:
		la a0,msg
		li a7,4
		ecall
		mv a0,t6
		li a7,1
		ecall 
