org 0x0000
ori $15,$0,0x0400 
ori $16,$0, 0x040c
ori $17,$0, 0x0414

ori $3, $0, 0xDEAD
ori $5, $0, 0xFEEF
ori $6, $0, 0xCEFF
sw $3, 0($15) #I->M(PrWr)
lw $4, 0($16) #I->S(PrRd)
lw $5, 0($16) #S->S(PrRd)
ori $5, $0, 0xFEEF
sw $5, 0($16) #S->M(PrWr)
sw $6, 0($16) #M->M(PrWr)
lw $7, 0($16) #M->M(PrRd)

halt

org 0x0200
halt

org 0x0400
cfw 0xBEEFFEED
cfw 0xCAFEDEAD
cfw 0xBEADBEEF
cfw 0xDEAFFEED
cfw 0xFACEFACE
cfw 0xACEACEFF
