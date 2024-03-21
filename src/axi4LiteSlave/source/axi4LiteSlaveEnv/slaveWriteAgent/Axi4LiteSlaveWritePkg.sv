`ifndef Axi4LITESLAVEWRITEPKG_INCLUDED_
`define Axi4LITESLAVEWRITEPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: Axi4LiteSlaveWritePkg
//  Includes all the files related to Axi4 Axi4_slave
//--------------------------------------------------------------------------------------------
package Axi4LiteSlaveWritePkg;

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
  `include "Axi4LiteSlaveWriteTransaction.sv"
  `include "Axi4LiteSlaveWriteAgentConfig.sv"
  `include "Axi4LiteSlaveWriteSeqItemConverter.sv"
  `include "Axi4LiteSlaveWriteConfigConverter.sv"
  `include "Axi4LiteSlaveWriteCoverage.sv"
  `include "Axi4LiteSlaveWriteSequencer.sv"
  `include "Axi4LiteSlaveWriteDriverProxy.sv"
  `include "Axi4LiteSlaveWriteMonitorProxy.sv"
  `include "Axi4LiteSlaveWriteAgent.sv"
  
endpackage : Axi4LiteSlaveWritePkg

`endif
