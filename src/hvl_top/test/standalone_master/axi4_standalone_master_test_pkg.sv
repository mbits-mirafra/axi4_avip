`ifndef AXI4_STANDALONE_MASTER_TEST_PKG_INCLUDED_
`define AXI4_STANDALONE_MASTER_TEST_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: Test
// Description:
// Includes all the files written to run the simulation
//--------------------------------------------------------------------------------------------
package axi4_standalone_master_test_pkg;

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
  import axi4_standalone_master_vseq_pkg::*;

  //base test comes from the shared base package
  import axi4_test_base_pkg::*;

  //-------------------------------------------------------
  // Slave tests (standalone master RTL)
  //-------------------------------------------------------
  `include "axi4_non_outstanding_slave_write_test.sv"
  `include "axi4_outstanding_slave_write_test.sv"
  `include "axi4_non_outstanding_slave_read_test.sv"
  `include "axi4_outstanding_slave_read_test.sv"
  `include "axi4_non_outstanding_slave_write_read_test.sv"
  `include "axi4_outstanding_slave_write_read_test.sv"

endpackage : axi4_standalone_master_test_pkg

`endif
