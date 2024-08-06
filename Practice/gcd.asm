 .data 
	msg_1:
		.asciiz "Enter first Number (Non Negative): "
	msg_2:
		.asciiz "Enter second Number (Non Negative): "
	error_msg:
		.asciiz "Invalid Number!! "
	output_msg:
		.asciiz "GCD of given two numbers is : "

.text
.globl main
main:
    la $a0, msg_1
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s0,$v0

    la $a0, msg_2
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s1,$v0

    add $a0,$s0,$zero
    add $a1,$s1,$zero
    jal find_gcd
    move $s0,$v0
    la $a0,output_msg
    li $v0,4
    syscall
    move $a0,$s0
    li $v0,1
    syscall
    li $v0,10
    syscall




find_gcd:
    addi $sp,$sp,-12
    sw $ra,0($sp)
    sw $a0,4($sp)
    sw $a1,8($sp)
    beq $a1,$zero,returna
    div $a0,$a1
    move $a0,$a1
    mfhi $a1
    jal find_gcd
    lw $ra,0($sp)
    lw $a0,4($sp)
    lw $a1,8($sp)
    addi $sp,$sp,12
    jr $ra
    returna:
        move $v0,$a0
        addi $sp,$sp,12
        jr $ra


    