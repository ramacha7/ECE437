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

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  assign ccif.ramWEN = ccif.dWEN;                                                //only data writes are possible
  assign ccif.ramREN = (ccif.dREN || (ccif.iREN && ~ccif.dWEN)) ? 1:0;                 // ramREN turned on when dREN is on or when iREN is on without dWEN being on
  assign ccif.ramaddr = (ccif.dWEN || ccif.dREN) ? ccif.daddr : ccif.iaddr;      // giving priority to data requests, if dREN or dWEN is on, ramaddr = daddr, else ramaddr = iaddr
  assign ccif.ramstore = ccif.dstore;                                            // only data writes are possible hence ramstore = dstore
  //assign ccif.iwait = ((~(ccif.ramstate == ACCESS)) && (ccif.dWEN || ccif.dREN)) ? 1:0;     // instruction wait is on whenever RAM isnt ready to be accessed and when dWEN or dREN are on
  assign ccif.iwait = ((ccif.iREN && ~ccif.dREN && ~ccif.dWEN) && (ccif.ramstate == ACCESS)) ? 0:1;
  assign ccif.dwait = ((ccif.dWEN || ccif.dREN) && (ccif.ramstate == ACCESS)) ? 0:1;
  //assign ccif.dwait = ((~(ccif.ramstate == ACCESS)) && ccif.iREN && ~ccif.dWEN && ~ccif.dREN) ? 1:0;  //NOTE: MAY HAVE TO CHECK DEPENDENCY OF iREN //data wait is on whenever RAM isnt ready to be accessed and when only iREN is on
  assign ccif.iload = (ccif.iREN && ~ccif.dREN && ~ccif.dWEN) ? ccif.ramload : '0;          //if iREN only is on with dREN and dWEN being off, then iload = ramload, else 0
  assign ccif.dload = (ccif.dREN) ? ccif.ramload : '0;                               //if dREN is on, then dload = ramload, else 0
endmodule