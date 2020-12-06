org 0x0000
ori $29, $0, 0xFFFC
ori $1, $0, 0x00F0

j jump_label
ori $4,$0,0x0002  #value of register 4 when jump test case does not work
halt

jal_label:
    ori $5,$0,0x0005     #value of register 5 when jal test case works
    sw $5, 0($1)
    jr $31


jump_label:
    ori $4,$0,0x0001   #value of register 4 when jump test case does work
    jal jal_label
    ori $5,$0,0x0001  #value of register 5 when jal test case doesnt work
    sw $4, 4($1)
    halt

ori $6,$0,0x0002       #value of register 6 when jr test case doesnt work

halt

