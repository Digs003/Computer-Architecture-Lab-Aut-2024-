# Binary Search

.data
    in1:  .asciiz "Enter 8 integers in an array(non-decreasing): "
    in2:  .asciiz "Enter the number to search: "
    msg1: .asciiz "Initial check passed. Array is sorted."
    msg2: .asciiz "Element found at index: "
    invalid: .asciiz "Array is not in non-decreasing order"
    array: .space 32

.text
.globl main
main:
    jal get_array
    jal check_ascending
    li $a0, 10
    li $v0, 11
    syscall
    la $a0, msg1
    li $v0, 4
    syscall
    li $a0,10
    li $v0,11
    syscall
    jal bin_search
    j exit


get_array:
    add $t0, $zero, $zero
    la $a0, in1
    li $v0, 4
    syscall
    move $t1, $ra
    jal loop
    jr $t1

loop:
    beq $t0, 32, end_loop
    li $v0, 5
    syscall
    sw $v0, array($t0)
    addi $t0, $t0, 4
    j loop

end_loop:
    jr $ra

check_ascending:
    add $t0, $zero, $zero
    lw $a0, array($t0)
    Again:
        addi $t0, $t0, 4
        beq $t0, 32, valid
        lw $a1, array($t0)
        blt $a1, $a0, invalid
        move $a0, $a1
        j Again
    invalid:
        la $a0, invalid
        li $v0, 4
        syscall
        j exit
    valid:
        jr $ra


bin_search:
    la $a0, in2
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s0, $v0
    li $t0, 0   # Left
    li $t1, 28  # Right
    li $t2, -1

    bin_loop:
        bgt $t0, $t1, not_found
        srl $t3, $t0, 2
        srl $t4, $t1, 2 
        add $t5, $t3, $t4

        srl $t5, $t5, 1 # Mid
        sll $t5, $t5, 2
        lw $a1, array($t5)
        beq $a1, $s0, success
        blt $a1, $s0, inc_lo
        j dec_hi
    
    inc_lo:
        addi $t0, $t5, 4
        j bin_loop

    dec_hi:
        addi $t1, $t5, -4
        j bin_loop

    success:
        move $t2, $t5
        srl $t2, $t2, 2
        la $a0, msg_found
        li $v0, 4
        syscall
        move $a0, $t2
        li $v0, 1
        syscall
        j exit

    not_found:
        la $a0,msg_found
        li $v0,4
        syscall
        move $a0,$t2
        li $v0,1
        syscall

exit:
    li $v0, 10
    syscall