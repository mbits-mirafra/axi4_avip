`ifndef AXI4_VIRTUAL_READ_SEQ_INCLUDED_
`define AXI4_VIRTUAL_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_read_seq
// Creates and starts the master and slave sequences
//--------------------------------------------------------------------------------------------
class axi4_virtual_read_seq extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_read_seq)

  //Variable: axi4_master_bk_read_seq_h
  //Instantiation of axi4_master_bk_read_seq handle
  axi4_master_bk_read_seq axi4_master_bk_read_seq_h;
  //Variable: axi4_master_nbk_read_seq_h
  //Instantiation of axi4_master_nbk_read_seq handle
  axi4_master_nbk_read_seq axi4_master_nbk_read_seq_h;

  //Variable: axi4_slave_read_seq_h
  //Instantiation of axi4_slave_read_seq handle
  axi4_slave_bk_read_seq axi4_slave_bk_read_seq_h;
  //Variable: axi4_slave_nbk_read_seq_h
  //Instantiation of axi4_slave_nbk_read_seq handle
  axi4_slave_nbk_read_seq axi4_slave_nbk_read_seq_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_read_seq");
  extern task body();
endclass : axi4_virtual_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialises new memory for the object
//
// Parameters:
//  name - axi4_virtual_read_seq
//--------------------------------------------------------------------------------------------
function axi4_virtual_read_seq::new(string name = "axi4_virtual_read_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Creates and starts the data of master and slave sequences
//--------------------------------------------------------------------------------------------
task axi4_virtual_read_seq::body();
  axi4_master_bk_read_seq_h = axi4_master_bk_read_seq::type_id::create("axi4_master_bk_read_seq_h");
  axi4_master_nbk_read_seq_h = axi4_master_nbk_read_seq::type_id::create("axi4_master_nbk_read_seq_h");
  axi4_slave_bk_read_seq_h = axi4_slave_bk_read_seq::type_id::create("axi4_slave_bk_read_seq_h");
  axi4_slave_nbk_read_seq_h = axi4_slave_nbk_read_seq::type_id::create("axi4_slave_nbk_read_seq_h");
   fork
    forever begin
      axi4_slave_bk_read_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
      axi4_slave_nbk_read_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
    end
  join_none

  repeat(5) begin
    axi4_master_bk_read_seq_h.start(p_sequencer.axi4_master_read_seqr_h);
    axi4_master_nbk_read_seq_h.start(p_sequencer.axi4_master_read_seqr_h);
  end
 endtask : body

`endif

