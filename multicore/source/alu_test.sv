/*
  Eric Villasenor
  evillase@gmail.com

  single cycle top block
  holds data path components
  and cache level
*/
`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu_test (
  input logic CLK, nRST,
  output logic halt,
  cpu_ram_if.cpu scif
);
  import cpu_types_pkg::*;

logic [3:0] counter, ncounter;

alu_if aif();

localparam logic [31:0] test_in_A [15:0] = '{
32'h27b70a85,32'h2e1b2138,32'h4d2c6dfc,32'h53380d13,32'h650a7354,32'h766a0abb,32'h81c2c92e,32'h92722c85,
32'ha2bfe8a1,32'ha81a664b,32'hc24b8b70,32'hc76c51a3,32'hd192e819,32'hd6990624,32'hf40e3585,32'h106aa070};

localparam logic [31:0] test_in_B [15:0] =  '{
32'h19a4c116,32'h1e376c08,32'h2748774c,32'h34b0bcb5,32'h391c0cb3,32'h4ed8aa4a,32'h5b9cca4f,32'h682e6ff3,
32'h748f82ee,32'h78a5636f,32'h84c87814,32'h8cc70208,32'h90befffa,32'ha4506ceb,32'hbef9a3f7,32'hc67178f2};
localparam aluop_t ALUop_in [15:0] = '{
    ALU_SLL,  ALU_SRL, ALU_ADD, ALU_SUB, ALU_ADD, ALU_SUB, ALU_ADD, ALU_SUB, ALU_ADD, ALU_SUB, ALU_AND, ALU_OR,
    ALU_XOR, ALU_NOR, ALU_SLT, ALU_SLTU
};
logic [31:0] portA, portB;
logic [31:0] ALUout;
logic Zero;
aluop_t ALUop;
assign portA = test_in_A[counter];
assign portB = test_in_B[counter];
assign ALUop = ALUop_in[counter];

assign aif.portA = portA;
assign aif.portB = portB;
assign aif.ALUOP = ALUop;

always_ff @(posedge CLK, negedge nRST) begin 
  if (nRST == 0) begin 
    counter <= 0;
  end else begin 
    counter <= ncounter;
  end 
end   

always_comb begin
    ncounter = counter;
    if (scif.ramstate == ACCESS) begin 
        ncounter = counter + 1;
    end
    if (counter == 10) begin 
        ncounter = counter;
    end 
end


/*`ifndef MAPPED
  alu DUT(CLK, nRST, aif.af);
`else
alu ALU (
.CLK(CLK), .nRST(nRST),
.\aif.portA(portA),
.\aif.portB(portB),
.\aif.ALUOP(ALUop),
.\aif.neg(), .\aif.zero(Zero), .\aif.ovf(),
.\aif.out_port(ALUout)
);
`endif*/

alu ALU (
CLK,nRST,aif
);

  assign scif.memaddr = counter << 2;
  assign scif.memstore = aif.out_port;
  assign scif.memREN = 0;
  assign scif.memWEN = 1;

  assign halt = (counter == 10);
endmodule
