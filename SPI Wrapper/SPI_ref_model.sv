module SPI (SPI_if.REF_MODEL spi_if);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

reg [3:0] counter;
reg       received_address;
reg       MOSI_transmit;
reg [7:0] buffered_tx_data;

reg [2:0] cs, ns;

always @(posedge spi_if.clk) begin
    if (~spi_if.rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (spi_if.SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (spi_if.SS_n)
                ns = IDLE;
            else begin
                if (~spi_if.MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA; 
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (spi_if.SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (spi_if.SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (spi_if.SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge spi_if.clk) begin
    if (~spi_if.rst_n) begin 
        spi_if.rx_data_ref <= 0;
        spi_if.rx_valid_ref <= 0;
        received_address <= 0;
        spi_if.MISO_ref <= 0;

        MOSI_transmit <= 0;
        buffered_tx_data <= 0;
    end
    else begin
        spi_if.rx_valid_ref <= 0;

        case (cs)
            IDLE : begin
                MOSI_transmit <= 0;
                spi_if.MISO_ref <= 0;
            end
            CHK_CMD : begin
                counter <= 10;
            end
            WRITE : begin
                if (counter > 0) begin
                    spi_if.rx_data_ref[counter-1] <= spi_if.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    spi_if.rx_valid_ref <= 1;
                    received_address <= 0;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    spi_if.rx_data_ref[counter-1] <= spi_if.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    spi_if.rx_valid_ref <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (!MOSI_transmit) begin
                    if (counter > 0) begin
                        spi_if.rx_data_ref[counter-1] <= spi_if.MOSI;
                        counter <= counter - 1;
                    end 
                    else begin
                        spi_if.rx_valid_ref <= 1;
                        
                        if (spi_if.rx_data_ref[9:8] == 2'b11) begin
                            if (spi_if.tx_valid) begin
                                // buffered_tx_data <= spi_if.tx_data;
                                spi_if.rx_valid_ref <= 1;
                            end
                            MOSI_transmit <= 1;
                            counter <= 8;
                        end
                    end
                end 
                else begin
                    if (counter > 0) begin
                        spi_if.MISO_ref <= spi_if.tx_data[counter-1];
                        spi_if.rx_valid_ref <= 0;
                        counter <= counter - 1;
                    end
                    else
                        spi_if.MISO_ref <= 0;
                end
            end
        endcase
    end
end
endmodule