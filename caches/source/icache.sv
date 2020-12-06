// Design icache connecting the datapath cache interface and caches (to memory) interface

`include "caches_if.vh"
`include "cpu_types_pkg.vh"

module icache(input logic CLK,nRST,
        datapath_cache_if dcif, 
        caches_if cif);

    import cpu_types_pkg::*;

    //structure for block in icache
    typedef struct packed{
        word_t data;
        logic[25:0] tag;
        logic valid;
    } icache_type;

    //declaration of icache hash table containing 16 blocks
    icache_type icache_table [15:0];

    //local variables
    logic [25:0] tag;
    logic [3:0] index;
    logic hit;
    logic miss;
    integer i;    //variable for for loop iteration


    //assignment of tag,index from pc value from datapath_cache
    assign tag = dcif.imemaddr[31:6];
    assign index = dcif.imemaddr[5:2];

    //flip flop to update the icache hastable
    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin 
            for(i = 0; i < 16; ++i) begin
                icache_table[i].data <= '0;
                icache_table[i].tag <= '0;
                icache_table[i].valid <= 0;
            end
        end

        else begin
            if(cif.iwait == 1'b0) begin    //not sure when to read into icache
                icache_table[index].data <= cif.iload;  // need to check what to assign here
                icache_table[index].tag <= tag;
                icache_table[index].valid <= 1;
            end
        end

    end

    //logic for ihit
    always_comb begin
        dcif.ihit = '0;
        hit = '0;
        dcif.imemload = '0;
        cif.iREN = '0;
        cif.iaddr = '0;
        miss = 0;


        hit = ~cif.iwait;

        if(dcif.halt == 1'b1) begin
            //if halt, then reset everything
            dcif.ihit = '0;
            dcif.imemload = '0;
            cif.iREN = '0;
            cif.iaddr = '0;
        end

        else if(dcif.imemREN) begin
            if(tag == icache_table[index].tag && icache_table[index].valid) begin
                //a hit for reading icache
                dcif.ihit = 1'b1;
                dcif.imemload = icache_table[index].data;
            end
            else begin
                //a miss for reading icache
                cif.iREN = 1'b1;
                cif.iaddr = dcif.imemaddr;
                miss = 1;
            end
        end     
    end

endmodule