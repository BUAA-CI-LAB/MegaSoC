create_generated_clock -name vgaclk_inner -source [get_pins CLK_GEN/SOC_CLK] -edges {1 5 9} [get_pins soc/configurable_framebuffer_inst/framebuffer_gen_inst/vga_clk_q_reg/Q]
create_generated_clock -name vgaclk_pin -source [get_pins CLK_GEN/SOC_CLK] -edges {3 7 11} [get_ports VGA_CLK]

# input/output delay setting

set_multicycle_path -setup -start -from SOC_CLK_CLK_GEN -to vgaclk_pin 2
set_multicycle_path -hold -start -from SOC_CLK_CLK_GEN -to vgaclk_pin 1
set_output_delay -clock vgaclk_pin -max 0.600 [get_ports VGA_RGB*]
set_output_delay -clock vgaclk_pin -min -1.300 [get_ports VGA_RGB*]
set_output_delay -clock vgaclk_pin -max 0.900 [get_ports VGA_DE]
set_output_delay -clock vgaclk_pin -min -1.300 [get_ports VGA_DE]
set_output_delay -clock vgaclk_pin -max 0.900 [get_ports VGA_H]
set_output_delay -clock vgaclk_pin -min -1.300 [get_ports VGA_H]
set_output_delay -clock vgaclk_pin -max 0.900 [get_ports VGA_V]
set_output_delay -clock vgaclk_pin -min -1.300 [get_ports VGA_V]