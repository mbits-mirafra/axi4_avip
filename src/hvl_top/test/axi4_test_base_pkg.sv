`ifndef AXI4_TEST_BASE_PKG_INCLUDED_
`define AXI4_TEST_BASE_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_test_base_pkg
// Description:
// Holds the common base test so it is compiled once and shared by all the test packages
//-------------------------------------------------------------------------------------------
package axi4_test_base_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import axi4_master_pkg::*;
  import axi4_slave_pkg::*;
  import axi4_env_pkg::*;

  //including base_test for testing
  `include "axi4_base_test.sv"

endpackage : axi4_test_base_pkg

`endif
