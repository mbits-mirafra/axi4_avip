`ifndef AXI4_BACK_TO_BACK_VSEQ_PKG_INCLUDED_
`define AXI4_BACK_TO_BACK_VSEQ_PKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: axi4_back_to_back_vseq_pkg
// Description:
// Includes all the back to back virtual sequences run by the master and slave VIP
//-------------------------------------------------------------------------------------------
package axi4_back_to_back_vseq_pkg;

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
  import axi4_globals_pkg::*;

  //-------------------------------------------------------
  // Importing the required virtual sequences
  //-------------------------------------------------------
  import axi4_vseq_base_pkg::*;
  `include "axi4_virtual_back_to_back_write_seq.sv"
  `include "axi4_virtual_back_to_back_read_seq.sv"
  `include "axi4_virtual_back_to_back_write_read_seq.sv"

endpackage : axi4_back_to_back_vseq_pkg

`endif
