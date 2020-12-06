org 0x0000
ori $15,$0,0x0400 
ori $16,$0, 0x0600
ori $17,$0, 0x0500

ori $3, $0, 0xDEAD
ori $5, $0, 0xFEEF
ori $6, $0, 0xCEFF
sw $3, 0($15) #I->M(PrWr)
sw $3, 0($17) #I->M(PrWr) Accounts for LRU change
ori $6, $0, 0xCEFF
lw $4, 0($16) #Cache miss
halt

org 0x0200
ori $15,$0,0x0900 
ori $16,$0, 0x0700
ori $17,$0, 0x0800

ori $3, $0, 0xDEAD
ori $5, $0, 0xFEEF
ori $6, $0, 0xCEFF
sw $3, 0($15) #I->M(PrWr)
sw $3, 0($17) #I->M(PrWr) Accounts for LRU change
lw $4, 0($16) #Cache miss
halt

org 0x0400
cfw 0xBEEFFEED
cfw 0xCAFEDEAD

org 0x0500
cfw 0xFACEFACE
cfw 0xACEACEFF

org 0x0600
cfw 0xBEADBEEF
cfw 0xDEAFFEED

org 0x0700
cfw 0xBEADBEEF
cfw 0xDEAFFEED

org 0x0800
cfw 0xBEADBEEF
cfw 0xDEAFFEED

org 0x0900
cfw 0xBEADBEEF
cfw 0xDEAFFEED
