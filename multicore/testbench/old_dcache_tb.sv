/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module dcache_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif ();
  datapath_cache_if dcif();
  // test program
  test PROG (CLK, nRST, dcif, cif);
  // DUT
`ifndef MAPPED
  dcache DUT(CLK, nRST, dcif, cif);
`else
  dcache DUT(
    .\dcif.halt(dcif.halt),
    .\dcif.dmemREN(dcif.dmemREN),
    .\dcif.dmemWEN(dcif.dmemWEN),
    .\dcif.datomic(dcif.datomic),
    .\dcif.dmemstore(dcif.dmemstore),
    .\dcif.dmemaddr(dcif.dmemaddr),
    .\cif.dwait(cif.dwait),
    .\cif.dload(cif.dload),
    .\cif.ccwait(cif.ccwait),
    .\cif.ccinv(cif.ccinv),
    .\cif.ccsnoopaddr(cif.ccsnoopaddr),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(input logic tb_clk, output logic tb_nrst, datapath_cache_if dcif, caches_if cif);

  integer test_case_number; 
  string test_case;

  initial begin
      reset_dut();
      test1();
      test2();
      test3();
      test4();
      test5();
      test6();
      test7();
      test8();
      test9();
      test10();
      test11();
      test12();
      test13();
      test14();
  end

  task reset_dut;
  begin
    tb_nrst = 1'b0;
    dcif.halt = '0;
    dcif.dmemREN = '0;
    dcif.dmemWEN = '0;
    dcif.datomic = '0;
    dcif.dmemstore = '0;
    dcif.dmemaddr = '0;
    cif.dwait = '0;
    cif.dload = '0;
    cif.ccwait = '0;
    cif.ccinv = '0;
    cif.ccsnoopaddr = '0;
    test_case = "Reset";
    test_case_number = 0;

    @(posedge tb_clk);

    @(negedge tb_clk);
    tb_nrst = 1'b1;

  end
  endtask

  task test1;
    //Load from 0x35 - cache miss
    test_case_number = 1;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h35,3'h0,3'b000};
    cif.dwait = 1;
    #(5);
    cif.dwait = 0;
    cif.dload = 32'hABCDBEEF;
    #(10);
    cif.dwait = 1;
    #(5);
    cif.dwait = 0;
    cif.dload = 32'h12345678;
    dcif.dmemREN = '0;
    #(10);
  endtask

  task test2;
    //Load from 0x35 - cache hit
    test_case_number = 2;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h35,3'h0,3'b100};
    #(10);
  endtask

  task test3;
    //Load from 0x36 - cache miss take lru
    test_case_number = 3;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h36,3'h0,3'b000};
    cif.dwait = 1;
    #(5);
    cif.dwait = 0;
    cif.dload = 32'hDEEBFEED;
    #(10);
    cif.dwait = 1;
    #(5);
    cif.dwait = 0;
    cif.dload = 32'hAFAF3456;
    dcif.dmemREN = '0;
    #(10);
  endtask

  task test4;
    //Load from 0x36 - cache hit change set/dcache lru to 0
    test_case_number = 4;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h36,3'h0,3'b000};
    #(10);
  endtask

  task test5;
    //Load from address 0x60 - cache miss
    test_case_number = 5;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h60,3'h3,3'b000};
    cif.dwait = 1;
    #(10);
    cif.dwait = 0;
    cif.dload = 32'h55550000;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(10);
    cif.dwait = 0;
    cif.dload = 32'h00005555;
    dcif.dmemREN = '0;
    #(10);
  endtask

  task test6;
    //Load from 0x65 - cache miss (greater latency)
    test_case_number = 6;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h65,3'h3,3'b000};
    cif.dwait = 1;
    #(200);
    cif.dwait = 0;
    cif.dload = 32'h65650000;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(200);
    cif.dwait = 0;
    cif.dload = 32'h00006565;
    dcif.dmemREN = '0;
    #(20);
  endtask

  task test7;
    //Load from 0x78 - cache miss (greater latency)
    test_case_number = 7;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h78,3'h7,3'b000};
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'h78780000;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'h00007878;
    dcif.dmemREN = '0;
    #(20);
  endtask

  task test8;
    //Load from 0x96 - cache miss (greater latency)
    test_case_number = 8;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h96,3'h7,3'b000};
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'h96960000;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'h00009696;
    dcif.dmemREN = '0;
    #(20);
  endtask

  task test9;
    //Write to memory - miss and not dirty
    test_case_number = 9;
    dcif.dmemWEN = '1;
    dcif.dmemaddr = {26'h190,3'h6,3'b100};
    dcif.dmemstore = 32'hFAB1FAB1;
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'hDEADBEEF;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'hBEEFDEAD;
    #(10);
    dcif.dmemWEN = '0;
    #(20);
  endtask

  task test10;
    //Write to memory - hit dirty
    test_case_number = 10;
    dcif.dmemWEN = '1;
    dcif.dmemaddr = {26'h190,3'h6,3'b100};
    dcif.dmemstore = 32'hDEAFDEAF; 
    #(20);  
    dcif.dmemWEN = '0;
  endtask

  task test11;
    //Load from 0x120 - cache miss (greater latency)
    test_case_number = 11;
    dcif.dmemREN = '1;
    dcif.dmemaddr = {26'h120,3'h6,3'b100};
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'hFEEDFEED;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'hDEEFDEEF;
    dcif.dmemREN = '0;
    #(20);
  endtask

  task test12;
    //Write to memory - miss and lru is dirty
    test_case_number = 12;
    dcif.dmemWEN = '1;
    dcif.dmemaddr = {26'h200,3'h6,3'b100};
    dcif.dmemstore = 32'hFAB1FAB1;
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'hDEADBEEF;
    @(posedge tb_clk);
    cif.dwait = 1;
    #(100);
    cif.dwait = 0;
    cif.dload = 32'hFEEEEEED;
    #(50);
    dcif.dmemWEN = '0;
  endtask

  task test13;
    //Write to memory - hit dirty
    test_case_number = 13;
    dcif.dmemWEN = '1;
    dcif.dmemaddr = {26'h96,3'h7,3'b000};
    dcif.dmemstore = 32'hBEEEEEEF; 
    #(20);  
    dcif.dmemWEN = '0;
  endtask

  task test14;
  test_case_number = 14;
    dcif.halt ='1;
    #(300);
    tb_nrst = '0;
    #(20);
  endtask

endprogram
