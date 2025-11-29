package Wrapper_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_seq_item_pkg::*;
import Wrapper_config_pkg::*;
import shared_pkg::*;

    class Wrapper_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(Wrapper_scoreboard)

        uvm_analysis_export #(Wrapper_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(Wrapper_seq_item) sb_fifo;
        virtual Wrapper_if wrapper_vif;
        Wrapper_config cfg;
        Wrapper_seq_item seq_item;

        function new(string name = "Wrapper_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
            if(!uvm_config_db #(Wrapper_config)::get(this, "", "Wrapper_CFG", cfg))
                `uvm_fatal("Build_Phase", "Scoreboard-Unable to get configuration");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
            wrapper_vif = cfg.wrapper_vif;
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item);
                if (seq_item.MISO !== wrapper_vif.MISO_ref) begin
                        error_count_out++;
                        $display("Wrapper - error in data out at %0d", $time);           
                        `uvm_error("run_phase", $sformatf("comparison failed transaction received by the DUT:%s while the reference out:0b%0b",
                        seq_item.convert2string(), wrapper_vif.MISO_ref));
                    end
                    else begin
                        `uvm_info("run_phase", $sformatf("correct wrapper out: %s", seq_item.convert2string()), UVM_HIGH);
                        correct_count_out++;
                    end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("total successful transactions: %0d", correct_count_out), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("total failed transactions: %0d", error_count_out), UVM_MEDIUM);
        endfunction
    endclass
endpackage
