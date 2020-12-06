onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /forwarding_unit_tb/CLK
add wave -noupdate /forwarding_unit_tb/nRST
add wave -noupdate /forwarding_unit_tb/fuif/forwardA
add wave -noupdate /forwarding_unit_tb/fuif/forwardB
add wave -noupdate /forwarding_unit_tb/fuif/RegWr_memwb
add wave -noupdate /forwarding_unit_tb/fuif/RegWr_exmem
add wave -noupdate /forwarding_unit_tb/fuif/rs_idex
add wave -noupdate /forwarding_unit_tb/fuif/rt_idex
add wave -noupdate /forwarding_unit_tb/fuif/rt_memwb
add wave -noupdate /forwarding_unit_tb/fuif/rd_memwb
add wave -noupdate /forwarding_unit_tb/fuif/rt_exmem
add wave -noupdate /forwarding_unit_tb/fuif/rd_exmem
add wave -noupdate /forwarding_unit_tb/fuif/RegDst_memwb
add wave -noupdate /forwarding_unit_tb/fuif/RegDst_exmem
add wave -noupdate /forwarding_unit_tb/fuif/ALUOut_exmem
add wave -noupdate /forwarding_unit_tb/fuif/wdat_memwb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {63 ns}
