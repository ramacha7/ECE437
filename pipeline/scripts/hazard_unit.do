onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hazard_unit_tb/CLK
add wave -noupdate /hazard_unit_tb/nRST
add wave -noupdate /hazard_unit_tb/huif/instr
add wave -noupdate /hazard_unit_tb/huif/BEQ_exmem
add wave -noupdate /hazard_unit_tb/huif/BNE_exmem
add wave -noupdate /hazard_unit_tb/huif/PCSrc
add wave -noupdate /hazard_unit_tb/huif/rt_idex
add wave -noupdate /hazard_unit_tb/huif/ihit
add wave -noupdate /hazard_unit_tb/huif/dhit
add wave -noupdate /hazard_unit_tb/huif/equal_exmem
add wave -noupdate /hazard_unit_tb/huif/MemtoReg_idex
add wave -noupdate /hazard_unit_tb/huif/flush
add wave -noupdate /hazard_unit_tb/huif/stall
add wave -noupdate /hazard_unit_tb/DUT/rs_ifid
add wave -noupdate /hazard_unit_tb/DUT/rt_ifid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43 ns} 0}
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
WaveRestoreZoom {0 ns} {85 ns}
