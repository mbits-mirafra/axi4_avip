`ifndef AXI4_ENV_PKG_INCLUDED_
`define AXI4_ENV_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: axi4_env_pkg
// Includes all the files related to axi4 env
//--------------------------------------------------------------------------------------------
package axi4_env_pkg;
  
  //Import uvm package
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  //Importing the required packages
  import axi4_globals_pkg::*;
  import axi4_master_pkg::*;
  import axi4_slave_pkg::*;

  //Include all other files
  `include "axi4_env_config.sv"
  `include "axi4_virtual_sequencer.sv"
  `include "axi4_scoreboard.sv"
  `include "axi4_env.sv"

endpackage : axi4_env_pkg

`endif
