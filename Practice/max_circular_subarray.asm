.data
array: .space 32
msg1: .asciiz "Enter 8 integers: "

.text 
.globl main
main:
    la $a0,msg1
    li $v0,4
    syscall
    jal get_array
    jal max_subarray_sum
    move $s1,$v0#max_subarray_sum
    jal multiplyminus
    jal max_subarray_sum
    move $s2,$v0
    mul $s2,$s2,-1#min_subarray_sum
    # move $a0,$s2
    # li $v0,1
    # syscall
    sub $s3,$s0,$s2
    bgt $s3,$s1,returns3
    move $a0,$s1
    li $v0,1
    syscall
    j exit
    returns3:
        move $a0,$s3
        li $v0,1
        syscall
    j exit
   

get_array:
    li $t0,0
    li $s0,0#sum
    loop:
        beq $t0,8,end_loop
        sll $t2,$t0,2
        li $v0,5
        syscall
        sw $v0,array($t2)
        add $s0,$s0,$v0
        addi $t0,$t0,1
        j loop
    end_loop:
        jr $ra

max_subarray_sum:
    li $t0,0#i
    li $t1,0#max_sum
    li $t2,0#curr_sum
    loop2:
        beq $t0,8,end_loop2
        sll $t4,$t0,2
        lw $t3,array($t4)
        add $t2,$t2,$t3
        bge $t2,$t3,lab
        move $t2,$t3
        lab:
            blt $t1,$t2,lab2
            j continue_loop2
        lab2:
            move $t1,$t2
        continue_loop2:
            addi $t0,$t0,1
            j loop2
    end_loop2:
        move $v0,$t1
        jr $ra

multiplyminus:
    li $t0,0
    loop3:
        beq $t0,8,end_loop3
        sll $t2,$t0,2
        lw $t5,array($t2)
        mul $t5,$t5,-1
        sw $t5,array($t2)
        addi $t0,$t0,1
        j loop3
    end_loop3:
        jr $ra

exit:
    li $v0,10
    syscall