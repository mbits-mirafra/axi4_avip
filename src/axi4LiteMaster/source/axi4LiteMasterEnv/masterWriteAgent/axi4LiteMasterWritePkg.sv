`ifndef AXI4LITEMASTERWRITEPKG_INCLUDED_
`define AXI4LITEMASTERWRITEPKG_INCLUDED_

package Axi4LiteMasterWritePkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  import Axi4LiteGlobalsPkg::*;

  `include "axi4LiteMasterWriteAgentConfig.sv"
  `include "axi4LiteMasterWriteTransaction.sv"
  `include "axi4LiteMasterWriteSeqItemConverter.sv"
  `include "axi4LiteMasterWriteConfigConverter.sv"
  `include "axi4LiteMasterWriteSequencer.sv"
  `include "axi4LiteMasterWriteDriverProxy.sv"
  `include "axi4LiteMasterWriteMonitorProxy.sv"
  `include "axi4LiteMasterWriteCoverage.sv"
  `include "axi4LiteMasterWriteAgent.sv"
  
endpackage : Axi4LiteMasterWritePkg

`endif
