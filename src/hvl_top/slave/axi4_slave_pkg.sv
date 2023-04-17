`ifndef AXI4_SLAVE_PKG_INCLUDED_
`define AXI4_SLAVE_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: axi4_slave_pkg
//  Includes all the files related to axi4 axi4_slave
//--------------------------------------------------------------------------------------------
package axi4_slave_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Import axi4_globals_pkg 
  import axi4_globals_pkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "axi4_slave_memory.sv"
  `include "axi4_slave_tx.sv"
  `include "axi4_slave_agent_config.sv"
  `include "axi4_slave_seq_item_converter.sv"
  `include "axi4_slave_cfg_converter.sv"
  `include "axi4_slave_coverage.sv"
  `include "axi4_slave_write_sequencer.sv"
  `include "axi4_slave_read_sequencer.sv"
  `include "axi4_slave_driver_proxy.sv"
  `include "axi4_slave_monitor_proxy.sv"
  `include "axi4_slave_agent.sv"
  
endpackage : axi4_slave_pkg

`endif
