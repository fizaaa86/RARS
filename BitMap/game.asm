.data
WIDTH:  .word 512
HEIGHT: .word 256
COLOR:  .word 0x00FF0000      # Red
BLACK:  .word 0x00000000      # Black

.text
.globl main

########################################
# MAIN
########################################
main:

    # Load width into s0 (used by draw_rect)
    la s0, WIDTH
    lw s0, 0(s0)

    li s1, 100        # x position
    li s2, 100        # y position

game_loop:

########################################
# Wait for key press (MMIO)
########################################
    li t0, 0xFFFF0000
wait_key:
    lb t1, 0(t0)
    beqz t1, wait_key

    li t0, 0xFFFF0004
    lb t2, 0(t0)

########################################
# Clear screen
########################################
    jal ra, clear_screen

########################################
# Movement logic
########################################
    li t3, 'w'
    beq t2, t3, move_up

    li t3, 's'
    beq t2, t3, move_down

    li t3, 'a'
    beq t2, t3, move_left

    li t3, 'd'
    beq t2, t3, move_right

    j draw_rect_call

move_up:
    addi s2, s2, -5
    j draw_rect_call

move_down:
    addi s2, s2, 5
    j draw_rect_call

move_left:
    addi s1, s1, -5
    j draw_rect_call

move_right:
    addi s1, s1, 5

########################################
# Call draw_rect
########################################
draw_rect_call:
    mv a0, s1        # x
    mv a1, s2        # y
    li a2, 20        # length
    li a3, 20        # breadth
    la t0, COLOR
    lw a4, 0(t0)     # color
    jal ra, draw_rect

    j game_loop


########################################
# DRAW_RECT FUNCTION
# a0 = x
# a1 = y
# a2 = length
# a3 = breadth
# a4 = color
########################################
draw_rect:

    li t5, 0              # row counter

row_loop:
    bge t5, a3, done_rect

    add t6, a1, t5        # current_y = y + i
    mul t6, t6, s0        # (y+i) * width

    li t4, 0              # column counter

col_loop:
    bge t4, a2, next_row

    li t0, 0x10010000     # framebuffer base

    add t1, a0, t4        # current_x = x + j
    add t1, t1, t6        # index
    slli t1, t1, 2        # *4
    add t0, t0, t1

    sw a4, 0(t0)

    addi t4, t4, 1
    j col_loop

next_row:
    addi t5, t5, 1
    j row_loop

done_rect:
    ret


########################################
# CLEAR SCREEN FUNCTION
########################################
clear_screen:

    li t0, 0x10010000     # framebuffer base

    la t1, WIDTH
    lw t1, 0(t1)

    la t2, HEIGHT
    lw t2, 0(t2)

    la t3, BLACK
    lw t3, 0(t3)

    mul t4, t1, t2        # total pixels
    li t5, 0

clear_loop:
    bge t5, t4, clear_done

    sw t3, 0(t0)
    addi t0, t0, 4
    addi t5, t5, 1
    j clear_loop

clear_done:
    ret
