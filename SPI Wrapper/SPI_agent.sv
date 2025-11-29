package SPI_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;
import SPI_driver_pkg::*;
import SPI_monitor_pkg::*;
import SPI_sqr_pkg::*;
import SPI_config_pkg::*;

    class SPI_agent extends uvm_agent;
        `uvm_component_utils(SPI_agent)

        SPI_sqr sqr;
        SPI_driver drv;
        SPI_monitor mon;
        SPI_config cfg;
        uvm_analysis_port #(SPI_seq_item) agt_ap;

        function new(string name = "SPI_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(SPI_config)::get(this, "", "SPI_CFG", cfg))
                `uvm_fatal("Build_phase", "Agent-Unable to get configuration object")
            
            if(cfg.spi_is_active == UVM_ACTIVE) begin
                sqr = SPI_sqr::type_id::create("sqr", this);
                drv = SPI_driver::type_id::create("drv", this);
            end

            mon = SPI_monitor::type_id::create("mon", this);
            agt_ap = new("agt_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            if(cfg.spi_is_active == UVM_ACTIVE) begin
                drv.spi_vif = cfg.spi_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end
            
            mon.spi_vif = cfg.spi_vif;
            mon.mon_ap.connect(agt_ap);
        endfunction

    endclass
endpackage