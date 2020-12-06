`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

module control_unit(
    input logic CLK, nRST, control_unit_if.cu cuif
);

    import cpu_types_pkg::*;

    opcode_t opcode;
    funct_t func;
    
    assign opcode = opcode_t'(cuif.instr[31:26]);
    assign func = funct_t'(cuif.instr[5:0]);       //FOR RTYPE

    always_comb begin
        cuif.PCSrc = '0;
        cuif.RegWr = '0;
        cuif.RegDst = '0;
        cuif.ExtOp = '0;
        cuif.ALUSrc = '0;
        cuif.MemtoReg = '0;
        cuif.halt = '0;
        cuif.dREN = '0;
        cuif.dWEN = '0;
        cuif.iREN = '0;
        cuif.JAL = '0;
        cuif.LUI = '0;
        cuif.ALUOP = ALU_SLL;
        cuif.BNE = '0;
        cuif.BEQ = '0;
        cuif.rs = '0;
        cuif.rd = '0;
        cuif.rt = '0;
        cuif.imm_val = '0;

        if(opcode == RTYPE) begin
            cuif.rs = cuif.instr[25:21];
            cuif.rt = cuif.instr[20:16];
            cuif.rd = cuif.instr[15:11];
            cuif.PCSrc = '0;           //pc+4 (EXCEPT FOR JR)
            cuif.ALUOP = ALU_ADD;      //default ALUOP
            cuif.RegDst = '0;

            case(func)
                SLLV: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_SLL;
                    
                end

                SRLV: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_SRL;
                    
                end
        
                ADD: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_ADD;
                    
                end

                ADDU: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_ADD;
                end

                SUB: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_SUB;
                end

                SUBU: begin
                    cuif.RegWr = 1'b1;
                    cuif.ALUOP = ALU_SUB;
                end

                AND: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_AND;
                end

                OR: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_OR;
                end

                XOR: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_XOR;
                    
                end

                NOR: begin
                    cuif.RegWr = 1'b1;
                    cuif.ALUOP = ALU_NOR;
                end

                SLT: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_SLT;
                end

                SLTU: begin
                    cuif.RegWr =1'b1;
                    cuif.ALUOP = ALU_SLTU;
                    
                end

                JR: begin
                    cuif.PCSrc = 2'd3;
                end

            endcase
        end

        else if(opcode == HALT) begin
            cuif.halt = 1'b1;
        end

        else if(opcode == J) begin
            cuif.PCSrc = 2'd2;
        end


        else if(opcode == JAL) begin
            cuif.JAL = 1;
            cuif.PCSrc = 2'd2;
            cuif.RegWr = 1'b1;
            cuif.RegDst = 2'd2;
        end



        else begin
            //itype
            cuif.rs = cuif.instr[25:21];
            cuif.rt = cuif.instr[20:16];
            cuif.imm_val = cuif.instr[15:0];
            cuif.RegDst = 1'b1;

            case(opcode)
                
                BEQ: begin
                    cuif.BEQ = 1'b1;
                    cuif.PCSrc = 2'd1;
                    cuif.ALUSrc = 1'b0;
                    cuif.ExtOp = 2'd0;
                    cuif.ALUOP = ALU_SUB;
                end

                BNE: begin
                    cuif.BNE = 1'b1;
                    cuif.PCSrc = 2'd1;
                    cuif.ALUSrc = 1'b0;
                    cuif.ExtOp = 2'd0;
                    cuif.ALUOP = ALU_SUB;
                    
                end

                ORI: begin
                    cuif.BEQ = 1'b0;
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd0;
                    cuif.ALUOP = ALU_OR;
                    cuif.MemtoReg = 1'b0;  
                    cuif.RegWr = 1'b1; 
                end

                SLTI: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd1;
                    cuif.ALUOP = ALU_SLT;
                    cuif.MemtoReg = 1'b0;  
                    cuif.dWEN = 1'b0;
                    cuif.RegWr = 1'b1;
                end

                SLTIU: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd1;
                    cuif.ALUOP = ALU_SLTU;
                    cuif.MemtoReg = 1'b0;  
                    cuif.dWEN = 1'b0;
                    cuif.RegWr = 1'b1;    
                end

                XORI: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd0;
                    cuif.ALUOP = ALU_XOR;
                    cuif.MemtoReg = 1'b0;  
                    cuif.dWEN = 1'b0;
                    cuif.RegWr = 1'b1;     
                end

                ADDI: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd1;
                    cuif.ALUOP = ALU_ADD;
                    cuif.MemtoReg = 1'b0;  
                    cuif.dWEN = 1'b0;
                    cuif.RegWr = 1'b1; 
                    
                end

                ADDIU: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd1;
                    cuif.ALUOP = ALU_ADD;
                    cuif.MemtoReg = 1'b0;  
                    cuif.dWEN = 1'b0;
                    cuif.RegWr = 1'b1; 
                    
                end

                ANDI: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd0;
                    cuif.ALUOP = ALU_AND;
                    cuif.MemtoReg = 1'b0;  
                    cuif.dWEN = 1'b0;
                    cuif.RegWr = 1'b1; 
                    
                end


                LUI: begin
                    cuif.LUI = 1'b1;
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd2;
                    cuif.ALUOP = ALU_ADD;
                    cuif.MemtoReg = 1'b0;   
                    cuif.RegWr = 1'b1; 
                end

                LW: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd1;
                    cuif.ALUOP = ALU_ADD;
                    cuif.MemtoReg = 1'b1;
                    cuif.RegWr = 1'b1;
                    cuif.dREN = 1'b1;
                    cuif.RegDst = 2'd1;
                    cuif.dWEN = 1'b0;     
                end

                SW: begin
                    cuif.PCSrc = 2'd0;
                    cuif.ALUSrc = 1'b1;
                    cuif.ExtOp = 2'd1;
                    cuif.ALUOP = ALU_ADD;
                    cuif.MemtoReg = 1'b0;  
                    cuif.dWEN = 1'b1;
                    cuif.RegWr = 1'b0;     
                end
            endcase
        end
    end
    

    


endmodule