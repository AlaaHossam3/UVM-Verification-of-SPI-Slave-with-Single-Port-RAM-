package Wrapper_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Wrapper_env_pkg::*;
import Wrapper_config_pkg::*;
import Wrapper_seq_pkg::*;

import SPI_env_pkg::*;
import SPI_config_pkg::*;

import RAM_env_pkg::*;
import RAM_config_pkg::*;

  class Wrapper_test extends uvm_test;
  `uvm_component_utils(Wrapper_test)
  
    Wrapper_env wrapper_env;
    SPI_env     spi_env;
    RAM_env     ram_env;

    Wrapper_config  wrapper_cfg;
    SPI_config      spi_cfg;
    RAM_config      ram_cfg;

    wrapper_reset_sequence       reset_seq;
    wrapper_write_only_sequence  write_only_seq;
    wrapper_read_only_sequence   read_only_seq;
    wrapper_random_rw_sequence   random_rw_seq;

    function new(string name = "Wrapper_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      wrapper_env =  Wrapper_env::type_id::create("wrapper_env", this);
      spi_env     =  SPI_env::type_id::create("spi_env", this);
      ram_env     =  RAM_env::type_id::create("ram_env", this);

      wrapper_cfg = Wrapper_config::type_id::create("wrapper_cfg");
      spi_cfg     = SPI_config::type_id::create("spi_cfg");
      ram_cfg     = RAM_config::type_id::create("ram_cfg");

      reset_seq       = wrapper_reset_sequence::type_id::create("reset_seq");
      write_only_seq  = wrapper_write_only_sequence::type_id::create("write_only_seq");
      read_only_seq   = wrapper_read_only_sequence::type_id::create("read_only_seq");
      random_rw_seq   = wrapper_random_rw_sequence::type_id::create("random_rw_seq");

      wrapper_cfg.wrapper_is_active = UVM_ACTIVE;
      spi_cfg.spi_is_active         = UVM_PASSIVE;
      ram_cfg.ram_is_active         = UVM_PASSIVE;

      if(!uvm_config_db #(virtual Wrapper_if)::get(this, "", "Wrapper_IF", wrapper_cfg.wrapper_vif))
        `uvm_fatal("Build_Phase", "Test-Unable to get WRAPPER virtual interface");
      
      if(!uvm_config_db #(virtual SPI_if)::get(this, "", "SPI_IF", spi_cfg.spi_vif))
        `uvm_fatal("Build_Phase", "Test-Unable to get SPI virtual interface");
      
      if(!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", ram_cfg.ram_vif))
        `uvm_fatal("Build_Phase", "Test-Unable to get RAM virtual interface");
      
      uvm_config_db #(Wrapper_config)::set(this, "*", "Wrapper_CFG", wrapper_cfg);
      uvm_config_db #(SPI_config)::set(this, "*", "SPI_CFG", spi_cfg);
      uvm_config_db #(RAM_config)::set(this, "*", "RAM_CFG", ram_cfg);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      `uvm_info("Run_phase", "Reset asserted.", UVM_LOW);
      reset_seq.start(wrapper_env.agt.sqr);
      `uvm_info("Run_phase", "Reset deasserted.", UVM_LOW);

      `uvm_info("Run_phase", "Write: Stimulus generation started.", UVM_LOW);
      write_only_seq.start(wrapper_env.agt.sqr);  
      `uvm_info("Run_phase", "Write: Stimulus generation ended.", UVM_LOW);

      `uvm_info("Run_phase", "Reset asserted.", UVM_LOW);
      reset_seq.start(wrapper_env.agt.sqr);
      `uvm_info("Run_phase", "Reset deasserted.", UVM_LOW);

      `uvm_info("Run_phase", "Read: Stimulus generation started.", UVM_LOW);
      read_only_seq.start(wrapper_env.agt.sqr);  
      `uvm_info("Run_phase", "Read: Stimulus generation ended.", UVM_LOW);

      `uvm_info("Run_phase", "Reset asserted.", UVM_LOW);
      reset_seq.start(wrapper_env.agt.sqr);
      `uvm_info("Run_phase", "Reset deasserted.", UVM_LOW);

      `uvm_info("Run_phase", "Random: Stimulus generation started.", UVM_LOW);
      random_rw_seq.start(wrapper_env.agt.sqr);
      `uvm_info("Run_phase", "Random: Stimulus generation ended.", UVM_LOW);
      
      phase.drop_objection(this);
    endtask
  endclass: Wrapper_test
endpackage
