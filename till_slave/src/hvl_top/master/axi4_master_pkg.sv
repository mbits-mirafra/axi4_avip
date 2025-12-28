`ifndef AXI4_MASTER_PKG_INCLUDED_
`define AXI4_MASTER_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: axi4_master_pkg
//  Includes all the files related to axi4 master
//--------------------------------------------------------------------------------------------
package axi4_master_pkg;

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
  `include "axi4_master_agent_config.sv"
  `include "axi4_master_tx.sv"
  `include "axi4_master_seq_item_converter.sv"
  `include "axi4_master_cfg_converter.sv"
  `include "axi4_master_write_sequencer.sv"
  `include "axi4_master_read_sequencer.sv"
  `include "axi4_master_driver_proxy.sv"
  `include "axi4_master_monitor_proxy.sv"
  `include "axi4_master_coverage.sv"
  `include "axi4_master_agent.sv"
  
endpackage : axi4_master_pkg

`endif
