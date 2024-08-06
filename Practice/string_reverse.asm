.data
input: .space 101
inputsize: .word 100
msg: .asciiz "Enter a string: "
msg2: .asciiz "Reversed string is: "

.text
.globl main
main:
    la $a0,msg
    li $v0,4
    syscall
    li $v0,8
    la $a0,input
    lw $a1,inputsize
    syscall
    la $a0,msg2
    li $v0,4
    syscall
    li $t1,0
    lb $a0,input($t1)
    jal reverse
    j exit

reverse:
    beq $a0,$zero,return
    addi $sp,$sp,-8
    sw $ra,0($sp)
    sb $a0,4($sp)
    addi $t1,$t1,1
    lb $a0,input($t1)
    jal reverse
    lb $a0,4($sp)
    li $v0,11
    syscall
return:
    lb $a0,4($sp)
    lw $ra,0($sp)
    addi $sp,$sp,8
    jr $ra

exit:
    li $v0,10
    syscall


