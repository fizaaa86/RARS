.data
arr: .word 1 3 5 7 9 11 15
str1: .asciz "Enter key value: "
str2: .asciz "The key found at: "
.text
.globl main
main:
	la s0,arr #s0=array address
	li t1,0 #copy starting address
	li t2,6 #ending index
	la a0,str1
	li a7,4
	ecall
	li a7,5
	ecall
	mv t3,a0
	jal bs
	mv t4,a0
	la a0,str2
	li a7,4
	ecall
	mv a0,t4
	li a7,1
	ecall
	
	li a7,10
	ecall

bs:
	addi sp,sp,-4
	sw ra,0(sp)
	
	bgt t1,t2,not_found
	
	add t0,t1,t2
	srai t0,t0,1 #t0=t1+t2/2
	mv t4,t0
	slli t4,t4,2 #t4*4
	add t4,s0,t4 #address of mid
	lw t4,0(t4) #value of mid
	beq t4,t3,found
	bgt t4,t3,search_left
	blt t4,t3,search_right
	
	found: mv a0,t0
		j restore
	search_left: addi t0,t0,-1
		     mv t2,t0
		     jal bs
		     j restore
	search_right: addi t0,t0,1
		     mv t1,t0
		     jal bs
		     j restore
	not_found:
		    li a0,-1
	restore:    lw ra,0(sp)
		    addi sp,sp,4
		    ret
	
	