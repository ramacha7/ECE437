/*
  Eric Villasenor
  evillase@gmail.com

  register file interface
*/
`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic     [1:0] forwardA, forwardB;
  logic     RegWr_memwb, RegWr_exmem;
  regbits_t rs_idex, rt_idex, rt_memwb, rd_memwb, rt_exmem, rd_exmem;
  logic [1:0] RegDst_memwb, RegDst_exmem;
  word_t    ALUOut_exmem, wdat_memwb;

  // forwarding unit ports
  modport fu (
    input   RegWr_memwb, RegDst_memwb, wdat_memwb, RegDst_exmem, RegWr_exmem, ALUOut_exmem, rt_memwb, rd_memwb, rt_exmem, rd_exmem, rs_idex, rt_idex,
    output  forwardA, forwardB
  );
  // forwarding unit tb
  modport tb (
    input   forwardA, forwardB,
    output  RegWr_memwb, RegDst_memwb, wdat_memwb, RegDst_exmem, RegWr_exmem, ALUOut_exmem, rt_memwb, rd_memwb, rt_exmem, rd_exmem, rs_idex, rt_idex
  );
endinterface

`endif //FORWARDING_UNIT_IF_VH