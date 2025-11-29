package shared_pkg;
    int correct_count_out = 0;
    int error_count_out = 0;
    int spi_counter = 0;
    int cycles;
    bit [10:0] MOSI_bits_fixed;
    localparam SPI_WRITE_ADD    = 3'b000;
    localparam SPI_WRITE_DATA   = 3'b001;
    localparam SPI_READ_ADD     = 3'b110;
    localparam SPI_READ_DATA    = 3'b111;
    bit [2:0] state;
endpackage