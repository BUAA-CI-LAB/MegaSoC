module axi_sdc_wrapper (
    input aclk,
    input aresetn,
    
    input  wire sd_ncd,
    input  wire [3:0] sd_dat_i,
    output wire [3:0] sd_dat_o,
    output wire sd_dat_t,
    input  wire sd_cmd_i,
    output wire sd_cmd_o,
    output wire sd_cmd_t,
    output wire sd_clk,
    
    output wire interrupt,
    
    AXI_LITE.Slave   slv,
    AXI_BUS.Master  dma_mst
);

wire sd_rst;

assign dma_mst.aw_id = '0;
assign dma_mst.aw_size = 3'b010;
assign dma_mst.aw_burst = 2'b01;
assign dma_mst.w_strb = 4'b1111;
assign dma_mst.ar_id = '0;
assign dma_mst.ar_size = 3'b010;
assign dma_mst.ar_burst = 2'b01;

sdc_controller # (
    .dma_addr_bits(32),
    .sdio_card_detect_level(0)
) sdc_inst (
    .aresetn(aresetn),
    .clock(aclk),
    .s_axi_awaddr(slv.aw_addr[15:0]),
    .s_axi_awvalid(slv.aw_valid),
    .s_axi_awready(slv.aw_ready),
    .s_axi_wdata(slv.w_data),
    .s_axi_wvalid(slv.w_valid),
    .s_axi_wready(slv.w_ready),
    .s_axi_bresp(slv.b_resp),
    .s_axi_bvalid(slv.b_valid),
    .s_axi_bready(slv.b_ready),
    .s_axi_araddr(slv.ar_addr[15:0]),
    .s_axi_arvalid(slv.ar_valid),
    .s_axi_arready(slv.ar_ready),
    .s_axi_rdata(slv.r_data),
    .s_axi_rresp(slv.r_resp),
    .s_axi_rvalid(slv.r_valid),
    .s_axi_rready(slv.r_ready),
    .m_axi_awaddr(dma_mst.aw_addr),
    .m_axi_awlen(dma_mst.aw_len),
    .m_axi_awvalid(dma_mst.aw_valid),
    .m_axi_awready(dma_mst.aw_ready),
    .m_axi_wdata(dma_mst.w_data),
    .m_axi_wlast(dma_mst.w_last),
    .m_axi_wvalid(dma_mst.w_valid),
    .m_axi_wready(dma_mst.w_ready),
    .m_axi_bresp(dma_mst.b_resp),
    .m_axi_bvalid(dma_mst.b_valid),
    .m_axi_bready(dma_mst.b_ready),
    .m_axi_araddr(dma_mst.ar_addr),
    .m_axi_arlen(dma_mst.ar_len),
    .m_axi_arvalid(dma_mst.ar_valid),
    .m_axi_arready(dma_mst.ar_ready),
    .m_axi_rdata(dma_mst.r_data),
    .m_axi_rlast(dma_mst.r_last),
    .m_axi_rresp(dma_mst.r_resp),
    .m_axi_rvalid(dma_mst.r_valid),
    .m_axi_rready(dma_mst.r_ready),
    .sdio_clk(sd_clk),
    .sdio_reset(sd_rst),
    .sdio_cd(sd_ncd),
    .sd_cmd_i(sd_cmd_i),
    .sd_cmd_reg_o(sd_cmd_o),
    .sd_cmd_reg_t(sd_cmd_t),
    .sd_dat_i(sd_dat_i),
    .sd_dat_reg_o(sd_dat_o),
    .sd_dat_reg_t(sd_dat_t),
    .interrupt(interrupt)
  );

endmodule

