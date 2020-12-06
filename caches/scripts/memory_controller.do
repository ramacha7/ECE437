onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_controller_tb/PROG/test_case_number
add wave -noupdate /memory_controller_tb/PROG/test_case
add wave -noupdate /memory_controller_tb/CLK
add wave -noupdate /memory_controller_tb/nRST
add wave -noupdate /memory_controller_tb/cif0/iwait
add wave -noupdate /memory_controller_tb/cif0/dwait
add wave -noupdate /memory_controller_tb/cif0/iREN
add wave -noupdate /memory_controller_tb/cif0/dREN
add wave -noupdate /memory_controller_tb/cif0/dWEN
add wave -noupdate /memory_controller_tb/cif0/iload
add wave -noupdate /memory_controller_tb/cif0/dload
add wave -noupdate /memory_controller_tb/cif0/dstore
add wave -noupdate /memory_controller_tb/cif0/iaddr
add wave -noupdate /memory_controller_tb/cif0/daddr
add wave -noupdate /memory_controller_tb/ram_if/ramREN
add wave -noupdate /memory_controller_tb/ram_if/ramWEN
add wave -noupdate /memory_controller_tb/ram_if/ramaddr
add wave -noupdate /memory_controller_tb/ram_if/ramstore
add wave -noupdate /memory_controller_tb/ram_if/ramload
add wave -noupdate /memory_controller_tb/ram_if/ramstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {190000 ps} 0}
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
WaveRestoreZoom {170686 ps} {225329 ps}
