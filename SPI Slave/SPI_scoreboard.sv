package SPI_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;
import SPI_config_pkg::*;
import shared_pkg::*;

    class SPI_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_scoreboard)

        uvm_analysis_export #(SPI_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(SPI_seq_item) sb_fifo;
        virtual SPI_if spi_vif;
        SPI_config cfg;
        SPI_seq_item seq_item;

        function new(string name = "SPI_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);

            if(!uvm_config_db #(SPI_config)::get(this, "", "SPI_CFG", cfg))
                `uvm_fatal("Build_Phase", "Scoreboard-Unable to get configuration");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
            spi_vif = cfg.spi_vif;
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item);
                if (seq_item.MISO !== spi_vif.MISO_ref) begin
                    error_count_out++;
                    $display("error in data out at %0d", $time);           
                    `uvm_error("run_phase", $sformatf("comparison failed transaction received by the DUT:%s while the reference out:0b%0b",
                    seq_item.convert2string(), spi_vif.MISO_ref));
                end
                else begin
                    `uvm_info("run_phase", $sformatf("correct spi_SPI out: %s", seq_item.convert2string()), UVM_HIGH);
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