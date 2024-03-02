`ifndef AXI4LITESLAVEWRITESEQPKG_INCLUDED
`define AXI4LITESLAVEWRITESEQPKG_INCLUDED

package Axi4LiteSlaveWriteSeqPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4LiteSlaveWritePkg::*;
  import axi4LiteGlobalsPkg::*; 
 
  `include "axi4LiteSlaveWriteBaseSeq.sv"

endpackage : Axi4LiteSlaveWriteSeqPkg
`endif
