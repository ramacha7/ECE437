`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

module hazard_unit(
    input logic CLK, nRST, hazard_unit_if huif,forwarding_unit_if fuif
);

    import cpu_types_pkg::*;
    regbits_t rt_ifid, rs_ifid;
    logic [4:0] exmem_rd;     //variable to hold rd,rt for exmem
    opcode_t instr_opcode;

    assign rt_ifid = regbits_t'(huif.instr[20:16]);
    assign rs_ifid = regbits_t'(huif.instr[25:21]);
    assign instr_opcode = opcode_t'(huif.instr[31:26]);

    always_comb begin
        huif.flush_ifid = 0;
        huif.stall_ifid = 0;
        huif.flush_idex = 0;
        huif.stall_idex = 0;
        huif.flush_exmem = 0;
        huif.stall_exmem = 0;
        huif.flush_memwb = 0;
        huif.stall_memwb = 0;
        huif.flush_branch_ifid = 0;
        huif.flush_branch_idex = 0;

        if((huif.MemtoReg_idex) && ((huif.rt_idex == rt_ifid) || (huif.rt_idex == rs_ifid))) begin
            //Load hazard
            huif.stall_ifid = 1'b1;
            huif.flush_idex = 1'b1;
        end

        if(huif.RegWr_exmem && ((huif.rs_ifid == exmem_rd) || (huif.rt_ifid == exmem_rd)) && (huif.MemtoReg_idex || huif.MemWr_idex)) begin
            //Special case: load or store in between two dependent operations, so dhit does not flush our registers
            huif.stall_ifid = 1;
            huif.flush_idex = 1'b1;
        end

        if(huif.dhit) begin
            huif.stall_ifid = 0;
            huif.stall_idex = 0;
            huif.stall_exmem = 0;
            huif.stall_memwb = 0;
        end

        if(huif.br_nottaken) begin
            huif.stall_ifid = 1;
            huif.flush_idex = 1'b1;
        end

        if(((huif.BEQ_exmem && ~huif.equal_exmem) || (huif.BNE_exmem && huif.equal_exmem))) begin
            //for branch
            huif.flush_branch_ifid = 1'b1;
            huif.flush_branch_idex = 1'b1;
        end
        else if((huif.PCSrc_exmem == 2'd2 || huif.PCSrc_exmem == 2'd3)) begin
            //for jr,jal,j
            huif.flush_branch_ifid = 1'b1;
            huif.flush_branch_idex = 1'b1;
        end

        if(huif.PCSrc_idex == 2'd2 || huif.PCSrc_idex == 2'd3) begin
            huif.stall_ifid = 1;
            huif.flush_idex = 1'b1;
        end
    end


    //logic for calculatin destination register for exmem stage
    always_comb begin
        exmem_rd = '0;
        if(huif.RegDst_exmem == '0) begin
            exmem_rd = huif.rd_exmem;
        end
        else if(huif.RegDst_exmem == 2'd1) begin
            exmem_rd = huif.rt_exmem;
        end
    end
endmodule