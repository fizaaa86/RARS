.data
history_b_1: .word  1,0,1,1,0,1,0,0,1,1
history_size: .word 10
BHT: .word 1,1,1,1,1,1,1,1,
	    1,1,1,1,1,1,1,1,
	    1,1,1,1,1,1,1,1,
	    1,1,1,1,1,1,1,1
msg: .asciz "Branch 1 prediction: "	
.text
main:
	la s0,BHT #starting address og BHT
	la s1,history_b_1 #address of A
	la s2,history_size #address of N
	lw s2,0(s2) #size of N
	
	li t0,16 #pc value =10
	li t1,0 #counter
	li t3,0 #GHR=0
	li s5,2 #comparison
	li s6,0 #pi
	li s9,3 #comparison
	la a0,msg
	li a7,4
	ecall
	loop:
		andi t2,t0,0xF #t2=pc_low4
		slli t2,t2,1 # t2=pc_low4<<1
		andi s8,t3,1 #t3=GHR&1
		or t4,t2,s8 #t4 = pc_low4<<1 | GHR&1
		andi t5,t4,0x1F #idx = t5
		slli t6,t5,2 #t6=t5*4
		add s3,s0,t6 #s3 = address of bht+idx*4
		lw s4,0(s3) #s4 = BHT[idx],s3 points to bht[idx]
		bge s4,s5,update
		li s6,0
		predict:mv a0,s6
		li a7,1
		ecall #print p[i]
		li a0,32
		li a7,11
		ecall
		check:lw s7,0(s1) #a[i]
		#assuming for A[i]=1 as default
		beqz s7,decr
		addi s4,s4,1 #BHT[idx]+1
		ble s4,s9,GHR
		li s4,3
		GHR:sw s4,0(s3) 
		slli t3,t3,1
		or t3,t3,s7 #GHR<<1 | A[i]
		andi t3,t3,1  #GHR<<1 | A[i] &1
		addi t1,t1,1
		addi s1,s1,4
		blt t1,s2,loop
	li a7,10
	ecall
	update: li s6,1
		j predict
	decr: addi s4,s4,-1 #s8 = BHT[idx]-1
	      blt s4,zero,to_zero
	      sw s4,0(s3)
	      j GHR
	 to_zero: li s4,0
	 	sw s4,0(s3)
	 	j GHR
	 	
	
		
		
		
	
	