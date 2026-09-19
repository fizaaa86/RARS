.data
	WIDTH: .word 512
.text
.globl main
main:
	li t0,5#start_X
	li t1,50,#length
	li t2,150 #y
	la t3,WIDTH
	lw t3,0(t3) #width
	mul t3,t3,t2 #t3=y*width
	li t5,0 #counter
	li s0,0x00FF0000 #RED
	draw_line:
		li t4,0x10010000 #frame buffer address
		add t6,t0,t5 #x+i
		add t2,t3,t6 #y*width + x+i
		slli t2,t2,2 #t2=4(y*width+x+i)
		add t4,t4,t2 #address
		sw s0,0(t4)
		addi t5,t5,1 #i++
		bne t5,t1,draw_line
	li a7,10
	ecall