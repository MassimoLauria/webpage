
### Generatore di progressioni con procedura.

        .data
        .align 0
space:  
        .asciiz " "
newline:
        .asciiz "\n"

        .text
        .align 2
        .globl main

progression:
        move $t0,$a0
        move $t1,$a1
        move $t2,$0
loop:
        blez $t1,endloop
        add  $t2,$t2,$t0

        li $v0,1
        move $a0,$t2
        syscall
        
        li $v0,4
        la $a0,space
        syscall
        
        
        addi $t1,$t1,-1
        j loop
endloop:        
        li $v0,4
        la $a0,newline
        syscall
                
        jr $ra      

        
main:

        li $a0,1
        li $a1,5
        jal progression

        li $a0,2
        li $a1,0
        jal progression

        li $a0,7
        li $a1,3
        jal progression

        li $v0,10
        syscall
        