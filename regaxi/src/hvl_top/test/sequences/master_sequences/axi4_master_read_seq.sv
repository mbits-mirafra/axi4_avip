`ifndef AXI4_MASTER_READ_SEQ_INCLUDED_
`define AXI4_MASTER_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_master_read_seq
// Extends the axi4_master_base_seq and randomises the req item
//--------------------------------------------------------------------------------------------
class axi4_master_read_seq extends axi4_master_base_seq;
  `uvm_object_utils(axi4_master_read_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_read_seq");
  extern task body();
endclass : axi4_master_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi4_master_read_seq
//--------------------------------------------------------------------------------------------
function axi4_master_read_seq::new(string name = "axi4_master_read_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type master transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi4_master_read_seq::body();
  req = axi4_master_tx::type_id::create("req");
  
  start_item(req);
  if(!req.randomize() with {req.arsize == READ_4_BYTES;
                            req.tx_type == READ;
                            req.arburst == READ_FIXED;}) begin
    `uvm_fatal("axi4","Rand failed");
  end
  req.print();
  finish_item(req);

endtask : body

`endif

