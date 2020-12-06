onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/syif/halt
add wave -noupdate /system_tb/DUT/CPU/DP/CU_DUT/opcode
add wave -noupdate /system_tb/DUT/CPU/DP/CU_DUT/func
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/halt
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/datomic
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/flushed
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -expand -group datapath_cache /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/instr
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/rs
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/rd
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/rt
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/imm_val
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/ALUOp
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/PCSrc
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/ALUSrc
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/RegDst
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/ExtOp
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/RegWr
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/MemtoReg
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/dREN
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/iREN
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/JAL
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/LUI
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/JR
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/BNE
add wave -noupdate -group control_unit /system_tb/DUT/CPU/DP/cuif/BEQ
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/zero
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/ALUOP
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/portA
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/portB
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/out_port
add wave -noupdate -expand -group program_counter /system_tb/DUT/CPU/DP/pcif/pc
add wave -noupdate -expand -group program_counter /system_tb/DUT/CPU/DP/pcif/next_pc
add wave -noupdate -expand -group program_counter /system_tb/DUT/CPU/DP/pcif/pc_comb
add wave -noupdate -expand -group program_counter /system_tb/DUT/CPU/DP/pcif/pc_incr
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group reg_file -expand /system_tb/DUT/CPU/DP/RF_DUT/registers
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -group request_unit /system_tb/DUT/CPU/DP/ruif/reg_dREN
add wave -noupdate -group request_unit /system_tb/DUT/CPU/DP/ruif/reg_dWEN
add wave -noupdate -group request_unit /system_tb/DUT/CPU/DP/ruif/dREN
add wave -noupdate -group request_unit /system_tb/DUT/CPU/DP/ruif/dWEN
add wave -noupdate -group request_unit /system_tb/DUT/CPU/DP/ruif/dhit
add wave -noupdate -group request_unit /system_tb/DUT/CPU/DP/ruif/ihit
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/iwait
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/dwait
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/iREN
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/dREN
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/dWEN
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/dload
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/dstore
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/iaddr
add wave -noupdate -expand -group memory_control /system_tb/DUT/CPU/CC/ccif/daddr
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67654 ps} 0}
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
WaveRestoreZoom {0 ps} {62119 ps}
