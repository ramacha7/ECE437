onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/PROG/test_case_number
add wave -noupdate /control_unit_tb/PROG/test_case
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate /control_unit_tb/cuif/instr
add wave -noupdate /control_unit_tb/cuif/rs
add wave -noupdate /control_unit_tb/cuif/rd
add wave -noupdate /control_unit_tb/cuif/rt
add wave -noupdate /control_unit_tb/cuif/imm_val
add wave -noupdate /control_unit_tb/cuif/ALUOp
add wave -noupdate /control_unit_tb/cuif/PCSrc
add wave -noupdate /control_unit_tb/cuif/ALUSrc
add wave -noupdate /control_unit_tb/cuif/RegDst
add wave -noupdate /control_unit_tb/cuif/ExtOp
add wave -noupdate /control_unit_tb/cuif/halt
add wave -noupdate /control_unit_tb/cuif/RegWr
add wave -noupdate /control_unit_tb/cuif/MemtoReg
add wave -noupdate /control_unit_tb/cuif/dREN
add wave -noupdate /control_unit_tb/cuif/dWEN
add wave -noupdate /control_unit_tb/cuif/iREN
add wave -noupdate /control_unit_tb/cuif/JAL
add wave -noupdate /control_unit_tb/cuif/LUI
add wave -noupdate /control_unit_tb/cuif/JR
add wave -noupdate /control_unit_tb/cuif/BNE
add wave -noupdate /control_unit_tb/cuif/BEQ
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {230 ns} 0}
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
