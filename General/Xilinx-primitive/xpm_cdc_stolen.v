// -------------------------------------------------------------------------------------------------------------------
// Macro definitions.  Only to be used by xpm_cdc_* modules.
// -------------------------------------------------------------------------------------------------------------------

// Define Xilinx Synchronous Register.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREG(clk, reset_p, q, d, rstval)   \
  always @(posedge clk) begin                    \
    if (reset_p == 1'b1)                         \
      q <= rstval;                               \
    else                                         \
      q <= d;                                    \
  end

// Define Xilinx Synchronous Register with Enable.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREGEN(clk, reset_p, q, d, en, rstval)   \
  always @(posedge clk) begin                          \
    if (reset_p == 1'b1)                               \
      q <= rstval;                                     \
    else                                               \
      if (en == 1'b1)                                  \
        q <= d;                                        \
  end

// Define Xilinx Asynchronous Register. Only to be used by xpm_cdc_* modules.
`define XPM_XARREG(clk, reset_p, q, d, rstval)   \
  always @(posedge clk or posedge reset_p)       \
  begin                                          \
    if (reset_p == 1'b1)                         \
      q <= rstval;                               \
    else                                         \
      q <= d;                                    \
  end

//==================================================================================================================

  // Define Xilinx Synchronous Register.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREG_INIT(clk, reset_p, q, d, rstval, gsr_asserted, gsr_init_val) \
  always @(gsr_asserted) begin                                                  \
    if (gsr_asserted)                                                           \
      force q = gsr_init_val;                                                   \
    else                                                                        \
      release q;                                                                \
  end                                                                           \
                                                                                \
  always @(posedge clk) begin                                                   \
    if (reset_p == 1'b1)                                                        \
      q <= rstval;                                                              \
    else                                                                        \
      q <= d;                                                                   \
  end

// Define Xilinx Synchronous Register with Enable.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREGEN_INIT(clk, reset_p, q, d, en, rstval, gsr_asserted, gsr_init_val) \
  always @(gsr_asserted) begin                                                        \
    if (gsr_asserted)                                                                 \
      force q = gsr_init_val;                                                         \
    else                                                                              \
      release q;                                                                      \
  end                                                                                 \
                                                                                      \
  always @(posedge clk) begin                                                         \
    if (reset_p == 1'b1)                                                              \
      q <= rstval;                                                                    \
    else                                                                              \
      if (en == 1'b1)                                                                 \
        q <= d;                                                                       \
  end

// Define Xilinx Asynchronous Register. Only to be used by xpm_cdc_* modules.
`define XPM_XARREG_INIT(clk, reset_p, q, d, rstval, gsr_asserted, gsr_init_val) \
  always @(gsr_asserted or reset_p)                                             \
    if (gsr_asserted)                                                           \
      force q = gsr_init_val;                                                   \
    else if (reset_p === 1'b1)                                                  \
      force q = ~gsr_init_val;                                                  \
    else if (reset_p === 1'bx)                                                  \
      force q = 1'bx;                                                           \
    else                                                                        \
      release q;                                                                \
                                                                                \
  always @(posedge clk or posedge reset_p)                                      \
  begin                                                                         \
    if (reset_p == 1'b1)                                                        \
      q <= rstval;                                                              \
    else                                                                        \
      q <= d;                                                                   \
  end

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_single #(
  // Module parameters
  parameter integer DEST_SYNC_FF    = 4,
  parameter integer SRC_INPUT_REG   = 1
) (
  // Module ports
  input  wire         src_clk,
  input  wire         src_in,
  input  wire         dest_clk,
  output wire         dest_out
);

  // Set Asynchronous Register property on synchronizers
  (* DONT_TOUCH, STOLEN_CDC = "SINGLE", ASYNC_REG = "TRUE" *) reg [DEST_SYNC_FF-1:0] syncstages_ff;

  reg  src_ff;
  wire src_inqual;
  wire async_path_bit;

  assign dest_out       = syncstages_ff[DEST_SYNC_FF-1];
  assign async_path_bit = src_inqual;

  // Virtual mux:  Register at input optional.
  generate
  if (SRC_INPUT_REG) begin
    assign src_inqual = src_ff;
  end
  else begin
    assign src_inqual = src_in;
  end 
  endgenerate

  `XPM_XSRREG(src_clk , 1'b0,  src_ff,        src_in,         1'b0)
  `XPM_XSRREG(dest_clk, 1'b0,  syncstages_ff, { syncstages_ff[DEST_SYNC_FF-2:0], async_path_bit} , {DEST_SYNC_FF{1'b0}})

endmodule

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_sync_rst # (
  parameter integer DEST_SYNC_FF    = 4
  ) (
  input  wire       src_rst,
  input  wire       dest_clk,
  output wire       dest_rst
);

  (* DONT_TOUCH, STOLEN_CDC = "SYNC_RST", ASYNC_REG = "TRUE" *) reg [DEST_SYNC_FF-1:0] syncstages_ff;

  wire async_path_bit;

  assign dest_rst = syncstages_ff[DEST_SYNC_FF-1];
  assign async_path_bit = src_rst;
  
  `XPM_XSRREG(dest_clk, 1'b0,  syncstages_ff, { syncstages_ff[DEST_SYNC_FF-2:0], async_path_bit}, {DEST_SYNC_FF{1'b0}})

endmodule

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_array_single # (
  parameter integer DEST_SYNC_FF    = 4,
  parameter integer SRC_INPUT_REG   = 1,
  parameter integer WIDTH           = 2
) (
  input  wire             src_clk,
  input  wire [WIDTH-1:0] src_in,
  input  wire             dest_clk,
  output wire [WIDTH-1:0] dest_out
);

  (* DONT_TOUCH, STOLEN_CDC = "ARRAY_SINGLE", ASYNC_REG = "TRUE" *) reg  [WIDTH-1:0] syncstages_ff [DEST_SYNC_FF-1:0];

  reg  [WIDTH-1:0] src_ff;
  wire [WIDTH-1:0] src_inqual;
  wire [WIDTH-1:0] async_path_bit;

  assign dest_out = syncstages_ff[DEST_SYNC_FF-1];

  integer syncstage;
  always @(posedge dest_clk) begin
    syncstages_ff[0] <= async_path_bit;

    for ( syncstage = 1; syncstage < DEST_SYNC_FF ;syncstage = syncstage + 1)
      syncstages_ff[syncstage] <= syncstages_ff [syncstage-1];
  end

  assign async_path_bit = src_inqual;

  // Virtual mux:  Register at input optional.
  generate
  if (SRC_INPUT_REG) begin 
    assign src_inqual = src_ff;
  end 
  else begin 
    assign src_inqual = src_in;
  end 
  endgenerate

  genvar vara_i;
  generate
      `XPM_XSRREG(src_clk, 1'b0, src_ff, src_in, {WIDTH{1'b0}})
  endgenerate
endmodule

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_gray #(
  // Module parameters
  parameter integer DEST_SYNC_FF          = 4,
  parameter integer INIT_SYNC_FF          = 0,
  parameter integer REG_OUTPUT            = 0,
  parameter integer SIM_ASSERT_CHK        = 0,
  parameter integer SIM_LOSSLESS_GRAY_CHK = 0,
  parameter integer VERSION               = 0,
  parameter integer WIDTH                 = 2
) (
  // Module ports
  input  wire             src_clk,
  input  wire [WIDTH-1:0] src_in_bin,
  input  wire             dest_clk,
  output wire [WIDTH-1:0] dest_out_bin
);

  // Set Asynchronous Register property on synchronizers
  (* DONT_TOUCH, STOLEN_CDC = "GRAY", ASYNC_REG = "TRUE" *) reg [WIDTH-1:0] dest_graysync_ff [DEST_SYNC_FF-1:0];


  wire [WIDTH-1:0] gray_enc;
  reg  [WIDTH-1:0] binval;

  (* DONT_TOUCH, STOLEN_CDC = "GRAY" *) reg  [WIDTH-1:0] src_gray_ff;
  wire [WIDTH-1:0] synco_gray;
  wire [WIDTH-1:0] async_path;
  reg  [WIDTH-1:0] dest_out_bin_ff;

  integer syncstage;
  always @(posedge dest_clk) begin
    dest_graysync_ff[0] <= async_path;

    for (syncstage = 1; syncstage < DEST_SYNC_FF ;syncstage = syncstage + 1)
      dest_graysync_ff[syncstage] <= dest_graysync_ff [syncstage-1];
  end

  assign async_path = src_gray_ff;

  assign synco_gray = dest_graysync_ff[DEST_SYNC_FF-1];
  assign gray_enc = src_in_bin ^ {1'b0, src_in_bin[WIDTH-1:1]};

  // Convert gray code back to binary
  integer j;
  always @(*) begin
    binval[WIDTH-1] = synco_gray[WIDTH-1];
    for (j = WIDTH - 2; j >= 0; j = j - 1)
        binval[j] = binval[j+1] ^ synco_gray[j];
  end

  generate
  if(REG_OUTPUT) begin
    assign dest_out_bin     = dest_out_bin_ff;
  end
  else begin
    assign dest_out_bin     = binval;
  end
  endgenerate


  `XPM_XSRREG(src_clk, 1'b0,  src_gray_ff, gray_enc, {WIDTH{1'b0}})
  `XPM_XSRREG(dest_clk, 1'b0,  dest_out_bin_ff, binval, {WIDTH{1'b0}})


endmodule

// -------------------------------------------------------------------------------------------------------------------
// Pulse Transfer
// -------------------------------------------------------------------------------------------------------------------
// This is a module that takes a pulse from the source domain and converts it
// to a level to cross into the other domain, and then converting it back to a pulse
// in destination domain.
(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_pulse #(
  parameter integer DEST_SYNC_FF    = 4,
  parameter integer REG_OUTPUT      = 0,
  parameter integer RST_USED        = 1,
  parameter integer SIM_ASSERT_CHK  = 0,
  parameter integer VERSION         = 0
) (
  input  wire       src_clk,
  input  wire       src_pulse,
  input  wire       dest_clk,
  input  wire       src_rst,
  input  wire       dest_rst,
  output wire       dest_pulse
);

  // If toggle flop is not initialized,then it can be un-known forever.
  // It is assumed that there is no loss of coverage either way.
  // For edge detect, we would want the logic to be more controlled.
  reg  src_level_ff = 1'b0;

  reg  src_in_ff;
  wire src_level_nxt;
  wire src_edge_det;
  wire src_sync_in;

  wire dest_sync_out;
  wire dest_event_nxt;
  reg  dest_event_ff;
  wire dest_sync_qual;

  wire src_rst_qual;
  wire dest_rst_qual;

  wire dest_pulse_int;
  reg  dest_pulse_ff;

  //Assignments
  assign src_edge_det   = src_pulse & ~src_in_ff;
  assign src_level_nxt  = src_level_ff ^ src_edge_det;
  assign src_sync_in    = src_level_ff;
  assign dest_event_nxt = dest_sync_qual;
  assign dest_pulse_int = dest_sync_qual ^ dest_event_ff;
  assign dest_sync_qual = dest_sync_out & ~dest_rst_qual;

  generate
  if(RST_USED) begin : use_rst
    assign src_rst_qual = src_rst;
    assign dest_rst_qual = dest_rst;
  end : use_rst
  else begin : no_rst
    assign src_rst_qual = 1'b0;
    assign dest_rst_qual = 1'b0;
  end : no_rst
  endgenerate

  generate
  if(REG_OUTPUT) begin : reg_out
    assign dest_pulse     = dest_pulse_ff;
  end : reg_out
  else begin : comb_out
    assign dest_pulse     = dest_pulse_int;
  end : comb_out
  endgenerate

  stolen_cdc_single # (
    .DEST_SYNC_FF   (DEST_SYNC_FF ),
    .SRC_INPUT_REG  (0            )
  ) xpm_cdc_single_inst (
    .src_clk       (src_clk       ),
    .dest_clk      (dest_clk      ),
    .src_in        (src_sync_in   ),
    .dest_out      (dest_sync_out )
  );

  // Instantiate Xilinx Synchronous Register
  `XPM_XSRREG(src_clk,  src_rst_qual,   src_in_ff,     src_pulse,      1'b0)
  `XPM_XSRREG(src_clk,  src_rst_qual,   src_level_ff,  src_level_nxt,  1'b0)
  `XPM_XSRREG(dest_clk, dest_rst_qual,  dest_event_ff, dest_event_nxt, 1'b0)
  `XPM_XSRREG(dest_clk, dest_rst_qual,  dest_pulse_ff, dest_pulse_int, 1'b0)


endmodule

// -------------------------------------------------------------------------------------------------------------------
// Asynchronous Reset Synchronizer
// -------------------------------------------------------------------------------------------------------------------
(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_async_rst # (
  parameter integer DEST_SYNC_FF    = 4,
  parameter integer INIT_SYNC_FF    = 0,
  parameter integer RST_ACTIVE_HIGH = 0,
  parameter integer VERSION         = 0
  ) (
  input  wire       src_arst,
  input  wire       dest_clk,
  output wire       dest_arst
);
  // -------------------------------------------------------------------------------------------------------------------
  // Local parameter definitions
  // -------------------------------------------------------------------------------------------------------------------

  // Define local parameter for settings
  localparam DEF_VAL        = (RST_ACTIVE_HIGH == 1) ? 1'b0 : 1'b1;
  localparam INV_DEF_VAL    = (RST_ACTIVE_HIGH == 0) ? 1'b0 : 1'b1;

  // Set asynchronous register property on synchronizers and initialize register with default value
  (* XPM_CDC = "ASYNC_RST", ASYNC_REG = "TRUE" *) reg [DEST_SYNC_FF-1:0] arststages_ff = {DEST_SYNC_FF{DEF_VAL}};

  wire                    async_path_bit;
  wire                    reset_pol;
  wire                    reset_polo;

  assign reset_polo = arststages_ff[DEST_SYNC_FF-1];
  assign async_path_bit = (RST_ACTIVE_HIGH == 1) ? 1'b0 : 1'b1;
  assign reset_pol = src_arst ^ ~RST_ACTIVE_HIGH;
  assign dest_arst = reset_polo;

  `XPM_XARREG(dest_clk, reset_pol,  arststages_ff, { arststages_ff[DEST_SYNC_FF-2:0], async_path_bit}, {DEST_SYNC_FF{INV_DEF_VAL}})

endmodule

