package SPI_sqr_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;

    class SPI_sqr extends uvm_sequencer #(SPI_seq_item);
        `uvm_component_utils(SPI_sqr)

        function new(string name = "SPI_sqr", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass    
endpackage