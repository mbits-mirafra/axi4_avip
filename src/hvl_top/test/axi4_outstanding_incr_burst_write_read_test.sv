`ifndef AXI4_OUTSTANDING_INCR_BURST_WRITE_READ_TEST_INCLUDED_
`define AXI4_OUTSTANDING_INCR_BURST_WRITE_READ_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_outstanding_incr_burst_write_read_test
// Extends the base test and starts the virtual sequence of incr burst write and read sequences
//--------------------------------------------------------------------------------------------
class axi4_outstanding_incr_burst_write_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_outstanding_incr_burst_write_read_test)

  //Variable : axi4_virtual_nbk_incr_burst_write_read_seq_h
  //Instatiation of axi4_virtual_nbk_incr_burst_write_read_seq
  axi4_virtual_nbk_incr_burst_write_read_seq axi4_virtual_nbk_incr_burst_write_read_seq_h;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_outstanding_incr_burst_write_read_test", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
endclass : axi4_outstanding_incr_burst_write_read_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_outstanding_incr_burst_write_read_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_outstanding_incr_burst_write_read_test::new(string name = "axi4_outstanding_incr_burst_write_read_test",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void axi4_outstanding_incr_burst_write_read_test :: build_phase(uvm_phase phase);
 super.build_phase(phase);
 axi4_env_cfg_h.axi4_slave_agent_cfg_h[0].slave_response_mode = WRITE_READ_RESP_OUT_OF_ORDER;
endfunction


//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates the axi4_virtual_incr_burst_write_seq sequence and starts the write and read virtual sequences
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task axi4_outstanding_incr_burst_write_read_test::run_phase(uvm_phase phase);

  axi4_virtual_nbk_incr_burst_write_read_seq_h=axi4_virtual_nbk_incr_burst_write_read_seq::type_id::create("axi4_virtual_nbk_incr_burst_write_read_seq_h");
  `uvm_info(get_type_name(),$sformatf("axi4_outstanding_incr_burst_write_read_test"),UVM_LOW);
  phase.raise_objection(this);
  axi4_virtual_nbk_incr_burst_write_read_seq_h.start(axi4_env_h.axi4_virtual_seqr_h);
  phase.drop_objection(this);

endtask : run_phase

`endif

