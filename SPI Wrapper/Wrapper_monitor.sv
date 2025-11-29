package Wrapper_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_seq_item_pkg::*;
    
    class Wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(Wrapper_monitor)

        virtual Wrapper_if wrapper_vif;
        Wrapper_seq_item seq_item_main;
        Wrapper_seq_item seq_item_next;
        uvm_analysis_port #(Wrapper_seq_item) mon_ap;

        function new(string name = "Wrapper_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item_main = Wrapper_seq_item::type_id::create("seq_item_main");
                seq_item_next = Wrapper_seq_item::type_id::create("seq_item_next");
                @(negedge wrapper_vif.clk);
        
                seq_item_main.rst_n = wrapper_vif.rst_n;
                seq_item_main.MOSI  = wrapper_vif.MOSI;
                seq_item_main.SS_n  = wrapper_vif.SS_n;
                seq_item_main.MISO  = wrapper_vif.MISO;
                mon_ap.write(seq_item_main);
                `uvm_info("run_phase", seq_item_main.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage
