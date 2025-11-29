interface RAM_if(clk);

    input clk;
    logic [9:0] din;
    logic       rst_n, rx_valid;
    logic [7:0] dout;
    logic       tx_valid;
    logic [7:0] dout_ref;
    logic       tx_valid_ref;

    modport DUT(
        input din, clk, rst_n, rx_valid,
        output dout, tx_valid
    );
    
    modport REF_MODEL(
        input din, clk, rst_n, rx_valid,
        output dout_ref, tx_valid_ref
    );
endinterface
