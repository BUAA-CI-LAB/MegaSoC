//-----------------------------------------------------------------
//                       AXI-4 JPEG Decoder
//                             V0.2
//                       Ultra-Embedded.com
//                        Copyright 2020
//
//                   admin@ultra-embedded.com
//-----------------------------------------------------------------
//                      License: Apache 2.0
// This IP can be freely used in commercial projects, however you may
// want access to unreleased materials such as verification environments,
// or test vectors, as well as changes to the IP for integration purposes.
// If this is the case, contact the above address.
// I am interested to hear how and where this IP is used, so please get
// in touch!
//-----------------------------------------------------------------
// Copyright 2020 Ultra-Embedded.com
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------

module generic_256x32_fifo
#(
    parameter C_ASIC_SRAM = 1
)
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [ 31:0]  data_in_i
    ,input           push_i
    ,input           pop_i
    ,input           flush_i

    // Outputs
    ,output [ 31:0]  data_out_o
    ,output          accept_o
    ,output          valid_o
    ,output [ 8:0]   level_o
);



//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
reg [7:0]   rd_ptr_q;
reg [7:0]   wr_ptr_q;

//-----------------------------------------------------------------
// Write Side
//-----------------------------------------------------------------
wire [7:0] write_next_w = wr_ptr_q + 8'd1;

wire full_w = (write_next_w == rd_ptr_q);

always @ (posedge clk_i)
if (rst_i)
    wr_ptr_q <= 8'b0;
else if (flush_i)
    wr_ptr_q <= 8'b0;
// Push
else if (push_i & !full_w)
    wr_ptr_q <= write_next_w;

//-----------------------------------------------------------------
// Read Side
//-----------------------------------------------------------------
wire read_ok_w = (wr_ptr_q != rd_ptr_q);
reg  rd_q;

always @ (posedge clk_i)
if (rst_i)
    rd_q <= 1'b0;
else if (flush_i)
    rd_q <= 1'b0;
else
    rd_q <= read_ok_w;

always @ (posedge clk_i)
if (rst_i)
    rd_ptr_q     <= 8'b0;
else if (flush_i)
    rd_ptr_q     <= 8'b0;
// Read address increment
else if (read_ok_w && ((!valid_o) || (valid_o && pop_i)))
    rd_ptr_q <= rd_ptr_q + 8'd1;

//-------------------------------------------------------------------
// Read Skid Buffer
//-------------------------------------------------------------------
reg                rd_skid_q;
reg [31:0] rd_skid_data_q;

always @ (posedge clk_i)
if (rst_i)
begin
    rd_skid_q <= 1'b0;
    rd_skid_data_q <= 32'b0;
end
else if (flush_i)
begin
    rd_skid_q <= 1'b0;
    rd_skid_data_q <= 32'b0;
end
else if (valid_o && !pop_i)
begin
    rd_skid_q      <= 1'b1;
    rd_skid_data_q <= data_out_o;
end
else
begin
    rd_skid_q      <= 1'b0;
    rd_skid_data_q <= 32'b0;
end

//-------------------------------------------------------------------
// Combinatorial
//-------------------------------------------------------------------
assign valid_o       = rd_skid_q | rd_q;
assign accept_o      = !full_w;

//-------------------------------------------------------------------
// Dual port RAM
//-------------------------------------------------------------------
wire [31:0] data_out_w;
generate 
    if(C_ASIC_SRAM) begin
        DP_RAM_DP_W256_B32_M4 ram (
            .CLKA(clk_i ),
            .CLKB(clk_i ),
            
            .CENA(~read_ok_w),
            .CENB(1'b0      ),
            
            .WENA(1'b1),
            .WENB(~(push_i & accept_o)),
            
            .AA  (rd_ptr_q),
            .AB  (wr_ptr_q),
            
            .QA  (data_out_w),
            .QB  (    ),
            
            .DA  (32'bx),
            .DB  (data_in_i )
        );
    end else begin
        fpga_ram_dp_256x32
        u_ram
        (
            // Inputs
            .clk0_i(clk_i),
            .rst0_i(rst_i),
            .clk1_i(clk_i),
            .rst1_i(rst_i),

            // Write side
            .addr0_i(wr_ptr_q),
            .wr0_i(push_i & accept_o),
            .data0_i(data_in_i),
            .data0_o(),

            // Read side
            .addr1_i(rd_ptr_q),
            .data1_i(32'b0),
            .wr1_i(1'b0),
            .data1_o(data_out_w)
        );
    end
endgenerate

assign data_out_o = rd_skid_q ? rd_skid_data_q : data_out_w;


//-------------------------------------------------------------------
// Level
//-------------------------------------------------------------------
reg [8:0]  count_q;

always @ (posedge clk_i)
if (rst_i)
    count_q   <= 9'b0;
else if (flush_i)
    count_q   <= 9'b0;
// Count up
else if ((push_i & accept_o) & ~(pop_i & valid_o))
    count_q <= count_q + 9'd1;
// Count down
else if (~(push_i & accept_o) & (pop_i & valid_o))
    count_q <= count_q - 9'd1;

assign level_o = count_q;

endmodule

//-------------------------------------------------------------------
// Dual port RAM
//-------------------------------------------------------------------
module fpga_ram_dp_256x32
(
    // Inputs
     input           clk0_i
    ,input           rst0_i
    ,input  [ 7:0]   addr0_i
    ,input  [ 31:0]  data0_i
    ,input           wr0_i
    ,input           clk1_i
    ,input           rst1_i
    ,input  [ 7:0]   addr1_i
    ,input  [ 31:0]  data1_i
    ,input           wr1_i

    // Outputs
    ,output [ 31:0]  data0_o
    ,output [ 31:0]  data1_o
);

/* verilator lint_off MULTIDRIVEN */
reg [31:0]   ram [255:0] /*verilator public*/;
/* verilator lint_on MULTIDRIVEN */

reg [31:0] ram_read0_q;
reg [31:0] ram_read1_q;

// Synchronous write
always @ (posedge clk0_i)
begin
    if (wr0_i)
        ram[addr0_i] <= data0_i;

    ram_read0_q <= ram[addr0_i];
end

always @ (posedge clk1_i)
begin
    if (wr1_i)
        ram[addr1_i] <= data1_i;

    ram_read1_q <= ram[addr1_i];
end

assign data0_o = ram_read0_q;
assign data1_o = ram_read1_q;



endmodule
