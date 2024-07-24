
`include "axi/assign.svh"
`include "axi/typedef.svh"

module my_axi_lite_demux_intf #(
  parameter int unsigned AxiAddrWidth = 32'd0,
  parameter int unsigned AxiDataWidth = 32'd0,
  parameter int unsigned NoMstPorts   = 32'd11,
  parameter int unsigned MaxTrans     = 32'd0,
  parameter bit          FallThrough  = 1'b0,
  parameter bit          SpillAw      = 1'b1,
  parameter bit          SpillW       = 1'b1,
  parameter bit          SpillB       = 1'b1,
  parameter bit          SpillAr      = 1'b1,
  parameter bit          SpillR       = 1'b1,
  // Dependent parameters, DO NOT OVERRIDE!
  parameter type         select_t     = logic [$clog2(NoMstPorts)-1:0]
) ( 
  input  logic     clk_i,               // Clock
  input  logic     rst_ni,              // Asynchronous reset active low
  input  logic     test_i,              // Testmode enable
  input  select_t  slv_aw_select_i,     // has to be stable, when aw_valid
  input  select_t  slv_ar_select_i,     // has to be stable, when ar_valid
  AXI_LITE.Slave   slv,                 // slave port
  AXI_LITE.Master  mst0,                // master ports
  AXI_LITE.Master  mst1,                // master ports
  AXI_LITE.Master  mst2,                // master ports
  AXI_LITE.Master  mst3,                // master ports
  AXI_LITE.Master  mst4,                // master ports
  AXI_LITE.Master  mst5,                // master ports
  AXI_LITE.Master  mst6,                // master ports
  AXI_LITE.Master  mst7,                // master ports
  AXI_LITE.Master  mst8,                // master ports
  AXI_LITE.Master  mst9                 // master ports
);
  typedef logic [AxiAddrWidth-1:0]   addr_t;
  typedef logic [AxiDataWidth-1:0]   data_t;
  typedef logic [AxiDataWidth/8-1:0] strb_t;
  `AXI_LITE_TYPEDEF_AW_CHAN_T(aw_chan_t, addr_t)
  `AXI_LITE_TYPEDEF_W_CHAN_T(w_chan_t, data_t, strb_t)
  `AXI_LITE_TYPEDEF_B_CHAN_T(b_chan_t)
  `AXI_LITE_TYPEDEF_AR_CHAN_T(ar_chan_t, addr_t)
  `AXI_LITE_TYPEDEF_R_CHAN_T(r_chan_t, data_t)
  `AXI_LITE_TYPEDEF_REQ_T(axi_req_t, aw_chan_t, w_chan_t, ar_chan_t)
  `AXI_LITE_TYPEDEF_RESP_T(axi_resp_t, b_chan_t, r_chan_t)

  axi_req_t                   slv_req;
  axi_resp_t                  slv_resp;
  axi_req_t  [NoMstPorts-1:0] mst_reqs;
  axi_resp_t [NoMstPorts-1:0] mst_resps;

  `AXI_LITE_ASSIGN_TO_REQ(slv_req, slv)
  `AXI_LITE_ASSIGN_FROM_RESP(slv, slv_resp)

  `define AXI_LITE_ASSIGN_MST(_i_) `AXI_LITE_ASSIGN_FROM_REQ(mst``_i_, mst_reqs[_i_]) `AXI_LITE_ASSIGN_TO_RESP(mst_resps[_i_], mst``_i_)
    `AXI_LITE_ASSIGN_MST(0)
    `AXI_LITE_ASSIGN_MST(1)
    `AXI_LITE_ASSIGN_MST(2)
    `AXI_LITE_ASSIGN_MST(3)
    `AXI_LITE_ASSIGN_MST(4)
    `AXI_LITE_ASSIGN_MST(5)
    `AXI_LITE_ASSIGN_MST(6)
    `AXI_LITE_ASSIGN_MST(7)
    `AXI_LITE_ASSIGN_MST(8)
    `AXI_LITE_ASSIGN_MST(9)
  `undef AXI_LITE_ASSIGN_MST

  axi_lite_demux #(
    .aw_chan_t   (  aw_chan_t  ),
    .w_chan_t    (   w_chan_t  ),
    .b_chan_t    (   b_chan_t  ),
    .ar_chan_t   (  ar_chan_t  ),
    .r_chan_t    (   r_chan_t  ),
    .axi_req_t   (  axi_req_t  ),
    .axi_resp_t  ( axi_resp_t  ),
    .NoMstPorts  ( NoMstPorts  ),
    .MaxTrans    ( MaxTrans    ),
    .FallThrough ( FallThrough ),
    .SpillAw     ( SpillAw     ),
    .SpillW      ( SpillW      ),
    .SpillB      ( SpillB      ),
    .SpillAr     ( SpillAr     ),
    .SpillR      ( SpillR      )
  ) i_axi_demux (
    .clk_i,
    .rst_ni,
    .test_i,
    // slave Port
    .slv_req_i       ( slv_req         ),
    .slv_aw_select_i ( slv_aw_select_i ), // must be stable while slv_aw_valid_i
    .slv_ar_select_i ( slv_ar_select_i ), // must be stable while slv_ar_valid_i
    .slv_resp_o      ( slv_resp        ),
    // mster ports
    .mst_reqs_o      ( mst_reqs        ),
    .mst_resps_i     ( mst_resps       )
  );

  // pragma translate_off
  `ifndef VERILATOR
    initial begin: p_assertions
      AddrWidth: assert (AxiAddrWidth > 0) else $fatal("Axi Parmeter has to be > 0!");
      DataWidth: assert (AxiDataWidth > 0) else $fatal("Axi Parmeter has to be > 0!");
    end
  `endif
  // pragma translate_on
endmodule
