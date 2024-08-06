# copilot: disable
.data
array: .space 20
msg: .asciiz "Enter 5 integers: "

.text 
.globl main
main:
    la $a0,msg
    li $v0,4
    syscall
    jal get_array
    jal sort
    jal print_array

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

sort:
    li $t0,0#i
    li $t1,0#j
    li $t2,4
    sort_loop:
        bge $t0,$t2,end_sort
        sub $t3,$t2,$t0
        inner_loop:      
            bge $t1,$t3,end_inner_loop
            sll $t4,$t1,2
            lw $s0,array($t4)
            addi $t4,$t4,4
            lw $s1,array($t4)
            bgt $s0,$s1,swap
            j lab
            swap:
                sw $s0,array($t4)
                addi $t4,$t4,-4
                sw $s1,array($t4)
            lab:
                addi $t1,$t1,1
                j inner_loop
        end_inner_loop:
            li $t1,0
            addi $t0,$t0,1
            j sort_loop
    end_sort:
        jr $ra

print_array:
    li $t0,0
    loop_:
        beq $t0,5,end_loop_
        sll $t1,$t0,2
        lw $a0,array($t1)
        li $v0,1
        syscall
        addi $t0,$t0,1
        j loop_
    end_loop_:
        jr $ra

