`ifndef AXI4_SLAVE_NBK_WRITE_CROSS_SEQ_INCLUDED_
`define AXI4_SLAVE_NBK_WRITE_CROSS_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_nbk_write_cross_seq
// Extends the axi4_slave_base_seq and randomises the req item
//--------------------------------------------------------------------------------------------
class axi4_slave_nbk_write_cross_seq extends axi4_slave_nbk_base_seq;
  `uvm_object_utils(axi4_slave_nbk_write_cross_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_nbk_write_cross_seq");
  extern task body();
endclass : axi4_slave_nbk_write_cross_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi4_slave_nbk_write_cross_seq
//--------------------------------------------------------------------------------------------
function axi4_slave_nbk_write_cross_seq::new(string name = "axi4_slave_nbk_write_cross_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type slave transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi4_slave_nbk_write_cross_seq::body();
  super.body();
begin 
  req.transfer_type = NON_BLOCKING_WRITE;

  start_item(req);
  if(!req.randomize())begin
    `uvm_fatal("axi4","Rand failed");
  end
  `uvm_info("SLAVE_WRITE_NBK_SEQ", $sformatf("slave_seq = \n%s",req.sprint()), UVM_NONE); 
  finish_item(req);

end
endtask : body

`endif

