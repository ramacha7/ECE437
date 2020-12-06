org 0x0000

#Let register 7 be where the result is held

ori $29,$0,0xFFFC
ori $2,$0,0x0007     #variable holding the input value n
ori $4,$0,0x0001     #variable holding value 1 used for return statement check

push $2

jal fib_procedure

halt

fib_procedure:
    pop $3          #grabbing the current value of n to compute fibonacci for
    push $31         #storing the return address of this function call
    beq $3,$0,return0
    beq $3,$4,return1

    sub $5,$3,$4     #storing n-1
    push $3          #saving value of n
    push $5
    jal fib_procedure    #calling fib(n-1)

    or $10,$7,$0        #saving result in temp register
    pop $3              #grabbing back the old value
    ori $11,$0,0x0002   #storing the value 2
    sub $6,$3,$11      #n-2
    push $10
    push $6
    jal fib_procedure

    pop $10
    addu $7,$7,$10

    pop $31
    jr $31

return0:
    ori $7,$0,0x0000
    pop $31
    jr $31

return1:
    ori $7,$0,0x0001
    pop $31
    jr $31
    
