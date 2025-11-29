package RAM_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import shared_pkg::*;
    
    class RAM_seq_item extends uvm_sequence_item;
        `uvm_object_utils(RAM_seq_item)
        
        rand bit [9:0] din;
        rand bit rst_n, rx_valid;
        bit tx_valid;
        bit [7:0] dout;

        bit [1:0] prev_op;
        rand bit [1:0] seq_type;
        bit [1:0] prev_seq_type;

        function new(string name = "RAM_seq_item");
            super.new(name);
        endfunction
        
        function void pre_randomize();
            if(ram_counter == 0) begin
                if(seq_type == RAM_READ_ONLY) begin
                    prev_op = RAM_READ_DATA;
                    prev_seq_type = seq_type;
                end
                else begin
                    prev_op = RAM_WRITE_DATA;
                    prev_seq_type = seq_type;
                end
                ram_counter++;
            end
        endfunction

        // --- CONSTRAINTS ---        
        constraint rst_c { rst_n dist {0:= 2, 1:= 98}; }
    
        constraint rx_valid_c { rx_valid dist{0:=2, 1:=98}; }
        
        constraint all_sequences_c {
            // If seq_type is READ_ONLY, then apply these rules
            (seq_type == RAM_READ_ONLY) -> {
                (prev_op == RAM_READ_ADD)  -> din[9:8] == RAM_READ_DATA;
                (prev_op == RAM_READ_DATA) -> din[9:8] == RAM_READ_ADD;
            }

            // If seq_type is WRITE_ONLY, then apply these rules
            (seq_type == RAM_WRITE_ONLY) -> {
                (prev_op == RAM_WRITE_ADD)  -> din[9:8] inside {RAM_WRITE_ADD, RAM_WRITE_DATA};
                (prev_op == RAM_WRITE_DATA) -> din[9:8] inside {RAM_WRITE_ADD, RAM_WRITE_DATA};
            }

            // If seq_type is RANDOM_RW, then apply these rules
            (seq_type == RAM_RANDOM_RW) -> {
                (prev_op == RAM_WRITE_ADD)  -> din[9:8] inside {RAM_WRITE_ADD, RAM_WRITE_DATA};
                (prev_op == RAM_WRITE_DATA) -> din[9:8] dist {
                                                    RAM_WRITE_ADD:= 40,
                                                    RAM_READ_ADD:= 60
                                                };
                (prev_op == RAM_READ_ADD)   -> din[9:8] == RAM_READ_DATA;
                (prev_op == RAM_READ_DATA)  -> din[9:8] dist {
                                                    RAM_WRITE_ADD:= 60,
                                                    RAM_READ_ADD:= 40
                                                };
            }
        }

        // --- POST_RANDOMIZE ---
        function void post_randomize();
            prev_op = din[9:8];
        endfunction

        // --- Utility Functions ---
        function string convert2string();
            return $sformatf(
                "rst_n=0b%0b, rx_valid=0b%0b, din=0x%02h, dout=0b%0b",
                 rst_n, rx_valid, din, dout
                 );
        endfunction

        function string convert2string_stimulus();
            return $sformatf(
                "rst_n=0b%0b, rx_valid=0b%0b, din=0b%0b, dout=0x%02h",
                rst_n, rx_valid, din, dout
            );
        endfunction

    endclass
endpackage
