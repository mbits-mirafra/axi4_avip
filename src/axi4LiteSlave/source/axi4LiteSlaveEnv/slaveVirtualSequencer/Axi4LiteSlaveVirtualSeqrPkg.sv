`ifndef AXI4LITEMASTERVIRTUALSEQRPKG_INCLUDED_
`define AXI4LITEMASTERVIRTUALSEQRPKG_INCLUDED_

package Axi4LiteSlaveVirtualSeqrPkg;
  
 `include "uvm_macros.svh"
  import uvm_pkg::*;
  import Axi4LiteSlaveWritePkg::*;
  import Axi4LiteSlaveReadPkg::*;

 `include "Axi4LiteSlaveVirtualSequencer.sv"

endpackage : Axi4LiteSlaveVirtualSeqrPkg

`endif
