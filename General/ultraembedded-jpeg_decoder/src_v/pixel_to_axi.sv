module pixel_to_axi (
    input clk,
    input rst_n,

    // FLUSH Controlling
    output empty_o,
    input flush_i,

    // Configuration, shouldn't be changed
    input  pixel_mode_24_i,
    input [31:0] dst_addr_i,
    input [13:0] pixel_stride_i,

    // pixel input
    input  pixel_valid_i,
    output pixel_ready_o,
    input [15:0] pixel_x_i,
    input [15:0] pixel_y_i,
    input [7:0]  pixel_r_i,
    input [7:0]  pixel_g_i,
    input [7:0]  pixel_b_i,

    // AXI AW
    (*mark_debug="true"*) output awvalid_o,
    (*mark_debug="true"*) input  awready_i,
    (*mark_debug="true"*) output[31:0] awaddr_o,
    (*mark_debug="true"*) output[7:0]  awlen_o,
    // AXI W
    (*mark_debug="true"*) output wvalid_o,
    (*mark_debug="true"*) input  wready_i,
    (*mark_debug="true"*) output[31:0] wdata_o,
    (*mark_debug="true"*) output wlast_o
);

    (*mark_debug="true"*) wire addr_valid, addr_ready_2;
    (*mark_debug="true"*) wire [2:0]  addr_len;
    wire [31:0] addr;
    (*mark_debug="true"*) wire addr_pixel_ready, data_pixel_ready;
    assign pixel_ready_o = addr_pixel_ready && data_pixel_ready;
    pixel_addr_burstirizer  pixel_addr_burstirizer_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_mode_24_i(pixel_mode_24_i),
        .dst_addr_i(dst_addr_i),
        .pixel_stride_i(pixel_stride_i),
        .pixel_valid_i(pixel_valid_i && data_pixel_ready),
        .pixel_ready_o(addr_pixel_ready),
        .pixel_x_i(pixel_x_i),
        .pixel_y_i(pixel_y_i),
        .addr_valid_o(addr_valid),
        .addr_ready_2_i(addr_ready_2),
        .addr_len_o(addr_len),
        .addr_o(addr)
    );

    (*mark_debug="true"*) wire pixel_valid_w, pixel_ready_w;
    wire [7:0] pixel_r_w,pixel_g_w,pixel_b_w;
    spill_register_noflushable #(
        .T(logic[23:0])
    ) pixel_input_register_inst (
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(pixel_valid_i && addr_pixel_ready),
        .flush_i(flush_i),
        .ready_o(data_pixel_ready),
        .data_i({pixel_r_i, pixel_g_i, pixel_b_i}),
        .valid_o(pixel_valid_w),
        .ready_i(pixel_ready_w),
        .data_o({pixel_r_w,pixel_g_w,pixel_b_w})
    );

    // FIFO_V3 WITH DEPTH @ 2 FOR PIXEL_ADDR_BURSTIERIZER
    
    wire [2:0]  addr_len_w;
    wire [31:0] addr_w;
    wire addr_valid_w = !addr_ready_2;
    (*mark_debug="true"*) wire addr_ready_w;
    fifo_v3 #(
        .FALL_THROUGH ( 1'b0 ),
        .DEPTH        (  2  ),
        .dtype        ( logic[31+3:0] )
    ) addr_len_fifo (
        .clk_i     ( clk        ),
        .rst_ni    ( rst_n      ),
        .flush_i   ( flush_i    ),
        .testmode_i( 1'b0       ),
        .full_o    (  ),
        .empty_o   ( addr_ready_2 ),
        .usage_o   ( /**/ ),
        .data_i    ( {addr_len, addr} ),
        .push_i    ( addr_valid ),
        .data_o    ( {addr_len_w, addr_w} ),
        .pop_i     ( {addr_valid_w & addr_ready_w}  )
    );

    (*mark_debug="true"*) wire data_valid_w, data_ready_w;
    wire [31:0] data_w;
    pixel_data_formatter  pixel_data_formatter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .flush_i(flush_i),
        .pixel_mode_24_i(pixel_mode_24_i),
        .pixel_valid_i(pixel_valid_w),
        .pixel_ready_o(pixel_ready_w),
        .pixel_r_i(pixel_r_w),
        .pixel_g_i(pixel_g_w),
        .pixel_b_i(pixel_b_w),
        .data_valid_o(data_valid_w),
        .data_ready_i(data_ready_w),
        .data_o(data_w)
    );

    pixel_axi_former  pixel_axi_former_inst (
        .clk(clk),
        .rst_n(rst_n),
        .empty_o(empty_o),
        .flush_i(flush_i),

        .data_valid_i(data_valid_w),
        .data_ready_o(data_ready_w),
        .data_i(data_w),
        .addr_valid_i(addr_valid_w),
        .addr_ready_o(addr_ready_w),
        .len_i(addr_len_w),
        .addr_i(addr_w),

        .awvalid_o(awvalid_o),
        .awready_i(awready_i),
        .awaddr_o(awaddr_o),
        .awlen_o(awlen_o),
        .wvalid_o(wvalid_o),
        .wready_i(wready_i),
        .wdata_o(wdata_o),
        .wlast_o(wlast_o)
    );

endmodule