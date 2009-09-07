
        ## Ackermann function
        ##
        ## A(0,n)=n+1
        ## A(m,0)=A(m-1,1) se m>0
        ## A(m,n)=A(m-1,A(m,n-1)) se m>0 e n>0
        ## 

        .data
        .align 0
error_positive:
        .asciiz "Hai inserito un numero negativo!!\nMi rifiuto di calcolare.\n"
ask_input:  
        .asciiz "Inserisci due valori numerici positivi:\n"
give_output:
        .asciiz "Output is:  "
newline:
        .asciiz "\n"
space:
        .asciiz " "

        .text
        .align 2
        .globl main

main:
        ##  Ask inputs
        li $v0,4
        la $a0,ask_input
        syscall

        ##  Get firsts
        li $v0,5
        syscall
        move $s0,$v0

        ##  Get seconds
        li $v0,5
        syscall
        move $s1,$v0

        ## Check for errors
        slt $t0,$s0,$0
        slt $t1,$s1,$0
        or  $t0,$t0,$t1
        beqz $t0,compute
        la  $a0,error_positive
        j   error_message
compute:        
        ## Print output msg
        li $v0,4
        la $a0,give_output
        syscall

        ## Compute!
        move $a0,$s0
        move $a1,$s1
        jal Ack
        move $a0,$v0
        li $v0,1
        syscall

        li $v0,4
        la $a0,newline
        syscall

exit:  
        li $v0,10
        syscall


error_message:
        li $v0,4
        syscall
        li $v0,10
        syscall


Ack:
        subu $sp,$sp,12
        sw   $ra,0($sp)
        sw   $a0,4($sp)
        sw   $a1,8($sp)
        
        beqz $a0,case1
        beqz $a1,case2
default:
        addi $a1,$a1,-1
        jal Ack
        move $a1,$v0
        addi $a0,$a0,-1
        jal Ack
        j endcases
case1:
        add $v0,$a1,1
        j endcases
case2:
        addi $a0,$a0,-1
        li   $a1,1
        jal Ack
        ## j endcases
endcases:       
        lw   $ra,0($sp)
        lw   $a0,4($sp)
        lw   $a1,8($sp)
        addiu $sp,$sp,12
        jr $ra