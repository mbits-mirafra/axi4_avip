`ifndef AXI4_SLAVE_BK_WRITE_UNALIGNED_ADDR_SEQ_INCLUDED_
`define AXI4_SLAVE_BK_WRITE_UNALIGNED_ADDR_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_bk_write_unaligned_addr_seq
// Extends the axi4_slave_base_seq and randomises the req item
//--------------------------------------------------------------------------------------------
class axi4_slave_bk_write_unaligned_addr_seq extends axi4_slave_bk_base_seq;
  `uvm_object_utils(axi4_slave_bk_write_unaligned_addr_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_bk_write_unaligned_addr_seq");
  extern task body();
endclass : axi4_slave_bk_write_unaligned_addr_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi4_slave_bk_write_unaligned_addr_seq
//--------------------------------------------------------------------------------------------
function axi4_slave_bk_write_unaligned_addr_seq::new(string name = "axi4_slave_bk_write_unaligned_addr_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type slave transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi4_slave_bk_write_unaligned_addr_seq::body();
  super.body();
  req.transfer_type = BLOCKING_WRITE;

  start_item(req);
  if(!req.randomize())begin
    `uvm_fatal("axi4","Rand failed");
  end
  `uvm_info("SLAVE_WRITE_bk_SEQ", $sformatf("slave_seq = \n%s",req.sprint()), UVM_NONE); 
  finish_item(req);

endtask : body

`endif

