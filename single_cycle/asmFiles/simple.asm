
  #------------------------------------------------------------------
  # R-type Instruction (ALU) Test Program
  #------------------------------------------------------------------

  org 0x0000
  ori   $4,$0,0x0800
  ori   $1,$0,0xfeed
  ori   $2,$0,0xcafe
  sw		$1, 0($4)	
  sw    $2, 4($4)
  
  halt  # that's all

