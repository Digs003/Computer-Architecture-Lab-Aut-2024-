.data
array:      .space 40
input_msg:  .asciiz "Enter 10 integers: \n"
heap_msg:   .asciiz "Max Heap: "

.text
.globl main

main:
    jal     get_array
    la      $s1, array
    j       build_heap

get_array:
    add     $t0, $zero, $zero
    la      $a0, input_msg
    li      $v0, 4
    syscall
    move    $t1, $ra
    jal     loop
    jr      $t1

    loop:
        beq     $t0, 40, end_loop
        li      $v0, 5
        syscall
        sw      $v0, array($t0)
        addi    $t0, $t0, 4
        j       loop

    end_loop:
        jr      $ra

build_heap:
    li     $t0, 4

    heap_loop:
        blt     $t0, 0, end_build
        move    $a0, $t0
        jal     heapify
        addi    $t0, $t0, -1
        j       heap_loop

    end_build:
        # jr      $ra
        j       print_array


heapify:
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)
    move    $s0, $a0
    sll     $t1, $a0, 1
    addi    $t1, $t1, 1       # Left child index
    addi    $t2, $t1, 1       # Right child index

    check_left:
        li      $t3, 10
        bge     $t1, $t3, check_right
        sll     $t4, $s0, 2
        add     $t4, $t4, $s1
        lw      $t5, 0($t4)       # Parent value
        sll     $t6, $t1, 2
        add     $t6, $t6, $s1
        lw      $t7, 0($t6)       # Left child value
        ble     $t7, $t5, check_right
        move    $s0, $t1

    check_right:
        bge     $t2, $t3, compare
        sll     $t8, $s0, 2
        add     $t8, $t8, $s1
        lw      $t5, 0($t8)       # Parent value
        sll     $t9, $t2, 2
        add     $t9, $t9, $s1
        lw      $t7, 0($t9)       # Right child value
        ble     $t7, $t5, compare
        move    $s0, $t2

    compare:
        beq     $s0, $a0, heapify_return
        sll     $t4, $a0, 2
        add     $t4, $t4, $s1
        lw      $t5, 0($t4)       # Parent value
        sll     $t6, $s0, 2
        add     $t6, $t6, $s1
        lw      $t7, 0($t6)       # Child value
        sw      $t7, 0($t4)       # Swap values
        sw      $t5, 0($t6)
        move    $a0, $s0
        jal     heapify

    heapify_return:
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra

print_array:
    la      $a0, heap_msg
    li      $v0, 4
    syscall
    add     $t0, $zero, $zero

    print_loop:
        beq     $t0, 40, end_print
        lw      $a0, array($t0)
        li      $v0, 1
        syscall
        li      $a0, 32
        li      $v0, 11
        syscall
        addi    $t0, $t0, 4
        j       print_loop

    end_print:
        j       exit

    exit:
        li      $v0, 10
        syscall
