`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

    word_t instr, flush, stall;
    regbits_t rs,rd,rt;
    logic[15:0] imm_val;
    aluop_t ALUOP;
    logic [1:0] PCSrc,RegDst,ExtOp;        //for regdst: either Rd, Rt, or $31
    logic halt;
    logic RegWr,MemtoReg,dWEN,dREN,iREN,ALUSrc;        //general control signals    (dWEN is the same as MemWr)
    logic JAL,LUI,JR;    //Signals to denote I-type specific instructions
    logic BNE,BEQ,equal,dhit,ihit;

    modport cu (
        input instr,dhit,ihit,flush, stall,
        output PCSrc,RegWr,RegDst,ExtOp,ALUSrc,MemtoReg,halt,dREN,dWEN,iREN,JAL,JR,LUI,ALUOP,BNE,BEQ,rs,rd,rt,imm_val
    );

    modport tb (
        input PCSrc,RegWr,RegDst,ExtOp,ALUSrc,MemtoReg,halt,dREN,dWEN,iREN,JAL,JR,LUI,ALUOP,BNE,BEQ,rs,rd,rt,imm_val,
        output instr,dhit,ihit, flush, stall
    );

    //ask about testbench modport definition

endinterface

`endif //CONTROL_UNIT_IF_VH
