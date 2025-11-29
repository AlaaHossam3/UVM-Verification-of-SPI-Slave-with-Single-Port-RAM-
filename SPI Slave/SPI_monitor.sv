package SPI_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;
    
    class SPI_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_monitor)

        virtual SPI_if spi_vif;
        SPI_seq_item seq_item_main;
        SPI_seq_item seq_item_next;
        uvm_analysis_port #(SPI_seq_item) mon_ap;

        function new(string name = "SPI_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item_main = SPI_seq_item::type_id::create("seq_item_main");
                seq_item_next = SPI_seq_item::type_id::create("seq_item_next");
                @(negedge spi_vif.clk);
        
                seq_item_main.rst_n = spi_vif.rst_n;
                seq_item_main.MOSI = spi_vif.MOSI;
                seq_item_main.tx_valid = spi_vif.tx_valid;
                seq_item_main.SS_n = spi_vif.SS_n;
                seq_item_main.tx_data = spi_vif.tx_data;
                seq_item_main.MISO = spi_vif.MISO;
                seq_item_main.rx_valid = spi_vif.rx_valid;
                seq_item_main.rx_data  = spi_vif.rx_data;
                
                mon_ap.write(seq_item_main);
                `uvm_info("run_phase", seq_item_main.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage