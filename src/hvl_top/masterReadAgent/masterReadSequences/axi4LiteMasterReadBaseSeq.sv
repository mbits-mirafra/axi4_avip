`ifndef AXI4LITEMASTERREADBASESEQ_INCLUDED_
`define AXI4LITEMASTERREADBASESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteMasterReadBaseSeq 
// creating Axi4LiteMasterReadBaseSeq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterReadBaseSeq extends uvm_sequence #(Axi4LiteMasterReadTransaction);

  //factory registration
  `uvm_object_utils(Axi4LiteMasterReadBaseSeq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteMasterReadBaseSeq");

endclass : Axi4LiteMasterReadBaseSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi4_master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function Axi4LiteMasterReadBaseSeq::new(string name = "Axi4LiteMasterReadBaseSeq");
  super.new(name);
endfunction : new

`endif
