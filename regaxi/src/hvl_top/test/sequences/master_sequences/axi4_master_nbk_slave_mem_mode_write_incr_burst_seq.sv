`ifndef AXI4_MASTER_NBK_SLAVE_MEM_MODE_WRITE_INCR_BURST_SEQ_INCLUDED_
`define AXI4_MASTER_NBK_SLAVE_MEM_MODE_WRITE_INCR_BURST_SEQ_INCLUDED_ 
//--------------------------------------------------------------------------------------------
// Class: axi4_master_nbk_slave_mem_mode_write_incr_burst_seq
// Extends the axi4_master_nbk_base_seq and randomises the req item
//--------------------------------------------------------------------------------------------
class axi4_master_nbk_slave_mem_mode_write_incr_burst_seq extends axi4_master_nbk_base_seq;
  `uvm_object_utils(axi4_master_nbk_slave_mem_mode_write_incr_burst_seq)
  `uvm_declare_p_sequencer(axi4_master_write_sequencer)

  int min_addr,max_addr;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_nbk_slave_mem_mode_write_incr_burst_seq");
  extern task body();
endclass : axi4_master_nbk_slave_mem_mode_write_incr_burst_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi4_master_nbk_slave_mem_mode_write_incr_burst_seq
//--------------------------------------------------------------------------------------------
function axi4_master_nbk_slave_mem_mode_write_incr_burst_seq::new(string name = "axi4_master_nbk_slave_mem_mode_write_incr_burst_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type master_nbk transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi4_master_nbk_slave_mem_mode_write_incr_burst_seq::body();
  super.body();
  if(!$cast(p_sequencer,m_sequencer))begin
    `uvm_error(get_full_name(),"tx_agent_config pointer cast failed")
  end

  min_addr = p_sequencer.axi4_master_agent_cfg_h.master_min_addr_range_array[0];
  max_addr = p_sequencer.axi4_master_agent_cfg_h.master_max_addr_range_array[0];
  
  start_item(req);
  if(!req.randomize() with {
                            req.awaddr inside {[min_addr:max_addr]};
                            req.tx_type == WRITE;
                            req.awburst == WRITE_INCR;
                            req.transfer_type == NON_BLOCKING_WRITE;}) begin

    `uvm_fatal("axi4","Rand failed");
  end
  req.print();
  finish_item(req);

endtask : body

`endif


