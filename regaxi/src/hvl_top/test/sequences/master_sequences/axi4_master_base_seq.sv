`ifndef AXI4_MASTER_BASE_SEQ_INCLUDED_
`define AXI4_MASTER_BASE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_master_base_seq 
// creating axi4_master_base_seq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class axi4_master_base_seq extends uvm_sequence #(axi4_master_tx);

  //factory registration
  `uvm_object_utils(axi4_master_base_seq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_base_seq");

endclass : axi4_master_base_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi4_master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function axi4_master_base_seq::new(string name = "axi4_master_base_seq");
  super.new(name);
endfunction : new

`endif
