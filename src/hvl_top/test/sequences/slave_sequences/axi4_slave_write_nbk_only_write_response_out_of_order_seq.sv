`ifndef AXI4_SLAVE_WRITE_NBK_ONLY_WRITE_RESPONSE_OUT_OF_ORDER_SEQ_INCLUDED_
`define AXI4_SLAVE_WRITE_NBK_ONLY_WRITE_RESPONSE_OUT_OF_ORDER_SEQ_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: axi4_slave_write_nbk_only_write_response_out_of_order_seq
// Extends the axi4_slave_base_seq and randomises the req item
//--------------------------------------------------------------------------------------------

class axi4_slave_write_nbk_only_write_response_out_of_order_seq extends axi4_slave_nbk_base_seq;
  `uvm_object_utils(axi4_slave_write_nbk_only_write_response_out_of_order_seq)


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_write_nbk_only_write_response_out_of_order_seq");
  extern task body();
endclass : axi4_slave_write_nbk_only_write_response_out_of_order_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi4_slave_write_nbk_only_write_response_out_of_order_seq
//--------------------------------------------------------------------------------------------
function axi4_slave_write_nbk_only_write_response_out_of_order_seq::new(string name = "axi4_slave_write_nbk_only_write_response_out_of_order_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type slave transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi4_slave_write_nbk_only_write_response_out_of_order_seq::body();
  super.body();
  req.transfer_type = NON_BLOCKING_WRITE;

  start_item(req);
  if(!req.randomize())begin
    `uvm_fatal("axi4","Rand failed");
  end
  `uvm_info("SLAVE_WRITE_NBK_SEQ", $sformatf("slave_seq = \n%s",req.sprint()), UVM_NONE); 
  finish_item(req);

endtask : body

`endif

