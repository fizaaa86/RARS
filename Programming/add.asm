.data
msg: .asciz "Sum = "
.text
.globl main

main:
    li a0, 5        # load 5 into a0
    li a1, 10       # load 10 into a1
    add a2, a0, a1  # a2 = a0 + a1

    # print string
    la a0, msg
    li a7, 4
    ecall

    # print integer
    mv a0, a2
    li a7, 1
    ecall

    # exit
    li a7, 10
    ecall
