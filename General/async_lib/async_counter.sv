module async_counter_reciver#(
    parameter int COUNTER_LEN = 4
)(
    input clk,
    input reset_i,

    input  [COUNTER_LEN:0] cnt_i, // BINARY INPUT, SYNC TO clk

    output [COUNTER_LEN:0] cnt_o,
    input cnt_taken_i
);

    logic[COUNTER_LEN:0] remote_cnt_q, local_cnt_q, cnt;
    always_ff @(posedge clk) begin
        remote_cnt_q <= cnt_i;
    end
    assign cnt = remote_cnt_q - local_cnt_q;
    always_ff @(posedge clk) begin
        if(reset_i) begin
            local_cnt_q <= '0;
        end else if(cnt_taken_i) begin
            local_cnt_q <= remote_cnt_q;
        end
    end

    assign cnt_o = cnt;

endmodule

module async_counter#(
    parameter int COUNTER_LEN = 4
)(
    input clk,
    input reset_i,

    output [COUNTER_LEN:0] cnt_o, // binary output sync to clk

    // write clockzone
    input wclk,
    input wreset_i,
    input cnt_taken_i
);

    logic[COUNTER_LEN:0] wclk_cnt_q, wclk_cnt_gray, async_wclk_cnt_gray_q;
    always_ff @(posedge wclk) begin
        if(wreset_i) begin
            wclk_cnt_q <= '0;
        end else begin
            if(cnt_taken_i) begin
                wclk_cnt_q <= wclk_cnt_q + 1'd1;
            end
        end
    end

    logic[COUNTER_LEN:0] async_cnt_gray_q, cnt_binary, cnt_binary_q;
    always_ff @(posedge wclk) begin
        async_wclk_cnt_gray_q <= wclk_cnt_gray;
    end
    always_ff @(posedge clk) begin
        async_cnt_gray_q <= async_wclk_cnt_gray_q;
    end
    comb_binary2gray #(COUNTER_LEN+1) b2g_wptr (wclk_cnt_q, wclk_cnt_gray);
    comb_gray2binary #(COUNTER_LEN+1) g2b_rptr (async_cnt_gray_q, cnt_binary);
    always_ff @(posedge clk) begin
        cnt_binary_q <= cnt_binary;
    end
    assign cnt_o = cnt_binary_q;

endmodule
