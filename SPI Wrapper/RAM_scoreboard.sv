package RAM_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;
import RAM_config_pkg::*;
import shared_pkg::*;

    class RAM_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(RAM_scoreboard)

        uvm_analysis_export #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
        virtual RAM_if ram_vif;
        RAM_config cfg;
        RAM_seq_item seq_item;

        function new(string name = "RAM_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);

            if(!uvm_config_db #(RAM_config)::get(this, "", "RAM_CFG", cfg))
                `uvm_fatal("Build_Phase", "Scoreboard-Unable to get configuration");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
            ram_vif = cfg.ram_vif;
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item);
                if (seq_item.dout !== ram_vif.dout_ref) begin
                    error_count_out++;
                    $display("RAM - error in data out at %0d", $time);
                    `uvm_error("run_phase", $sformatf("comparison failed transaction received by the DUT:%s while the reference out:0b%0b",
                    seq_item.convert2string(), ram_vif.dout_ref));
                end
                else begin
                    `uvm_info("run_phase", $sformatf("correct RAM out: %s", seq_item.convert2string()), UVM_HIGH);
                    correct_count_out++;
                end
                
                if (seq_item.tx_valid !== ram_vif.tx_valid_ref) begin
                    error_count_out++;
                    $display("RAM - error in tx_valid at %0d", $time);
                    `uvm_error("run_phase", $sformatf("comparison failed transaction received by the DUT:%s while the reference out:0b%0b",
                    seq_item.convert2string(), ram_vif.dout_ref));
                end
                else begin
                    `uvm_info("run_phase", $sformatf("correct RAM out: %s", seq_item.convert2string()), UVM_HIGH);
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