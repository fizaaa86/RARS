.data
str: .string "AAA BB CCCC DDDDD EE FFF GGGG H I LLL XX YYY ZZ"

.text
.globl main

main:
    # ----------------------------------
    # String setup
    # ----------------------------------
    la t0, str            # t0 = current char pointer
    addi t1, t0, 47       # t1 = end address (47 chars, no '\0')

    li s1, 65             # 'A'
    li s2, 90             # 'Z'

    # ----------------------------------
    # Allocate histogram array (26 words)
    # ----------------------------------
    li a0, 104            # 26 * 4 bytes
    li a7, 9              # sbrk syscall
    ecall

    mv s0, a0             # s0 = base address of array

    # ----------------------------------
    # Initialize array to zero
    # ----------------------------------
    mv t6, s0
    li t5, 26

zero_loop:
    sw zero, 0(t6)
    addi t6, t6, 4
    addi t5, t5, -1
    bnez t5, zero_loop

    # ----------------------------------
    # Histogram counting loop
    # ----------------------------------
count_loop:
    lb t3, 0(t0)          # load character

    blt t3, s1, skip     # if < 'A'
    bgt t3, s2, skip     # if > 'Z'

    addi t4, t3, -65     # index = char - 'A'
    slli t4, t4, 2       # index * 4 (word offset)
    add t6, s0, t4       # address of hist[index]

    lw t7, 0(t6)
    addi t7, t7, 1
    sw t7, 0(t6)

skip:
    addi t0, t0, 1
    bne t0, t1, count_loop

    # ----------------------------------
    # Print histogram
    # ----------------------------------
    mv t6, s0
    li t5, 26

print_loop:
    lw a0, 0(t6)
    li a7, 1              # print integer
    ecall

    li a0, 32             # print space
    li a7, 11
    ecall

    addi t6, t6, 4
    addi t5, t5, -1
    bnez t5, print_loop

    # ----------------------------------
    # Exit
    # ----------------------------------
    li a7, 10
    ecall

         print: mv t6,s0
                lw a0,0(t6)
                li a7,1
                ecall
                li a0,32
                li a7,11
                ecall
                addi t6,t6,4
                addi t5,t5,-1
                bnez t5,print
	          
	 li a7,10
	 ecall
	
	      	     
	
