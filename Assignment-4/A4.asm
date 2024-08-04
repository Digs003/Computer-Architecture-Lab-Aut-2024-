.data
input_m: .asciiz "Enter M: "  # Prompt for M
input_n: .asciiz "Enter N: "  # Prompt for N
input_d: .asciiz "Enter d: "  # Prompt for d

binary_array: .space 32      
msg1: .asciiz "The result of ModExp is: "       # Result message
msg2: .asciiz "Binary representation of d is: "  # Binary representation message

.text 
.globl main
main:
    la $a0, input_m        
    li $v0, 4              
    syscall
    li $v0, 5              
    syscall
    move $s0, $v0          

    la $a0, input_d        
    li $v0, 4              
    syscall
    li $v0, 5              
    syscall
    move $s2, $v0          

    la $a0, input_n        
    li $v0, 4              
    syscall
    li $v0, 5              
    syscall
    move $s1, $v0          # Store input N in $s1
    
    add $t0, $s2, $zero    # Copy d to $t0
    addi $t1, $zero, 2     # Set $t1 to 2
    addi $t3, $zero, 0     # Initialize counter $t3 to 0
    jal decimaltobinary    # Convert d to binary
    li $a0, 10             # Newline character
    li $v0, 11             # Print character syscall
    syscall

    la $a0, msg2           
    li $v0, 4              
    syscall
    jal print_binary       
    li $a0, 10             
    li $v0, 11             
    syscall

    la $a0, msg1           
    li $v0, 4              
    syscall
    jal ModExp             
    move $a0, $v0          
    li $v0, 1              
    syscall
    j exit                 
    
decimaltobinary:
    ble $t0, 0, finished   
    div $t0, $t1           
    mfhi $t2               
    mflo $t0               
    sb $t2, binary_array($t3)  
    addi $t3, $t3, 1       
    j decimaltobinary      

finished:
    jr $ra                 

print_binary:
    add $t0, $t3, $zero    
    sub $t0, $t0, 1        
    loop:
        blt $t0, 0, end_loop  
        lb $a0, binary_array($t0)  
        li $v0, 1           
        syscall
        addi $t0, $t0, -1   
        j loop              
    end_loop:
        jr $ra              

square:
    mul $v0, $a0, $a0       
    jr $ra                  

multiply:
    mul $v0, $a0, $a1       
    jr $ra                  

ModExp:
    li $t0, 1               
    div $s0, $s1            
    mfhi $s0                
    li $t1, 0               
    move $t5, $ra           

    loop2:
        bge $t1, $t3, end_loop2  
        lb $t2, binary_array($t1)  
        beq $t2, 1, ifcase  
        j lab               

        ifcase:
            move $a0, $t0   
            move $a1, $s0   
            jal multiply    
            move $t0, $v0   
            div $t0, $s1    
            mfhi $t0        

        lab:
            move $a0, $s0   
            jal square      
            move $s0, $v0   
            div $s0, $s1    
            mfhi $s0        
            addi $t1, $t1, 1  
            j loop2         

    end_loop2:
        move $v0, $t0       
        move $ra, $t5       
        jr $ra              

exit:
    li $v0, 10              
    syscall
