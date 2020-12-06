onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/PROG/test_case
add wave -noupdate -radix unsigned /dcache_tb/PROG/test_case_number
add wave -noupdate /dcache_tb/DUT/i
add wave -noupdate /dcache_tb/DUT/j
add wave -noupdate -group Address /dcache_tb/DUT/addrIndex
add wave -noupdate -group Address /dcache_tb/DUT/addrOffset
add wave -noupdate -group Address /dcache_tb/DUT/addrTag
add wave -noupdate -group State /dcache_tb/DUT/currState
add wave -noupdate -group State /dcache_tb/DUT/nextState
add wave -noupdate -group Counter /dcache_tb/DUT/cnt
add wave -noupdate -group Counter /dcache_tb/DUT/next_cnt
add wave -noupdate -group DCACHE /dcache_tb/DUT/dcache_table
add wave -noupdate -group DCACHE /dcache_tb/DUT/set
add wave -noupdate -group DCACHE /dcache_tb/DUT/lru
add wave -noupdate -group Flush /dcache_tb/DUT/flush_frame
add wave -noupdate -group Flush /dcache_tb/DUT/next_flush_frame
add wave -noupdate -group Flush /dcache_tb/DUT/flush_set
add wave -noupdate -group Flush /dcache_tb/DUT/next_flush_set
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/dwait
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/dREN
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/dWEN
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/daddr
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/dstore
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/dload
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/ccinv
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/ccsnoopaddr
add wave -noupdate -group {Cache to RAM} /dcache_tb/cif/ccwait
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/dhit
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/halt
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/dmemREN
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/dmemWEN
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/dmemaddr
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/dmemload
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/dmemstore
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/datomic
add wave -noupdate -group Datapath-Cache /dcache_tb/dcif/flushed
add wave -noupdate -group {Unused Datapath} /dcache_tb/dcif/imemload
add wave -noupdate -group {Unused Datapath} /dcache_tb/dcif/imemaddr
add wave -noupdate -group {Unused Datapath} /dcache_tb/dcif/imemREN
add wave -noupdate -group {Unused Datapath} /dcache_tb/dcif/ihit
add wave -noupdate -group {Unused Cache} /dcache_tb/cif/ccwrite
add wave -noupdate -group {Unused Cache} /dcache_tb/cif/cctrans
add wave -noupdate -group {Unused Cache} /dcache_tb/cif/iaddr
add wave -noupdate -group {Unused Cache} /dcache_tb/cif/iload
add wave -noupdate -group {Unused Cache} /dcache_tb/cif/iREN
add wave -noupdate -group {Unused Cache} /dcache_tb/cif/iwait
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
WaveRestoreZoom {1710 ns} {1747 ns}
