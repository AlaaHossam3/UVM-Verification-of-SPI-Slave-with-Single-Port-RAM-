package RAM_driver_pkg;
import uvm_pkg::*;
import RAM_config_pkg::*;
import RAM_seq_item_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

    class RAM_driver extends uvm_driver #(RAM_seq_item);
        `uvm_component_utils(RAM_driver)

        virtual RAM_if ram_vif;
        RAM_seq_item seq_item;

        function new(string name = "RAM_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = RAM_seq_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);

                ram_vif.rst_n    = seq_item.rst_n;
                ram_vif.rx_valid = seq_item.rx_valid;
                ram_vif.din      = seq_item.din;
                
                @(negedge ram_vif.clk);
                seq_item_port.item_done();
                `uvm_info("Run_phase", seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage
