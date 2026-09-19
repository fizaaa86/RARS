.data
msg: .asciz "fiza"
.text
.globl main
main:
	la t0,msg
	li t2,0
	loop:
		lb t1,0(t0)
		beq t1,x0,rev
		addi t2,t2,1
		addi t0,t0,1
		j loop
	rev:
		la t0,msg
		addi t2,t2,-1
		loop1:
			blt t2,x0,end
			mv t3,t0
			add t3,t3,t2
			lb a0,0(t3)
			li a7 11
			ecall
			addi t2,t2,-1
			j loop1
		end:
			li a7 10
			ecall