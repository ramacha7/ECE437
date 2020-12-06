`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

module request_unit(
    input logic CLK, nRST, request_unit_if.ru ruif
);

    import cpu_types_pkg::*;

    always_ff @(posedge CLK,negedge nRST) begin
        if(!nRST) begin
            ruif.reg_dWEN <= 0;
            ruif.reg_dREN <= 0;
        end
        else if(ruif.dhit == 1'b1) begin
            ruif.reg_dWEN <= 0;
            ruif.reg_dREN <= 0;
        end
        else if(ruif.ihit) begin
            ruif.reg_dWEN <= ruif.dWEN;
            ruif.reg_dREN <= ruif.dREN;
        end
    end 
endmodule