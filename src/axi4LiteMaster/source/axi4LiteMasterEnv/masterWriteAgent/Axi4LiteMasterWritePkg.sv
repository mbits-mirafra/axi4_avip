`ifndef AXI4LITEMASTERWRITEPKG_INCLUDED_
`define AXI4LITEMASTERWRITEPKG_INCLUDED_

package Axi4LiteMasterWritePkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  import Axi4LiteGlobalsPkg::*;

  `include "Axi4LiteMasterWriteAgentConfig.sv"
  `include "Axi4LiteMasterWriteTransaction.sv"
  `include "Axi4LiteMasterWriteSeqItemConverter.sv"
  `include "Axi4LiteMasterWriteConfigConverter.sv"
  `include "Axi4LiteMasterWriteSequencer.sv"
  `include "Axi4LiteMasterWriteDriverProxy.sv"
  `include "Axi4LiteMasterWriteMonitorProxy.sv"
  `include "Axi4LiteMasterWriteCoverage.sv"
  `include "Axi4LiteMasterWriteAgent.sv"
  
endpackage : Axi4LiteMasterWritePkg

`endif
