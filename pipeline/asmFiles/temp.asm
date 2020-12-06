org 0x0000

ori $29,$0,0xFFC

ori $4,$0, 0x0800
ori $1,$0, 0xfeed
ori $2,$0, 0xcafe

push $2
push $1

pop $5
pop $6

halt
