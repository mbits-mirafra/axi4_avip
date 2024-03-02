`ifndef AXI4LITEMASTERENVPKG_INCLUDED_
`define AXI4LITEMASTERENVPKG_INCLUDED_

package Axi4LiteMasterEnvPkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import Axi4LiteGlobalsPkg::*;
  import Axi4LiteMasterWritePkg::*;
  import Axi4LiteMasterReadPkg::*;

  `include "axi4LiteMasterEnvConfig.sv"
  `include "axi4LiteMasterVirtualSequencer.sv"
  `include "axi4LiteMasterEnv.sv"

endpackage : Axi4LiteMasterEnvPkg

`endif
