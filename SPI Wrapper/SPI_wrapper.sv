import shared_pkg::*;
module WRAPPER (Wrapper_if.DUT wrapper_if);

    SPI_if spi_if(wrapper_if.clk);
    RAM_if ram_if(wrapper_if.clk);

    logic rst_n, SS_n, MOSI, rx_valid, tx_valid, MISO;
    logic [7: 0] tx_data;
    logic [9: 0] rx_data;

    assign rst_n            = wrapper_if.rst_n;
    assign SS_n             = wrapper_if.SS_n;
    assign MOSI             = wrapper_if.MOSI;
    assign wrapper_if.MISO  = MISO;

    assign spi_if.rst_n     = rst_n;  
    assign spi_if.SS_n      = SS_n;
    assign spi_if.MOSI      = MOSI;
    assign spi_if.tx_valid  = tx_valid;
    assign spi_if.tx_data   = tx_data;
    assign rx_valid         = spi_if.rx_valid;
    assign rx_data          = spi_if.rx_data;
    assign MISO             = spi_if.MISO;

    assign ram_if.rst_n     = rst_n;  
    assign ram_if.rx_valid  = rx_valid;
    assign ram_if.din       = rx_data;
    assign tx_valid         = ram_if.tx_valid;
    assign tx_data          = ram_if.dout;
    

    RAM   RAM_instance (ram_if);
    SLAVE SLAVE_instance (spi_if);

    
    property rst_asserted;
        @(posedge wrapper_if.clk) !wrapper_if.rst_n |-> ##1(!wrapper_if.MISO);
    endproperty

    property stable_miso;
        @(posedge wrapper_if.clk)  disable iff (!spi_if.rst_n) (state !== 3'b100) |-> ##1 (wrapper_if.MISO == $past(wrapper_if.MISO));
    endproperty

    rst_assert: assert property(rst_asserted);
    rst_cover:  cover  property(rst_asserted);

    stable_miso_assert: assert property(stable_miso);
    stable_miso_cover:  cover  property(stable_miso);
endmodule