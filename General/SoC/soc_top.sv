(* keep_hierarchy = "yes" *)

module soc_top #(
    parameter C_ASIC_SRAM = 0
) (
    input soc_clk, // 100M
    input i2s_clk,     // 24.576M
    input cpu_clk,
    input aresetn,
    
    output [6:0]  mem_axi_awid,
    (*mark_debug="true"*)output [31:0] mem_axi_awaddr,
    output [7:0]  mem_axi_awlen,
    output [2:0]  mem_axi_awsize,
    output [1:0]  mem_axi_awburst,
    (*mark_debug="true"*)output        mem_axi_awvalid,
    (*mark_debug="true"*)input         mem_axi_awready,
    output [31:0] mem_axi_wdata,
    output [3:0]  mem_axi_wstrb,
    output        mem_axi_wlast,
    output        mem_axi_wvalid,
    input         mem_axi_wready,
    output        mem_axi_bready,
    input  [6:0]  mem_axi_bid,
    input  [1:0]  mem_axi_bresp,
    input         mem_axi_bvalid,
    output [6:0]  mem_axi_arid,
    (*mark_debug="true"*)output [31:0] mem_axi_araddr,
    output [7:0]  mem_axi_arlen,
    output [2:0]  mem_axi_arsize,
    output [1:0]  mem_axi_arburst,
    (*mark_debug="true"*)output        mem_axi_arvalid,
    (*mark_debug="true"*)input         mem_axi_arready,
    (*mark_debug="true"*)output        mem_axi_rready,
    input  [6:0]  mem_axi_rid,
    (*mark_debug="true"*)input [31:0]  mem_axi_rdata,
    input  [1:0]  mem_axi_rresp,
    input         mem_axi_rlast,
    (*mark_debug="true"*)input         mem_axi_rvalid,

    input  wire   spi_interrupt,
    output [3:0]  bootrom_axi_awid,
    output [31:0] bootrom_axi_awaddr,
    output [7:0]  bootrom_axi_awlen,
    output [2:0]  bootrom_axi_awsize,
    output [1:0]  bootrom_axi_awburst,
    output        bootrom_axi_awvalid,
    input         bootrom_axi_awready,
    output [31:0] bootrom_axi_wdata,
    output [3:0]  bootrom_axi_wstrb,
    output        bootrom_axi_wlast,
    output        bootrom_axi_wvalid,
    input         bootrom_axi_wready,
    output        bootrom_axi_bready,
    input  [3:0]  bootrom_axi_bid,
    input  [1:0]  bootrom_axi_bresp,
    input         bootrom_axi_bvalid,
    output [3:0]  bootrom_axi_arid,
    output [31:0] bootrom_axi_araddr,
    output [7:0]  bootrom_axi_arlen,
    output [2:0]  bootrom_axi_arsize,
    output [1:0]  bootrom_axi_arburst,
    output        bootrom_axi_arvalid,
    input         bootrom_axi_arready,
    output        bootrom_axi_rready,
    input [3:0]   bootrom_axi_rid,
    input [31:0]  bootrom_axi_rdata,
    input [1:0]   bootrom_axi_rresp,
    input         bootrom_axi_rlast,
    input         bootrom_axi_rvalid,

    input         uart_txd_i,
    output        uart_txd_o,
    output        uart_txd_en,
    input         uart_rxd_i,
    output        uart_rxd_o,
    output        uart_rxd_en,
`ifdef _USE_MII
    input           mii_tx_clk,
    output  [3:0]   mii_txd,    
    output          mii_tx_en,
    output          mii_tx_er,

    input           mii_rx_clk,
    input   [3:0]   mii_rxd, 
    input           mii_rxdv,
    input           mii_rx_err,
    input           mii_crs,
    input           mii_col,
`else
    input           rmii_ref_clk,  
    output  [1:0]   rmii_txd,    
    output          rmii_tx_en,   

    input   [1:0]   rmii_rxd,    
    input           rmii_crs_rxdv,   
    input           rmii_rx_err,
`endif    
    input           md_i_0,      
    output          mdc_0,
    output          md_o_0,
    output          md_t_0,
    output          phy_rstn,
    
    output [15:0]   led,
    
    // input           sd_ncd,
    input  [3:0]    sd_dat_i,
    output [3:0]    sd_dat_o,
    output          sd_dat_t,
    input           sd_cmd_i,
    output          sd_cmd_o,
    output          sd_cmd_t,
    output          sd_clk,
    
    input           ULPI_clk,
    input     [7:0] ULPI_data_i,
    output    [7:0] ULPI_data_o,
    output    [7:0] ULPI_data_t,
    output          ULPI_stp,
    input           ULPI_dir,
    input           ULPI_nxt,
    
    output          CDBUS_tx,
    output          CDBUS_tx_t,
    output          CDBUS_tx_en,
    output          CDBUS_tx_en_t,
    input           CDBUS_rx,

    output   [31:0] dat_cfg_to_ctrl,
    input    [31:0] dat_ctrl_to_cfg,

    output   [7:0] gpio_o,
    input    [7:0] gpio_i,
    output   [7:0] gpio_t,
    
    input           intr_ctrl,

    input    [1:0]  debug_output_mode,
    output   [3:0]  debug_output_data,

    input  i2cm_scl_i,
    output i2cm_scl_o,
    output i2cm_scl_t,
    input  i2cm_sda_i,
    output i2cm_sda_o,
    output i2cm_sda_t,

    output          i2s_lrclk_o,
    output          i2s_sclk_o,
    output          i2s_sdata_o,

    output wire vga_clk_o,
    output wire [11:0] vga_rgb_o,
    output wire vga_de_o,
    output wire vga_h_o,
    output wire vga_v_o,

    output cpu_aresetn,
    output cpu_global_reset
);

`define AXI_LINE(name) AXI_BUS #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(4)) name()
`define AXI_LITE_LINE(name) AXI_LITE #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32)) name()
`define AXI_LINE_W(name, idw) AXI_BUS #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(idw)) name()

`AXI_LINE(cpu_m);
`AXI_LINE(sdc_dma_m);
// `AXI_LINE(usb_dma_m);
`AXI_LINE(i2s_dma_m);
`AXI_LINE(fb_dma_m);
`AXI_LINE(jpeg_dma_m);

`AXI_LINE(mem_m);
`AXI_LINE(axilite_axi4_m);
// `AXI_LINE(usb_s);
`AXI_LINE(spi_s);

`AXI_LITE_LINE(axilite_m);
`AXI_LITE_LINE(sram_lite_s);
`AXI_LITE_LINE(apb_lite_s);
`AXI_LITE_LINE(cfg_lite_s);
`AXI_LITE_LINE(eth_lite_s);
`AXI_LITE_LINE(intc_lite_s);
`AXI_LITE_LINE(sdc_lite_s);
`AXI_LITE_LINE(jpeg_lite_s);
`AXI_LITE_LINE(i2s0_lite_s);
`AXI_LITE_LINE(i2s1_lite_s);
`AXI_LITE_LINE(fb_lite_s);

`AXI_LINE_W(mig_s, 7);

wire eth_interrupt;
wire uart_interrupt;
wire cpu_interrupt;
wire sd_interrupt;
// wire usb_interrupt;
wire cdbus_interrupt;
wire i2c_interrupt;
wire i2s_interrupt;
wire jpeg_interrupt;
// Ethernet should be at lowest bit because the configuration in intc
// (interrupt of emaclite is a pulse interrupt, not level) 
wire [7:0] interrupts = {'0, i2c_interrupt, cdbus_interrupt, /*usb_interrupt*/ '0, spi_interrupt, eth_interrupt};
cpu_wrapper #(
    .C_ASIC_SRAM(C_ASIC_SRAM)
) cpu (
    .cpu_clk(cpu_clk),
    .m0_clk(soc_clk),
    .m0_aresetn(aresetn),
    .interrupt({sd_interrupt, uart_interrupt, jpeg_interrupt, i2s_interrupt, intr_ctrl, cpu_interrupt}),
    .m0(cpu_m),

    .debug_output_mode(debug_output_mode),
    .debug_output_data(debug_output_data),
    .cpu_aresetn,
    .cpu_global_reset
);

function automatic logic [1:0] axi4_periph_addr_sel(input logic [ 31 : 0 ] addr);
    automatic logic [1:0] select;
    if (addr[31:28] == 4'b0000)     // Memory Controller == 256MB
        select = 0;
    else if (addr[31:20]==12'h1c0 || addr[31:16] == 16'h1d00)
        select = 1;                 // SPI device
    else if (addr[31:20]==12'h1d0)  // all axi-lite device
        select = 2;
//    else if (addr[31:20]==12'h1d1)  // USB Controller
//        select = 3;
    else  // ERROR
        select = 2;
    return select;
endfunction

my_axi_demux_intf #(
    .AXI_ID_WIDTH(4),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .NO_MST_PORTS(3),
    .MAX_TRANS(2),
    .AXI_LOOK_BITS(2)
) cpu_demux (
    .clk_i(soc_clk),
    .rst_ni(aresetn),
    .test_i(1'b0),
    .slv_aw_select_i(axi4_periph_addr_sel(cpu_m.aw_addr)),
    .slv_ar_select_i(axi4_periph_addr_sel(cpu_m.ar_addr)),
    .slv(cpu_m),
    .mst0(mem_m),
    .mst1(spi_s),
    .mst2(axilite_axi4_m)  // lite
    // .mst3(usb_s)
);

function automatic logic [3:0] axi4lite_periph_addr_sel(input logic [ 31 : 0 ] addr);
    automatic logic [3:0] select;
    if(addr[19:16]==4'h1 || addr[19:16]==4'h2 || addr[19:16]==4'h3) // APB(UART, I2C, CDBUS)
        select = 1;
    else if(addr[19:16]==4'h4) // CONF
        select = 2;
    else if(addr[19:16]==4'h5) // ETHERNET
        select = 3;
    else if(addr[19:16]==4'h6) // Interrupt Controller
        select = 4;
    else if(addr[19:16]==4'h7) // SD Controller
        select = 5;
    else if(addr[19:16]==4'ha) // JPEG Controller
        select = 6;
    else if(addr[19:16]==4'hb) // I2S CONTROLLER-0
        select = 7;
    else if(addr[19:16]==4'hc) // I2S CONTROLLER-1
        select = 8;
    else if(addr[19:16]==4'hd) // VGA Controller lite
        select = 9;
    else  // SRAM Controller(Waiting for implementation)
        select = 0;
    return select;
endfunction

axi_to_axi_lite_intf #(
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .AXI_ID_WIDTH(4),
    .FALL_THROUGH(0)
) slv_conv (
    .clk_i(soc_clk),
    .rst_ni(aresetn),
    .testmode_i(1'b0),
    .slv(axilite_axi4_m),
    .mst(axilite_m)
);

my_axi_lite_demux_intf # (
    .AxiAddrWidth(32),
    .AxiDataWidth(32),
    .NoMstPorts(10),
    .MaxTrans(2)
  )
  my_axi_lite_demux_intf_inst (
    .clk_i(soc_clk),
    .rst_ni(aresetn),
    .test_i('0),
    .slv_aw_select_i(axi4lite_periph_addr_sel(axilite_m.aw_addr)),
    .slv_ar_select_i(axi4lite_periph_addr_sel(axilite_m.ar_addr)),
    .slv(axilite_m),
    .mst0(sram_lite_s),
    .mst1(apb_lite_s),
    .mst2(cfg_lite_s),
    .mst3(eth_lite_s),
    .mst4(intc_lite_s),
    .mst5(sdc_lite_s),
    .mst6(jpeg_lite_s),
    .mst7(i2s0_lite_s),
    .mst8(i2s1_lite_s),
    .mst9(fb_lite_s)
  );

axi_mux_intf #(
    .SLV_AXI_ID_WIDTH(4),
    .MST_AXI_ID_WIDTH(7),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .NO_SLV_PORTS(5),
    .MAX_W_TRANS(2),
    .FALL_THROUGH(0)
) mem_mux (
    .clk_i(soc_clk),
    .rst_ni(aresetn),
    .test_i(1'b0),
    .slv0(sdc_dma_m),
    .slv1(mem_m),
    // .slv2(usb_dma_m),
    .slv2(fb_dma_m),
    .slv3(i2s_dma_m),
    .slv4(jpeg_dma_m),
    .mst(mig_s)
);

sram_wrapper  sram_wrapper_inst (
    .aclk(soc_clk),
    .aresetn(aresetn),
    .slv(sram_lite_s)
  );

axi_intc_wrapper #(
    .C_NUM_INTR_INPUTS($bits(interrupts))
) intc (
    .slv(intc_lite_s),
    .aclk(soc_clk),
    .aresetn(aresetn),
    .irq_i(interrupts),
    .irq_o(cpu_interrupt)
);

//eth top
`ifdef _USE_MII
ethernet_wrapper_mii #(
    .C_ASIC_SRAM(C_ASIC_SRAM)
) ethernet_mii (
    .aclk        (soc_clk  ),
    .aresetn     (aresetn  ),      
    .slv         (eth_lite_s),

    .interrupt_0 (eth_interrupt),
 
    .mii_tx_clk,
    .mii_txd,    
    .mii_tx_en,
    .mii_tx_er,

    .mii_rx_clk,
    .mii_rxd, 
    .mii_rxdv,
    .mii_rx_err,
    .mii_crs,
    .mii_col,

    .md_i_0,      
    .mdc_0,
    .md_o_0,
    .md_t_0,
    .phy_rstn
);
`else
ethernet_wrapper #(
    .C_ASIC_SRAM(C_ASIC_SRAM)
) ethernet (
    .aclk        (soc_clk  ),
    .aresetn     (aresetn  ),      
    .slv         (eth_lite_s),

    .interrupt_0 (eth_interrupt),
 
    .rmii_ref_clk (rmii_ref_clk   ),
    .rmii_txd     (rmii_txd       ),    
    .rmii_tx_en   (rmii_tx_en     ),   

    .rmii_rxd     (rmii_rxd       ),    
    .rmii_crs_rxdv(rmii_crs_rxdv  ),   
    .rmii_rx_err  (rmii_rx_err    ),  

    // MDIO
    .mdc_0        (mdc_0    ),
    .md_i_0       (md_i_0   ),
    .md_o_0       (md_o_0   ),       
    .md_t_0       (md_t_0   ),
    .phy_rstn     (phy_rstn )
);
`endif
axi_sdc_wrapper sdc(
    .aclk(soc_clk),
    .aresetn(aresetn),
    
    .slv(sdc_lite_s),
    .dma_mst(sdc_dma_m),
    .interrupt(sd_interrupt),
    
    .sd_ncd('0),
    .sd_dat_i(sd_dat_i),
    .sd_dat_o(sd_dat_o),
    .sd_dat_t(sd_dat_t),
    .sd_cmd_i(sd_cmd_i),
    .sd_cmd_o(sd_cmd_o),
    .sd_cmd_t(sd_cmd_t),
    .sd_clk(sd_clk)
);

wire [23:0] vga_rgb;
wire vga_de, vga_h, vga_v;
wire vga_clk;    // vga_clk    == soc_clk / 4
wire vga_clk_x2; // vga_clk_x2 == soc_clk / 2

reg [11:0] vga_data_q;
reg vga_clk_q;
reg vga_de_q;
reg vga_h_q;
reg vga_v_q;
always_ff @(posedge soc_clk) begin
    vga_data_q <= vga_clk ? vga_rgb[23:12] : vga_rgb[11:0];
    vga_clk_q <= vga_clk;
    vga_de_q <= vga_de;
    vga_h_q <= vga_h;
    vga_v_q <= vga_v;
end
assign vga_clk_o = vga_clk_q;
assign vga_rgb_o = vga_data_q;
assign vga_de_o = vga_de_q;
assign vga_h_o = vga_h_q;
assign vga_v_o = vga_v_q;

configurable_framebuffer  configurable_framebuffer_inst (
    .clk(soc_clk),
    .rst_n(aresetn),
    .slv(fb_lite_s),
    .dma(fb_dma_m),
    .vga_clk_x2_o(vga_clk_x2),
    .vga_clk_o(vga_clk),
    .vga_de_o(vga_de),
    .vga_h_o(vga_h),
    .vga_v_o(vga_v),
    .vga_r_o(vga_rgb[23:16]),
    .vga_g_o(vga_rgb[15:8]),
    .vga_b_o(vga_rgb[7:0])
  );

// jpeg
jpeg_decoder_wrapper  jpeg_decoder (
    .aclk(soc_clk),
    .aresetn(aresetn),

    .ctl_slv(jpeg_lite_s),
    .dma_mst(jpeg_dma_m),
    
    .irq_o(jpeg_interrupt)
);

i2s_wrapper  i2s_wrapper_inst (
    .aclk(soc_clk),
    .aresetn(aresetn),
    .i2s_clk(i2s_clk), // 24.576MHz

    .lrclk_o(i2s_lrclk_o),
    .sclk_o(i2s_sclk_o),
    .sdata_o(i2s_sdata_o),

    .i2s0_slv(i2s0_lite_s),
    .i2s1_slv(i2s1_lite_s),
    .dma_mst(i2s_dma_m),
    .irq(i2s_interrupt)
  );

usb_wrapper #(
    .C_ASIC_SRAM(C_ASIC_SRAM)
) usb_ctrl (
   .aclk(soc_clk),
   .aresetn(aresetn),
   // .slv(/*usb_s*/),
   .interrupt(/*usb_interrupt*/),
   // .dma_mst(/*usb_dma_m*/),

   .ULPI_clk,
   .ULPI_data_i,
   .ULPI_data_o,
   .ULPI_data_t,
   .ULPI_stp,
   .ULPI_dir,
   .ULPI_nxt
);

//confreg
confreg CONFREG(
    .aclk           (soc_clk            ),       
    .aresetn        (aresetn            ),       
    .s_awid         ('0                 ),
    .s_awaddr       (cfg_lite_s.aw_addr ),
    .s_awlen        ('0                 ),
    .s_awsize       (cfg_lite_s.aw_size ),
    .s_awburst      ('0                 ),
    .s_awlock       ('0                 ),
    .s_awcache      ('0                 ),
    .s_awprot       ('0                 ),
    .s_awvalid      (cfg_lite_s.aw_valid),
    .s_awready      (cfg_lite_s.aw_ready),
    .s_wready       (cfg_lite_s.w_ready ),
    .s_wdata        (cfg_lite_s.w_data  ),
    .s_wstrb        (cfg_lite_s.w_strb  ),
    .s_wlast        ('1                 ),
    .s_wvalid       (cfg_lite_s.w_valid ),
    .s_bid          (                   ),
    .s_bresp        (cfg_lite_s.b_resp  ),
    .s_bvalid       (cfg_lite_s.b_valid ),
    .s_bready       (cfg_lite_s.b_ready ),
    .s_arid         ('0                 ),
    .s_araddr       (cfg_lite_s.ar_addr ),
    .s_arlen        ('0                 ),
    .s_arsize       (cfg_lite_s.ar_size ),
    .s_arburst      ('0                 ),
    .s_arlock       ('0                 ),
    .s_arcache      ('0                 ),
    .s_arprot       ('0                 ),
    .s_arvalid      (cfg_lite_s.ar_valid),
    .s_arready      (cfg_lite_s.ar_ready),
    .s_rready       (cfg_lite_s.r_ready ),
    .s_rid          (                   ),
    .s_rdata        (cfg_lite_s.r_data  ),
    .s_rresp        (cfg_lite_s.r_resp  ),
    .s_rlast        (                   ),
    .s_rvalid       (cfg_lite_s.r_valid ),

    .dat_cfg_to_ctrl,
    .dat_ctrl_to_cfg,
    .gpio_o,
    .gpio_i,
    .gpio_t
);

axi2apb_misc #(.C_ASIC_SRAM(C_ASIC_SRAM)) APB_DEV 
(
    .clk                (soc_clk            ),
    .rst_n              (aresetn            ),

    .axi_s_awid         ('0                 ),
    .axi_s_awaddr       (apb_lite_s.aw_addr ),
    .axi_s_awlen        ('0                 ),
    .axi_s_awsize       (apb_lite_s.aw_size ),
    .axi_s_awburst      ('0                 ),
    .axi_s_awlock       ('0                 ),
    .axi_s_awcache      ('0                 ),
    .axi_s_awprot       ('0                 ),
    .axi_s_awvalid      (apb_lite_s.aw_valid),
    .axi_s_awready      (apb_lite_s.aw_ready),
    .axi_s_wready       (apb_lite_s.w_ready ),
    .axi_s_wdata        (apb_lite_s.w_data  ),
    .axi_s_wstrb        (apb_lite_s.w_strb  ),
    .axi_s_wlast        ('1                 ),
    .axi_s_wvalid       (apb_lite_s.w_valid ),
    .axi_s_bid          (                   ),
    .axi_s_bresp        (apb_lite_s.b_resp  ),
    .axi_s_bvalid       (apb_lite_s.b_valid ),
    .axi_s_bready       (apb_lite_s.b_ready ),
    .axi_s_arid         ('0                 ),
    .axi_s_araddr       (apb_lite_s.ar_addr ),
    .axi_s_arlen        ('0                 ),
    .axi_s_arsize       (apb_lite_s.ar_size ),
    .axi_s_arburst      ('0                 ),
    .axi_s_arlock       ('0                 ),
    .axi_s_arcache      ('0                 ),
    .axi_s_arprot       ('0                 ),
    .axi_s_arvalid      (apb_lite_s.ar_valid),
    .axi_s_arready      (apb_lite_s.ar_ready),
    .axi_s_rready       (apb_lite_s.r_ready ),
    .axi_s_rid          (                   ),
    .axi_s_rdata        (apb_lite_s.r_data  ),
    .axi_s_rresp        (apb_lite_s.r_resp  ),
    .axi_s_rlast        (                   ),
    .axi_s_rvalid       (apb_lite_s.r_valid ),


    .uart0_txd_i        (uart_txd_i ),
    .uart0_txd_o        (uart_txd_o ),
    .uart0_txd_oe       (uart_txd_en),
    .uart0_rxd_i        (uart_rxd_i ),
    .uart0_rxd_o        (uart_rxd_o ),
    .uart0_rxd_oe       (uart_rxd_en),
    .uart0_rts_o        (       ),
    .uart0_dtr_o        (       ),
    .uart0_cts_i        (1'b0   ),
    .uart0_dsr_i        (1'b0   ),
    .uart0_dcd_i        (1'b0   ),
    .uart0_ri_i         (1'b0   ),
    .cdbus_tx           (CDBUS_tx),
    .cdbus_tx_t         (CDBUS_tx_t),
    .cdbus_rx           (CDBUS_rx),
    .cdbus_tx_en        (CDBUS_tx_en),
    .cdbus_tx_en_t      (CDBUS_tx_en_t),

    .i2cm_scl_i,
    .i2cm_scl_o,
    .i2cm_scl_t, 

    .i2cm_sda_i,
    .i2cm_sda_o,
    .i2cm_sda_t,

    .uart0_int          (uart_interrupt),
    .cdbus_int          (cdbus_interrupt),
    .i2c_int            (i2c_interrupt)
);


    assign mem_axi_awid = mig_s.aw_id;
    assign mem_axi_awaddr = mig_s.aw_addr;
    assign mem_axi_awlen = mig_s.aw_len;
    assign mem_axi_awsize = mig_s.aw_size;
    assign mem_axi_awburst = mig_s.aw_burst;
    assign mem_axi_awvalid = mig_s.aw_valid;
    assign mig_s.aw_ready = mem_axi_awready;
    assign mem_axi_wdata = mig_s.w_data;
    assign mem_axi_wstrb = mig_s.w_strb;
    assign mem_axi_wlast = mig_s.w_last;
    assign mem_axi_wvalid = mig_s.w_valid;
    assign mig_s.w_ready = mem_axi_wready;
    assign mem_axi_bready = mig_s.b_ready;
    assign mig_s.b_id = mem_axi_bid;
    assign mig_s.b_resp = mem_axi_bresp;
    assign mig_s.b_valid = mem_axi_bvalid;
    assign mem_axi_arid = mig_s.ar_id;
    assign mem_axi_araddr = mig_s.ar_addr;
    assign mem_axi_arlen = mig_s.ar_len;
    assign mem_axi_arsize = mig_s.ar_size;
    assign mem_axi_arburst = mig_s.ar_burst;
    assign mem_axi_arvalid = mig_s.ar_valid;
    assign mig_s.ar_ready = mem_axi_arready;
    assign mem_axi_rready = mig_s.r_ready;
    assign mig_s.r_id = mem_axi_rid;
    assign mig_s.r_data = mem_axi_rdata;
    assign mig_s.r_resp = mem_axi_rresp;
    assign mig_s.r_last = mem_axi_rlast;
    assign mig_s.r_valid = mem_axi_rvalid;

    assign bootrom_axi_awid = spi_s.aw_id;
    assign bootrom_axi_awaddr = spi_s.aw_addr;
    assign bootrom_axi_awlen = spi_s.aw_len;
    assign bootrom_axi_awsize = spi_s.aw_size;
    assign bootrom_axi_awburst = spi_s.aw_burst;
    assign bootrom_axi_awvalid = spi_s.aw_valid;
    assign spi_s.aw_ready = bootrom_axi_awready;
    assign bootrom_axi_wdata = spi_s.w_data;
    assign bootrom_axi_wstrb = spi_s.w_strb;
    assign bootrom_axi_wlast = spi_s.w_last;
    assign bootrom_axi_wvalid = spi_s.w_valid;
    assign spi_s.w_ready = bootrom_axi_wready;
    assign bootrom_axi_bready = spi_s.b_ready;
    assign spi_s.b_id = bootrom_axi_bid;
    assign spi_s.b_resp = bootrom_axi_bresp;
    assign spi_s.b_valid = bootrom_axi_bvalid;
    assign bootrom_axi_arid = spi_s.ar_id;
    assign bootrom_axi_araddr = spi_s.ar_addr;
    assign bootrom_axi_arlen = spi_s.ar_len;
    assign bootrom_axi_arsize = spi_s.ar_size;
    assign bootrom_axi_arburst = spi_s.ar_burst;
    assign bootrom_axi_arvalid = spi_s.ar_valid;
    assign spi_s.ar_ready = bootrom_axi_arready;
    assign bootrom_axi_rready = spi_s.r_ready;
    assign spi_s.r_id = bootrom_axi_rid;
    assign spi_s.r_data = bootrom_axi_rdata;
    assign spi_s.r_resp = bootrom_axi_rresp;
    assign spi_s.r_last = bootrom_axi_rlast;
    assign spi_s.r_valid = bootrom_axi_rvalid;

endmodule
