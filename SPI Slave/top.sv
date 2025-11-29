import uvm_pkg::*;
import SPI_test_pkg::*;
`include "uvm_macros.svh"

module top();
    bit clk;

    initial begin
        clk = 0;
        forever
            #2 clk = ~clk;
    end

    SPI_if spi_if(clk); 
    SLAVE DUT(spi_if.DUT);
    SPI ref_model(spi_if.REF_MODEL);

    initial begin
        uvm_config_db #(virtual SPI_if)::set(null, "uvm_test_top", "SPI_IF", spi_if);
        run_test("SPI_test");
    end
endmodule