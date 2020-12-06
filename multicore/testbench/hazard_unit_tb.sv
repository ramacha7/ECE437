`include "cpu_types_pkg.vh"
`include "hazard_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface delcaration
  hazard_unit_if huif ();
// test program setup
  test PROG ();

`ifndef MAPPED
  hazard_unit DUT(CLK, nRST, huif);
`else
  hazard_unit DUT(
    .\huif.rt_idex(huif.rt_idex),
    .\huif.equal_exmem (huif.equal_exmem),
    .\huif.BEQ_exmem (huif.BEQ_exmem),
    .\huif.BNE_exmem (huif.BNE_exmem),
    .\huif.instr (huif.instr),
    .\huif.dhit (huif.dhit),
    .\huif.MemtoReg_idex (huif.MemtoReg_idex),
    .\huif.ihit (huif.ihit),
    .\huif.PCSrc (huif.PCSrc),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test;

  import cpu_types_pkg::*;
  parameter PERIOD = 10;

  initial begin
  #(5)//NO JUMP OR BRANCH
  huif.rt_idex = 0;
  huif.equal_exmem = '0;
  huif.BEQ_exmem = 1;
  huif.BNE_exmem = 0;
  huif.instr = 0;
  huif.dhit = 0;
  huif.MemtoReg_idex = 0;
  huif.ihit = 0; 
  huif.PCSrc = 0;
  #(2)
  if(huif.flush == 0 && huif.stall == 0) begin
    $display("Passed 1");
  end else begin
    $display("Failed 1");
  end
  #(5)//JUMP
  huif.rt_idex = 0;
  huif.equal_exmem = '0;
  huif.BEQ_exmem = 1;
  huif.BNE_exmem = 0;
  huif.instr = 0;
  huif.dhit = 0;
  huif.MemtoReg_idex = 0;
  huif.ihit = 0; 
  huif.PCSrc = 2;
  #(2)
  if(huif.flush == 1 && huif.stall == 0) begin
    $display("Passed 2");
  end else begin
    $display("Failed 2");
  end
  #(5)//JUMP
  huif.rt_idex = 0;
  huif.equal_exmem = '0;
  huif.BEQ_exmem = 1;
  huif.BNE_exmem = 0;
  huif.instr = 0;
  huif.dhit = 0;
  huif.MemtoReg_idex = 0;
  huif.ihit = 0; 
  huif.PCSrc = 3;
  #(2)
  if(huif.flush == 1 && huif.stall == 0) begin
    $display("Passed 3");
  end else begin
    $display("Failed 3");
  end
  #(5) //BRANCH NOT EQUAL
  huif.rt_idex = 0;
  huif.equal_exmem = '0;
  huif.BEQ_exmem = 0;
  huif.BNE_exmem = 1;
  huif.instr = 0;
  huif.dhit = 0;
  huif.MemtoReg_idex = 0;
  huif.ihit = 0; 
  huif.PCSrc = 0;
  #(2)
  if(huif.flush == 1 && huif.stall == 0) begin
    $display("Passed 4");
  end else begin
    $display("Failed 4");
  end
  #(5)//BRANCH EQUAL
  huif.rt_idex = 0;
  huif.equal_exmem = 1;
  huif.BEQ_exmem = 1;
  huif.BNE_exmem = 0;
  huif.instr = 0;
  huif.dhit = 0;
  huif.MemtoReg_idex = 0;
  huif.ihit = 0; 
  huif.PCSrc = 0;
  #(2)
  if(huif.flush == 1 && huif.stall == 0) begin
    $display("Passed 5");
  end else begin
    $display("Failed 5");
  end
  // #(5)
  // huif.rt_idex = 3;
  // huif.equal_exmem = '0;
  // huif.BEQ_exmem = 0;
  // huif.BNE_exmem = 0;
  // huif.instr = {5'd0, 5'd3, 5'd9, 17'd0};
  // huif.dhit = 0;
  // huif.MemtoReg_idex = 1;
  // huif.ihit = 1; 
  // huif.PCSrc = 0;
  // #(2)
  // if(huif.flush == 0 && huif.stall == 1) begin
  //   $display("Passed 6");
  // end else begin
  //   $display("Failed 6");
  // end
  // #(5)
  // huif.rt_idex = 4;
  // huif.equal_exmem = '0;
  // huif.BEQ_exmem = 0;
  // huif.BNE_exmem = 0;
  // huif.instr = {5'd0, 5'd3, 5'd4, 17'd0};
  // huif.dhit = 0;
  // huif.MemtoReg_idex = 1;
  // huif.ihit = 1; 
  // huif.PCSrc = 0;
  // #(2)
  // if(huif.flush == 0 && huif.stall == 1) begin
  //   $display("Passed 7");
  // end else begin
  //   $display("Failed 7");
  // end
  #(5)
  huif.rt_idex = 0;
  huif.equal_exmem = '0;
  huif.BEQ_exmem = 0;
  huif.BNE_exmem = 0;
  huif.instr = 0;
  huif.dhit = 0;
  huif.MemtoReg_idex = 0;
  huif.ihit = 0; 
  huif.PCSrc = 0;
  #(2)
  if(huif.flush == 0 && huif.stall == 0) begin
    $display("Passed 6");
  end else begin
    $display("Failed 6");
  end
  #(5)
  #(PERIOD)
  #(PERIOD);

  end
endprogram