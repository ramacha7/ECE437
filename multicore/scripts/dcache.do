onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate -radix unsigned /dcache_tb/PROG/test_case_number
add wave -noupdate /dcache_tb/PROG/test_case
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/halt
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/ihit
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/imemREN
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/imemload
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/imemaddr
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/dhit
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/datomic
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/dmemREN
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/dmemWEN
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/flushed
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/dmemload
add wave -noupdate -expand -group DATAPATH_0 /dcache_tb/dcif0/dmemstore
add wave -noupdate -expand -group DATAPATH_0 -radix hexadecimal /dcache_tb/dcif0/dmemaddr
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/currState
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/nextState
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/index
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/addrTag
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/addrIndex
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/addrOffset
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/snoopTag
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/snoopIndex
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/snoopOffset
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/snoopFrame
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/nextSnoopFrame
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/dcache_table
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/set
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/lru
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/next_lru
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/flush_set
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/next_flush_set
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/flush_frame
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/next_flush_frame
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/cnt
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/next_cnt
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/i
add wave -noupdate -group DCACHE_0 /dcache_tb/DUT0/j
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/halt
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/ihit
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/imemREN
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/imemload
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/imemaddr
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/dhit
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/datomic
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/dmemREN
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/dmemWEN
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/flushed
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/dmemload
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/dmemstore
add wave -noupdate -group DATAPATH_1 /dcache_tb/dcif1/dmemaddr
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/currState
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/nextState
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/index
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/addrTag
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/addrIndex
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/addrOffset
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/snoopTag
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/snoopIndex
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/snoopOffset
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/snoopFrame
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/nextSnoopFrame
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/dcache_table
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/set
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/lru
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/next_lru
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/next_flush_set
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/flush_set
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/flush_frame
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/next_flush_frame
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/cnt
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/next_cnt
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/i
add wave -noupdate -group DCACHE_1 /dcache_tb/DUT1/j
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/state
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/next_state
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/snooper
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/next_snooper
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/snoopy
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/next_snoopy
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/iwait
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/dwait
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/iREN
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/dREN
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/dWEN
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/iload
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/dload
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/dstore
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/iaddr
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/daddr
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ccwait
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ccinv
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ccwrite
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/cctrans
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ccsnoopaddr
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ramWEN
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ramREN
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ramstate
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ramaddr
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ramstore
add wave -noupdate -group BUS_CONTROLLER /dcache_tb/BUS/ccif/ramload
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/ramREN
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/ramWEN
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/ramaddr
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/ramstore
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/ramload
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/ramstate
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/memREN
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/memWEN
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/memaddr
add wave -noupdate -group RAM /dcache_tb/RAM/ramif/memstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13608 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 174
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
WaveRestoreZoom {0 ps} {36454 ps}
