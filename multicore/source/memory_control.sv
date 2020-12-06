/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

//BUS CONTROLLER IS INTEGRATED INTO MEMORY_CONTROL TO INTERACT BETWEEN CACHES AND MEMORY
module memory_control (
  input CLK, nRST,
  cache_control_if ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  typedef enum logic [4:0] {IDLE, ARBITRATE, SNOOP,LD1, LD_BUFF, LD2, BUSWB_BUFF0, BUSWB1, BUSWB_BUFF1, BUSWB2, WB1, WB_BUFF, WB2,INSTR_FETCH} StateType;

  StateType state,next_state;
  logic ireq,next_ireq;
  logic [31:0] next_iaddr,iaddr;
  logic [31:0] next_daddr,daddr;
  logic [31:0] next_dstore,dstore;
  logic dreq,next_dreq;
  logic next_ccwait [1:0];
  logic next_ccinv [1:0];
  logic[31:0] next_snoopaddr [1:0];    //latching in the snoop addresses
  logic[31:0] next_snoopaddr0;
  logic[31:0] next_snoopaddr1;
  logic snooper,next_snooper;     //snooper refers to the requestor block that is requesting for a block on a miss either from another cache or RAM
  logic snoopy,next_snoopy;       //snoopy refers to the other cache which the bus snoops into to update MSI and see if the block that the snooper needs is available.

  always_ff @(posedge CLK, negedge nRST) begin
    if(!nRST) begin
      snooper <= '0;
      snoopy <= '1;
      state <= IDLE;
      ireq <= '0;
      dreq <= '0;
      ccif.ccsnoopaddr[0] <= '0;
      ccif.ccsnoopaddr[1] <= '0;
      ccif.ccwait[0] <= '0;
      ccif.ccwait[1] <= '0;
      ccif.ccinv[0] <= '0;
      ccif.ccinv[1] <= '0;
      iaddr <= '0;
      daddr <= '0;
      dstore <= '0;
    end
    else begin
      snooper <= next_snooper;
      snoopy <= next_snoopy;
      state <= next_state;
      ireq <= next_ireq;
      dreq <= next_dreq;
      ccif.ccsnoopaddr[0] <= next_snoopaddr[0];
      ccif.ccsnoopaddr[1] <= next_snoopaddr[1];
      ccif.ccwait[0] <= next_ccwait[0];
      ccif.ccwait[1] <= next_ccwait[1];
      ccif.ccinv[0] <= next_ccinv[0];
      ccif.ccinv[1] <= next_ccinv[1];
      iaddr <= next_iaddr;
      daddr <= next_daddr;
      dstore <= next_dstore;
    end
  end

  //coherence state machine next state logic (bus controller)
  always_comb begin
    next_iaddr = iaddr;
    next_daddr = daddr;
    next_dstore = dstore;
    next_state = state;
    next_snoopy = snoopy;
    next_snooper = snooper;
    next_ireq = ireq;
    next_dreq = dreq;
    ccif.ramaddr = '0;
    ccif.ramstore = '0;
    ccif.ramWEN = '0;
    ccif.ramREN = '0;
    next_snoopaddr[0] = ccif.ccsnoopaddr[0];
    next_snoopaddr[1] = ccif.ccsnoopaddr[1];
    next_ccinv[0] = ccif.ccinv[0];
    next_ccinv[1] = ccif.ccinv[1];
    next_ccwait[0] = ccif.ccwait[0];
    next_ccwait[1] = ccif.ccwait[1];
    ccif.iwait = 2'b11;       // iwait is by default 1 for both caches because we only want to deassert it when we have supplied the instruction to the icaches (ccif.iwait[0] = 1, ccif.iwat[1] = 1)
    ccif.iload[0] = '0;
    ccif.iload[1] = '0;
    ccif.dwait = 2'b11;        // iwait is by default 1 for both caches because we only want to deassert it when we have supplied the data to the dcaches (ccif.iwait[0] = 1, ccif.iwat[1] = 1)
    ccif.dload[0] = '0;
    ccif.dload[1] = '0;

    case(state)

        IDLE: begin    //all related signals have been set in the starting of always_comb block
            next_ccwait[0] = '0;
            next_ccwait[1] = '0;
            if(ccif.dWEN[0] || ccif.dWEN[1]) begin
                if(ccif.dWEN[0]) begin
                    next_dreq = '0;
                    next_daddr = ccif.daddr[0];
                    next_dstore = ccif.dstore[0];
                end
                else begin
                    next_dreq = '1;
                    next_daddr = ccif.daddr[1];
                    next_dstore = ccif.dstore[1];
                end
                next_state = WB1;
            end
            else if(ccif.cctrans[0] || ccif.cctrans[1]) begin    // if there is a transition, we know there is a miss hence there we have to choose who is the snoopy and snooper
              next_state = ARBITRATE;
              if(ccif.cctrans[0]) begin
                  next_ccwait[1] = '1;
              end
              else if(ccif.cctrans[1]) begin
                  next_ccwait[0] = '1;
              end
            end
            else if(ccif.iREN[0] || ccif.iREN[1]) begin
                if(ccif.iREN[0]) begin
                    next_ireq = '0;
                    next_iaddr = ccif.iaddr[0];
                end
                else begin
                    next_ireq = '1;
                    next_iaddr = ccif.iaddr[1];
                end
              next_state = INSTR_FETCH;
            end
        end

        ARBITRATE: begin      //assigning based which processor's cache generated the BusRd/BusRdX. If both generated, use policy of arbitrating to first processor's cache
            if(ccif.dREN[0]) begin            //cache 0 is the requestor
                next_snooper = '0;
                next_snoopy = '1;
                next_state = SNOOP;
                next_ccwait[1] = '1;
                next_snoopaddr[1] = ccif.daddr[0];
                if(ccif.ccwrite[0] == 1) begin
                    next_ccinv[1] = 1;
                end
            end
            else if(ccif.dREN[1]) begin         //cache 1 is the requestor
                next_snooper = '1;
                next_snoopy = '0;
                next_state = SNOOP;
                next_ccwait[0] = '1;
                next_snoopaddr[0] = ccif.daddr[1];
                if(ccif.ccwrite[1] == 1) begin
                    next_ccinv[0] = 1;
                end
            end
            else begin
                next_state = IDLE;
            end
        end

        SNOOP: begin
          //here the requestor block generates a busRd or busRdX. if ccwrite of requestor block is on, it is a busRdX. Else it is a busRd. assign the snoopaddr for the snoopy cache.
          // Once the snoopy cache has updated the MSI state, there would be state transitions, hence when snoopy's cctrans is on, the MSI has been updated.
            if(ccif.dWEN[snoopy]) begin
                next_dreq = snoopy;
                next_daddr = ccif.daddr[snoopy];
                next_dstore = ccif.dstore[snoopy];
                next_state = WB1;
            end
            else begin
                next_ccwait[snoopy]= '1;
                if(ccif.cctrans[snoopy] && ccif.ccwrite[snoopy]) begin   //If the snoopy has the block, it will turn on its ccwrite, hence we have to do BUSWB.
                    next_state = BUSWB_BUFF0;
                    //next_daddr = ccif.daddr[snoopy];
                end
                else if(ccif.cctrans[snoopy] || ccif.ccflushed[snoopy]) begin   //If it does not have the block, then its ccwrite is 0 and we load the block from memory
                    next_state = LD1;
                    next_daddr = ccif.daddr[snooper];
                end
            end
        end

        LD1: begin  //loading first word from block from memory because no other caches have the block
            //ccif.ramaddr = ccif.daddr[snooper];
            ccif.ramaddr = daddr;
            ccif.ramREN = ccif.dREN[snooper];
            next_ccinv[snoopy] = 0;
            next_ccwait[snoopy] = 1;
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                next_state = LD_BUFF;         //read word 1 from memory, so go to LD1
            end
            else begin
              ccif.dwait[snooper]= 1;
            end

            ccif.dload[snooper] = ccif.ramload;
        end

        LD_BUFF: begin
            next_state = LD2;
            next_daddr = ccif.daddr[snooper];
            next_ccwait[snoopy] = 0;
        end

        LD2: begin    //loading second word from block from memory because no other caches have the block
            //ccif.ramaddr = ccif.daddr[snooper];
            ccif.ramaddr = daddr;
            ccif.ramREN = ccif.dREN[snooper];
            next_ccwait[snoopy] = 0;
            next_ccinv[snoopy] = 0;
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                next_ccwait[snoopy] = '0;
                next_state = IDLE;        //read word 2 from memory, so go to IDLE
            end
            else begin
              ccif.dwait[snooper]= 1;
            end
            ccif.dload[snooper] = ccif.ramload;
        end

        BUSWB_BUFF0: begin
            next_state = BUSWB1;
            next_daddr = ccif.daddr[snoopy];
        end

        BUSWB1: begin   //here we send first word in block from snoopy cache to memory as well as to requestor block
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                ccif.dwait[snoopy] = 0;
                next_snoopaddr[snoopy] = {ccif.daddr[snooper][31:3],~ccif.daddr[snooper][2],ccif.daddr[snooper][1:0]};
                next_state = BUSWB_BUFF1;          //written word 1 to memory and requestor, so go to BUSWB2
            end
            else begin
                ccif.dwait[snooper] = 1;
                ccif.dwait[snoopy] = 1;
            end
            ccif.ramaddr = daddr;
            //ccif.ramaddr = ccif.daddr[snoopy];
            ccif.ramWEN = ccif.dWEN[snoopy];
            ccif.ramstore = ccif.dstore[snoopy];
            next_ccwait[snoopy] = 1;       //changing here just to keep ccwait on until end of buswb1
            next_ccinv[snoopy] = 0;
            ccif.dload[snooper] = ccif.dstore[snoopy];
        end

        BUSWB_BUFF1: begin
            next_state = BUSWB2;
            next_daddr = ccif.daddr[snoopy];
            next_ccwait[snoopy] = 1; //still keeping ccwait on (just added now)
        end

        BUSWB2: begin       //here we send second word in block from snoopy cache to memory as well as to requestor block
            //ccif.ramaddr = ccif.daddr[snoopy];
            ccif.ramaddr = daddr;
            ccif.ramWEN = ccif.dWEN[snoopy];
            ccif.ramstore = ccif.dstore[snoopy];
            next_ccwait[snoopy] = '1;
            next_ccinv[snoopy] = 0;
            ccif.dload[snooper] = ccif.dstore[snoopy];
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                ccif.dwait[snoopy] = 0;
                next_ccwait[snoopy] = 0;
                next_state = IDLE;           //written word 2 to memory and requestor, so go to IDLE
            end
            else begin
                ccif.dwait[snooper] = 1;
                ccif.dwait[snoopy] = 1;
            end
        end

        WB1: begin     //If a block is being evicted (on a write miss and block is dirty), we write first word to memory (Writeback is not involved in coherence)
            //ccif.ramaddr = ccif.daddr[dreq];
            ccif.ramaddr = daddr;
            ccif.ramWEN = ccif.dWEN[dreq];
            //ccif.ramstore = ccif.dstore[dreq];
            ccif.ramstore = dstore;
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[dreq] = '0;
                next_state = WB_BUFF;
            end
            else begin
                ccif.dwait[dreq] = '1;
            end
        end

        WB_BUFF: begin
            next_daddr = ccif.daddr[dreq];
            next_dstore = ccif.dstore[dreq];
            next_state = WB2;
        end

        WB2: begin      //If a block is being evicted (on a write miss and block is dirty), we write second word to memory (Writeback is not involved in coherence)
            //ccif.ramaddr = ccif.daddr[dreq];
            ccif.ramaddr = daddr;
            ccif.ramWEN = ccif.dWEN[dreq];
            //ccif.ramstore = ccif.dstore[dreq];
            ccif.ramstore = dstore;
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[dreq] = '0;
                next_state = IDLE;
            end
            else begin
                ccif.dwait[dreq] = '1;
            end

            if(~ccif.dWEN[0] && ~ccif.dWEN[1]) begin
                next_state = IDLE;
            end
        end

        INSTR_FETCH: begin       //On an instruction miss, we just fetch the block from memory (Instruction fetch is not involved in coherence)
            //ccif.ramaddr = ccif.iaddr[ireq];
            ccif.ramaddr = iaddr;
            ccif.ramREN = ccif.iREN[ireq];
            ccif.ramREN = ccif.iREN[ireq];
            ccif.iload[ireq] = ccif.ramload;
            if(ccif.ramstate == ACCESS) begin
                ccif.iwait[ireq] = '0;
                next_state = IDLE;
            end
            else begin
                ccif.iwait[ireq] = '1;
            end
            if(~ccif.iREN[0] && ~ccif.iREN[1]) begin
                next_state = IDLE;
            end
        end
    endcase
  end
endmodule
