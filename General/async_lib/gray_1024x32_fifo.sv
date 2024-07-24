/// ```
/// set_ungroup [get_designs gray_1024x32_fifo] false
/// set_boundary_optimization [get_designs gray_1024x32_fifo] false
/// set_max_delay min(T_src, T_dst) \
///     -through [get_pins -hierarchical -filter async] \
///     -through [get_pins -hierarchical -filter async]
/// set_false_path -hold \
///     -through [get_pins -hierarchical -filter async] \
///     -through [get_pins -hierarchical -filter async]
/// ```

module gray_1024x32_fifo(
    input wclk,
    input wrstn,
    input wvalid_i,
    input logic[31:0] wdata_i,
    output wready_o,

    output rclk,
    output rrstn,
    input rready_i,
    output logic[31:0] rdata_o,
    output rvalid_o,

    output logic[10:0] wclk_fifo_cnt_o,
    output logic[10:0] rclk_fifo_cnt_o
);

logic[10:0] wclk_wptr_gray, rclk_rptr_gray, rclk_wptr_gray, wclk_rptr_gray; // GRAY PTR USED ACROSS TIMING ZONE.

localparam SYNC_STAGES = 2;
logic[SYNC_STAGES - 1 : 0][10:0] async_wptr_sync_q, async_rptr_sync_q; // set false path here
always_ff @(posedge rclk) begin
    async_wptr_sync_q <= {async_wptr_sync_q[SYNC_STAGES-2:0], wclk_wptr_gray};
end
assign rclk_wptr_gray = async_wptr_sync_q[SYNC_STAGES-1];
always_ff @(posedge wclk) begin
    async_rptr_sync_q <= {async_rptr_sync_q[SYNC_STAGES-2:0], rclk_rptr_gray};
end
assign wclk_rptr_gray = async_rptr_sync_q[SYNC_STAGES-1];

logic[9:0] wclk_wptr, rclk_rptr;
logic wclk_we, rclk_re;

async_tdpsram_wrapper # (
    .DATA_WIDTH(32),
    .DATA_DEPTH(1024),
    .BYTE_SIZE(32)
  )
  async_tdpsram_wrapper_inst (
    .clk0(wclk),
    .rst_n0(wrstn),
    .addr0_i(wclk_wptr),
    .en0_i('1),
    .we0_i(wclk_we),
    .wdata0_i(wdata_i),
    .rdata0_o(),
    .clk1(rclk),
    .rst_n1(rrstn),
    .addr1_i(rclk_rptr),
    .en1_i(rclk_re),
    .we1_i('0),
    .wdata1_i('0),
    .rdata1_o(rdata_o)
  );


  gray_fifo_rptr_logic # (
    .LOG_DEPTH(10)
  )
  gray_fifo_rptr_logic_inst (
    .clk(rclk),
    .flush_i(!rrstn),
    .wptr_gray_i(rclk_wptr_gray),
    .rptr_gray_o(rclk_rptr_gray),
    .rready_i(rready_i),
    .rvalid_o(rvalid_o),
    .rptr_o(rclk_rptr),
    .re_o(rclk_re),
    .fifo_cnt_o(rclk_fifo_cnt_o)
  );

  gray_fifo_wptr_logic # (
    .LOG_DEPTH(10)
  )
  gray_fifo_wptr_logic_inst (
    .clk(wclk),
    .flush_i(!wrstn),
    .rptr_gray_i(wclk_rptr_gray),
    .wptr_gray_o(wclk_wptr_gray),
    .wvalid_i(wvalid_i),
    .wready_o(wready_o),
    .wptr_o(wclk_wptr),
    .we_o(wclk_we),
    .fifo_cnt_o(wclk_fifo_cnt_o)
  );

endmodule

module gray_fifo_rptr_logic #(
    parameter int LOG_DEPTH = 10
)(
    input clk,
    input flush_i,

    input logic[LOG_DEPTH:0] wptr_gray_i, // SHOULD BE SYNC TO WPORT CLK ZONE
    output logic[LOG_DEPTH:0] rptr_gray_o,

    input logic rready_i,
    output logic rvalid_o,

    output logic[LOG_DEPTH-1:0] rptr_o,
    output logic re_o,

    output logic[LOG_DEPTH:0] fifo_cnt_o
);
    logic[LOG_DEPTH:0] rptr_q, wptr_q; // binary ptr
    generate
        logic[LOG_DEPTH:0] wptr_binary;
        logic[LOG_DEPTH:0] rptr_gray, rptr_gray_q;
        comb_gray2binary #(LOG_DEPTH+1) g2b_rptr (wptr_gray_i, wptr_binary);
        comb_binary2gray #(LOG_DEPTH+1) b2g_wptr (rptr_q, rptr_gray);
        always @(posedge clk) begin
            wptr_q <= wptr_binary;
            rptr_gray_q <= rptr_gray;
        end
        assign rptr_gray_o = rptr_gray_q;
    endgenerate
    wire[LOG_DEPTH:0] valid_count = wptr_q - rptr_q; // This value may higher than actual value thanks to rptr's delay.
    wire rvalid_w = |valid_count;
    wire rvalid_bigger_one = rvalid_w > 1;

    always_ff @(posedge clk) begin
        if(flush_i) begin
            rptr_q <= '0;
        end else begin
            if(rvalid_o && rready_i) begin
                rptr_q <= rptr_q + 1'd1;
            end
        end
    end

    // FOR R PORT, WE HAVE 1-Cycle latency for rport.
    logic[LOG_DEPTH-1:0] real_rptr_q;
    logic rvalid_q;
    always_ff @(posedge clk) begin
        if(flush_i) begin
            rvalid_q <= '0;
            real_rptr_q <= '0;
        end else if(!rvalid_q) begin
            if(rvalid_w) begin
                rvalid_q <= '1;
                real_rptr_q <= real_rptr_q + 1'd1;
            end
        end else begin
            // R_SKID_VALID_Q IS SET
            if(rready_i) begin
                if(rvalid_bigger_one) begin
                    real_rptr_q <= real_rptr_q + 1'd1;
                end else /*if(rvalid_bigger_one)*/ begin
                    rvalid_q <= '0;
                end 
            end
        end
    end
    assign rvalid_o = rvalid_q;
    assign rptr_o = real_rptr_q;
    assign re_o = (!rvalid_q && rvalid_w) || (rvalid_q && rvalid_bigger_one && rready_i); // DO WE HAVE VALID OUTPUT NEXT CYCLE?
    assign fifo_cnt_o = valid_count;

endmodule

module gray_fifo_wptr_logic #(
    parameter int LOG_DEPTH = 10
)(
    input clk,
    input flush_i,

    input logic[LOG_DEPTH:0] rptr_gray_i, // SHOULD BE SYNC TO WPORT CLK ZONE
    output logic[LOG_DEPTH:0] wptr_gray_o,

    input logic wvalid_i,
    output logic wready_o,

    output logic[LOG_DEPTH-1:0] wptr_o,
    output logic we_o,

    output logic[LOG_DEPTH:0] fifo_cnt_o
);

    logic[LOG_DEPTH:0] rptr_q, wptr_q; // binary ptr
    generate
        logic[LOG_DEPTH:0] rptr_binary;
        logic[LOG_DEPTH:0] wptr_gray, wptr_gray_q;
        comb_gray2binary #(LOG_DEPTH+1) g2b_rptr (rptr_gray_i, rptr_binary);
        comb_binary2gray #(LOG_DEPTH+1) b2g_wptr (wptr_q, wptr_gray);
        always @(posedge clk) begin
            rptr_q <= rptr_binary;
            wptr_gray_q <= wptr_gray;
        end
        assign wptr_gray_o = wptr_gray_q;
    endgenerate
    wire[LOG_DEPTH:0] valid_count = wptr_q - rptr_q; // This value may higher than actual value thanks to rptr's delay.
    assign fifo_cnt_o = valid_count;
    assign wptr_o = wptr_q;
    assign wready_o = !valid_count[LOG_DEPTH];
    assign we_o = wvalid_i && wready_o;

    always_ff @(posedge clk) begin
        if(flush_i) begin
            wptr_q <= '0;
        end else begin
            if(wvalid_i && wready_o) begin
                wptr_q <= wptr_q + 1'd1;
            end
        end
    end

endmodule
