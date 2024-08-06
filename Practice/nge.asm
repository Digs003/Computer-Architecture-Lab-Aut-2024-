# copilot: disable
.data
array: .space 20
msg: .asciiz "Enter 5 integers: "
arrow: .asciiz " -> "
stack: .space 20

.text 
.globl main
main:
    la $a0,msg
    li $v0,4
    syscall
    li $s0,5
    jal get_array
    jal printNGE
    li $v0,10
    syscall

get_array:
    li $t0,0
    loop:
        beq $t0,5,end_loop
        li $v0,5
        syscall
        sll $t1,$t0,2
        sw $v0,array($t1)
        addi $t0,$t0,1
        j loop
    end_loop:
        jr $ra

printNGE:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    li $t0,0#stack size
    li $t1,0#i
    sll $t2,$t1,2
    lw $t3,array($t2)
    move $a0,$t0
    move $a1,$t3
    jal stackPush
    addi $t0,$t0,1
    addi $t1,$t1,1
    loopNGE:
        bge $t1,$s0,end_loop_NGE
        beq $t0,$zero,pushandloop
        j while
    pushandloop:
        sll $t2,$t1,2
        move $a0,$t0
        lw $a1,array($t2)
        jal stackPush
        addi $t0,$t0,1
        addi $t1,$t1,1
        j loopNGE
    while:
        beq $t0,$zero,pushandloop
        sll $t2,$t0,2
        addi $t2,$t2,-4
        lw $t4,stack($t2)
        sll $t2,$t1,2
        lw $t5,array($t2)
        bge $t4,$t5,pushandloop
        jal print
        addi $t0,$t0,-1#Pop
        j while
    print:
        sll $t2,$t0,2
        addi $t2,$t2,-4
        lw $a0,stack($t2)
        li $v0,1
        syscall
        la $a0,arrow
        li $v0,4
        syscall
        sll $t2,$t1,2
        lw $a0,array($t2)
        li $v0,1
        syscall
        li $a0,10
        li $v0,11
        syscall
        jr $ra
    end_loop_NGE:
        beq $t0,$zero,return
        sll $t2,$t0,2
        addi $t2,$t2,-4
        lw $a0,stack($t2)
        li $v0,1
        syscall
        la $a0,arrow
        li $v0,4
        syscall
        li $a0,-1
        li $v0,1
        syscall
        li $a0,10
        li $v0,11
        syscall
        addi $t0,$t0,-1
        j end_loop_NGE
    return:
        lw $ra,0($sp)
        addi $sp,$sp,4
        jr $ra



stackPush:
    sll $s1,$a0,2
    sw $a1,stack($s1)
    jr $ra