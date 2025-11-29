package Wrapper_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import shared_pkg::*;

    class Wrapper_seq_item extends uvm_sequence_item;
        `uvm_object_utils(Wrapper_seq_item)

        rand bit [10:0] MOSI_bits;
        rand bit rst_n, SS_n;

        logic MISO, MOSI, MISO_ref;

        bit [1:0] prev_op;
        rand bit [1:0] seq_type;
        bit [1:0] prev_seq_type;

        function new(string name = "Wrapper_seq_item");
            super.new(name);
        endfunction
         
        function void pre_randomize();
            if (SS_n || !rst_n) begin
                MOSI_bits.rand_mode(1);
                spi_counter = 0; 
            end
            else begin
                MOSI_bits.rand_mode(0);
            end

            if(ram_counter == 0 && MOSI_bits_old[10:8] == SPI_READ_ADD) begin
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

        constraint rst_c { rst_n dist {0:= 2, 1:= 98}; }
        
        constraint MOSI_c { 
            if (MOSI_bits.rand_mode()) {
                MOSI_bits[10:8] inside {SPI_WRITE_ADD, SPI_WRITE_DATA, SPI_READ_ADD, SPI_READ_DATA};
            }
        }
        
        constraint SS_c {
            if (wrapper_MOSI_bits_old[10:8] == SPI_READ_DATA && state == 3'b100) {
                if (spi_counter < 22) SS_n == 0;
                else SS_n == 1;
            }
            else {
                if (spi_counter < 12) SS_n == 0;
                else SS_n == 1;
            }
        }

        constraint all_sequences_c {
            if (MOSI_bits.rand_mode()) {
                (seq_type == RAM_READ_ONLY) -> {
                    (prev_op == RAM_READ_ADD)  -> MOSI_bits[10:8] == SPI_READ_DATA;
                    (prev_op == RAM_READ_DATA) -> MOSI_bits[10:8] == SPI_READ_ADD;
                }
                (seq_type == RAM_WRITE_ONLY) -> {
                    (prev_op == RAM_WRITE_ADD)  -> MOSI_bits[10:8] inside {SPI_WRITE_ADD, SPI_WRITE_DATA};
                    (prev_op == RAM_WRITE_DATA) -> MOSI_bits[10:8] inside {SPI_WRITE_ADD, SPI_WRITE_DATA};
                }
                (seq_type == RAM_RANDOM_RW) -> {
                    (prev_op == RAM_WRITE_ADD)  -> MOSI_bits[10:8] inside {SPI_WRITE_ADD, SPI_WRITE_DATA};
                    (prev_op == RAM_WRITE_DATA) -> MOSI_bits[10:8] dist {
                                                        SPI_WRITE_ADD:= 40,
                                                        SPI_READ_ADD:= 60
                                                    };
                    (prev_op == RAM_READ_ADD)   -> MOSI_bits[10:8] == SPI_READ_DATA;
                    (prev_op == RAM_READ_DATA)  -> MOSI_bits[10:8] dist {
                                                        SPI_WRITE_ADD:= 60,
                                                        SPI_READ_ADD:= 40
                                                    };
                }
            }
        }

        function void post_randomize();  
            if (SS_n || !rst_n) begin
                spi_counter = 0;
            end
            else begin
                spi_counter++;
            end

            wrapper_MOSI_bits_old = MOSI_bits;

            if (wrapper_MOSI_bits_old[10:8] == SPI_READ_DATA && state == 3'b100) 
                cycles = 23;
            else
                cycles = 13;

            prev_op = MOSI_bits[9:8];
        endfunction

        function string convert2string();
            return $sformatf("rst_n=0b%0b, SS_n=0b%0b, MISO=0b%0b",rst_n, SS_n, MISO);
        endfunction

        function string convert2string_stimulus();
            return $sformatf( "rst_n=0b%0b, SS_n=0b%0b", rst_n, SS_n);
        endfunction
    endclass
endpackage
