create_generated_clock -name SD_CLK -source [get_pins CLK_GEN/SOC_CLK] -divide_by 4 [get_ports SD_CLK]

set_input_delay -clock SD_CLK -max 3.000 [get_ports SD_*]
set_input_delay -clock SD_CLK -min 1.000 [get_ports SD_*]
set_output_delay -clock SD_CLK -max 3.000 [get_ports {SD_DAT* SD_CMD SD_nCD}]
set_output_delay -clock SD_CLK -min -1.000 [get_ports {SD_DAT* SD_CMD SD_nCD}]

# SDIO Output multicycle path
set_multicycle_path -setup -start -from SOC_CLK_CLK_GEN -to SD_CLK 4
set_multicycle_path -hold -start -from SOC_CLK_CLK_GEN -to SD_CLK 3
# SDIO Input  multicycle path, only sampling when SDIO_CLK is high.
set_multicycle_path -setup -end -from SD_CLK -to SOC_CLK_CLK_GEN 2
set_multicycle_path -hold -end -from SD_CLK -to SOC_CLK_CLK_GEN 1