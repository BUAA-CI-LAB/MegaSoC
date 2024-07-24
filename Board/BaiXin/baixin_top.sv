`timescale 1ns / 1ps
`include "iobuf_helper_fpga.svh"
`include "debug.vh"

module baixin_top (
    input clk_100m,                     // 25MHz 外部时钟输入
    input sys_rstn,                     // SoC 外部复位输入

    output              sdram_CLK,      // SDRAM 时钟输出，等同于 SoC 时钟
    output     [12:0]   sdram_ADDR,     // 以下为 sdram 各路信号
    output     [1:0]    sdram_BA,
    inout      [31:0]   sdram_DQ,
    output     [3:0]    sdram_DQM,
    output              sdram_CASn,
    output              sdram_CKE,
    output     [1:0]    sdram_CSn,
    output              sdram_RASn,
    output              sdram_WEn,
    
    output        SPI_CLK,              // SPI 时钟，由 SoC 时钟分频得到
    output  [3:0] SPI_CS,               // SPI 片选信号
    inout         SPI_MISO,             // SPI 数据信号（1bit SPI: MISO，Dual SPI: IO1）
    inout         SPI_MOSI,             // SPI 数据信号（1bit SPI：MOSI，Dual SPI: IO2）
    
    inout         UART_RX,              // UART
    inout         UART_TX,
    
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
    output mii_phy_rstn,
    
    output        MDC,                  // MDIO 时钟（RMII 管理总线），由 SoC 时钟分频得到
    inout         MDIO,                 // MDIO 数据
    
    inout  [3:0]  SD_DAT,               // SDIO 数据输入 / 输出
    inout         SD_CMD,               // SDIO 指令输入 / 输出
    output        SD_CLK,               // SDIO 时钟输出，由 SoC 时钟分频得到
    input         SD_nCD,

    output          CDBUS_tx,           // CDBUS 总线信号，类似 UART 串口，属于 SoC 时钟域
    output          CDBUS_tx_en,
    input           CDBUS_rx,

    inout  [7:0] gpio,

    inout i2cm_scl,
    inout i2cm_sda,
    
    output hpi_nCS,
    output [1:0] hpi_addr,
    output hpi_nWR,
    output hpi_nRD,
    input hpi_INT,
    output hpi_nRESET,
    inout [15:0] hpi_data,


    // I2S
    output        I2S_lrclk,
    output        I2S_sclk,
    output        I2S_sdata,

    output [11:0] VGA_RGB,
    output VGA_CLK,
    output VGA_DE,
    output VGA_H,
    output VGA_V
);

wire soc_clk;
wire cpu_clk;
wire soc_aresetn;

`IPAD_GEN_SIMPLE(clk_100m)
`IPAD_GEN_SIMPLE(sys_rstn)
wire i2s_clk;     // 24.576M

CLK_GEN CLK_GEN(
    .clk_100m(clk_100m_c),
    .CPU_CLK(cpu_clk), // 100M
    .SOC_CLK(soc_clk), // 100M
    .i2s_clk(i2s_clk)
);

stolen_cdc_sync_rst soc_rstgen(
    .dest_clk(soc_clk),
    .dest_rst(soc_aresetn),
    .src_rst(sys_rstn_c)
);

// WARNING: en==0 means output, en==1 means input!!!
`IOBUF_GEN_SIMPLE(UART_TX)
`IOBUF_GEN_SIMPLE(UART_RX)
`IOBUF_GEN_VEC_SIMPLE(gpio)

`IOBUF_GEN_SIMPLE(i2c_sda)
`IPAD_GEN_SIMPLE(i2c_scl)

`OPAD_GEN_SIMPLE(sdram_CLK)
`OPAD_GEN_VEC_SIMPLE(sdram_ADDR)
`OPAD_GEN_VEC_SIMPLE(sdram_BA)
`OPAD_GEN_VEC_SIMPLE(sdram_DQM)
`IOBUF_GEN_VEC_SIMPLE(sdram_DQ)
`OPAD_GEN_SIMPLE(sdram_CASn)
`OPAD_GEN_SIMPLE(sdram_CKE)
`OPAD_GEN_VEC_SIMPLE(sdram_CSn)
`OPAD_GEN_SIMPLE(sdram_RASn)
`OPAD_GEN_SIMPLE(sdram_WEn)

`OPAD_GEN_SIMPLE(SPI_CLK)
`OPAD_GEN_VEC_SIMPLE(SPI_CS)
`IOBUF_GEN_SIMPLE(SPI_MISO)
`IOBUF_GEN_SIMPLE(SPI_MOSI)

`IPADG_GEN_SIMPLE(mii_tx_clk)
`IPADG_GEN_SIMPLE(mii_rx_clk)
`OPAD_GEN_VEC_SIMPLE(mii_txd)
`IPAD_GEN_VEC_SIMPLE(mii_rxd)
`OPAD_GEN_SIMPLE(mii_tx_en)
`OPAD_GEN_SIMPLE(mii_tx_er)
`IPAD_GEN_SIMPLE(mii_rxdv)
`IPAD_GEN_SIMPLE(mii_rx_err)
`IPAD_GEN_SIMPLE(mii_crs)
`IPAD_GEN_SIMPLE(mii_col)

`OPAD_GEN_SIMPLE(MDC)
`IOBUF_GEN_SIMPLE(MDIO)

`OPAD_GEN_SIMPLE(SD_CLK)
`IPAD_GEN_SIMPLE(SD_nCD)
`IOBUF_GEN_SIMPLE(SD_CMD)
`IOBUF_GEN_VEC_UNIFORM_SIMPLE(SD_DAT)

`OEPAD_GEN_SIMPLE(CDBUS_tx)
`OEPAD_GEN_SIMPLE(CDBUS_tx_en)
`IPAD_GEN_SIMPLE(CDBUS_rx)

`IOBUF_GEN_SIMPLE(i2cm_scl)
`IOBUF_GEN_SIMPLE(i2cm_sda)
    
`OPAD_GEN_SIMPLE(hpi_nCS)
`OPAD_GEN_VEC_SIMPLE(hpi_addr)
`OPAD_GEN_SIMPLE(hpi_nWR)
`OPAD_GEN_SIMPLE(hpi_nRD)
`IPAD_GEN_SIMPLE(hpi_INT)
`OPAD_GEN_SIMPLE(hpi_nRESET)
`IOBUF_GEN_VEC_SIMPLE(hpi_data)

// i2s begin
`OPAD_GEN_SIMPLE(I2S_lrclk)
`OPAD_GEN_SIMPLE(I2S_sclk)
`OPAD_GEN_SIMPLE(I2S_sdata)

// vga begin
`OPAD_GEN_SIMPLE(VGA_CLK)
`OPAD_GEN_SIMPLE(VGA_DE)
`OPAD_GEN_SIMPLE(VGA_H)
`OPAD_GEN_SIMPLE(VGA_V)
`OPAD_GEN_VEC_SIMPLE(VGA_RGB)


assign i2c_sda_t = i2c_sda_o;

wire [6:0]  mem_axi_awid;
wire [31:0] mem_axi_awaddr;
wire [7:0]  mem_axi_awlen;
wire [2:0]  mem_axi_awsize;
wire [1:0]  mem_axi_awburst;
wire        mem_axi_awvalid;
wire        mem_axi_awready;
wire [31:0] mem_axi_wdata;
wire [3:0]  mem_axi_wstrb;
wire        mem_axi_wlast;
wire        mem_axi_wvalid;
wire        mem_axi_wready;
wire        mem_axi_bready;
wire  [6:0] mem_axi_bid;
wire  [1:0] mem_axi_bresp;
wire        mem_axi_bvalid;
wire [6:0]  mem_axi_arid;
wire [31:0] mem_axi_araddr;
wire [7:0]  mem_axi_arlen;
wire [2:0]  mem_axi_arsize;
wire [1:0]  mem_axi_arburst;
wire        mem_axi_arvalid;
wire        mem_axi_arready;
wire        mem_axi_rready;
wire [6:0]  mem_axi_rid;
wire [31:0] mem_axi_rdata;
wire [1:0]  mem_axi_rresp;
wire        mem_axi_rlast;
wire        mem_axi_rvalid;

wire [3:0]  bootrom_axi_awid;
wire [31:0] bootrom_axi_awaddr;
wire [7:0]  bootrom_axi_awlen;
wire [2:0]  bootrom_axi_awsize;
wire [1:0]  bootrom_axi_awburst;
wire        bootrom_axi_awvalid;
wire        bootrom_axi_awready;
wire [31:0] bootrom_axi_wdata;
wire [3:0]  bootrom_axi_wstrb;
wire        bootrom_axi_wlast;
wire        bootrom_axi_wvalid;
wire        bootrom_axi_wready;
wire        bootrom_axi_bready;
wire  [3:0] bootrom_axi_bid;
wire  [1:0] bootrom_axi_bresp;
wire        bootrom_axi_bvalid;
wire [3:0]  bootrom_axi_arid;
wire [31:0] bootrom_axi_araddr;
wire [7:0]  bootrom_axi_arlen;
wire [2:0]  bootrom_axi_arsize;
wire [1:0]  bootrom_axi_arburst;
wire        bootrom_axi_arvalid;
wire        bootrom_axi_arready;
wire        bootrom_axi_rready;
wire [3:0]  bootrom_axi_rid;
wire [31:0] bootrom_axi_rdata;
wire [1:0]  bootrom_axi_rresp;
wire        bootrom_axi_rlast;
wire        bootrom_axi_rvalid;

assign sdram_CLK_c = soc_clk;

wire [31:0] sdram_DQ_we;
assign sdram_DQ_t = ~sdram_DQ_we;
AxiSdramCtrl sdram (
  .clk(soc_clk),
  .reset(~soc_aresetn),

        .io_bus_aw_valid(mem_axi_awvalid),
        .io_bus_aw_ready(mem_axi_awready),
        .io_bus_aw_payload_addr(mem_axi_awaddr),
        .io_bus_aw_payload_id(mem_axi_awid),
        .io_bus_aw_payload_len(mem_axi_awlen),
        .io_bus_aw_payload_size(mem_axi_awsize),
        .io_bus_aw_payload_burst(mem_axi_awburst),
        .io_bus_w_valid(mem_axi_wvalid),
        .io_bus_w_ready(mem_axi_wready),
        .io_bus_w_payload_data(mem_axi_wdata),
        .io_bus_w_payload_strb(mem_axi_wstrb),
        .io_bus_w_payload_last(mem_axi_wlast),
        .io_bus_b_valid(mem_axi_bvalid),
        .io_bus_b_ready(mem_axi_bvalid ? mem_axi_bready : 1'b1),
        .io_bus_b_payload_id(mem_axi_bid),
        .io_bus_b_payload_resp(mem_axi_bresp),
        .io_bus_ar_valid(mem_axi_arvalid),
        .io_bus_ar_ready(mem_axi_arready),
        .io_bus_ar_payload_addr(mem_axi_araddr),
        .io_bus_ar_payload_id(mem_axi_arid),
        .io_bus_ar_payload_len(mem_axi_arlen),
        .io_bus_ar_payload_size(mem_axi_arsize),
        .io_bus_ar_payload_burst(mem_axi_arburst),
        .io_bus_r_valid(mem_axi_rvalid),
        .io_bus_r_ready(mem_axi_rvalid ? mem_axi_rready : 1'b1),
        .io_bus_r_payload_data(mem_axi_rdata),
        .io_bus_r_payload_id(mem_axi_rid),
        .io_bus_r_payload_resp(mem_axi_rresp),
        .io_bus_r_payload_last(mem_axi_rlast),

        .io_sdram_ADDR(sdram_ADDR_c),
        .io_sdram_BA(sdram_BA_c),
        .io_sdram_DQ_read(sdram_DQ_i),
        .io_sdram_DQ_write(sdram_DQ_o),
        .io_sdram_DQ_writeEnable(sdram_DQ_we),
        .io_sdram_DQM(sdram_DQM_c),
        .io_sdram_CASn(sdram_CASn_c),
        .io_sdram_CKE(sdram_CKE_c),
        .io_sdram_CSn(sdram_CSn_c),
        .io_sdram_RASn(sdram_RASn_c),
        .io_sdram_WEn(sdram_WEn_c)
);

wire spi_interrupt;
spi_flash_ctrl SPI (                                         
    .aclk           (soc_clk               ),
    .aresetn        (soc_aresetn           ),
    .spi_addr       (16'h1d00              ),
    .fast_startup   (1'b0                  ),
    .s_awid         (bootrom_axi_awid      ),
    .s_awaddr       (bootrom_axi_awaddr    ),
    .s_awlen        (bootrom_axi_awlen[3:0]),
    .s_awsize       (bootrom_axi_awsize    ),
    .s_awburst      (bootrom_axi_awburst   ),
    .s_awlock       ('0                    ),
    .s_awcache      ('0                    ),
    .s_awprot       ('0                    ),
    .s_awvalid      (bootrom_axi_awvalid   ),
    .s_awready      (bootrom_axi_awready   ),
    .s_wready       (bootrom_axi_w1ready   ),
    .s_wdata        (bootrom_axi_wdata     ),
    .s_wstrb        (bootrom_axi_wstrb     ),
    .s_wlast        (bootrom_axi_wlast     ),
    .s_wvalid       (bootrom_axi_wvalid    ),
    .s_bid          (bootrom_axi_bid       ),
    .s_bresp        (bootrom_axi_bresp     ),
    .s_bvalid       (bootrom_axi_bvalid    ),
    .s_bready       (bootrom_axi_bready    ),
    .s_arid         (bootrom_axi_arid      ),
    .s_araddr       (bootrom_axi_araddr    ),
    .s_arlen        (bootrom_axi_arlen[3:0]),
    .s_arsize       (bootrom_axi_arsize    ),
    .s_arburst      (bootrom_axi_arburst   ),
    .s_arlock       ('0                    ),
    .s_arcache      ('0                    ),
    .s_arprot       ('0                    ),
    .s_arvalid      (bootrom_axi_arvalid   ),
    .s_arready      (bootrom_axi_arready   ),
    .s_rready       (bootrom_axi_rready    ),
    .s_rid          (bootrom_axi_rid       ),
    .s_rdata        (bootrom_axi_rdata     ),
    .s_rresp        (bootrom_axi_rresp     ),
    .s_rlast        (bootrom_axi_rlast     ),
    .s_rvalid       (bootrom_axi_rvalid    ),
    
    .power_down_req (1'b0                  ),
    .power_down_ack (                      ),
    .csn_o          (SPI_CS_c              ),
    .sck_o          (SPI_CLK_c             ),
    .sdo_i          (SPI_MOSI_i            ),
    .sdo_o          (SPI_MOSI_o            ),
    .sdo_en         (SPI_MOSI_t            ),  // Notice: en==0 means output, en==1 means input!
    .sdi_i          (SPI_MISO_i            ),
    .sdi_o          (SPI_MISO_o            ),
    .sdi_en         (SPI_MISO_t            ),
    .inta_o         (spi_interrupt         ),
    
    .default_div    (4'b0100               )
);

`DEBUG_W(mem_axi_araddr)
`DEBUG_W(mem_axi_arready)
`DEBUG_W(mem_axi_arvalid)
`DEBUG_W(mem_axi_rvalid)
`DEBUG_W(mem_axi_rready)
`DEBUG_W(mem_axi_rdata)
`DEBUG_W(mem_axi_awaddr)
`DEBUG_W(mem_axi_awready)
`DEBUG_W(mem_axi_awvalid)
`DEBUG_W(mem_axi_wdata)
`DEBUG_W(mem_axi_wready)
`DEBUG_W(mem_axi_wvalid)
`DEBUG_W(mem_axi_bvalid)
`DEBUG_W(mem_axi_bready)
`DEBUG_W(sdram_ADDR_c)
`DEBUG_W(sdram_BA_c)
`DEBUG_W(sdram_DQ_i)
`DEBUG_W(sdram_DQM_c)
`DEBUG_W(sdram_CASn_c)
`DEBUG_W(sdram_CKE_c)
`DEBUG_W(sdram_CSn_c)
`DEBUG_W(sdram_RASn_c)
`DEBUG_W(sdram_WEn_c)
`DEBUG_W(sdram_DQ_t)
`DEBUG_W(sdram_DQ_o)

soc_top #(
    .C_ASIC_SRAM(1)
) soc (
    .soc_clk(soc_clk),
    .i2s_clk(i2s_clk),
    .cpu_clk(cpu_clk),
    .aresetn(soc_aresetn),
    
    .mem_axi_awid(mem_axi_awid),
    .mem_axi_awaddr(mem_axi_awaddr),
    .mem_axi_awlen(mem_axi_awlen),
    .mem_axi_awsize(mem_axi_awsize),
    .mem_axi_awburst(mem_axi_awburst),
    .mem_axi_awvalid(mem_axi_awvalid),
    .mem_axi_awready(mem_axi_awready),
    .mem_axi_wdata(mem_axi_wdata),
    .mem_axi_wstrb(mem_axi_wstrb),
    .mem_axi_wlast(mem_axi_wlast),
    .mem_axi_wvalid(mem_axi_wvalid),
    .mem_axi_wready(mem_axi_wready),
    .mem_axi_bready(mem_axi_bready),
    .mem_axi_bid(mem_axi_bid),
    .mem_axi_bresp(mem_axi_bresp),
    .mem_axi_bvalid(mem_axi_bvalid),
    .mem_axi_arid(mem_axi_arid),
    .mem_axi_araddr(mem_axi_araddr),
    .mem_axi_arlen(mem_axi_arlen),
    .mem_axi_arsize(mem_axi_arsize),
    .mem_axi_arburst(mem_axi_arburst),
    .mem_axi_arvalid(mem_axi_arvalid),
    .mem_axi_arready(mem_axi_arready),
    .mem_axi_rready(mem_axi_rready),
    .mem_axi_rid(mem_axi_rid),
    .mem_axi_rdata(mem_axi_rdata),
    .mem_axi_rresp(mem_axi_rresp),
    .mem_axi_rlast(mem_axi_rlast),
    .mem_axi_rvalid(mem_axi_rvalid),
    
    .spi_interrupt(spi_interrupt),
    .bootrom_axi_awid(bootrom_axi_awid),
    .bootrom_axi_awaddr(bootrom_axi_awaddr),
    .bootrom_axi_awlen(bootrom_axi_awlen),
    .bootrom_axi_awsize(bootrom_axi_awsize),
    .bootrom_axi_awburst(bootrom_axi_awburst),
    .bootrom_axi_awvalid(bootrom_axi_awvalid),
    .bootrom_axi_awready(bootrom_axi_awready),
    .bootrom_axi_wdata(bootrom_axi_wdata),
    .bootrom_axi_wstrb(bootrom_axi_wstrb),
    .bootrom_axi_wlast(bootrom_axi_wlast),
    .bootrom_axi_wvalid(bootrom_axi_wvalid),
    .bootrom_axi_wready(bootrom_axi_wready),
    .bootrom_axi_bready(bootrom_axi_bready),
    .bootrom_axi_bid(bootrom_axi_bid),
    .bootrom_axi_bresp(bootrom_axi_bresp),
    .bootrom_axi_bvalid(bootrom_axi_bvalid),
    .bootrom_axi_arid(bootrom_axi_arid),
    .bootrom_axi_araddr(bootrom_axi_araddr),
    .bootrom_axi_arlen(bootrom_axi_arlen),
    .bootrom_axi_arsize(bootrom_axi_arsize),
    .bootrom_axi_arburst(bootrom_axi_arburst),
    .bootrom_axi_arvalid(bootrom_axi_arvalid),
    .bootrom_axi_arready(bootrom_axi_arready),
    .bootrom_axi_rready(bootrom_axi_rready),
    .bootrom_axi_rid(bootrom_axi_rid),
    .bootrom_axi_rdata(bootrom_axi_rdata),
    .bootrom_axi_rresp(bootrom_axi_rresp),
    .bootrom_axi_rlast(bootrom_axi_rlast),
    .bootrom_axi_rvalid(bootrom_axi_rvalid),
    
    .uart_txd_i(UART_TX_i),
    .uart_txd_o(UART_TX_o),
    .uart_txd_en(UART_TX_t),
    .uart_rxd_i(UART_RX_i),
    .uart_rxd_o(UART_RX_o),
    .uart_rxd_en(UART_RX_t),
    
    .mii_tx_clk(mii_tx_clk_c),
    .mii_txd(mii_txd_c),    
    .mii_tx_en(mii_tx_en_c),
    .mii_tx_er(mii_tx_er_c),

    .mii_rx_clk(mii_rx_clk_c),
    .mii_rxd(mii_rxd_c), 
    .mii_rxdv(mii_rxdv_c),
    .mii_rx_err(mii_rx_err_c),
    .mii_crs(mii_crs_c),
    .mii_col(mii_col_c),
    .phy_rstn(mii_phy_rstn),

    // MDIO
    .mdc_0        (MDC_c    ),
    .md_i_0       (MDIO_i   ),
    .md_o_0       (MDIO_o   ),       
    .md_t_0       (MDIO_t   ),
    
    // .sd_ncd(SD_nCD_c),
    .sd_dat_i(SD_DAT_i),
    .sd_dat_o(SD_DAT_o),
    .sd_dat_t(SD_DAT_t),
    .sd_cmd_i(SD_CMD_i),
    .sd_cmd_o(SD_CMD_o),
    .sd_cmd_t(SD_CMD_t),
    .sd_clk  (SD_CLK_c),
    
    .CDBUS_tx(CDBUS_tx_c),
    .CDBUS_tx_t(CDBUS_tx_t),
    .CDBUS_tx_en(CDBUS_tx_en_c),
    .CDBUS_tx_en_t(CDBUS_tx_en_t),
    .CDBUS_rx(CDBUS_rx_c),

    .gpio_o(gpio_o),
    .gpio_i(gpio_i),
    .gpio_t(gpio_t),
    .intr_ctrl(1'b0),

    .debug_output_mode(2'b00),

    .i2cm_scl_i,
	.i2cm_scl_o,
	.i2cm_scl_t, 

	.i2cm_sda_i,
	.i2cm_sda_o,
	.i2cm_sda_t,

    .i2s_lrclk_o           (I2S_lrclk_c),
    .i2s_sclk_o            (I2S_sclk_c),
    .i2s_sdata_o           (I2S_sdata_c),

    .vga_clk_o(VGA_CLK_c),
    .vga_rgb_o(VGA_RGB_c),
    .vga_de_o(VGA_DE_c),
    .vga_h_o(VGA_H_c),
    .vga_v_o(VGA_V_c)
	// .hpi_nCS(hpi_nCS_c),
    // .hpi_addr(hpi_addr_c),
    // .hpi_nWR(hpi_nWR_c),
    // .hpi_nRD(hpi_nRD_c),
    // .hpi_INT(hpi_INT_c),
    // .hpi_nRESET(hpi_nRESET_c),
    // .hpi_data_i,
    // .hpi_data_o,
    // .hpi_data_t
);

assign hpi_nCS_c = '0;
assign hpi_addr_c = '0;
assign hpi_nWR_c = '0;
assign hpi_nRD_c = '0;
assign hpi_nRESET_c = '0;

endmodule
