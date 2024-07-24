// 临时占位使用
module apb_dev_wrapper (
    input aclk,
    input aresetn,
    AXI_LITE.Slave slv,

    input  uart0_txd_i,
    output uart0_txd_o,
    output uart0_txd_oe,
    input  uart0_rxd_i,
    output uart0_rxd_o,
    output uart0_rxd_oe,
    output uart0_rts_o,
    output uart0_dtr_o,
    input  uart0_cts_i,
    input  uart0_dsr_i,
    input  uart0_dcd_i,
    input  uart0_ri_i,
    
    output cdbus_tx,
    output cdbus_tx_t,
    input  cdbus_rx,
    output cdbus_tx_en,
    output cdbus_tx_en_t,
    
    input  i2cm_scl_i,       // SCL-line input
    output i2cm_scl_o,       // SCL-line output (always 1'b0)
    output i2cm_scl_t,       // SCL-line output enable (active low)
    
    input  i2cm_sda_i,       // SDA-line input
    output i2cm_sda_o,       // SDA-line output (always 1'b0)
    output i2cm_sda_t,       // SDA-line output enable (active low)
    
    output uart0_int,
    output cdbus_int,
    output i2c_int
  );

  AXI_LITE #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(8)) slv_8();

  // Width Convert from 32 -> 8
  axi_lite_dw_converter_intf #(
      .AXI_ADDR_WIDTH(32),
      .AXI_SLV_PORT_DATA_WIDTH(32),
      .AXI_MST_PORT_DATA_WIDTH(8)
  ) axi_lite_dw_converter_intf_inst (
      .clk_i(aclk),        // Clock
      .rst_ni(aresetn),    // Asynchronous reset active low
      .slv(slv),
      .mst(slv_8)
  );

  wire [31:0] paddr;
  wire [2:0] pprot;
  wire [2:0] pselx;
  wire psel_uart = pselx[0];
  wire psel_cdbus = pselx[1];
  wire psel_i2c = pselx[2];
  wire penable;
  wire pwrite;
  wire [7:0] pwdata;
  wire pstrb;

  wire pready_uart = 1'b1;
  wire pready_cdbus = 1'b1;
  wire pready_i2c = 1'b1;
  wire [2:0]pready = {pready_i2c,pready_cdbus,pready_uart};
  wire [7:0]prdata_uart;
  wire [7:0]prdata_cdbus;
  wire [7:0]prdata_i2c;
  wire [2:0][7:0] prdata = {prdata_i2c,prdata_cdbus,prdata_uart};

  wire [31:0] sel_addr;
  logic [1:0] sel_idx;
  always_comb begin
    case(sel_addr[17:16])
    default: // UART
      sel_idx = 2'd0;
    2'd2: // CDBUS
      sel_idx = 2'd1;
    2'd3: // I2C
      sel_idx = 2'd2;
    endcase
  end

  // Axi lite -> Apb device
  my_axi_lite_to_apb_intf #(
      .NoApbSlaves(3),  // Number of connected APB slaves
      .AddrWidth  (32), // Address width
      .DataWidth  (8), // Data width
      .PipelineRequest  (1'b1),   // Pipeline request path
      .PipelineResponse (1'b1)    // Pipeline response path
    ) (
      .clk_i(aclk),        // Clock
      .rst_ni(aresetn),    // Asynchronous reset active low
      // AXI LITE slave port
      .slv(slv_8),
      // APB master port
      .paddr_o(paddr),
      .pprot_o(pprot),
      .pselx_o(pselx),
      .penable_o(penable),
      .pwrite_o(pwrite),
      .pwdata_o(pwdata),
      .pstrb_o(pstrb),
      .pready_i(pready),
      .prdata_i(prdata),
      .pslverr_i('0),
      // APB Slave Address Map
      .sel_addr_o(sel_addr),
      .sel_idx_i(sel_idx)
    );

    UART_TOP uart0 (
        .PCLK              (aclk        ),
        .PRST_             (aresetn     ),
        .clk_carrier       (1'b0        ),
        .PSEL              (psel_uart   ),
        .PENABLE           (penable & (~pwrite | pstrb)),
        .PADDR             (paddr[7:0]  ),
        .PWRITE            (pwrite      ),
        .PWDATA            (pwdata      ),
        .URT_PRDATA        (prdata_uart ),

        .INT               (uart0_int   ),
        .TXD_o             (uart0_txd_o ),
        .TXD_i             (uart0_txd_i ),
        .TXD_oe            (uart0_txd_oe),
        .RXD_o             (uart0_rxd_o ),
        .RXD_i             (uart0_rxd_i ),
        .RXD_oe            (uart0_rxd_oe),
        .RTS               (uart0_rts_o ),
        .CTS               (uart0_cts_i ),
        .DSR               (uart0_dsr_i ),
        .DCD               (uart0_dcd_i ),
        .DTR               (uart0_dtr_o ),
        .RI                (uart0_ri_i  )
    );
        
    cdbus #(
        .DIV_LS(868),
        .DIV_HS(868),
        .C_ASIC_SRAM(1)
    ) cdbus_ctrl (
        .clk(aclk),
        .reset_n(aresetn),
        .irq(cdbus_int),

        .chip_select(psel_cdbus),
        
        .csr_address   (paddr[4:0]                       ),
        .csr_read      (psel_cdbus && penable && !pwrite ),
        .csr_readdata  (prdata_cdbus                     ),
        .csr_write     (psel_cdbus && penable && pwrite && pstrb),
        .csr_writedata (pwdata                           ),
        
        .tx      (cdbus_tx      ),
        .tx_t    (cdbus_tx_t    ),
        .rx      (cdbus_rx      ),
        .tx_en   (cdbus_tx_en   ),
        .tx_en_t (cdbus_tx_en_t )
    );
    
    i2c_master_top i2c_ctrl(
        .clk(aclk),
        .rst(~aresetn),
        .irq(i2c_int),
    
        .csr_address   (paddr[2:0]                     ),
        .csr_read      (psel_i2c && penable && !pwrite ),
        .csr_readdata  (prdata_i2c                     ),
        .csr_write     (psel_i2c && penable && pwrite && pstrb ),
        .csr_writedata (pwdata                         ),
    
        .scl_pad_i     (i2cm_scl_i),
        .scl_pad_o     (i2cm_scl_o),
        .scl_padoen_o  (i2cm_scl_t),
        .sda_pad_i     (i2cm_sda_i),
        .sda_pad_o     (i2cm_sda_o),
        .sda_padoen_o  (i2cm_sda_t)
    );

  endmodule
