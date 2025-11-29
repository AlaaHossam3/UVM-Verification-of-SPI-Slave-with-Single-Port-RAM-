package Wrapper_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_seq_item_pkg::*;
import shared_pkg::*;
    
    class wrapper_reset_sequence extends uvm_sequence #(Wrapper_seq_item);
        `uvm_object_utils(wrapper_reset_sequence)
        Wrapper_seq_item seq_item;

        function new(string name = "wrapper_reset_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = Wrapper_seq_item::type_id::create("seq_item");
            start_item(seq_item);

            seq_item.rst_n = 0;
            seq_item.SS_n = 0;
            seq_item.MOSI = 0;
            
            finish_item(seq_item);
            
        endtask
    endclass


    class wrapper_write_only_sequence extends uvm_sequence #(Wrapper_seq_item);
        `uvm_object_utils(wrapper_write_only_sequence)
        Wrapper_seq_item seq_item;

        function new(string name = "wrapper_write_only_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = Wrapper_seq_item::type_id::create("seq_item");
            
            repeat (1000) begin

                start_item(seq_item);
                    if (!seq_item.randomize() with {seq_type == RAM_WRITE_ONLY;})
                        `uvm_error("RND_FAIL", "Failed to randomize.")
                finish_item(seq_item);
            end
        endtask
    endclass

    class wrapper_read_only_sequence extends uvm_sequence #(Wrapper_seq_item);
        `uvm_object_utils(wrapper_read_only_sequence)
        Wrapper_seq_item seq_item;

        function new(string name = "wrapper_read_only_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = Wrapper_seq_item::type_id::create("seq_item");
            
            repeat (1000) begin

                start_item(seq_item);
                    if (!seq_item.randomize() with {seq_type == RAM_READ_ONLY;})
                    `uvm_error("RND_FAIL", "Failed to randomize.")
                finish_item(seq_item);
            end
        endtask

    endclass
    
    class wrapper_random_rw_sequence extends uvm_sequence #(Wrapper_seq_item);
        `uvm_object_utils(wrapper_random_rw_sequence)
        Wrapper_seq_item seq_item;

        function new(string name = "wrapper_random_rw_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = Wrapper_seq_item::type_id::create("seq_item");
            
            repeat (50000) begin

                start_item(seq_item);
                    if (!seq_item.randomize() with {seq_type == RAM_RANDOM_RW;})
                    `uvm_error("RND_FAIL", "Failed to randomize.")
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage
