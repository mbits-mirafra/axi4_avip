`ifndef AXI4_VIRTUAL_SEQ_PKG_INCLUDED_
`define AXI4_VIRTUAL_SEQ_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_virtual_seq_pkg
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
package axi4_virtual_seq_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_master_pkg::*;
  import axi4_slave_pkg::*; 
  import axi4_master_seq_pkg::*; 
  import axi4_slave_seq_pkg::*; 
  import axi4_env_pkg::*; 

  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  `include "axi4_virtual_base_seq.sv"
  `include "axi4_virtual_write_seq.sv"
  `include "axi4_virtual_read_seq.sv"
  `include "axi4_virtual_write_read_seq.sv"
  `include "axi4_virtual_bk_8b_write_data_seq.sv"
  `include "axi4_virtual_bk_16b_write_data_seq.sv"
  `include "axi4_virtual_bk_32b_write_data_seq.sv"
  `include "axi4_virtual_bk_64b_write_data_seq.sv"
  `include "axi4_virtual_bk_exokay_response_write_seq.sv"
  `include "axi4_virtual_bk_okay_response_write_seq.sv"
  `include "axi4_virtual_bk_incr_burst_write_seq.sv"
  `include "axi4_virtual_bk_wrap_burst_write_seq.sv"
  `include "axi4_virtual_nbk_8b_write_data_seq.sv"
  `include "axi4_virtual_nbk_16b_write_data_seq.sv"
  `include "axi4_virtual_nbk_32b_write_data_seq.sv"
  `include "axi4_virtual_nbk_64b_write_data_seq.sv"
  `include "axi4_virtual_nbk_exokay_response_write_seq.sv"
  `include "axi4_virtual_nbk_okay_response_write_seq.sv"
  `include "axi4_virtual_nbk_incr_burst_write_seq.sv"
  `include "axi4_virtual_nbk_wrap_burst_write_seq.sv"
  `include "axi4_virtual_bk_write_read_seq.sv"
  `include "axi4_virtual_nbk_write_read_seq.sv"
  `include "axi4_virtual_bk_incr_burst_read_seq.sv"
  `include "axi4_virtual_bk_wrap_burst_read_seq.sv"
  `include "axi4_virtual_bk_okay_response_read_seq.sv"
  `include "axi4_virtual_bk_exokay_response_read_seq.sv"
  `include "axi4_virtual_bk_8b_data_read_seq.sv"
  `include "axi4_virtual_bk_16b_data_read_seq.sv"
  `include "axi4_virtual_bk_32b_data_read_seq.sv"
  `include "axi4_virtual_bk_64b_data_read_seq.sv"
  `include "axi4_virtual_nbk_incr_burst_read_seq.sv"
  `include "axi4_virtual_nbk_wrap_burst_read_seq.sv"
  `include "axi4_virtual_nbk_8b_data_read_seq.sv"
  `include "axi4_virtual_nbk_16b_data_read_seq.sv"
  `include "axi4_virtual_nbk_32b_data_read_seq.sv"
  `include "axi4_virtual_nbk_64b_data_read_seq.sv"
  `include "axi4_virtual_nbk_okay_response_read_seq.sv"
  `include "axi4_virtual_nbk_exokay_response_read_seq.sv"
  
  `include "axi4_virtual_bk_8b_write_read_seq.sv"
  `include "axi4_virtual_bk_16b_write_read_seq.sv"
  `include "axi4_virtual_bk_32b_write_read_seq.sv"
  `include "axi4_virtual_bk_64b_write_read_seq.sv"
  `include "axi4_virtual_bk_okay_response_write_read_seq.sv"
  `include "axi4_virtual_bk_write_read_rand_seq.sv"
  `include "axi4_virtual_bk_slave_error_write_read_seq.sv"
  `include "axi4_virtual_bk_unaligned_addr_write_read_seq.sv"
  `include "axi4_virtual_bk_fixed_burst_write_read_seq.sv"
  `include "axi4_virtual_bk_outstanding_transfer_write_read_seq.sv"
  `include "axi4_virtual_bk_cross_write_read_seq.sv"
  
  `include "axi4_virtual_nbk_8b_write_read_seq.sv"
  `include "axi4_virtual_nbk_16b_write_read_seq.sv"
  `include "axi4_virtual_nbk_32b_write_read_seq.sv"
  `include "axi4_virtual_nbk_64b_write_read_seq.sv"
  `include "axi4_virtual_bk_incr_burst_write_read_seq.sv"
  `include "axi4_virtual_nbk_incr_burst_write_read_seq.sv"
  `include "axi4_virtual_bk_wrap_burst_write_read_seq.sv"
  `include "axi4_virtual_nbk_wrap_burst_write_read_seq.sv"
  `include "axi4_virtual_nbk_fixed_burst_write_read_seq.sv"
  `include "axi4_virtual_nbk_outstanding_transfer_write_read_seq.sv"
  `include "axi4_virtual_nbk_unaligned_addr_write_read_seq.sv"
  `include "axi4_virtual_nbk_cross_write_read_seq.sv"
  `include "axi4_virtual_nbk_slave_error_write_read_seq.sv"
  
  `include "axi4_virtual_nbk_okay_response_write_read_seq.sv"

  `include "axi4_virtual_nbk_write_read_rand_seq.sv"

  `include "axi4_virtual_nbk_slave_mem_mode_wrap_burst_write_read_seq.sv"
  `include "axi4_virtual_nbk_slave_mem_mode_fixed_burst_write_read_seq.sv"
  `include "axi4_virtual_nbk_slave_mem_mode_incr_burst_write_read_seq.sv"



  `include "axi4_virtual_nbk_only_write_response_out_of_order_seq.sv"
  `include "axi4_virtual_nbk_only_read_response_out_of_order_seq.sv"
  `include "axi4_virtual_nbk_write_read_response_out_of_order_seq.sv"

  `include "axi4_virtual_nbk_qos_write_read_seq.sv"

endpackage : axi4_virtual_seq_pkg

`endif

