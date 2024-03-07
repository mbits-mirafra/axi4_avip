`ifndef AXI4LITEMASTERENVPKG_INCLUDED_
`define AXI4LITEMASTERENVPKG_INCLUDED_

package Axi4LiteMasterEnvPkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import Axi4LiteGlobalsPkg::*;
  import Axi4LiteMasterWritePkg::*;
  import Axi4LiteMasterReadPkg::*;

  `include "Axi4LiteMasterEnvConfig.sv"
  `include "Axi4LiteMasterEnv.sv"

endpackage : Axi4LiteMasterEnvPkg

`endif
