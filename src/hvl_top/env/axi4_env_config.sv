`ifndef AXI4_ENV_CONFIG_INCLUDED_
`define AXI4_ENV_CONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4 env_config
// This class is used as configuration class for environment and its components
//--------------------------------------------------------------------------------------------
class axi4_env_config extends uvm_object;
  `uvm_object_utils(axi4_env_config)
  

  // Variable: has_scoreboard
  // Enables the scoreboard. Default value is 1
  bit has_scoreboard = 1;

  // Variable: has_virtual_sqr
  // Enables the virtual sequencer. Default value is 1
  bit has_virtual_seqr = 1;

  // Variable: no_of_slaves
  // Number of slaves connected to the AXI interface
  int no_of_slaves;
  
  // Variable: no_of_masters
  // Number of masters connected to the AXI interface
  int no_of_masters;

  // Variable: master_agent_cfg_h
  // Handle for axi4 master agent configuration
  axi4_master_agent_config axi4_master_agent_cfg_h[];

  // Variable: slave_agent_cfg_h
  // axi4 slave agent configuration handles
  axi4_slave_agent_config axi4_slave_agent_cfg_h[];

  // Variable: write_read_mode_h
  write_read_data_mode_e write_read_mode_h;

//-------------------------------------------------------
// Externally defined Tasks and Functions
//-------------------------------------------------------
  extern function new(string name = "axi4_env_config");
  extern function void do_print(uvm_printer printer);

endclass : axi4_env_config

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_env_config
//--------------------------------------------------------------------------------------------
function axi4_env_config::new(string name = "axi4_env_config");
  super.new(name);
endfunction : new


//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void axi4_env_config::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field ("has_scoreboard",has_scoreboard,1, UVM_DEC);
  printer.print_field ("has_virtual_sqr",has_virtual_seqr,1, UVM_DEC);
  printer.print_field ("no_of_masters",no_of_masters,$bits(no_of_masters), UVM_HEX);
  printer.print_field ("no_of_slaves",no_of_slaves,$bits(no_of_slaves), UVM_HEX);
  printer.print_string ("transfer_type",   write_read_mode_h.name());

endfunction : do_print

`endif

