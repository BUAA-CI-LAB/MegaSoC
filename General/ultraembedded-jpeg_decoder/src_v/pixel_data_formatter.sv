// This module is used to buildup axi - burst request for pixel writeback task
// W data may comes earlier than AW data
// So we reformat
module pixel_data_formatter(
    input clk,
    input rst_n,

    input flush_i,

    input  pixel_mode_24_i,

    input  pixel_valid_i,
    output pixel_ready_o,
    input [7:0]  pixel_r_i,
    input [7:0]  pixel_g_i,
    input [7:0]  pixel_b_i,

    // formatted data

    output data_valid_o,
    input  data_ready_i,
    output [31:0] data_o
);

/*
    24bits mode
        wptr at 0 1 2 3
        wptr at 0 3 6 9
        rptr at 0 1 2
                11
        012345678901
        RGBRGBRGBRGB
    16bits mode
        wptr at 0 1 2 3 4  5
        wptr at 0 2 4 6 8 10
        rptr at 0 1 2
*/
logic [2:0] wptr_q;
logic [1:0] rptr_q;
logic [11:0][7:0] fifo_q;
wire [2:0][3:0][7:0] fifo_r = fifo_q;
logic [3:0] cnt_q; // IN BYTES

// COUNT BYTES
always_ff @(posedge clk) begin
    if(!rst_n || flush_i) begin
        cnt_q <= '0;
    end else begin
        cnt_q <= cnt_q - ((data_valid_o && data_ready_i) ? 4'd4 : 4'd0) // Read  sub
                       + ((pixel_valid_i && pixel_ready_o) ? 
                                    (pixel_mode_24_i ? 4'd3 : 4'd2) :   // Write add
                                    '0); 
    end
end
assign data_valid_o = |cnt_q[3:2];
assign pixel_ready_o = ~(&cnt_q[3:2]);

// W PTR
always_ff @(posedge clk) begin
    if(!rst_n || flush_i) begin
        wptr_q <= '0;
    end else begin
        if(pixel_valid_i && pixel_ready_o) begin
            if(pixel_mode_24_i) begin
                wptr_q <= wptr_q == 3'd3 ? '0 : (wptr_q + 1'd1);
            end else begin
                wptr_q <= wptr_q == 3'd5 ? '0 : (wptr_q + 1'd1);
            end
        end
    end
end

// R PTR
always_ff @(posedge clk) begin
    if(!rst_n || flush_i) begin
        rptr_q <= '0;
    end else begin
        if(data_ready_i && data_valid_o) begin
            rptr_q <= rptr_q == 2'd2 ? '0 : (rptr_q + 1'd1);
        end
    end
end
assign data_o = fifo_r[rptr_q];

// fifo_q update
always_ff @(posedge clk) begin
    if(pixel_valid_i && pixel_ready_o) begin
        if(pixel_mode_24_i) begin
            fifo_q[wptr_q * 3] <= pixel_r_i;
            fifo_q[wptr_q * 3 + 1] <= pixel_g_i;
            fifo_q[wptr_q * 3 + 2] <= pixel_b_i;
        end else begin
            fifo_q[{wptr_q, 1'd0}] <= {pixel_g_i[4:2],pixel_b_i[7:3]};
            fifo_q[{wptr_q, 1'd1}] <= {pixel_r_i[7:3],pixel_g_i[7:5]};
        end
    end
end

endmodule
