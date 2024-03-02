`ifndef AXI4LITESLAVEREADPKG_INCLUDED_
`define AXI4LITESLAVEREADPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: Axi4LiteSlaveReadPkg
//  Includes all the files related to axi4 axi4_slave
//--------------------------------------------------------------------------------------------
package Axi4LiteSlaveReadPkg;

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
  `include "axi4LiteSlaveReadTransaction.sv"
  `include "axi4LiteSlaveReadAgentConfig.sv"
  `include "axi4LiteSlaveReadSeqItemConverter.sv"
  `include "axi4LiteSlaveReadConfigConverter.sv"
  `include "axi4LiteSlaveReadCoverage.sv"
  `include "axi4LiteSlaveReadSequencer.sv"
  `include "axi4LiteSlaveReadDriverProxy.sv"
  `include "axi4LiteSlaveReadMonitorProxy.sv"
  `include "axi4LiteSlaveReadAgent.sv"
  
endpackage : Axi4LiteSlaveReadPkg

`endif
