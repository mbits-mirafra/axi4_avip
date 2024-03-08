`ifndef AXI4LITEMASTERVIRTUALSEQRPKG_INCLUDED_
`define AXI4LITEMASTERVIRTUALSEQRPKG_INCLUDED_

package Axi4LiteMasterVirtualSeqrPkg;
  
 `include "uvm_macros.svh"
  import uvm_pkg::*;
  import Axi4LiteMasterWritePkg::*;
  import Axi4LiteMasterReadPkg::*;

 `include "Axi4LiteMasterVirtualSequencer.sv"

endpackage : Axi4LiteMasterVirtualSeqrPkg

`endif
