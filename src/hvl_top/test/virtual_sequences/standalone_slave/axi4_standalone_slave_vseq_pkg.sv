`ifndef AXI4_STANDALONE_SLAVE_VSEQ_PKG_INCLUDED_
`define AXI4_STANDALONE_SLAVE_VSEQ_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_virtual_seq_pkg
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
package axi4_standalone_slave_vseq_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_master_pkg::*;
  import axi4_slave_pkg::*; 
  import axi4_master_seq_pkg::*; 
  import axi4_env_pkg::*; 
  import axi4_globals_pkg::*;
  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  import axi4_vseq_base_pkg::*;
  `include "axi4_virtual_write_followed_by_read_seq.sv"
  `include "axi4_virtual_write_seq.sv"
  `include "axi4_virtual_read_seq.sv"
  `include "axi4_virtual_write_read_seq.sv"

endpackage : axi4_standalone_slave_vseq_pkg

`endif

