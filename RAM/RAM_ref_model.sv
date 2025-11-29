module RAM_ref_model ( RAM_if.REF_MODEL ram_if);

    localparam WRITE_ADD = 2'b00;
    localparam WRITE_DATA = 2'b01;
    localparam READ_ADD = 2'b10;
    localparam READ_DATA = 2'b11;
    
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;

    reg [ADDR_SIZE-1:0] addr_wr, addr_rd;
    reg [7:0] mem[MEM_DEPTH-1:0];
    integer i;
    initial begin
        for(i = 0; i<256; i = i+1) begin
            mem[i] = i;
        end    
    end

    always @(posedge ram_if.clk) begin
        if(~ram_if.rst_n) begin
            ram_if.dout_ref <= 0;
            ram_if.tx_valid_ref <= 0;
            addr_wr <= 0;
            addr_rd <= 0;
        end
        else begin
            ram_if.tx_valid_ref <= 1'b0;
            case (ram_if.din[9:8])
                WRITE_ADD:  if (ram_if.rx_valid) begin
                    addr_wr <=  ram_if.din[7:0];
                    ram_if.tx_valid_ref <= 0;
                end
                WRITE_DATA: if (ram_if.rx_valid) begin
                        mem[addr_wr] <= ram_if.din[7:0];
                        ram_if.tx_valid_ref <= 0;
                end
                READ_ADD: if (ram_if.rx_valid) begin
                    addr_rd <= ram_if.din[7:0];
                    ram_if.tx_valid_ref <= 0;
                end
                READ_DATA: begin
                    if(ram_if.rx_valid)
                        ram_if.dout_ref <= mem[addr_rd];
                    ram_if.tx_valid_ref <= (ram_if.din[9] && ram_if.din[8] && ram_if.rx_valid)? 1'b1 : 1'b0;
                end
            endcase
        end
    end
endmodule