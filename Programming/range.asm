.data
msg: .asciz "Range: "
array: .word 10 12 6 8 45 3
.text
.globl main
main: 
	li t0,6 #size of array
	la t1,array	#address of array
	lw t2,0(t1)	#min value
	mv t3,t2	#max value
	addi t1,t1,4
	addi t0,t0,-1
	loop:
	      lw t5,0(t1)
	      blt t5,t2,change1
	      bgt t5,t3,change2
	incr: addi t1,t1,4
	      addi t0,t0,-1
	      bnez t0,loop
	      la a0,msg
	      li a7,4
	      ecall
	      sub t3,t3,t2
	      mv a0,t3
	      li a7,1
	      ecall
	      li a7,10
	      ecall
	change1: mv t2,t5
		 j incr
	change2: mv t3,t5
		 j incr
