package Wrapper_cov_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_seq_item_pkg::*;
import shared_pkg::*;

    class Wrapper_cov_collector extends uvm_component;
        `uvm_component_utils(Wrapper_cov_collector)

        uvm_analysis_export #(Wrapper_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(Wrapper_seq_item) cov_fifo;
        Wrapper_seq_item seq_item;

        function new(string name = "Wrapper_cov_collector", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cob_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item);
            end
        endtask
    endclass
endpackage