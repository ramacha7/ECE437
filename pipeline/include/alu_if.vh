/*
  Eric Villasenor
  evillase@gmail.com

  register file interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic     neg, ovf, zero;
  aluop_t   ALUOP;
  word_t    portA, portB, out_port;

  // alu ports
  modport af (
    input   portA, portB, ALUOP,
    output  out_port, neg, ovf, zero
  );
  // alu tb
  modport tb (
    input   portA, portB, ALUOP,
    output  out_port, neg, ovf, zero
  );
endinterface

`endif //ALU_IF_VH
