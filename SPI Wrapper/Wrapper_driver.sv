package Wrapper_driver_pkg;
import uvm_pkg::*;
import Wrapper_config_pkg::*;
import Wrapper_seq_item_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

    class Wrapper_driver extends uvm_driver #(Wrapper_seq_item);
        `uvm_component_utils(Wrapper_driver)

        virtual Wrapper_if wrapper_vif;
        Wrapper_seq_item seq_item;

        function new(string name = "Wrapper_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = Wrapper_seq_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);

                wrapper_vif.rst_n       = seq_item.rst_n;
                wrapper_vif.SS_n        = seq_item.SS_n;

                if(spi_counter > 1)
                    wrapper_vif.MOSI    = wrapper_MOSI_bits_old[12 - spi_counter];

                @(negedge wrapper_vif.clk);
                seq_item_port.item_done();
                `uvm_info("Run_phase", seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage
