.data
msg_input: .asciiz "Enter 8 integers: "
array: .space 32
tmp: .space 48
msg_sort:   .asciiz "\nThe sorted array is:. "
msg_unsort:   .asciiz "The unsorted array is: "

.text
.globl main
main:
    jal get_array
    la $a0, msg_unsort
    li $v0, 4
    syscall
    jal print_array
    add $a0, $zero, $zero
    add $a1, $zero, 7
    jal merge_sort
    la $a0, msg_sort
    li $v0, 4
    syscall
    jal print_array
    j exit

   
get_array:
    la $a0, msg_input
    li $v0, 4
    syscall
    add $t0, $zero, $zero
    loop:
        beq $t0, 32, end_loop
        li $v0, 5
        syscall
        sw $v0, array($t0)
        addi $t0, $t0, 4
        j loop
    end_loop:
        jr $ra

print_array:
    add $t0, $zero, $zero
    loop2:
        beq $t0, 32, end_loop2
        lw $a0, array($t0)
        li $v0, 1
        syscall
        li $a0,32
        li $v0, 11
        syscall
        addi $t0, $t0, 4
        j loop2
    end_loop2:
        jr $ra

merge_sort:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    blt $a0, $a1, lab1
    addi $sp, $sp, 16
    jr $ra
    lab1:
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        srl $t3, $a0, 2
        srl $t4, $a1, 2
        add $a2, $t3, $t4
        sll $a2, $a2, 1
        sw $a2, 12($sp)
        move $a1,$a2
        jal merge_sort
        lw $a2, 12($sp)
        lw $a1, 8($sp)
        move $a0, $a2
        jal merge_sort
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        lw $a2, 12($sp)
        jal merge
        lw $ra, 0($sp)
        addi $sp,$sp,16
        jr $ra

merge:
    move $s0,$a0
    move $s1,$a1
    move $s2,$a2
    addi $s3,$s2,4
    



exit:
    li $v0, 10
    syscall