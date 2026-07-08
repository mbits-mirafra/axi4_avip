`ifndef AXI4_STANDALONE_SLAVE_TEST_PKG_INCLUDED_
`define AXI4_STANDALONE_SLAVE_TEST_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: Test
// Description:
// Includes all the files written to run the simulation
//--------------------------------------------------------------------------------------------
package axi4_standalone_slave_test_pkg;

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
  import axi4_standalone_slave_vseq_pkg::*;

  //base test comes from the shared base package
  import axi4_test_base_pkg::*;
  `include "axi4_non_outstanding_8b_write_data_test.sv"
  `include "axi4_non_outstanding_16b_write_data_test.sv"
  `include "axi4_non_outstanding_32b_write_data_test.sv"
  `include "axi4_non_outstanding_64b_write_data_test.sv"
  `include "axi4_non_outstanding_incr_burst_write_test.sv"
  `include "axi4_non_outstanding_wrap_burst_write_test.sv"
  `include "axi4_outstanding_8b_write_data_test.sv"
  `include "axi4_outstanding_16b_write_data_test.sv"
  `include "axi4_outstanding_32b_write_data_test.sv"
  `include "axi4_outstanding_64b_write_data_test.sv"
  `include "axi4_outstanding_incr_burst_write_test.sv"
  `include "axi4_outstanding_wrap_burst_write_test.sv"
  `include "axi4_non_outstanding_incr_burst_read_test.sv"
  `include "axi4_non_outstanding_wrap_burst_read_test.sv"
  `include "axi4_non_outstanding_8b_data_read_test.sv"
  `include "axi4_non_outstanding_16b_data_read_test.sv"
  `include "axi4_non_outstanding_32b_data_read_test.sv"
  `include "axi4_non_outstanding_64b_data_read_test.sv"
  `include "axi4_non_outstanding_64b_data_read_test.sv"
  `include "axi4_outstanding_incr_burst_read_test.sv"
  `include "axi4_outstanding_wrap_burst_read_test.sv"
  `include "axi4_outstanding_8b_data_read_test.sv"
  `include "axi4_outstanding_16b_data_read_test.sv"
  `include "axi4_outstanding_32b_data_read_test.sv"
  `include "axi4_outstanding_64b_data_read_test.sv"
  
  `include "axi4_non_outstanding_8b_write_read_test.sv"
  `include "axi4_non_outstanding_16b_write_read_test.sv"
  `include "axi4_non_outstanding_32b_write_read_test.sv"
  `include "axi4_non_outstanding_64b_write_read_test.sv"
  `include "axi4_non_outstanding_fixed_burst_write_read_test.sv"
  
  `include "axi4_outstanding_8b_write_read_test.sv"
  `include "axi4_outstanding_16b_write_read_test.sv"
  `include "axi4_outstanding_32b_write_read_test.sv"
  `include "axi4_outstanding_64b_write_read_test.sv"
  `include "axi4_non_outstanding_incr_burst_write_read_test.sv"
  `include "axi4_outstanding_incr_burst_write_read_test.sv"
  `include "axi4_non_outstanding_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_fixed_burst_write_read_test.sv"

  //-------------------------------------------------------
  // Larger transfer-size tests : 128b/256b/512b
  // (WRITE/READ_16/32/64_BYTES) up to 64-byte / 512-bit
  //-------------------------------------------------------
  // write_data
  `include "axi4_non_outstanding_128b_write_data_test.sv"
  `include "axi4_non_outstanding_256b_write_data_test.sv"
  `include "axi4_non_outstanding_512b_write_data_test.sv"
  `include "axi4_outstanding_128b_write_data_test.sv"
  `include "axi4_outstanding_256b_write_data_test.sv"
  `include "axi4_outstanding_512b_write_data_test.sv"
  // data_read
  `include "axi4_non_outstanding_128b_data_read_test.sv"
  `include "axi4_non_outstanding_256b_data_read_test.sv"
  `include "axi4_non_outstanding_512b_data_read_test.sv"
  `include "axi4_outstanding_128b_data_read_test.sv"
  `include "axi4_outstanding_256b_data_read_test.sv"
  `include "axi4_outstanding_512b_data_read_test.sv"
  // write_read
  `include "axi4_non_outstanding_128b_write_read_test.sv"
  `include "axi4_non_outstanding_256b_write_read_test.sv"
  `include "axi4_non_outstanding_512b_write_read_test.sv"
  `include "axi4_outstanding_128b_write_read_test.sv"
  `include "axi4_outstanding_256b_write_read_test.sv"
  `include "axi4_outstanding_512b_write_read_test.sv"

  //-------------------------------------------------------
  // FIXED & WRAP burst at larger sizes : 128b/256b/512b
  //-------------------------------------------------------
  // fixed burst
  `include "axi4_non_outstanding_128b_fixed_burst_write_read_test.sv"
  `include "axi4_non_outstanding_256b_fixed_burst_write_read_test.sv"
  `include "axi4_non_outstanding_512b_fixed_burst_write_read_test.sv"
  `include "axi4_outstanding_128b_fixed_burst_write_read_test.sv"
  `include "axi4_outstanding_256b_fixed_burst_write_read_test.sv"
  `include "axi4_outstanding_512b_fixed_burst_write_read_test.sv"
   `include "axi4_outstanding_8b_fixed_burst_write_read_test.sv"
  `include "axi4_outstanding_16b_fixed_burst_write_read_test.sv"
  // wrap burst
  `include "axi4_non_outstanding_128b_wrap_burst_write_read_test.sv"
  `include "axi4_non_outstanding_256b_wrap_burst_write_read_test.sv"
  `include "axi4_non_outstanding_512b_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_128b_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_256b_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_512b_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_8b_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_16b_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_64b_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_64b_fixed_burst_write_read_test.sv"

endpackage : axi4_standalone_slave_test_pkg

`endif
