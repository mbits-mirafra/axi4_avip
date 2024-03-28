`ifndef AXI4LITEMASTERREADSEQPKG_INCLUDED
`define AXI4LITEMASTERREADSEQPKG_INCLUDED

package Axi4LiteMasterReadSeqPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import Axi4LiteMasterReadPkg::*;
  import Axi4LiteGlobalsPkg::*; 
 
  `include "Axi4LiteMasterReadBaseSeq.sv"
  `include "Axi4LiteMasterReadTransferValidGenerateSeq.sv"

endpackage : Axi4LiteMasterReadSeqPkg
`endif
