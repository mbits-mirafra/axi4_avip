`ifndef AXI4LITESLAVEWRITEBASESEQ_INCLUDED_
`define AXI4LITESLAVEWRITEBASESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveWriteBaseSeq 
// creating Axi4LiteSlaveWriteBaseSeq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveWriteBaseSeq extends uvm_sequence #(Axi4LiteSlaveWriteTransaction);

  //factory registration
  `uvm_object_utils(Axi4LiteSlaveWriteBaseSeq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteSlaveWriteBaseSeq");

endclass : Axi4LiteSlaveWriteBaseSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi4_master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function Axi4LiteSlaveWriteBaseSeq::new(string name = "Axi4LiteSlaveWriteBaseSeq");
  super.new(name);
endfunction : new

`endif
