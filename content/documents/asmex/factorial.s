### Another exercise of SPIM

        .data
        .align 0
        
name_iter:
        .asciiz "Iterative factorial: "
name_rec:  
        .asciiz "Recursive factorial: "
newline:
        .asciiz "\n"

        .align 2
data_set:
        .word 4,5
        
        .text
        .align 2
        .globl main


main:
        sw   $fp,-4($sp)
        la   $fp,-4($sp)
        subu $sp,8              # Prologue
        sw   $ra,-4($fp)

        
        li   $v0,4              # Recursive
        la   $a0,name_rec
        syscall

        lw   $a0,data_set
        jal  rec_factorial

        move $a0,$v0
        li   $v0, 1
        syscall

        li   $v0,4
        la   $a0,newline
        syscall

        li  $v0,4
        la  $a0,name_iter
        syscall

        lw  $a0,data_set+4
        jal iter_factorial

        move $a0,$v0
        li   $v0,1
        syscall

        la   $a0,newline
        li   $v0,4
        syscall
        
        lw   $ra,-4($fp)        # Epilogue
        la   $sp, 4($fp)
        lw   $fp, 0($fp)
        jr   $ra



### recursive factorial implementation
rec_factorial:

        sw   $fp,-4($sp)        #Prologue
        la   $fp,-4($sp)
        subu $sp,$sp,12
        sw   $ra,-4($fp)
        sw   $a0,-8($fp)

        beqz $a0,Rzero
        sub  $a0, $a0, 1        # fact(n)=n*fact(n-1)
        jal  rec_factorial
        lw   $a0, -8($fp)
        mul  $v0, $v0, $a0
        b    Rdone
Rzero:  
        li   $v0,1              # 0! is 1
Rdone:
        
        lw   $ra,-4($fp)       #Epilogue
        la   $sp, 4($fp)
        lw   $fp, 0($fp)
        jr $ra        
        
        
        
### iterative factorial implementation
iter_factorial:
        move $t0,$a0
        li   $t1,1
Iloop:
        beqz $t0,Idone
        mul  $t1,$t1,$t0
        sub  $t0,$t0,1
        b    Iloop
Idone:
        move $v0,$t1
        jr   $ra