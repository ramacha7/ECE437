`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

// types
`include "cpu_types_pkg.vh"

interface program_counter_if;
  // import types
  import cpu_types_pkg::*;

    word_t pc,next_pc,pc_comb,PC_RESET;
    logic pc_incr;

    modport pu (
        input pc_comb,pc_incr,PC_RESET,
        output next_pc,pc
    );

    //ask about testbench modport definition


endinterface

`endif //PROGRAM_COUNTER_IF_VH
