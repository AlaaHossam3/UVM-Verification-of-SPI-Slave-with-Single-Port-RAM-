package RAM_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_env_pkg::*;
import RAM_config_pkg::*;
import RAM_seq_pkg::*;


  class RAM_test extends uvm_test;
  `uvm_component_utils(RAM_test)

    RAM_env my_env;
    RAM_config my_cfg;
    reset_sequence reset_seq;
    write_only_sequence write_only_seq;
    read_only_sequence read_only_seq;
    random_rw_sequence random_rw_seq;

    function new(string name = "RAM_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      my_env = RAM_env::type_id::create("my_env", this);
      my_cfg = RAM_config::type_id::create("my_cfg");
      reset_seq = reset_sequence::type_id::create("reset_seq");
      write_only_seq = write_only_sequence::type_id::create("write_only_seq");
      read_only_seq = read_only_sequence::type_id::create("read_only_seq");
      random_rw_seq = random_rw_sequence::type_id::create("random_rw_seq");


      if(!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", my_cfg.ram_vif))
        `uvm_fatal("Build_Phase", "Test-Unable to get virtual interface");
      
      uvm_config_db #(RAM_config)::set(this, "*", "RAM_CFG", my_cfg);

      my_cfg.ram_is_active = UVM_ACTIVE;
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      `uvm_info("Run_phase", "Reset asserted.", UVM_LOW);
      reset_seq.start(my_env.agt.sqr);
      `uvm_info("Run_phase", "Reset deasserted.", UVM_LOW);

      `uvm_info("Run_phase", "Write only: Stimulus generation started.", UVM_LOW);
      write_only_seq.start(my_env.agt.sqr);  
      `uvm_info("Run_phase", "Write only: Stimulus generation ended.", UVM_LOW);
      
      `uvm_info("Run_phase", "Reset asserted.", UVM_LOW);
      reset_seq.start(my_env.agt.sqr);
      `uvm_info("Run_phase", "Reset deasserted.", UVM_LOW);

      `uvm_info("Run_phase", "Read only: Stimulus generation started.", UVM_LOW);
      read_only_seq.start(my_env.agt.sqr);  
      `uvm_info("Run_phase", "Read only: Stimulus generation ended.", UVM_LOW);
      
      `uvm_info("Run_phase", "Random: Stimulus generation started.", UVM_LOW);
      random_rw_seq.start(my_env.agt.sqr);  
      `uvm_info("Run_phase", "Random: Stimulus generation ended.", UVM_LOW);
      
      phase.drop_objection(this);
    endtask

  endclass: RAM_test
endpackage
