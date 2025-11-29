package SPI_driver_pkg;
import uvm_pkg::*;
import SPI_config_pkg::*;
import SPI_seq_item_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

    class SPI_driver extends uvm_driver #(SPI_seq_item);
        `uvm_component_utils(SPI_driver)

        virtual SPI_if spi_vif;
        SPI_seq_item seq_item;

        function new(string name = "SPI_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = SPI_seq_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);

                spi_vif.rst_n       = seq_item.rst_n;
                spi_vif.tx_valid    = seq_item.tx_valid;
                spi_vif.SS_n        = seq_item.SS_n;
                spi_vif.tx_data     = seq_item.tx_data;

                if(spi_counter > 1)
                    spi_vif.MOSI = MOSI_bits_fixed[12 - spi_counter];

                @(negedge spi_vif.clk);
                seq_item_port.item_done();
                `uvm_info("Run_phase", seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage