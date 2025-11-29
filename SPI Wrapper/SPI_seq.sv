package SPI_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;
import shared_pkg::*;
    
    class reset_sequence extends uvm_sequence #(SPI_seq_item);
        `uvm_object_utils(reset_sequence)
        SPI_seq_item seq_item;

        function new(string name = "reset_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = SPI_seq_item::type_id::create("seq_item");
            start_item(seq_item);

            seq_item.rst_n = 0;
            seq_item.SS_n = 0;
            seq_item.tx_data = 0;
            seq_item.tx_valid = 0;
            
            finish_item(seq_item);
            
        endtask
    endclass


    class main_sequence extends uvm_sequence #(SPI_seq_item);
        `uvm_object_utils(main_sequence)
        SPI_seq_item seq_item;

        function new(string name = "main_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = SPI_seq_item::type_id::create("seq_item");
            repeat(100000) begin 
                start_item(seq_item);   
                    assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask

    endclass

endpackage