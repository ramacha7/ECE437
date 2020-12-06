`include "ex_mem_if.vh"
`include "cpu_types_pkg.vh"

module ex_mem(
    input logic CLK, nRST, ex_mem_if exmem
);

    import cpu_types_pkg::*;

    always_ff @(posedge CLK, negedge nRST) begin
        if(nRST == 0) begin
            exmem.npc_out <= '0;
            exmem.instr_out <= '0;
            exmem.ALUOut_out <= '0;
            exmem.imm32_out <= '0;
            exmem.imm16_out <= '0;
            exmem.halt_out <= '0;
            exmem.ALUSrc_out <= '0;
            exmem.JAL_out <= '0;
            exmem.BEQ_out <= '0;
            exmem.BNE_out <= '0;
            exmem.RegWr_out <= '0;
            exmem.PCSrc_out <= '0;
            exmem.ExtOp_out <= '0;
            exmem.RegDst_out <= '0;
            exmem.MemtoReg_out <= '0;
            exmem.MemWr_out <= '0;
            exmem.iREN_out <= '1;
            exmem.ALUOP_out <= ALU_SLL;
            exmem.rs_out <= '0;
            exmem.rd_out <= '0;
            exmem.rt_out <= '0;
            exmem.rdat2_out <= '0;
            exmem.rdat1_out <= '0;
            exmem.pc_out <= '0;
            exmem.zero_out <= '0;
            exmem.opcode_out <= RTYPE;
            exmem.br_nottaken_out <= '0;
            exmem.jraddr_forward_out <= '0;
        end

        else if(exmem.dhit == 1) begin
            exmem.npc_out <= '0;
            exmem.instr_out <= '0;
            exmem.ALUOut_out <= '0;
            exmem.imm32_out <= '0;
            exmem.imm16_out <= '0;
            exmem.halt_out <= '0;
            exmem.ALUSrc_out <= '0;
            exmem.JAL_out <= '0;
            exmem.BEQ_out <= '0;
            exmem.BNE_out <= '0;
            exmem.RegWr_out <= '0;
            exmem.PCSrc_out <= '0;
            exmem.ExtOp_out <= '0;
            exmem.RegDst_out <= '0;
            exmem.MemtoReg_out <= '0;
            exmem.MemWr_out <= '0;
            exmem.iREN_out <= '1;
            exmem.ALUOP_out <= ALU_SLL;
            exmem.rs_out <= '0;
            exmem.rd_out <= '0;
            exmem.rt_out <= '0;
            exmem.rdat2_out <= '0;
            exmem.rdat1_out <= '0;
            exmem.pc_out <= '0;
            exmem.zero_out <= '0;
            exmem.opcode_out <= RTYPE;
            exmem.br_nottaken_out <= '0;
            exmem.jraddr_forward_out <= '0;
        end

        else if((exmem.flush == 1) && (exmem.ihit == 1)) begin
            exmem.npc_out <= '0;
            exmem.instr_out <= '0;
            exmem.ALUOut_out <= '0;
            exmem.imm32_out <= '0;
            exmem.imm16_out <= '0;
            exmem.halt_out <= '0;
            exmem.ALUSrc_out <= '0;
            exmem.JAL_out <= '0;
            exmem.BEQ_out <= '0;
            exmem.BNE_out <= '0;
            exmem.RegWr_out <= '0;
            exmem.PCSrc_out <= '0;
            exmem.ExtOp_out <= '0;
            exmem.RegDst_out <= '0;
            exmem.MemtoReg_out <= '0;
            exmem.MemWr_out <= '0;
            exmem.iREN_out <= '1;
            exmem.ALUOP_out <= ALU_SLL;
            exmem.rs_out <= '0;
            exmem.rd_out <= '0;
            exmem.rt_out <= '0;
            exmem.rdat2_out <= '0;
            exmem.rdat1_out <= '0;
            exmem.pc_out <= '0;
            exmem.zero_out <= '0;
            exmem.opcode_out <= RTYPE;
            exmem.br_nottaken_out <= '0;
            exmem.jraddr_forward_out <= '0;
        end

        else if(exmem.ihit == 1) begin
            exmem.npc_out <= exmem.npc_in;
            exmem.instr_out <= exmem.instr_in;
            exmem.ALUOut_out <= exmem.ALUOut_in;
            exmem.imm32_out <= exmem.imm32_in;
            exmem.imm16_out <= exmem.imm16_in;
            exmem.halt_out <= exmem.halt_in;
            exmem.ALUSrc_out <= exmem.ALUSrc_in;
            exmem.JAL_out <= exmem.JAL_in;
            exmem.BEQ_out <= exmem.BEQ_in;
            exmem.BNE_out <= exmem.BNE_in;
            exmem.RegWr_out <= exmem.RegWr_in;
            exmem.PCSrc_out <= exmem.PCSrc_in;
            exmem.ExtOp_out <= exmem.ExtOp_in;
            exmem.RegDst_out <= exmem.RegDst_in;
            exmem.MemtoReg_out <= exmem.MemtoReg_in;
            exmem.MemWr_out <= exmem.MemWr_in;
            exmem.iREN_out <= exmem.iREN_in;
            exmem.ALUOP_out <= exmem.ALUOP_in;
            exmem.rs_out <= exmem.rs_in;
            exmem.rd_out <= exmem.rd_in;
            exmem.rt_out <= exmem.rt_in;
            exmem.rdat2_out <= exmem.rdat2_in;
            exmem.rdat1_out <= exmem.rdat1_in;
            exmem.pc_out <= exmem.pc_in;
            exmem.zero_out <= exmem.zero_in;
            exmem.opcode_out <= exmem.opcode_in;
            exmem.br_nottaken_out <= exmem.br_nottaken_in;
            exmem.jraddr_forward_out <= exmem.jraddr_forward_in;
        end
    end


endmodule