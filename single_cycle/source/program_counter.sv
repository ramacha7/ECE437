`include "program_counter_if.vh"
`include "cpu_types_pkg.vh"

module program_counter(
    input logic CLK, nRST, program_counter_if.pu pcif
);

    import cpu_types_pkg::*;

    always_comb begin
        pcif.next_pc = pcif.pc + 4;
    end

    always_ff @(posedge CLK,negedge nRST) begin
        if(!nRST) begin
            pcif.pc <= '0;
        end

        else begin
            if(pcif.pc_incr) begin
                pcif.pc <= pcif.pc_comb;
            end
        end
    end


endmodule