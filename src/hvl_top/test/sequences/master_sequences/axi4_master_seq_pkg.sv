`ifndef AXI4_MASTER_SEQ_PKG_INCLUDED_
`define AXI4_MASTER_SEQ_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_master_seq_pkg
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
package axi4_master_seq_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_master_pkg::*;
  import axi4_globals_pkg::*;

  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  `include "axi4_master_base_seq.sv"

endpackage : axi4_master_seq_pkg

`endif

