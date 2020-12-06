/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module control_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
 control_unit_if cuif ();
  // test program
  test PROG (CLK, nRST, cuif.tb);
  // DUT
`ifndef MAPPED
  control_unit DUT(CLK, nRST, cuif);
`else
  control_unit DUT(CLK, nRST, cuif);
  /*request_unit DUT(
    .\aif.out_port (aif.out_port),
    .\aif.portA (aif.portA),
    .\aif.portB (aif.portB),
    .\aif.neg (aif.neg),
    .\aif.zero (aif.zero),
    .\aif.ovf (aif.ovf),
    .\aif.ALUOP (aif.ALUOP),
    .\nRST (nRST),
    .\CLK (CLK)
  );*/
`endif

endmodule

program test(input logic tb_clk,output logic tb_nrst,control_unit_if.tb cuif);

  integer test_case_number; 
  string test_case;

  initial begin
      cuif.instr = '0;
      #(10);
      test_case_number = 0;
      test_case = "LOAD instruction";

      cuif.instr = {6'b100011,5'd3,5'd8,16'd1500};
        #(10);
      test_case_number = test_case_number + 1;
      test_case = "STORE instruction";
      cuif.instr = {SW,5'd15,5'd6,16'd14800};
      #(10);
      test_case_number = test_case_number + 1;
      test_case = "J instruction";
      cuif.instr = {J,26'd54};
      #(10);
      test_case_number = test_case_number + 1;
      test_case = "ADD instruction";
      cuif.instr = {RTYPE,5'd5,5'd10,5'd15,5'd0,ADD};
      #(10);
      test_case_number = test_case_number + 1;
      test_case = "BEQ instruction";
      cuif.instr = {BEQ,5'd5,5'd4,5'd7,16'd2048};
      #(10);
  end


  /*task reset_dut;
  output tb_nrst;

  begin
    tb_nrst = 1'b0;

    @(posedge tb_clk);
    @(posedge tb_clk);

    @(negedge tb_clk);
    tb_nrst = 1'b1;

    @(posedge tb_clk);
    @(posedge tb_clk);
  end
  endtask*/
endprogram
