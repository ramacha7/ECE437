org 0x0000

main:
    ori $29,$0, 0xFFFC    #initialization of stack pointer
    ori $20,$0, 0xFFF8    #the address of the stack pointer containing 1 value
    ori $2,$0,0x0005
    ori $3,$0,0x0004
    ori $4,$0,0x0003
    ori $5,$0,0x0002

    push $2
    push $3
    push $4
    push $5

multiply_procedure:
    beq $20,$29,complete
    jal mul_func
    j multiply_procedure

mul_func:
    pop $7      #register 5 holding operand 2
    pop $6      #register 6 holding operand 1

    addu $8,$0, $0      #register 8 holding result
    ori $9, $6, 0x0000   #register 9 acting as iterator
    ori $10, $0, 0x0001   #register 10 holding the value to decrement iterator register

multiply:
    beq $0,$9, done       #checking the when register
    addu $8,$8,$7
    sub $9,$9,$10
    j multiply

done:
    push $8    #pushing the result onto the stack
    jr $31

complete:
    halt
