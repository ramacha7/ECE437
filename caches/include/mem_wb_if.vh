`ifndef MEM_WB_IF_VH
`define MEM_WB_IF_VH

// types
`include "cpu_types_pkg.vh"

////////////////// !!!!!! HAVE NOT REMOVED UNREQUIRED SIGNALS FROM THIS INTERFACE !!!!!!!!!!!!!!!

interface mem_wb_if;
  // import types
  import cpu_types_pkg::*;

    logic flush,stall,ihit,dhit,mem_op;                  //signals for dhit and ihit from datapath cache interface signals
    word_t branchaddr_out,branchaddr_in;    //for cputracker
    word_t pc_in,pc_out,npc_in, npc_out;             //variables for pc
    word_t ALUOut_in, ALUOut_out; //ALU Output 
    word_t dmemload_in, dmemload_out; //Data memory
    word_t instr_in, instr_out;
    opcode_t opcode_in, opcode_out;
    funct_t funct_in, funct_out;
    word_t rdat2_in, rdat2_out;
    word_t rdat1_in, rdat1_out;
    logic[4:0] rs_in, rd_in , rt_in, rs_out, rd_out, rt_out;   //variables for rs,rd and rt
    word_t imm32_in, imm32_out;
    logic[15:0] imm16_in, imm16_out;
    logic halt_in, halt_out;                        //signals for halt
    logic ALUSrc_in, JAL_in, BEQ_in, RegWr_in, ALUSrc_out, JAL_out, BEQ_out, RegWr_out;    //some of one bit control signals
    logic[1:0] PCSrc_in, ExtOp_in, RegDst_in, PCSrc_out, ExtOp_out, RegDst_out;              //some of two bit control signals
    logic MemtoReg_in, MemWr_in, iREN_in, MemtoReg_out, MemWr_out, iREN_out;    //signals for read(instr,data) and write(data) (for load and store)(same as dWEN and dREN)  
    aluop_t ALUOP_in, ALUOP_out;     //signals for ALUOP


    modport memwb (
        input   flush,stall,ihit,dhit,npc_in,pc_in,halt_in, ALUOut_in, dmemload_in,rs_in,rd_in,rt_in,imm16_in,imm32_in,
                ALUSrc_in, JAL_in, BEQ_in, RegWr_in,PCSrc_in,ExtOp_in,RegDst_in,
                MemtoReg_in, MemWr_in, iREN_in,ALUOP_in,instr_in,opcode_in,funct_in, rdat1_in, rdat2_in,branchaddr_in,mem_op,

        output  npc_out,pc_out,rs_out,halt_out, ALUOut_out, dmemload_out,rd_out,rt_out,imm16_out,imm32_out,
                ALUSrc_out, JAL_out, BEQ_out, RegWr_out,PCSrc_out,ExtOp_out,RegDst_out,
                MemtoReg_out, MemWr_out, iREN_out,ALUOP_out,instr_out,opcode_out,funct_out, rdat1_out, rdat2_out,branchaddr_out
    );

    modport tb (
        input   npc_out,pc_out,halt_out, ALUOut_out, dmemload_out,rs_out,rd_out,rt_out,imm16_out,imm32_out,
                ALUSrc_out, JAL_out, BEQ_out, RegWr_out,PCSrc_out,ExtOp_out,RegDst_out,
                MemtoReg_out, MemWr_out, iREN_out,ALUOP_out,instr_out,opcode_out,funct_out, rdat1_out, rdat2_out,branchaddr_out,

        output  flush,stall,ihit,dhit,npc_in,pc_in,halt_in, ALUOut_in, dmemload_in,rs_in,rd_in,rt_in,imm16_in,imm32_in,
                ALUSrc_in, JAL_in, BEQ_in, RegWr_in,PCSrc_in,ExtOp_in,RegDst_in,
                MemtoReg_in, MemWr_in, iREN_in,ALUOP_in,instr_in,opcode_in,funct_in, rdat1_in, rdat2_in,branchaddr_in,mem_op
    );

endinterface

`endif //MEM_WB_IF_VH