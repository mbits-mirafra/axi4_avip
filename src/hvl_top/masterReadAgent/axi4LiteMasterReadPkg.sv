`ifndef AXI4LITEMASTERREADPKG_INCLUDED_
`define AXI4LITEMASTERREADPKG_INCLUDED_

package Axi4LiteMasterReadPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  import Axi4LiteGlobalsPkg::*;

  `include "axi4LiteMasterReadAgentConfig.sv"
  `include "axi4LiteMasterReadTransaction.sv"
  `include "axi4LiteMasterReadSeqItemConverter.sv"
  `include "axi4LiteMasterReadConfigConverter.sv"
  `include "axi4LiteMasterReadSequencer.sv"
  `include "axi4LiteMasterReadDriverProxy.sv"
  `include "axi4LiteMasterReadMonitorProxy.sv"
  `include "axi4LiteMasterReadCoverage.sv"
  `include "axi4LiteMasterReadAgent.sv"
  
endpackage : Axi4LiteMasterReadPkg

`endif
