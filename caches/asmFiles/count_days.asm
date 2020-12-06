org 0x0000

main:
    ori $29,$0, 0xFFFC    #initialization of stack pointer
    ori $28,$0, 0xFFF8   #pointer of stack when there is result value
    ori $2,$0,0x0002      #register holding current day (5)
    ori $3,$0,0x0009      #register holding current month (4)
    ori $4,$0,0x07E4      #register holding current year (2005)


count_days_procedure:
    ori $5,$0,0x07D0    #holding value of 2000
    sub $4,$4,$5        # curr_year - 2000
    push $4
    ori $11,$0,0x016D    #holding value of 365
    push $11
    jal multiply_procedure
    pop $25   #holding value of 365*(numyears - 2000)

    ori $12,$0,0x1E    #holding value of 30
    ori $13,$0,0x0001
    sub $3,$3,$13       #currmonth - 1
    push $3
    push $12
    jal multiply_procedure   #holding value of (30*(currmonth - 1))
    pop $26

    addu $2,$2,$26
    addu $2,$2,$25

    #calculated currday + 30*(curr_month-1) + 365*(curr_year - 2000)
    push $2

    halt

multiply_procedure:
    ori $30,$31,0x0000
    jal mul_func
    jr $30

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







