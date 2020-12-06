org 0x0000     
ori $15,$0,0x00F0  
ori $16,$0, 0x0FF0 
ori $17,$0, 0xEFF0

## instructions to show associative cache

lw $4, 0($15) #first dcache access leads to miss and load from RAM 

lw $6, 0($16) #Second dcache access leads to miss and load from RAM

lw $7, 0($17) #Leads to a miss due to wrong tag value and so replaces lru from RAM

halt

org 0x00F0
cfw 0xBEEF
cfw 0xFEED

org 0x0FF0
cfw 0xCAFE
cfw 0xDEAD

org 0xEFF0
cfw 0xBEAD

