.data
newline: .byte 10

.text
.globl main

main:
    li s0, 0              # character count (X position)
    li s1, 0              # row number (Y = 0)

########################################
# READ + ECHO LOOP
########################################
########################################
# INITIALIZE DISPLAY (IMPORTANT)
########################################

    li t0, 0              # X = 0
    slli t0, t0, 20

    li t1, 0              # Y = 0
    slli t1, t1, 8

    or t0, t0, t1
    ori t0, t0, 7         # ASCII BEL

init_wait:
    li t2, 0xFFFF0008
    lw t3, 0(t2)
    andi t3, t3, 1
    beqz t3, init_wait

    li t2, 0xFFFF000C
    sw t0, 0(t2)

read_loop:

# ---- wait for key ----
wait_key:
    li t0, 0xFFFF0000
    lw t1, 0(t0)
    andi t1, t1, 1
    beqz t1, wait_key

# ---- read character (clears ready bit) ----
    li t0, 0xFFFF0004
    lw t2, 0(t0)

# ENTER ?
li t3, 10
beq t2, t3, rewrite_last   # jump BEFORE increment
li t3, 8
beq t2, t3, do_backspace


########################################
# ECHO CHARACTER
########################################

disp_wait1:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, disp_wait1

    li t4, 0xFFFF000C
    sw t2, 0(t4)

    addi s0, s0, 1      # increment ONLY for printed chars
    j read_loop


########################################
# MOVE CURSOR + OVERWRITE LAST CHAR
########################################
########################################
# BACKSPACE HANDLING
########################################
do_backspace:

    beqz s0, read_loop      # nothing to erase if at start

    addi s0, s0, -1         # move one position left

# ----- move cursor to new X -----
    mv t0, s0
    slli t0, t0, 20

    mv t1, s1
    slli t1, t1, 8

    or t0, t0, t1
    ori t0, t0, 7           # ASCII BEL

disp_wait_bs1:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, disp_wait_bs1

    li t4, 0xFFFF000C
    sw t0, 0(t4)

# ----- overwrite with SPACE -----
disp_wait_bs2:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, disp_wait_bs2

    li t6, ' '
    li t4, 0xFFFF000C
    sw t6, 0(t4)

# ----- move cursor LEFT again -----
    mv t0, s0
    slli t0, t0, 20

    mv t1, s1
    slli t1, t1, 8

    or t0, t0, t1
    ori t0, t0, 7

disp_wait_bs3:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, disp_wait_bs3

    li t4, 0xFFFF000C
    sw t0, 0(t4)

    j read_loop


rewrite_last:

    addi s0, s0, -1       # go to last character position

# ----- build ASCII 7 command -----
# bits 20–31 = X
# bits 8–19  = Y
# bits 0–7   = 7

    mv t0, s0
    slli t0, t0, 20       # X << 20

    mv t1, s1
    slli t1, t1, 8        # Y << 8

    or t0, t0, t1
    ori t0, t0, 7         # ASCII BEL

# wait display ready
disp_wait2:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, disp_wait2

# send cursor move command
    li t4, 0xFFFF000C
    sw t0, 0(t4)

########################################
# PRINT 'P' OVER LAST CHARACTER
########################################

disp_wait3:
    li t4, 0xFFFF0008
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, disp_wait3

    li t6, 'P'
    li t4, 0xFFFF000C
    sw t6, 0(t4)

end:
    j end
