`ifndef ID_EX_IF_VH
`define ID_EX_IF_VH

// types
`include "cpu_types_pkg.vh"

interface id_ex_if;
  // import types
  import cpu_types_pkg::*;

    logic flush,stall,flush_branch,ihit,dhit,mem_op;                  //signals for dhit and ihit from datapath cache interface signals
    word_t pc_in,pc_out,npc_in, npc_out;             //variables for pc
    word_t instr_in, instr_out;      //variables for instruction
    word_t rdat1_in, rdat2_in, rdat1_out, rdat2_out;       //variables for portA and portB values out of reg files
    logic[4:0] rs_in, rd_in , rt_in, rs_out, rd_out, rt_out;   //variables for rs,rd and rt
    logic[15:0] imm16_in, imm16_out;              //signals for immediate value
    word_t imm32_in, imm32_out;
    logic halt_in, halt_out;                        //signals for halt
    logic ALUSrc_in, JAL_in, BEQ_in, RegWr_in, ALUSrc_out, JAL_out, BEQ_out, RegWr_out, BNE_in, BNE_out;    //some of one bit control signals
    logic[1:0] PCSrc_in, ExtOp_in, RegDst_in, PCSrc_out, ExtOp_out, RegDst_out;              //some of two bit control signals
    logic MemtoReg_in, MemWr_in, iREN_in, MemtoReg_out, MemWr_out, iREN_out;    //signals for read(instr,data) and write(data) (for load and store)(same as dWEN and dREN)
    aluop_t ALUOP_in, ALUOP_out;     //signals for ALUOP
    opcode_t opcode_in, opcode_out;


    modport idex (
        input   flush,stall,ihit,dhit,pc_in,npc_in,instr_in,rdat1_in,rdat2_in,rs_in,rd_in,rt_in,imm16_in,imm32_in,halt_in,
                ALUSrc_in, JAL_in, BEQ_in, RegWr_in,PCSrc_in,ExtOp_in,RegDst_in,
                MemtoReg_in, MemWr_in, iREN_in,ALUOP_in, BNE_in,opcode_in,flush_branch,mem_op,

        output  npc_out,pc_out,instr_out,rdat1_out,rdat2_out,rs_out,rd_out,rt_out,imm16_out,imm32_out,halt_out,
                ALUSrc_out, JAL_out, BEQ_out, RegWr_out,PCSrc_out,ExtOp_out,RegDst_out,
                MemtoReg_out, MemWr_out, iREN_out,ALUOP_out, BNE_out,opcode_out
    );

    modport tb (
        input   npc_out,pc_out,instr_out,rdat1_out,rdat2_out,rs_out,rd_out,rt_out,imm16_out,imm32_out,halt_out,
                ALUSrc_out, JAL_out, BEQ_out, RegWr_out,PCSrc_out,ExtOp_out,RegDst_out,
                MemtoReg_out, MemWr_out, iREN_out,ALUOP_out, BNE_out,opcode_out,

        output  flush,stall,ihit,dhit,npc_in,pc_in,instr_in,rdat1_in,rdat2_in,rs_in,rd_in,rt_in,imm16_in,imm32_in,halt_in,
                ALUSrc_in, JAL_in, BEQ_in, RegWr_in,PCSrc_in,ExtOp_in,RegDst_in,
                MemtoReg_in, MemWr_in, iREN_in,ALUOP_in, BNE_in,opcode_in,flush_branch,mem_op
    );

endinterface

`endif //ID_EX_IF_VH
