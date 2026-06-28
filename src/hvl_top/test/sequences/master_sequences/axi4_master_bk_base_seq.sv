`ifndef AXI4_MASTER_BK_BASE_SEQ_INCLUDED_
`define AXI4_MASTER_BK_BASE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_master_bk_base_seq 
// creating axi4_master_bk_base_seq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class axi4_master_bk_base_seq extends uvm_sequence #(axi4_master_tx);

  //factory registration
  `uvm_object_utils(axi4_master_bk_base_seq)
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_bk_base_seq");
  extern task body();
endclass : axi4_master_bk_base_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi4_master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function axi4_master_bk_base_seq::new(string name = "axi4_master_bk_base_seq");
  super.new(name);
endfunction : new

//-----------------------------------------------------------------------------
// Task: body
// based on the request from driver task will drive the transactions
//-----------------------------------------------------------------------------
task axi4_master_bk_base_seq::body();
  req = axi4_master_tx::type_id::create("req");
  
  req.transfer_type=BLOCKING_WRITE;
  req.transfer_type=BLOCKING_READ;
  

endtask : body

`endif
