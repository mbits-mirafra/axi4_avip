`ifndef AXI4LITEMASTERWRITESEQPKG_INCLUDED
`define AXI4LITEMASTERWRITESEQPKG_INCLUDED

package Axi4LiteMasterWriteSeqPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4LiteMasterWritePkg::*;
  import axi4LiteGlobalsPkg::*; 
 
  `include "axi4LiteMasterWriteBaseSeq.sv"

endpackage : Axi4LiteMasterWriteSeqPkg
`endif
