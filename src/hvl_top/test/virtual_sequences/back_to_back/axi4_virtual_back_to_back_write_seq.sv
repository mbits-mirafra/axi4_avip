`ifndef AXI4_VIRTUAL_BACK_TO_BACK_WRITE_SEQ_INCLUDED_
`define AXI4_VIRTUAL_BACK_TO_BACK_WRITE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_back_to_back_write_seq
// Creates and starts the master write and slave write responder sequences
//--------------------------------------------------------------------------------------------
class axi4_virtual_back_to_back_write_seq extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_back_to_back_write_seq)

  //Variable: axi4_master_write_seq_h
  //Instantiation of axi4_master_write_seq handle
  axi4_master_base_seq axi4_master_write_seq_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_back_to_back_write_seq");
  extern task body();
endclass : axi4_virtual_back_to_back_write_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialises new memory for the object
//
// Parameters:
//  name - axi4_virtual_back_to_back_write_seq
//--------------------------------------------------------------------------------------------
function axi4_virtual_back_to_back_write_seq::new(string name = "axi4_virtual_back_to_back_write_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Runs the slave write responder in the background and drives the master write
//--------------------------------------------------------------------------------------------
task axi4_virtual_back_to_back_write_seq::body();
 
  super.body();
  axi4_master_write_seq_h = axi4_master_base_seq::type_id::create("axi4_master_write_seq_h");
  axi4_master_write_seq_h.writeTranSize     = writeTranSize;
  axi4_master_write_seq_h.writeTransferType = writeTransferType;
  axi4_master_write_seq_h.writeBurstType    = writeBurstType;
  axi4_master_write_seq_h.writeOrRead       = WRITE;

  `uvm_info(get_type_name(), $sformatf("Starting BACK-TO-BACK WRITE | size=%s burst=%s type=%s",
            writeTranSize.name(), writeBurstType.name(), writeTransferType.name()), UVM_LOW)

  //slave write responder keeps running in the background
  fork
    begin : SLAVE_WRITE_RESP
      axi4_slave_base_seq axi4_slave_write_seq_h;
      forever begin
        axi4_slave_write_seq_h = axi4_slave_base_seq::type_id::create("axi4_slave_write_seq_h");
        axi4_slave_write_seq_h.writeOrRead       = WRITE;
        axi4_slave_write_seq_h.writeTransferType = writeTransferType;
        axi4_slave_write_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
      end
    end
  join_none

  //master drives the write stimulus
  fork
    begin : T1_WRITE
      axi4_master_write_seq_h.start(p_sequencer.axi4_master_write_seqr_h);
    end
  join

endtask : body

`endif
