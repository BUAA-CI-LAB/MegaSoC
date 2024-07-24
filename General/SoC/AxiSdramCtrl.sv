// Generator : SpinalHDL dev    git head : c3e2bd3c4ea71354cea34e53a1dc41b36a66b5f5
// Component : AxiSdramCtrl
// Git hash  : 50961bc06c8a18c0d1f006887c88261514f244d1

`timescale 1ns/1ps

module AxiSdramCtrl (
  input  wire          io_bus_aw_valid,
  output wire          io_bus_aw_ready,
  input  wire [31:0]   io_bus_aw_payload_addr,
  input  wire [6:0]    io_bus_aw_payload_id,
  input  wire [7:0]    io_bus_aw_payload_len,
  input  wire [2:0]    io_bus_aw_payload_size,
  input  wire [1:0]    io_bus_aw_payload_burst,
  input  wire          io_bus_w_valid,
  output wire          io_bus_w_ready,
  input  wire [31:0]   io_bus_w_payload_data,
  input  wire [3:0]    io_bus_w_payload_strb,
  input  wire          io_bus_w_payload_last,
  output wire          io_bus_b_valid,
  input  wire          io_bus_b_ready,
  output wire [6:0]    io_bus_b_payload_id,
  output wire [1:0]    io_bus_b_payload_resp,
  input  wire          io_bus_ar_valid,
  output wire          io_bus_ar_ready,
  input  wire [31:0]   io_bus_ar_payload_addr,
  input  wire [6:0]    io_bus_ar_payload_id,
  input  wire [7:0]    io_bus_ar_payload_len,
  input  wire [2:0]    io_bus_ar_payload_size,
  input  wire [1:0]    io_bus_ar_payload_burst,
  output wire          io_bus_r_valid,
  input  wire          io_bus_r_ready,
  output wire [31:0]   io_bus_r_payload_data,
  output wire [6:0]    io_bus_r_payload_id,
  output wire [1:0]    io_bus_r_payload_resp,
  output wire          io_bus_r_payload_last,
  output wire [12:0]   io_sdram_ADDR,
  output wire [1:0]    io_sdram_BA,
  input  wire [31:0]   io_sdram_DQ_read,
  output wire [31:0]   io_sdram_DQ_write,
  output wire [31:0]   io_sdram_DQ_writeEnable,
  output wire [3:0]    io_sdram_DQM,
  output wire          io_sdram_CASn,
  output wire          io_sdram_CKE,
  output wire [1:0]    io_sdram_CSn,
  output wire          io_sdram_RASn,
  output wire          io_sdram_WEn,
  input  wire          clk,
  input  wire          reset
);

  wire       [27:0]   sdramCtrl_1_io_axi_arw_payload_addr;
  wire                sdramCtrl_1_io_axi_arw_payload_write;
  wire                sdramCtrl_1_io_axi_arw_ready;
  wire                sdramCtrl_1_io_axi_w_ready;
  wire                sdramCtrl_1_io_axi_b_valid;
  wire       [6:0]    sdramCtrl_1_io_axi_b_payload_id;
  wire       [1:0]    sdramCtrl_1_io_axi_b_payload_resp;
  wire                sdramCtrl_1_io_axi_r_valid;
  wire       [31:0]   sdramCtrl_1_io_axi_r_payload_data;
  wire       [6:0]    sdramCtrl_1_io_axi_r_payload_id;
  wire       [1:0]    sdramCtrl_1_io_axi_r_payload_resp;
  wire                sdramCtrl_1_io_axi_r_payload_last;
  wire       [12:0]   sdramCtrl_1_io_sdram_ADDR;
  wire       [1:0]    sdramCtrl_1_io_sdram_BA;
  wire                sdramCtrl_1_io_sdram_CASn;
  wire                sdramCtrl_1_io_sdram_CKE;
  wire       [1:0]    sdramCtrl_1_io_sdram_CSn;
  wire       [3:0]    sdramCtrl_1_io_sdram_DQM;
  wire                sdramCtrl_1_io_sdram_RASn;
  wire                sdramCtrl_1_io_sdram_WEn;
  wire       [31:0]   sdramCtrl_1_io_sdram_DQ_write;
  wire       [31:0]   sdramCtrl_1_io_sdram_DQ_writeEnable;
  wire                streamArbiter_1_io_inputs_0_ready;
  wire                streamArbiter_1_io_inputs_1_ready;
  wire                streamArbiter_1_io_output_valid;
  wire       [31:0]   streamArbiter_1_io_output_payload_addr;
  wire       [6:0]    streamArbiter_1_io_output_payload_id;
  wire       [7:0]    streamArbiter_1_io_output_payload_len;
  wire       [2:0]    streamArbiter_1_io_output_payload_size;
  wire       [1:0]    streamArbiter_1_io_output_payload_burst;
  wire       [0:0]    streamArbiter_1_io_chosen;
  wire       [1:0]    streamArbiter_1_io_chosenOH;

  Axi4SharedSdramCtrl sdramCtrl_1 (
    .io_axi_arw_valid         (streamArbiter_1_io_output_valid             ), //i
    .io_axi_arw_ready         (sdramCtrl_1_io_axi_arw_ready                ), //o
    .io_axi_arw_payload_addr  (sdramCtrl_1_io_axi_arw_payload_addr[27:0]   ), //i
    .io_axi_arw_payload_id    (streamArbiter_1_io_output_payload_id[6:0]   ), //i
    .io_axi_arw_payload_len   (streamArbiter_1_io_output_payload_len[7:0]  ), //i
    .io_axi_arw_payload_size  (streamArbiter_1_io_output_payload_size[2:0] ), //i
    .io_axi_arw_payload_burst (streamArbiter_1_io_output_payload_burst[1:0]), //i
    .io_axi_arw_payload_write (sdramCtrl_1_io_axi_arw_payload_write        ), //i
    .io_axi_w_valid           (io_bus_w_valid                              ), //i
    .io_axi_w_ready           (sdramCtrl_1_io_axi_w_ready                  ), //o
    .io_axi_w_payload_data    (io_bus_w_payload_data[31:0]                 ), //i
    .io_axi_w_payload_strb    (io_bus_w_payload_strb[3:0]                  ), //i
    .io_axi_w_payload_last    (io_bus_w_payload_last                       ), //i
    .io_axi_b_valid           (sdramCtrl_1_io_axi_b_valid                  ), //o
    .io_axi_b_ready           (io_bus_b_ready                              ), //i
    .io_axi_b_payload_id      (sdramCtrl_1_io_axi_b_payload_id[6:0]        ), //o
    .io_axi_b_payload_resp    (sdramCtrl_1_io_axi_b_payload_resp[1:0]      ), //o
    .io_axi_r_valid           (sdramCtrl_1_io_axi_r_valid                  ), //o
    .io_axi_r_ready           (io_bus_r_ready                              ), //i
    .io_axi_r_payload_data    (sdramCtrl_1_io_axi_r_payload_data[31:0]     ), //o
    .io_axi_r_payload_id      (sdramCtrl_1_io_axi_r_payload_id[6:0]        ), //o
    .io_axi_r_payload_resp    (sdramCtrl_1_io_axi_r_payload_resp[1:0]      ), //o
    .io_axi_r_payload_last    (sdramCtrl_1_io_axi_r_payload_last           ), //o
    .io_sdram_ADDR            (sdramCtrl_1_io_sdram_ADDR[12:0]             ), //o
    .io_sdram_BA              (sdramCtrl_1_io_sdram_BA[1:0]                ), //o
    .io_sdram_DQ_read         (io_sdram_DQ_read[31:0]                      ), //i
    .io_sdram_DQ_write        (sdramCtrl_1_io_sdram_DQ_write[31:0]         ), //o
    .io_sdram_DQ_writeEnable  (sdramCtrl_1_io_sdram_DQ_writeEnable[31:0]   ), //o
    .io_sdram_DQM             (sdramCtrl_1_io_sdram_DQM[3:0]               ), //o
    .io_sdram_CASn            (sdramCtrl_1_io_sdram_CASn                   ), //o
    .io_sdram_CKE             (sdramCtrl_1_io_sdram_CKE                    ), //o
    .io_sdram_CSn             (sdramCtrl_1_io_sdram_CSn[1:0]               ), //o
    .io_sdram_RASn            (sdramCtrl_1_io_sdram_RASn                   ), //o
    .io_sdram_WEn             (sdramCtrl_1_io_sdram_WEn                    ), //o
    .clk                      (clk                                         ), //i
    .reset                    (reset                                       )  //i
  );
  StreamArbiter streamArbiter_1 (
    .io_inputs_0_valid         (io_bus_ar_valid                             ), //i
    .io_inputs_0_ready         (streamArbiter_1_io_inputs_0_ready           ), //o
    .io_inputs_0_payload_addr  (io_bus_ar_payload_addr[31:0]                ), //i
    .io_inputs_0_payload_id    (io_bus_ar_payload_id[6:0]                   ), //i
    .io_inputs_0_payload_len   (io_bus_ar_payload_len[7:0]                  ), //i
    .io_inputs_0_payload_size  (io_bus_ar_payload_size[2:0]                 ), //i
    .io_inputs_0_payload_burst (io_bus_ar_payload_burst[1:0]                ), //i
    .io_inputs_1_valid         (io_bus_aw_valid                             ), //i
    .io_inputs_1_ready         (streamArbiter_1_io_inputs_1_ready           ), //o
    .io_inputs_1_payload_addr  (io_bus_aw_payload_addr[31:0]                ), //i
    .io_inputs_1_payload_id    (io_bus_aw_payload_id[6:0]                   ), //i
    .io_inputs_1_payload_len   (io_bus_aw_payload_len[7:0]                  ), //i
    .io_inputs_1_payload_size  (io_bus_aw_payload_size[2:0]                 ), //i
    .io_inputs_1_payload_burst (io_bus_aw_payload_burst[1:0]                ), //i
    .io_output_valid           (streamArbiter_1_io_output_valid             ), //o
    .io_output_ready           (sdramCtrl_1_io_axi_arw_ready                ), //i
    .io_output_payload_addr    (streamArbiter_1_io_output_payload_addr[31:0]), //o
    .io_output_payload_id      (streamArbiter_1_io_output_payload_id[6:0]   ), //o
    .io_output_payload_len     (streamArbiter_1_io_output_payload_len[7:0]  ), //o
    .io_output_payload_size    (streamArbiter_1_io_output_payload_size[2:0] ), //o
    .io_output_payload_burst   (streamArbiter_1_io_output_payload_burst[1:0]), //o
    .io_chosen                 (streamArbiter_1_io_chosen                   ), //o
    .io_chosenOH               (streamArbiter_1_io_chosenOH[1:0]            ), //o
    .clk                       (clk                                         ), //i
    .reset                     (reset                                       )  //i
  );
  assign io_bus_ar_ready = streamArbiter_1_io_inputs_0_ready;
  assign io_bus_aw_ready = streamArbiter_1_io_inputs_1_ready;
  assign io_bus_w_ready = sdramCtrl_1_io_axi_w_ready;
  assign io_bus_b_valid = sdramCtrl_1_io_axi_b_valid;
  assign io_bus_b_payload_id = sdramCtrl_1_io_axi_b_payload_id;
  assign io_bus_b_payload_resp = sdramCtrl_1_io_axi_b_payload_resp;
  assign io_bus_r_valid = sdramCtrl_1_io_axi_r_valid;
  assign io_bus_r_payload_data = sdramCtrl_1_io_axi_r_payload_data;
  assign io_bus_r_payload_id = sdramCtrl_1_io_axi_r_payload_id;
  assign io_bus_r_payload_resp = sdramCtrl_1_io_axi_r_payload_resp;
  assign io_bus_r_payload_last = sdramCtrl_1_io_axi_r_payload_last;
  assign sdramCtrl_1_io_axi_arw_payload_addr = streamArbiter_1_io_output_payload_addr[27:0];
  assign sdramCtrl_1_io_axi_arw_payload_write = streamArbiter_1_io_chosenOH[1];
  assign io_sdram_ADDR = sdramCtrl_1_io_sdram_ADDR;
  assign io_sdram_BA = sdramCtrl_1_io_sdram_BA;
  assign io_sdram_DQ_write = sdramCtrl_1_io_sdram_DQ_write;
  assign io_sdram_DQ_writeEnable = sdramCtrl_1_io_sdram_DQ_writeEnable;
  assign io_sdram_DQM = sdramCtrl_1_io_sdram_DQM;
  assign io_sdram_CASn = sdramCtrl_1_io_sdram_CASn;
  assign io_sdram_CKE = sdramCtrl_1_io_sdram_CKE;
  assign io_sdram_CSn = sdramCtrl_1_io_sdram_CSn;
  assign io_sdram_RASn = sdramCtrl_1_io_sdram_RASn;
  assign io_sdram_WEn = sdramCtrl_1_io_sdram_WEn;

endmodule

module StreamArbiter (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [31:0]   io_inputs_0_payload_addr,
  input  wire [6:0]    io_inputs_0_payload_id,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [1:0]    io_inputs_0_payload_burst,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [31:0]   io_inputs_1_payload_addr,
  input  wire [6:0]    io_inputs_1_payload_id,
  input  wire [7:0]    io_inputs_1_payload_len,
  input  wire [2:0]    io_inputs_1_payload_size,
  input  wire [1:0]    io_inputs_1_payload_burst,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [31:0]   io_output_payload_addr,
  output wire [6:0]    io_output_payload_id,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [1:0]    io_output_payload_burst,
  output wire [0:0]    io_chosen,
  output wire [1:0]    io_chosenOH,
  input  wire          clk,
  input  wire          reset
);

  wire       [3:0]    _zz__zz_maskProposal_0_2;
  wire       [3:0]    _zz__zz_maskProposal_0_2_1;
  wire       [1:0]    _zz__zz_maskProposal_0_2_2;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_maskProposal_0;
  wire       [3:0]    _zz_maskProposal_0_1;
  wire       [3:0]    _zz_maskProposal_0_2;
  wire       [1:0]    _zz_maskProposal_0_3;
  wire                io_output_fire;
  wire                _zz_io_chosen;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = {maskLocked_0,maskLocked_1};
  assign _zz__zz_maskProposal_0_2_1 = {2'd0, _zz__zz_maskProposal_0_2_2};
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_maskProposal_0 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[3 : 2] | _zz_maskProposal_0_2[1 : 0]);
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign maskProposal_1 = _zz_maskProposal_0_3[1];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_id = (maskRouted_0 ? io_inputs_0_payload_id : io_inputs_1_payload_id);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_burst = (maskRouted_0 ? io_inputs_0_payload_burst : io_inputs_1_payload_burst);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_io_chosen = io_chosenOH[1];
  assign io_chosen = _zz_io_chosen;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module Axi4SharedSdramCtrl (
  input  wire          io_axi_arw_valid,
  output reg           io_axi_arw_ready,
  input  wire [27:0]   io_axi_arw_payload_addr,
  input  wire [6:0]    io_axi_arw_payload_id,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [1:0]    io_axi_arw_payload_burst,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [6:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire [6:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire [12:0]   io_sdram_ADDR,
  output wire [1:0]    io_sdram_BA,
  input  wire [31:0]   io_sdram_DQ_read,
  output wire [31:0]   io_sdram_DQ_write,
  output wire [31:0]   io_sdram_DQ_writeEnable,
  output wire [3:0]    io_sdram_DQM,
  output wire          io_sdram_CASn,
  output wire          io_sdram_CKE,
  output wire [1:0]    io_sdram_CSn,
  output wire          io_sdram_RASn,
  output wire          io_sdram_WEn,
  input  wire          clk,
  input  wire          reset
);

  wire       [25:0]   ctrl_io_bus_cmd_payload_address;
  wire                ctrl_io_bus_cmd_ready;
  wire                ctrl_io_bus_rsp_valid;
  wire       [31:0]   ctrl_io_bus_rsp_payload_data;
  wire       [6:0]    ctrl_io_bus_rsp_payload_context_id;
  wire                ctrl_io_bus_rsp_payload_context_last;
  wire       [12:0]   ctrl_io_sdram_ADDR;
  wire       [1:0]    ctrl_io_sdram_BA;
  wire                ctrl_io_sdram_CASn;
  wire                ctrl_io_sdram_CKE;
  wire       [1:0]    ctrl_io_sdram_CSn;
  wire       [3:0]    ctrl_io_sdram_DQM;
  wire                ctrl_io_sdram_RASn;
  wire                ctrl_io_sdram_WEn;
  wire       [31:0]   ctrl_io_sdram_DQ_write;
  wire       [31:0]   ctrl_io_sdram_DQ_writeEnable;
  wire       [1:0]    _zz_Axi4Incr_alignMask;
  wire       [11:0]   _zz_Axi4Incr_base;
  wire       [11:0]   _zz_Axi4Incr_base_1;
  wire       [11:0]   _zz_Axi4Incr_baseIncr;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_1;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_2;
  reg        [11:0]   _zz_Axi4Incr_result;
  wire       [10:0]   _zz_Axi4Incr_result_1;
  wire       [0:0]    _zz_Axi4Incr_result_2;
  wire       [9:0]    _zz_Axi4Incr_result_3;
  wire       [1:0]    _zz_Axi4Incr_result_4;
  wire       [8:0]    _zz_Axi4Incr_result_5;
  wire       [2:0]    _zz_Axi4Incr_result_6;
  wire       [7:0]    _zz_Axi4Incr_result_7;
  wire       [3:0]    _zz_Axi4Incr_result_8;
  wire       [6:0]    _zz_Axi4Incr_result_9;
  wire       [4:0]    _zz_Axi4Incr_result_10;
  wire       [5:0]    _zz_Axi4Incr_result_11;
  wire       [5:0]    _zz_Axi4Incr_result_12;
  reg                 unburstify_result_valid;
  wire                unburstify_result_ready;
  reg                 unburstify_result_payload_last;
  reg        [27:0]   unburstify_result_payload_fragment_addr;
  reg        [6:0]    unburstify_result_payload_fragment_id;
  reg        [2:0]    unburstify_result_payload_fragment_size;
  reg        [1:0]    unburstify_result_payload_fragment_burst;
  reg                 unburstify_result_payload_fragment_write;
  wire                unburstify_doResult;
  reg                 unburstify_buffer_valid;
  reg        [7:0]    unburstify_buffer_len;
  reg        [7:0]    unburstify_buffer_beat;
  reg        [27:0]   unburstify_buffer_transaction_addr;
  reg        [6:0]    unburstify_buffer_transaction_id;
  reg        [2:0]    unburstify_buffer_transaction_size;
  reg        [1:0]    unburstify_buffer_transaction_burst;
  reg                 unburstify_buffer_transaction_write;
  wire                unburstify_buffer_last;
  wire       [1:0]    Axi4Incr_validSize;
  reg        [27:0]   Axi4Incr_result;
  wire       [15:0]   Axi4Incr_highCat;
  wire       [2:0]    Axi4Incr_sizeValue;
  wire       [11:0]   Axi4Incr_alignMask;
  wire       [11:0]   Axi4Incr_base;
  wire       [11:0]   Axi4Incr_baseIncr;
  reg        [1:0]    _zz_Axi4Incr_wrapCase;
  wire       [2:0]    Axi4Incr_wrapCase;
  wire                when_Axi4Channel_l322;
  wire                _zz_unburstify_result_ready;
  wire                bridge_axiCmd_valid;
  wire                bridge_axiCmd_ready;
  wire                bridge_axiCmd_payload_last;
  wire       [27:0]   bridge_axiCmd_payload_fragment_addr;
  wire       [6:0]    bridge_axiCmd_payload_fragment_id;
  wire       [2:0]    bridge_axiCmd_payload_fragment_size;
  wire       [1:0]    bridge_axiCmd_payload_fragment_burst;
  wire                bridge_axiCmd_payload_fragment_write;
  wire                bridge_writeRsp_valid;
  reg                 bridge_writeRsp_ready;
  wire       [6:0]    bridge_writeRsp_payload_id;
  wire       [1:0]    bridge_writeRsp_payload_resp;
  wire                bridge_axiCmd_fire;
  wire                bridge_writeRsp_m2sPipe_valid;
  wire                bridge_writeRsp_m2sPipe_ready;
  wire       [6:0]    bridge_writeRsp_m2sPipe_payload_id;
  wire       [1:0]    bridge_writeRsp_m2sPipe_payload_resp;
  reg                 bridge_writeRsp_rValid;
  reg        [6:0]    bridge_writeRsp_rData_id;
  reg        [1:0]    bridge_writeRsp_rData_resp;
  wire                when_Stream_l369;

  assign _zz_Axi4Incr_alignMask = {(2'b01 < Axi4Incr_validSize),(2'b00 < Axi4Incr_validSize)};
  assign _zz_Axi4Incr_base_1 = unburstify_buffer_transaction_addr[11 : 0];
  assign _zz_Axi4Incr_base = _zz_Axi4Incr_base_1;
  assign _zz_Axi4Incr_baseIncr = {9'd0, Axi4Incr_sizeValue};
  assign _zz_Axi4Incr_wrapCase_1 = {1'd0, Axi4Incr_validSize};
  assign _zz_Axi4Incr_wrapCase_2 = {1'd0, _zz_Axi4Incr_wrapCase};
  assign _zz_Axi4Incr_result_1 = Axi4Incr_base[11 : 1];
  assign _zz_Axi4Incr_result_2 = Axi4Incr_baseIncr[0 : 0];
  assign _zz_Axi4Incr_result_3 = Axi4Incr_base[11 : 2];
  assign _zz_Axi4Incr_result_4 = Axi4Incr_baseIncr[1 : 0];
  assign _zz_Axi4Incr_result_5 = Axi4Incr_base[11 : 3];
  assign _zz_Axi4Incr_result_6 = Axi4Incr_baseIncr[2 : 0];
  assign _zz_Axi4Incr_result_7 = Axi4Incr_base[11 : 4];
  assign _zz_Axi4Incr_result_8 = Axi4Incr_baseIncr[3 : 0];
  assign _zz_Axi4Incr_result_9 = Axi4Incr_base[11 : 5];
  assign _zz_Axi4Incr_result_10 = Axi4Incr_baseIncr[4 : 0];
  assign _zz_Axi4Incr_result_11 = Axi4Incr_base[11 : 6];
  assign _zz_Axi4Incr_result_12 = Axi4Incr_baseIncr[5 : 0];
  SdramCtrl ctrl (
    .io_bus_cmd_valid                (bridge_axiCmd_valid                    ), //i
    .io_bus_cmd_ready                (ctrl_io_bus_cmd_ready                  ), //o
    .io_bus_cmd_payload_address      (ctrl_io_bus_cmd_payload_address[25:0]  ), //i
    .io_bus_cmd_payload_write        (bridge_axiCmd_payload_fragment_write   ), //i
    .io_bus_cmd_payload_data         (io_axi_w_payload_data[31:0]            ), //i
    .io_bus_cmd_payload_mask         (io_axi_w_payload_strb[3:0]             ), //i
    .io_bus_cmd_payload_context_id   (bridge_axiCmd_payload_fragment_id[6:0] ), //i
    .io_bus_cmd_payload_context_last (bridge_axiCmd_payload_last             ), //i
    .io_bus_rsp_valid                (ctrl_io_bus_rsp_valid                  ), //o
    .io_bus_rsp_ready                (io_axi_r_ready                         ), //i
    .io_bus_rsp_payload_data         (ctrl_io_bus_rsp_payload_data[31:0]     ), //o
    .io_bus_rsp_payload_context_id   (ctrl_io_bus_rsp_payload_context_id[6:0]), //o
    .io_bus_rsp_payload_context_last (ctrl_io_bus_rsp_payload_context_last   ), //o
    .io_sdram_ADDR                   (ctrl_io_sdram_ADDR[12:0]               ), //o
    .io_sdram_BA                     (ctrl_io_sdram_BA[1:0]                  ), //o
    .io_sdram_DQ_read                (io_sdram_DQ_read[31:0]                 ), //i
    .io_sdram_DQ_write               (ctrl_io_sdram_DQ_write[31:0]           ), //o
    .io_sdram_DQ_writeEnable         (ctrl_io_sdram_DQ_writeEnable[31:0]     ), //o
    .io_sdram_DQM                    (ctrl_io_sdram_DQM[3:0]                 ), //o
    .io_sdram_CASn                   (ctrl_io_sdram_CASn                     ), //o
    .io_sdram_CKE                    (ctrl_io_sdram_CKE                      ), //o
    .io_sdram_CSn                    (ctrl_io_sdram_CSn[1:0]                 ), //o
    .io_sdram_RASn                   (ctrl_io_sdram_RASn                     ), //o
    .io_sdram_WEn                    (ctrl_io_sdram_WEn                      ), //o
    .clk                             (clk                                    ), //i
    .reset                           (reset                                  )  //i
  );
  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_1,_zz_Axi4Incr_result_2};
      3'b001 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_3,_zz_Axi4Incr_result_4};
      3'b010 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_5,_zz_Axi4Incr_result_6};
      3'b011 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_7,_zz_Axi4Incr_result_8};
      3'b100 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_9,_zz_Axi4Incr_result_10};
      default : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_11,_zz_Axi4Incr_result_12};
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == 8'h01);
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_highCat = unburstify_buffer_transaction_addr[27 : 12];
  assign Axi4Incr_sizeValue = {(2'b10 == Axi4Incr_validSize),{(2'b01 == Axi4Incr_validSize),(2'b00 == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_Axi4Incr_alignMask};
  assign Axi4Incr_base = (_zz_Axi4Incr_base & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_Axi4Incr_baseIncr);
  always @(*) begin
    casez(unburstify_buffer_len)
      8'b????1??? : begin
        _zz_Axi4Incr_wrapCase = 2'b11;
      end
      8'b????01?? : begin
        _zz_Axi4Incr_wrapCase = 2'b10;
      end
      8'b????001? : begin
        _zz_Axi4Incr_wrapCase = 2'b01;
      end
      default : begin
        _zz_Axi4Incr_wrapCase = 2'b00;
      end
    endcase
  end

  assign Axi4Incr_wrapCase = (_zz_Axi4Incr_wrapCase_1 + _zz_Axi4Incr_wrapCase_2);
  always @(*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        Axi4Incr_result = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        Axi4Incr_result = {Axi4Incr_highCat,_zz_Axi4Incr_result};
      end
      default : begin
        Axi4Incr_result = {Axi4Incr_highCat,Axi4Incr_baseIncr};
      end
    endcase
  end

  always @(*) begin
    io_axi_arw_ready = 1'b0;
    if(!unburstify_buffer_valid) begin
      io_axi_arw_ready = unburstify_result_ready;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_valid = 1'b1;
    end else begin
      unburstify_result_valid = io_axi_arw_valid;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_last = unburstify_buffer_last;
    end else begin
      unburstify_result_payload_last = 1'b1;
      if(when_Axi4Channel_l322) begin
        unburstify_result_payload_last = 1'b0;
      end
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      unburstify_result_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      unburstify_result_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      unburstify_result_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      unburstify_result_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_addr = Axi4Incr_result;
    end else begin
      unburstify_result_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign when_Axi4Channel_l322 = (io_axi_arw_payload_len != 8'h00);
  assign _zz_unburstify_result_ready = (! (unburstify_result_payload_fragment_write && (! io_axi_w_valid)));
  assign bridge_axiCmd_valid = (unburstify_result_valid && _zz_unburstify_result_ready);
  assign unburstify_result_ready = (bridge_axiCmd_ready && _zz_unburstify_result_ready);
  assign bridge_axiCmd_payload_last = unburstify_result_payload_last;
  assign bridge_axiCmd_payload_fragment_addr = unburstify_result_payload_fragment_addr;
  assign bridge_axiCmd_payload_fragment_id = unburstify_result_payload_fragment_id;
  assign bridge_axiCmd_payload_fragment_size = unburstify_result_payload_fragment_size;
  assign bridge_axiCmd_payload_fragment_burst = unburstify_result_payload_fragment_burst;
  assign bridge_axiCmd_payload_fragment_write = unburstify_result_payload_fragment_write;
  assign ctrl_io_bus_cmd_payload_address = bridge_axiCmd_payload_fragment_addr[27 : 2];
  assign bridge_axiCmd_fire = (bridge_axiCmd_valid && bridge_axiCmd_ready);
  assign bridge_writeRsp_valid = ((bridge_axiCmd_fire && bridge_axiCmd_payload_fragment_write) && bridge_axiCmd_payload_last);
  assign bridge_writeRsp_payload_resp = 2'b00;
  assign bridge_writeRsp_payload_id = bridge_axiCmd_payload_fragment_id;
  always @(*) begin
    bridge_writeRsp_ready = bridge_writeRsp_m2sPipe_ready;
    if(when_Stream_l369) begin
      bridge_writeRsp_ready = 1'b1;
    end
  end

  assign when_Stream_l369 = (! bridge_writeRsp_m2sPipe_valid);
  assign bridge_writeRsp_m2sPipe_valid = bridge_writeRsp_rValid;
  assign bridge_writeRsp_m2sPipe_payload_id = bridge_writeRsp_rData_id;
  assign bridge_writeRsp_m2sPipe_payload_resp = bridge_writeRsp_rData_resp;
  assign io_axi_b_valid = bridge_writeRsp_m2sPipe_valid;
  assign bridge_writeRsp_m2sPipe_ready = io_axi_b_ready;
  assign io_axi_b_payload_id = bridge_writeRsp_m2sPipe_payload_id;
  assign io_axi_b_payload_resp = bridge_writeRsp_m2sPipe_payload_resp;
  assign io_axi_r_valid = ctrl_io_bus_rsp_valid;
  assign io_axi_r_payload_id = ctrl_io_bus_rsp_payload_context_id;
  assign io_axi_r_payload_data = ctrl_io_bus_rsp_payload_data;
  assign io_axi_r_payload_last = ctrl_io_bus_rsp_payload_context_last;
  assign io_axi_r_payload_resp = 2'b00;
  assign io_axi_w_ready = ((unburstify_result_valid && unburstify_result_payload_fragment_write) && bridge_axiCmd_ready);
  assign bridge_axiCmd_ready = (ctrl_io_bus_cmd_ready && (! (bridge_axiCmd_payload_fragment_write && (! bridge_writeRsp_ready))));
  assign io_sdram_ADDR = ctrl_io_sdram_ADDR;
  assign io_sdram_BA = ctrl_io_sdram_BA;
  assign io_sdram_DQ_write = ctrl_io_sdram_DQ_write;
  assign io_sdram_DQ_writeEnable = ctrl_io_sdram_DQ_writeEnable;
  assign io_sdram_DQM = ctrl_io_sdram_DQM;
  assign io_sdram_CASn = ctrl_io_sdram_CASn;
  assign io_sdram_CKE = ctrl_io_sdram_CKE;
  assign io_sdram_CSn = ctrl_io_sdram_CSn;
  assign io_sdram_RASn = ctrl_io_sdram_RASn;
  assign io_sdram_WEn = ctrl_io_sdram_WEn;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      unburstify_buffer_valid <= 1'b0;
      bridge_writeRsp_rValid <= 1'b0;
    end else begin
      if(unburstify_result_ready) begin
        if(unburstify_buffer_last) begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(!unburstify_buffer_valid) begin
        if(when_Axi4Channel_l322) begin
          if(unburstify_result_ready) begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(bridge_writeRsp_ready) begin
        bridge_writeRsp_rValid <= bridge_writeRsp_valid;
      end
    end
  end

  always @(posedge clk) begin
    if(unburstify_result_ready) begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - 8'h01);
      unburstify_buffer_transaction_addr[11 : 0] <= Axi4Incr_result[11 : 0];
    end
    if(!unburstify_buffer_valid) begin
      if(when_Axi4Channel_l322) begin
        if(unburstify_result_ready) begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(bridge_writeRsp_ready) begin
      bridge_writeRsp_rData_id <= bridge_writeRsp_payload_id;
      bridge_writeRsp_rData_resp <= bridge_writeRsp_payload_resp;
    end
  end


endmodule

module SdramCtrl (
  input  wire          io_bus_cmd_valid,
  output reg           io_bus_cmd_ready,
  input  wire [25:0]   io_bus_cmd_payload_address,
  input  wire          io_bus_cmd_payload_write,
  input  wire [31:0]   io_bus_cmd_payload_data,
  input  wire [3:0]    io_bus_cmd_payload_mask,
  input  wire [6:0]    io_bus_cmd_payload_context_id,
  input  wire          io_bus_cmd_payload_context_last,
  output wire          io_bus_rsp_valid,
  input  wire          io_bus_rsp_ready,
  output wire [31:0]   io_bus_rsp_payload_data,
  output wire [6:0]    io_bus_rsp_payload_context_id,
  output wire          io_bus_rsp_payload_context_last,
  output wire [12:0]   io_sdram_ADDR,
  output wire [1:0]    io_sdram_BA,
  input  wire [31:0]   io_sdram_DQ_read,
  output wire [31:0]   io_sdram_DQ_write,
  output wire [31:0]   io_sdram_DQ_writeEnable,
  output wire [3:0]    io_sdram_DQM,
  output wire          io_sdram_CASn,
  output wire          io_sdram_CKE,
  output wire [1:0]    io_sdram_CSn,
  output wire          io_sdram_RASn,
  output wire          io_sdram_WEn,
  input  wire          clk,
  input  wire          reset
);
  localparam SdramCtrlBackendTask_MODE = 3'd0;
  localparam SdramCtrlBackendTask_PRECHARGE_ALL = 3'd1;
  localparam SdramCtrlBackendTask_PRECHARGE_SINGLE = 3'd2;
  localparam SdramCtrlBackendTask_REFRESH = 3'd3;
  localparam SdramCtrlBackendTask_ACTIVE = 3'd4;
  localparam SdramCtrlBackendTask_READ = 3'd5;
  localparam SdramCtrlBackendTask_WRITE = 3'd6;
  localparam SdramCtrlFrontendState_BOOT_PRECHARGE = 2'd0;
  localparam SdramCtrlFrontendState_BOOT_REFRESH = 2'd1;
  localparam SdramCtrlFrontendState_BOOT_MODE = 2'd2;
  localparam SdramCtrlFrontendState_RUN = 2'd3;

  wire                chip_backupIn_fifo_io_flush;
  wire                chip_backupIn_fifo_io_push_ready;
  wire                chip_backupIn_fifo_io_pop_valid;
  wire       [31:0]   chip_backupIn_fifo_io_pop_payload_data;
  wire       [6:0]    chip_backupIn_fifo_io_pop_payload_context_id;
  wire                chip_backupIn_fifo_io_pop_payload_context_last;
  wire       [1:0]    chip_backupIn_fifo_io_occupancy;
  wire       [1:0]    chip_backupIn_fifo_io_availability;
  wire       [10:0]   _zz_refresh_counter_valueNext;
  wire       [0:0]    _zz_refresh_counter_valueNext_1;
  wire       [1:0]    _zz_frontend_rsp_payload_cs_1;
  wire       [2:0]    _zz_frontend_bootRefreshCounter_valueNext;
  wire       [0:0]    _zz_frontend_bootRefreshCounter_valueNext_1;
  reg                 _zz__zz_when_SdramCtrl_l229;
  reg                 _zz__zz_when_SdramCtrl_l229_1;
  reg                 _zz__zz_when_SdramCtrl_l229_2;
  reg                 _zz__zz_when_SdramCtrl_l229_3;
  reg                 _zz__zz_when_SdramCtrl_l229_4;
  reg        [12:0]   _zz_when_SdramCtrl_l229_1;
  reg        [12:0]   _zz_when_SdramCtrl_l229_2;
  reg        [12:0]   _zz_when_SdramCtrl_l229_3;
  reg        [12:0]   _zz_when_SdramCtrl_l229_4;
  reg        [12:0]   _zz_when_SdramCtrl_l229_5;
  reg                 _zz_bubbleInserter_insertBubble;
  reg                 _zz_bubbleInserter_insertBubble_1;
  wire                refresh_counter_willIncrement;
  wire                refresh_counter_willClear;
  reg        [10:0]   refresh_counter_valueNext;
  reg        [10:0]   refresh_counter_value;
  wire                refresh_counter_willOverflowIfInc;
  wire                refresh_counter_willOverflow;
  reg                 refresh_pending;
  reg        [13:0]   powerup_counter;
  reg                 powerup_done;
  wire                when_SdramCtrl_l147;
  wire       [13:0]   _zz_when_SdramCtrl_l149;
  wire                when_SdramCtrl_l149;
  reg                 frontend_banks_0_0_active;
  reg        [12:0]   frontend_banks_0_0_row;
  reg                 frontend_banks_0_1_active;
  reg        [12:0]   frontend_banks_0_1_row;
  reg                 frontend_banks_0_2_active;
  reg        [12:0]   frontend_banks_0_2_row;
  reg                 frontend_banks_0_3_active;
  reg        [12:0]   frontend_banks_0_3_row;
  reg                 frontend_banks_1_0_active;
  reg        [12:0]   frontend_banks_1_0_row;
  reg                 frontend_banks_1_1_active;
  reg        [12:0]   frontend_banks_1_1_row;
  reg                 frontend_banks_1_2_active;
  reg        [12:0]   frontend_banks_1_2_row;
  reg                 frontend_banks_1_3_active;
  reg        [12:0]   frontend_banks_1_3_row;
  wire       [9:0]    frontend_address_column;
  wire       [1:0]    frontend_address_bank;
  wire       [12:0]   frontend_address_row;
  wire       [0:0]    frontend_address_chip;
  wire       [25:0]   _zz_frontend_address_column;
  reg                 frontend_rsp_valid;
  reg                 frontend_rsp_ready;
  reg        [2:0]    frontend_rsp_payload_task;
  wire       [1:0]    frontend_rsp_payload_bank;
  reg        [12:0]   frontend_rsp_payload_rowColumn;
  wire       [31:0]   frontend_rsp_payload_data;
  wire       [3:0]    frontend_rsp_payload_mask;
  wire       [6:0]    frontend_rsp_payload_context_id;
  wire                frontend_rsp_payload_context_last;
  wire       [1:0]    frontend_rsp_payload_cs;
  reg        [1:0]    _zz_frontend_rsp_payload_cs;
  reg        [1:0]    frontend_state;
  reg                 frontend_bootRefreshCounter_willIncrement;
  wire                frontend_bootRefreshCounter_willClear;
  reg        [2:0]    frontend_bootRefreshCounter_valueNext;
  reg        [2:0]    frontend_bootRefreshCounter_value;
  wire                frontend_bootRefreshCounter_willOverflowIfInc;
  wire                frontend_bootRefreshCounter_willOverflow;
  wire                when_SdramCtrl_l214;
  wire       [1:0]    _zz_1;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_when_SdramCtrl_l229;
  wire       [3:0]    _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
  wire                _zz_8;
  wire                when_SdramCtrl_l229;
  wire       [2:0]    _zz_frontend_rsp_payload_task;
  wire                when_SdramCtrl_l234;
  wire                bubbleInserter_cmd_valid;
  wire                bubbleInserter_cmd_ready;
  wire       [2:0]    bubbleInserter_cmd_payload_task;
  wire       [1:0]    bubbleInserter_cmd_payload_bank;
  wire       [12:0]   bubbleInserter_cmd_payload_rowColumn;
  wire       [31:0]   bubbleInserter_cmd_payload_data;
  wire       [3:0]    bubbleInserter_cmd_payload_mask;
  wire       [6:0]    bubbleInserter_cmd_payload_context_id;
  wire                bubbleInserter_cmd_payload_context_last;
  wire       [1:0]    bubbleInserter_cmd_payload_cs;
  reg                 frontend_rsp_rValid;
  reg        [2:0]    frontend_rsp_rData_task;
  reg        [1:0]    frontend_rsp_rData_bank;
  reg        [12:0]   frontend_rsp_rData_rowColumn;
  reg        [31:0]   frontend_rsp_rData_data;
  reg        [3:0]    frontend_rsp_rData_mask;
  reg        [6:0]    frontend_rsp_rData_context_id;
  reg                 frontend_rsp_rData_context_last;
  reg        [1:0]    frontend_rsp_rData_cs;
  wire                when_Stream_l369;
  wire                bubbleInserter_rsp_valid;
  wire                bubbleInserter_rsp_ready;
  wire       [2:0]    bubbleInserter_rsp_payload_task;
  wire       [1:0]    bubbleInserter_rsp_payload_bank;
  wire       [12:0]   bubbleInserter_rsp_payload_rowColumn;
  wire       [31:0]   bubbleInserter_rsp_payload_data;
  wire       [3:0]    bubbleInserter_rsp_payload_mask;
  wire       [6:0]    bubbleInserter_rsp_payload_context_id;
  wire                bubbleInserter_rsp_payload_context_last;
  wire       [1:0]    bubbleInserter_rsp_payload_cs;
  reg                 bubbleInserter_insertBubble;
  wire                _zz_bubbleInserter_cmd_ready;
  wire       [2:0]    _zz_bubbleInserter_rsp_payload_task;
  reg        [1:0]    bubbleInserter_timings_read_counter;
  wire                bubbleInserter_timings_read_busy;
  wire                when_SdramCtrl_l260;
  reg        [1:0]    bubbleInserter_timings_write_counter;
  wire                bubbleInserter_timings_write_busy;
  wire                when_SdramCtrl_l260_1;
  reg        [2:0]    bubbleInserter_timings_banks_0_precharge_counter;
  wire                bubbleInserter_timings_banks_0_precharge_busy;
  wire                when_SdramCtrl_l260_2;
  reg        [3:0]    bubbleInserter_timings_banks_0_active_counter;
  wire                bubbleInserter_timings_banks_0_active_busy;
  wire                when_SdramCtrl_l260_3;
  reg        [2:0]    bubbleInserter_timings_banks_1_precharge_counter;
  wire                bubbleInserter_timings_banks_1_precharge_busy;
  wire                when_SdramCtrl_l260_4;
  reg        [3:0]    bubbleInserter_timings_banks_1_active_counter;
  wire                bubbleInserter_timings_banks_1_active_busy;
  wire                when_SdramCtrl_l260_5;
  reg        [2:0]    bubbleInserter_timings_banks_2_precharge_counter;
  wire                bubbleInserter_timings_banks_2_precharge_busy;
  wire                when_SdramCtrl_l260_6;
  reg        [3:0]    bubbleInserter_timings_banks_2_active_counter;
  wire                bubbleInserter_timings_banks_2_active_busy;
  wire                when_SdramCtrl_l260_7;
  reg        [2:0]    bubbleInserter_timings_banks_3_precharge_counter;
  wire                bubbleInserter_timings_banks_3_precharge_busy;
  wire                when_SdramCtrl_l260_8;
  reg        [3:0]    bubbleInserter_timings_banks_3_active_counter;
  wire                bubbleInserter_timings_banks_3_active_busy;
  wire                when_SdramCtrl_l260_9;
  wire                when_SdramCtrl_l269;
  wire                when_SdramCtrl_l269_1;
  wire                when_SdramCtrl_l269_2;
  wire                when_SdramCtrl_l269_3;
  wire                when_SdramCtrl_l269_4;
  wire                when_Utils_l1048;
  wire                when_SdramCtrl_l269_5;
  wire                when_Utils_l1048_1;
  wire                when_SdramCtrl_l269_6;
  wire                when_Utils_l1048_2;
  wire                when_SdramCtrl_l269_7;
  wire                when_Utils_l1048_3;
  wire                when_SdramCtrl_l269_8;
  wire                when_SdramCtrl_l269_9;
  wire                when_SdramCtrl_l269_10;
  wire                when_SdramCtrl_l269_11;
  wire                when_SdramCtrl_l269_12;
  wire                when_SdramCtrl_l269_13;
  wire                when_Utils_l1048_4;
  wire                when_SdramCtrl_l269_14;
  wire                when_Utils_l1048_5;
  wire                when_SdramCtrl_l269_15;
  wire                when_Utils_l1048_6;
  wire                when_SdramCtrl_l269_16;
  wire                when_Utils_l1048_7;
  wire                when_SdramCtrl_l269_17;
  wire                when_Utils_l1048_8;
  wire                when_SdramCtrl_l269_18;
  wire                when_Utils_l1048_9;
  wire                when_SdramCtrl_l269_19;
  wire                when_Utils_l1048_10;
  wire                when_SdramCtrl_l269_20;
  wire                when_Utils_l1048_11;
  wire                when_SdramCtrl_l269_21;
  wire                when_SdramCtrl_l269_22;
  wire                when_Utils_l1048_12;
  wire                when_SdramCtrl_l269_23;
  wire                when_Utils_l1048_13;
  wire                when_SdramCtrl_l269_24;
  wire                when_Utils_l1048_14;
  wire                when_SdramCtrl_l269_25;
  wire                when_Utils_l1048_15;
  wire                when_SdramCtrl_l269_26;
  wire                chip_cmd_valid;
  wire                chip_cmd_ready;
  wire       [2:0]    chip_cmd_payload_task;
  wire       [1:0]    chip_cmd_payload_bank;
  wire       [12:0]   chip_cmd_payload_rowColumn;
  wire       [31:0]   chip_cmd_payload_data;
  wire       [3:0]    chip_cmd_payload_mask;
  wire       [6:0]    chip_cmd_payload_context_id;
  wire                chip_cmd_payload_context_last;
  wire       [1:0]    chip_cmd_payload_cs;
  reg        [12:0]   chip_sdram_ADDR;
  reg        [1:0]    chip_sdram_BA;
  reg        [31:0]   chip_sdram_DQ_read;
  reg        [31:0]   chip_sdram_DQ_write;
  reg        [31:0]   chip_sdram_DQ_writeEnable;
  reg        [3:0]    chip_sdram_DQM;
  reg                 chip_sdram_CASn;
  reg                 chip_sdram_CKE;
  reg        [1:0]    chip_sdram_CSn;
  reg                 chip_sdram_RASn;
  reg                 chip_sdram_WEn;
  wire                chip_remoteCke;
  wire                chip_readHistory_0;
  wire                chip_readHistory_1;
  wire                chip_readHistory_2;
  wire                chip_readHistory_3;
  wire                chip_readHistory_4;
  wire                _zz_chip_readHistory_0;
  reg                 _zz_chip_readHistory_1;
  reg                 _zz_chip_readHistory_2;
  reg                 _zz_chip_readHistory_3;
  reg                 _zz_chip_readHistory_4;
  reg        [6:0]    chip_cmd_payload_context_delay_1_id;
  reg                 chip_cmd_payload_context_delay_1_last;
  reg        [6:0]    chip_cmd_payload_context_delay_2_id;
  reg                 chip_cmd_payload_context_delay_2_last;
  reg        [6:0]    chip_cmd_payload_context_delay_3_id;
  reg                 chip_cmd_payload_context_delay_3_last;
  reg        [6:0]    chip_contextDelayed_id;
  reg                 chip_contextDelayed_last;
  wire                chip_sdramCkeNext;
  reg                 chip_sdramCkeInternal;
  reg                 chip_sdramCkeInternal_regNext;
  wire                _zz_chip_sdram_DQM;
  wire                chip_backupIn_valid;
  wire                chip_backupIn_ready;
  wire       [31:0]   chip_backupIn_payload_data;
  wire       [6:0]    chip_backupIn_payload_context_id;
  wire                chip_backupIn_payload_context_last;
  `ifndef SYNTHESIS
  reg [127:0] frontend_rsp_payload_task_string;
  reg [111:0] frontend_state_string;
  reg [127:0] _zz_frontend_rsp_payload_task_string;
  reg [127:0] bubbleInserter_cmd_payload_task_string;
  reg [127:0] frontend_rsp_rData_task_string;
  reg [127:0] bubbleInserter_rsp_payload_task_string;
  reg [127:0] _zz_bubbleInserter_rsp_payload_task_string;
  reg [127:0] chip_cmd_payload_task_string;
  `endif

  function [1:0] zz__zz_frontend_rsp_payload_cs(input dummy);
    begin
      zz__zz_frontend_rsp_payload_cs = 2'b00;
      zz__zz_frontend_rsp_payload_cs[0] = 1'b1;
    end
  endfunction
  wire [1:0] _zz_9;

  assign _zz_refresh_counter_valueNext_1 = refresh_counter_willIncrement;
  assign _zz_refresh_counter_valueNext = {10'd0, _zz_refresh_counter_valueNext_1};
  assign _zz_frontend_rsp_payload_cs_1 = (_zz_frontend_rsp_payload_cs <<< frontend_address_chip);
  assign _zz_frontend_bootRefreshCounter_valueNext_1 = frontend_bootRefreshCounter_willIncrement;
  assign _zz_frontend_bootRefreshCounter_valueNext = {2'd0, _zz_frontend_bootRefreshCounter_valueNext_1};
  StreamFifoLowLatency chip_backupIn_fifo (
    .io_push_valid                (chip_backupIn_valid                              ), //i
    .io_push_ready                (chip_backupIn_fifo_io_push_ready                 ), //o
    .io_push_payload_data         (chip_backupIn_payload_data[31:0]                 ), //i
    .io_push_payload_context_id   (chip_backupIn_payload_context_id[6:0]            ), //i
    .io_push_payload_context_last (chip_backupIn_payload_context_last               ), //i
    .io_pop_valid                 (chip_backupIn_fifo_io_pop_valid                  ), //o
    .io_pop_ready                 (io_bus_rsp_ready                                 ), //i
    .io_pop_payload_data          (chip_backupIn_fifo_io_pop_payload_data[31:0]     ), //o
    .io_pop_payload_context_id    (chip_backupIn_fifo_io_pop_payload_context_id[6:0]), //o
    .io_pop_payload_context_last  (chip_backupIn_fifo_io_pop_payload_context_last   ), //o
    .io_flush                     (chip_backupIn_fifo_io_flush                      ), //i
    .io_occupancy                 (chip_backupIn_fifo_io_occupancy[1:0]             ), //o
    .io_availability              (chip_backupIn_fifo_io_availability[1:0]          ), //o
    .clk                          (clk                                              ), //i
    .reset                        (reset                                            )  //i
  );
  always @(*) begin
    case(frontend_address_bank)
      2'b00 : begin
        _zz__zz_when_SdramCtrl_l229 = _zz__zz_when_SdramCtrl_l229_1;
        _zz_when_SdramCtrl_l229_1 = _zz_when_SdramCtrl_l229_2;
      end
      2'b01 : begin
        _zz__zz_when_SdramCtrl_l229 = _zz__zz_when_SdramCtrl_l229_2;
        _zz_when_SdramCtrl_l229_1 = _zz_when_SdramCtrl_l229_3;
      end
      2'b10 : begin
        _zz__zz_when_SdramCtrl_l229 = _zz__zz_when_SdramCtrl_l229_3;
        _zz_when_SdramCtrl_l229_1 = _zz_when_SdramCtrl_l229_4;
      end
      default : begin
        _zz__zz_when_SdramCtrl_l229 = _zz__zz_when_SdramCtrl_l229_4;
        _zz_when_SdramCtrl_l229_1 = _zz_when_SdramCtrl_l229_5;
      end
    endcase
  end

  always @(*) begin
    case(frontend_address_chip)
      1'b0 : begin
        _zz__zz_when_SdramCtrl_l229_1 = frontend_banks_0_0_active;
        _zz__zz_when_SdramCtrl_l229_2 = frontend_banks_0_1_active;
        _zz__zz_when_SdramCtrl_l229_3 = frontend_banks_0_2_active;
        _zz__zz_when_SdramCtrl_l229_4 = frontend_banks_0_3_active;
        _zz_when_SdramCtrl_l229_2 = frontend_banks_0_0_row;
        _zz_when_SdramCtrl_l229_3 = frontend_banks_0_1_row;
        _zz_when_SdramCtrl_l229_4 = frontend_banks_0_2_row;
        _zz_when_SdramCtrl_l229_5 = frontend_banks_0_3_row;
      end
      default : begin
        _zz__zz_when_SdramCtrl_l229_1 = frontend_banks_1_0_active;
        _zz__zz_when_SdramCtrl_l229_2 = frontend_banks_1_1_active;
        _zz__zz_when_SdramCtrl_l229_3 = frontend_banks_1_2_active;
        _zz__zz_when_SdramCtrl_l229_4 = frontend_banks_1_3_active;
        _zz_when_SdramCtrl_l229_2 = frontend_banks_1_0_row;
        _zz_when_SdramCtrl_l229_3 = frontend_banks_1_1_row;
        _zz_when_SdramCtrl_l229_4 = frontend_banks_1_2_row;
        _zz_when_SdramCtrl_l229_5 = frontend_banks_1_3_row;
      end
    endcase
  end

  always @(*) begin
    case(bubbleInserter_cmd_payload_bank)
      2'b00 : begin
        _zz_bubbleInserter_insertBubble = bubbleInserter_timings_banks_0_precharge_busy;
        _zz_bubbleInserter_insertBubble_1 = bubbleInserter_timings_banks_0_active_busy;
      end
      2'b01 : begin
        _zz_bubbleInserter_insertBubble = bubbleInserter_timings_banks_1_precharge_busy;
        _zz_bubbleInserter_insertBubble_1 = bubbleInserter_timings_banks_1_active_busy;
      end
      2'b10 : begin
        _zz_bubbleInserter_insertBubble = bubbleInserter_timings_banks_2_precharge_busy;
        _zz_bubbleInserter_insertBubble_1 = bubbleInserter_timings_banks_2_active_busy;
      end
      default : begin
        _zz_bubbleInserter_insertBubble = bubbleInserter_timings_banks_3_precharge_busy;
        _zz_bubbleInserter_insertBubble_1 = bubbleInserter_timings_banks_3_active_busy;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(frontend_rsp_payload_task)
      SdramCtrlBackendTask_MODE : frontend_rsp_payload_task_string = "MODE            ";
      SdramCtrlBackendTask_PRECHARGE_ALL : frontend_rsp_payload_task_string = "PRECHARGE_ALL   ";
      SdramCtrlBackendTask_PRECHARGE_SINGLE : frontend_rsp_payload_task_string = "PRECHARGE_SINGLE";
      SdramCtrlBackendTask_REFRESH : frontend_rsp_payload_task_string = "REFRESH         ";
      SdramCtrlBackendTask_ACTIVE : frontend_rsp_payload_task_string = "ACTIVE          ";
      SdramCtrlBackendTask_READ : frontend_rsp_payload_task_string = "READ            ";
      SdramCtrlBackendTask_WRITE : frontend_rsp_payload_task_string = "WRITE           ";
      default : frontend_rsp_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(frontend_state)
      SdramCtrlFrontendState_BOOT_PRECHARGE : frontend_state_string = "BOOT_PRECHARGE";
      SdramCtrlFrontendState_BOOT_REFRESH : frontend_state_string = "BOOT_REFRESH  ";
      SdramCtrlFrontendState_BOOT_MODE : frontend_state_string = "BOOT_MODE     ";
      SdramCtrlFrontendState_RUN : frontend_state_string = "RUN           ";
      default : frontend_state_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(_zz_frontend_rsp_payload_task)
      SdramCtrlBackendTask_MODE : _zz_frontend_rsp_payload_task_string = "MODE            ";
      SdramCtrlBackendTask_PRECHARGE_ALL : _zz_frontend_rsp_payload_task_string = "PRECHARGE_ALL   ";
      SdramCtrlBackendTask_PRECHARGE_SINGLE : _zz_frontend_rsp_payload_task_string = "PRECHARGE_SINGLE";
      SdramCtrlBackendTask_REFRESH : _zz_frontend_rsp_payload_task_string = "REFRESH         ";
      SdramCtrlBackendTask_ACTIVE : _zz_frontend_rsp_payload_task_string = "ACTIVE          ";
      SdramCtrlBackendTask_READ : _zz_frontend_rsp_payload_task_string = "READ            ";
      SdramCtrlBackendTask_WRITE : _zz_frontend_rsp_payload_task_string = "WRITE           ";
      default : _zz_frontend_rsp_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(bubbleInserter_cmd_payload_task)
      SdramCtrlBackendTask_MODE : bubbleInserter_cmd_payload_task_string = "MODE            ";
      SdramCtrlBackendTask_PRECHARGE_ALL : bubbleInserter_cmd_payload_task_string = "PRECHARGE_ALL   ";
      SdramCtrlBackendTask_PRECHARGE_SINGLE : bubbleInserter_cmd_payload_task_string = "PRECHARGE_SINGLE";
      SdramCtrlBackendTask_REFRESH : bubbleInserter_cmd_payload_task_string = "REFRESH         ";
      SdramCtrlBackendTask_ACTIVE : bubbleInserter_cmd_payload_task_string = "ACTIVE          ";
      SdramCtrlBackendTask_READ : bubbleInserter_cmd_payload_task_string = "READ            ";
      SdramCtrlBackendTask_WRITE : bubbleInserter_cmd_payload_task_string = "WRITE           ";
      default : bubbleInserter_cmd_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(frontend_rsp_rData_task)
      SdramCtrlBackendTask_MODE : frontend_rsp_rData_task_string = "MODE            ";
      SdramCtrlBackendTask_PRECHARGE_ALL : frontend_rsp_rData_task_string = "PRECHARGE_ALL   ";
      SdramCtrlBackendTask_PRECHARGE_SINGLE : frontend_rsp_rData_task_string = "PRECHARGE_SINGLE";
      SdramCtrlBackendTask_REFRESH : frontend_rsp_rData_task_string = "REFRESH         ";
      SdramCtrlBackendTask_ACTIVE : frontend_rsp_rData_task_string = "ACTIVE          ";
      SdramCtrlBackendTask_READ : frontend_rsp_rData_task_string = "READ            ";
      SdramCtrlBackendTask_WRITE : frontend_rsp_rData_task_string = "WRITE           ";
      default : frontend_rsp_rData_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(bubbleInserter_rsp_payload_task)
      SdramCtrlBackendTask_MODE : bubbleInserter_rsp_payload_task_string = "MODE            ";
      SdramCtrlBackendTask_PRECHARGE_ALL : bubbleInserter_rsp_payload_task_string = "PRECHARGE_ALL   ";
      SdramCtrlBackendTask_PRECHARGE_SINGLE : bubbleInserter_rsp_payload_task_string = "PRECHARGE_SINGLE";
      SdramCtrlBackendTask_REFRESH : bubbleInserter_rsp_payload_task_string = "REFRESH         ";
      SdramCtrlBackendTask_ACTIVE : bubbleInserter_rsp_payload_task_string = "ACTIVE          ";
      SdramCtrlBackendTask_READ : bubbleInserter_rsp_payload_task_string = "READ            ";
      SdramCtrlBackendTask_WRITE : bubbleInserter_rsp_payload_task_string = "WRITE           ";
      default : bubbleInserter_rsp_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_bubbleInserter_rsp_payload_task)
      SdramCtrlBackendTask_MODE : _zz_bubbleInserter_rsp_payload_task_string = "MODE            ";
      SdramCtrlBackendTask_PRECHARGE_ALL : _zz_bubbleInserter_rsp_payload_task_string = "PRECHARGE_ALL   ";
      SdramCtrlBackendTask_PRECHARGE_SINGLE : _zz_bubbleInserter_rsp_payload_task_string = "PRECHARGE_SINGLE";
      SdramCtrlBackendTask_REFRESH : _zz_bubbleInserter_rsp_payload_task_string = "REFRESH         ";
      SdramCtrlBackendTask_ACTIVE : _zz_bubbleInserter_rsp_payload_task_string = "ACTIVE          ";
      SdramCtrlBackendTask_READ : _zz_bubbleInserter_rsp_payload_task_string = "READ            ";
      SdramCtrlBackendTask_WRITE : _zz_bubbleInserter_rsp_payload_task_string = "WRITE           ";
      default : _zz_bubbleInserter_rsp_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(chip_cmd_payload_task)
      SdramCtrlBackendTask_MODE : chip_cmd_payload_task_string = "MODE            ";
      SdramCtrlBackendTask_PRECHARGE_ALL : chip_cmd_payload_task_string = "PRECHARGE_ALL   ";
      SdramCtrlBackendTask_PRECHARGE_SINGLE : chip_cmd_payload_task_string = "PRECHARGE_SINGLE";
      SdramCtrlBackendTask_REFRESH : chip_cmd_payload_task_string = "REFRESH         ";
      SdramCtrlBackendTask_ACTIVE : chip_cmd_payload_task_string = "ACTIVE          ";
      SdramCtrlBackendTask_READ : chip_cmd_payload_task_string = "READ            ";
      SdramCtrlBackendTask_WRITE : chip_cmd_payload_task_string = "WRITE           ";
      default : chip_cmd_payload_task_string = "????????????????";
    endcase
  end
  `endif

  assign refresh_counter_willClear = 1'b0;
  assign refresh_counter_willOverflowIfInc = (refresh_counter_value == 11'h40f);
  assign refresh_counter_willOverflow = (refresh_counter_willOverflowIfInc && refresh_counter_willIncrement);
  always @(*) begin
    if(refresh_counter_willOverflow) begin
      refresh_counter_valueNext = 11'h000;
    end else begin
      refresh_counter_valueNext = (refresh_counter_value + _zz_refresh_counter_valueNext);
    end
    if(refresh_counter_willClear) begin
      refresh_counter_valueNext = 11'h000;
    end
  end

  assign refresh_counter_willIncrement = 1'b1;
  assign when_SdramCtrl_l147 = (! powerup_done);
  assign _zz_when_SdramCtrl_l149[13 : 0] = 14'h3fff;
  assign when_SdramCtrl_l149 = (powerup_counter == _zz_when_SdramCtrl_l149);
  assign _zz_frontend_address_column = io_bus_cmd_payload_address;
  assign frontend_address_column = _zz_frontend_address_column[9 : 0];
  assign frontend_address_bank = _zz_frontend_address_column[11 : 10];
  assign frontend_address_row = _zz_frontend_address_column[24 : 12];
  assign frontend_address_chip = _zz_frontend_address_column[25 : 25];
  always @(*) begin
    frontend_rsp_valid = 1'b0;
    case(frontend_state)
      SdramCtrlFrontendState_BOOT_PRECHARGE : begin
        if(powerup_done) begin
          frontend_rsp_valid = 1'b1;
        end
      end
      SdramCtrlFrontendState_BOOT_REFRESH : begin
        frontend_rsp_valid = 1'b1;
      end
      SdramCtrlFrontendState_BOOT_MODE : begin
        frontend_rsp_valid = 1'b1;
      end
      default : begin
        if(refresh_pending) begin
          frontend_rsp_valid = 1'b1;
        end else begin
          if(io_bus_cmd_valid) begin
            frontend_rsp_valid = 1'b1;
          end
        end
      end
    endcase
  end

  always @(*) begin
    frontend_rsp_payload_task = SdramCtrlBackendTask_REFRESH;
    case(frontend_state)
      SdramCtrlFrontendState_BOOT_PRECHARGE : begin
        frontend_rsp_payload_task = SdramCtrlBackendTask_PRECHARGE_ALL;
      end
      SdramCtrlFrontendState_BOOT_REFRESH : begin
        frontend_rsp_payload_task = SdramCtrlBackendTask_REFRESH;
      end
      SdramCtrlFrontendState_BOOT_MODE : begin
        frontend_rsp_payload_task = SdramCtrlBackendTask_MODE;
      end
      default : begin
        if(refresh_pending) begin
          if(when_SdramCtrl_l214) begin
            frontend_rsp_payload_task = SdramCtrlBackendTask_PRECHARGE_ALL;
          end else begin
            frontend_rsp_payload_task = SdramCtrlBackendTask_REFRESH;
          end
        end else begin
          if(io_bus_cmd_valid) begin
            if(when_SdramCtrl_l229) begin
              frontend_rsp_payload_task = SdramCtrlBackendTask_PRECHARGE_SINGLE;
            end else begin
              if(when_SdramCtrl_l234) begin
                frontend_rsp_payload_task = SdramCtrlBackendTask_ACTIVE;
              end else begin
                frontend_rsp_payload_task = _zz_frontend_rsp_payload_task;
              end
            end
          end
        end
      end
    endcase
  end

  assign frontend_rsp_payload_bank = frontend_address_bank;
  always @(*) begin
    frontend_rsp_payload_rowColumn = frontend_address_row;
    case(frontend_state)
      SdramCtrlFrontendState_BOOT_PRECHARGE : begin
      end
      SdramCtrlFrontendState_BOOT_REFRESH : begin
      end
      SdramCtrlFrontendState_BOOT_MODE : begin
      end
      default : begin
        if(!refresh_pending) begin
          if(io_bus_cmd_valid) begin
            if(!when_SdramCtrl_l229) begin
              if(!when_SdramCtrl_l234) begin
                frontend_rsp_payload_rowColumn = {3'd0, frontend_address_column};
              end
            end
          end
        end
      end
    endcase
  end

  assign frontend_rsp_payload_data = io_bus_cmd_payload_data;
  assign frontend_rsp_payload_mask = io_bus_cmd_payload_mask;
  assign frontend_rsp_payload_context_id = io_bus_cmd_payload_context_id;
  assign frontend_rsp_payload_context_last = io_bus_cmd_payload_context_last;
  assign _zz_9 = zz__zz_frontend_rsp_payload_cs(1'b0);
  always @(*) _zz_frontend_rsp_payload_cs = _zz_9;
  assign frontend_rsp_payload_cs = (~ _zz_frontend_rsp_payload_cs_1);
  always @(*) begin
    io_bus_cmd_ready = 1'b0;
    case(frontend_state)
      SdramCtrlFrontendState_BOOT_PRECHARGE : begin
      end
      SdramCtrlFrontendState_BOOT_REFRESH : begin
      end
      SdramCtrlFrontendState_BOOT_MODE : begin
      end
      default : begin
        if(!refresh_pending) begin
          if(io_bus_cmd_valid) begin
            if(!when_SdramCtrl_l229) begin
              if(!when_SdramCtrl_l234) begin
                io_bus_cmd_ready = frontend_rsp_ready;
              end
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    frontend_bootRefreshCounter_willIncrement = 1'b0;
    case(frontend_state)
      SdramCtrlFrontendState_BOOT_PRECHARGE : begin
      end
      SdramCtrlFrontendState_BOOT_REFRESH : begin
        if(frontend_rsp_ready) begin
          frontend_bootRefreshCounter_willIncrement = 1'b1;
        end
      end
      SdramCtrlFrontendState_BOOT_MODE : begin
      end
      default : begin
      end
    endcase
  end

  assign frontend_bootRefreshCounter_willClear = 1'b0;
  assign frontend_bootRefreshCounter_willOverflowIfInc = (frontend_bootRefreshCounter_value == 3'b111);
  assign frontend_bootRefreshCounter_willOverflow = (frontend_bootRefreshCounter_willOverflowIfInc && frontend_bootRefreshCounter_willIncrement);
  always @(*) begin
    frontend_bootRefreshCounter_valueNext = (frontend_bootRefreshCounter_value + _zz_frontend_bootRefreshCounter_valueNext);
    if(frontend_bootRefreshCounter_willClear) begin
      frontend_bootRefreshCounter_valueNext = 3'b000;
    end
  end

  assign when_SdramCtrl_l214 = ((((frontend_banks_0_0_active || frontend_banks_0_1_active) || frontend_banks_0_2_active) || frontend_banks_0_3_active) || (((frontend_banks_1_0_active || frontend_banks_1_1_active) || frontend_banks_1_2_active) || frontend_banks_1_3_active));
  assign _zz_1 = ({1'd0,1'b1} <<< frontend_address_chip);
  assign _zz_2 = _zz_1[0];
  assign _zz_3 = _zz_1[1];
  assign _zz_when_SdramCtrl_l229 = _zz__zz_when_SdramCtrl_l229;
  assign _zz_4 = ({3'd0,1'b1} <<< frontend_address_bank);
  assign _zz_5 = _zz_4[0];
  assign _zz_6 = _zz_4[1];
  assign _zz_7 = _zz_4[2];
  assign _zz_8 = _zz_4[3];
  assign when_SdramCtrl_l229 = (_zz_when_SdramCtrl_l229 && (_zz_when_SdramCtrl_l229_1 != frontend_address_row));
  assign _zz_frontend_rsp_payload_task = (io_bus_cmd_payload_write ? SdramCtrlBackendTask_WRITE : SdramCtrlBackendTask_READ);
  assign when_SdramCtrl_l234 = (! _zz_when_SdramCtrl_l229);
  always @(*) begin
    frontend_rsp_ready = bubbleInserter_cmd_ready;
    if(when_Stream_l369) begin
      frontend_rsp_ready = 1'b1;
    end
  end

  assign when_Stream_l369 = (! bubbleInserter_cmd_valid);
  assign bubbleInserter_cmd_valid = frontend_rsp_rValid;
  assign bubbleInserter_cmd_payload_task = frontend_rsp_rData_task;
  assign bubbleInserter_cmd_payload_bank = frontend_rsp_rData_bank;
  assign bubbleInserter_cmd_payload_rowColumn = frontend_rsp_rData_rowColumn;
  assign bubbleInserter_cmd_payload_data = frontend_rsp_rData_data;
  assign bubbleInserter_cmd_payload_mask = frontend_rsp_rData_mask;
  assign bubbleInserter_cmd_payload_context_id = frontend_rsp_rData_context_id;
  assign bubbleInserter_cmd_payload_context_last = frontend_rsp_rData_context_last;
  assign bubbleInserter_cmd_payload_cs = frontend_rsp_rData_cs;
  always @(*) begin
    bubbleInserter_insertBubble = 1'b0;
    if(bubbleInserter_cmd_valid) begin
      case(bubbleInserter_cmd_payload_task)
        SdramCtrlBackendTask_MODE : begin
          bubbleInserter_insertBubble = bubbleInserter_timings_banks_0_active_busy;
        end
        SdramCtrlBackendTask_PRECHARGE_ALL : begin
          bubbleInserter_insertBubble = ({bubbleInserter_timings_banks_3_precharge_busy,{bubbleInserter_timings_banks_2_precharge_busy,{bubbleInserter_timings_banks_1_precharge_busy,bubbleInserter_timings_banks_0_precharge_busy}}} != 4'b0000);
        end
        SdramCtrlBackendTask_PRECHARGE_SINGLE : begin
          bubbleInserter_insertBubble = _zz_bubbleInserter_insertBubble;
        end
        SdramCtrlBackendTask_REFRESH : begin
          bubbleInserter_insertBubble = ({bubbleInserter_timings_banks_3_active_busy,{bubbleInserter_timings_banks_2_active_busy,{bubbleInserter_timings_banks_1_active_busy,bubbleInserter_timings_banks_0_active_busy}}} != 4'b0000);
        end
        SdramCtrlBackendTask_ACTIVE : begin
          bubbleInserter_insertBubble = _zz_bubbleInserter_insertBubble_1;
        end
        SdramCtrlBackendTask_READ : begin
          bubbleInserter_insertBubble = bubbleInserter_timings_read_busy;
        end
        default : begin
          bubbleInserter_insertBubble = bubbleInserter_timings_write_busy;
        end
      endcase
    end
  end

  assign _zz_bubbleInserter_cmd_ready = (! bubbleInserter_insertBubble);
  assign bubbleInserter_cmd_ready = (bubbleInserter_rsp_ready && _zz_bubbleInserter_cmd_ready);
  assign _zz_bubbleInserter_rsp_payload_task = bubbleInserter_cmd_payload_task;
  assign bubbleInserter_rsp_valid = (bubbleInserter_cmd_valid && _zz_bubbleInserter_cmd_ready);
  assign bubbleInserter_rsp_payload_task = _zz_bubbleInserter_rsp_payload_task;
  assign bubbleInserter_rsp_payload_bank = bubbleInserter_cmd_payload_bank;
  assign bubbleInserter_rsp_payload_rowColumn = bubbleInserter_cmd_payload_rowColumn;
  assign bubbleInserter_rsp_payload_data = bubbleInserter_cmd_payload_data;
  assign bubbleInserter_rsp_payload_mask = bubbleInserter_cmd_payload_mask;
  assign bubbleInserter_rsp_payload_context_id = bubbleInserter_cmd_payload_context_id;
  assign bubbleInserter_rsp_payload_context_last = bubbleInserter_cmd_payload_context_last;
  assign bubbleInserter_rsp_payload_cs = bubbleInserter_cmd_payload_cs;
  assign bubbleInserter_timings_read_busy = (bubbleInserter_timings_read_counter != 2'b00);
  assign when_SdramCtrl_l260 = (bubbleInserter_timings_read_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_write_busy = (bubbleInserter_timings_write_counter != 2'b00);
  assign when_SdramCtrl_l260_1 = (bubbleInserter_timings_write_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_0_precharge_busy = (bubbleInserter_timings_banks_0_precharge_counter != 3'b000);
  assign when_SdramCtrl_l260_2 = (bubbleInserter_timings_banks_0_precharge_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_0_active_busy = (bubbleInserter_timings_banks_0_active_counter != 4'b0000);
  assign when_SdramCtrl_l260_3 = (bubbleInserter_timings_banks_0_active_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_1_precharge_busy = (bubbleInserter_timings_banks_1_precharge_counter != 3'b000);
  assign when_SdramCtrl_l260_4 = (bubbleInserter_timings_banks_1_precharge_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_1_active_busy = (bubbleInserter_timings_banks_1_active_counter != 4'b0000);
  assign when_SdramCtrl_l260_5 = (bubbleInserter_timings_banks_1_active_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_2_precharge_busy = (bubbleInserter_timings_banks_2_precharge_counter != 3'b000);
  assign when_SdramCtrl_l260_6 = (bubbleInserter_timings_banks_2_precharge_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_2_active_busy = (bubbleInserter_timings_banks_2_active_counter != 4'b0000);
  assign when_SdramCtrl_l260_7 = (bubbleInserter_timings_banks_2_active_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_3_precharge_busy = (bubbleInserter_timings_banks_3_precharge_counter != 3'b000);
  assign when_SdramCtrl_l260_8 = (bubbleInserter_timings_banks_3_precharge_busy && bubbleInserter_rsp_ready);
  assign bubbleInserter_timings_banks_3_active_busy = (bubbleInserter_timings_banks_3_active_counter != 4'b0000);
  assign when_SdramCtrl_l260_9 = (bubbleInserter_timings_banks_3_active_busy && bubbleInserter_rsp_ready);
  assign when_SdramCtrl_l269 = (bubbleInserter_timings_banks_0_active_counter <= 4'b0001);
  assign when_SdramCtrl_l269_1 = (bubbleInserter_timings_banks_1_active_counter <= 4'b0001);
  assign when_SdramCtrl_l269_2 = (bubbleInserter_timings_banks_2_active_counter <= 4'b0001);
  assign when_SdramCtrl_l269_3 = (bubbleInserter_timings_banks_3_active_counter <= 4'b0001);
  assign when_SdramCtrl_l269_4 = (bubbleInserter_timings_banks_0_active_counter <= 4'b0010);
  assign when_Utils_l1048 = (bubbleInserter_cmd_payload_bank == 2'b00);
  assign when_SdramCtrl_l269_5 = (bubbleInserter_timings_banks_0_active_counter <= 4'b0010);
  assign when_Utils_l1048_1 = (bubbleInserter_cmd_payload_bank == 2'b01);
  assign when_SdramCtrl_l269_6 = (bubbleInserter_timings_banks_1_active_counter <= 4'b0010);
  assign when_Utils_l1048_2 = (bubbleInserter_cmd_payload_bank == 2'b10);
  assign when_SdramCtrl_l269_7 = (bubbleInserter_timings_banks_2_active_counter <= 4'b0010);
  assign when_Utils_l1048_3 = (bubbleInserter_cmd_payload_bank == 2'b11);
  assign when_SdramCtrl_l269_8 = (bubbleInserter_timings_banks_3_active_counter <= 4'b0010);
  assign when_SdramCtrl_l269_9 = (bubbleInserter_timings_banks_0_active_counter <= 4'b1000);
  assign when_SdramCtrl_l269_10 = (bubbleInserter_timings_banks_1_active_counter <= 4'b1000);
  assign when_SdramCtrl_l269_11 = (bubbleInserter_timings_banks_2_active_counter <= 4'b1000);
  assign when_SdramCtrl_l269_12 = (bubbleInserter_timings_banks_3_active_counter <= 4'b1000);
  assign when_SdramCtrl_l269_13 = (bubbleInserter_timings_write_counter <= 2'b10);
  assign when_Utils_l1048_4 = (bubbleInserter_cmd_payload_bank == 2'b00);
  assign when_SdramCtrl_l269_14 = (bubbleInserter_timings_banks_0_precharge_counter <= 3'b101);
  assign when_Utils_l1048_5 = (bubbleInserter_cmd_payload_bank == 2'b01);
  assign when_SdramCtrl_l269_15 = (bubbleInserter_timings_banks_1_precharge_counter <= 3'b101);
  assign when_Utils_l1048_6 = (bubbleInserter_cmd_payload_bank == 2'b10);
  assign when_SdramCtrl_l269_16 = (bubbleInserter_timings_banks_2_precharge_counter <= 3'b101);
  assign when_Utils_l1048_7 = (bubbleInserter_cmd_payload_bank == 2'b11);
  assign when_SdramCtrl_l269_17 = (bubbleInserter_timings_banks_3_precharge_counter <= 3'b101);
  assign when_Utils_l1048_8 = (bubbleInserter_cmd_payload_bank == 2'b00);
  assign when_SdramCtrl_l269_18 = (bubbleInserter_timings_banks_0_active_counter <= 4'b0111);
  assign when_Utils_l1048_9 = (bubbleInserter_cmd_payload_bank == 2'b01);
  assign when_SdramCtrl_l269_19 = (bubbleInserter_timings_banks_1_active_counter <= 4'b0111);
  assign when_Utils_l1048_10 = (bubbleInserter_cmd_payload_bank == 2'b10);
  assign when_SdramCtrl_l269_20 = (bubbleInserter_timings_banks_2_active_counter <= 4'b0111);
  assign when_Utils_l1048_11 = (bubbleInserter_cmd_payload_bank == 2'b11);
  assign when_SdramCtrl_l269_21 = (bubbleInserter_timings_banks_3_active_counter <= 4'b0111);
  assign when_SdramCtrl_l269_22 = (bubbleInserter_timings_write_counter <= 2'b11);
  assign when_Utils_l1048_12 = (bubbleInserter_cmd_payload_bank == 2'b00);
  assign when_SdramCtrl_l269_23 = (bubbleInserter_timings_banks_0_precharge_counter <= 3'b001);
  assign when_Utils_l1048_13 = (bubbleInserter_cmd_payload_bank == 2'b01);
  assign when_SdramCtrl_l269_24 = (bubbleInserter_timings_banks_1_precharge_counter <= 3'b001);
  assign when_Utils_l1048_14 = (bubbleInserter_cmd_payload_bank == 2'b10);
  assign when_SdramCtrl_l269_25 = (bubbleInserter_timings_banks_2_precharge_counter <= 3'b001);
  assign when_Utils_l1048_15 = (bubbleInserter_cmd_payload_bank == 2'b11);
  assign when_SdramCtrl_l269_26 = (bubbleInserter_timings_banks_3_precharge_counter <= 3'b001);
  assign chip_cmd_valid = bubbleInserter_rsp_valid;
  assign bubbleInserter_rsp_ready = chip_cmd_ready;
  assign chip_cmd_payload_task = bubbleInserter_rsp_payload_task;
  assign chip_cmd_payload_bank = bubbleInserter_rsp_payload_bank;
  assign chip_cmd_payload_rowColumn = bubbleInserter_rsp_payload_rowColumn;
  assign chip_cmd_payload_data = bubbleInserter_rsp_payload_data;
  assign chip_cmd_payload_mask = bubbleInserter_rsp_payload_mask;
  assign chip_cmd_payload_context_id = bubbleInserter_rsp_payload_context_id;
  assign chip_cmd_payload_context_last = bubbleInserter_rsp_payload_context_last;
  assign chip_cmd_payload_cs = bubbleInserter_rsp_payload_cs;
  assign io_sdram_ADDR = chip_sdram_ADDR;
  assign io_sdram_BA = chip_sdram_BA;
  assign io_sdram_DQ_write = chip_sdram_DQ_write;
  assign io_sdram_DQ_writeEnable = chip_sdram_DQ_writeEnable;
  assign io_sdram_DQM = chip_sdram_DQM;
  assign io_sdram_CASn = chip_sdram_CASn;
  assign io_sdram_CKE = chip_sdram_CKE;
  assign io_sdram_CSn = chip_sdram_CSn;
  assign io_sdram_RASn = chip_sdram_RASn;
  assign io_sdram_WEn = chip_sdram_WEn;
  assign _zz_chip_readHistory_0 = (chip_cmd_valid && ((chip_cmd_payload_task == SdramCtrlBackendTask_READ) || 1'b0));
  assign chip_readHistory_0 = _zz_chip_readHistory_0;
  assign chip_readHistory_1 = _zz_chip_readHistory_1;
  assign chip_readHistory_2 = _zz_chip_readHistory_2;
  assign chip_readHistory_3 = _zz_chip_readHistory_3;
  assign chip_readHistory_4 = _zz_chip_readHistory_4;
  assign chip_sdramCkeNext = (! (({chip_readHistory_4,{chip_readHistory_3,{chip_readHistory_2,{chip_readHistory_1,chip_readHistory_0}}}} != 5'h00) && (! io_bus_rsp_ready)));
  assign chip_remoteCke = chip_sdramCkeInternal_regNext;
  assign _zz_chip_sdram_DQM = (! chip_readHistory_0);
  assign chip_backupIn_valid = (chip_readHistory_4 && chip_remoteCke);
  assign chip_backupIn_payload_data = chip_sdram_DQ_read;
  assign chip_backupIn_payload_context_id = chip_contextDelayed_id;
  assign chip_backupIn_payload_context_last = chip_contextDelayed_last;
  assign chip_backupIn_ready = chip_backupIn_fifo_io_push_ready;
  assign io_bus_rsp_valid = chip_backupIn_fifo_io_pop_valid;
  assign io_bus_rsp_payload_data = chip_backupIn_fifo_io_pop_payload_data;
  assign io_bus_rsp_payload_context_id = chip_backupIn_fifo_io_pop_payload_context_id;
  assign io_bus_rsp_payload_context_last = chip_backupIn_fifo_io_pop_payload_context_last;
  assign chip_cmd_ready = chip_remoteCke;
  assign chip_backupIn_fifo_io_flush = 1'b0;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      refresh_counter_value <= 11'h000;
      refresh_pending <= 1'b0;
      powerup_counter <= 14'h0000;
      powerup_done <= 1'b0;
      frontend_banks_0_0_active <= 1'b0;
      frontend_banks_0_1_active <= 1'b0;
      frontend_banks_0_2_active <= 1'b0;
      frontend_banks_0_3_active <= 1'b0;
      frontend_banks_1_0_active <= 1'b0;
      frontend_banks_1_1_active <= 1'b0;
      frontend_banks_1_2_active <= 1'b0;
      frontend_banks_1_3_active <= 1'b0;
      frontend_state <= SdramCtrlFrontendState_BOOT_PRECHARGE;
      frontend_bootRefreshCounter_value <= 3'b000;
      frontend_rsp_rValid <= 1'b0;
      bubbleInserter_timings_read_counter <= 2'b00;
      bubbleInserter_timings_write_counter <= 2'b00;
      bubbleInserter_timings_banks_0_precharge_counter <= 3'b000;
      bubbleInserter_timings_banks_0_active_counter <= 4'b0000;
      bubbleInserter_timings_banks_1_precharge_counter <= 3'b000;
      bubbleInserter_timings_banks_1_active_counter <= 4'b0000;
      bubbleInserter_timings_banks_2_precharge_counter <= 3'b000;
      bubbleInserter_timings_banks_2_active_counter <= 4'b0000;
      bubbleInserter_timings_banks_3_precharge_counter <= 3'b000;
      bubbleInserter_timings_banks_3_active_counter <= 4'b0000;
      _zz_chip_readHistory_1 <= 1'b0;
      _zz_chip_readHistory_2 <= 1'b0;
      _zz_chip_readHistory_3 <= 1'b0;
      _zz_chip_readHistory_4 <= 1'b0;
      chip_sdramCkeInternal <= 1'b1;
      chip_sdramCkeInternal_regNext <= 1'b1;
    end else begin
      refresh_counter_value <= refresh_counter_valueNext;
      if(refresh_counter_willOverflow) begin
        refresh_pending <= 1'b1;
      end
      if(when_SdramCtrl_l147) begin
        powerup_counter <= (powerup_counter + 14'h0001);
        if(when_SdramCtrl_l149) begin
          powerup_done <= 1'b1;
        end
      end
      frontend_bootRefreshCounter_value <= frontend_bootRefreshCounter_valueNext;
      case(frontend_state)
        SdramCtrlFrontendState_BOOT_PRECHARGE : begin
          if(powerup_done) begin
            if(frontend_rsp_ready) begin
              frontend_state <= SdramCtrlFrontendState_BOOT_REFRESH;
            end
          end
        end
        SdramCtrlFrontendState_BOOT_REFRESH : begin
          if(frontend_rsp_ready) begin
            if(frontend_bootRefreshCounter_willOverflowIfInc) begin
              frontend_state <= SdramCtrlFrontendState_BOOT_MODE;
            end
          end
        end
        SdramCtrlFrontendState_BOOT_MODE : begin
          if(frontend_rsp_ready) begin
            frontend_state <= SdramCtrlFrontendState_RUN;
          end
        end
        default : begin
          if(refresh_pending) begin
            if(when_SdramCtrl_l214) begin
              if(frontend_rsp_ready) begin
                frontend_banks_0_0_active <= 1'b0;
                frontend_banks_0_1_active <= 1'b0;
                frontend_banks_0_2_active <= 1'b0;
                frontend_banks_0_3_active <= 1'b0;
                frontend_banks_1_0_active <= 1'b0;
                frontend_banks_1_1_active <= 1'b0;
                frontend_banks_1_2_active <= 1'b0;
                frontend_banks_1_3_active <= 1'b0;
              end
            end else begin
              if(frontend_rsp_ready) begin
                refresh_pending <= 1'b0;
              end
            end
          end else begin
            if(io_bus_cmd_valid) begin
              if(when_SdramCtrl_l229) begin
                if(frontend_rsp_ready) begin
                  if(_zz_5) begin
                    if(_zz_2) begin
                      frontend_banks_0_0_active <= 1'b0;
                    end
                    if(_zz_3) begin
                      frontend_banks_1_0_active <= 1'b0;
                    end
                  end
                  if(_zz_6) begin
                    if(_zz_2) begin
                      frontend_banks_0_1_active <= 1'b0;
                    end
                    if(_zz_3) begin
                      frontend_banks_1_1_active <= 1'b0;
                    end
                  end
                  if(_zz_7) begin
                    if(_zz_2) begin
                      frontend_banks_0_2_active <= 1'b0;
                    end
                    if(_zz_3) begin
                      frontend_banks_1_2_active <= 1'b0;
                    end
                  end
                  if(_zz_8) begin
                    if(_zz_2) begin
                      frontend_banks_0_3_active <= 1'b0;
                    end
                    if(_zz_3) begin
                      frontend_banks_1_3_active <= 1'b0;
                    end
                  end
                end
              end else begin
                if(when_SdramCtrl_l234) begin
                  if(frontend_rsp_ready) begin
                    if(_zz_5) begin
                      if(_zz_2) begin
                        frontend_banks_0_0_active <= 1'b1;
                      end
                      if(_zz_3) begin
                        frontend_banks_1_0_active <= 1'b1;
                      end
                    end
                    if(_zz_6) begin
                      if(_zz_2) begin
                        frontend_banks_0_1_active <= 1'b1;
                      end
                      if(_zz_3) begin
                        frontend_banks_1_1_active <= 1'b1;
                      end
                    end
                    if(_zz_7) begin
                      if(_zz_2) begin
                        frontend_banks_0_2_active <= 1'b1;
                      end
                      if(_zz_3) begin
                        frontend_banks_1_2_active <= 1'b1;
                      end
                    end
                    if(_zz_8) begin
                      if(_zz_2) begin
                        frontend_banks_0_3_active <= 1'b1;
                      end
                      if(_zz_3) begin
                        frontend_banks_1_3_active <= 1'b1;
                      end
                    end
                  end
                end
              end
            end
          end
        end
      endcase
      if(frontend_rsp_ready) begin
        frontend_rsp_rValid <= frontend_rsp_valid;
      end
      if(when_SdramCtrl_l260) begin
        bubbleInserter_timings_read_counter <= (bubbleInserter_timings_read_counter - 2'b01);
      end
      if(when_SdramCtrl_l260_1) begin
        bubbleInserter_timings_write_counter <= (bubbleInserter_timings_write_counter - 2'b01);
      end
      if(when_SdramCtrl_l260_2) begin
        bubbleInserter_timings_banks_0_precharge_counter <= (bubbleInserter_timings_banks_0_precharge_counter - 3'b001);
      end
      if(when_SdramCtrl_l260_3) begin
        bubbleInserter_timings_banks_0_active_counter <= (bubbleInserter_timings_banks_0_active_counter - 4'b0001);
      end
      if(when_SdramCtrl_l260_4) begin
        bubbleInserter_timings_banks_1_precharge_counter <= (bubbleInserter_timings_banks_1_precharge_counter - 3'b001);
      end
      if(when_SdramCtrl_l260_5) begin
        bubbleInserter_timings_banks_1_active_counter <= (bubbleInserter_timings_banks_1_active_counter - 4'b0001);
      end
      if(when_SdramCtrl_l260_6) begin
        bubbleInserter_timings_banks_2_precharge_counter <= (bubbleInserter_timings_banks_2_precharge_counter - 3'b001);
      end
      if(when_SdramCtrl_l260_7) begin
        bubbleInserter_timings_banks_2_active_counter <= (bubbleInserter_timings_banks_2_active_counter - 4'b0001);
      end
      if(when_SdramCtrl_l260_8) begin
        bubbleInserter_timings_banks_3_precharge_counter <= (bubbleInserter_timings_banks_3_precharge_counter - 3'b001);
      end
      if(when_SdramCtrl_l260_9) begin
        bubbleInserter_timings_banks_3_active_counter <= (bubbleInserter_timings_banks_3_active_counter - 4'b0001);
      end
      if(bubbleInserter_cmd_valid) begin
        case(bubbleInserter_cmd_payload_task)
          SdramCtrlBackendTask_MODE : begin
            if(bubbleInserter_cmd_ready) begin
              if(when_SdramCtrl_l269) begin
                bubbleInserter_timings_banks_0_active_counter <= 4'b0001;
              end
              if(when_SdramCtrl_l269_1) begin
                bubbleInserter_timings_banks_1_active_counter <= 4'b0001;
              end
              if(when_SdramCtrl_l269_2) begin
                bubbleInserter_timings_banks_2_active_counter <= 4'b0001;
              end
              if(when_SdramCtrl_l269_3) begin
                bubbleInserter_timings_banks_3_active_counter <= 4'b0001;
              end
            end
          end
          SdramCtrlBackendTask_PRECHARGE_ALL : begin
            if(bubbleInserter_cmd_ready) begin
              if(when_SdramCtrl_l269_4) begin
                bubbleInserter_timings_banks_0_active_counter <= 4'b0010;
              end
            end
          end
          SdramCtrlBackendTask_PRECHARGE_SINGLE : begin
            if(bubbleInserter_cmd_ready) begin
              if(when_Utils_l1048) begin
                if(when_SdramCtrl_l269_5) begin
                  bubbleInserter_timings_banks_0_active_counter <= 4'b0010;
                end
              end
              if(when_Utils_l1048_1) begin
                if(when_SdramCtrl_l269_6) begin
                  bubbleInserter_timings_banks_1_active_counter <= 4'b0010;
                end
              end
              if(when_Utils_l1048_2) begin
                if(when_SdramCtrl_l269_7) begin
                  bubbleInserter_timings_banks_2_active_counter <= 4'b0010;
                end
              end
              if(when_Utils_l1048_3) begin
                if(when_SdramCtrl_l269_8) begin
                  bubbleInserter_timings_banks_3_active_counter <= 4'b0010;
                end
              end
            end
          end
          SdramCtrlBackendTask_REFRESH : begin
            if(bubbleInserter_cmd_ready) begin
              if(when_SdramCtrl_l269_9) begin
                bubbleInserter_timings_banks_0_active_counter <= 4'b1000;
              end
              if(when_SdramCtrl_l269_10) begin
                bubbleInserter_timings_banks_1_active_counter <= 4'b1000;
              end
              if(when_SdramCtrl_l269_11) begin
                bubbleInserter_timings_banks_2_active_counter <= 4'b1000;
              end
              if(when_SdramCtrl_l269_12) begin
                bubbleInserter_timings_banks_3_active_counter <= 4'b1000;
              end
            end
          end
          SdramCtrlBackendTask_ACTIVE : begin
            if(bubbleInserter_cmd_ready) begin
              if(when_SdramCtrl_l269_13) begin
                bubbleInserter_timings_write_counter <= 2'b10;
              end
              bubbleInserter_timings_read_counter <= 2'b10;
              if(when_Utils_l1048_4) begin
                if(when_SdramCtrl_l269_14) begin
                  bubbleInserter_timings_banks_0_precharge_counter <= 3'b101;
                end
              end
              if(when_Utils_l1048_5) begin
                if(when_SdramCtrl_l269_15) begin
                  bubbleInserter_timings_banks_1_precharge_counter <= 3'b101;
                end
              end
              if(when_Utils_l1048_6) begin
                if(when_SdramCtrl_l269_16) begin
                  bubbleInserter_timings_banks_2_precharge_counter <= 3'b101;
                end
              end
              if(when_Utils_l1048_7) begin
                if(when_SdramCtrl_l269_17) begin
                  bubbleInserter_timings_banks_3_precharge_counter <= 3'b101;
                end
              end
              if(when_Utils_l1048_8) begin
                if(when_SdramCtrl_l269_18) begin
                  bubbleInserter_timings_banks_0_active_counter <= 4'b0111;
                end
              end
              if(when_Utils_l1048_9) begin
                if(when_SdramCtrl_l269_19) begin
                  bubbleInserter_timings_banks_1_active_counter <= 4'b0111;
                end
              end
              if(when_Utils_l1048_10) begin
                if(when_SdramCtrl_l269_20) begin
                  bubbleInserter_timings_banks_2_active_counter <= 4'b0111;
                end
              end
              if(when_Utils_l1048_11) begin
                if(when_SdramCtrl_l269_21) begin
                  bubbleInserter_timings_banks_3_active_counter <= 4'b0111;
                end
              end
            end
          end
          SdramCtrlBackendTask_READ : begin
            if(bubbleInserter_cmd_ready) begin
              if(when_SdramCtrl_l269_22) begin
                bubbleInserter_timings_write_counter <= 2'b11;
              end
            end
          end
          default : begin
            if(bubbleInserter_cmd_ready) begin
              if(when_Utils_l1048_12) begin
                if(when_SdramCtrl_l269_23) begin
                  bubbleInserter_timings_banks_0_precharge_counter <= 3'b001;
                end
              end
              if(when_Utils_l1048_13) begin
                if(when_SdramCtrl_l269_24) begin
                  bubbleInserter_timings_banks_1_precharge_counter <= 3'b001;
                end
              end
              if(when_Utils_l1048_14) begin
                if(when_SdramCtrl_l269_25) begin
                  bubbleInserter_timings_banks_2_precharge_counter <= 3'b001;
                end
              end
              if(when_Utils_l1048_15) begin
                if(when_SdramCtrl_l269_26) begin
                  bubbleInserter_timings_banks_3_precharge_counter <= 3'b001;
                end
              end
            end
          end
        endcase
      end
      if(chip_remoteCke) begin
        _zz_chip_readHistory_1 <= _zz_chip_readHistory_0;
      end
      if(chip_remoteCke) begin
        _zz_chip_readHistory_2 <= _zz_chip_readHistory_1;
      end
      if(chip_remoteCke) begin
        _zz_chip_readHistory_3 <= _zz_chip_readHistory_2;
      end
      if(chip_remoteCke) begin
        _zz_chip_readHistory_4 <= _zz_chip_readHistory_3;
      end
      chip_sdramCkeInternal <= chip_sdramCkeNext;
      chip_sdramCkeInternal_regNext <= chip_sdramCkeInternal;
    end
  end

  always @(posedge clk) begin
    case(frontend_state)
      SdramCtrlFrontendState_BOOT_PRECHARGE : begin
      end
      SdramCtrlFrontendState_BOOT_REFRESH : begin
      end
      SdramCtrlFrontendState_BOOT_MODE : begin
      end
      default : begin
        if(!refresh_pending) begin
          if(io_bus_cmd_valid) begin
            if(!when_SdramCtrl_l229) begin
              if(when_SdramCtrl_l234) begin
                if(_zz_5) begin
                  if(_zz_2) begin
                    frontend_banks_0_0_row <= frontend_address_row;
                  end
                  if(_zz_3) begin
                    frontend_banks_1_0_row <= frontend_address_row;
                  end
                end
                if(_zz_6) begin
                  if(_zz_2) begin
                    frontend_banks_0_1_row <= frontend_address_row;
                  end
                  if(_zz_3) begin
                    frontend_banks_1_1_row <= frontend_address_row;
                  end
                end
                if(_zz_7) begin
                  if(_zz_2) begin
                    frontend_banks_0_2_row <= frontend_address_row;
                  end
                  if(_zz_3) begin
                    frontend_banks_1_2_row <= frontend_address_row;
                  end
                end
                if(_zz_8) begin
                  if(_zz_2) begin
                    frontend_banks_0_3_row <= frontend_address_row;
                  end
                  if(_zz_3) begin
                    frontend_banks_1_3_row <= frontend_address_row;
                  end
                end
              end
            end
          end
        end
      end
    endcase
    if(frontend_rsp_ready) begin
      frontend_rsp_rData_task <= frontend_rsp_payload_task;
      frontend_rsp_rData_bank <= frontend_rsp_payload_bank;
      frontend_rsp_rData_rowColumn <= frontend_rsp_payload_rowColumn;
      frontend_rsp_rData_data <= frontend_rsp_payload_data;
      frontend_rsp_rData_mask <= frontend_rsp_payload_mask;
      frontend_rsp_rData_context_id <= frontend_rsp_payload_context_id;
      frontend_rsp_rData_context_last <= frontend_rsp_payload_context_last;
      frontend_rsp_rData_cs <= frontend_rsp_payload_cs;
    end
    if(chip_remoteCke) begin
      chip_cmd_payload_context_delay_1_id <= chip_cmd_payload_context_id;
      chip_cmd_payload_context_delay_1_last <= chip_cmd_payload_context_last;
    end
    if(chip_remoteCke) begin
      chip_cmd_payload_context_delay_2_id <= chip_cmd_payload_context_delay_1_id;
      chip_cmd_payload_context_delay_2_last <= chip_cmd_payload_context_delay_1_last;
    end
    if(chip_remoteCke) begin
      chip_cmd_payload_context_delay_3_id <= chip_cmd_payload_context_delay_2_id;
      chip_cmd_payload_context_delay_3_last <= chip_cmd_payload_context_delay_2_last;
    end
    if(chip_remoteCke) begin
      chip_contextDelayed_id <= chip_cmd_payload_context_delay_3_id;
      chip_contextDelayed_last <= chip_cmd_payload_context_delay_3_last;
    end
    chip_sdram_CKE <= chip_sdramCkeNext;
    if(chip_remoteCke) begin
      chip_sdram_DQ_read <= io_sdram_DQ_read;
      chip_sdram_CSn <= 2'b00;
      chip_sdram_RASn <= 1'b1;
      chip_sdram_CASn <= 1'b1;
      chip_sdram_WEn <= 1'b1;
      chip_sdram_DQ_write <= chip_cmd_payload_data;
      chip_sdram_DQ_writeEnable <= 32'h00000000;
      chip_sdram_DQM[0] <= _zz_chip_sdram_DQM;
      chip_sdram_DQM[1] <= _zz_chip_sdram_DQM;
      chip_sdram_DQM[2] <= _zz_chip_sdram_DQM;
      chip_sdram_DQM[3] <= _zz_chip_sdram_DQM;
      if(chip_cmd_valid) begin
        case(chip_cmd_payload_task)
          SdramCtrlBackendTask_PRECHARGE_ALL : begin
            chip_sdram_ADDR[10] <= 1'b1;
            chip_sdram_CSn <= 2'b00;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b1;
            chip_sdram_WEn <= 1'b0;
          end
          SdramCtrlBackendTask_REFRESH : begin
            chip_sdram_CSn <= 2'b00;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b1;
          end
          SdramCtrlBackendTask_MODE : begin
            chip_sdram_ADDR <= 13'h0000;
            chip_sdram_ADDR[2 : 0] <= 3'b000;
            chip_sdram_ADDR[3] <= 1'b0;
            chip_sdram_ADDR[6 : 4] <= 3'b010;
            chip_sdram_ADDR[8 : 7] <= 2'b00;
            chip_sdram_ADDR[9] <= 1'b0;
            chip_sdram_BA <= 2'b00;
            chip_sdram_CSn <= 2'b00;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b0;
          end
          SdramCtrlBackendTask_ACTIVE : begin
            chip_sdram_ADDR <= chip_cmd_payload_rowColumn;
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_CSn <= chip_cmd_payload_cs;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b1;
            chip_sdram_WEn <= 1'b1;
          end
          SdramCtrlBackendTask_WRITE : begin
            chip_sdram_ADDR <= chip_cmd_payload_rowColumn;
            chip_sdram_ADDR[10] <= 1'b0;
            chip_sdram_DQ_writeEnable <= 32'hffffffff;
            chip_sdram_DQ_write <= chip_cmd_payload_data;
            chip_sdram_DQM <= (~ chip_cmd_payload_mask);
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_CSn <= chip_cmd_payload_cs;
            chip_sdram_RASn <= 1'b1;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b0;
          end
          SdramCtrlBackendTask_READ : begin
            chip_sdram_ADDR <= chip_cmd_payload_rowColumn;
            chip_sdram_ADDR[10] <= 1'b0;
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_CSn <= chip_cmd_payload_cs;
            chip_sdram_RASn <= 1'b1;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b1;
          end
          default : begin
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_ADDR[10] <= 1'b0;
            chip_sdram_CSn <= chip_cmd_payload_cs;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b1;
            chip_sdram_WEn <= 1'b0;
          end
        endcase
      end
    end
  end


endmodule

module StreamFifoLowLatency (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [31:0]   io_push_payload_data,
  input  wire [6:0]    io_push_payload_context_id,
  input  wire          io_push_payload_context_last,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [31:0]   io_pop_payload_data,
  output wire [6:0]    io_pop_payload_context_id,
  output wire          io_pop_payload_context_last,
  input  wire          io_flush,
  output wire [1:0]    io_occupancy,
  output wire [1:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [31:0]   fifo_io_pop_payload_data;
  wire       [6:0]    fifo_io_pop_payload_context_id;
  wire                fifo_io_pop_payload_context_last;
  wire       [1:0]    fifo_io_occupancy;
  wire       [1:0]    fifo_io_availability;

  StreamFifo fifo (
    .io_push_valid                (io_push_valid                      ), //i
    .io_push_ready                (fifo_io_push_ready                 ), //o
    .io_push_payload_data         (io_push_payload_data[31:0]         ), //i
    .io_push_payload_context_id   (io_push_payload_context_id[6:0]    ), //i
    .io_push_payload_context_last (io_push_payload_context_last       ), //i
    .io_pop_valid                 (fifo_io_pop_valid                  ), //o
    .io_pop_ready                 (io_pop_ready                       ), //i
    .io_pop_payload_data          (fifo_io_pop_payload_data[31:0]     ), //o
    .io_pop_payload_context_id    (fifo_io_pop_payload_context_id[6:0]), //o
    .io_pop_payload_context_last  (fifo_io_pop_payload_context_last   ), //o
    .io_flush                     (io_flush                           ), //i
    .io_occupancy                 (fifo_io_occupancy[1:0]             ), //o
    .io_availability              (fifo_io_availability[1:0]          ), //o
    .clk                          (clk                                ), //i
    .reset                        (reset                              )  //i
  );
  assign io_push_ready = fifo_io_push_ready;
  assign io_pop_valid = fifo_io_pop_valid;
  assign io_pop_payload_data = fifo_io_pop_payload_data;
  assign io_pop_payload_context_id = fifo_io_pop_payload_context_id;
  assign io_pop_payload_context_last = fifo_io_pop_payload_context_last;
  assign io_occupancy = fifo_io_occupancy;
  assign io_availability = fifo_io_availability;

endmodule

module StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [31:0]   io_push_payload_data,
  input  wire [6:0]    io_push_payload_context_id,
  input  wire          io_push_payload_context_last,
  output reg           io_pop_valid,
  input  wire          io_pop_ready,
  output reg  [31:0]   io_pop_payload_data,
  output reg  [6:0]    io_pop_payload_context_id,
  output reg           io_pop_payload_context_last,
  input  wire          io_flush,
  output wire [1:0]    io_occupancy,
  output wire [1:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  wire       [39:0]   _zz_logic_ram_port1;
  wire       [39:0]   _zz_logic_ram_port;
  reg                 _zz_1;
  reg                 logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [1:0]    logic_ptr_push;
  reg        [1:0]    logic_ptr_pop;
  wire       [1:0]    logic_ptr_occupancy;
  wire       [1:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1205;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [0:0]    logic_push_onRam_write_payload_address;
  wire       [31:0]   logic_push_onRam_write_payload_data_data;
  wire       [6:0]    logic_push_onRam_write_payload_data_context_id;
  wire                logic_push_onRam_write_payload_data_context_last;
  wire                logic_pop_addressGen_valid;
  wire                logic_pop_addressGen_ready;
  wire       [0:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire       [31:0]   logic_pop_async_readed_data;
  wire       [6:0]    logic_pop_async_readed_context_id;
  wire                logic_pop_async_readed_context_last;
  wire       [39:0]   _zz_logic_pop_async_readed_data;
  wire       [7:0]    _zz_logic_pop_async_readed_context_id;
  wire                logic_pop_addressGen_translated_valid;
  wire                logic_pop_addressGen_translated_ready;
  wire       [31:0]   logic_pop_addressGen_translated_payload_data;
  wire       [6:0]    logic_pop_addressGen_translated_payload_context_id;
  wire                logic_pop_addressGen_translated_payload_context_last;
  (* ram_style = "distributed" *) reg [39:0] logic_ram [0:1];

  assign _zz_logic_ram_port = {{logic_push_onRam_write_payload_data_context_last,logic_push_onRam_write_payload_data_context_id},logic_push_onRam_write_payload_data_data};
  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= _zz_logic_ram_port;
    end
  end

  assign _zz_logic_ram_port1 = logic_ram[logic_pop_addressGen_payload];
  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1205 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 2'b10) == 2'b00);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  always @(*) begin
    logic_ptr_doPush = io_push_fire;
    if(logic_ptr_empty) begin
      if(io_pop_ready) begin
        logic_ptr_doPush = 1'b0;
      end
    end
  end

  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[0:0];
  assign logic_push_onRam_write_payload_data_data = io_push_payload_data;
  assign logic_push_onRam_write_payload_data_context_id = io_push_payload_context_id;
  assign logic_push_onRam_write_payload_data_context_last = io_push_payload_context_last;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[0:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  assign _zz_logic_pop_async_readed_data = _zz_logic_ram_port1;
  assign logic_pop_async_readed_data = _zz_logic_pop_async_readed_data[31 : 0];
  assign _zz_logic_pop_async_readed_context_id = _zz_logic_pop_async_readed_data[39 : 32];
  assign logic_pop_async_readed_context_id = _zz_logic_pop_async_readed_context_id[6 : 0];
  assign logic_pop_async_readed_context_last = _zz_logic_pop_async_readed_context_id[7];
  assign logic_pop_addressGen_translated_valid = logic_pop_addressGen_valid;
  assign logic_pop_addressGen_ready = logic_pop_addressGen_translated_ready;
  assign logic_pop_addressGen_translated_payload_data = logic_pop_async_readed_data;
  assign logic_pop_addressGen_translated_payload_context_id = logic_pop_async_readed_context_id;
  assign logic_pop_addressGen_translated_payload_context_last = logic_pop_async_readed_context_last;
  always @(*) begin
    io_pop_valid = logic_pop_addressGen_translated_valid;
    if(logic_ptr_empty) begin
      io_pop_valid = io_push_valid;
    end
  end

  assign logic_pop_addressGen_translated_ready = io_pop_ready;
  always @(*) begin
    io_pop_payload_data = logic_pop_addressGen_translated_payload_data;
    if(logic_ptr_empty) begin
      io_pop_payload_data = io_push_payload_data;
    end
  end

  always @(*) begin
    io_pop_payload_context_id = logic_pop_addressGen_translated_payload_context_id;
    if(logic_ptr_empty) begin
      io_pop_payload_context_id = io_push_payload_context_id;
    end
  end

  always @(*) begin
    io_pop_payload_context_last = logic_pop_addressGen_translated_payload_context_last;
    if(logic_ptr_empty) begin
      io_pop_payload_context_last = io_push_payload_context_last;
    end
  end

  assign logic_ptr_popOnIo = logic_ptr_pop;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (2'b10 - logic_ptr_occupancy);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_ptr_push <= 2'b00;
      logic_ptr_pop <= 2'b00;
      logic_ptr_wentUp <= 1'b0;
    end else begin
      if(when_Stream_l1205) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 2'b01);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 2'b01);
      end
      if(io_flush) begin
        logic_ptr_push <= 2'b00;
        logic_ptr_pop <= 2'b00;
      end
    end
  end


endmodule
