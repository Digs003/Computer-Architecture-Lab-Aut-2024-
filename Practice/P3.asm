# SORTING AN ARRAY

.data
array: .word 1000, 100, 10, 1
msg1: .asciiz "Sorted array: "
n: .word 4

.text
main:
    lw $s0, n
    la $s5, array
    li $t1, 0

loop:
    bge $t1, $s0, output
    li $t2, 0

inner_loop:
    sub $t4, $s0, $t1
    addi $t4, $t4, -1
    bge $t2, $t4, inc1

    move $t6, $s5
    sll $t7, $t2, 2
    add $t6, $t6, $t7

    lw $s1, 0($t6)
    lw $s2, 4($t6)
    bgt $s1, $s2, swap
    j no_swap

swap:
    sw $s1, 4($t6)
    sw $s2, 0($t6)

no_swap:
    addi $t2, $t2, 1
    j inner_loop

inc1:
    addi $t1, $t1, 1
    j loop

output:
    la $a0, msg1
    li $v0, 4
    syscall
    li $t2, 0
    la $t1, array

print_loop:
    bge $t2, $s0, end_print_loop
    sll $t3, $t2, 2
    add $t4, $t1, $t3
    lw $a0, 0($t4)
    li $v0, 1
    syscall
    li $a0, 32
    li $v0, 11
    syscall 
    addi $t2, $t2, 1
    j print_loop

end_print_loop:
    li $a0, 10
    li $v0, 11 
    syscall
    li $v0, 10
    syscall



