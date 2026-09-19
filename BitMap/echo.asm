.data
msg: .asciz "Type (ENTER to quit):\n"

.text
.globl main
main:

# print prompt
la a0, msg
li a7, 4
ecall

li t0, 10          # ENTER ASCII

read_loop:

# wait keyboard ready
li t1, 0xFFFF0000
wait_k:
lb t2, 0(t1)
beqz t2, wait_k

# read char
li t1, 0xFFFF0004
lb t3, 0(t1)
beq t3, t0, exit

# wait display ready
li t1, 0xFFFF0008
wait_d:
lb t2, 0(t1)
beqz t2, wait_d

# print char
li t1, 0xFFFF000C
sb t3, 0(t1)

j read_loop

exit:
li t1, 0xFFFF0008
wait_m:
lb t2, 0(t1)
beqz t2, wait_m
li t3,10
li t1, 0xFFFF000C
sb t3, 0(t1)
li t1, 0xFFFF0008
wait_b:
lb t2, 0(t1)
beqz t2, wait_b
li t1, 0xFFFF000C
li t5,60
sb t5,0(t1)
li t1, 0xFFFF0008
wait_last:
lb t2, 0(t1)
beqz t2, wait_last
li a7, 10
ecall