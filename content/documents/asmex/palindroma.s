
###  Test di una parola palindroma:
###
###  Ex.
###
###  Inserisci una parola: ireneneri
###  Palindroma!
###
###  Inserisci una parola: lavatrice
###  Non e` palindroma


        .data
        .align 0
buffer:
        .byte 0:100

request:
        .asciiz "Inserisci una parola: "
yes:
        .asciiz "Palindroma!\n"
no:
        .asciiz "Non e` palindroma"

        
        .text
        .align 2
        .globl main
        
main:   
        la $a0,request          # Legge la stringa in buffer
        li $v0,4
        syscall
        la $a0,buffer
        li $a1,100
        li $v0,8
        syscall

        la $t0,buffer           # Inizializza test
        la $t1,buffer
searchend:      
        lb $t7,0($t1)
        beqz $t7,pretest        # Fine stringa 0x00
        xori $t7,0x0d
        beqz $t7,pretest        # Carriage return 0x0d
        xori $t7,0x07           # 0x07 = 0x0a xor 0x0d (LF xor CR)
        beqz $t7,pretest        # Line feed 0x0a
        addi $t1,$t1,1
        b searchend
        
pretest:
        addi $t1,$t1,-1
maketest:                       # Ciclo di test
        bge $t0,$t1,good
        lb $t2,($t0)
        lb $t3,($t1)
        bne $t2,$t3,bad
        addi $t0,$t0,1
        addi $t1,$t1,-1
        b maketest       

good:
        la $a0,yes
        li $v0,4
        syscall
        jr $ra
bad:    
        la $a0,no
        li $v0,4
        syscall
        jr $ra
        
