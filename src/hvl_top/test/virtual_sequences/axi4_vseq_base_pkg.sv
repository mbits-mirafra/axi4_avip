`ifndef AXI4_VSEQ_BASE_PKG_INCLUDED_
`define AXI4_VSEQ_BASE_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_vseq_base_pkg
// Description:
// Holds the common virtual base sequence so it is compiled once and shared by all the
// virtual sequence packages
//-------------------------------------------------------------------------------------------
package axi4_vseq_base_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import axi4_master_pkg::*;
  import axi4_slave_pkg::*;
  import axi4_env_pkg::*;

  //-------------------------------------------------------
  // Importing the virtual base sequence
  //-------------------------------------------------------
  `include "axi4_virtual_base_seq.sv"

endpackage : axi4_vseq_base_pkg

`endif
