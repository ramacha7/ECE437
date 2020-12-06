//Interface
`include "id_ex_if.vh"
`include "cpu_types_pkg.vh"

module id_ex(input logic CLK, nRST, id_ex_if.idex idex_if);

    import cpu_types_pkg::*;

    always_ff @(posedge CLK,negedge nRST) begin
        if(!nRST) begin
            idex_if.npc_out <= '0;
            idex_if.instr_out <= '0;
            idex_if.rdat1_out <= '0;
            idex_if.rdat2_out <= '0;
            idex_if.rs_out <= '0;
            idex_if.rd_out <= '0;
            idex_if.rt_out <= '0;
            idex_if.imm16_out <= '0;
            idex_if.imm32_out <= '0;
            idex_if.halt_out <= '0;
            idex_if.ALUSrc_out <= '0;
            idex_if.JAL_out <= '0;
            idex_if.BEQ_out <= '0;
            idex_if.BNE_out <= '0;
            idex_if.RegWr_out <= '0;
            idex_if.PCSrc_out <= '0;
            idex_if.ExtOp_out <= '0;
            idex_if.RegDst_out <= '0;
            idex_if.MemtoReg_out <= '0;
            idex_if.MemWr_out <= '0;
            idex_if.iREN_out <= 1;
            idex_if.dREN_out <= '0;
            idex_if.ALUOP_out <= ALU_SLL;
            idex_if.pc_out <= '0;
            idex_if.opcode_out <= RTYPE;
        end
        else if(idex_if.flush_branch) begin
            idex_if.npc_out <= '0;
            idex_if.instr_out <= '0;
            idex_if.rdat1_out <= '0;
            idex_if.rdat2_out <= '0;
            idex_if.rs_out <= '0;
            idex_if.rd_out <= '0;
            idex_if.rt_out <= '0;
            idex_if.imm16_out <= '0;
            idex_if.imm32_out <= '0;
            idex_if.halt_out <= '0;
            idex_if.ALUSrc_out <= '0;
            idex_if.JAL_out <= '0;
            idex_if.BEQ_out <= '0;
            idex_if.BNE_out <= '0;
            idex_if.RegWr_out <= '0;
            idex_if.PCSrc_out <= '0;
            idex_if.ExtOp_out <= '0;
            idex_if.RegDst_out <= '0;
            idex_if.MemtoReg_out <= '0;
            idex_if.MemWr_out <= '0;
            idex_if.iREN_out <= 1;
            idex_if.dREN_out <= '0;
            idex_if.ALUOP_out <= ALU_SLL;
            idex_if.pc_out <= '0;
            idex_if.opcode_out <= RTYPE;
        end
        else if(idex_if.flush == 1'b1) begin
            if(idex_if.mem_op && idex_if.ihit && idex_if.dhit) begin
                //If there is a memory operation we only want to flush on ihit and dhit
                idex_if.npc_out <= '0;
                idex_if.instr_out <= '0;
                idex_if.rdat1_out <= '0;
                idex_if.rdat2_out <= '0;
                idex_if.rs_out <= '0;
                idex_if.rd_out <= '0;
                idex_if.rt_out <= '0;
                idex_if.imm16_out <= '0;
                idex_if.imm32_out <= '0;
                idex_if.halt_out <= '0;
                idex_if.ALUSrc_out <= '0;
                idex_if.JAL_out <= '0;
                idex_if.BEQ_out <= '0;
                idex_if.BNE_out <= '0;
                idex_if.RegWr_out <= '0;
                idex_if.PCSrc_out <= '0;
                idex_if.ExtOp_out <= '0;
                idex_if.RegDst_out <= '0;
                idex_if.MemtoReg_out <= '0;
                idex_if.MemWr_out <= '0;
                idex_if.iREN_out <= 1;
                idex_if.dREN_out <= '0;
                idex_if.ALUOP_out <= ALU_SLL;
                idex_if.pc_out <= '0;
                idex_if.opcode_out <= RTYPE;
            end
            else if(~idex_if.mem_op && idex_if.ihit) begin
                //If there is no memory operation we want to flush on ihit
                idex_if.npc_out <= '0;
                idex_if.instr_out <= '0;
                idex_if.rdat1_out <= '0;
                idex_if.rdat2_out <= '0;
                idex_if.rs_out <= '0;
                idex_if.rd_out <= '0;
                idex_if.rt_out <= '0;
                idex_if.imm16_out <= '0;
                idex_if.imm32_out <= '0;
                idex_if.halt_out <= '0;
                idex_if.ALUSrc_out <= '0;
                idex_if.JAL_out <= '0;
                idex_if.BEQ_out <= '0;
                idex_if.BNE_out <= '0;
                idex_if.RegWr_out <= '0;
                idex_if.PCSrc_out <= '0;
                idex_if.ExtOp_out <= '0;
                idex_if.RegDst_out <= '0;
                idex_if.MemtoReg_out <= '0;
                idex_if.MemWr_out <= '0;
                idex_if.iREN_out <= 1;
                idex_if.dREN_out <= '0;
                idex_if.ALUOP_out <= ALU_SLL;
                idex_if.pc_out <= '0;
                idex_if.opcode_out <= RTYPE;
            end
        end
        else begin
            //if there is a mem op in exmem stage, stall all pipes until dhit is on,then on next ihit, enable pipes
            if(idex_if.mem_op) begin
                if(idex_if.ihit && idex_if.dhit && ~idex_if.stall) begin
                    idex_if.npc_out <= idex_if.npc_in;
                    idex_if.instr_out <= idex_if.instr_in;
                    idex_if.rdat1_out <= idex_if.rdat1_in;
                    idex_if.rdat2_out <= idex_if.rdat2_in;
                    idex_if.rs_out <= idex_if.rs_in;
                    idex_if.rd_out <= idex_if.rd_in;
                    idex_if.rt_out <= idex_if.rt_in;
                    idex_if.imm16_out <= idex_if.imm16_in;
                    idex_if.imm32_out <= idex_if.imm32_in;
                    idex_if.halt_out <= idex_if.halt_in;
                    idex_if.ALUSrc_out <= idex_if.ALUSrc_in;
                    idex_if.JAL_out <= idex_if.JAL_in;
                    idex_if.BEQ_out <= idex_if.BEQ_in;
                    idex_if.BNE_out <= idex_if.BNE_in;
                    idex_if.RegWr_out <= idex_if.RegWr_in;
                    idex_if.PCSrc_out <= idex_if.PCSrc_in;
                    idex_if.ExtOp_out <= idex_if.ExtOp_in;
                    idex_if.RegDst_out <= idex_if.RegDst_in;
                    idex_if.MemtoReg_out <= idex_if.MemtoReg_in;
                    idex_if.MemWr_out <= idex_if.MemWr_in;
                    idex_if.iREN_out <= 1;
                    idex_if.dREN_out <= idex_if.dREN_in;
                    idex_if.ALUOP_out <= idex_if.ALUOP_in;
                    idex_if.pc_out <= idex_if.pc_in;
                    idex_if.opcode_out <= idex_if.opcode_in;
                end
            end
            //if there is no mem op in exmem stage, then use ihit and stall to enable pipes
            else if(idex_if.ihit && ~idex_if.stall) begin
                idex_if.npc_out <= idex_if.npc_in;
                idex_if.instr_out <= idex_if.instr_in;
                idex_if.rdat1_out <= idex_if.rdat1_in;
                idex_if.rdat2_out <= idex_if.rdat2_in;
                idex_if.rs_out <= idex_if.rs_in;
                idex_if.rd_out <= idex_if.rd_in;
                idex_if.rt_out <= idex_if.rt_in;
                idex_if.imm16_out <= idex_if.imm16_in;
                idex_if.imm32_out <= idex_if.imm32_in;
                idex_if.halt_out <= idex_if.halt_in;
                idex_if.ALUSrc_out <= idex_if.ALUSrc_in;
                idex_if.JAL_out <= idex_if.JAL_in;
                idex_if.BEQ_out <= idex_if.BEQ_in;
                idex_if.BNE_out <= idex_if.BNE_in;
                idex_if.RegWr_out <= idex_if.RegWr_in;
                idex_if.PCSrc_out <= idex_if.PCSrc_in;
                idex_if.ExtOp_out <= idex_if.ExtOp_in;
                idex_if.RegDst_out <= idex_if.RegDst_in;
                idex_if.MemtoReg_out <= idex_if.MemtoReg_in;
                idex_if.MemWr_out <= idex_if.MemWr_in;
                idex_if.iREN_out <= 1;
                idex_if.dREN_out <= idex_if.dREN_in;
                idex_if.ALUOP_out <= idex_if.ALUOP_in;
                idex_if.pc_out <= idex_if.pc_in;
                idex_if.opcode_out <= idex_if.opcode_in;
            end
        end
    end


endmodule