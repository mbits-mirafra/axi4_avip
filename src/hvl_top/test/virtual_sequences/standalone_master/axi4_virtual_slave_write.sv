`ifndef AXI4_VIRTUAL_SLAVE_WRITE_SEQ_INCLUDED_
`define AXI4_VIRTUAL_SLAVE_WRITE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_slave_write
// Creates and starts the slave write sequence on the slave write sequencer
//--------------------------------------------------------------------------------------------
class axi4_virtual_slave_write extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_slave_write)

  //Variable: axi4_slave_write_seq_h
  //Instantiation of axi4_slave_base_seq handle used for the write transfers
  axi4_slave_base_seq axi4_slave_write_seq_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_slave_write");
  extern task body();
endclass : axi4_virtual_slave_write

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_virtual_slave_write
//--------------------------------------------------------------------------------------------
function axi4_virtual_slave_write::new(string name = "axi4_virtual_slave_write");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Creates and starts the slave write sequence
//--------------------------------------------------------------------------------------------
task axi4_virtual_slave_write::body();
  super.body();
  axi4_slave_write_seq_h = axi4_slave_base_seq::type_id::create("axi4_slave_write_seq_h");

  axi4_slave_write_seq_h.writeTransferType = writeTransferType;
  axi4_slave_write_seq_h.writeOrRead       = WRITE;
  `uvm_info(get_type_name(), $sformatf("Starting SLAVE WRITE virtual sequence | type=%s",
            writeTransferType.name()), UVM_LOW)

  axi4_slave_write_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
endtask : body

`endif
