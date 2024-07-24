`timescale 1ns / 1ps
`include "iobuf_helper_fpga.svh"

module beihang325tv1_top (
    input clk_50m,                      // 25MHz 外部时钟输入
    input clk_i2s,                      // 24.576 时钟输入 --- 仅供 i2s 使用
    input sys_rstn,                     // SoC 外部复位输入

    input ctrl_rstn,                    // 系统控制器外部复位输入
    inout i2c_sda,                      // 系统控制器 I2C 数据脚
    input i2c_scl,                      // 系统控制器 I2C 时钟脚

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
    output  [2:0] SPI_CS,               // SPI 片选信号
    inout         SPI_MISO,             // SPI 数据信号（1bit SPI: MISO，Dual SPI: IO1）
    inout         SPI_MOSI,             // SPI 数据信号（1bit SPI：MOSI，Dual SPI: IO2）
    
    inout         UART_RX,              // UART
    inout         UART_TX,
    
    input         rmii_ref_clk,         // 50MHz 以太网 RMII 参考时钟输入，由外部以太网 Phy 给出
    output [1:0]  rmii_txd,             // 以下 rmii 开头的信号均在 RMII 时钟域下
    output        rmii_tx_en,

    input  [1:0]  rmii_rxd,
    input         rmii_crs_rxdv,
    input         rmii_rx_err,
    
    output        MDC,                  // MDIO 时钟（RMII 管理总线），由 SoC 时钟分频得到
    inout         MDIO,                 // MDIO 数据
    
    inout  [3:0]  SD_DAT,               // SDIO 数据输入 / 输出
    inout         SD_CMD,               // SDIO 指令输入 / 输出
    output        SD_CLK,               // SDIO 时钟输出，由 SoC 时钟分频得到
    
    input         ULPI_clk,             // 60MHz USB ULPI 参考时钟，由外部 USB Phy 给出
    inout  [7:0]  ULPI_data,            // 以下 ULPI 开头的信号均在 ULPI 时钟域下
    output        ULPI_stp,
    input         ULPI_dir,
    input         ULPI_nxt,
    
    
    // 与 I2S 复用
    // output          CDBUS_tx,           // CDBUS 总线信号，类似 UART 串口，属于 SoC 时钟域
    // output          CDBUS_tx_en,
    // input           CDBUS_rx,

    // 与 HDMI 复用
    // inout  [7:0] gpio,


    // 与 I2S 复用
    // output          CDBUS_tx,           // CDBUS 总线信号，类似 UART 串口，属于 SoC 时钟域
    // output          CDBUS_tx_en,
    // input           CDBUS_rx,

    // 与 HDMI 复用
    // inout  [7:0] gpio,

    inout i2cm_scl,
    inout i2cm_sda,

    // I2S | CDBUS
    output        I2S_lrclk_CDBUS_tx,
    output        I2S_sclk_CDBUS_tx_en,
    inout         I2S_sdata_CDBUS_rx,

    // VGA
    output [3:0] VGA_RGB_11_8,
    inout  [7:0] VGA_RGB_7_0_GPIO,
    output VGA_CLK,
    output VGA_DE,
    output VGA_H,
    output VGA_V
);

// NOTE: en==0 means output, en==1 means input!!!
`IPAD_GEN_SIMPLE(clk_50m)
`IPAD_GEN_SIMPLE(clk_i2s)
// `OPAD_GEN_SIMPLE(fpga_clk_i2s_o)
`IPAD_GEN_SIMPLE(sys_rstn)
`IPAD_GEN_SIMPLE(ctrl_rstn)

// uart
`IOBUF_GEN_SIMPLE(UART_TX)
`IOBUF_GEN_SIMPLE(UART_RX)
// i2c sys ctrl
`IOBUF_GEN_SIMPLE(i2c_sda)
`IPAD_GEN_SIMPLE(i2c_scl)
// sdram ctrl
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
// spi bus
`OPAD_GEN_SIMPLE(SPI_CLK)
`OPAD_GEN_VEC_SIMPLE(SPI_CS)
`IOBUF_GEN_SIMPLE(SPI_MISO)
`IOBUF_GEN_SIMPLE(SPI_MOSI)
// ethernet rmii ctrl
`IPAD_GEN_SIMPLE(rmii_ref_clk)
`OPAD_GEN_VEC_SIMPLE(rmii_txd)
`OPAD_GEN_SIMPLE(rmii_tx_en)
`IPAD_GEN_VEC_SIMPLE(rmii_rxd)
`IPAD_GEN_SIMPLE(rmii_crs_rxdv)
`IPAD_GEN_SIMPLE(rmii_rx_err)
`OPAD_GEN_SIMPLE(MDC)
`IOBUF_GEN_SIMPLE(MDIO)
// sd card ctrl
`OPAD_GEN_SIMPLE(SD_CLK)
`IOBUF_GEN_SIMPLE(SD_CMD)
`IOBUF_GEN_VEC_UNIFORM_SIMPLE(SD_DAT)
// usb phy ulpi ctrl
`IPAD_GEN_SIMPLE(ULPI_clk)
`IOBUF_GEN_VEC_SIMPLE(ULPI_data)
`OPAD_GEN_SIMPLE(ULPI_stp)
`IPAD_GEN_SIMPLE(ULPI_dir)
`IPAD_GEN_SIMPLE(ULPI_nxt)
// i2c master
`IOBUF_GEN_SIMPLE(i2cm_scl)
`IOBUF_GEN_SIMPLE(i2cm_sda)

// vga-only_ports
`OPAD_GEN_SIMPLE(VGA_CLK)
`OPAD_GEN_SIMPLE(VGA_DE)
`OPAD_GEN_SIMPLE(VGA_H)
`OPAD_GEN_SIMPLE(VGA_V)
`OPAD_GEN_VEC_SIMPLE(VGA_RGB_11_8)

// vga | gpio mux
wire output_enable_hdmi;
`IOBUF_GEN_VEC_SIMPLE(VGA_RGB_7_0_GPIO)
wire [7:0] vga_rgb_7_0;
wire [7:0] gpio_i;
wire [7:0] gpio_o;
wire [7:0] gpio_t;
assign VGA_RGB_7_0_GPIO_t = output_enable_hdmi ? '0 : gpio_t;
assign VGA_RGB_7_0_GPIO_o = output_enable_hdmi ? vga_rgb_7_0 : gpio_o;
assign gpio_i = VGA_RGB_7_0_GPIO_i;

// I2S | CDBUS MUX
wire output_enable_i2s;
`OEPAD_GEN_SIMPLE(I2S_lrclk_CDBUS_tx)
`OEPAD_GEN_SIMPLE(I2S_sclk_CDBUS_tx_en)
`IOBUF_GEN_SIMPLE(I2S_sdata_CDBUS_rx)
wire i2s_lrclk_w;
wire i2s_sclk_w;
wire i2s_sdata_w;
wire cdbus_tx_w, cdbus_tx_t_w;
wire cdbus_tx_en_w, cdbus_tx_en_t_w;
wire cdbus_rx_w;
assign cdbus_rx_w = I2S_sdata_CDBUS_rx_i;
assign I2S_sdata_CDBUS_rx_o = i2s_sdata_w;
assign I2S_sdata_CDBUS_rx_t = ~output_enable_i2s; // 输出 I2S 时，配置为输出，否之为输入

assign I2S_lrclk_CDBUS_tx_t = output_enable_i2s ? '0 : cdbus_tx_t_w;
assign I2S_sclk_CDBUS_tx_en_t = output_enable_i2s ? '0 : cdbus_tx_en_t_w;
assign I2S_lrclk_CDBUS_tx_c = output_enable_i2s ? i2s_lrclk_w : cdbus_tx_w;
assign I2S_sclk_CDBUS_tx_en_c = output_enable_i2s ? i2s_sclk_w : cdbus_tx_en_w;


wire soc_clk;
wire cpu_clk;
wire i2s_clk;
wire soc_aresetn;

wire [7:0]  CPU_PLL_MUL,
            CPU_PLL_DIV, 
            SOC_PLL_MUL, 
            SOC_PLL_DIV,
            PLL_CTRL,
            SPI_DIV_CTRL,
            DBG_CTRL,
            OUTPUT_MUX_CTRL;
assign output_enable_hdmi = OUTPUT_MUX_CTRL[0];
assign output_enable_i2s  = OUTPUT_MUX_CTRL[1];

wire [31:0] dat_ctrl_to_cfg,
            dat_cfg_to_ctrl;
wire [31:0] dat_ctrl_to_cfg_soc,
            dat_cfg_to_ctrl_soc;
wire [3:0]  spi_div_ctrl_soc;

wire CPU_PLL_OE = PLL_CTRL[0], CPU_PLL_BP = PLL_CTRL[1], SOC_PLL_OE = PLL_CTRL[2], SOC_PLL_BP = PLL_CTRL[3], CTRL_SYS_RSTN = PLL_CTRL[4], CTRL_INTR = PLL_CTRL[5];

stolen_cdc_sync_rst soc_rstgen(
    .dest_clk(soc_clk),
    .dest_rst(soc_aresetn),
    .src_rst(sys_rstn_c || CTRL_SYS_RSTN)
);

assign i2c_sda_t = i2c_sda_o;

wire i2c_rstn;
stolen_cdc_sync_rst ctrl_rstgen(
    .dest_clk(clk_50m_c),
    .dest_rst(i2c_rstn),
    .src_rst(ctrl_rstn_c)
);

i2cSlave #(
    .C_NUM_OUTPUT_REGS(12),
    .C_NUM_INPUT_REGS(4)
) i2c_ctrl (
  .clk     (clk_50m_c     ),
  .rst     (~i2c_rstn     ),
  .scl     (i2c_scl_c     ),
  .sdaIn   (i2c_sda_i     ),
  .sdaOut  (i2c_sda_o     ),
  .outputs ({dat_ctrl_to_cfg[31:24], dat_ctrl_to_cfg[23:16], dat_ctrl_to_cfg[15:8], dat_ctrl_to_cfg[7:0], 
      OUTPUT_MUX_CTRL, DBG_CTRL, SPI_DIV_CTRL, PLL_CTRL, SOC_PLL_DIV  , SOC_PLL_MUL, CPU_PLL_DIV  , CPU_PLL_MUL}),
  .defaults({8'b0,                   8'b0,                   8'b0,                  8'b0,
             8'b11   , 8'b101  , 8'b000010   , 8'b0    , {3'd1, 5'd1} , 8'd30      , {3'd1, 5'd2}, 8'd46       }),
  .inputs  ({dat_cfg_to_ctrl[31:24], dat_cfg_to_ctrl[23:16], dat_cfg_to_ctrl[15:8], dat_cfg_to_ctrl[7:0]       })
);

CLK_GEN CLK_GEN(
    .clk_50m(clk_50m_c),
    .CPU_CLK(cpu_clk),
    .SOC_CLK(soc_clk)
);

stolen_cdc_array_single #(2, 1, 32) dat_ctrl_to_cfg_sync (
   .src_clk(clk_50m_c),
   .src_in(dat_ctrl_to_cfg),
   .dest_clk(soc_clk),
   .dest_out(dat_ctrl_to_cfg_soc)
);

stolen_cdc_array_single #(2, 1, 32) dat_cfg_to_ctrl_sync (
   .src_clk(soc_clk),
   .src_in(dat_cfg_to_ctrl_soc),
   .dest_clk(clk_50m_c),
   .dest_out(dat_cfg_to_ctrl)
);

stolen_cdc_array_single #(2, 1, 4) spi_div_ctrl_sync (
   .src_clk(clk_50m_c),
   .src_in(SPI_DIV_CTRL[3:0]),
   .dest_clk(soc_clk),
   .dest_out(spi_div_ctrl_soc)
);

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

wire spi_interrupt, spi_nc;
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
    .s_wready       (bootrom_axi_wready    ),
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
    .csn_o          ({spi_nc,SPI_CS_c[2:0]}),
    .sck_o          (SPI_CLK_c             ),
    .sdo_i          (SPI_MOSI_i            ),
    .sdo_o          (SPI_MOSI_o            ),
    .sdo_en         (SPI_MOSI_t            ),  // Notice: en==0 means output, en==1 means input!
    .sdi_i          (SPI_MISO_i            ),
    .sdi_o          (SPI_MISO_o            ),
    .sdi_en         (SPI_MISO_t            ),
    .inta_o         (spi_interrupt         ),
    
    .default_div    (spi_div_ctrl_soc      )
);
(*mark_debug="true"*) wire [2:0] dbg_spi_cs = SPI_CS_c;
(*mark_debug="true"*) wire dbg_spi_clk = SPI_CLK_c;
(*mark_debug="true"*) wire dbg_spi_mosi = SPI_MOSI_o;
(*mark_debug="true"*) wire dbg_spi_mosi_t = SPI_MOSI_t;
(*mark_debug="true"*) wire dbg_spi_miso = SPI_MISO_i;
(*mark_debug="true"*) wire dbg_spi_miso_t = SPI_MISO_t;
(*mark_debug="true"*) wire dbg_uart_rx = UART_RX_i;
(*mark_debug="true"*) wire dbg_uart_tx = UART_TX_o;
// 以下 ULPI 开头的信号均在 ULPI 时钟域下
(*mark_debug="true"*) wire [7:0]  dbg_ULPI_data = ULPI_data_i;
(*mark_debug="true"*) wire [7:0]  dbg_ULPI_data_o = ULPI_data_o;
(*mark_debug="true"*) wire [7:0]  dbg_ULPI_data_t = ULPI_data_t;
(*mark_debug="true"*) wire        dbg_ULPI_stp  = ULPI_stp_c;
(*mark_debug="true"*) wire        dbg_ULPI_dir  = ULPI_dir_c;
(*mark_debug="true"*) wire        dbg_ULPI_nxt  = ULPI_nxt_c;
// SDRAM
(*mark_debug="true"*) wire [12:0] dbg_sdram_addr = sdram_ADDR_c;
(*mark_debug="true"*) wire [1:0] dbg_sdram_ba = sdram_BA_c;
(*mark_debug="true"*) wire [31:0] dbg_sdram_dq = sdram_DQ_i;
(*mark_debug="true"*) wire [3:0]  dbg_sdram_dqm = sdram_DQM_c;
(*mark_debug="true"*) wire        dbg_sdram_casn = sdram_CASn_c;
(*mark_debug="true"*) wire        dbg_sdram_cke = sdram_CKE_c;
(*mark_debug="true"*) wire [1:0]  dbg_sdram_csn = sdram_CSn_c;
(*mark_debug="true"*) wire        dbg_sdram_rasn = sdram_RASn_c;
(*mark_debug="true"*) wire        dbg_sdram_wen = sdram_WEn_c;

wire ULPI_clk_bufg;
BUFG ULPI_BUFG(
    .I(~ULPI_clk_c),
    .O(ULPI_clk_bufg)
);

soc_top #(
    .C_ASIC_SRAM(1)
) soc (
    .soc_clk(soc_clk),
    .cpu_clk(cpu_clk),
    .i2s_clk(clk_i2s_c),
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
    
    .rmii_ref_clk (rmii_ref_clk_c ),
    .rmii_txd     (rmii_txd_c     ),    
    .rmii_tx_en   (rmii_tx_en_c   ),   

    .rmii_rxd     (rmii_rxd_c     ),    
    .rmii_crs_rxdv(rmii_crs_rxdv_c),   
    .rmii_rx_err  (rmii_rx_err_c  ),  

    // MDIO
    .mdc_0        (MDC_c    ),
    .md_i_0       (MDIO_i   ),
    .md_o_0       (MDIO_o   ),       
    .md_t_0       (MDIO_t   ),
    
    .sd_dat_i(SD_DAT_i),
    .sd_dat_o(SD_DAT_o),
    .sd_dat_t(SD_DAT_t),
    .sd_cmd_i(SD_CMD_i),
    .sd_cmd_o(SD_CMD_o),
    .sd_cmd_t(SD_CMD_t),
    .sd_clk  (SD_CLK_c),
    
    .ULPI_clk(ULPI_clk_bufg),
    .ULPI_data_i(ULPI_data_i),
    .ULPI_data_o(ULPI_data_o),
    .ULPI_data_t(ULPI_data_t),
    .ULPI_stp(ULPI_stp_c),
    .ULPI_dir(ULPI_dir_c),
    .ULPI_nxt(ULPI_nxt_c),
    
    .CDBUS_tx(cdbus_tx_w),
    .CDBUS_tx_t(cdbus_tx_t_w),
    .CDBUS_tx_en(cdbus_tx_en_w),
    .CDBUS_tx_en_t(cdbus_tx_en_t_w),
    .CDBUS_rx(cdbus_rx_w),

    .dat_cfg_to_ctrl(dat_cfg_to_ctrl_soc),
    .dat_ctrl_to_cfg(dat_ctrl_to_cfg_soc),
    .gpio_o(gpio_o),
    .gpio_i(gpio_i),
    .gpio_t(gpio_t),
    .intr_ctrl(CTRL_INTR),

    .debug_output_mode(DBG_CTRL[1:0]),

    .i2cm_scl_i(i2cm_scl_i),
    .i2cm_scl_o(i2cm_scl_o),
    .i2cm_scl_t(i2cm_scl_t), 
    .i2cm_sda_i(i2cm_sda_i),
    .i2cm_sda_o(i2cm_sda_o),
    .i2cm_sda_t(i2cm_sda_t),

    .i2s_lrclk_o(i2s_lrclk_w),
    .i2s_sclk_o(i2s_sclk_w),
    .i2s_sdata_o(i2s_sdata_w),

    .vga_clk_o(VGA_CLK_c),
    .vga_rgb_o({VGA_RGB_11_8_c, vga_rgb_7_0}),
    .vga_de_o(VGA_DE_c),
    .vga_h_o(VGA_H_c),
    .vga_v_o(VGA_V_c)
);

endmodule
