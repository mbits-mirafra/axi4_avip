`ifndef AXI4LITEMASTERREADPKG_INCLUDED_
`define AXI4LITEMASTERREADPKG_INCLUDED_

package Axi4LiteMasterReadPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  import Axi4LiteGlobalsPkg::*;

  `include "Axi4LiteMasterReadAgentConfig.sv"
  `include "Axi4LiteMasterReadTransaction.sv"
  `include "Axi4LiteMasterReadSeqItemConverter.sv"
  `include "Axi4LiteMasterReadConfigConverter.sv"
  `include "Axi4LiteMasterReadSequencer.sv"
  `include "Axi4LiteMasterReadDriverProxy.sv"
  `include "Axi4LiteMasterReadMonitorProxy.sv"
  `include "Axi4LiteMasterReadCoverage.sv"
  `include "Axi4LiteMasterReadAgent.sv"
  
endpackage : Axi4LiteMasterReadPkg

`endif
