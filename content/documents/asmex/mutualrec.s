
        ## An example of multual recursive function
        ##
        ## F(0)=1
        ## G(0)=0
        ## F(n+1)=3*F(n) +  G(n)
        ## G(n+1)=  F(n) +3*G(n)

        .data
        .align 0
error_positive:
        .asciiz "Hai inserito un numero negativo!!\nMi rifiuto di calcolare.\n"
ask_input:  
        .asciiz "Inserisci un valore numerico positivo:\n"
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

        ##  Get input
        li $v0,5
        syscall
        move $s0,$v0

        ## Check for errors
        slt $t0,$s0,$0
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
        jal F
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

        
G:
        subu $sp,$sp,12
        sw   $ra,0($sp)
        sw   $a0,4($sp)
        sw   $s0,8($sp)

        li $v0,0
        beqz $a0,endG

        addi $a0,$a0,-1
        jal F
        move $s0,$v0
        jal G
        mul  $v0,$v0,3
        add  $v0,$v0,$s0
        
endG:   
        lw   $ra,0($sp)
        lw   $a0,4($sp)
        lw   $s0,8($sp)
        addiu $sp,$sp,12
        jr $ra

        
F:
        subu $sp,$sp,12
        sw   $ra,0($sp)
        sw   $a0,4($sp)
        sw   $s0,8($sp)
        
        li $v0,1
        beqz $a0,endF

        addi $a0,$a0,-1
        jal F
        mul  $s0,$v0,3
        jal G
        add  $v0,$v0,$s0
endF:   
        lw   $ra,0($sp)
        lw   $a0,4($sp)
        lw   $s0,8($sp)
        addiu $sp,$sp,12
        jr $ra