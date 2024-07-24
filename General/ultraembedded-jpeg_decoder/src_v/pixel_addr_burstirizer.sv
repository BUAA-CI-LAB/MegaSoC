// This module is used to buildup axi - burst request for pixel writeback task

module pixel_addr_burstirizer(
    input clk,
    input rst_n,

    // Configuration, shouldn't be changed
    input  pixel_mode_24_i,
    input [31:0] dst_addr_i,
    input [13:0] pixel_stride_i,

    input  pixel_valid_i,
    output pixel_ready_o,
    input [15:0] pixel_x_i,
    input [15:0] pixel_y_i,

    // AW channel
    // 5 cycles before first PIXEL handshake
    output addr_valid_o,
    input  addr_ready_2_i,    // READY for at least 2 transaction
    output [2:0]  addr_len_o,
    output [31:0] addr_o
);
// FSM Defines

typedef logic[2:0] addr_fsm_t;
addr_fsm_t fsm_q, fsm;
parameter addr_fsm_t WAIT_NEXT_8PIXEL = 0;
parameter addr_fsm_t CALCULATE_START_ADDR_INPUT  = 1;
parameter addr_fsm_t CALCULATE_START_ADDR_WAIT   = 2;
parameter addr_fsm_t CALCULATE_START_ADDR_OUTPUT = 3;
parameter addr_fsm_t JUDGE_ALIGNING = 4;
parameter addr_fsm_t JUDGE_ALIGNING_2 = 5;
parameter addr_fsm_t WAIT_AW_HANDSHAKE = 6;

logic addr_valid,addr_valid_q;
logic [2:0]  pixel_addr_len,pixel_addr_len_q;
logic [31:0] pixel_addr,pixel_addr_q;
assign addr_valid_o = addr_valid_q;
assign addr_len_o = pixel_addr_len_q;
assign addr_o = pixel_addr_q;

// batch_counter
reg [2:0] cnt_q;
reg [17:0] x_offset_q;
reg [31:0] pixel_hoffset_q;
// address fsm
reg[25:0] addr_muler_q;
reg[25:0] addr_muler_out;
logic[15:0] x,x_q;
logic[15:0] y,y_q;

always_ff @(posedge clk) begin
    if(!rst_n) begin
        cnt_q <= '0;
        fsm_q <= WAIT_NEXT_8PIXEL;
    end else begin
        fsm_q <= fsm;
        if(pixel_ready_o & pixel_valid_i) begin
            cnt_q <= cnt_q + 1;
        end
    end
end

always_ff @(posedge clk) begin
    addr_valid_q <= addr_valid;
    pixel_addr_len_q <= pixel_addr_len;
    pixel_addr_q <= pixel_addr;
    x_q <= x;
    y_q <= y;
end

// pixel offset calculator
always_ff @(posedge clk) begin
    x_offset_q <= (x_q << 1) + (pixel_mode_24_i ? x_q : '0);
end
always_ff @(posedge clk) begin
    pixel_hoffset_q <= x_offset_q + dst_addr_i;
end
always_ff @(posedge clk) begin
    addr_muler_q <= y_q * pixel_stride_i;
end
always_ff @(posedge clk) begin
    addr_muler_out <= addr_muler_q;
end

always_comb begin
    fsm = fsm_q;
    pixel_addr_len = pixel_addr_len_q;
    pixel_addr = pixel_addr_q;
    addr_valid = 1'd0;
    y = y_q;
    x = x_q;
    case(fsm_q)
    WAIT_NEXT_8PIXEL: begin
        if((cnt_q == '0) && pixel_valid_i & pixel_ready_o) begin
            fsm = CALCULATE_START_ADDR_INPUT;
            x = pixel_x_i;
            y = pixel_y_i;
        end
    end
    CALCULATE_START_ADDR_INPUT: begin
        fsm = CALCULATE_START_ADDR_WAIT;
    end
    CALCULATE_START_ADDR_WAIT: begin
        fsm = CALCULATE_START_ADDR_OUTPUT;
    end
    CALCULATE_START_ADDR_OUTPUT: begin
        fsm = JUDGE_ALIGNING;
        pixel_addr = pixel_hoffset_q + addr_muler_out;
    end
    JUDGE_ALIGNING: begin
        addr_valid = 1'd1;
        if((pixel_mode_24_i && (pixel_addr_q[11:2] > 10'd1018)) || 
          (!pixel_mode_24_i && (pixel_addr_q[11:2] > 10'd1020))) begin
            pixel_addr_len = 10'd1023 - pixel_addr_q[11:2];
            fsm = JUDGE_ALIGNING_2;
          end else begin
            pixel_addr_len = pixel_mode_24_i ? 3'd5 : 3'd3;
            fsm = WAIT_AW_HANDSHAKE;
          end
    end
    JUDGE_ALIGNING_2: begin
        addr_valid = 1'd1;
        fsm = WAIT_AW_HANDSHAKE;
        pixel_addr_len = (pixel_mode_24_i ? 3'd4 : 3'd2) - pixel_addr_len_q;
        pixel_addr = {{pixel_addr_q[31:12] + 1'd1}, 12'd0};
    end
    WAIT_AW_HANDSHAKE: begin
        fsm = WAIT_NEXT_8PIXEL;
    end
    endcase
end

// PIXEL HANDSHAKING
assign pixel_ready_o = (|cnt_q) || addr_ready_2_i;

endmodule
