`ifndef AXI4LITESLAVEWRITEPKG_INCLUDED_
`define AXI4LITESLAVEWRITEPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: Axi4LiteSlaveWritePkg
//  Includes all the files related to axi4 axi4_slave
//--------------------------------------------------------------------------------------------
package Axi4LiteSlaveWritePkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Import axi4_globals_pkg 
  import Axi4LiteGlobalsPkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "axi4LiteSlaveWriteTransaction.sv"
  `include "axi4LiteSlaveWriteAgentConfig.sv"
  `include "axi4LiteSlaveWriteSeqItemConverter.sv"
  `include "axi4LiteSlaveWriteConfigConverter.sv"
  `include "axi4LiteSlaveWriteCoverage.sv"
  `include "axi4LiteSlaveWriteSequencer.sv"
  `include "axi4LiteSlaveWriteDriverProxy.sv"
  `include "axi4LiteSlaveWriteMonitorProxy.sv"
  `include "axi4LiteSlaveWriteAgent.sv"
  
endpackage : Axi4LiteSlaveWritePkg

`endif
