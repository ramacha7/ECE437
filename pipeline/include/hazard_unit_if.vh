/*
  Eric Villasenor
  evillase@gmail.com

  register file interface
*/
`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic equal_exmem, BEQ_exmem, BNE_exmem, dhit, MemtoReg_idex, MemWr_idex, ihit,RegWr_exmem, br_nottaken; 
  logic[1:0] RegDst_exmem; 
  logic flush_ifid, stall_ifid,flush_idex, stall_idex,flush_exmem, stall_exmem, flush_memwb, stall_memwb;   //flush and stall signals for alll pipeline registers 
  logic flush_branch_ifid, flush_branch_idex;
  logic[1:0] PCSrc_exmem, PCSrc_idex;
  regbits_t rt_idex,rt_exmem,rd_exmem,rs_ifid,rt_ifid;
  word_t    instr;

  // forwarding unit ports
  modport hu (
    input   rt_idex, equal_exmem, BEQ_exmem, BNE_exmem, instr, dhit, MemtoReg_idex, MemWr_idex, ihit,PCSrc_exmem,rt_exmem,rd_exmem,RegDst_exmem,rs_ifid,rt_ifid,RegWr_exmem,PCSrc_idex,br_nottaken,
    output  flush_ifid, stall_ifid,flush_idex, stall_idex,flush_exmem, stall_exmem, flush_memwb, stall_memwb,flush_branch_ifid, flush_branch_idex
  );
  // forwarding unit tb
  modport tb (
    input   flush_ifid, stall_ifid,flush_idex, stall_idex,flush_exmem, stall_exmem, flush_memwb, stall_memwb,flush_branch_ifid, flush_branch_idex,
    output  rt_idex, equal_exmem, BEQ_exmem, BNE_exmem, instr, dhit, MemtoReg_idex, MemWr_idex, ihit, PCSrc_exmem, rt_exmem,rd_exmem,RegDst_exmem,rs_ifid,rt_ifid,RegWr_exmem,PCSrc_idex, br_nottaken
  );
endinterface

`endif //HAZARD_UNIT_IF_VH