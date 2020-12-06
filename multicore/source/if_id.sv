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
        else if(ifid_if.flush_branch) begin
            ifid_if.npc_out <= '0;
            ifid_if.instr_out <= '0;
            ifid_if.pc_out <= '0;
            ifid_if.opcode_out <= RTYPE;
        end
        else if(ifid_if.flush) begin
            if(ifid_if.mem_op && ifid_if.ihit && ifid_if.dhit) begin
                //If there is a memory operation we only want to flush on ihit and dhit
                ifid_if.npc_out <= '0;
                ifid_if.instr_out <= '0;
                ifid_if.pc_out <= '0;
                ifid_if.opcode_out <= RTYPE;
            end
            else if(~ifid_if.mem_op && ifid_if.ihit) begin
                //If there is no memory operation we want to flush on ihit
                ifid_if.npc_out <= '0;
                ifid_if.instr_out <= '0;
                ifid_if.pc_out <= '0;
                ifid_if.opcode_out <= RTYPE;
            end
        end
        else begin
            //if there is a mem op in exmem stage, stall all pipes until dhit is on,then on next ihit, enable pipes
            if(ifid_if.mem_op) begin
                if(ifid_if.ihit && ifid_if.dhit && ~ifid_if.stall) begin
                    ifid_if.npc_out <= ifid_if.npc_in;
                    ifid_if.instr_out <= ifid_if.instr_in;
                    ifid_if.pc_out <= ifid_if.pc_in;
                    ifid_if.opcode_out <= ifid_if.opcode_in;
                end
            end
            //if there is no mem op in exmem stage, then use ihit and stall to enable pipes
            else if(ifid_if.ihit && ~ifid_if.stall) begin
                ifid_if.npc_out <= ifid_if.npc_in;
                ifid_if.instr_out <= ifid_if.instr_in;
                ifid_if.pc_out <= ifid_if.pc_in;
                ifid_if.opcode_out <= ifid_if.opcode_in;
            end
        end
    end


endmodule