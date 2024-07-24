(* keep_hierarchy = "yes" *)
module usb_wrapper #(
    parameter C_ASIC_SRAM = 0
) (
    input aclk,
    input aresetn,
    // AXI_BUS.Slave slv,
    // AXI_BUS.Master dma_mst,
    output interrupt,
    
    input  wire       ULPI_clk,
    input  wire [7:0] ULPI_data_i,
    output wire [7:0] ULPI_data_o,
    output wire [7:0] ULPI_data_t,
    output wire       ULPI_stp,
    input  wire       ULPI_dir,
    input  wire       ULPI_nxt
);

assign interrupt = '0;
assign ULPI_data_o = '0;
assign ULPI_data_t = '1;
assign ULPI_stp = '0;
  
endmodule

