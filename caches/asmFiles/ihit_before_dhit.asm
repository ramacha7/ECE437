org 0x0000

ori $6, $zero, 0xF00
ori $7, $zero, 1
ori $8, $zero, 2

branch:
    lw $15, 0($6) #dhit
    add $9, $9, $7
    addi $8, $8, -1
    sw $8, 0($6) #ihit
    addi $6,$6,0x00F4
    bne $8, $0, branch
    sw $9, 0($6)
halt

org 0xF00
cfw 0xDEAD

org 0x0FF4
cfw 0xCAFE
