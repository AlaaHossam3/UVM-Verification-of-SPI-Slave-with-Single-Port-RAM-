package SPI_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_cov_collector_pkg::*;
import SPI_agent_pkg::*;
import SPI_scoreboard_pkg::*;

  class SPI_env extends uvm_env;
    `uvm_component_utils(SPI_env)

    SPI_cov_collector cov;
    SPI_scoreboard sb;
    SPI_agent agt;

    function new(string name = "SPI_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt = SPI_agent::type_id::create("agt", this);
      cov = SPI_cov_collector::type_id::create("cov", this);
      sb = SPI_scoreboard::type_id::create("sb", this);

    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agt.agt_ap.connect(cov.cov_export);
      agt.agt_ap.connect(sb.sb_export);
    endfunction

  endclass
endpackage