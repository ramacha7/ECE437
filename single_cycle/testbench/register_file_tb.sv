/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
/*  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119; */

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK, nRST, rfif.tb);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif.rf);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

  task reset_dut;
  output tb_nrst;

  begin
    tb_nrst = 1'b0;

    @(posedge CLK);
    @(posedge CLK);

    @(negedge CLK);
    tb_nrst = 1'b1;

    @(posedge CLK);
    @(posedge CLK);
  end
  endtask

endmodule

program test(input logic tb_clk,output logic tb_nrst,register_file_if.tb tb_rfif);

  integer test_case_number;
  string test_case;
  integer iter_var;


  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  initial begin
    tb_nrst = 1'b1;
    tb_rfif.WEN = 1'b0;
    tb_rfif.wdat = 32'd0;
    tb_rfif.wsel = 5'd0;
    tb_rfif.rsel1 = 5'd0;
    tb_rfif.rsel2 = 5'd0;

    #(1);

   //************************************************
   //     Test case 1: Asynchronous reset test
   //************************************************

    test_case_number = 1;
    test_case = "Asyncrhonous Reset";

    #(0.1);

    //reset_dut(tb_nrst);
    @(negedge tb_clk);
    tb_nrst = 1'b0;

    @(posedge tb_clk);
    @(posedge tb_clk);
    tb_nrst = 1'b1;

    @(negedge tb_clk);


   //****************************************************************
   //     Test case 2: Write to all registers including register 0
   //****************************************************************

  @(negedge tb_clk);
  test_case_number = test_case_number + 1;
  test_case = "Writing to all registers including register 0";

  #(0.1);

  tb_rfif.WEN = 1'b1;
  tb_rfif.wdat = v2;
  for(iter_var = 0; iter_var < 32; iter_var = iter_var + 1) begin
    tb_rfif.wsel = iter_var;
    #(10);
  end

  @(negedge tb_clk);
  tb_rfif.WEN = 1'b0;

   //****************************************************************
   //     Test case 3: Read from all registers
   //****************************************************************

  @(negedge tb_clk);
  test_case_number = test_case_number + 1;
  test_case = "Reading from  all registers";

  tb_rfif.WEN = 1'b1;
  tb_rfif.wdat = v3;
  tb_rfif.wsel = 5'b10101;

  #(10);
  @(negedge tb_clk);
  tb_rfif.wdat = v1;
  tb_rfif.wsel = 5'b00111;
  #(10);

  @(negedge tb_clk);
  tb_rfif.WEN = 1'b0;

  #(0.1);

  for(iter_var = 0; iter_var < 32; iter_var = iter_var + 1) begin
    tb_rfif.rsel1 = iter_var;
    tb_rfif.rsel2 = iter_var;
    #(10);
  end

   //****************************************************************
   //     Test case 4: Test write and read to register 0
   //****************************************************************

  @(negedge tb_clk);
  test_case_number = test_case_number + 1;
  test_case = "Write and read to register 0";

  tb_rfif.WEN = 1'b1;
  tb_rfif.wdat = 123;
  tb_rfif.wsel = 5'b0;

  #(10);

  @(negedge tb_clk);
  tb_rfif.rsel1 = 5'b0;
  tb_rfif.rsel2 = 5'b0;

  #(10);

   //************************************************
   //     Test case 5: Asynchronous reset test
   //************************************************

    test_case_number = test_case_number + 1;
    test_case = "Asyncrhonous Reset";

    #(0.1);

    //reset_dut(tb_nrst);
    @(negedge tb_clk);
    tb_nrst = 1'b0;

    @(posedge tb_clk);
    @(posedge tb_clk);
    tb_nrst = 1'b1;

    @(negedge tb_clk);


  end
endprogram
