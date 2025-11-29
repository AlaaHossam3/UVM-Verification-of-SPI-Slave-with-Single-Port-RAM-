module RAM (RAM_if.DUT ram_if);

reg [7:0] MEM [255:0];
integer i;
initial begin
    for(i = 0; i<256; i = i+1) begin
        MEM[i] = i;
    end    
end

reg [7:0] Rd_Addr, Wr_Addr;

always @(posedge ram_if.clk) begin
    if (~ram_if.rst_n) begin
        ram_if.dout <= 0;
        ram_if.tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end 
    else begin             
        if (ram_if.rx_valid) begin
            case (ram_if.din[9:8])
                2'b00 : Wr_Addr <= ram_if.din[7:0];
                2'b01 : MEM[Wr_Addr] <= ram_if.din[7:0];
                2'b10 : Rd_Addr <= ram_if.din[7:0];
                2'b11 : ram_if.dout <= MEM[Rd_Addr];
                default : ram_if.dout <= 0;
            endcase
        end
        ram_if.tx_valid <= (ram_if.din[9] && ram_if.din[8] && ram_if.rx_valid)? 1'b1 : 1'b0;
    end
end

endmodule