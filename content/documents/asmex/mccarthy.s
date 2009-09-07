
        .data
        .align 0
hello:  
        .asciiz "Inserisci un valore numerico: "
newline:
        .asciiz "\n"
space:
        .asciiz " "
bye:
        .asciiz "Output is "


        .text
        .align 2
        .globl main

M91:
        subu $sp,$sp,4
        sw   $ra,0($sp)
        bgt  $a0,100,stopcase

        addi  $a0,$a0,11
        jal   M91
        move  $a0,$v0
        jal   M91
        
        j epilogue
stopcase:
        move $v0,$a0
        addi $v0,-10
epilogue:
        lw   $ra,0($sp)
        addiu $sp,$sp,4
        jr $ra

################################

main:
        li $v0,4
        la $a0,hello
        syscall

        li $v0,5
        syscall

        move $a0,$v0
        jal M91
        move $s0,$v0

        li $v0,4
        la $a0,bye
        syscall

        li $v0,1
        move $a0,$s0
        syscall

        li $v0,4
        la $a0,newline
        syscall

        li $v0,10
        syscall
