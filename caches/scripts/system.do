onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -group PC -color Cyan /system_tb/DUT/CPU/DP/PC_DUT/pcif/pc
add wave -noupdate -group PC -color Cyan /system_tb/DUT/CPU/DP/PC_DUT/pcif/next_pc
add wave -noupdate -group PC -color Cyan /system_tb/DUT/CPU/DP/PC_DUT/pcif/pc_comb
add wave -noupdate -group PC -color Cyan /system_tb/DUT/CPU/DP/PC_DUT/pcif/pc_incr
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/opcode
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/func
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/instr
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/rs
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/rd
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/rt
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/imm_val
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/ALUOP
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/PCSrc
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/RegDst
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/ExtOp
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/halt
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/RegWr
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/MemtoReg
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/dWEN
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/dREN
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/iREN
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/ALUSrc
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/JAL
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/LUI
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/JR
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/BNE
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/BEQ
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/equal
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/dhit
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/CU_DUT/cuif/ihit
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/IFID_DUT/ifid_if/flush
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/IFID_DUT/ifid_if/stall
add wave -noupdate -group Control_unit -color Yellow /system_tb/DUT/CPU/DP/IFID_DUT/ifid_if/ihit
add wave -noupdate -group IFID /system_tb/DUT/CPU/DP/ifid/opcode_out
add wave -noupdate -group IFID -color {Violet Red} /system_tb/DUT/CPU/DP/ifid/flush
add wave -noupdate -group IFID -color {Violet Red} /system_tb/DUT/CPU/DP/ifid/stall
add wave -noupdate -group IFID -color {Violet Red} /system_tb/DUT/CPU/DP/ifid/ihit
add wave -noupdate -group IFID -color {Violet Red} /system_tb/DUT/CPU/DP/ifid/npc_in
add wave -noupdate -group IFID -color {Violet Red} /system_tb/DUT/CPU/DP/ifid/npc_out
add wave -noupdate -group IFID -color {Violet Red} /system_tb/DUT/CPU/DP/ifid/instr_in
add wave -noupdate -group IFID -color {Violet Red} /system_tb/DUT/CPU/DP/ifid/instr_out
add wave -noupdate -group IFID /system_tb/DUT/CPU/DP/ifid/flush_branch
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/CLK
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/nRST
add wave -noupdate -group ICACHE -expand /system_tb/DUT/CPU/CM/ICACHE/icache_table
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/tag
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/index
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/hit
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/miss
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/i
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/opcode_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/flush
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/stall
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/ihit
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/dhit
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/npc_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/npc_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/instr_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/instr_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rdat1_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rdat1_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rdat2_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rdat2_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rs_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rs_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rd_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rd_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rt_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/rt_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/imm16_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/imm16_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/imm32_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/imm32_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/halt_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/halt_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/ALUSrc_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/ALUSrc_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/JAL_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/JAL_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/BEQ_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/BEQ_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/BNE_in
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/BNE_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/RegWr_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/RegWr_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/PCSrc_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/PCSrc_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/ExtOp_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/ExtOp_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/RegDst_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/RegDst_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/MemtoReg_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/MemtoReg_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/MemWr_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/MemWr_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/iREN_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/iREN_out
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/ALUOP_in
add wave -noupdate -group IDEX -color Sienna /system_tb/DUT/CPU/DP/idex/ALUOP_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/flush_branch
add wave -noupdate -group ALU -color Khaki /system_tb/DUT/CPU/DP/ALU_DUT/aif/neg
add wave -noupdate -group ALU -color Khaki /system_tb/DUT/CPU/DP/ALU_DUT/aif/ovf
add wave -noupdate -group ALU -color Khaki /system_tb/DUT/CPU/DP/ALU_DUT/aif/zero
add wave -noupdate -group ALU -color Khaki /system_tb/DUT/CPU/DP/ALU_DUT/aif/ALUOP
add wave -noupdate -group ALU -color Khaki /system_tb/DUT/CPU/DP/ALU_DUT/aif/portA
add wave -noupdate -group ALU -color Khaki /system_tb/DUT/CPU/DP/ALU_DUT/aif/portB
add wave -noupdate -group ALU -color Khaki /system_tb/DUT/CPU/DP/ALU_DUT/aif/out_port
add wave -noupdate -group EXMEM /system_tb/DUT/CPU/DP/exmem/opcode_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/stall
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/flush
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ihit
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/dhit
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/npc_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/npc_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/instr_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/instr_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ALUOut_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ALUOut_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rdat2_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rdat2_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rs_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rs_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rd_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rd_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rt_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/rt_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/imm16_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/imm16_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/imm32_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/imm32_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/halt_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/halt_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ALUSrc_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ALUSrc_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/JAL_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/JAL_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/BEQ_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/BEQ_out
add wave -noupdate -group EXMEM /system_tb/DUT/CPU/DP/exmem/BNE_in
add wave -noupdate -group EXMEM /system_tb/DUT/CPU/DP/exmem/BNE_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/RegWr_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/RegWr_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/PCSrc_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/PCSrc_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ExtOp_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ExtOp_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/RegDst_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/RegDst_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/MemtoReg_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/MemtoReg_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/MemWr_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/MemWr_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/iREN_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/iREN_out
add wave -noupdate -group EXMEM /system_tb/DUT/CPU/DP/EXMEM_DUT/exmem/zero_in
add wave -noupdate -group EXMEM /system_tb/DUT/CPU/DP/EXMEM_DUT/exmem/zero_out
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ALUOP_in
add wave -noupdate -group EXMEM -color {Medium Sea Green} /system_tb/DUT/CPU/DP/exmem/ALUOP_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/opcode_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/flush
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/stall
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ihit
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/dhit
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/npc_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/npc_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ALUOut_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ALUOut_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/dmemload_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/dmemload_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/rs_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/rs_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/rd_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/rd_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/rt_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/rt_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/imm32_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/imm32_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/imm16_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/imm16_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/halt_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/halt_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ALUSrc_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ALUSrc_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/JAL_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/JAL_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/BEQ_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/BEQ_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/RegWr_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/RegWr_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/PCSrc_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/PCSrc_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ExtOp_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ExtOp_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/RegDst_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/RegDst_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/MemtoReg_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/MemtoReg_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/MemWr_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/MemWr_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/iREN_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/iREN_out
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ALUOP_in
add wave -noupdate -group MEMWB /system_tb/DUT/CPU/DP/memwb/ALUOP_out
add wave -noupdate -group REG_FILE /system_tb/DUT/CPU/DP/RF_DUT/registers
add wave -noupdate -group REG_FILE -color {Blue Violet} /system_tb/DUT/CPU/DP/RF_DUT/rfif/WEN
add wave -noupdate -group REG_FILE -color {Blue Violet} /system_tb/DUT/CPU/DP/RF_DUT/rfif/wsel
add wave -noupdate -group REG_FILE -color {Blue Violet} /system_tb/DUT/CPU/DP/RF_DUT/rfif/rsel1
add wave -noupdate -group REG_FILE -color {Blue Violet} /system_tb/DUT/CPU/DP/RF_DUT/rfif/rsel2
add wave -noupdate -group REG_FILE -color {Blue Violet} /system_tb/DUT/CPU/DP/RF_DUT/rfif/wdat
add wave -noupdate -group REG_FILE -color {Blue Violet} /system_tb/DUT/CPU/DP/RF_DUT/rfif/rdat1
add wave -noupdate -group REG_FILE -color {Blue Violet} /system_tb/DUT/CPU/DP/RF_DUT/rfif/rdat2
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/currState
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nextState
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/addrTag
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/addrIndex
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/addrOffset
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/flush_set
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_flush_set
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/flush_frame
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_flush_frame
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/lru
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_lru
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/cnt
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_cnt
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/i
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/j
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/dcache_table
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/set
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/bneaddr
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/jraddr
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/jaddr
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/br_nottaken
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/PCSrc_br
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/beqaddr
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/branch_op
add wave -noupdate -group Datapath_cache -group Datapath(local) /system_tb/DUT/CPU/DP/beq
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group Datapath_cache /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/forwardA
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/forwardB
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/FU_DUT/exmem_rd
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/FU_DUT/memwb_rd
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/rs_idex
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/rt_idex
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/rt_exmem
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/rt_memwb
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/rd_exmem
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/rd_memwb
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/RegDst_exmem
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/RegWr_exmem
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/RegDst_memwb
add wave -noupdate -group {Forwading Unit} /system_tb/DUT/CPU/DP/fuif/RegWr_memwb
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/BEQ_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/BNE_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/dhit
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/equal_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/instr
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/MemtoReg_idex
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/rt_idex
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/HU_DUT/instr_opcode
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/HU_DUT/rs_ifid
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/HU_DUT/rt_ifid
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/RegDst_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/HU_DUT/exmem_rd
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/flush_ifid
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/stall_ifid
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/flush_idex
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/stall_idex
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/flush_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/stall_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/flush_memwb
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/stall_memwb
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/rt_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/rd_exmem
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/rs_ifid
add wave -noupdate -group HAZARD_UNIT /system_tb/DUT/CPU/DP/huif/rt_ifid
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -expand -group {Cache Control} /system_tb/DUT/CPU/ccif/ccwrite
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {600000 ps} 0}
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
WaveRestoreZoom {0 ps} {2050244 ps}
