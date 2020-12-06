onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/nRST
add wave -noupdate /memory_control_tb/PROG/test_num
add wave -noupdate /memory_control_tb/PROG/test_case
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/state
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/next_state
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/CPUS
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/next_snooper
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/next_snoopy
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/nRST
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/snooper
add wave -noupdate -expand -group BUS_ctrller /memory_control_tb/DUT/snoopy
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ccinv
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ccsnoopaddr
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/cctrans
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ccwait
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ccwrite
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/CPUS
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/daddr
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/dload
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/dREN
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/dstore
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/dwait
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/dWEN
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/iaddr
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/iload
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/iREN
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/iwait
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ramaddr
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ramload
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ramREN
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ramstate
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ramstore
add wave -noupdate -group Cache_ctrl /memory_control_tb/DUT/ccif/ramWEN
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/memaddr
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/memREN
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/memstore
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/memWEN
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/ramaddr
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/ramload
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/ramREN
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/ramstate
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/ramstore
add wave -noupdate -expand -group {RAM SIGNALS} /memory_control_tb/ram_if/ramWEN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19452 ps} 0}
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
WaveRestoreZoom {0 ps} {1 us}
