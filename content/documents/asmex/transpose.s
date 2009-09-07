 
###  Transpose a 3x5 matrix contained in memory.
###  Program work only for 3x5 matrices.

        .data
        .align 2
A:                              # output matrix B
        .word 0,1,2,3,4
        .word 5,6,7,8,9
        .word 10,11,12,13,14

B:
        .word 0:15
        
        .align 0
newline:
        .asciiz "\n"
tab:
        .asciiz "\t|"
separator:
        .asciiz "|"
        

        .text
        .align 2
        .globl main
main:   
        li $s6,3                # rows
        li $s7,5                # columns
        
        li $s1,0                # column index
outer:                          
        bge $s1,$s7,endouter

        la $a0,separator
        li $v0,4
        syscall
        
        li $s0,0                # row index
inner:  
        bge $s0,$s6,endinner

        ## Main loop body
        mul  $t0,$s7,$s0        #
        add  $t0,$t0,$s1        # offset in  A = i*rows+j
        sll  $t0,$t0,2          #
        
        mul  $t1,$s6,$s1        #
        add  $t1,$t1,$s0        # offset in  B = j*colums+i
        sll  $t1,$t1,2          #

        lw $s2,A($t0)
        sw $s2,B($t1)
        
        move $a0,$s2
        li $v0,1
        syscall
        la $a0,tab
        li $v0,4
        syscall
        
        ## --------------

        addi $s0,$s0,1
        b inner
endinner:

        la $a0,newline
        li $v0,4
        syscall
        
        addi $s1,$s1,1
        b outer
endouter:

        jr $ra