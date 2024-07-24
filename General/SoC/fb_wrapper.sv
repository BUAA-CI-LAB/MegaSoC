module fb_wrapper (
    input aclk,
    input aresetn,

    input vgaclk,
    input vgaresetn,

    output wire [7:0] vga_r_o,
    output wire [7:0] vga_g_o,
    output wire [7:0] vga_b_o,
    output wire vga_de_o,
    output wire vga_h_o,
    output wire vga_v_o,

    AXI_LITE.Slave   slv,
    AXI_BUS.Master   dma_mst
);

    AXI_BUS #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(4)) vga_dma();
    AXI_LITE #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32)) slv_lite();

    axi_lite_cdc_intf #(
        .AXI_ADDR_WIDTH(32),
        .AXI_DATA_WIDTH(32),
        .LOG_DEPTH(2)
    ) cfg_slv_cdc (
        .src_clk_i(aclk),
        .src_rst_ni(aresetn),
        .src(slv),
        
        .dst_clk_i(vgaclk),
        .dst_rst_ni(vgaresetn),
        .dst(slv_lite)
    ); 
    axi_cdc_intf #(
        .AXI_ID_WIDTH(4),
        .AXI_ADDR_WIDTH(32),
        .AXI_DATA_WIDTH(32),
        .LOG_DEPTH(4)
    ) dma_mst_cdc (
        .src_clk_i(vgaclk),
        .src_rst_ni(vgaresetn),
        .src(vga_dma),
        
        .dst_clk_i(aclk),
        .dst_rst_ni(aresetn),
        .dst(dma_mst)
    ); 

    vga_framebuffer # (
        .VIDEO_WIDTH(1280),
        .VIDEO_HEIGHT(720),
        .VIDEO_REFRESH(24),
        .VIDEO_ENABLE(1),
        .VIDEO_X2_MODE(0)
    )
    vga_framebuffer_inst (
        .clk_i(vgaclk),
        .rst_i(~vgaresetn),
        .cfg_awvalid_i(slv_lite.aw_valid),
        .cfg_awaddr_i (slv_lite.aw_addr),
        .cfg_wvalid_i (slv_lite.w_valid),
        .cfg_wdata_i  (slv_lite.w_data),
        .cfg_wstrb_i  (slv_lite.w_strb),
        .cfg_bready_i (slv_lite.b_ready),
        .cfg_rready_i (slv_lite.r_ready),
        .cfg_arvalid_i(slv_lite.ar_valid),
        .cfg_araddr_i (slv_lite.ar_addr),
        .cfg_awready_o(slv_lite.aw_ready),
        .cfg_arready_o(slv_lite.ar_ready),
        .cfg_wready_o (slv_lite.w_ready),
        .cfg_bvalid_o (slv_lite.b_valid),
        .cfg_bresp_o  (slv_lite.b_resp),
        .cfg_rvalid_o (slv_lite.r_valid),
        .cfg_rdata_o  (slv_lite.r_data),
        .cfg_rresp_o  (slv_lite.r_resp),
        .outport_awready_i(vga_dma.aw_ready),
        .outport_wready_i(vga_dma.w_ready),
        .outport_bvalid_i(vga_dma.b_valid),
        .outport_bresp_i(vga_dma.b_resp),
        .outport_bid_i(vga_dma.b_id),
        .outport_arready_i(vga_dma.ar_ready),
        .outport_rvalid_i(vga_dma.r_valid),
        .outport_rdata_i(vga_dma.r_data),
        .outport_rresp_i(vga_dma.r_resp),
        .outport_rid_i(vga_dma.r_id),
        .outport_rlast_i(vga_dma.r_last),
        .intr_o(intr),
        .outport_awvalid_o(vga_dma.aw_valid),
        .outport_awaddr_o(vga_dma.aw_addr),
        .outport_awid_o(vga_dma.aw_id),
        .outport_awlen_o(vga_dma.aw_len),
        .outport_awburst_o(vga_dma.aw_burst),
        .outport_wvalid_o(vga_dma.w_valid),
        .outport_wdata_o(vga_dma.w_data),
        .outport_wstrb_o(vga_dma.w_strb),
        .outport_wlast_o(vga_dma.w_last),
        .outport_bready_o(vga_dma.b_ready),
        .outport_arvalid_o(vga_dma.ar_valid),
        .outport_araddr_o(vga_dma.ar_addr),
        .outport_arid_o(vga_dma.ar_id),
        .outport_arlen_o(vga_dma.ar_len),
        .outport_arburst_o(vga_dma.ar_burst),
        .outport_rready_o(vga_dma.r_ready),
        .vga_r_o(vga_r_o),
        .vga_g_o(vga_g_o),
        .vga_b_o(vga_b_o),
        .vga_de_o(vga_de_o),
        .vga_h_o(vga_h_o),
        .vga_v_o(vga_v_o)
    );
    assign vga_dma.aw_size = 3'b010;
    assign vga_dma.ar_size = 3'b010;

endmodule