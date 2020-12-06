`ifndef IF_ID_IF_VH
`define IF_ID_IF_VH

// types
`include "cpu_types_pkg.vh"

interface if_id_if;
  // import types
  import cpu_types_pkg::*;

    logic flush,stall,flush_branch,ihit;
    word_t pc_in,pc_out,npc_in,npc_out,instr_in,instr_out;
    opcode_t opcode_in, opcode_out;

    modport ifid (
        input flush,ihit,stall,npc_in,instr_in,pc_in,opcode_in,flush_branch,
        output instr_out, npc_out,pc_out,opcode_out
    );

    modport tb (
        input instr_out,npc_out,pc_out,opcode_out,
        output flush,stall,npc_in,instr_in,ihit,pc_in,opcode_in,flush_branch
    );

endinterface

`endif //IF_ID_IF_VH