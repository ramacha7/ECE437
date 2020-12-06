//Interface
`include "if_id_if.vh"
`include "cpu_types_pkg.vh"

module if_id(input logic CLK, nRST, if_id_if.ifid ifid_if);

    import cpu_types_pkg::*;
    
    always_ff @(posedge CLK,negedge nRST) begin
        if(!nRST) begin
            ifid_if.npc_out <= '0;
            ifid_if.instr_out <= '0;
            ifid_if.pc_out <= '0;
            ifid_if.opcode_out <= RTYPE;
        end
        else if(ifid_if.flush_branch || (ifid_if.flush && ifid_if.ihit)) begin
            ifid_if.npc_out <= '0;
            ifid_if.instr_out <= '0;
            ifid_if.pc_out <= '0;
            ifid_if.opcode_out <= RTYPE;
        end
        else begin
            if(ifid_if.ihit && ~ifid_if.stall) begin
                ifid_if.npc_out <= ifid_if.npc_in;
                ifid_if.instr_out <= ifid_if.instr_in;
                ifid_if.pc_out <= ifid_if.pc_in;
                ifid_if.opcode_out <= ifid_if.opcode_in;
            end
        end
    end


endmodule