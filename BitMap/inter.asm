.data
WIDTH:  .word 512
HEIGHT: .word 256
COLOR:  .word 0x00FF0000
BLACK:  .word 0x00000000
RECT_W: .word 60
RECT_H: .word 20

.text
.globl main
main:
    la s0, WIDTH
    lw s0, 0(s0)            # s0 = 512
    li s1, 100              # x
    li s2, 100              # y
    la t0, RECT_W
    lw s3, 0(t0)            # s3 = 60  (reload from memory — safe)
    la t0, RECT_H
    lw s4, 0(t0)            # s4 = 20
    la t0, COLOR
    lw s8, 0(t0)            # s8 = color (safe, callee-saved)
    jal draw_rect

loop:
    li t0, 0xFFFF0000
wait_key:
    lb t1, 0(t0)
    beqz t1, wait_key

    li t0, 0xFFFF0004
    lb t2, 0(t0)

    li t3, 'w'
    beq t2, t3, move_up
    li t3, 's'
    beq t2, t3, move_down
    li t3, 'a'
    beq t2, t3, move_left
    li t3, 'd'
    beq t2, t3, move_right
    j loop

move_up:
    addi s2, s2, -35
    blt s2, zero, clamp_top     # don't go above y=0
    j redraw
clamp_top:
    li s2, 0
    j redraw

move_down:
    addi s2, s2, 35
    j redraw

move_left:
    addi s1, s1, -35
    blt s1, zero, clamp_left
    j redraw
clamp_left:
    li s1, 0
    j redraw

move_right:
    addi s1, s1, 35
    j redraw

redraw:
    jal clear_screen
    jal draw_rect
    j loop

# --- clear_screen ---
clear_screen:
    addi sp, sp, -4
    sw ra, 0(sp)
    li t0, 0x10010000
    li t1, 512
    li t2, 256
    mul t3, t1, t2          # 131072 pixels
    li t4, 0                # BLACK
    li t5, 0
clear_loop:
    bge t5, t3, clear_done
    sw t4, 0(t0)
    addi t0, t0, 4
    addi t5, t5, 1
    j clear_loop
clear_done:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# --- draw_rect ---
draw_rect:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw s5, 12(sp)
    sw s6, 8(sp)
    sw s7, 4(sp)
    sw s8, 0(sp)

    li t5, 0
row_loop:
    bge t5, s4, done
    li t4, 0x10010000
    add s5, s2, t5
    mul s5, s5, s0
    li t6, 0
col_loop:
    bge t6, s3, next_row
    add s6, s1, t6
    add s7, s5, s6
    slli s7, s7, 2
    add s7, s7, t4
    sw s8, 0(s7)
    addi t6, t6, 1
    j col_loop
next_row:
    addi t5, t5, 1
    j row_loop
done:
    lw s8, 0(sp)
    lw s7, 4(sp)
    lw s6, 8(sp)
    lw s5, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    ret