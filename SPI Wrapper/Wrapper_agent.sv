package Wrapper_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_seq_item_pkg::*;
import Wrapper_driver_pkg::*;
import Wrapper_monitor_pkg::*;
import Wrapper_sqr_pkg::*;
import Wrapper_config_pkg::*;

    class Wrapper_agent extends uvm_agent;
        `uvm_component_utils(Wrapper_agent)

        Wrapper_sqr sqr;
        Wrapper_driver drv;
        Wrapper_monitor mon;
        Wrapper_config cfg;
        uvm_analysis_port #(Wrapper_seq_item) agt_ap;

        function new(string name = "Wrapper_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(Wrapper_config)::get(this, "", "Wrapper_CFG", cfg))
                `uvm_fatal("Build_phase", "Agent-Unable to get configuration object")

            if(cfg.wrapper_is_active == UVM_ACTIVE) begin
                sqr = Wrapper_sqr::type_id::create("sqr", this);
                drv = Wrapper_driver::type_id::create("drv", this);
            end

            mon = Wrapper_monitor::type_id::create("mon", this);
            agt_ap = new("agt_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            if(cfg.wrapper_is_active == UVM_ACTIVE) begin
                drv.wrapper_vif = cfg.wrapper_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end

            mon.wrapper_vif = cfg.wrapper_vif;
            mon.mon_ap.connect(agt_ap);
        endfunction
    endclass
endpackage
