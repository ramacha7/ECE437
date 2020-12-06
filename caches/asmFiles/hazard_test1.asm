#### Hazard test unit for RAW (with register 1) #####

org 0x0000

ori   $22,$zero,0xF0
ori $2,$0,0x0001
ori $3,$0,0x0002
ori $7,$0,0x000F
ori $9,$0,0xFFFF
ori $11,$0,0x00FF

add $1,$2,$3
sub $4,$1,$3    #(RAW hazard)
and $6,$1,$7
or $8,$1,$9
xor $10,$1,$11
addi $10,$10,0x0005  #(RAW hazard)
sw  $1,0($22)
sw  $4,4($22)
sw  $6,8($22)
sw  $8,12($22)
sw  $10,16($22)

halt
