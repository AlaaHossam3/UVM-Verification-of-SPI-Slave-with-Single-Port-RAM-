import uvm_pkg::*;
import RAM_test_pkg::*;
`include "uvm_macros.svh"

module top();
    bit clk;

    initial begin
        clk = 0;
        forever
            #2 clk = ~clk;
    end

    RAM_if ram_if(clk); 
    RAM dut(ram_if.DUT);
    RAM_ref_model ref_model(ram_if.REF_MODEL);

    bind RAM RAM_sva ram_sva_inst(ram_if);

    initial begin
        uvm_config_db #(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", ram_if);
        run_test("RAM_test");
    end
endmodule
