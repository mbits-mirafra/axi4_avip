`ifndef AXI4_VIRTUAL_BACK_TO_BACK_READ_SEQ_INCLUDED_
`define AXI4_VIRTUAL_BACK_TO_BACK_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_back_to_back_read_seq
// Creates and starts the master read and slave read responder sequences
//--------------------------------------------------------------------------------------------
class axi4_virtual_back_to_back_read_seq extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_back_to_back_read_seq)

  //Variable: axi4_master_read_seq_h
  //Instantiation of axi4_master_read_seq handle
  axi4_master_base_seq axi4_master_read_seq_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_back_to_back_read_seq");
  extern task body();
endclass : axi4_virtual_back_to_back_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialises new memory for the object
//
// Parameters:
//  name - axi4_virtual_back_to_back_read_seq
//--------------------------------------------------------------------------------------------
function axi4_virtual_back_to_back_read_seq::new(string name = "axi4_virtual_back_to_back_read_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Runs the slave read responder in the background and drives the master read
//--------------------------------------------------------------------------------------------
task axi4_virtual_back_to_back_read_seq::body();

  super.body();
  axi4_master_read_seq_h = axi4_master_base_seq::type_id::create("axi4_master_read_seq_h");
  axi4_master_read_seq_h.readTranSize     = readTranSize;
  axi4_master_read_seq_h.readTransferType = readTransferType;
  axi4_master_read_seq_h.readBurstType    = readBurstType;
  axi4_master_read_seq_h.writeOrRead      = READ;

  `uvm_info(get_type_name(), $sformatf("Starting BACK-TO-BACK READ | size=%s burst=%s type=%s",
            readTranSize.name(), readBurstType.name(), readTransferType.name()), UVM_LOW)

  //slave read responder keeps running in the background
  fork
    begin : SLAVE_READ_RESP
      axi4_slave_base_seq axi4_slave_read_seq_h;
      forever begin
        axi4_slave_read_seq_h = axi4_slave_base_seq::type_id::create("axi4_slave_read_seq_h");
        axi4_slave_read_seq_h.writeOrRead      = READ;
        axi4_slave_read_seq_h.readTransferType = readTransferType;
        axi4_slave_read_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
      end
    end
  join_none

  //master drives the read stimulus
  fork
    begin : T1_READ
      axi4_master_read_seq_h.start(p_sequencer.axi4_master_read_seqr_h);
    end
  join

endtask : body

`endif
