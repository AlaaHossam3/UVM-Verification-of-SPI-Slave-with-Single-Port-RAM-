import uvm_pkg::*;
import Wrapper_test_pkg::*;
`include "uvm_macros.svh"

module top();
    bit clk;

    initial begin
        clk = 0;
        forever
            #2 clk = ~clk;
    end

    Wrapper_if wrapper_if(clk);
    SPI_if spi_if(clk);
    RAM_if ram_if(clk);

    assign spi_if.rst_n         = dut.rst_n;
    assign spi_if.SS_n          = dut.SS_n;
    assign spi_if.MOSI          = dut.MOSI;
    assign spi_if.rx_valid      = dut.rx_valid;
    assign spi_if.rx_valid_ref  = ref_model.rx_valid_ref;
    assign spi_if.rx_data       = dut.rx_data;
    assign spi_if.rx_data_ref   = ref_model.rx_data_ref;
    assign spi_if.tx_valid      = dut.tx_valid;
    assign spi_if.tx_data       = dut.tx_data;
    assign spi_if.MISO          = dut.MISO;
    assign spi_if.MISO_ref      = ref_model.MISO_ref;

    assign ram_if.rst_n         = dut.rst_n;
    assign ram_if.rx_valid      = dut.rx_valid;
    assign ram_if.din           = dut.rx_data;
    assign ram_if.tx_valid      = dut.tx_valid;
    assign ram_if.tx_valid_ref  = ref_model.tx_valid_ref;
    assign ram_if.dout          = dut.tx_data;
    assign ram_if.dout_ref      = ref_model.tx_data_ref;

    WRAPPER dut (wrapper_if.DUT);
    Wrap ref_model(wrapper_if.REF_MODEL);
    bind dut.RAM_instance RAM_sva ram_sva_inst(ram_if);

    initial begin
        uvm_config_db #(virtual Wrapper_if)::set(null, "uvm_test_top", "Wrapper_IF", wrapper_if);
        uvm_config_db #(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", ram_if);
        uvm_config_db #(virtual SPI_if)::set(null, "uvm_test_top", "SPI_IF", spi_if);
        run_test("Wrapper_test");
    end
endmodule
