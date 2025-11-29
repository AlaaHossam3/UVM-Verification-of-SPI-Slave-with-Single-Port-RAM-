package RAM_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;
import shared_pkg::*;
    
    class reset_sequence extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(reset_sequence)
        RAM_seq_item seq_item;

        function new(string name = "reset_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = RAM_seq_item::type_id::create("seq_item");
            start_item(seq_item);

            seq_item.rst_n = 0;
            seq_item.din = 0;
            seq_item.rx_valid = 0;
            
            finish_item(seq_item);
            
        endtask
    endclass


    class write_only_sequence extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(write_only_sequence)
        RAM_seq_item seq_item;

        function new(string name = "write_only_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = RAM_seq_item::type_id::create("seq_item");

            repeat (100) begin
                start_item(seq_item);

                // This is the inline constraint!
                if (!seq_item.randomize() with {seq_type == RAM_WRITE_ONLY;})
                    `uvm_error("RND_FAIL", "...")
                
                finish_item(seq_item);
            end
        endtask
    endclass
    
    class read_only_sequence extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(read_only_sequence)
        RAM_seq_item seq_item;

        function new(string name = "read_only_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = RAM_seq_item::type_id::create("seq_item");

            repeat (100) begin
                start_item(seq_item);

                // This is the inline constraint!
                if (!seq_item.randomize() with {seq_type == RAM_READ_ONLY;})
                    `uvm_error("RND_FAIL", "...")
                
                finish_item(seq_item);
            end
        endtask
    endclass
    
    class random_rw_sequence extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(random_rw_sequence)
        RAM_seq_item seq_item;

        function new(string name = "random_rw_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = RAM_seq_item::type_id::create("seq_item");

            repeat (100) begin
                start_item(seq_item);

                // This is the inline constraint!
                if (!seq_item.randomize() with {seq_type == RAM_RANDOM_RW;})
                    `uvm_error("RND_FAIL", "...")
                
                finish_item(seq_item);
            end
        endtask
    endclass

endpackage