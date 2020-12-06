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

    typedef enum logic [3:0] {IDLE, WB1, WB2, LD1, LD2, DIRTY, FLUSH1, FLUSH2, STORE_CNT,HALT} StateType; 
    logic [25:0]    addrTag;
    logic [2:0]     addrIndex;
    logic [3:0]     next_flush_set, flush_set;
    logic           addrOffset, lru, next_lru, next_flush_frame, flush_frame;
    word_t          cnt, next_cnt; 
    integer         i, j;

    StateType       currState, nextState;

    dcache_set      dcache_table[7:0];
    dcache_set      set;

    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            cnt <= '0;
            lru <= '0;
            currState <= IDLE;
            flush_set <= '0;
            flush_frame <= '0;
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
            lru <= next_lru;
            currState <= nextState;
            flush_set <= next_flush_set;
            flush_frame <= next_flush_frame;
            dcache_table[addrIndex].lru <= set.lru;
            for(j = 0; j < 2; j++) begin
                dcache_table[addrIndex].frames[j].tag <= set.frames[j].tag;
                dcache_table[addrIndex].frames[j].data <= set.frames[j].data;
                dcache_table[addrIndex].frames[j].valid <= set.frames[j].valid;
                dcache_table[addrIndex].frames[j].dirty <= set.frames[j].dirty;
            end
        end
    end

    always_comb begin
        addrTag = dcif.dmemaddr[31:6];
        addrIndex = dcif.dmemaddr[5:3];
        addrOffset = dcif.dmemaddr[2];
        nextState = currState;
        dcif.dhit = '0;
        dcif.dmemload = '0;
        dcif.flushed = '0;
        cif.dREN = '0;
        cif.dWEN = '0;
        cif.daddr = '0;
        cif.dstore = '0;
        next_lru = lru;
        next_flush_set = flush_set;
        next_flush_frame = flush_frame;
        next_cnt = cnt;
        set.lru = dcache_table[addrIndex].lru;
        set.frames[0].tag = dcache_table[addrIndex].frames[0].tag;
        set.frames[0].data = dcache_table[addrIndex].frames[0].data;
        set.frames[0].valid = dcache_table[addrIndex].frames[0].valid;
        set.frames[0].dirty = dcache_table[addrIndex].frames[0].dirty;
        set.frames[1].tag = dcache_table[addrIndex].frames[1].tag;
        set.frames[1].data = dcache_table[addrIndex].frames[1].data;
        set.frames[1].valid = dcache_table[addrIndex].frames[1].valid;
        set.frames[1].dirty = dcache_table[addrIndex].frames[1].dirty;
        
        casez(currState)
            IDLE: begin
                if(dcif.dmemREN) begin
                    //Read request
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
                        next_lru = dcache_table[addrIndex].lru; //LRU value I want to use to replace in memory
                        set.lru = ~dcache_table[addrIndex].lru; //The updated LRU value
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
                    if(dcache_table[addrIndex].frames[0].tag == addrTag && dcache_table[addrIndex].frames[0].valid) begin
                        //Cache hit on left side, so we load memory
                        dcif.dhit = 1;
                        nextState = IDLE;
                        next_cnt = cnt + 1;
                        set.lru = '1;
                        set.frames[0].dirty = '1;
                        set.frames[0].data[addrOffset] = dcif.dmemstore;

                    end 
                    else if(dcache_table[addrIndex].frames[1].tag == addrTag && dcache_table[addrIndex].frames[1].valid) begin
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
                        next_lru = dcache_table[addrIndex].lru; //LRU value I want to use to replace in memory
                        set.lru = ~dcache_table[addrIndex].lru; //The updated LRU value
                        if(dcache_table[addrIndex].frames[dcache_table[addrIndex].lru].dirty) begin 
                            nextState = WB1;
                        end
                        else begin
                            nextState = LD1;
                        end
                    end
                end
                else if(dcif.halt) begin
                    nextState = DIRTY;
                end
            end
            
            WB1: begin
                //Writeback the first block
                cif.dWEN = '1;
                cif.dstore = dcache_table[addrIndex].frames[lru].data[addrOffset];  
                cif.daddr = {dcache_table[addrIndex].frames[lru].tag, addrIndex, addrOffset, 2'b00};
                if(!cif.dwait) begin 
                    nextState = WB2;
                end
            end
            
            WB2: begin
                //Writeback the second block
                cif.dWEN = '1;
                cif.dstore = dcache_table[addrIndex].frames[lru].data[~addrOffset];
                cif.daddr = {dcache_table[addrIndex].frames[lru].tag, addrIndex, ~addrOffset, 2'b00};
                if(!cif.dwait) begin
                    nextState = LD1;
                end
            end
            
            LD1: begin
                //Load the first block from memory
                cif.dREN = '1;
                cif.daddr = {addrTag, addrIndex, addrOffset, 2'b00};
                if(!cif.dwait) begin
                    set.frames[lru].tag = addrTag;
                    set.frames[lru].data[addrOffset] = cif.dload;
                    nextState = LD2;
                end
            end
            
            LD2: begin
                //Load the second block from memory
                cif.dREN = '1;
                cif.daddr = {addrTag, addrIndex, ~addrOffset, 2'b00};
                if(!cif.dwait) begin
                    set.frames[lru].valid = '1;
                    set.frames[lru].data[~addrOffset] = cif.dload;
                    nextState = IDLE;
                end
            end
            
            DIRTY: begin
                //Check if block is dirty
                if(dcache_table[flush_set].frames[flush_frame].dirty && flush_set < 4'd8) begin
                    nextState = FLUSH1;
                end
                else if(flush_set < 4'd8) begin
                    if(flush_frame == 1'b1) begin
                        next_flush_set = flush_set + 1;
                    end
                    next_flush_frame = ~flush_frame;
                end
                else if(flush_set == 4'd8) begin
                    nextState = STORE_CNT;
                end
            end 
            
            FLUSH1: begin
                //Flush the first block
                cif.dWEN = '1;
                cif.daddr = {dcache_table[flush_set].frames[flush_frame].tag, flush_set[2:0], 1'b0, 2'b00};
                cif.dstore = dcache_table[flush_set].frames[flush_frame].data[0];
                if(!cif.dwait) begin
                    nextState = FLUSH2;
                end
            end
            
            FLUSH2: begin
                //Flush the second block
                cif.dWEN = '1;
                cif.daddr = {dcache_table[flush_set].frames[flush_frame].tag, flush_set[2:0], 1'b1, 2'b00};
                cif.dstore = dcache_table[flush_set].frames[flush_frame].data[1];
                if(!cif.dwait) begin
                    next_flush_frame = ~flush_frame;
                    nextState = DIRTY;
                    if(flush_frame == 1'b1) begin
                        next_flush_set = flush_set + 1; 
                    end
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
            end
        endcase
    end

endmodule