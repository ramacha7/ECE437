`include "mem_wb_if.vh"
`include "cpu_types_pkg.vh"

module mem_wb(
    input logic CLK, nRST, mem_wb_if memwb
);

    import cpu_types_pkg::*;

    always_ff @(posedge CLK, negedge nRST) begin
        if(nRST == 0) begin
            memwb.npc_out <= '0;
            memwb.ALUOut_out <= '0;
            memwb.dmemload_out <= '0;
            memwb.imm32_out <= '0;
            memwb.imm16_out <= '0;
            memwb.halt_out <= '0;
            memwb.ALUSrc_out <= '0;
            memwb.JAL_out <= '0;
            memwb.BEQ_out <= '0;
            memwb.RegWr_out <= '0;
            memwb.PCSrc_out <= '0;
            memwb.ExtOp_out <= '0;
            memwb.RegDst_out <= '0;
            memwb.MemtoReg_out <= '0;
            memwb.instr_out <= '0;
            memwb.MemWr_out <= '0;
            memwb.iREN_out <= '1;
            memwb.ALUOP_out <= ALU_SLL;
            memwb.rs_out <= '0;
            memwb.rd_out <= '0;
            memwb.rt_out <= '0;
            memwb.opcode_out <= RTYPE;
            memwb.funct_out <= funct_t'('0);
            memwb.pc_out <= '0;
            memwb.rdat2_out <= '0;
            memwb.branchaddr_out <= '0;
        end
        else if(memwb.ihit || memwb.dhit) begin
            memwb.npc_out <= memwb.npc_in;
            memwb.ALUOut_out <= memwb.ALUOut_in;
            memwb.dmemload_out <= memwb.dmemload_in;
            memwb.imm32_out <= memwb.imm32_in;
            memwb.imm16_out <= memwb.imm16_in;
            memwb.halt_out <= memwb.halt_in;
            memwb.ALUSrc_out <= memwb.ALUSrc_in;
            memwb.JAL_out <= memwb.JAL_in;
            memwb.BEQ_out <= memwb.BEQ_in;
            memwb.RegWr_out <= memwb.RegWr_in;
            memwb.PCSrc_out <= memwb.PCSrc_in;
            memwb.ExtOp_out <= memwb.ExtOp_in;
            memwb.RegDst_out <= memwb.RegDst_in;
            memwb.MemtoReg_out <= memwb.MemtoReg_in;
            memwb.instr_out <= memwb.instr_in;
            memwb.MemWr_out <= memwb.MemWr_in;
            memwb.iREN_out <= memwb.iREN_in;
            memwb.ALUOP_out <= memwb.ALUOP_in;
            memwb.rs_out <= memwb.rs_in;
            memwb.rd_out <= memwb.rd_in;
            memwb.rt_out <= memwb.rt_in;
            memwb.opcode_out <= memwb.opcode_in;
            memwb.funct_out <= memwb.funct_in;
            memwb.pc_out <= memwb.pc_in;
            memwb.rdat2_out <= memwb.rdat2_in;
            memwb.branchaddr_out <= memwb.branchaddr_in;
        end
    end

endmodule