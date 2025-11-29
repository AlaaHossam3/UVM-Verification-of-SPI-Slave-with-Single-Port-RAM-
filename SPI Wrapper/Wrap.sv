module Wrap (Wrapper_if.REF_MODEL wrapper_if);

SPI_if spi_if(wrapper_if.clk);
RAM_if ram_if(wrapper_if.clk);

logic clk, rst_n, SS_n, MOSI, rx_valid_ref, tx_valid_ref, MISO_ref;
logic [7: 0] tx_data_ref;
logic [9: 0] rx_data_ref;

assign clk                  = wrapper_if.clk;
assign rst_n                = wrapper_if.rst_n;
assign SS_n                 = wrapper_if.SS_n;
assign MOSI                 = wrapper_if.MOSI;
assign wrapper_if.MISO_ref  = MISO_ref;

assign spi_if.rst_n     = rst_n;  
assign spi_if.SS_n      = SS_n;
assign spi_if.MOSI      = MOSI;
assign spi_if.tx_valid  = tx_valid_ref;
assign spi_if.tx_data   = tx_data_ref;
assign rx_valid_ref     = spi_if.rx_valid_ref;
assign rx_data_ref      = spi_if.rx_data_ref;
assign MISO_ref         = spi_if.MISO_ref;

assign ram_if.rst_n     = rst_n;  
assign ram_if.rx_valid  = rx_valid_ref;
assign ram_if.din       = rx_data_ref;
assign tx_valid_ref     = ram_if.tx_valid_ref;
assign tx_data_ref      = ram_if.dout_ref;

// Modules instantiation
RAM_ref_model ram_ref_model (ram_if.REF_MODEL);

SPI spi_init (spi_if.REF_MODEL);

endmodule