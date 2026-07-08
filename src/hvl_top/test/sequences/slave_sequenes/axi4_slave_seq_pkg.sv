`ifndef AXI4_SLAVE_SEQ_PKG_INCLUDED_
`define AXI4_SLAVE_SEQ_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_slave_seq_pkg
// Description:
// Includes the slave (response) sequences used by the slave virtual sequences
//-------------------------------------------------------------------------------------------
package axi4_slave_seq_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_slave_pkg::*;
  import axi4_globals_pkg::*;

  //-------------------------------------------------------
  // Importing the required sequences
  //-------------------------------------------------------
  `include "axi4_slave_base_seq.sv"

endpackage : axi4_slave_seq_pkg

`endif
