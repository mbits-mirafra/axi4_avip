`ifndef AXI4LITESLAVEWRITESEQPKG_INCLUDED
`define AXI4LITESLAVEWRITESEQPKG_INCLUDED

package Axi4LiteSlaveWriteSeqPkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import Axi4LiteSlaveWritePkg::*;
  import Axi4LiteGlobalsPkg::*; 
 
  `include "Axi4LiteSlaveWriteBaseSeq.sv"
  `include "Axi4LiteSlaveWriteTransferRandomReadyDelaySeq.sv"

endpackage : Axi4LiteSlaveWriteSeqPkg
`endif
