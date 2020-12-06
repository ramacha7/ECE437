`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
`include "cpu_ram_if.vh"
`include "caches_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module old_memory_control_tb;

    parameter PERIOD = 20;

    logic CLK = 0, nRST;

    // clock
    always #(PERIOD/2) CLK++;

    // interface
    
    // ASK ABOUT DIFFERENCE BETWEEN CACHE_CONTROL_if and caches_if
    caches_if cif0();
    caches_if cif1();
    cache_control_if #(.CPUS(1)) ccif (cif0,cif1);
    cpu_ram_if ram_if();

    // test program
    test PROG (CLK, nRST, ccif,cif0);
   
    // DUT
 //   `ifndef MAPPED
    memory_controller DUT(CLK, nRST, ccif);
    ram DUT2 (CLK,nRST,ram_if.ram);
 //   `else
 /*   memory_controller DUT(
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
    `endif */

    assign ccif.ramstate = ram_if.ramstate;
    assign ccif.ramload = ram_if.ramload;
    assign ram_if.ramaddr = ccif.ramaddr;
    assign ram_if.ramstore = ccif.ramstore;
    assign ram_if.ramWEN = ccif.ramWEN;
    assign ram_if.ramREN = ccif.ramREN;
    
endmodule

program test(input logic CLK,output logic nRST, cache_control_if ccif, caches_if cif0);
    
    parameter PERIOD = 10;

    integer test_case_number; 
    string test_case;
    
    initial begin

        nRST = 1'b1;
        @(negedge CLK);
        test_case_number = 0;
        test_case = "Asynchronous Reset";

        nRST = 1'b0;
        cif0.iREN = 1'b0;
        cif0.dREN = 1'b0;
        cif0.dWEN = 1'b0;
        cif0.dstore = '0;
        #(10);
        nRST = 1'b1;
        #(20);

        /*for(integer i = 0; i < 15; i = i + 1) begin
            test_case_number = test_case_number + 1;
            test_case = "Read data from RAM";

            cif0.dWEN = 1'b0;
            cif0.dREN = 1'b1;
            cif0.iREN = 1'b0;
            cif0.daddr = (i*4);
            //cif0.dstore = 32'h0000FFFF;

            #(50);
        end

        test_case_number = test_case_number + 1;
        test_case = "MODIFY VALUES";
        cif0.dWEN = 1'b1;
        cif0.dREN = 1'b0;
        cif0.iREN = 1'b1;
        cif0.daddr = 32'd4;
        cif0.dstore = 32'h000FFFFF;

        #(50);*/
        
        
        @(negedge CLK);
        test_case_number = test_case_number + 1;
        test_case = "wRITE data to RAM";

        cif0.dWEN = 1'b1;
        cif0.dREN = 1'b0;
        cif0.iREN = 1'b1;
        cif0.daddr = 32'h0000000C;
        cif0.dstore = 32'd11;

        #(50);

        @(negedge CLK);
        test_case_number = test_case_number + 1;
        test_case = "Load Instruction";

        cif0.iREN = 1'b1;
        cif0.dREN = 1'b0;
        cif0.dWEN = 1'b0;
        cif0.iaddr = 32'h00000004;
        #(50);

        @(negedge CLK);
        test_case_number = test_case_number + 1;
        test_case = "Write Data1";

        cif0.iREN = 1'b1;
        cif0.dREN = 1'b0;
        cif0.dWEN = 1'b1;
        cif0.daddr = 32'h00000FB8;
        cif0.dstore = 32'h12345678;
        #(50);

        test_case_number = test_case_number + 1;
        test_case = "Write Data2";
        cif0.daddr = 32'h00000400;
        cif0.dstore = 32'h12F63581;
        #(50);

        @(negedge CLK);
        test_case_number = test_case_number + 1;
        test_case = "Load Instruction";

        cif0.iREN = 1'b1;
        cif0.dREN = 1'b0;
        cif0.dWEN = 1'b0;
        cif0.iaddr = 32'h00000FB8;
        #(50);

        @(negedge CLK);
        test_case_number = test_case_number + 1;
        test_case = "Read Data";

        cif0.iREN = 1'b1;
        cif0.dREN = 1'b1;
        cif0.dWEN = 1'b0;
        cif0.daddr = 32'h00000400;
        #(50);




        dump_memory();
        
    end

    task automatic dump_memory();
        string filename = "memcpu.hex";
        int memfd;

        cif0.daddr = '0;
        cif0.iREN = 0;
        cif0.dWEN = 0;
        cif0.dREN = 0;

        memfd = $fopen(filename,"w");
        if (memfd)
        $display("Starting memory dump.");
        else
        begin $display("Failed to open %s.",filename); $finish; end

        for (int unsigned i = 0; memfd && i < 16384; i++)
        begin
        int chksum = 0;
        bit [7:0][7:0] values;
        string ihex;

        cif0.daddr = i << 2;
        cif0.dREN = 1;
        repeat (4) @(posedge CLK);
        if (cif0.dload === 0)
            continue;
        values = {8'h04,16'(i),8'h00,cif0.dload};
        foreach (values[j])
            chksum += values[j];
        chksum = 16'h100 - chksum;
        ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
        $fdisplay(memfd,"%s",ihex.toupper());
        end //for
        if (memfd)
        begin
        //syif.tbCTRL = 0;
        cif0.dREN = 0;
        $fdisplay(memfd,":00000001FF");
        $fclose(memfd);
        $display("Finished memory dump.");
        end
    endtask

endprogram