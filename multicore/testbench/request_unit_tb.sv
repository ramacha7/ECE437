/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module request_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
 request_unit_if ruif ();
  // test program
  test PROG (CLK, nRST, ruif.tb);
  // DUT
`ifndef MAPPED
  request_unit DUT(CLK, nRST, ruif);
`else
  request_unit DUT(CLK, nRST, ruif);
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

program test(input logic tb_clk,output logic tb_nrst,request_unit_if.tb ruif);

  integer test_case_number; 
  string test_case;

  logic test_arr[3:0];

  initial begin
    tb_nrst = 1'b0;
    test_case_number = 0;
    test_case = "Asynchronous reset";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b0;
    ruif.dhit = 1'b0;
    ruif.ihit = 1'b0;

    #(10);
    tb_nrst = 1'b1;

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER0";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER1";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b1;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER2";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER3";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b1;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER4";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER5";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b1;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER6";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER7";
    ruif.dWEN = 1'b0;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b1;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER8";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER9";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b1;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER10";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER11";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b0;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b1;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER12";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER13";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b0;
    ruif.dhit = 1'b1;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER14";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b0;

    #(5);

    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "FILLER15";
    ruif.dWEN = 1'b1;
    ruif.dREN = 1'b1;
    ruif.ihit = 1'b1;
    ruif.dhit = 1'b1;

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
