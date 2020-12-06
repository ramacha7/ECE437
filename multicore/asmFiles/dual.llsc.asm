#------------------------------------------------------------------
# Test llsc1
# Note: SW/SC should invalidate the link register if there is an
#       address match in the opposite core or in the same core.
#------------------------------------------------------------------

  org   0x0000
  ori   $1, $zero, 0x1FC0
  ori   $2, $zero, 0x80

  lw    $3, 0($2)     ## $3 = 0
  addiu   $3, $3, 0x01   ## $3 = 1
  sw    $3, 0($2)        ## puts 1 in address 0x80 (no invalidating linkreg)

  ll    $3, 0($2)        ## $3 = 1. Link Reg is updated (0x000000080)
  addiu   $3, $3, 0x01   ## $3 = 2
  sc    $3, 0($2)        ## puts 2 in address 0x80 if it matches link reg (invalidates link reg)
  sc    $3, 0($2)        ## puts 2 in address 0x80 again if it matches link reg (invalidates link reg)

  ll    $3, 8($2)        ## $3 = 0. Link reg is updated (0x000000088)
  addiu   $3, $3, 0x01   ## $3 = 1
  sw    $3, 8($2)        ## puts 1 in address 0x88 if it matches link reg (invalidates link reg)
  sc    $3, 8($2)        ## puts 1 inn address 0x88 if it matches link reg (invalidates link reg)
  sw    $3, 8($2)        ## puts 1 inn address 0x88 if it matches link reg (invalidates link reg)

  halt      # that's all

  org   0x0200
  ori   $1, $zero, 0x1FC0
  ori   $2, $zero, 0x90

  lw    $3, 0($2)
  addiu   $3, $3, 0x01
  sw    $3, 0($2)

  ll    $3, 0($2)
  addiu   $3, $3, 0x01
  sc    $3, 0($2)
  sc    $3, 0($2)

  ll    $3, 8($2)
  addiu   $3, $3, 0x01
  sw    $3, 8($2)
  sc    $3, 8($2)
  sw    $3, 8($2)

  halt      # that's all


