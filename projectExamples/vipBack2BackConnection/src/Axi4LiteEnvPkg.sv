`ifndef AXI4LITEENVPKG_INCLUDED_
`define AXI4LITEENVPKG_INCLUDED_

package Axi4LiteEnvPkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import Axi4LiteGlobalsPkg::*;
  import Axi4LiteMasterEnvPkg::*;
  import Axi4LiteSlaveEnvPkg::*;

  `include "Axi4LiteEnvConfig.sv"
  `include "Axi4LiteVirtualSequencer.sv"
  `include "Axi4LiteScoreboard.sv"
  `include "Axi4LiteEnv.sv"

endpackage : Axi4LiteEnvPkg

`endif
