`ifndef AXI4_VIRTUAL_NBK_OKAY_RESPONSE_WRITE_SEQ_INCLUDED_
`define AXI4_VIRTUAL_NBK_OKAY_RESPONSE_WRITE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_nbk_okay_response_write_seq
// Creates and starts the master and slave sequences
//--------------------------------------------------------------------------------------------
class axi4_virtual_nbk_okay_response_write_seq extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_nbk_okay_response_write_seq)

  //Variable: axi4_master_write_okay_resp_seq_h
  //Instantiation of axi4_master_write_okay_resp_seq handle
  axi4_master_nbk_write_okay_resp_seq axi4_master_nbk_write_okay_resp_seq_h;

  //Variable: axi4_slave_write_okay_resp_seq_h
  //Instantiation of axi4_slave_write_okay_resp_seq handle
  axi4_slave_nbk_write_okay_resp_seq axi4_slave_nbk_write_okay_resp_seq_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_nbk_okay_response_write_seq");
  extern task body();
endclass : axi4_virtual_nbk_okay_response_write_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialises new memory for the object
//
// Parameters:
//  name - axi4_virtual_nbk_okay_response_write_seq
//--------------------------------------------------------------------------------------------
function axi4_virtual_nbk_okay_response_write_seq::new(string name = "axi4_virtual_nbk_okay_response_write_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Creates and starts the data of master and slave sequences
//--------------------------------------------------------------------------------------------
task axi4_virtual_nbk_okay_response_write_seq::body();
  axi4_master_nbk_write_okay_resp_seq_h = axi4_master_nbk_write_okay_resp_seq::type_id::create("axi4_master_nbk_write_okay_resp_seq_h");

  axi4_slave_nbk_write_okay_resp_seq_h = axi4_slave_nbk_write_okay_resp_seq::type_id::create("axi4_slave_nbk_write_okay_resp_seq_h");

  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Insdie axi4_virtual_nbk_okay_response_write_seq"), UVM_NONE); 

  fork 
    begin : T1_SL_WR
      forever begin
        axi4_slave_nbk_write_okay_resp_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
      end
    end
  join_none


  fork 
    begin: T1_WRITE
      repeat(2) begin
          axi4_master_nbk_write_okay_resp_seq_h.start(p_sequencer.axi4_master_write_seqr_h);
      end
    end
  join
 endtask : body

`endif

