### Merge of two vectors on a third

        .data
        .align 0
space:        
        .asciiz " "

        .align 2

v1:
        .word -3,12,23,54,2454
size1:
        .word 5
v2:     
        .word -37,3,15,21,34,35,76
size2:
        .word 7
target:
        .space 12

        
        .text
        .align 2
        .globl main

main:   
        ## (Start,end) of first vector (s0,s1) 
        la $s0,v1
        lw $s1,size1
        sll $s1,$s1,2
        add $s1,$s1,$s0

        ## (Start,End) of second vector (s2,s3)
        la $s2,v2
        lw $s3,size2
        sll $s3,$s3,2
        add $s3,$s3,$s2

        ## Start of destination vector
        la $t4,target

        ## Actual Merge
mainloop:
        bge $s0,$s1,secondtail
        bge $s2,$s3,firsttail
        lw $t0,($s0)
        lw $t2,($s2)
        blt $t0,$t2,min1
        move $t0,$t2
        addi $s2,$s2,4
        addi $s0,$s0,-4
min1:
        sw $t0,($t4)
        addi $s0,$s0,4
        addi $t4,$t4,4      
        j mainloop
       
secondtail:
        move $s0,$s2
        move $s1,$s3
firsttail:
        bge $s0,$s1,exit
        lw $t0,($s0)
        sw $t0,($t4)
        addi $s0,$s0,4
        addi $t4,$t4,4
        j firsttail

###  Print result vector
exit:
        la $t3,target
printloop:
        bge $t3,$t4,endprintloop
        lw $a0,($t3)
        li $v0,1
        syscall
        la $a0,space
        li $v0,4
        syscall
        addi $t3,$t3,4
        j printloop
endprintloop:      
        li $v0,10
        syscall