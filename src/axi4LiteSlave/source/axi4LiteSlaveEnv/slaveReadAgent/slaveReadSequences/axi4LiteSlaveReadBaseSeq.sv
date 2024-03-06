`ifndef AXI4LITESLAVEREADBASESEQ_INCLUDED_
`define AXI4LITESLAVEREADBASESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveReadBaseSeq 
// creating Axi4LiteSlaveReadBaseSeq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveReadBaseSeq extends uvm_sequence #(Axi4LiteSlaveReadTransaction);

  //factory registration
  `uvm_object_utils(Axi4LiteSlaveReadBaseSeq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteSlaveReadBaseSeq");

endclass : Axi4LiteSlaveReadBaseSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi4_master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function Axi4LiteSlaveReadBaseSeq::new(string name = "Axi4LiteSlaveReadBaseSeq");
  super.new(name);
endfunction : new

`endif
