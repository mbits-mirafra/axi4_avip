`ifndef AXI4LITESLAVEREADPKG_INCLUDED_
`define AXI4LITESLAVEREADPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: Axi4LiteSlaveReadPkg
//  Includes all the files related to Axi4 Axi4_slave
//--------------------------------------------------------------------------------------------
package Axi4LiteSlaveReadPkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Import Axi4_globals_pkg 
  import Axi4LiteGlobalsPkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "Axi4LiteSlaveReadTransaction.sv"
  `include "Axi4LiteSlaveReadAgentConfig.sv"
  `include "Axi4LiteSlaveReadSeqItemConverter.sv"
  `include "Axi4LiteSlaveReadConfigConverter.sv"
  `include "Axi4LiteSlaveReadCoverage.sv"
  `include "Axi4LiteSlaveReadSequencer.sv"
  `include "Axi4LiteSlaveReadDriverProxy.sv"
  `include "Axi4LiteSlaveReadMonitorProxy.sv"
  `include "Axi4LiteSlaveReadAgent.sv"
  
endpackage : Axi4LiteSlaveReadPkg

`endif
