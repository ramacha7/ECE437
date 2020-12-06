/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  word_t sign_extend,zero_extend,lui_extend;
  word_t beqaddr,bneaddr,jraddr,jaddr;

  //instantiation of Interfaces
  //cpu_ram_if ramif();
  control_unit_if cuif();
  alu_if aluif();
  program_counter_if pcif();
  register_file_if rfif();
  request_unit_if ruif();

  //DUT calls
  alu ALU_DUT (CLK,nRST,aluif);
  //ram RAM_DUT (CLK,nRST,ramif);
  register_file RF_DUT(CLK,nRST,rfif);
  program_counter PC_DUT(CLK,nRST,pcif);
  request_unit REG_DUT(CLK,nRST,ruif);
  control_unit CU_DUT(CLK,nRST,cuif);

  always_ff @(posedge CLK,negedge nRST) begin
      if(!nRST) begin
          dpif.halt <= '0;
      end
      else begin
          dpif.halt <= cuif.halt;
      end
  end


    always_comb begin
        //logic for the next pc value
        pcif.pc_comb = pcif.next_pc;
        if(cuif.PCSrc == 2'd0) begin
            pcif.pc_comb = pcif.next_pc;
        end
        else if(cuif.PCSrc == 2'd1) begin
            if(cuif.BEQ == 1) begin
                pcif.pc_comb = beqaddr;
            end
            else begin
                pcif.pc_comb = bneaddr;
            end
        end
        else if(cuif.PCSrc == 2'd2) begin
            pcif.pc_comb = jaddr;
        end
        else if(cuif.PCSrc == 2'd3) begin
            pcif.pc_comb = jraddr;
        end


        //logic for calculating portB
        if(cuif.ALUSrc == 1'b0) begin
            aluif.portB = rfif.rdat2;
        end
        else begin
            if(cuif.ExtOp == 2'd0) begin
                aluif.portB = zero_extend;
            end
            else if(cuif.ExtOp == 2'd1) begin
                aluif.portB = sign_extend;
            end
            else begin
                aluif.portB = lui_extend;
            end
        end
    end


    //extend operations
    assign sign_extend = cuif.imm_val[15] ? {16'hFFFF,cuif.imm_val} : {16'h0000,cuif.imm_val};
    assign zero_extend = {16'h0000,cuif.imm_val};
    assign lui_extend = {cuif.imm_val,16'h0000};

    //branch and jump addresses
    assign jaddr = {pcif.next_pc[31:28],cuif.instr[25:0],2'b00};
    assign jraddr = aluif.portA;
    assign beqaddr = aluif.zero ? pcif.next_pc + (sign_extend[29:0] << 2) : pcif.next_pc;
    assign bneaddr = ~aluif.zero ? pcif.next_pc + (sign_extend[29:0] << 2) : pcif.next_pc;

  //datapath cache interface
    assign dpif.imemaddr = pcif.pc;
    assign dpif.dmemWEN = ruif.reg_dWEN;
    assign dpif.imemREN = 1'b1;
    assign dpif.dmemREN = ruif.reg_dREN;
    assign dpif.dmemaddr = aluif.out_port;
    assign dpif.dmemstore = rfif.rdat2;

   //register file interface
    assign rfif.rsel1 = cuif.rs;
    assign rfif.rsel2 = cuif.rt;


    //REQUEST UNIT interface
    assign ruif.dWEN = cuif.dWEN;
    assign ruif.dREN = cuif.dREN;
    assign ruif.ihit = cuif.ihit;
    assign ruif.dhit = cuif.dhit;

    //control unit interface
    assign cuif.dhit = dpif.dhit;
    assign cuif.ihit = dpif.ihit;
    assign cuif.instr = dpif.imemload;

    //alu interface
    assign aluif.portA = rfif.rdat1;
    assign aluif.ALUOP = cuif.ALUOP;

    //program counter interface
    assign pcif.pc_incr = ruif.ihit;

    //logic for rfif.WEN
    assign rfif.WEN = (cuif.RegWr & (dpif.ihit | dpif.dhit)) ? 1'b1 : 1'b0;

    //logic for rfif.wdat
    assign rfif.wdat = (cuif.JAL == 1'b1) ? pcif.next_pc : ((cuif.MemtoReg) ? dpif.dmemload : aluif.out_port);

    //logic for rfif.wsel
    assign rfif.wsel = (cuif.RegDst == 2'd0) ? cuif.rd : ((cuif.RegDst == 2'd1) ? cuif.rt : 5'd31);

endmodule