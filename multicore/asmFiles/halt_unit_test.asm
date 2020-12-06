org 0x0000

ori $2,$0,0x0001
ori $3,$0,0x0002

halt

ori $3,$0,0x0001        #if register 3 has a value of 1 then halt is not working
