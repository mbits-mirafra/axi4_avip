`ifndef AXI4LITEENVPKG_INCLUDED_
`define AXI4LITEENVPKG_INCLUDED_

package Axi4LiteEnvPkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import Axi4LiteGlobalsPkg::*;
  import Axi4LiteMasterEnvPkg::*;
  import Axi4LiteSlaveEnvPkg::*;

  `include "axi4LiteEnvConfig.sv"
  `include "axi4LiteVirtualSequencer.sv"
  `include "axi4LiteScoreboard.sv"
  `include "axi4LiteEnv.sv"

endpackage : Axi4LiteEnvPkg

`endif
