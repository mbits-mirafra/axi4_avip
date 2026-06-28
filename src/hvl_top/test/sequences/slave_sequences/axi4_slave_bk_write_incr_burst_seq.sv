`ifndef AXI4_SLAVE_BK_WRITE_INCR_BURST_SEQ_INCLUDED_
`define AXI4_SLAVE_BK_WRITE_INCR_BURST_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_bk_write_incr_burst_seq
// Extends the axi4_slave_base_seq and randomises the req item
//--------------------------------------------------------------------------------------------
class axi4_slave_bk_write_incr_burst_seq extends axi4_slave_bk_base_seq;
  `uvm_object_utils(axi4_slave_bk_write_incr_burst_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_bk_write_incr_burst_seq");
  extern task body();

endclass : axi4_slave_bk_write_incr_burst_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_slave_bk_write_incr_burst_seq
//  intializes new memory for the object
//--------------------------------------------------------------------------------------------
function axi4_slave_bk_write_incr_burst_seq::new(string name = "axi4_slave_bk_write_incr_burst_seq");
  super.new(name);
endfunction : new

//-------------------------------------------------------
//Task : Body
//Creates the req of type slave transaction and randomises the req.
//-------------------------------------------------------
task axi4_slave_bk_write_incr_burst_seq::body();
  super.body();
  req.transfer_type=BLOCKING_WRITE;

  start_item(req);
  if(!req.randomize())begin
    `uvm_fatal("axi4","Rand failed");
  end
  
  `uvm_info(get_type_name(), $sformatf("slave_seq \n%s",req.sprint()), UVM_NONE); 
  finish_item(req);

endtask :body

`endif

