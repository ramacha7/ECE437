// mapped needs this

`include "cpu_types_pkg.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "caches_if.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns
parameter PERIOD = 10;

module memory_control_tb;

  logic CLK = 0, nRST;

  always #(PERIOD/2) CLK++;

  // interface delcaration
  caches_if cif0();
  caches_if cif1();
  cache_control_if #(.CPUS(2)) ccif (cif0, cif1);
  cpu_ram_if ram_if ();

// test program setup
  test PROG (CLK,nRST,ccif);

`ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif);
`else
  memory_control DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\ccif.iREN (ccif.iREN),
    .\ccif.dREN (ccif.dREN),
    .\ccif.dWEN (ccif.dWEN),
    .\ccif.dstore (ccif.dstore),
    .\ccif.iaddr (ccif.iaddr),
    .\ccif.daddr (ccif.daddr),
    .\ccif.ramload (ccif.ramload),
    .\ccif.ramstate (ccif.ramstate),
    .\ccif.iwait (ccif.iwait),
    .\ccif.dwait (ccif.dwait),
    .\ccif.iload (ccif.iload),
    .\ccif.dload (ccif.dload),
    .\ccif.ramstore (ccif.ramstore),
    .\ccif.ramaddr (ccif.ramaddr),
    .\ccif.ramWEN (ccif.ramWEN),
    .\ccif.ramREN (ccif.ramREN)
  );
`endif

// `ifndef MAPPED
  ram rDUT(CLK, nRST, ram_if.ram);
// `else
//   ram rDUT(
//     .\CLK (CLK),
//     .\nRST (nRST),
//     .\ram_if.ramaddr (ram_if.ramaddr),
//     .\ram_if.ramstore (ram_if.ramstore),
//     .\ram_if.ramREN (ram_if.ramREN),
//     .\ram_if.ramWEN (ram_if.ramWEN),
//     .\ram_if.ramstate (ram_if.ramstate),
//     .\ram_if.ramload (ram_if.ramload)
//   );

// `endif

  assign ram_if.ramaddr = ccif.ramaddr;
  assign ram_if.ramstore = ccif.ramstore;
  assign ram_if.ramREN = ccif.ramREN;
  assign ram_if.ramWEN = ccif.ramWEN;
  assign ccif.ramstate = ram_if.ramstate;
  assign ccif.ramload = ram_if.ramload;

endmodule

program test (input logic CLK, output logic nRST, cache_control_if.cc ccif);

    integer test_num = 0;
    string test_case;
    initial begin
    //Initialize
    nRST = 0;

    cif0.dWEN = 0;
    cif0.dREN = 0;
    cif0.iREN = 0;
    cif0.dstore = '0;
    cif0.iaddr = '0;
    cif0.daddr = '0;
    cif0.ccwrite = 0;
    cif0.cctrans = 0;

    cif1.dWEN = 0;
    cif1.dREN = 0;
    cif1.iREN = 0;
    cif1.dstore = '0;
    cif1.iaddr = '0;
    cif1.daddr = '0;
    cif1.ccwrite = 0;
    cif1.cctrans = 0;

    #(5);
    nRST = 1;
    test_num++;
    test_case = "IF PATH ONE";
    #(PERIOD);
    cif0.iREN = 1;
    cif0.iaddr = 32'h00000032;
    @(negedge cif0.iwait);
    #(PERIOD);
    cif0.iREN = 0;
    #(PERIOD);
    #(PERIOD);

    test_num++;
    test_case = "IF PATH TWO";
    #(PERIOD);
    cif1.iREN = 1;
    cif1.iaddr = 32'h00000036;
    @(negedge cif1.iwait);
    #(PERIOD);
    cif1.iREN = 0;
    #(PERIOD);
    #(PERIOD);

    test_num++;
    test_case = "WRITE BACK PATH ONE";
    #(PERIOD);
    nRST = 1;
    cif0.dWEN = 1;
    cif0.daddr = 32'h00000032;
    cif0.dstore = 32'hDEAFDEAF;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif0.daddr = 32'h00000036;
    cif0.dstore = 32'hFAAFFEEF;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif0.dWEN = 0;
    cif0.dstore = '0;
    #(PERIOD);
    #(PERIOD);

    test_num++;
    test_case = "WRITE BACK PATH TWO";
    #(PERIOD);
    nRST = 1;
    cif1.dWEN = 1;
    cif1.daddr = 32'h00000032;
    cif1.dstore = 32'hDEAFDEAF;
    @(negedge cif1.dwait);
    #(10);
    cif1.daddr = 32'h00000036;
    cif1.dstore = 32'hFAAFFEEF;
    @(negedge cif1.dwait);
    #(10);
    cif1.dWEN = 0;
    cif1.dstore = '0;
    #(PERIOD);
    #(PERIOD);

    test_num++;
    test_case = "BUSWB PATH ONE";
    #(PERIOD);
    cif0.cctrans = 1;
    #(PERIOD);
    cif0.dREN = 1;
    #(PERIOD);
    cif1.ccwrite = 1;
    cif1.cctrans = 1;
    #(PERIOD);
    cif1.dWEN = 1;
    cif1.daddr = 32'h0000000c;
    cif1.dstore = 32'hDEAFDEAF;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif1.daddr = 32'h0000000a;
    cif1.dstore = 32'hDEEFDEEF;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif0.dREN = 0;
    cif1.ccwrite = 0;
    cif0.cctrans = 0;
    cif1.cctrans = 0;
    cif1.dWEN = 0;
    #(PERIOD);
    #(PERIOD);

    test_num++;
    test_case = "BUSWB PATH TWO";
    #(PERIOD);
    cif1.cctrans = 1;
    #(PERIOD);
    cif1.dREN = 1;
    #(PERIOD);
    cif0.ccwrite = 1;
    cif0.cctrans = 1;
    #(PERIOD);
    cif0.dWEN = 1;
    cif0.daddr = 32'h0000000c;
    cif0.dstore = 32'hDEAFDEAF;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif0.daddr = 32'h0000000a;
    cif0.dstore = 32'hDEEFDEEF;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif1.dREN = 0;
    cif0.ccwrite = 0;
    cif1.cctrans = 0;
    cif0.cctrans = 0;
    cif0.dWEN = 0;
    #(PERIOD);
    #(PERIOD);

    test_num++;
    test_case = "LOAD PATH ONE";
    #(PERIOD);
    cif0.cctrans = 1;
    #(PERIOD);
    cif0.dREN = 1;
    #(PERIOD);
    cif1.ccwrite = 0;
    cif1.cctrans = 1;
    #(PERIOD);
    cif0.daddr = 32'h0000000c;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif0.daddr = 32'h00000008;
    @(negedge cif0.dwait);
    #(PERIOD);
    cif0.daddr = '0;
    cif1.cctrans = '0;
    cif0.dREN = '0;
    cif0.cctrans = '0;
    #(PERIOD);
    #(PERIOD);
    nRST = '0;
    end
endprogram