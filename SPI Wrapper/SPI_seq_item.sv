package SPI_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import shared_pkg::*;

    class SPI_seq_item extends uvm_sequence_item;
        `uvm_object_utils(SPI_seq_item)

        rand bit [10:0] MOSI_bits;
        rand bit rst_n, SS_n, tx_valid;
        rand bit [7:0] tx_data;

        logic rx_valid, MISO, MOSI;
        logic [9:0] rx_data;

        function new(string name = "SPI_seq_item");
            super.new(name);
        endfunction


        function void pre_randomize();

            if (SS_n || !rst_n) begin
                MOSI_bits.rand_mode(1);
            end

            else begin
                MOSI_bits.rand_mode(0);
            end

            if (MOSI_bits_old[10:8] == 3'b111 && state == 3'b100) begin
                tx_data.rand_mode(0); 
            end
            else begin
                tx_data.rand_mode(1);
            end
        endfunction

        constraint rst_c { rst_n dist {0:= 2, 1:= 98}; }
        
        constraint MOSI_c { 
            
            if (MOSI_bits.rand_mode()) {
                MOSI_bits[10:8] inside {SPI_WRITE_ADD, SPI_WRITE_DATA, SPI_READ_ADD, SPI_READ_DATA};
            }
        }
        
        constraint SS_c {
            if (MOSI_bits_old[10:8] == 3'b111 && state == 3'b100) {
                if (spi_counter < 22) SS_n == 0;
                else SS_n == 1;
            }
            else {
                if (spi_counter < 12) SS_n == 0;
                else SS_n == 1;
            }
        }
        
        constraint tx_valid_c { 
            if (MOSI_bits_old[10:8] == 3'b111) {
                tx_valid == 1;
            }
        }

        function void post_randomize();

            if (SS_n || !rst_n) begin
                spi_counter = 0;
            end
            else begin
                spi_counter++;
            end

            MOSI_bits_old = MOSI_bits;

            if (MOSI_bits_old[10:8] == 3'b111 && state == 3'b100) begin
                cycles = 23;
            end
            else begin
                cycles = 13;
            end
        endfunction

        function string convert2string();
            return $sformatf(
                "rst_n=0b%0b, SS_n=0b%0b, tx_valid=0b%0b, tx_data=0x%02h, MISO=0b%0b, rx_valid=0b%0b, rx_data=0x%03h",
                 rst_n, SS_n, tx_valid, tx_data, MISO, rx_valid, rx_data
            );
        endfunction

        function string convert2string_stimulus();
            return $sformatf(
                "rst_n=0b%0b, SS_n=0b%0b, tx_valid=0b%0b, tx_data=0x%02h",
                rst_n, SS_n, tx_valid, tx_data
            );
        endfunction

    endclass
endpackage
