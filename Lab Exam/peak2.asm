.data
array: .word  3,7,5,5,2,9,9,9,10,5
len: .word 10
.text
.globl main
main:
	la s0,array
	la t0,len
	lw s1,0(t0) #len
	mv a0,s1 #a0=len
	li a7,9
	ecall
	mv s2,a0 #address of the ans array
	li t0,0 #i-1
	li t1,1 # i
	li t2,2 #i+1
	li t6,'X'
	li s5,'P'
	li s6,'V'
	mv a0,t6
	li a7,11
	ecall

	outer:
		slli t3,t0,2 #t0*4
		add t3,s0,t3 #add of i-1
		lw t3,0(t3)#a[i-1]
		slli t4,t1,2 #t1*4
		add t4,s0,t4 #add of i
		lw t4,0(t4)#a[i-1]
		slli t5,t2,2 #t2*4
		add t5,s0,t5 #add of i+1
		lw t5,0(t5)#a[i+1]
		#t3=a[i-1] t4=a[i] t5 = a[i+1]
		blt t4,t3,valley
		bgt t4,t5,peak
		else:mv a0,t6
		li a7,11
		ecall
		inc:
		addi t0,t0,1
		addi t1,t1,1
		addi t2,t2,1
		blt t2,s1,outer
	mv a0,t6
	li a7,11
	ecall
	exit: li a7,10
		ecall
		
	valley:
		blt t4,t5,val
		j else
		val:mv a0,s6
		li a7,11
		ecall
		j inc
		
	peak:
		bgt t4,t3,pea
		j else
		pea:mv a0,s5
		li a7,11
		ecall
		j inc
		
		
		
		
