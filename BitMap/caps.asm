.data
msg: .asciz "sCHizOpHReNiA"
.text
.globl main
main:
	la t0,msg
	li t1,65
	li t2,90
	li t4,0
loop:lb t3,0(t0)
	beq t3,x0,end
	blt t3,t1,not_caps
	bgt t3,t2,not_caps
	addi t4,t4,1
	addi t0,t0,1
	j loop
not_caps:addi t0,t0,1
	j loop
end: mv a0,t4
     li a7,1
     ecall
     li a7,10
     ecall

	