package Wrapper_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_cov_collector_pkg::*;
import Wrapper_agent_pkg::*;
import Wrapper_scoreboard_pkg::*;

  class Wrapper_env extends uvm_env;
    `uvm_component_utils(Wrapper_env)

    Wrapper_cov_collector cov;
    Wrapper_scoreboard sb;
    Wrapper_agent agt;

    function new(string name = "Wrapper_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt = Wrapper_agent::type_id::create("agt", this);
      cov = Wrapper_cov_collector::type_id::create("cov", this);
      sb = Wrapper_scoreboard::type_id::create("sb", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agt.agt_ap.connect(cov.cov_export);
      agt.agt_ap.connect(sb.sb_export);
    endfunction

  endclass
endpackage