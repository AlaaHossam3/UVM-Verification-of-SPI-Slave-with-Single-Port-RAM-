import shared_pkg::*;
module SLAVE (SPI_if.DUT spi_if);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

reg [3:0] counter;
reg       received_address;
reg       MOSI_transmit;

reg [2:0] cs, ns;

always @(posedge spi_if.clk) begin
    if (~spi_if.rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
        state <= ns;
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
        spi_if.rx_data <= 0;
        spi_if.rx_valid <= 0;
        received_address <= 0;
        spi_if.MISO <= 0;

        MOSI_transmit <= 0;
    end
    else begin
        spi_if.rx_valid <= 0;

        case (cs)
            IDLE : begin
                MOSI_transmit <= 0;
                spi_if.MISO <= 0;
            end
            CHK_CMD : begin
                counter <= 10;
            end
            WRITE : begin
                if (counter > 0) begin
                    spi_if.rx_data[counter-1] <= spi_if.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    spi_if.rx_valid <= 1;
                    received_address <= 0;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    spi_if.rx_data[counter-1] <= spi_if.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    spi_if.rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (!MOSI_transmit) begin
                    if (counter > 0) begin
                        spi_if.rx_data[counter-1] <= spi_if.MOSI;
                        counter <= counter - 1;
                    end 
                    else begin
                        spi_if.rx_valid <= 1;
                        
                            if (spi_if.tx_valid) begin
                                spi_if.rx_valid <= 1;
                            end
                            MOSI_transmit <= 1;
                            counter <= 8;
                    end
                end 
                else begin
                    if (counter > 0) begin
                        spi_if.MISO <=  spi_if.tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else
                        spi_if.MISO <= 0;
                end
            end
        endcase
    end
end


property rst_asserted;
    @(posedge spi_if.clk) !spi_if.rst_n |=> ##1(!spi_if.MISO && !spi_if.rx_valid && spi_if.rx_data == 0);
endproperty

property wr_op;
   @(posedge spi_if.clk) disable iff (!spi_if.rst_n) $rose(cs == WRITE) |-> ##12 $rose($past(spi_if.rx_valid, 1) && !spi_if.SS_n);
endproperty

property rd_add;
    @(posedge spi_if.clk) disable iff (!spi_if.rst_n) $rose(cs == READ_ADD) |-> ##12 $rose($past(spi_if.rx_valid, 1) && !spi_if.SS_n);
endproperty

property rd_data;
    @(posedge spi_if.clk) disable iff (!spi_if.rst_n) $rose(cs == READ_DATA) |-> ##11 $rose(spi_if.rx_valid) ;
endproperty

property idle_to_chk_cmd;
    @(posedge spi_if.clk) disable iff (!spi_if.rst_n) $rose(cs == IDLE) |-> ##1 $rose(cs == CHK_CMD) ;
endproperty

property chk_cmd_to_rd_wr;
    @(posedge spi_if.clk) disable iff (!spi_if.rst_n) $rose(cs == CHK_CMD) |-> ##1 ($rose(cs == WRITE) | $rose(cs == READ_ADD) | $rose(cs == READ_DATA));
endproperty

property wr_to_idle;
    @(posedge spi_if.clk) disable iff (!spi_if.rst_n) $rose(cs == WRITE) |-> ##11 $rose(cs == IDLE);
endproperty

property rd_add_to_idle;
    @(posedge spi_if.clk) disable iff (!spi_if.rst_n) $rose(cs == READ_ADD) |->  ##11 $rose(cs == IDLE);
endproperty

property rd_data_to_idle;
    @(posedge spi_if.clk) disable iff (!spi_if.rst_n) ($rose(cs == READ_DATA) && cycles == 23) |-> ##21 $rose(cs == IDLE);
endproperty

rst_assert:                 assert property(rst_asserted);
wr_op_assert:               assert property(wr_op);
rd_add_assert:              assert property(rd_add);
rd_data_assert:             assert property(rd_data);
idle_to_chk_cmd_assert:     assert property(idle_to_chk_cmd);
chk_cmd_to_rd_wr_assert:    assert property(chk_cmd_to_rd_wr);
wr_to_idle_assert:          assert property(wr_to_idle);
rd_add_to_idle_assert:      assert property(rd_add_to_idle);
rd_data_to_idle_assert:     assert property(rd_data_to_idle);

rst_cover:                  cover property(rst_asserted);
wr_op_cover:                cover property(wr_op);
rd_add_cover:               cover property(rd_add);
rd_data_cover:              cover property(rd_data);
idle_to_chk_cmd_cover:      cover property(idle_to_chk_cmd);
chk_cmd_to_rd_wr_cover:     cover property(chk_cmd_to_rd_wr);
wr_to_idle_cover:           cover property(wr_to_idle);
rd_add_to_idle_cover:       cover property(rd_add_to_idle);
rd_data_to_idle_cover:      cover property(rd_data_to_idle);

endmodule