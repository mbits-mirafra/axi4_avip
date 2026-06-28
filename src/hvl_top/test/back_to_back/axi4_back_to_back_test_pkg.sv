`ifndef AXI4_BACK_TO_BACK_TEST_PKG_INCLUDED_
`define AXI4_BACK_TO_BACK_TEST_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_back_to_back_test_pkg
// Description:
// Includes all the back to back tests run for the master to slave VIP verification
//--------------------------------------------------------------------------------------------
package axi4_back_to_back_test_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import axi4_master_pkg::*;
  import axi4_slave_pkg::*;
  import axi4_env_pkg::*;
  import axi4_master_seq_pkg::*;
  import axi4_slave_seq_pkg::*;
  import axi4_back_to_back_vseq_pkg::*;

  //base test comes from the shared base package
  import axi4_test_base_pkg::*;

  //-------------------------------------------------------
  // Back to back tests
  //-------------------------------------------------------
  `include "axi4_back_to_back_write_test.sv"
  `include "axi4_back_to_back_read_test.sv"
  `include "axi4_back_to_back_write_read_test.sv"

endpackage : axi4_back_to_back_test_pkg

`endif
