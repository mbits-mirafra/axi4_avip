`ifndef AXI4_VIRTUAL_WRITE_READ_SEQ_INCLUDED_
`define AXI4_VIRTUAL_WRITE_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_virtual_write_read_seq
// Creates and starts the master and slave sequences
//--------------------------------------------------------------------------------------------
class axi4_virtual_write_read_seq extends axi4_virtual_base_seq;
  `uvm_object_utils(axi4_virtual_write_read_seq)

  //Variable: axi4_master seq
  //Instantiation of axi4_master seq handles
  axi4_master_bk_write_seq axi4_master_bk_write_seq_h;
  axi4_master_nbk_write_seq axi4_master_nbk_write_seq_h;
  axi4_master_bk_read_seq axi4_master_bk_read_seq_h;
  axi4_master_nbk_read_seq axi4_master_nbk_read_seq_h;

  //Variable: axi4_slave seq's
  //Instantiation of axi4_slave seq handles
  axi4_slave_bk_write_seq axi4_slave_bk_write_seq_h;
  axi4_slave_nbk_write_seq axi4_slave_nbk_write_seq_h;
  axi4_slave_bk_read_seq axi4_slave_bk_read_seq_h;
  axi4_slave_nbk_read_seq axi4_slave_nbk_read_seq_h;

  process blocking_master_wr_seq;
  process blocking_master_rd_seq;
  process blocking_slave_wr_seq;
  process blocking_slave_rd_seq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_virtual_write_read_seq");
  extern task body();
endclass : axi4_virtual_write_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialises new memory for the object
//
// Parameters:
//  name - axi4_virtual_write_read_seq
//--------------------------------------------------------------------------------------------
function axi4_virtual_write_read_seq::new(string name = "axi4_virtual_write_read_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task - body
// Creates and starts the data of master and slave sequences
//--------------------------------------------------------------------------------------------
task axi4_virtual_write_read_seq::body();
  axi4_master_bk_write_seq_h  = axi4_master_bk_write_seq::type_id::create("axi4_master_bk_write_seq_h");
  axi4_master_nbk_write_seq_h = axi4_master_nbk_write_seq::type_id::create("axi4_master_nbk_write_seq_h");
  axi4_master_bk_read_seq_h   = axi4_master_bk_read_seq::type_id::create("axi4_master_bk_read_seq_h");
  axi4_master_nbk_read_seq_h  = axi4_master_nbk_read_seq::type_id::create("axi4_master_nbk_read_seq_h");

  axi4_slave_bk_write_seq_h  = axi4_slave_bk_write_seq::type_id::create("axi4_slave_bk_write_seq_h");
  axi4_slave_nbk_write_seq_h = axi4_slave_nbk_write_seq::type_id::create("axi4_slave_nbk_write_seq_h");
  axi4_slave_bk_read_seq_h   = axi4_slave_bk_read_seq::type_id::create("axi4_slave_bk_read_seq_h");
  axi4_slave_nbk_read_seq_h  = axi4_slave_nbk_read_seq::type_id::create("axi4_slave_nbk_read_seq_h");

  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Insdie axi4_virtual_write_read_seq"), UVM_NONE); 

  fork 
    begin : T1_BK_SL_WR
      forever begin
        blocking_slave_wr_seq = process::self();
        axi4_slave_bk_write_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
      end
    end
    begin : T2_BK_SL_RD
      forever begin
        blocking_slave_rd_seq = process::self();
        axi4_slave_bk_read_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
      end
    end
    begin : T1_NBK_SL_WR
      forever begin
        blocking_slave_wr_seq.await();
        axi4_slave_nbk_write_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
      end
    end
    begin : T2_NBK_SL_RD
      forever begin
        blocking_slave_rd_seq.await();
        axi4_slave_nbk_read_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
      end
    end
  join_none


  fork 
    begin: T1_BK_WRITE
      blocking_master_wr_seq = process::self();
      repeat(5) begin
        axi4_master_bk_write_seq_h.start(p_sequencer.axi4_master_write_seqr_h);
      end
    end
    begin: T2_BK_READ
      blocking_master_rd_seq = process::self();
      repeat(3) begin
        axi4_master_bk_read_seq_h.start(p_sequencer.axi4_master_read_seqr_h);
      end
    end
    begin: T1_NBK_WRITE
      repeat(5) begin
        blocking_master_wr_seq.await();
        axi4_master_nbk_write_seq_h.start(p_sequencer.axi4_master_write_seqr_h);
      end
    end
    begin: T2_NBK_READ
      repeat(3) begin
        blocking_master_rd_seq.await();
        axi4_master_nbk_read_seq_h.start(p_sequencer.axi4_master_read_seqr_h);
      end
    end
  join
 endtask : body

`endif

