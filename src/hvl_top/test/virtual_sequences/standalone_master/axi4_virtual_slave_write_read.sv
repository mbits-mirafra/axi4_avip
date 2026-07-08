`ifndef AXI4_VIRTUAL_SLAVE_WRITE_READ_SEQ_INCLUDED_
`define AXI4_VIRTUAL_SLAVE_WRITE_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_slave_write_read
// Creates and starts the slave write and read sequences in parallel
//--------------------------------------------------------------------------------------------
class axi4_virtual_slave_write_read extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_slave_write_read)

  //Variable: axi4_slave_write_seq_h
  //Instantiation of axi4_slave_base_seq handle used for the write transfers
  axi4_slave_base_seq axi4_slave_write_seq_h;

  //Variable: axi4_slave_read_seq_h
  //Instantiation of axi4_slave_base_seq handle used for the read transfers
  axi4_slave_base_seq axi4_slave_read_seq_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_slave_write_read");
  extern task body();
endclass : axi4_virtual_slave_write_read

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_virtual_slave_write_read
//--------------------------------------------------------------------------------------------
function axi4_virtual_slave_write_read::new(string name = "axi4_virtual_slave_write_read");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Creates and starts the slave write and read sequences concurrently
//--------------------------------------------------------------------------------------------
task axi4_virtual_slave_write_read::body();
  super.body();
  axi4_slave_write_seq_h = axi4_slave_base_seq::type_id::create("axi4_slave_write_seq_h");
  axi4_slave_read_seq_h  = axi4_slave_base_seq::type_id::create("axi4_slave_read_seq_h");

  axi4_slave_write_seq_h.writeTransferType = writeTransferType;
  axi4_slave_write_seq_h.writeOrRead       = WRITE;

  axi4_slave_read_seq_h.readTransferType   = readTransferType;
  axi4_slave_read_seq_h.writeOrRead        = READ;

  `uvm_info(get_type_name(), $sformatf("Starting SLAVE WRITE_READ virtual sequence | wtype=%s rtype=%s",
            writeTransferType.name(), readTransferType.name()), UVM_LOW)

  fork
    axi4_slave_write_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
    axi4_slave_read_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
  join
endtask : body

`endif
