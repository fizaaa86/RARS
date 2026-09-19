.data
.text
.globl main

main:
    li s0, 0          # cursor X
    li s1, 0          # cursor Y

########################################
# INITIALIZE DISPLAY
########################################
    li t0, 0
    slli t0, t0, 20
    li t1, 0
    slli t1, t1, 8
    or t0, t0, t1
    ori t0, t0, 7

init_wait:
    li t2, 0xFFFF0008
    lw t3, 0(t2)
    andi t3, t3, 1
    beqz t3, init_wait

    li t2, 0xFFFF000C
    sw t0, 0(t2)

########################################
# MAIN INPUT LOOP
########################################
read_loop:

# wait key
wait_key:
    li t0, 0xFFFF0000
    lw t1, 0(t0)
    andi t1, t1, 1
    beqz t1, wait_key

# read char
    li t0, 0xFFFF0004
    lw t2, 0(t0)

########################################
# ENTER → finish input
########################################
    li t3, 10
    beq t2, t3, done

########################################
# BACKSPACE
########################################
    li t3, 8
    beq t2, t3, do_backspace

########################################
# NORMAL CHARACTER PRINT
########################################
disp_wait1:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, disp_wait1

    li t4, 0xFFFF000C
    sw t2, 0(t4)

    addi s0, s0, 1
    j read_loop

########################################
# BACKSPACE ROUTINE
########################################
do_backspace:
    beqz s0, read_loop

    addi s0, s0, -1

# move cursor left
    mv t0, s0
    slli t0, t0, 20
    mv t1, s1
    slli t1, t1, 8
    or t0, t0, t1
    ori t0, t0, 7

wait_bs1:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, wait_bs1

    li t4, 0xFFFF000C
    sw t0, 0(t4)

# overwrite with space
wait_bs2:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, wait_bs2

    li t6, ' '
    li t4, 0xFFFF000C
    sw t6, 0(t4)

# reposition cursor again
    mv t0, s0
    slli t0, t0, 20
    mv t1, s1
    slli t1, t1, 8
    or t0, t0, t1
    ori t0, t0, 7

wait_bs3:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, wait_bs3

    li t4, 0xFFFF000C
    sw t0, 0(t4)

    j read_loop

########################################
# DONE
########################################
done:
    j done
