org 0x0000
ori $29, $0, 0xFFFC
ori $15,$0,0x0F0

ori $2,$0,0x0001
ori $3,$0,0x0002
ori $6,$0,0x0002

bne $2,$3,bne_pass
ori $4,$0,0x0002   #register 4 holding a value of 2 indicates a failure of bne test

bne_pass:
    ori $4,$0,0x0001    # register 4 holding a value of 1 indicates success for bne test
    beq $2,$3,beq_pass
    ori $5,$0,0x0002    #register 5 holding a value of 2 indicates a success of beq test
    beq $6,$3,beq_pass
    halt
beq_pass:
    ori $5,$0,0x0001    # register 5 holding a value of 1 indicates failure for beq test
    sw  $4, 0($15)   
    halt    
