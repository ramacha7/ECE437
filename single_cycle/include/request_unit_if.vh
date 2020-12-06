`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

    logic reg_dREN, reg_dWEN, dREN,dWEN,dhit,ihit;

    modport ru (
        input dREN,dWEN,dhit,ihit,
        output reg_dREN, reg_dWEN
    );

    modport tb (     
        input reg_dREN, reg_dWEN,
        output dREN,dWEN,dhit,ihit
    );

    //ask about testbench modport definition


endinterface

`endif //PROGRAM_COUNTER_IF_VH