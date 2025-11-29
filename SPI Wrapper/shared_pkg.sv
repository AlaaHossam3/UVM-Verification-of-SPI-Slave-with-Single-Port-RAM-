package shared_pkg;

    // SPI_Slave 
    int correct_count_out = 0;
    int error_count_out = 0;
    int spi_counter = 0;
    int cycles;
    bit [10:0] MOSI_bits_old;
    localparam SPI_WRITE_ADD  = 3'b000;
    localparam SPI_WRITE_DATA = 3'b001;
    localparam SPI_READ_ADD   = 3'b110;
    localparam SPI_READ_DATA  = 3'b111;
    bit [2:0] state;

    // RAM
    int ram_counter = 0;
    localparam RAM_WRITE_ADD  = 2'b00;
    localparam RAM_WRITE_DATA = 2'b01;
    localparam RAM_READ_ADD   = 2'b10;
    localparam RAM_READ_DATA  = 2'b11;
    
    localparam RAM_WRITE_ONLY = 2'b00;
    localparam RAM_READ_ONLY  = 2'b01;
    localparam RAM_RANDOM_RW  = 2'b10;

    //Wrapper
    bit [10:0] wrapper_MOSI_bits_old;
    
endpackage
