`ifndef AXI4_TEST_PKG_INCLUDED_
`define AXI4_TEST_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: Test
// Description:
// Includes all the files written to run the simulation
//--------------------------------------------------------------------------------------------
package axi4_test_pkg;

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
  import axi4_virtual_seq_pkg::*;

  //including base_test for testing
  `include "axi4_base_test.sv"
  `include "assertion_base_test.sv"
  `include "axi4_write_test.sv"
  `include "axi4_read_test.sv"
  `include "axi4_write_read_test.sv"
  `include "axi4_non_outstanding_8b_write_data_test.sv"
  `include "axi4_non_outstanding_16b_write_data_test.sv"
  `include "axi4_non_outstanding_32b_write_data_test.sv"
  `include "axi4_non_outstanding_64b_write_data_test.sv"
  `include "axi4_non_outstanding_exokay_response_write_test.sv"
  `include "axi4_non_outstanding_okay_response_write_test.sv"
  `include "axi4_non_outstanding_incr_burst_write_test.sv"
  `include "axi4_non_outstanding_wrap_burst_write_test.sv"
  `include "axi4_32b_ordered_write_read_test.sv"  
  `include "axi4_outstanding_8b_write_data_test.sv"
  `include "axi4_outstanding_16b_write_data_test.sv"
  `include "axi4_outstanding_32b_write_data_test.sv"
  `include "axi4_outstanding_64b_write_data_test.sv"
  `include "axi4_outstanding_exokay_write_response_test.sv"
  `include "axi4_outstanding_okay_write_response_test.sv"
  `include "axi4_outstanding_incr_burst_write_test.sv"
  `include "axi4_outstanding_wrap_burst_write_test.sv"
  `include "axi4_non_outstanding_write_read_test.sv"
  `include "axi4_outstanding_write_read_test.sv"
  `include "axi4_non_outstanding_incr_burst_read_test.sv"
  `include "axi4_non_outstanding_wrap_burst_read_test.sv"
  `include "axi4_non_outstanding_8b_data_read_test.sv"
  `include "axi4_non_outstanding_16b_data_read_test.sv"
  `include "axi4_non_outstanding_32b_data_read_test.sv"
  `include "axi4_non_outstanding_64b_data_read_test.sv"
  `include "axi4_non_outstanding_64b_data_read_test.sv"
  `include "axi4_non_outstanding_okay_response_read_test.sv"
  `include "axi4_non_outstanding_exokay_response_read_test.sv"
  `include "axi4_outstanding_incr_burst_read_test.sv"
  `include "axi4_outstanding_wrap_burst_read_test.sv"
  `include "axi4_outstanding_8b_data_read_test.sv"
  `include "axi4_outstanding_16b_data_read_test.sv"
  `include "axi4_outstanding_32b_data_read_test.sv"
  `include "axi4_outstanding_64b_data_read_test.sv"
  `include "axi4_outstanding_okay_response_read_test.sv"
  `include "axi4_outstanding_exokay_response_read_test.sv"
  
  `include "axi4_non_outstanding_8b_write_read_test.sv"
  `include "axi4_non_outstanding_16b_write_read_test.sv"
  `include "axi4_non_outstanding_32b_write_read_test.sv"
  `include "axi4_non_outstanding_64b_write_read_test.sv"
  `include "axi4_non_outstanding_okay_response_write_read_test.sv"
  `include "axi4_non_outstanding_slave_error_write_read_test.sv"
  `include "axi4_non_outstanding_unaligned_addr_write_read_test.sv"
  `include "axi4_non_outstanding_fixed_burst_write_read_test.sv"
  `include "axi4_non_outstanding_cross_write_read_test.sv"
  
  `include "axi4_outstanding_8b_write_read_test.sv"
  `include "axi4_outstanding_16b_write_read_test.sv"
  `include "axi4_outstanding_32b_write_read_test.sv"
  `include "axi4_outstanding_64b_write_read_test.sv"
  `include "axi4_non_outstanding_incr_burst_write_read_test.sv"
  `include "axi4_outstanding_incr_burst_write_read_test.sv"
  `include "axi4_non_outstanding_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_okay_response_write_read_test.sv"
  `include "axi4_outstanding_fixed_burst_write_read_test.sv"
  `include "axi4_outstanding_unaligned_addr_write_read_test.sv"
  `include "axi4_outstanding_cross_write_read_test.sv"
  `include "axi4_outstanding_slave_error_write_read_test.sv"

  `include "axi4_outstanding_write_read_rand_test.sv"
  `include "axi4_non_outstanding_write_read_rand_test.sv"

  `include "axi4_outstanding_slave_mem_mode_wrap_burst_write_read_test.sv"
  `include "axi4_outstanding_slave_mem_mode_fixed_burst_write_read_test.sv"
  `include "axi4_outstanding_slave_mem_mode_incr_burst_write_read_test.sv"
  

  `include "axi4_outstanding_write_read_response_out_of_order_test.sv"
  `include "axi4_outstanding_only_read_response_out_of_order_test.sv"
  `include "axi4_outstanding_only_write_response_out_of_order_test.sv"

  `include "axi4_outstanding_qos_write_read_test.sv"
endpackage : axi4_test_pkg

`endif
