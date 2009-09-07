
        .data
        .align 0
hello:  
        .asciiz "Inserisci un valore numerico: "
newline:
        .asciiz "\n"
bye:
        .asciiz "Il numero con i bit invertiti e` "


        .text
        .align 2
        .globl main

flip:
        subu $sp,$sp,4
        sw   $ra,0($sp)

        addi $t0,$0,1 # Source mask
        move $t1,$t0  # Dest mask
        ror  $t1,$t1,1
        move $v0,$0
        ## Loop throught all digits
fliploop:       
        beqz $t0,epilogue

        and  $t2,$a0,$t0
        seq  $t2,$t2,$t0
        mul  $t2,$t2,$t1
        or   $v0,$v0,$t2
        
        ## Shifts bitmasks by one position
        sll $t0,$t0,1
        srl $t1,$t1,1
        j fliploop
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
        jal  flip
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
