vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover 
coverage save top.ucdb -onexit -du work.WRAPPER
add wave -position insertpoint  \
sim:/top/wrapper_if/clk \
sim:/top/wrapper_if/MISO \
sim:/top/wrapper_if/MISO_ref \
sim:/top/wrapper_if/MOSI \
sim:/top/wrapper_if/rst_n \
sim:/top/wrapper_if/SS_n

add wave -position insertpoint  \
sim:/top/spi_if/clk \
sim:/top/spi_if/MISO \
sim:/top/spi_if/MISO_ref \
sim:/top/spi_if/MOSI \
sim:/top/spi_if/rst_n \
sim:/top/spi_if/rx_data \
sim:/top/spi_if/rx_data_ref \
sim:/top/spi_if/rx_valid \
sim:/top/spi_if/rx_valid_ref \
sim:/top/spi_if/SS_n \
sim:/top/spi_if/tx_data \
sim:/top/spi_if/tx_valid
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
sim:/shared_pkg::state \
sim:/shared_pkg::ram_counter \
sim:/shared_pkg::spi_counter

add wave /top/dut/RAM_instance/ram_sva_inst/reset_assert 
add wave /top/dut/RAM_instance/ram_sva_inst/tx_valid_deasserted_assert 
add wave /top/dut/RAM_instance/ram_sva_inst/read_data_tx_valid_assert 
add wave /top/dut/RAM_instance/ram_sva_inst/wr_add_data_assert 
add wave /top/dut/RAM_instance/ram_sva_inst/rd_add_data_assert 
add wave /top/dut/SLAVE_instance/rst_assert 
add wave /top/dut/SLAVE_instance/wr_op_assert 
add wave /top/dut/SLAVE_instance/rd_add_assert 
add wave /top/dut/SLAVE_instance/rd_data_assert 
add wave /top/dut/SLAVE_instance/idle_to_chk_cmd_assert 
add wave /top/dut/SLAVE_instance/chk_cmd_to_rd_wr_assert 
add wave /top/dut/SLAVE_instance/wr_to_idle_assert 
add wave /top/dut/SLAVE_instance/rd_add_to_idle_assert 
add wave /top/dut/SLAVE_instance/rd_data_to_idle_assert

add wave /top/dut/rst_assert 
add wave /top/dut/stable_miso_assert
run -all