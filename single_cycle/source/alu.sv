//Interface
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module alu(input logic CLK, nRST, alu_if.af aif);

import cpu_types_pkg::*;

logic [31:0] temp;
logic [31:0] twocomplement;
logic [31:0] two_comp_res;

assign twocomplement = ~((aif.portB));
assign two_comp_res = twocomplement + 1;

always_comb begin
    temp = '0;
    aif.ovf = 0;
    casez(aif.ALUOP)

        ALU_SLL: begin
            temp = aif.portB << aif.portA[4:0];
        end

        ALU_SRL: begin
            temp = aif.portB >> aif.portA[4:0];
        end

        ALU_ADD: begin
            temp = (aif.portA) + (aif.portB);
            aif.ovf = (aif.portA[31] ^ aif.portB[31]) ? 0: temp[31] ^ aif.portA[31];

        end

        ALU_SUB: begin
            //temp = (aif.portA) + (two_comp_res);
            temp = aif.portA - aif.portB;
            aif.ovf = (aif.portA[31] ^ aif.portB[31]) ? 0: temp[31] ^ aif.portA[31];
        end

        ALU_AND: begin
            temp = aif.portA & aif.portB;
        end

        ALU_OR: begin
            temp = aif.portA |  aif.portB;
        end

        ALU_XOR: begin
            temp = aif.portA ^ aif.portB;
        end

        ALU_NOR: begin
            temp = ~(aif.portA | aif.portB);
        end

        ALU_SLT: begin
            temp = ($signed(aif.portA) < $signed(aif.portB)) ? 32'd1 : 32'd0;
        end

        ALU_SLTU: begin
            temp = (aif.portA < aif.portB) ? 32'd1 : 32'd0;
        end

    endcase
end

assign aif.out_port = temp[31:0];

assign aif.zero = (aif.out_port == 32'd0) ? 1'b1 : 1'b0;

assign aif.neg = (temp[31] == 1) ? 1'b1 : 1'b0;

endmodule
