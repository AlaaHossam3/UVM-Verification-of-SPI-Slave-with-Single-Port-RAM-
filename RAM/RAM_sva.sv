import shared_pkg::*;
module RAM_sva(RAM_if ram_if);
    
property reset_asserted;
    @(posedge ram_if.clk) (!ram_if.rst_n) |-> ##1 (ram_if.dout == 0 && ram_if.tx_valid == 0);
endproperty

property tx_valid_deasserted;
    @(posedge ram_if.clk) disable iff (!ram_if.rst_n) 
    (ram_if.din[9:8] != RAM_READ_DATA) |-> ##1 (ram_if.tx_valid == 0);
endproperty

property read_data_tx_valid;
    @(posedge ram_if.clk) disable iff (!ram_if.rst_n) 
    (ram_if.din[9:8] == RAM_READ_DATA && ram_if.rx_valid) 
    |-> ##1 (ram_if.tx_valid == 1) ##1 (ram_if.tx_valid == 0);
endproperty

property wr_add_data;
    @(posedge ram_if.clk) disable iff (!ram_if.rst_n) 
    (ram_if.din[9:8] == RAM_WRITE_ADD && ram_if.rx_valid) 
    |-> ##1 (ram_if.din[9:8] == RAM_WRITE_DATA || ram_if.din[9:8] == RAM_WRITE_ADD);
endproperty

property rd_add_data;
    @(posedge ram_if.clk) disable iff (!ram_if.rst_n) 
    (ram_if.din[9:8] == RAM_READ_ADD && ram_if.rx_valid) 
    |-> ##1 (ram_if.din[9:8] == RAM_READ_DATA || ram_if.din[9:8] == RAM_READ_ADD);
endproperty

reset_assert: assert property(reset_asserted);
reset_cover:  cover  property(reset_asserted);

tx_valid_deasserted_assert: assert property(tx_valid_deasserted);
tx_valid_deasserted_cover:  cover  property(tx_valid_deasserted);

read_data_tx_valid_assert: assert property(read_data_tx_valid);
read_data_tx_valid_cover:  cover  property(read_data_tx_valid);

wr_add_data_assert: assert property(wr_add_data);
wr_add_data_cover:  cover  property(wr_add_data);

rd_add_data_assert: assert property(rd_add_data);
rd_add_data_cover:  cover  property(rd_add_data);
endmodule
