.data
array: .space 40
input_msg: .asciiz "Enter 10 integers: "
heap_msg: .asciiz "Max Heap: "


.text
.globl main

main:
    jal get_array
    li $a0, 10
    li $v0, 11
    syscall
    j build_heap
    
get_array:
    add $t0, $zero, $zero
    la $a0, input_msg
    li $v0, 4
    syscall
    move $t1, $ra
    jal loop
    jr $t1

loop:
    beq $t0,40,end_loop
    li $v0, 5
    syscall
    sw $v0, array($t0)
    addi $t0, $t0, 4
    j loop

end_loop:
    jr $ra

build_heap:
    add $s0, $zero, $zero
    addi $s0, $s0, 4 #Startidx
    add $t0, $s0, $zero # counter i
    heap_loop:
        blt $t0, 0, end_heap
        add $a0, $t0, $zero 
        jal heapify
        addi $t0, $t0, -1
        j heap_loop
    end_heap:
        j print_array

heapify:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        move $s2, $a0  # s2 = index
        add $t1, $s2, $zero  # largest = index
        sll $t2, $s2, 1
        addi $t3, $t2, 1  # left = 2 * index + 1
        addi $t4, $t2, 2  # right = 2 * index + 2
        sll $s3,$s2,2
        lw $t5, array($s3)  # value at index
        
        blt $t3, 10, check_left
        j check_right
        
    check_left:
            sll $s4,$t3,2
            lw $t6, array($s4)  # value at left
            bgt $t6, $t5, update_left
            j check_right
            
    update_left:
            add $t1, $t3, $zero  # largest = left
            
    check_right:
            blt $t4, 10, check_right_value
            j compare_largest
            
    check_right_value:
            sll $s5,$t4,2
            lw $t7, array($s5)  # value at right
            sll $s3,$t1,2
            lw $t5, array($s3)  # value at largest
            bgt $t7, $t5, update_right
            j compare_largest
            
    update_right:
            add $t1, $t4, $zero  # largest = right
            
    compare_largest:
            bne $t1, $s2, swap
            j end_heapify
            
    swap:   
            sll $s3,$s2,2
            sll $s4,$t1,2
            lw $t8, array($s3)  # value at index
            lw $t9, array($s4)  # value at largest
            sw $t8, array($s4)  # array[largest] = value at index
            sw $t9, array($s3)  # array[index] = value at largest
            move $a0, $t1  # recursive call with largest
            jal heapify
            
    end_heapify:
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra

print_array:
    la $a0, heap_msg
    li $v0, 4
    syscall
    add $t0, $zero, $zero
    print_loop:
        beq $t0, 40, end_print
        lw $a0, array($t0)
        li $v0, 1
        syscall
        li $a0, 32
        li $v0, 11
        syscall
        addi $t0, $t0, 4
        j print_loop
    end_print:
        j exit

exit:
    li $v0, 10
    syscall


