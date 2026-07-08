`ifndef AXI4_VIRTUAL_WRITE_FOLLOWED_BY_READ_SEQ_INCLUDED_
`define AXI4_VIRTUAL_WRITE_FOLLOWED_BY_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_write_followed_by_read_seq
// Creates and starts the master and slave sequences
//--------------------------------------------------------------------------------------------
class axi4_virtual_write_followed_by_read_seq extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_write_followed_by_read_seq)
   
  //Variable: axi4_master seq
  //Instantiation of axi4_master seq handles
  axi4_master_base_seq axi4_master_write_seq_h;

  //Variable: axi4_slave seq's
  //Instantiation of axi4_slave seq handles
  axi4_master_base_seq axi4_master_read_seq_h;

    
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_write_followed_by_read_seq");
  extern task body();
endclass : axi4_virtual_write_followed_by_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialises new memory for the object
//
// Parameters:
//  name - axi4_virtual_write_followed_by_read_seq
//--------------------------------------------------------------------------------------------
function axi4_virtual_write_followed_by_read_seq::new(string name = "axi4_virtual_write_followed_by_read_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Creates and starts the data of master and slave sequences
//--------------------------------------------------------------------------------------------
task axi4_virtual_write_followed_by_read_seq::body();
  
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Insdie axi4_virtual_write_followed_by_read_seq"), UVM_NONE); 


  axi4_master_write_seq_h  = axi4_master_base_seq::type_id::create("axi4_master_bk_write_seq_h");
  axi4_master_read_seq_h   = axi4_master_base_seq::type_id::create("axi4_slave_bk_read_seq_h");

  axi4_master_write_seq_h.writeTranSize = writeTranSize;
  axi4_master_write_seq_h.writeTransferType = writeTransferType;
  axi4_master_write_seq_h.writeBurstType = writeBurstType;
  axi4_master_write_seq_h.writeOrRead  = WRITE; 
 
  axi4_master_read_seq_h.readTranSize = readTranSize;
  axi4_master_read_seq_h.readTransferType = readTransferType;
  axi4_master_read_seq_h.readBurstType = readBurstType;
  axi4_master_read_seq_h.writeOrRead  = READ; 

   begin 
      repeat(2) begin
        axi4_master_write_seq_h.start(p_sequencer.axi4_master_write_seqr_h);
        axi4_master_read_seq_h.start(p_sequencer.axi4_master_read_seqr_h);
      end
    end
 endtask : body

`endif

