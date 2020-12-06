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
    word_t beqaddr,bneaddr,jraddr,jaddr,branchaddr_extend;
    word_t forwardB_input1;
    word_t dmemstore;
    logic br_nottaken;
    opcode_t branch_op;
    logic PCSrc_br;    //signal for block deciding next pc value for branch always taken
    logic beq;    //signal to detect BEQ for block deciding next pc value for branch always taken

    //instantiation of Interfaces
    control_unit_if cuif();
    alu_if aluif();
    program_counter_if pcif();
    register_file_if rfif();
    if_id_if ifid();
    id_ex_if idex();
    ex_mem_if exmem();
    mem_wb_if memwb();
    forwarding_unit_if fuif();
    hazard_unit_if huif();

    //signals for cpu tracker
    word_t branchaddr;
    logic pipe_enable;

    //DUT calls
    alu ALU_DUT (CLK,nRST,aluif);
    register_file RF_DUT(CLK,nRST,rfif);
    program_counter PC_DUT(CLK,nRST,pcif);
    control_unit CU_DUT(CLK,nRST,cuif);
    if_id IFID_DUT(CLK,nRST,ifid);
    id_ex IDEX_DUT(CLK,nRST,idex);
    ex_mem EXMEM_DUT(CLK,nRST,exmem);
    mem_wb MW_o(CLK,nRST,memwb);
    forwarding_unit FU_DUT(CLK, nRST, fuif);
    hazard_unit HU_DUT(CLK, nRST, huif,fuif);


    //setting the pc init value for each core
    assign pcif.PC_RESET = PC_INIT;
    
    always_ff @(posedge CLK,negedge nRST) begin
        if(!nRST) begin
            dpif.halt <= '0;
        end
        else begin
            if(exmem.halt_out) begin
                dpif.halt <= exmem.halt_out;
            end
        end
    end

    //for cpu tracker signals
    always_comb begin
        pipe_enable = (dpif.ihit | dpif.dhit);
    end

    //============= datomic (for RMW - Synchronization) ============
    always_comb begin
        dpif.datomic = 0;
        if(opcode_t'(exmem.instr_out[31:26]) == LL) begin
            dpif.datomic = 1;
        end
        else if(opcode_t'(exmem.instr_out[31:26]) == SC) begin
            dpif.datomic = 1;
        end
    end
    
    //=====================IF_ID register assignment=========================
    always_comb begin
        ifid.npc_in = pcif.next_pc;
        ifid.pc_in = pcif.pc;
        ifid.instr_in = dpif.imemload;
        ifid.ihit = dpif.ihit;
        ifid.dhit = dpif.dhit;
        ifid.stall = huif.stall_ifid;
        ifid.flush = huif.flush_ifid;
        ifid.mem_op = huif.mem_op;
        ifid.flush_branch = huif.flush_branch_ifid;
        ifid.opcode_in = opcode_t'(dpif.imemload[31:26]);
    end
    //=======================================================================


    //=====================ID_EX register assignment============================
    always_comb begin
        idex.flush = huif.flush_idex;
        idex.stall = huif.stall_idex;
        idex.mem_op = huif.mem_op;
        idex.flush_branch = huif.flush_branch_idex;
        idex.ihit = dpif.ihit;
        idex.dhit = dpif.dhit;
        idex.pc_in = ifid.pc_out;
        idex.npc_in = ifid.npc_out;
        idex.instr_in = ifid.instr_out;
        idex.rdat1_in = rfif.rdat1;
        idex.rdat2_in = rfif.rdat2;
        idex.rs_in = cuif.rs;
        idex.rd_in = cuif.rd;
        idex.rt_in = cuif.rt;
        idex.imm16_in = cuif.imm_val;
        //idex.imm32_in = aluif.portB;        (IMM32_IN is assigned in always_comb block based on control unit ExtOp)
        idex.halt_in = cuif.halt;
        idex.ALUSrc_in = cuif.ALUSrc;
        idex.JAL_in = cuif.JAL;
        idex.BEQ_in = cuif.BEQ;
        idex.BNE_in = cuif.BNE;
        idex.RegWr_in = cuif.RegWr;
        idex.PCSrc_in = cuif.PCSrc;
        idex.ExtOp_in = cuif.ExtOp;
        idex.RegDst_in = cuif.RegDst;
        idex.MemtoReg_in = cuif.MemtoReg;
        idex.MemWr_in = cuif.dWEN;
        idex.iREN_in = cuif.iREN;
        idex.dREN_in = cuif.dREN;
        idex.ALUOP_in = cuif.ALUOP;
        idex.opcode_in = ifid.opcode_out;
    end
    //===========================================================================


    //===================EX_MEM register assignment=======================
    always_comb begin
        exmem.flush = huif.flush_exmem;
        exmem.stall = huif.stall_exmem;
        exmem.mem_op = huif.mem_op;
        exmem.ihit = dpif.ihit;
        exmem.dhit = dpif.dhit;
        exmem.npc_in = idex.npc_out;
        exmem.pc_in = idex.pc_out;
        exmem.instr_in = idex.instr_out;
        exmem.ALUOut_in = aluif.out_port;
        exmem.rdat1_in = idex.rdat1_out;
        exmem.rdat2_in = dmemstore;
        exmem.rs_in = idex.rs_out;
        exmem.rd_in = idex.rd_out;
        exmem.rt_in = idex.rt_out;
        exmem.imm16_in = idex.imm16_out;
        exmem.imm32_in = idex.imm32_out;
        exmem.halt_in = idex.halt_out;
        exmem.ALUSrc_in = idex.ALUSrc_out;
        exmem.JAL_in = idex.JAL_out;
        exmem.BEQ_in = idex.BEQ_out;
        exmem.BNE_in = idex.BNE_out;
        exmem.RegWr_in = idex.RegWr_out;
        exmem.PCSrc_in = idex.PCSrc_out;
        exmem.ExtOp_in = idex.ExtOp_out;
        exmem.RegDst_in = idex.RegDst_out;
        exmem.MemtoReg_in = idex.MemtoReg_out;
        exmem.MemWr_in = idex.MemWr_out;
        exmem.iREN_in = idex.iREN_out;
        exmem.dREN_in = idex.dREN_out;
        exmem.ALUOP_in = idex.ALUOP_out;
        exmem.zero_in = aluif.zero;
        exmem.opcode_in = idex.opcode_out;
        exmem.br_nottaken_in = br_nottaken;
        exmem.jraddr_forward_in = aluif.portA;       //passing the register value for jr instruction incase need of forwarding
    end
    //===================================================================


    //===================MEM_WB register assignment===================
    always_comb begin
        memwb.flush = huif.flush_memwb;
        memwb.stall = huif.stall_memwb;
        memwb.mem_op = huif.mem_op;
        memwb.ihit = dpif.ihit;
        memwb.dhit = dpif.dhit;
        memwb.npc_in = exmem.npc_out;
        memwb.pc_in = exmem.pc_out;
        memwb.instr_in = exmem.instr_out;
        memwb.ALUOut_in = exmem.ALUOut_out;
        memwb.rdat1_in = exmem.rdat1_out;
        memwb.rdat2_in = exmem.rdat2_out;
        memwb.dmemload_in = dpif.dmemload;
        memwb.rs_in = exmem.rs_out;
        memwb.rd_in = exmem.rd_out;
        memwb.rt_in = exmem.rt_out;
        memwb.imm16_in = exmem.imm16_out;
        memwb.imm32_in = exmem.imm32_out;
        memwb.halt_in = exmem.halt_out;
        memwb.ALUSrc_in = exmem.ALUSrc_out;
        memwb.JAL_in = exmem.JAL_out;
        memwb.BEQ_in = exmem.BEQ_out;
        memwb.RegWr_in = exmem.RegWr_out;
        memwb.PCSrc_in = exmem.PCSrc_out;
        memwb.ExtOp_in = exmem.ExtOp_out;
        memwb.RegDst_in = exmem.RegDst_out;
        memwb.MemtoReg_in = exmem.MemtoReg_out;
        memwb.MemWr_in = exmem.MemWr_out;
        memwb.iREN_in = exmem.iREN_out;
        memwb.ALUOP_in = exmem.ALUOP_out;
        memwb.opcode_in = exmem.opcode_out;
        memwb.funct_in = funct_t'(exmem.instr_out[5:0]);
        memwb.branchaddr_in = branchaddr;
    end
    //================================================================


    //====================BRANCH and JUMP(begin)============================================
    //calculating the br_not taken flag based on values in the exmem stage
    always_comb begin
        br_nottaken = 1'b0;
        if(((idex.BEQ_out && ~aluif.zero) || (idex.BNE_out && aluif.zero))) begin
            br_nottaken = 1'b1;
        end
    end

    always_comb begin //COMBINATIONAL BLOCK FOR BRANCH AND JUMP
        //logic for the next pc value
        jaddr = {exmem.npc_out[31:28],exmem.instr_out[25:0],2'b00};
        //jraddr = exmem.rdat1_out;       //havent changed for fowarding
        jraddr = exmem.jraddr_forward_out;    //changed for forwarding (check exmem assignment block for value of jraddr_forward_in)

        pcif.pc_comb = pcif.next_pc;
        branchaddr = '0;
        if(exmem.br_nottaken_out == 1'b1) begin
            //if branch is not taken
            pcif.pc_comb = exmem.npc_out;
            branchaddr = exmem.npc_out;
        end
        else begin
            //if branch is taken or it is jr,or j or jal instruction    ( NOTE! HAVE TO CHANGE PCSRC signal)
            if(exmem.PCSrc_out == 2'd2) begin
                pcif.pc_comb = jaddr;
                branchaddr = jaddr;
            end
            else if(exmem.PCSrc_out == 2'd3) begin
                pcif.pc_comb = jraddr;
                branchaddr = jraddr;
            end
            else if(PCSrc_br == 1'd1) begin
                if(beq == 1) begin
                    pcif.pc_comb = beqaddr;
                    branchaddr = beqaddr;
                end
                else begin
                    pcif.pc_comb = bneaddr;
                    branchaddr = bneaddr;
                end
            end
            else if(exmem.PCSrc_out == 2'd0) begin
                pcif.pc_comb = pcif.next_pc;
                branchaddr = pcif.next_pc;
            end
        end

        //logic for calculating the extended value
        if(cuif.ExtOp == 2'd0) begin
            idex.imm32_in = zero_extend;
        end
        else if(cuif.ExtOp == 2'd1) begin
            idex.imm32_in = sign_extend;
        end
        else begin
            idex.imm32_in = lui_extend;
        end
    end

    //logic to sign extend the branch addr for always taken branch design
    always_comb begin
        if(dpif.imemload[15] == 1) begin
            branchaddr_extend = {16'hFFFF,dpif.imemload[15:0]};
        end
        else begin
            branchaddr_extend = {16'h0,dpif.imemload[15:0]};
        end
    end

    always_comb begin
        //block before IFID register to get next pc value for branch always taken design
        PCSrc_br = '0;
        beq = '0;
        beqaddr = '0;
        bneaddr = '0;
        branch_op = opcode_t'(dpif.imemload[31:26]);

        if(branch_op == BEQ) begin
            PCSrc_br = 1'd1;
            beq = 1'b1;
            beqaddr = (pcif.next_pc) + (branchaddr_extend << 2);   //address for beq
        end
        else if(branch_op == BNE) begin
            PCSrc_br = 1'd1;
            beq = 1'b0;
            bneaddr = (pcif.next_pc) + (branchaddr_extend << 2);     //address for bne
        end

    end
    //================================================================================================

    //====================Extend Operations====================
    assign sign_extend = cuif.imm_val[15] ? {16'hFFFF,cuif.imm_val} : {16'h0000,cuif.imm_val};
    assign zero_extend = {16'h0000,cuif.imm_val};
    assign lui_extend = {cuif.imm_val,16'h0000};
    //========================================================

    //==================Datapath Cache interface=============
    assign dpif.imemaddr = pcif.pc;
    assign dpif.dmemWEN = exmem.MemWr_out;
    assign dpif.imemREN = 1'b1;
    //assign dpif.dmemREN = exmem.MemtoReg_out;
    assign dpif.dmemREN = exmem.dREN_out;   //actual signal for Load, not MemtoReg. Because SC also needs to return a value to rt
    assign dpif.dmemaddr = exmem.ALUOut_out;
    assign dpif.dmemstore = exmem.rdat2_out;
    //=======================================================


    //=================Register File Interface==================
    assign rfif.rsel1 = cuif.rs;
    assign rfif.rsel2 = cuif.rt;
    //=========================================================


    //=================Control Unit Interface=================
    assign cuif.dhit = dpif.dhit;
    assign cuif.ihit = dpif.ihit;
    assign cuif.instr = ifid.instr_out;
    //assign cuif.stall = huif.stall;
    //========================================================


    //=======ALU interface====================================
    assign aluif.ALUOP = idex.ALUOP_out;


    //=========Program Counter Interface======================
    //assign pcif.pc_incr = dpif.ihit && ~huif.stall_ifid;         // have to incoorporate condition for huif.mem_op && ihit && dhit
    always_comb begin
        pcif.pc_incr = 1'b0;
        if(huif.mem_op) begin
            if(dpif.ihit && dpif.dhit && ~huif.stall_ifid) begin
                pcif.pc_incr = 1'b1;
            end
        end
        else if(dpif.ihit && ~huif.stall_ifid) begin
            pcif.pc_incr = 1'b1;
        end
    end
    //==================Register File Assignment========================
    assign rfif.WEN = memwb.RegWr_out;

    //logic for rfif.wdat
    always_comb begin
        if(memwb.MemtoReg_out == 1) begin
            rfif.wdat = memwb.dmemload_out;
        end
        else if(memwb.JAL_out == 1'b1) begin
            rfif.wdat = memwb.npc_out;
        end
        else begin
            rfif.wdat = memwb.ALUOut_out;
        end
    end

    //logic for rfif.wsel
    always_comb begin
        rfif.wsel = 5'd31; 
        if(memwb.RegDst_out == 2'd0) begin
            rfif.wsel = memwb.rd_out;
        end
        else if(memwb.RegDst_out == 2'd1) begin
            rfif.wsel = memwb.rt_out;
        end
    end
    //==================================================================


    //=================Forwarding unit assignment======================
    always_comb begin
        fuif.RegWr_memwb = memwb.RegWr_out;
        fuif.RegDst_memwb = memwb.RegDst_out;
        fuif.RegDst_exmem = exmem.RegDst_out;
        fuif.RegWr_exmem = exmem.RegWr_out;
        fuif.rt_memwb = memwb.rt_out;
        fuif.rd_memwb = memwb.rd_out;
        fuif.rt_exmem = exmem.rt_out;
        fuif.rd_exmem = exmem.rd_out;
        fuif.rs_idex = idex.rs_out;
        fuif.rt_idex = idex.rt_out;
    end
    //================================================================


    //=====================ALU port assignment=====================
    always_comb begin
        if(fuif.forwardA == 2'd0) begin
            aluif.portA = idex.rdat1_out;
        end
        else if(fuif.forwardA == 2'd1) begin
            aluif.portA = exmem.ALUOut_out;
        end
        else begin
            aluif.portA = rfif.wdat;  //Check to see if correct
        end

        //logic for calculating intermediate (MUX before MUX_forwardB)
        if(fuif.forwardB == 2'd0) begin
            forwardB_input1 = idex.rdat2_out;
        end
        else if(fuif.forwardB == 2'd1) begin
            forwardB_input1 = exmem.ALUOut_out;
        end
        else begin
            forwardB_input1 = rfif.wdat;  //Check to see if correct
        end

        if(idex.ALUSrc_out == 1'b0) begin
            aluif.portB = forwardB_input1;
        end
        else begin
            aluif.portB = idex.imm32_out;
        end
    end
    //===============================================================


    //===================MUX to determine dmemstore in idex stage, sw raw hazard=================
    always_comb begin 
        dmemstore = '0;
        if(fuif.forwardB == 2'd0) begin
            dmemstore = idex.rdat2_out;
        end
        else if(fuif.forwardB == 2'd1) begin
            dmemstore = exmem.ALUOut_out;
        end
        else begin
            dmemstore = rfif.wdat;  //Check to see if correct
        end
    end
    //============================================================================================


    //==================Hazard unit assignment=====================
    always_comb begin
        huif.rt_idex = idex.rt_out;
        huif.equal_exmem = exmem.zero_out;
        huif.BEQ_exmem = exmem.BEQ_out;
        huif.BNE_exmem = exmem.BNE_out;
        huif.instr = ifid.instr_out;
        huif.dhit = dpif.dhit;
        huif.MemtoReg_idex = idex.MemtoReg_out;
        huif.MemWr_idex = idex.MemWr_out;
        //huif.MemtoReg_exmem = exmem.MemtoReg_out;
        huif.MemtoReg_exmem = exmem.dREN_out;  //actual signal for Load not MemtoReg. Because SC also needs to return a value to rt
        huif.MemWr_exmem = exmem.MemWr_out;
        huif.RegDst_exmem = exmem.RegDst_out;
        huif.rs_ifid = cuif.rs;
        huif.rt_ifid = cuif.rt;
        huif.rd_exmem = exmem.rd_out;
        huif.rt_exmem = exmem.rt_out;
        huif.RegWr_exmem = exmem.RegWr_out;
        huif.ihit = dpif.ihit;
        huif.PCSrc_exmem = exmem.PCSrc_out;
        huif.PCSrc_idex = idex.PCSrc_out;
        huif.br_nottaken = br_nottaken;
        huif.halt = exmem.halt_out;
    end
    //==============================================================
endmodule