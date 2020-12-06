onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /request_unit_tb/PROG/test_case_number
add wave -noupdate /request_unit_tb/PROG/test_case
add wave -noupdate /request_unit_tb/PROG/tb_clk
add wave -noupdate /request_unit_tb/PROG/tb_nrst
add wave -noupdate /request_unit_tb/ruif/dhit
add wave -noupdate /request_unit_tb/ruif/ihit
add wave -noupdate /request_unit_tb/ruif/dWEN
add wave -noupdate /request_unit_tb/ruif/dREN
add wave -noupdate /request_unit_tb/ruif/reg_dWEN
add wave -noupdate /request_unit_tb/ruif/reg_dREN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {219 ns} 0}
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
