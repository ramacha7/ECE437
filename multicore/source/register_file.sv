//Interface
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module register_file(input logic CLK, nRST, register_file_if.rf rfif);

import cpu_types_pkg::*;

word_t registers[31:0];
//word_t temp_reg[31:0];

always_ff @(negedge CLK, negedge nRST) begin
  if(!nRST) begin
    registers <= '{default: '0};
  end

  else begin
    //registers <= temp_reg;
    if(rfif.WEN == 1'b1 && rfif.wsel != 5'd0) begin
      registers[rfif.wsel] <= rfif.wdat;
    end
  end
end

always_comb begin
  //temp_reg = registers;
  rfif.rdat1 = registers[rfif.rsel1];
  rfif.rdat2 = registers[rfif.rsel2];
  // if(rfif.WEN == 1'b1 && rfif.wsel != 5'd0) begin
  //   temp_reg[rfif.wsel] = rfif.wdat;
  // end
end

endmodule
