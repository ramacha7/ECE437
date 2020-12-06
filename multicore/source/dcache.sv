//Interface
`include "caches_if.vh"
`include "cpu_types_pkg.vh"

module dcache(input logic CLK, nRST, 
            datapath_cache_if dcif,
            caches_if cif);

    import cpu_types_pkg::*;
    typedef struct packed{
        //Structure for a dcache frame
        logic [25:0] tag;
        word_t [1:0] data;
        logic valid, dirty;
    }dcache_frame;

    typedef struct packed{
        //Structure for a dcache set
        dcache_frame [1:0] frames;
        logic lru;
    }dcache_set;

    typedef enum logic [3:0] {IDLE, WB1, WB2, LD1, LD2, DIRTY, FLUSH1, FLUSH2, STORE_CNT,HALT, SNOOP, SEND1, SEND2, CHECK} StateType; 
    logic [25:0]    addrTag, snoopTag;
    logic [2:0]     addrIndex, snoopIndex, index;
    logic [3:0]     next_flush_set, flush_set;
    logic [31:0]    flush_addr,next_flush_addr;    //latching the address to reduce critical path.
    logic           addrOffset, snoopOffset, curr_lru, next_curr_lru, next_flush_frame, flush_frame, snoopFrame, nextSnoopFrame, nextWB;
    word_t          cnt, next_cnt; 
    word_t          link_register,next_link_register;  //signals for RMW - LL and SC - (synchronization)
    logic           link_valid, next_link_valid;        //signals to denote if link register is valid
    logic           success; //signal to denote if the test was successful. Returned to processor to store in reg rt.
    integer         i, j;

    StateType       currState, nextState;

    dcache_set      dcache_table[7:0];
    dcache_set      set;

    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            cnt <= '0;
            curr_lru <= '0;
            currState <= IDLE;
            flush_set <= '0;
            flush_frame <= '0;
            snoopFrame <= '0;
            flush_addr <= '0;
            link_register <= '0;
            link_valid <= '0;
            for(i = 0; i < 8; i++) begin
                dcache_table[i].lru <= '0;
                for(j = 0; j < 2; j++) begin
                    dcache_table[i].frames[j].tag <= '0;
                    dcache_table[i].frames[j].data <= '0;
                    dcache_table[i].frames[j].valid <= '0;
                    dcache_table[i].frames[j].dirty <= '0;
                end
            end
        end
        else begin
            cnt <= next_cnt;
            curr_lru <= next_curr_lru;
            currState <= nextState;
            flush_set <= next_flush_set;
            flush_frame <= next_flush_frame;
            flush_addr <= next_flush_addr;
            link_register <= next_link_register;
            link_valid <= next_link_valid;
            snoopFrame <= nextSnoopFrame;
            dcache_table[addrIndex].lru <= set.lru;
            for(j = 0; j < 2; j++) begin
                dcache_table[index].frames[j].tag <= set.frames[j].tag;
                dcache_table[index].frames[j].data <= set.frames[j].data;
                dcache_table[index].frames[j].valid <= set.frames[j].valid;
                dcache_table[index].frames[j].dirty <= set.frames[j].dirty;
            end
        end
    end

    always_comb begin
        addrTag = dcif.dmemaddr[31:6];
        addrIndex = dcif.dmemaddr[5:3];
        addrOffset = dcif.dmemaddr[2];
        snoopTag = cif.ccsnoopaddr[31:6];
        snoopIndex = cif.ccsnoopaddr[5:3];
        snoopOffset = cif.ccsnoopaddr[2];
        success = '0;
        index = cif.ccwait ? snoopIndex : dcif.halt ? flush_set : addrIndex;
        nextState = currState;
        dcif.dhit = '0;
        dcif.dmemload = '0;
        dcif.flushed = '0;
        cif.dREN = '0;
        cif.dWEN = '0;
        cif.daddr = '0;
        cif.dstore = '0;
        cif.ccwrite = '0;
        cif.cctrans = '0;
        cif.ccflushed = '0;
        next_curr_lru = curr_lru;
        next_flush_set = flush_set;
        next_flush_frame = flush_frame;
        next_flush_addr = flush_addr;
        next_cnt = cnt;
        nextSnoopFrame = snoopFrame;
        next_link_register = link_register;
        next_link_valid = link_valid;
        set.lru = dcache_table[addrIndex].lru;
        set.frames[0].tag = dcache_table[index].frames[0].tag;
        set.frames[0].data = dcache_table[index].frames[0].data;
        set.frames[0].valid = dcache_table[index].frames[0].valid;
        set.frames[0].dirty = dcache_table[index].frames[0].dirty;
        set.frames[1].tag = dcache_table[index].frames[1].tag;
        set.frames[1].data = dcache_table[index].frames[1].data;
        set.frames[1].valid = dcache_table[index].frames[1].valid;
        set.frames[1].dirty = dcache_table[index].frames[1].dirty;
        
        casez(currState)
            IDLE: begin
                if(cif.ccwait) begin
                    nextState = SNOOP;
                end
                else if(dcif.dmemREN) begin
                    //Read request
                    if(dcif.datomic) begin          //LL instruction (still do normal load after setting link register related signals)
                        next_link_register = dcif.dmemaddr;
                        next_link_valid = '1;
                    end

                    if(dcache_table[addrIndex].frames[0].tag == addrTag && dcache_table[addrIndex].frames[0].valid) begin
                        //Cache hit on left side, so we load memory
                        dcif.dhit = 1;
                        nextState = IDLE;
                        next_cnt = cnt + 1;
                        set.lru = '1;
                        dcif.dmemload = dcache_table[addrIndex].frames[0].data[addrOffset];
                    end
                    else if(dcache_table[addrIndex].frames[1].tag == addrTag && dcache_table[addrIndex].frames[1].valid) begin
                        //Cache hit on right side, so we load memory
                        dcif.dhit = 1;
                        nextState = IDLE;
                        next_cnt = cnt + 1;
                        set.lru = '0;
                        dcif.dmemload = dcache_table[addrIndex].frames[1].data[addrOffset];
                    end
                    else begin
                        //Cache miss
                        dcif.dhit = '0;
                        next_cnt = cnt - 1;
                        next_curr_lru = dcache_table[addrIndex].lru; //LRU value I want to use to replace in memory
                        set.lru = ~dcache_table[addrIndex].lru; //The updated LRU value(next lru)
                        if(dcache_table[addrIndex].frames[dcache_table[addrIndex].lru].dirty) begin 
                            nextState = WB1;
                        end
                        else begin
                            nextState = LD1;
                        end
                    end
                end 
                else if(dcif.dmemWEN) begin
                    //Write request
                    if(dcif.datomic) begin        //(RMW) - SC instruction
                        success = (dcif.dmemaddr == link_register) ? link_valid : '0;
                        if(success) begin        // if success, then send back a 1 to processor and do store like normal
                            dcif.dmemload = 32'd1;
                            // next_link_register = '0;
                            // next_link_valid = '0;
                            if(dcache_table[addrIndex].frames[0].tag == addrTag && dcache_table[addrIndex].frames[0].valid && dcache_table[addrIndex].frames[0].dirty) begin
                                //Cache hit on left side, so we load memory
                                dcif.dhit = 1;
                                nextState = IDLE;
                                next_cnt = cnt + 1;
                                set.lru = '1;
                                set.frames[0].dirty = '1;
                                set.frames[0].data[addrOffset] = dcif.dmemstore;
                                next_link_register = '0;
                                next_link_valid = '0;
                            end 
                            else if(dcache_table[addrIndex].frames[1].tag == addrTag && dcache_table[addrIndex].frames[1].valid && dcache_table[addrIndex].frames[1].dirty) begin
                                //Cache hit on right side, so we load memory
                                dcif.dhit = 1;
                                nextState = IDLE;
                                next_cnt = cnt + 1;
                                set.lru = '0;
                                set.frames[1].dirty = '1;
                                set.frames[1].data[addrOffset] = dcif.dmemstore;
                                next_link_register = '0;
                                next_link_valid = '0;
                            end
                            else begin
                                //Cache miss
                                dcif.dhit = '0;
                                next_cnt = cnt - 1;

                                //If statement is used to determine the state of the cache block
                                //if the block is in shared state we want to replace that specific block which 
                                //is why I hardcode either a 1 or 0, so we know the shared block to replace
                                //if the the block is in the invalid state then we can just do the regular LRU operation

                                if(dcache_table[addrIndex].frames[0].tag == addrTag && dcache_table[addrIndex].frames[0].valid) begin
                                    next_curr_lru = '0; //LRU value I want to use to replace in memory
                                end
                                else if(dcache_table[addrIndex].frames[1].tag == addrTag && dcache_table[addrIndex].frames[1].valid) begin
                                    next_curr_lru = '1; //LRU value I want to use to replace in memory
                                end
                                else begin
                                    next_curr_lru = dcache_table[addrIndex].lru; //LRU value I want to use to replace in memory
                                    set.lru = ~dcache_table[addrIndex].lru; //The updated LRU value
                                end

                                if(dcache_table[addrIndex].frames[dcache_table[addrIndex].lru].dirty) begin 
                                    nextState = WB1;
                                end
                                else begin
                                    nextState = LD1;
                                end
                            end
                        end
                        
                        else begin     // if test is not a success, then no store is completed and send back 0 to processor and dhit
                            dcif.dmemload = 32'd0;
                            dcif.dhit = '1;
                        end
                    end

                    else begin  // normal store
                        
                        if(dcif.dmemaddr == link_register) begin      // if there is a matching coherent store with the link reg, then invalidate the register
                            next_link_register = '0;
                            next_link_valid = '0;
                        end

                        if(dcache_table[addrIndex].frames[0].tag == addrTag && dcache_table[addrIndex].frames[0].valid && dcache_table[addrIndex].frames[0].dirty) begin
                            //Cache hit on left side, so we load memory
                            dcif.dhit = 1;
                            nextState = IDLE;
                            next_cnt = cnt + 1;
                            set.lru = '1;
                            set.frames[0].dirty = '1;
                            set.frames[0].data[addrOffset] = dcif.dmemstore;
                        end 
                        else if(dcache_table[addrIndex].frames[1].tag == addrTag && dcache_table[addrIndex].frames[1].valid && dcache_table[addrIndex].frames[1].dirty) begin
                            //Cache hit on right side, so we load memory
                            dcif.dhit = 1;
                            nextState = IDLE;
                            next_cnt = cnt + 1;
                            set.lru = '0;
                            set.frames[1].dirty = '1;
                            set.frames[1].data[addrOffset] = dcif.dmemstore;
                        end
                        else begin
                            //Cache miss
                            dcif.dhit = '0;
                            next_cnt = cnt - 1;

                            //If statement is used to determine the state of the cache block
                            //if the block is in shared state we want to replace that specific block which 
                            //is why I hardcode either a 1 or 0, so we know the shared block to replace
                            //if the the block is in the invalid state then we can just do the regular LRU operation

                            if(dcache_table[addrIndex].frames[0].tag == addrTag && dcache_table[addrIndex].frames[0].valid) begin
                                next_curr_lru = '0; //LRU value I want to use to replace in memory
                            end
                            else if(dcache_table[addrIndex].frames[1].tag == addrTag && dcache_table[addrIndex].frames[1].valid) begin
                                next_curr_lru = '1; //LRU value I want to use to replace in memory
                            end
                            else begin
                                next_curr_lru = dcache_table[addrIndex].lru; //LRU value I want to use to replace in memory
                                set.lru = ~dcache_table[addrIndex].lru; //The updated LRU value
                            end

                            if(dcache_table[addrIndex].frames[dcache_table[addrIndex].lru].dirty) begin 
                                nextState = WB1;
                            end
                            else begin
                                nextState = LD1;
                            end
                        end
                    end
                end
                else if(dcif.halt) begin
                    nextState = DIRTY;
                end
            end

            SNOOP: begin
                cif.cctrans = '1;
                if(!cif.ccwait) begin
                    nextState = IDLE;
                end
                else begin
                    if(snoopTag == dcache_table[snoopIndex].frames[0].tag && dcache_table[snoopIndex].frames[0].valid) begin
                        if(dcache_table[snoopIndex].frames[0].dirty) begin
                            nextState = SEND1;
                            nextSnoopFrame = '0;
                            cif.ccwrite = '1;
                            if(dcif.dmemREN) begin //M--> S, deasserting dirty bit
                                set.frames[0].dirty = '0;
                            end 
                        end
                        
                        if(cif.ccinv) begin //Invalidation for M-->I or S-->I path
                            if((cif.ccsnoopaddr == link_register) && (link_valid)) begin
                                next_link_register = '0;
                                next_link_valid = '0;
                            end
                            set.frames[0].valid = '0;
                            set.frames[0].dirty = '0;
                        end
                    end
                    else if(snoopTag == dcache_table[snoopIndex].frames[1].tag && dcache_table[snoopIndex].frames[1].valid) begin
                        if(dcache_table[snoopIndex].frames[1].dirty) begin
                            nextState = SEND1;
                            nextSnoopFrame = '1;
                            cif.ccwrite = '1;
                            if(dcif.dmemREN) begin //M--> S, deasserting dirty bit
                                set.frames[1].dirty = '0;
                            end
                        end

                        if(cif.ccinv) begin //Invalidation for M-->I or S-->I path
                            if((cif.ccsnoopaddr == link_register) && (link_valid)) begin
                                next_link_register = '0;
                                next_link_valid = '0;
                            end
                            set.frames[1].valid = '0;
                            set.frames[1].dirty = '0;
                        end
                    end 
                end
            end

            SEND1: begin
                cif.dWEN = '1;
                cif.daddr = cif.ccsnoopaddr;
                cif.dstore = dcache_table[snoopIndex].frames[snoopFrame].data[snoopOffset];
                if(!cif.dwait) begin 
                    nextState = SEND2;
                end
            end

            SEND2: begin
                cif.dWEN = '1;
                cif.daddr = cif.ccsnoopaddr;
                cif.dstore = dcache_table[snoopIndex].frames[snoopFrame].data[snoopOffset];
                set.frames[snoopFrame].dirty = '0;

                if(!cif.dwait) begin 
                    nextState = IDLE;
                end
            end
            
            WB1: begin
                //Writeback the first block
                cif.dWEN = '1;
                cif.dstore = dcache_table[addrIndex].frames[curr_lru].data[addrOffset];  
                cif.daddr = {dcache_table[addrIndex].frames[curr_lru].tag, addrIndex, addrOffset, 2'b00};
                if(!cif.dwait) begin 
                    set.frames[curr_lru].dirty = '0;
                    nextState = WB2;
                end
            end
            
            WB2: begin
                //Writeback the second block
                cif.dWEN = '1;
                cif.dstore = dcache_table[addrIndex].frames[curr_lru].data[~addrOffset];
                cif.daddr = {dcache_table[addrIndex].frames[curr_lru].tag, addrIndex, ~addrOffset, 2'b00};
                if(!cif.dwait) begin
                    nextState = CHECK;
                end
            end

            CHECK: begin
                //State between WB2 and LD1 to determine if dirty bit has been deasserted for 
                //specific cache block
                if(!dcache_table[addrIndex].frames[curr_lru].dirty) begin
                    nextState = LD1;
                end
            end
            
            LD1: begin
                //Load the first block from memory
                if(!cif.ccwait) begin
                    cif.dREN = '1;
                    cif.cctrans = '1;
                    cif.daddr = {addrTag, addrIndex, addrOffset, 2'b00};
                    if(dcif.dmemWEN) begin
                        cif.ccwrite = '1; //Generates BusRdx
                        set.frames[curr_lru].dirty = '1; //Sets the dirty bit on the S-->M and I-->M path, can only write to block in modified state
                    end

                    if(!cif.dwait) begin
                        set.frames[curr_lru].tag = addrTag;
                        set.frames[curr_lru].data[addrOffset] = cif.dload;
                        nextState = LD2;
                    end
                end
                else begin
                    nextState = SNOOP;
                end
            end
            
            LD2: begin
                //Load the second block from memory
                cif.dREN = '1;
                cif.daddr = {addrTag, addrIndex, ~addrOffset, 2'b00};
                if(!cif.dwait) begin
                    set.frames[curr_lru].valid = '1;
                    set.frames[curr_lru].data[~addrOffset] = cif.dload;
                    nextState = IDLE;
                end
            end
            
            DIRTY: begin
                //Check if block is dirty
                if(cif.ccwait) begin
                    nextState = SNOOP;
                end
                else if(dcache_table[flush_set].frames[flush_frame].dirty && dcache_table[flush_set].frames[flush_frame].valid && flush_set < 4'd8) begin
                    nextState = FLUSH1;
                    next_flush_addr = {dcache_table[flush_set].frames[flush_frame].tag, flush_set[2:0], 1'b0, 2'b00};
                end
                else if(flush_set < 4'd8) begin
                    if(flush_frame == 1'b1) begin
                        next_flush_set = flush_set + 1;
                    end
                    next_flush_frame = ~flush_frame;
                end
                else if(flush_set == 4'd8) begin
                   nextState = HALT;
                end
            end 
            
            FLUSH1: begin
                if(!cif.ccwait) begin
                    //Flush the first block
                    cif.dWEN = '1;
                    //cif.daddr = {dcache_table[flush_set].frames[flush_frame].tag, flush_set[2:0], 1'b0, 2'b00};
                    cif.daddr = flush_addr;
                    cif.dstore = dcache_table[flush_set].frames[flush_frame].data[0];
                    if(!cif.dwait) begin
                        nextState = FLUSH2;
                        next_flush_addr = {dcache_table[flush_set].frames[flush_frame].tag, flush_set[2:0], 1'b1, 2'b00};
                    end
                end
                else begin
                    nextState = SNOOP;
                end
            end
            
            FLUSH2: begin
                if(!cif.ccwait) begin
                    //Flush the second block
                    cif.dWEN = '1;
                    cif.daddr = flush_addr;
                    //cif.daddr = {dcache_table[flush_set].frames[flush_frame].tag, flush_set[2:0], 1'b1, 2'b00};
                    cif.dstore = dcache_table[flush_set].frames[flush_frame].data[1];
                    if(!cif.dwait) begin
                        set.frames[flush_frame].dirty = '0;
                        next_flush_frame = ~flush_frame;
                        nextState = DIRTY;
                        if(flush_frame == 1'b1) begin
                            next_flush_set = flush_set + 1; 
                        end
                    end
                end
                else begin
                    nextState = SNOOP;
                end
            end

            STORE_CNT: begin
                //store cnt of hit
                cif.dWEN = '1;
                cif.daddr = 32'h00003100;
                cif.dstore = cnt;
                if(!cif.dwait) begin
                    nextState = HALT;
                end
            end

            HALT: begin
                //flushed all values in dcache, so halt
                dcif.flushed = 1'b1;
                cif.ccflushed = '1;
            end
        endcase
    end

endmodule