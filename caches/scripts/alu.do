onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/PROG/test_case_number
add wave -noupdate /alu_tb/PROG/test_case
add wave -noupdate /alu_tb/CLK
add wave -noupdate /alu_tb/nRST
add wave -noupdate /alu_tb/aif/ALUOP
add wave -noupdate -radix decimal /alu_tb/aif/portA
add wave -noupdate -radix decimal /alu_tb/aif/portB
add wave -noupdate -radix decimal /alu_tb/aif/out_port
add wave -noupdate /alu_tb/aif/zero
add wave -noupdate /alu_tb/aif/ovf
add wave -noupdate /alu_tb/aif/neg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
