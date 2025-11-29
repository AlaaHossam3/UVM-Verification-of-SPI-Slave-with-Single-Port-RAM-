package RAM_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;
    
    class RAM_monitor extends uvm_monitor;
        `uvm_component_utils(RAM_monitor)

        virtual RAM_if ram_vif;
        RAM_seq_item seq_item_main;
        RAM_seq_item seq_item_next;
        uvm_analysis_port #(RAM_seq_item) mon_ap;

        function new(string name = "RAM_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item_main = RAM_seq_item::type_id::create("seq_item_main");
                seq_item_next = RAM_seq_item::type_id::create("seq_item_next");
                @(negedge ram_vif.clk);
        
                seq_item_main.rst_n = ram_vif.rst_n;
                seq_item_main.din = ram_vif.din;
                seq_item_main.rx_valid = ram_vif.rx_valid;
                seq_item_main.dout = ram_vif.dout;
                seq_item_main.tx_valid = ram_vif.tx_valid;
                mon_ap.write(seq_item_main);
                `uvm_info("run_phase", seq_item_main.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage
