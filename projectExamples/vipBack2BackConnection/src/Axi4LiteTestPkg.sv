`ifndef AXI4LITETESTPKG_INCLUDED_
`define AXI4LITETESTPKG_INCLUDED_

package Axi4LiteTestPkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import Axi4LiteGlobalsPkg::*;
  import Axi4LiteMasterWritePkg::*;
  import Axi4LiteMasterReadPkg::*;
  import Axi4LiteSlaveWritePkg::*;
  import Axi4LiteSlaveReadPkg::*;
  import Axi4LiteMasterEnvPkg::*;
  import Axi4LiteSlaveEnvPkg::*;
  import Axi4LiteEnvPkg::*;

  import Axi4LiteMasterWriteSeqPkg::*;
  import Axi4LiteMasterReadSeqPkg::*;
  import Axi4LiteSlaveWriteSeqPkg::*;
  import Axi4LiteSlaveReadSeqPkg::*;

  import Axi4LiteVirtualSeqPkg::*;

  //including base_test for testing
  `include "Axi4LiteBaseTest.sv"

endpackage : Axi4LiteTestPkg

`endif
