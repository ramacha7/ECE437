  #------------------------------------------------------------------
  # Tests for branches
  #------------------------------------------------------------------

  org   0x0000
  ori   $1, $zero, 0x0F00
  ori   $2, $zero, 0x0800
  ori   $3, $0, 0x0005
  ori   $4, $0, 0x0005
  beq $3,$4,bne_label     #(branch hazard)
  ori $3,$0,0x0001
  ori $4,$4,0x0004
  halt

bne_label:
    sw $3, 0($1)
    halt


  org   0x0F00
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
