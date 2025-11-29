package RAM_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_cov_collector_pkg::*;
import RAM_agent_pkg::*;
import RAM_scoreboard_pkg::*;

  class RAM_env extends uvm_env;
    `uvm_component_utils(RAM_env)

    RAM_cov_collector cov;
    RAM_scoreboard sb;
    RAM_agent agt;

    function new(string name = "RAM_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt = RAM_agent::type_id::create("agt", this);
      cov = RAM_cov_collector::type_id::create("cov", this);
      sb = RAM_scoreboard::type_id::create("sb", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agt.agt_ap.connect(cov.cov_export);
      agt.agt_ap.connect(sb.sb_export);
    endfunction

  endclass
endpackage