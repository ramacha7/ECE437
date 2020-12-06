`include "forwarding_unit_if.vh"
`include "cpu_types_pkg.vh"

module forwarding_unit(
    input logic CLK, nRST, forwarding_unit_if fuif
);

    import cpu_types_pkg::*;
    logic [4:0] exmem_rd, memwb_rd;

    always_comb begin
        fuif.forwardA = 2'd0;
        fuif.forwardB = 2'd0;

        //for forwardA (portA value or rs value)
        if((fuif.RegWr_exmem == 1'b1) && (fuif.rs_idex == exmem_rd)) begin    
            fuif.forwardA = 2'd1;
        end
        else if((fuif.RegWr_memwb == 1'b1) && (fuif.rs_idex == memwb_rd)) begin   
            fuif.forwardA = 2'd2;
        end
 
        //for forwardB (portB value or rt value)
        if((fuif.RegWr_exmem == 1'b1) && (fuif.rt_idex == exmem_rd)) begin     
            fuif.forwardB = 2'd1;
        end
        else if((fuif.RegWr_memwb == 1'b1) && (fuif.rt_idex == memwb_rd)) begin     
            fuif.forwardB = 2'd2;
        end

    end

    always_comb begin
        exmem_rd = '0;
        memwb_rd = '0;
        if(fuif.RegDst_exmem == '0) begin
            exmem_rd = fuif.rd_exmem;
        end
        else if(fuif.RegDst_exmem == 2'd1) begin
            exmem_rd = fuif.rt_exmem;
        end

        if(fuif.RegDst_memwb == '0) begin
            memwb_rd = fuif.rd_memwb;
        end
        else if(fuif.RegDst_memwb == 2'd1) begin
            memwb_rd = fuif.rt_memwb;
        end
    end

endmodule