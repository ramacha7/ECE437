onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate /icache_tb/PROG/test_case_number
add wave -noupdate /icache_tb/PROG/test_case
add wave -noupdate -group icache /icache_tb/DUT/icache_table
add wave -noupdate -group icache /icache_tb/DUT/tag
add wave -noupdate -group icache /icache_tb/DUT/index
add wave -noupdate -group icache /icache_tb/DUT/hit
add wave -noupdate -group icache /icache_tb/DUT/i
add wave -noupdate -group caches /icache_tb/DUT/cif/iwait
add wave -noupdate -group caches /icache_tb/DUT/cif/iREN
add wave -noupdate -group caches /icache_tb/DUT/cif/iload
add wave -noupdate -group caches /icache_tb/DUT/cif/iaddr
add wave -noupdate -group datapath_cache /icache_tb/DUT/dcif/halt
add wave -noupdate -group datapath_cache /icache_tb/DUT/dcif/ihit
add wave -noupdate -group datapath_cache /icache_tb/DUT/dcif/imemREN
add wave -noupdate -group datapath_cache /icache_tb/DUT/dcif/imemload
add wave -noupdate -group datapath_cache /icache_tb/DUT/dcif/imemaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 115
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
WaveRestoreZoom {0 ns} {60 ns}
