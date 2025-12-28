`ifndef AXI4_SLAVE_READ_SEQ_INCLUDED_
`define AXI4_SLAVE_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_read_seq
// Extends the axi4_slave_read_seq and randomize the req item
//--------------------------------------------------------------------------------------------
class axi4_slave_read_seq extends axi4_slave_base_seq;
  `uvm_object_utils(axi4_slave_read_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_read_seq");
  extern task body();
endclass : axi4_slave_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_slave_read_seq
//  intializes the memory for the object
//--------------------------------------------------------------------------------------------
function axi4_slave_read_seq::new(string name = "axi4_slave_read_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
//Task : Body
//Creates the req of type slave transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi4_slave_read_seq::body();
  req=axi4_slave_tx::type_id::create("req");

  start_item(req);
  if(!req.randomize()) begin
    `uvm_fatal(get_type_name(),"randomization failed");
  end
  `uvm_info("REQ_READ_DEBUG",$sformatf("read_req = \n %0p",req.sprint()),UVM_HIGH);
  finish_item(req);
endtask : body

`endif

