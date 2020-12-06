org 0x0000

ori $6, $zero, 0xF00
ori $7, $zero, 1
ori $8, $zero, 2
ori $12, $zero, 2

branch:
    lw $15, 0($6) #dhit
    add $9, $9, $7
    addi $8, $8, -1
    addi $12, $12, -1 #ihit
    bne $8, $0, branch
    sw $9, 0($6)

halt

org 0xF00
cfw 0xDEAD
