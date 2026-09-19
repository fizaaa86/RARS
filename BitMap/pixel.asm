.data
	WIDTH: .word 512
	HEIGHT: .word 256
.text
.globl main
main:
	li t0,0x10010000 #frame buffer base address
	li t1,150 #y=10
	lw t2,WIDTH #t2 = width
	mul t1,t2,t1 #t1= t1*t2 ie y=y*width
	lw t2,HEIGHT #t2 = height
	add t1,t1,t2 #t1 = y*width+x
	slli t1,t1,2 #4*(y*width+x)
	add t0,t0,t1 #address 
	li t3,0x0000FF00 #GREEN
	sw t3,0(t0)
	
	li a7,10
	ecall