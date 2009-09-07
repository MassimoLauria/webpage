
        ## Radix sort implementation
        
        .data
        .align 2
data: 
        .word 0:100
data2:
        .word 0:100
usage:
        .asciiz "Please insert a number 1 <= N <= 100 and a sequence of N positive integers\n"
greeeting:
        .asciiz "\nIt has been a pleasure! Bye bye.\n"
error:
        .asciiz "Input contains an error.\n"
space:
        .asciiz " "
        
        .text
        .align 2
        .globl main

main:
        li $v0,4
        la $a0,usage            # Usage description
        syscall

### (1)  Read values loop
        ## Read size
        li $v0,5
        syscall
        sll $s0,$v0,2
        bgt $s0,400,error_exit
        blt $s0,0,error_exit

### (2) Load data
        la $t0,data
        add  $t1,$s0,$t0
input_loop:     
        beq $t0,$t1,end_input_loop
        li $v0,5
        syscall
        blt $v0,0,error_exit
        sw $v0,($t0)
        addi $t0,$t0,4
        b input_loop
end_input_loop: 

        
### (3) Digit loop ($t6 src buffer,$t7 dest buffer, $t5 digit mask)
        la $t6,data
        la $t7,data2
        li $t5,1
digit_loop:     
        beqz $t5,end_digit_loop
        
        ## Copy zeroes
        move $t0,$t6
        move $t2,$t7
        add  $t1,$s0,$t0       
collect0:                      # (t0 src index,t2 dest index, t1 roof)
        bge $t0,$t1,end_collect0
        lw $t3,($t0)
        and $t4,$t3,$t5
        bnez $t4,no_store0
        sw $t3,($t2)
        addi $t2,$t2,4
no_store0:
        addi $t0,$t0,4
        b collect0
end_collect0:   

        ## Copy zeroes
        move $t0,$t6
        add  $t1,$s0,$t0
collect1:                      # (t0 src index,t2 dest index, t1 roof)
        bge $t0,$t1,end_collect1
        lw $t3,($t0)
        and $t4,$t3,$t5
        beqz $t4,no_store1
        sw $t3,($t2)
        addi $t2,$t2,4
no_store1:
        addi $t0,$t0,4
        b collect1
end_collect1:   
        ## End copy
        
        sll $t5,$t5,1
        move $t4,$t6
        move $t6,$t7
        move $t7,$t4
        b digit_loop
end_digit_loop: 
        
        
### (4) Print data
        move $t0,$t6
        add  $t1,$s0,$t0
output_loop:     
        beq $t0, $t1, end_output_loop
        lw $a0,($t0)
        li $v0,1
        syscall
        la $a0,space
        li $v0,4
        syscall
        addi $t0,$t0,4
        b output_loop
end_output_loop:

        
### (5) Bye bye 
        la $a0,greeeting
        li $v0,4
        syscall
        b exit
        
error_exit:
        la $a0,error
        li $v0,4
        syscall
exit:   
        li $v0,10
        syscall
