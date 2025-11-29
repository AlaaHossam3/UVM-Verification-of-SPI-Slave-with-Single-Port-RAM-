package SPI_cov_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;
import shared_pkg::*;

    class SPI_cov_collector extends uvm_component;
        `uvm_component_utils(SPI_cov_collector)

        uvm_analysis_export #(SPI_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(SPI_seq_item) cov_fifo;
        SPI_seq_item seq_item;

        covergroup cg;
                                
            RX_DATA_cp: coverpoint seq_item.rx_data[9:8]{ 
                bins valid_values[] = {[0:3]}; 
                bins trans_1 = (0 => 1);
                bins trans_2 = (2 => 3);
                bins trans_3 = (0 => 2);
                bins trans_4 = (2 => 0);
                ignore_bins invalid_trans_1[] = ([2:3] => 1);
                ignore_bins invalid_trans_2[] = ([0:1] => 3);
            }

            MOSI_TRANS_cp: coverpoint seq_item.MOSI {
                bins wr_add_trans   = (0 => 0 => 0); 
                bins wr_data_trans  = (0 => 0 => 1);
                bins rd_add_trans   = (1 => 1 => 0); 
                bins rd_data_trans  = (1 => 1 => 1); 
            }
            
            SS_op_cp: coverpoint seq_item.SS_n {
                bins normal_operation   = (1 => 0[*12] => 1);
                bins read_operation     = (1 => 0[*22] => 1);
            }

            SS_cp: coverpoint seq_item.SS_n {
                bins active   = {0};
                bins inactive = {1};
            }

            MOSI_cp: coverpoint seq_item.MOSI {
                bins write_cmd = {0};
                bins read_cmd  = {1};
            }

            ss_n_mosi: cross SS_cp, MOSI_cp { ignore_bins inactive_cross = binsof(SS_cp.inactive);}
        endgroup

        function new(string name = "SPI_cov_collector", uvm_component parent = null);
            super.new(name, parent);
            cg = new();
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
                cg.sample();
            end
        endtask
    endclass
endpackage