set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports sdram_CLK]

create_generated_clock -name sdram_CLK -source [get_pins CLK_GEN/SOC_CLK] -divide_by 1 [get_ports sdram_CLK]
create_generated_clock -name sdclk_pin -source [get_pins CLK_GEN/SOC_CLK] -divide_by 1 [get_ports sdram_CLK]

set_input_delay -clock sdclk_pin -max 5.000 [get_ports {sdram_DQ[*]}]
set_input_delay -clock sdclk_pin -min 1.000 [get_ports {sdram_DQ[*]}]

set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_A*]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_A*]
set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_B*]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_B*]
set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_D*]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_D*]
set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_CASn]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_CASn]
set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_CKE]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_CKE]
set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_WEn]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_WEn]
set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_CSn*]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_CSn*]
set_output_delay -clock sdclk_pin -max 1.500 [get_ports sdram_RASn]
set_output_delay -clock sdclk_pin -min -0.800 [get_ports sdram_RASn]
 