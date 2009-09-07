### Endian converter
###
### given a number in a location we want to fill the table
###
### original number
### first byte as loaded in a register
### second byte as loaded in a register
### third byte ...
### fourth byte ...
### number with reversed endianess
### 

        .data
        .align 0
long:   
        .word 5235254
medium:        
        .half 2342,31242
short:  
        .byte 123,-54,23,-1
hex_digit:
        .byte 48,00,49,00,50,00,51,00,52,00,53,00,54,00,55,00,56,00,57,00,65,00,66,00,67,00,68,00,69,00,70,00
space:
        .asciiz " "
newline:
        .asciiz "\n"
        .align 2
table:
        .space 24
        
        .text
        .align 2
        .globl main

print_hex:
        and  $t0,$a0,240
        and  $t1,$a0,15
        srl  $t0,$t0,3
        sll  $t1,$t1,1
        la   $a0,hex_digit($t0)
        li   $v0,4
        syscall
        la   $a0,hex_digit($t1)
        li   $v0,4
        syscall
        jr $ra


print_table:
        add $sp,$sp,-12
        sw  $ra,($sp)
        sw  $s0,4($sp)
        sw  $s1,8($sp)

        move $s0,$0
loop:
        bge $s0,24,endloop
        
        lb  $s1,table($s0)
        move $a0,$s1
        jal print_hex
        la   $a0,space
        li   $v0,4
        syscall
        and $t0,$s0,3
        xor $t0,$t0,3
        bnez $t0,nonewline
        la $a0,newline
        li $v0,4
        syscall
nonewline:            
        add $s0,$s0,1
        j loop
endloop:        
        
        lw  $ra,($sp)
        lw  $s0,4($sp)
        lw  $s1,8($sp)
        add $sp,$sp,12
        jr $ra


main:
        ## Word
        la  $t0,long
        la  $t1,table
        lw  $s0,($t0)
        lb  $s1,0($t0)
        lb  $s2,1($t0)
        lb  $s3,2($t0)
        lb  $s4,3($t0)
        sw  $s0,($t1)
        sw  $s1,4($t1)
        sw  $s2,8($t1)
        sw  $s3,12($t1)
        sw  $s4,16($t1)
        sb  $s4,20($t1)
        sb  $s3,21($t1)
        sb  $s2,22($t1)
        sb  $s1,23($t1)
        jal print_table
        la $a0,newline
        li $v0,4
        syscall

        ## Half words 
        la  $t0,medium
        la  $t1,table
        lh  $s0,($t0)
        lh  $s1,2($t0)
        lb  $s2,0($t0)
        lb  $s3,1($t0)
        lb  $s4,2($t0)
        lb  $s5,3($t0)
        sh  $s0,($t1)
        sh  $s1,2($t1)
        sw  $s2,4($t1)
        sw  $s3,8($t1)
        sw  $s4,12($t1)
        sw  $s5,16($t1)
        sb  $s3,20($t1)
        sb  $s2,21($t1)
        sb  $s5,22($t1)
        sb  $s4,23($t1)
        jal print_table
        la $a0,newline
        li $v0,4
        syscall

        ## Bytes
        la  $t0,short
        la  $t1,table
        lb  $s0,0($t0)
        lb  $s1,1($t0)
        lb  $s2,2($t0)
        lb  $s3,3($t0)
        sb  $s0,0($t1)
        sb  $s1,1($t1)
        sb  $s2,2($t1)
        sb  $s3,3($t1)
        sw  $s0,4($t1)
        sw  $s1,8($t1)
        sw  $s2,12($t1)
        sw  $s3,16($t1)
        sb  $s0,20($t1)
        sb  $s1,21($t1)
        sb  $s2,22($t1)
        sb  $s3,23($t1)
        jal print_table
        la $a0,newline
        li $v0,4
        syscall
        
        li $v0,10
        syscall
        