# clock constraint is done in Clocking Wizard
set_property -dict {PACKAGE_PIN AC19 IOSTANDARD LVCMOS33} [get_ports clk_100m]
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS33} [get_ports sys_rstn]

set_property -dict {PACKAGE_PIN M25 IOSTANDARD LVCMOS33} [get_ports SPI_CLK]
set_property -dict {PACKAGE_PIN K26 IOSTANDARD LVCMOS33} [get_ports SPI_MISO]
set_property -dict {PACKAGE_PIN K25 IOSTANDARD LVCMOS33} [get_ports SPI_MOSI]
set_property -dict {PACKAGE_PIN L24 IOSTANDARD LVCMOS33} [get_ports {SPI_CS[0]}]
set_property -dict {PACKAGE_PIN P25 IOSTANDARD LVCMOS33} [get_ports {SPI_CS[1]}]
set_property -dict {PACKAGE_PIN R25 IOSTANDARD LVCMOS33} [get_ports {SPI_CS[2]}]
set_property -dict {PACKAGE_PIN P24 IOSTANDARD LVCMOS33} [get_ports {SPI_CS[3]}]

set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports UART_TX]
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports UART_RX]

create_clock -period 40.000 -name mii_tx_clk [get_ports mii_tx_clk]
create_clock -period 40.000 -name mii_rx_clk [get_ports mii_rx_clk]

set_property -dict {PACKAGE_PIN AA3 IOSTANDARD LVCMOS33} [get_ports mii_tx_clk]
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS33} [get_ports {mii_txd[0]}]
set_property -dict {PACKAGE_PIN AD1 IOSTANDARD LVCMOS33} [get_ports {mii_txd[1]}]
set_property -dict {PACKAGE_PIN AF2 IOSTANDARD LVCMOS33} [get_ports {mii_txd[2]}]
set_property -dict {PACKAGE_PIN AE1 IOSTANDARD LVCMOS33} [get_ports {mii_txd[3]}]
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports mii_tx_en]
set_property -dict {PACKAGE_PIN AE2 IOSTANDARD LVCMOS33} [get_ports mii_tx_er]
set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS33} [get_ports mii_rx_clk]
set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports {mii_rxd[0]}]
set_property PACKAGE_PIN U7 [get_ports {mii_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mii_rxd[1]}]
set_property PULLDOWN true [get_ports {mii_rxd[1]}]
set_property PACKAGE_PIN Y3 [get_ports {mii_rxd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mii_rxd[2]}]
set_property PULLDOWN true [get_ports {mii_rxd[2]}]
set_property PACKAGE_PIN AC2 [get_ports {mii_rxd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mii_rxd[3]}]
set_property PULLDOWN true [get_ports {mii_rxd[3]}]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports mii_rxdv]
set_property -dict {PACKAGE_PIN V1 IOSTANDARD LVCMOS33} [get_ports mii_rx_err]
set_property PACKAGE_PIN W4 [get_ports mii_crs]
set_property IOSTANDARD LVCMOS33 [get_ports mii_crs]
set_property PULLDOWN true [get_ports mii_crs]
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports mii_col]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports MDC]
set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVCMOS33} [get_ports MDIO]
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVCMOS33} [get_ports mii_phy_rstn]

set_input_delay -clock mii_rx_clk -min 10.000 [get_ports {mii_rxdv mii_rx_err mii_rxd*}]
set_input_delay -clock mii_rx_clk -max 30.000 [get_ports {mii_rxdv mii_rx_err mii_rxd*}]
set_output_delay -clock mii_tx_clk -min 0.000 [get_ports {mii_tx_en mii_txd*}]
set_output_delay -clock mii_tx_clk -max 12.000 [get_ports {mii_tx_en mii_txd*}]

set_property -dict {PACKAGE_PIN AF22 IOSTANDARD LVCMOS33} [get_ports SD_CLK]
set_property -dict {PACKAGE_PIN AD21 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[0]}]
set_property -dict {PACKAGE_PIN AE20 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[1]}]
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[2]}]
set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[3]}]
set_property -dict {PACKAGE_PIN AE22 IOSTANDARD LVCMOS33} [get_ports SD_CMD]
set_property -dict {PACKAGE_PIN AF20 IOSTANDARD LVCMOS33} [get_ports SD_nCD]

# gpio[0..3] = LED0..3, gpio[4..7] = Switch0..3
set_property -dict {PACKAGE_PIN L8 IOSTANDARD LVCMOS33} [get_ports {gpio[0]}]
set_property -dict {PACKAGE_PIN H9 IOSTANDARD LVCMOS33} [get_ports {gpio[1]}]
set_property -dict {PACKAGE_PIN G9 IOSTANDARD LVCMOS33} [get_ports {gpio[2]}]
set_property -dict {PACKAGE_PIN K8 IOSTANDARD LVCMOS33} [get_ports {gpio[3]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {gpio[4]}]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS33} [get_ports {gpio[5]}]
set_property -dict {PACKAGE_PIN AC18 IOSTANDARD LVCMOS33} [get_ports {gpio[6]}]
set_property -dict {PACKAGE_PIN AD18 IOSTANDARD LVCMOS33} [get_ports {gpio[7]}]

# FPGA_EXT0_IO16
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS33} [get_ports CDBUS_tx]
# FPGA_EXT0_IO17
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports CDBUS_rx]
# FPGA_EXT0_IO18
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports CDBUS_tx_en]
# FPGA_EXT0_IO19
set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS33} [get_ports i2cm_scl]
# FPGA_EXT0_IO20
set_property -dict {PACKAGE_PIN P26 IOSTANDARD LVCMOS33} [get_ports i2cm_sda]

set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports hpi_nCS]
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS33} [get_ports {hpi_addr[0]}]
set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS33} [get_ports {hpi_addr[1]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports hpi_nWR]
set_property -dict {PACKAGE_PIN W8 IOSTANDARD LVCMOS33} [get_ports hpi_nRD]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports hpi_INT]
set_property -dict {PACKAGE_PIN AF4 IOSTANDARD LVCMOS33} [get_ports hpi_nRESET]
set_property -dict {PACKAGE_PIN AC3 IOSTANDARD LVCMOS33} [get_ports {hpi_data[0]}]
set_property -dict {PACKAGE_PIN Y5 IOSTANDARD LVCMOS33} [get_ports {hpi_data[1]}]
set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports {hpi_data[2]}]
set_property -dict {PACKAGE_PIN AD3 IOSTANDARD LVCMOS33} [get_ports {hpi_data[3]}]
set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS33} [get_ports {hpi_data[4]}]
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS33} [get_ports {hpi_data[5]}]
set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVCMOS33} [get_ports {hpi_data[6]}]
set_property -dict {PACKAGE_PIN AF3 IOSTANDARD LVCMOS33} [get_ports {hpi_data[7]}]
set_property -dict {PACKAGE_PIN AE3 IOSTANDARD LVCMOS33} [get_ports {hpi_data[8]}]
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS33} [get_ports {hpi_data[9]}]
set_property -dict {PACKAGE_PIN AD5 IOSTANDARD LVCMOS33} [get_ports {hpi_data[10]}]
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports {hpi_data[11]}]
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS33} [get_ports {hpi_data[12]}]
set_property -dict {PACKAGE_PIN AE5 IOSTANDARD LVCMOS33} [get_ports {hpi_data[13]}]
set_property -dict {PACKAGE_PIN AF5 IOSTANDARD LVCMOS33} [get_ports {hpi_data[14]}]
set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVCMOS33} [get_ports {hpi_data[15]}]

# I2S
# FPGA_EXT0_IO21
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports I2S_lrclk]
# FPGA_EXT0_IO22
set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports I2S_sclk]
# FPGA_EXT0_IO24
set_property -dict {PACKAGE_PIN N23 IOSTANDARD LVCMOS33} [get_ports I2S_sdata]

# VGA
# N22 N21 | R2 R3 | D10 D11
# R26 P19 | R0 R1 | D8  D9
# P20 P23 | G2 G3 | D6  D7
# P21 R20 | G1 CK | D5  CK
# R22 R23 | G0 B3 | D4  D3
# T24 T25 | B2 B1 | D2  D1
# T22 T23 | B0 DE | D0  DE
# N26 R21 | HS VS | HS  VS
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33} [get_ports VGA_CLK]
create_generated_clock -name vgaclk_inner -source [get_pins clock_generator/soc_clk] -edges {1 5  9} [get_pins soc/configurable_framebuffer_inst/framebuffer_gen_inst/vga_clk_q_reg/Q]
create_generated_clock -name vgaclk_pin   -source [get_pins clock_generator/soc_clk] -edges {3 7 11} [get_ports VGA_CLK]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[10]}]
set_property -dict {PACKAGE_PIN N21 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[11]}]
set_property -dict {PACKAGE_PIN R26 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[8]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[9]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[6]}]
set_property -dict {PACKAGE_PIN P23 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[7]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[5]}]
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[4]}]
set_property -dict {PACKAGE_PIN R23 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[3]}]
set_property -dict {PACKAGE_PIN T24 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[2]}]
set_property -dict {PACKAGE_PIN T25 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[1]}]
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports {VGA_RGB[0]}]
set_property -dict {PACKAGE_PIN T23 IOSTANDARD LVCMOS33} [get_ports VGA_DE]
set_property -dict {PACKAGE_PIN N26 IOSTANDARD LVCMOS33} [get_ports VGA_H]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports VGA_V]

set_output_delay -clock vgaclk_pin -max  0.6 [get_ports VGA_RGB*]
set_output_delay -clock vgaclk_pin -min -1.3 [get_ports VGA_RGB*]
set_output_delay -clock vgaclk_pin -max  0.9 [get_ports VGA_DE]
set_output_delay -clock vgaclk_pin -min -1.3 [get_ports VGA_DE]
set_output_delay -clock vgaclk_pin -max  0.9 [get_ports VGA_H]
set_output_delay -clock vgaclk_pin -min -1.3 [get_ports VGA_H]
set_output_delay -clock vgaclk_pin -max  0.9 [get_ports VGA_V]
set_output_delay -clock vgaclk_pin -min -1.3 [get_ports VGA_V]

