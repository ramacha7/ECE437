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
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  typedef enum logic [3:0] {IDLE, ARBITRATE, SNOOP, LD1, LD2, BUSWB1, BUSWB2, WB1, WB2,INSTR_FETCH} StateType; 

  StateType state,next_state;
  logic snooper,next_snooper;     //snooper refers to the requestor block that is requesting for a block on a miss either from another cache or RAM
  logic snoopy,next_snoopy;       //snoopy refers to the other cache which the bus snoops into to update MSI and see if the block that the snooper needs is available.

  always_ff @(posedge clk, negedge nRST) begin
    if(!nRST) begin
      snooper <= '0;
      snoopy <= '1;
      state <= IDLE;
    end

    else begin
      snooper <= next_snooper;
      snoopy <= next_snoopy;
      state <= next_state;
    end
  end

  //coherence state machine next state logic (bus controller)
  always_comb begin
    next_state = state;
    next_snoopy = snoopy;
    next_snooper = snooper;

    ccif.ramaddr = '0;
    ccif.ramstore = '0;
    ccif.ramWEN = '0;
    ccif.ramREN = '0;

    ccif.snoopaddr[0] = '0;
    ccif.snooperaddr[1] = '0;

    ccif.inv = 2'b00;         //invalidate signals going to both caches is deasserted by default  (ccif.inv[0] = 0, ccif.inv[1] = 0)

    ccif.iwait = 2'b11;       // iwait is by default 1 for both caches because we only want to deassert it when we have supplied the instruction to the icaches (ccif.iwait[0] = 1, ccif.iwat[1] = 1)
    ccif.iload[0] = '0;
    ccif.iload[1] = '0;

    ccif.dwait = 2'b11;        // iwait is by default 1 for both caches because we only want to deassert it when we have supplied the data to the dcaches (ccif.iwait[0] = 1, ccif.iwat[1] = 1)
    ccif.dload[0] = '0;
    ccif.dload[1] = '0;

    case(state)
        
        IDLE: begin    //all related signals have been set in the starting of always_comb block
            if(ccif.dWEN[0] || ccif.dWEN[1]) begin
                next_state = WB1;
            end
            else if(ccif.cctrans[0] || ccif.cctrans[1]) begin    // if there is a transition, we know there is a miss hence there we have to choose who is the snoopy and snooper
              next_state = ARBITRATE;
            end
            else if(ccif.iREN[0] || ccif.iREN[1]) begin
              next_state = INSTR_FETCH;
            end
        end

        ARBITRATE: begin      //assigning based which processor's cache generated the BusRd/BusRdX. If both generated, use policy of arbitrating to first processor's cache
            if(ccif.dREN[0]) begin            //cache 0 is the requestor
                next_snooper = '0;
                next_snoopy = '1;
                next_state = SNOOP;
                ccif.ccwait[1] = 1;
            end
            else if(ccif.dREN[1]) begin         //cache 1 is the requestor
                next_snooper = '1;
                next_snoopy = '0;
                next_state = SNOOP;
                ccif.ccwait[0] = 1;
            end
        end

        SNOOP: begin     
          //here the requestor block generates a busRd or busRdX. if ccwrite of requestor block is on, it is a busRdX. Else it is a busRd. assign the snoopaddr for the snoopy cache.
          // Once the snoopy cache has updated the MSI state, there would be state transitions, hence when snoopy's cctrans is on, the MSI has been updated.
            ccif.ccsnoopaddr[snoopy] = ccif.daddr[snooper];
            ccif.ccwait[snoopy] = 1;
            if(ccif.ccwrite[snooper] == 1) begin
                ccif.inv[snoopy] = 1;
            end

            if(ccif.cctrans[snoopy] && ccif.ccwrite[snoopy]) begin   //If the snoopy has the block, it will turn on its ccwrite, hence we have to do BUSWB.
                next_state = BUSWB1;
            end
            else if(ccif.cctrans[snoopy]) begin   //If it does not have the block, then its ccwrite is 0 and we load the block from memory
                next_state = LD1;
            end  
        end

        LD1: begin  //loading first word from block from memory because no other caches have the block
            ccif.ramaddr = ccif.daddr[snooper];
            ccif.ramREN = ccif.dREN[snooper];

            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                next_state = LD2;         //read word 1 from memory, so go to LD1
            end
            else begin
              ccif.dwait[snooper]= 1;
            end 

            ccif.dload[snooper] = ccif.ramload;
        end

        LD2: begin    //loading second word from block from memory because no other caches have the block
            ccif.ramaddr = ccif.daddr[snooper];
            ccif.ramREN = ccif.dREN[snooper];
            
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                next_state = IDLE;        //read word 2 from memory, so go to IDLE
            end
            else begin
              ccif.dwait[snooper]= 1;
            end

            ccif.dload[snooper] = ccif.ramload;
        end

        BUSWB1: begin   //here we send first word in block from snoopy cache to memory as well as to requestor block
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                ccif.dwait[snoopy] = 0;
                next_state = BUSWB2;          //written word 1 to memory and requestor, so go to BUSWB2
            end
            else begin
                ccif.dwait[snooper] = 1;
                ccif.dwait[snoopy] = 1;
            end
            ccif.ramaddr = ccif.daddr[snoopy];
            ccif.ramWEN = ccif.dREN[snoopy];
            ccif.ramstore = ccif.dstore[snoopy];

            ccif.dload[snooper] = ccif.dstore[snoopy];    
        end

        BUSWB2: begin       //here we send second word in block from snoopy cache to memory as well as to requestor block
            if(ccif.ramstate == ACCESS) begin
                ccif.dwait[snooper] = 0;
                ccif.dwait[snoopy] = 0;
                next_state = IDLE;           //written word 2 to memory and requestor, so go to IDLE
            end
            else begin
                ccif.dwait[snooper] = 1;
                ccif.dwait[snoopy] = 1;
            end
            
            ccif.ramaddr = ccif.daddr[snoopy];
            ccif.ramWEN = ccif.dREN[snoopy];
            ccif.ramstore = ccif.dstore[snoopy];

            ccif.dload[snooper] = ccif.dstore[snoopy]; 
        end

        WB1: begin     //If a block is being evicted (on a write miss and block is dirty), we write first word to memory (Writeback is not involved in coherence)
            if(ccif.dWEN[0]) begin              //checking if cache 0 made the request
                ccif.ramaddr = ccif.daddr[0];
                ccif.ramWEN = ccif.dWEN[0];
                ccif.ramstore = ccif.dstore[0];
                if(ccif.ramstate == ACCESS) begin
                    ccif.dwait[0] = 0;
                    next_state = WB2;           //written word 1 to memory, so go to WB2
                end
                else begin
                    ccif.dwait[0] = 1;
                end
            end

            else if(ccif.dWEN[1]) begin         //checking if cache 1 made the request
                ccif.ramaddr = ccif.daddr[1];
                ccif.ramWEN = ccif.dWEN[1];
                ccif.ramstore = ccif.dstore[1];
                if(ccif.ramstate == ACCESS) begin
                    ccif.dwait[1] = 0;
                    next_state = WB2;           //written word 1 to memory, so go to WB2
                end
                else begin
                    ccif.dwait[1] = 1;
                end
            end
          
        end

        WB2: begin      //If a block is being evicted (on a write miss and block is dirty), we write second word to memory (Writeback is not involved in coherence)
            if(ccif.dWEN[0]) begin                        //checking if cache 0 made the request
                ccif.ramaddr = ccif.daddr[0];
                ccif.ramWEN = ccif.dWEN[0];
                ccif.ramstore = ccif.dstore[0];
                if(ccif.ramstate == ACCESS) begin
                    ccif.dwait[0] = 0;
                    next_state = IDLE;              //written word 2 to memory, so go to IDLE
                end
                else begin
                    ccif.dwait[0] = 1;
                end
            end

            else if(ccif.dWEN[1]) begin                   //checking if cache 1 made the request
                ccif.ramaddr = ccif.daddr[1];
                ccif.ramWEN = ccif.dWEN[1];
                ccif.ramstore = ccif.dstore[1];
                if(ccif.ramstate == ACCESS) begin
                    ccif.dwait[1] = 0;
                    next_state = IDLE;              //written word 2 to memory, so go to IDLE
                end
                else begin
                    ccif.dwait[1] = 1;
                end
            end
          
        end

        INSTR_FETCH: begin       //On an instruction miss, we just fetch the block from memory (Instruction fetch is not involved in coherence)
          if(ccif.iREN[0]) begin                                    //checking if cache 0 made the request
              ccif.ramaddr = ccif.iaddr[0];
              ccif.iload[0] = ccif.ramload;
              ccif.ramREN = ccif.iREN[0];
              if(ccif.ramstate == ACCESS) begin
                  ccif.iwait[0] = 0;
                  next_state = IDLE;                  //read word 1 to memory, so go to IDLE
              end
              else begin
                  ccif.iwait[0] = 1;
              end
          end
          else if(ccif.iREN[1]) begin                               //checking if cache 1 made the request
              ccif.ramaddr = ccif.iaddr[1];
              ccif.iload[1] = ccif.ramload;
              ccif.ramREN = ccif.iREN[1];
              if(ccif.ramstate == ACCESS) begin
                  ccif.iwait[1] = 0;
                  next_state = IDLE;                  //read word 1 to memory, so go to IDLE
              end
              else begin
                  ccif.iwait[1] = 1;
              end
          end
          
        end

    endcase

  end

  // assign ccif.ramWEN = ccif.dWEN;                                                //only data writes are possible
  // assign ccif.ramREN = (ccif.dREN || (ccif.iREN && ~ccif.dWEN)) ? 1:0;                 // ramREN turned on when dREN is on or when iREN is on without dWEN being on
  // assign ccif.ramaddr = (ccif.dWEN || ccif.dREN) ? ccif.daddr : ccif.iaddr;      // giving priority to data requests, if dREN or dWEN is on, ramaddr = daddr, else ramaddr = iaddr
  // assign ccif.ramstore = ccif.dstore;                                            // only data writes are possible hence ramstore = dstore
  // //assign ccif.iwait = ((~(ccif.ramstate == ACCESS)) && (ccif.dWEN || ccif.dREN)) ? 1:0;     // instruction wait is on whenever RAM isnt ready to be accessed and when dWEN or dREN are on
  // assign ccif.iwait = ((ccif.iREN && ~ccif.dREN && ~ccif.dWEN) && (ccif.ramstate == ACCESS)) ? 0:1;
  // assign ccif.dwait = ((ccif.dWEN || ccif.dREN) && (ccif.ramstate == ACCESS)) ? 0:1;
  // //assign ccif.dwait = ((~(ccif.ramstate == ACCESS)) && ccif.iREN && ~ccif.dWEN && ~ccif.dREN) ? 1:0;  //NOTE: MAY HAVE TO CHECK DEPENDENCY OF iREN //data wait is on whenever RAM isnt ready to be accessed and when only iREN is on
  // assign ccif.iload = (ccif.iREN && ~ccif.dREN && ~ccif.dWEN) ? ccif.ramload : '0;          //if iREN only is on with dREN and dWEN being off, then iload = ramload, else 0
  // assign ccif.dload = (ccif.dREN) ? ccif.ramload : '0;                               //if dREN is on, then dload = ramload, else 0
endmodule