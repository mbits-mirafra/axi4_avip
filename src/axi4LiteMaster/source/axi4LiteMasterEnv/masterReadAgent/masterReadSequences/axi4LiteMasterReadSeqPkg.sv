`ifndef AXI4LITEMASTERREADSEQPKG_INCLUDED
`define AXI4LITEMASTERREADSEQPKG_INCLUDED

package Axi4LiteMasterReadSeqPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4LiteMasterReadPkg::*;
  import axi4LiteGlobalsPkg::*; 
 
  `include "axi4LiteMasterReadBaseSeq.sv"

endpackage : Axi4LiteMasterReadSeqPkg
`endif
