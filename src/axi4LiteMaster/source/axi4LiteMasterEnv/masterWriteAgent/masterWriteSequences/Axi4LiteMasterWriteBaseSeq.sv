`ifndef AXI4LITEMASTERWRITEBASESEQ_INCLUDED_
`define AXI4LITEMASTERWRITEBASESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteMasterWriteBaseSeq 
// creating Axi4LiteMasterWriteBaseSeq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterWriteBaseSeq extends uvm_sequence #(Axi4LiteMasterWriteTransaction);

  //factory registration
  `uvm_object_utils(Axi4LiteMasterWriteBaseSeq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteMasterWriteBaseSeq");

endclass : Axi4LiteMasterWriteBaseSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi4_master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function Axi4LiteMasterWriteBaseSeq::new(string name = "Axi4LiteMasterWriteBaseSeq");
  super.new(name);
endfunction : new

`endif
