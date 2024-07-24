set_max_delay -through [get_nets -hierarchical -filter CDC_ASYNC==1] 10.000
set_false_path -hold -through [get_nets -hierarchical -filter CDC_ASYNC==1]

set_false_path -to [get_cells -hier -regexp {syncstages_ff_reg\\[0\\]}]
set_false_path -to [get_cells -hier -regexp {syncstages_ff_reg\\[0\\]\\[\\\d+\\]}]

set_max_delay -from [get_cells -hier -regexp src_gray_ff_reg.*] -to [get_cells -hier -regexp {dest_graysync_ff_reg\\[0\\].*}] 10.00

set_max_delay -through [get_pins -hierarchical {async_rptr_o async_wptr_o async_data_o}] 10.0
set_false_path -hold -through [get_pins -hierarchical {async_rptr_o async_wptr_o async_data_o}]

current_instance soc/ethernet_mii/eth/XEMAC_I/EMAC_I/RX/INST_RX_INTRFCE/I_RX_FIFO/xpm_fifo_base_inst
set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -through [get_pins -of_objects [get_cells -hier stolen_fifo_mem_reg*] -filter {DIRECTION==OUT}]
set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -to [get_cells -hier *rd_tmp_reg_reg*]

set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -through [get_pins -of_objects [get_cells -hier stolen_fifo_mem_reg*] -filter {DIRECTION==OUT}]
set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -to [get_cells -hier *rd_tmp_reg_reg*]
