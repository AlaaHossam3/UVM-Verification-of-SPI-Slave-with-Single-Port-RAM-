interface Wrapper_if(clk);

    input clk;
    logic MOSI, SS_n, rst_n;
    logic MISO, MISO_ref;

    modport DUT(
        input clk, MOSI, SS_n, rst_n,
        output MISO
    );
    
    modport REF_MODEL(
        input clk, MOSI, SS_n, rst_n,
        output MISO_ref
    );
    
endinterface
