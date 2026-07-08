`ifndef AXI4_VIRTUAL_BACK_TO_BACK_WRITE_READ_SEQ_INCLUDED_
`define AXI4_VIRTUAL_BACK_TO_BACK_WRITE_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_back_to_back_write_read_seq
// Creates and starts the master write/read and slave responder sequences
//--------------------------------------------------------------------------------------------
class axi4_virtual_back_to_back_write_read_seq extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_back_to_back_write_read_seq)

  //Variable: axi4_master_write_seq_h
  //Instantiation of axi4_master_write_seq handle
  axi4_master_base_seq axi4_master_write_seq_h;

  //Variable: axi4_master_read_seq_h
  //Instantiation of axi4_master_read_seq handle
  axi4_master_base_seq axi4_master_read_seq_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_back_to_back_write_read_seq");
  extern task body();
endclass : axi4_virtual_back_to_back_write_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialises new memory for the object
//
// Parameters:
//  name - axi4_virtual_back_to_back_write_read_seq
//--------------------------------------------------------------------------------------------
function axi4_virtual_back_to_back_write_read_seq::new(string name = "axi4_virtual_back_to_back_write_read_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Runs the slave responders in the background and drives master write and read in parallel
//--------------------------------------------------------------------------------------------
task axi4_virtual_back_to_back_write_read_seq::body();
  super.body();
  axi4_master_write_seq_h = axi4_master_base_seq::type_id::create("axi4_master_write_seq_h");
  axi4_master_read_seq_h  = axi4_master_base_seq::type_id::create("axi4_master_read_seq_h");

  axi4_master_write_seq_h.writeTranSize     = writeTranSize;
  axi4_master_write_seq_h.writeTransferType = writeTransferType;
  axi4_master_write_seq_h.writeBurstType    = writeBurstType;
  axi4_master_write_seq_h.writeOrRead       = WRITE;

  axi4_master_read_seq_h.readTranSize     = readTranSize;
  axi4_master_read_seq_h.readTransferType = readTransferType;
  axi4_master_read_seq_h.readBurstType    = readBurstType;
  axi4_master_read_seq_h.writeOrRead      = READ;

  `uvm_info(get_type_name(), $sformatf("Starting BACK-TO-BACK WRITE+READ | wr_size=%s rd_size=%s wr_burst=%s rd_burst=%s",
            writeTranSize.name(), readTranSize.name(), writeBurstType.name(), readBurstType.name()), UVM_LOW)

  //slave write and read responders keep running in the background
  fork
    begin : SLAVE_WRITE_RESP
      axi4_slave_base_seq axi4_slave_write_seq_h;
        axi4_slave_write_seq_h = axi4_slave_base_seq::type_id::create("axi4_slave_write_seq_h");
        axi4_slave_write_seq_h.writeOrRead       = WRITE;
        axi4_slave_write_seq_h.writeTransferType = writeTransferType;
        axi4_slave_write_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
    end
    begin : SLAVE_READ_RESP
      axi4_slave_base_seq axi4_slave_read_seq_h;
        axi4_slave_read_seq_h = axi4_slave_base_seq::type_id::create("axi4_slave_read_seq_h");
        axi4_slave_read_seq_h.writeOrRead      = READ;
        axi4_slave_read_seq_h.readTransferType = readTransferType;
        axi4_slave_read_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
    end
  join_none

  //master drives the write and read stimulus
//  fork
    //begin : T1_WRITE
      axi4_master_write_seq_h.start(p_sequencer.axi4_master_write_seqr_h);
    //end
    //begin : T2_READ
      axi4_master_read_seq_h.start(p_sequencer.axi4_master_read_seqr_h);
    //end
  //join //parallel write read may cause data hazard

endtask : body

`endif
