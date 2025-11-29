package Wrapper_sqr_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_seq_item_pkg::*;

    class Wrapper_sqr extends uvm_sequencer #(Wrapper_seq_item);
        `uvm_component_utils(Wrapper_sqr)

        function new(string name = "Wrapper_sqr", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass    
endpackage