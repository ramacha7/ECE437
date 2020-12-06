/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aif ();
  // test program
  test PROG (CLK, nRST, aif.tb);
  // DUT
`ifndef MAPPED
  alu DUT(CLK, nRST, aif.af);
`else
  alu DUT(
    .\aif.out_port (aif.out_port),
    .\aif.portA (aif.portA),
    .\aif.portB (aif.portB),
    .\aif.neg (aif.neg),
    .\aif.zero (aif.zero),
    .\aif.ovf (aif.ovf),
    .\aif.ALUOP (aif.ALUOP),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(input logic tb_clk,output logic tb_nrst,alu_if.tb tb_aif);

  integer test_case_number; 
  string test_case;
  integer iter_var;


  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  initial begin
      tb_aif.portA = 32'd0;
      tb_aif.portB = 32'd0;


      @(negedge tb_clk);
      test_case_number = 0; 
      test_case = "ADD SIGNED";
      tb_aif.portA = 32'd2000;
      tb_aif.portB = 32'd3000;
      tb_aif.ALUOP = ALU_ADD;

      #(10);
  
      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "ADD SIGNED OVF";
      tb_aif.portA = 32'h7FFFFFFF;
      tb_aif.portB = 32'h7FFFFFFF;
      tb_aif.ALUOP = ALU_ADD;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "ADD SIGNED UNDERFLOW";

      tb_aif.portA = 32'h80000000;
      tb_aif.portB = 32'h80000000;
      tb_aif.ALUOP = ALU_ADD;
      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "SUB SIGNED";

      tb_aif.portA = 32'd50;
      tb_aif.portB = 32'd10;
      tb_aif.ALUOP = ALU_SUB;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "SUB SIGNED OVF";

      tb_aif.portA = 32'hC0000000;
      tb_aif.portB = 32'h7FFFFFFF;
      tb_aif.ALUOP = ALU_SUB;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "SHIFT LEFT";

      tb_aif.portA = 32'hFFFFFFFF;
      tb_aif.portB = 32'd12;
      tb_aif.ALUOP = ALU_SLL;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "SHIFT RIGHT";

      tb_aif.portA = 32'hFFFFFFFF;
      tb_aif.portB = 32'd8;
      tb_aif.ALUOP = ALU_SRL;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "AND";

      tb_aif.portA = 32'hFFFFFFFF;
      tb_aif.portB = 32'h000000FF;
      tb_aif.ALUOP = ALU_AND;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "OR";

      tb_aif.portA = 32'h00FF00FF;
      tb_aif.portB = 32'hFF00FF00;
      tb_aif.ALUOP = ALU_OR;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "XOR";

      tb_aif.portA = 32'hFFFFFFFF;
      tb_aif.portB = 32'h00000000;
      tb_aif.ALUOP = ALU_XOR;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "NOR";

      tb_aif.portA = 32'h00000000;
      tb_aif.portB = 32'h00FF00FF;
      tb_aif.ALUOP = ALU_NOR;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "SET LESS THAN";

      tb_aif.portA = 32'd4328;
      tb_aif.portB = 32'd90000;
      tb_aif.ALUOP = ALU_SLT;

      tb_aif.portA = 32'hFFFFFFFF;
      tb_aif.portB = 32'h00FFFFFF;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "SET LESS THAN UNSIGNED";

      tb_aif.portA = 32'd4328;
      tb_aif.portB = 32'd90000;
      tb_aif.ALUOP = ALU_SLTU;

      #(10);

      @(negedge tb_clk);
      test_case_number = test_case_number + 1;
      test_case = "SET LESS THAN UNSIGNED";

      tb_aif.portA = 32'd4328;
      tb_aif.portB = 32'd200;
      tb_aif.ALUOP = ALU_SLTU;
      #(30);
  end


  task reset_dut;
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
  endtask
endprogram
