org 0x0000

ori $29, $0, 0xFFFC
ori $2, $0, 0x0001
ori $3, $0, 0x0002

push $2       #register holding operand 1
push $3       #register holding operand 2

start:
    pop $5      #register 5 holding operand 2
    pop $6      #register 6 holding operand 1

    addu $8,$0, $0      #register 8 holding result
    ori $9, $5, 0x0000   #register 9 acting as iterator
    ori $10, $0, 0x0001   #register 10 holding the value to decrement iterator register

multiply:
    beq $0,$9, done       #checking the when register
    addu $8,$8,$6
    sub $9,$9,$10
    j multiply

done:
    push $8    #pushing the result onto the stack
    halt
