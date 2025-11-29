vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover 
coverage save top.ucdb -onexit -du work.RAM
add wave -position insertpoint  \
sim:/top/ram_if/clk \
sim:/top/ram_if/din \
sim:/top/ram_if/dout \
sim:/top/ram_if/dout_ref \
sim:/top/ram_if/rst_n \
sim:/top/ram_if/rx_valid \
sim:/top/ram_if/tx_valid \
sim:/top/ram_if/tx_valid_ref
add wave -position insertpoint  \
sim:/top/dut/MEM
add wave /top/dut/ram_sva_inst/reset_assert 
add wave /top/dut/ram_sva_inst/tx_valid_deasserted_assert 
add wave /top/dut/ram_sva_inst/read_data_tx_valid_assert 
add wave /top/dut/ram_sva_inst/wr_add_data_assert 
add wave /top/dut/ram_sva_inst/rd_add_data_assert
run -all