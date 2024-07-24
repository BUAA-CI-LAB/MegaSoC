// Gather data and addr request

module pixel_axi_former(
    input clk,
    input rst_n,

    output empty_o,
    input flush_i,

    input data_valid_i,
    output data_ready_o,
    input [31:0]data_i,

    input addr_valid_i,
    output addr_ready_o,
    input [2:0] len_i,
    input [31:0]addr_i,

    output awvalid_o,
    input  awready_i,
    output[31:0] awaddr_o,
    output[7:0]  awlen_o,

    output wvalid_o,
    input  wready_i,
    output[31:0] wdata_o,
    output wlast_o

);

    // addr fifo
    wire addr_full, addr_empty, addr_pop, addr_push, len_full;
    wire[2:0] len;
    fifo_v3 #(
        .FALL_THROUGH ( 1'b0 ),
        .DEPTH        (  2   ),
        .dtype        ( logic[31 + 3:0] )
    ) addr_fifo (
        .clk_i     ( clk        ),
        .rst_ni    ( rst_n      ),
        .flush_i   ( flush_i    ),
        .testmode_i( 1'b0       ),
        .full_o    ( addr_full  ),
        .empty_o   ( addr_empty ),
        .usage_o   ( /*      */ ),
        .data_i    ( {len_i, addr_i} ),
        .push_i    ( addr_push  ),
        .data_o    ( {len, awaddr_o} ),
        .pop_i     ( addr_pop   )
    );
    assign awvalid_o = !addr_empty && !len_full;
    assign addr_pop = awvalid_o && awready_i;
    assign addr_ready_o = !addr_full;
    assign addr_push = addr_valid_i && addr_ready_o;
    assign awlen_o = {5'd0, len};

    // data fifo
    wire len_pop, len_empty;
    wire data_full, data_empty, data_push, data_pop;
    fifo_v3 #(
        .FALL_THROUGH ( 1'b0 ),
        .DEPTH        ( 16 ),
        .dtype        ( logic[31:0] )
    ) data_fifo (
        .clk_i     ( clk        ),
        .rst_ni    ( rst_n      ),
        .flush_i   ( flush_i    ),
        .testmode_i( 1'b0       ),
        .full_o    ( data_full  ),
        .empty_o   ( data_empty ),
        .usage_o   ( /*      */ ),
        .data_i    ( data_i ),
        .push_i    ( data_push  ),
        .data_o    ( wdata_o ),
        .pop_i     ( data_pop   )
    );
    assign wvalid_o = !data_empty && !len_empty;
    assign data_ready_o = !data_full;
    assign data_push = data_valid_i && data_ready_o;
    assign data_pop = wvalid_o && wready_i;

    // len fifo
    wire [2:0] len_cnt;
    fifo_v3 #(
        .FALL_THROUGH ( 1'b0 ),
        .DEPTH        (  2  ),
        .dtype        ( logic[2:0] )
    ) addr_len_fifo (
        .clk_i     ( clk        ),
        .rst_ni    ( rst_n      ),
        .flush_i   ( flush_i    ),
        .testmode_i( 1'b0       ),
        .full_o    ( len_full  ),
        .empty_o   ( len_empty ),
        .usage_o   ( /**/ ),
        .data_i    ( len ),
        .push_i    ( addr_pop ),
        .data_o    ( len_cnt  ),
        .pop_i     ( len_pop  )
    );
    assign len_pop = data_pop && wlast_o;

    // len counter and wlast generation
    reg  [2:0] cnt_q;
    always_ff @(posedge clk) begin
        if(!rst_n || flush_i) begin
            cnt_q <= '0;
        end else begin
            if(len_pop) begin
                cnt_q <= '0;
            end else begin
                if(data_pop) begin
                    cnt_q <= cnt_q + 1'd1;
                end
            end
        end
    end
    assign wlast_o = cnt_q == len_cnt;

    assign empty_o = data_empty && addr_empty;

endmodule

