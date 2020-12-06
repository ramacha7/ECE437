`include "cpu_types_pkg.vh"
`include "forwarding_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module forwarding_unit_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface delcaration
  forwarding_unit_if fuif ();
// test program setup
  test PROG ();

`ifndef MAPPED
  forwarding_unit DUT(CLK, nRST, fuif);
`else
  forwarding_unit DUT(
    .\fuif.RegWr_memwb(fuif.RegWr_memwb),
    .\fuif.RegDst_memwb (fuif.RegDst_memwb),
    .\fuif.wdat_memwb (fuif.wdat_memwb),
    .\fuif.RegDst_exmem (fuif.RegDst_exmem),
    .\fuif.RegWr_exmem (fuif.RegWr_exmem),
    .\fuif.ALUOut_exmem (fuif.ALUOut_exmem),
    .\fuif.rt_memwb (fuif.rt_memwb),
    .\fuif.rd_memwb (fuif.rd_memwb),
    .\fuif.rt_exmem (fuif.rt_exmem),
    .\fuif.rd_exmem (fuif.rd_exmem),
    .\fuif.rs_idex (fuif.rs_idex),
    .\fuif.rt_idex (fuif.rt_idex),
    .\fuif.forwardA (fuif.forwardA),
    .\fuif.forwardB (fuif.forwardB),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test;

  import cpu_types_pkg::*;
  parameter PERIOD = 10;

  initial begin
  #(5)
  fuif.RegWr_memwb = 1;
  fuif.RegDst_memwb = '0;
  fuif.wdat_memwb = 1;
  fuif.RegDst_exmem = 0;
  fuif.RegWr_exmem = 0;
  fuif.ALUOut_exmem = 0;
  fuif.rt_memwb = 0; 
  fuif.rd_memwb = 2;
  fuif.rs_idex = 2;
  fuif.rt_idex = 4;
  fuif.rt_exmem = 2;
  fuif.rd_exmem = 4;
  #(2)
  if(fuif.forwardA == 2'd2 && fuif.forwardB == '0) begin
    $display("Passed 1");
  end else begin
    $display("Failed 1");
  end
  #(5)
  fuif.RegWr_memwb = 1;
  fuif.RegDst_memwb = 2'd1;
  fuif.wdat_memwb = 1;
  fuif.RegDst_exmem = 0;
  fuif.RegWr_exmem = 0;
  fuif.ALUOut_exmem = 0;
  fuif.rt_memwb = 2; 
  fuif.rd_memwb = 4;
  fuif.rs_idex = 2;
  fuif.rt_idex = 4;
  fuif.rt_exmem = 2;
  fuif.rd_exmem = 4;

  #(2)
  if(fuif.forwardA == 2'd2 && fuif.forwardB == '0) begin
    $display("Passed 2");
  end else begin
      $display("Failed 2");
  end
  #(5)//JUMP
  fuif.RegWr_memwb = 0;
  fuif.RegDst_memwb = '0;
  fuif.wdat_memwb = 1;
  fuif.RegDst_exmem = '0;
  fuif.RegWr_exmem = 1;
  fuif.ALUOut_exmem = 0;
  fuif.rt_memwb = 2; 
  fuif.rd_memwb = 0;
  fuif.rs_idex = 2;
  fuif.rt_idex = 4;
  fuif.rt_exmem = 2;
  fuif.rd_exmem = 4;
  #(2)
  if(fuif.forwardA == 2'd0 && fuif.forwardB == 2'd1) begin
    $display("Passed 3");
  end else begin
    $display("Failed 3");
  end
  #(5) //BRANCH NOT EQUAL
  fuif.RegWr_memwb = '0;
  fuif.RegDst_memwb = '0;
  fuif.wdat_memwb = 1;
  fuif.RegDst_exmem = 2'd1;
  fuif.RegWr_exmem = 1;
  fuif.ALUOut_exmem = 0;
  fuif.rt_memwb = 2; 
  fuif.rd_memwb = 0;
  fuif.rs_idex = 2;
  fuif.rt_idex = 4;
  fuif.rt_exmem = 2;
  fuif.rd_exmem = 4;

  #(2)
  if(fuif.forwardA == 2'd1 && fuif.forwardB == 0) begin
    $display("Passed 4");
  end else begin
    $display("Failed 4");
  end
  #(5)//BRANCH EQUAL
  fuif.RegWr_memwb = 1;
  fuif.RegDst_memwb = '0;
  fuif.wdat_memwb = 1;
  fuif.RegDst_exmem = '0;
  fuif.RegWr_exmem = 1;
  fuif.ALUOut_exmem = 0;
  fuif.rt_memwb = 2; 
  fuif.rd_memwb = 4;
  fuif.rs_idex = 2;
  fuif.rt_idex = 4;
  fuif.rt_exmem = 2;
  fuif.rd_exmem = 4;

  #(2)
  if(fuif.forwardA == 2'd0 && fuif.forwardB == 2'd1) begin
    $display("Passed 5");
  end else begin
    $display("Failed 5");
  end
  #(5);
  #(PERIOD);
  #(PERIOD);
  end

endprogram