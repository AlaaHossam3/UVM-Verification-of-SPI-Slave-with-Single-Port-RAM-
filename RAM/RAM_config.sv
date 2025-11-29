package RAM_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh";

class RAM_config extends uvm_object;
    `uvm_object_utils(RAM_config)

    virtual RAM_if ram_vif;
    uvm_active_passive_enum ram_is_active;

    function new(string name = "RAM_config");
        super.new(name);
    endfunction
endclass
    
endpackage
