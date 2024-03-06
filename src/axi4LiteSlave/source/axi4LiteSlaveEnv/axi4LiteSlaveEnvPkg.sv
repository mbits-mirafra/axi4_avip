`ifndef AXI4LITESLAVEENVPKG_INCLUDED_
`define AXI4LITESLAVEENVPKG_INCLUDED_

package Axi4LiteSlaveEnvPkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import Axi4LiteGlobalsPkg::*;
  import Axi4LiteSlaveWritePkg::*;
  import Axi4LiteSlaveReadPkg::*;

  `include "axi4LiteSlaveEnvConfig.sv"
  `include "axi4LiteSlaveVirtualSequencer.sv"
  `include "axi4LiteSlaveEnv.sv"

endpackage : Axi4LiteSlaveEnvPkg

`endif
