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
  caches_if cif0();
  caches_if cif1();

  cpu_ram_if ramif();

  cache_control_if ccif(cif0,cif1);
  
  datapath_cache_if dcif0();
  datapath_cache_if dcif1();
  // test program
  test PROG (CLK, nRST, dcif0,dcif1,cif0,cif1);
  // DUT
`ifndef MAPPED
  dcache DUT0 (CLK, nRST, dcif0, cif0);
  dcache DUT1 (CLK, nRST, dcif1, cif1);
  memory_control BUS (CLK,nRST,ccif);
  ram RAM (CLK,nRST,ramif);
`else
  dcache DUT0(
    .\dcif.halt(dcif0.halt),
    .\dcif.dmemREN(dcif0.dmemREN),
    .\dcif.dmemWEN(dcif0.dmemWEN),
    .\dcif.datomic(dcif0.datomic),
    .\dcif.dmemstore(dcif0.dmemstore),
    .\dcif.dmemaddr(dcif0.dmemaddr),
    .\cif.dwait(cif0.dwait),
    .\cif.dload(cif0.dload),
    .\cif.ccwait(cif0.ccwait),
    .\cif.ccinv(cif0.ccinv),
    .\cif.ccsnoopaddr(cif0.ccsnoopaddr),
    .\nRST (nRST),
    .\CLK (CLK)
  );

  dcache DUT1(
    .\dcif.halt(dcif1.halt),
    .\dcif.dmemREN(dcif1.dmemREN),
    .\dcif.dmemWEN(dcif1.dmemWEN),
    .\dcif.datomic(dcif1.datomic),
    .\dcif.dmemstore(dcif1.dmemstore),
    .\dcif.dmemaddr(dcif1.dmemaddr),
    .\cif.dwait(cif1.dwait),
    .\cif.dload(cif1.dload),
    .\cif.ccwait(cif1.ccwait),
    .\cif.ccinv(cif1.ccinv),
    .\cif.ccsnoopaddr(cif1.ccsnoopaddr),
    .\nRST (nRST),
    .\CLK (CLK)
  );

  memory_control BUS (CLK,nRST,ccif);
  ram RAM (CLK,nRST,ramif);
`endif

  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ccif.ramstate = ramif.ramstate;
  assign ccif.ramload = ramif.ramload;

endmodule

program test(input logic tb_clk, output logic tb_nrst, datapath_cache_if dcif0, datapath_cache_if dcif1, caches_if cif0,caches_if cif1);

  integer test_case_number; 
  string test_case;

  initial begin
      reset_dut();
      test0();
      test1();
      test2();
      test3();
      test4();
      // test5();
      // test6();
      // test7();
      // test8();
      // test9();
      // test10();
      // test11();
      // test12();
      // test13();
      // test14();
  end

  task reset_dut;
  begin
    tb_nrst = 1'b0;
    dcif0.halt = '0;
    dcif0.dmemREN = '0;
    dcif0.dmemWEN = '0;
    dcif0.datomic = '0;
    dcif0.dmemstore = '0;
    dcif0.dmemaddr = '0;
    dcif1.halt = '0;
    dcif1.dmemREN = '0;
    dcif1.dmemWEN = '0;
    dcif1.datomic = '0;
    dcif1.dmemstore = '0;
    dcif1.dmemaddr = '0;
    test_case = "Reset";
    test_case_number = 0;

    @(posedge tb_clk);

    @(negedge tb_clk);
    tb_nrst = 1'b1;

  end
  endtask

  task test0;
    //Writeto 0x35 - cache_0 miss
    test_case_number = 0;
    test_case = "CACHE_0 Write MISS (I->M) and CACHE_1 (I->I)";
    dcif0.dmemaddr = {26'h35,3'h0,3'b100};
    dcif0.dmemstore = 32'hFEEDFEED;
    dcif0.dmemWEN = '1;
    @(negedge cif0.dwait)
    #(10);
    @(negedge cif0.dwait);
    #(20);
    dcif0.dmemWEN = '0;
    dcif0.dmemaddr = '0;
    dcif0.dmemstore = '0;
    #(10);
  endtask

  task test1;
    //Load from 0x35 - cache_0 miss
    test_case_number++;
    test_case = "CACHE_0 READ HIT (M->M) and CACHE_1 (I->I)";
    dcif0.dmemREN = '1;
    dcif0.dmemaddr = {26'h35,3'h0,3'b100};
    #(10);
    dcif0.dmemREN = '0;
    dcif0.dmemaddr = '0;
  endtask

  task test2;
    //Cache_0 Block can supply but if there are more than 2 caches with the shared block, then we would have to
    //arbitrate, hence we just let memory supply the block
    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "CACHE_1 READ MISS (I->S) and CACHE_0 (M->S)";
    dcif1.dmemREN = '1;
    dcif1.dmemaddr = {26'h35,3'h0,3'b000};
    @(negedge cif1.dwait)
    #(10);
    dcif1.dmemaddr = {26'h35,3'h0,3'b000};
    @(negedge cif1.dwait);
    #(10);
    dcif1.dmemREN = '0;
    dcif1.dmemaddr = '0;
    #(10);
  endtask

  task test3;
    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "CACHE_0 WRITE HIT (S->M) and CACHE_1 (S->I)";
    dcif0.dmemWEN = '1;
    dcif0.dmemaddr = {26'h35,3'h0,3'b000};
    dcif0.dmemstore = 32'hBEEFBEEF;
    @(negedge cif0.dwait);
    #(10);
    @(negedge cif0.dwait);
    #(20);
    dcif0.dmemWEN = '0;
    #(10);
  endtask

  task test4;
    @(negedge tb_clk);
    test_case_number = test_case_number + 1;
    test_case = "CACHE_1 WRITE HIT (M->M) and CACHE_1 (I->I)";
    dcif0.dmemWEN = '1;
    dcif0.dmemaddr = {26'h35,3'h0,3'b000};
    dcif0.dmemstore = 32'hCAFECAFE;
    #(10);
    dcif0.dmemWEN = '0;
    #(200);
  endtask

  // task test5;
  //   //Load from address 0x60 - cache miss
  //   test_case_number = 5;
  //   dcif.dmemREN = '1;
  //   dcif.dmemaddr = {26'h60,3'h3,3'b000};
  //   cif.dwait = 1;
  //   #(10);
  //   cif.dwait = 0;
  //   cif.dload = 32'h55550000;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(10);
  //   cif.dwait = 0;
  //   cif.dload = 32'h00005555;
  //   dcif.dmemREN = '0;
  //   #(10);
  // endtask

  // task test6;
  //   //Load from 0x65 - cache miss (greater latency)
  //   test_case_number = 6;
  //   dcif.dmemREN = '1;
  //   dcif.dmemaddr = {26'h65,3'h3,3'b000};
  //   cif.dwait = 1;
  //   #(200);
  //   cif.dwait = 0;
  //   cif.dload = 32'h65650000;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(200);
  //   cif.dwait = 0;
  //   cif.dload = 32'h00006565;
  //   dcif.dmemREN = '0;
  //   #(20);
  // endtask

  // task test7;
  //   //Load from 0x78 - cache miss (greater latency)
  //   test_case_number = 7;
  //   dcif.dmemREN = '1;
  //   dcif.dmemaddr = {26'h78,3'h7,3'b000};
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'h78780000;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'h00007878;
  //   dcif.dmemREN = '0;
  //   #(20);
  // endtask

  // task test8;
  //   //Load from 0x96 - cache miss (greater latency)
  //   test_case_number = 8;
  //   dcif.dmemREN = '1;
  //   dcif.dmemaddr = {26'h96,3'h7,3'b000};
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'h96960000;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'h00009696;
  //   dcif.dmemREN = '0;
  //   #(20);
  // endtask

  // task test9;
  //   //Write to memory - miss and not dirty
  //   test_case_number = 9;
  //   dcif.dmemWEN = '1;
  //   dcif.dmemaddr = {26'h190,3'h6,3'b100};
  //   dcif.dmemstore = 32'hFAB1FAB1;
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'hDEADBEEF;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'hBEEFDEAD;
  //   #(10);
  //   dcif.dmemWEN = '0;
  //   #(20);
  // endtask

  // task test10;
  //   //Write to memory - hit dirty
  //   test_case_number = 10;
  //   dcif.dmemWEN = '1;
  //   dcif.dmemaddr = {26'h190,3'h6,3'b100};
  //   dcif.dmemstore = 32'hDEAFDEAF; 
  //   #(20);  
  //   dcif.dmemWEN = '0;
  // endtask

  // task test11;
  //   //Load from 0x120 - cache miss (greater latency)
  //   test_case_number = 11;
  //   dcif.dmemREN = '1;
  //   dcif.dmemaddr = {26'h120,3'h6,3'b100};
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'hFEEDFEED;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'hDEEFDEEF;
  //   dcif.dmemREN = '0;
  //   #(20);
  // endtask

  // task test12;
  //   //Write to memory - miss and lru is dirty
  //   test_case_number = 12;
  //   dcif.dmemWEN = '1;
  //   dcif.dmemaddr = {26'h200,3'h6,3'b100};
  //   dcif.dmemstore = 32'hFAB1FAB1;
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'hDEADBEEF;
  //   @(posedge tb_clk);
  //   cif.dwait = 1;
  //   #(100);
  //   cif.dwait = 0;
  //   cif.dload = 32'hFEEEEEED;
  //   #(50);
  //   dcif.dmemWEN = '0;
  // endtask

  // task test13;
  //   //Write to memory - hit dirty
  //   test_case_number = 13;
  //   dcif.dmemWEN = '1;
  //   dcif.dmemaddr = {26'h96,3'h7,3'b000};
  //   dcif.dmemstore = 32'hBEEEEEEF; 
  //   #(20);  
  //   dcif.dmemWEN = '0;
  // endtask

  // task test14;
  // test_case_number = 14;
  //   dcif.halt ='1;
  //   #(300);
  //   tb_nrst = '0;
  //   #(20);
  // endtask

endprogram
