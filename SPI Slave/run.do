vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover 
coverage save top.ucdb -onexit -du work.SLAVE
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
add wave /top/DUT/rst_assert 
add wave /top/DUT/wr_op_assert 
add wave /top/DUT/rd_add_assert 
add wave /top/DUT/rd_data_assert 
add wave /top/DUT/idle_to_chk_cmd_assert 
add wave /top/DUT/chk_cmd_to_rd_wr_assert 
add wave /top/DUT/wr_to_idle_assert 
add wave /top/DUT/rd_add_to_idle_assert 
add wave /top/DUT/rd_data_to_idle_assert
add wave -position insertpoint  \
sim:/shared_pkg::spi_counter \
sim:/shared_pkg::MOSI_bits_fixed
run -all
