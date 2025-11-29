package RAM_cov_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;
import shared_pkg::*;

    class RAM_cov_collector extends uvm_component;
        `uvm_component_utils(RAM_cov_collector)

        uvm_analysis_export #(RAM_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) cov_fifo;
        RAM_seq_item seq_item;

        covergroup cg;
                           
            din_cp: coverpoint seq_item.din[9:8]{ 
                bins possible_values[] = {[0:3]}; 
                bins wr_add_data = (RAM_WRITE_ADD => RAM_WRITE_DATA);
                bins rd_add_data = (RAM_READ_ADD => RAM_READ_DATA);
                bins wr_add_data_rd_add_data = (RAM_WRITE_ADD => RAM_WRITE_DATA 
                                                => RAM_READ_ADD => RAM_READ_DATA);
            }
            rx_valid_cp: coverpoint seq_item.rx_valid{
                bins rx_high = {1};
                bins rx_low  = {0};
            }

            tx_valid_cp: coverpoint seq_item.tx_valid{
                bins tx_high = {1};
                bins tx_low  = {0};
            }

            din_rx_cross: cross din_cp, rx_valid_cp{ 
                bins din_rx_high = binsof(din_cp) && binsof(rx_valid_cp.rx_high);
                option.cross_auto_bin_max = 0;
            }

            din_tx_cross: cross din_cp, tx_valid_cp{ 
                bins din_tx_high = binsof(din_cp.possible_values) 
                                   intersect{RAM_READ_DATA} && binsof(tx_valid_cp.tx_high);
                option.cross_auto_bin_max = 0;
            }

        endgroup

        function new(string name = "RAM_cov_collector", uvm_component parent = null);
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
