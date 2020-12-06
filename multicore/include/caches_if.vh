/*
  John Skubic

  interface to coordinate caches and
  implement coherence protocol

  caches_if connects a single cache to the cache_control_if

  The cache_control_if will pass on the caches_if signals to
  the memory controller
*/
`ifndef CACHES_IF_VH
`define CACHES_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"

interface caches_if;

  // import types
  import cpu_types_pkg::*;

  // arbitration
  logic          iwait, dwait, iREN, dREN, dWEN;
  word_t         iload, dload, dstore;
  word_t         iaddr, daddr;

  // coherence
  // CPUS = number of cpus parameter passed from system -> cc
  // ccwait         : lets a cache know it needs to block cpu
  // ccinv          : let a cache know it needs to invalidate entry
  // ccwrite        : high if cache is doing a write of addr
  // ccsnoopaddr    : the addr being sent to other cache with either (wb/inv)
  // cctrans        : high if the cache state is transitioning (i.e. I->S, I->M, etc...)
  //ccflushed       : Used to determine if one cache has already halted, thus all snooping goes through memory path
  //snoopy_write    : Used to signal snoopy cache that requestor cache is doing a store. (used for invalidating link register of snoopy cache)
  logic         ccwait, ccinv, ccflushed; 
  logic         ccwrite, cctrans;
  logic         snoopy_write;
  word_t        ccsnoopaddr;


  // icache ports to controller
  modport icache (
    input   iwait, iload,
    output  iREN, iaddr
  );

  // dcache ports to controller
  modport dcache (
    input   dwait, dload,
            ccwait, ccinv, ccsnoopaddr,snoopy_write,
    output  dREN, dWEN, daddr, dstore,
            ccwrite, cctrans, ccflushed
  );

  // caches ports to controller
  modport caches(
    input   dwait, dload,
            ccwait, ccinv, ccsnoopaddr,
            iwait, iload,snoopy_write,
    output  dREN, dWEN, daddr, dstore,
            ccwrite, cctrans, ccflushed,
            iREN, iaddr
  );


endinterface

`endif //CACHES_IF_VH
