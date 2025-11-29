package SPI_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_env_pkg::*;
import SPI_config_pkg::*;
import SPI_seq_pkg::*;


  class SPI_test extends uvm_test;
  `uvm_component_utils(SPI_test)

    SPI_env my_env;
    SPI_config my_cfg;
    reset_sequence reset_seq;
    main_sequence main_seq;

    function new(string name = "SPI_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      my_env = SPI_env::type_id::create("my_env", this);
      my_cfg = SPI_config::type_id::create("my_cfg");
      reset_seq = reset_sequence::type_id::create("reset_seq");
      main_seq = main_sequence::type_id::create("main_seq");


      if(!uvm_config_db #(virtual SPI_if)::get(this, "", "SPI_IF", my_cfg.spi_vif))
        `uvm_fatal("Build_Phase", "Test-Unable to get virtual interface");
      
      uvm_config_db #(SPI_config)::set(this, "*", "SPI_CFG", my_cfg);

      my_cfg.spi_is_active = UVM_ACTIVE;
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      `uvm_info("Run_phase", "Reset asserted.", UVM_LOW);
      reset_seq.start(my_env.agt.sqr);
      `uvm_info("Run_phase", "Reset deasserted.", UVM_LOW);

      `uvm_info("Run_phase", "Stimulus generation started.", UVM_LOW);
      main_seq.start(my_env.agt.sqr);  
      `uvm_info("Run_phase", "Stimulus generation ended.", UVM_LOW);
      
      phase.drop_objection(this);
    endtask

  endclass: SPI_test
endpackage