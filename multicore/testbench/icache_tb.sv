`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns
import cpu_types_pkg::*;

module icache_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface delcaration
  caches_if cif();
  datapath_cache_if dcif();

// test program setup
  test PROG (CLK,nRST,cif,dcif);

`ifndef MAPPED
  icache DUT(CLK, nRST, dcif,cif);
`else
  icache DUT(
    .\cif.iwait(cif.iwait),
    .\cif.iREN(cif.iREN),
    .\cif.iload(cif.iload),
    .\cif.iaddr(cif.iaddr),
    .\dcif.imemREN(dcif.imemREN),
    .\dcif.dmemREN(dcif.dmemREN),
    .\dcif.dmemWEN(dcif.dmemWEN),
    .\dcif.ihit(dcif.ihit),
    .\dcif.imemaddr(dcif.imemaddr),
    .\dcif.imemload(dcif.imemload),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule


program test(input logic CLK,output logic nRST,caches_if cif, datapath_cache_if dcif);

  integer test_case_number; 
  string test_case;

  initial begin
    nRST = 1'b1;

    #(5);
    //reset test case
    nRST = 1'b0;
    test_case_number = 0;
    test_case = "RESET";
    cif.iload = '0;
    cif.iwait = '0;
    dcif.imemREN = '0;
    dcif.imemaddr = '0;
    dcif.dmemREN = '0;
    dcif.dmemWEN = '0;

    #(10);

    //reading first address (going to miss as nothing is in icache)
    nRST = 1'b1;
    test_case_number = test_case_number + 1;
    test_case = "FIRST ADDR ACCESS(MISS)";
    dcif.imemREN  = 1'b1;
    //26 bit = tag, 4 bit = index, 2 bit = byte offset(not used)
    dcif.imemaddr = {26'b00000000000000000001111111,4'b0000,2'b00};  
    cif.iload = 32'hDEADBEEF;
    cif.iwait = 1'b1;
    #(5);
    cif.iwait = 1'b0;


    #(10);

    // reading second address (going to miss as nothing is in icache for this memaddr)
    test_case_number = test_case_number + 1;
    test_case = "SECOND ADDR ACCESS(MISS)";
    dcif.imemREN  = 1'b1;
    //26 bit = tag, 4 bit = index, 2 bit = byte offset(not used)
    dcif.imemaddr = {26'b00000000000001111111111111,4'b0010,2'b00};  
    cif.iload = 32'hFF00FF00;
    // cif.iwait = 1'b1;
    // #(5);
    cif.iwait = 1'b0;

    #(10);

    // reading first address (going to hit as tag matches in icache for this memaddr)
    test_case_number = test_case_number + 1;
    test_case = "FIRST ADDR ACCESS(HIT)";
    dcif.imemREN  = 1'b1;
    //26 bit = tag, 4 bit = index, 2 bit = byte offset(not used)
    dcif.imemaddr = {26'b00000000000000000001111111,4'b0000,2'b00};   
    cif.iload = 32'hDEADBEEF;
    cif.iwait = 1'b1;

    #(10);
    
    // reading second address (going to hit as tag matches in icache for this memaddr)
    test_case_number = test_case_number + 1;
    test_case = "SECOND ADDR ACCESS(HIT)";
    dcif.imemREN  = 1'b1;
    //26 bit = tag, 4 bit = index, 2 bit = byte offset(not used)
    dcif.imemaddr = {26'b00000000000001111111111111,4'b0010,2'b00};     
    cif.iload = 32'hFF00FF00;
    cif.iwait = 1'b1;

    #(10);

    // reading first address (going to miss as wrong tag is in icache for this memaddr)
    test_case_number = test_case_number + 1;
    test_case = "FIRST ADDR DIFF TAG(MISS)";
    dcif.imemREN  = 1'b1;
    //26 bit = tag, 4 bit = index, 2 bit = byte offset(not used)
    dcif.imemaddr = {26'b00000000000111111111111111,4'b0000,2'b00};     
    cif.iload = 32'hABCDE000;
    #(5);
    cif.iwait = 1'b0;

    #(10);

    // reading second address (going to miss as wrong tag is in icache for this memaddr)
    @(negedge CLK);
    test_case_number = test_case_number + 1;
    test_case = "SECOND ADDR DIFF TAG(MISS)";
    dcif.imemREN  = 1'b1;
    //26 bit = tag, 4 bit = index, 2 bit = byte offset(not used)
    dcif.imemaddr = {26'b00000000111111111111111111,4'b0010,2'b00};     
    cif.iload = 32'hAABBCCDD;
    cif.iwait = 1'b1;
    #(50);
    cif.iwait = 1'b0;

    #(10);
  end

endprogram