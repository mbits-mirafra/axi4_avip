`ifndef AXI4LITESLAVEREADSEQPKG_INCLUDED
`define AXI4LITESLAVEREADSEQPKG_INCLUDED

package Axi4LiteSlaveReadSeqPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4LiteSlaveReadPkg::*;
  import axi4LiteGlobalsPkg::*; 
 
  `include "axi4LiteSlaveReadBaseSeq.sv"

endpackage : Axi4LiteSlaveReadSeqPkg
`endif
