`ifndef AXI4_OUTSTANDING_SLAVE_WRITE_TEST_INCLUDED_
`define AXI4_OUTSTANDING_SLAVE_WRITE_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_outstanding_slave_write_test
// Extends the base test and starts the outstanding slave write virtual sequence
//--------------------------------------------------------------------------------------------
class axi4_outstanding_slave_write_test extends axi4_base_test;
  `uvm_component_utils(axi4_outstanding_slave_write_test)

  //Variable: axi4_virtual_slave_write_h
  //Instantiation of the slave write virtual sequence
  axi4_virtual_slave_write axi4_virtual_slave_write_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_outstanding_slave_write_test", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);

endclass : axi4_outstanding_slave_write_test

//--------------------------------------------------------------------------------------------
// Construct: new
//--------------------------------------------------------------------------------------------
function axi4_outstanding_slave_write_test::new(string name = "axi4_outstanding_slave_write_test",
                                                uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates and starts the outstanding slave write virtual sequence
//--------------------------------------------------------------------------------------------
task axi4_outstanding_slave_write_test::run_phase(uvm_phase phase);
  axi4_virtual_slave_write_h = axi4_virtual_slave_write::type_id::create("axi4_virtual_slave_write_h");
  axi4_virtual_slave_write_h.writeTransferType = OUTSTANDING_WRITE;
  `uvm_info(get_type_name(),$sformatf("axi4_outstanding_slave_write_test"),UVM_LOW);
  axi4_env_cfg_h.axi4_slave_agent_cfg_h[0].slave_response_mode = RESP_OUT_OF_ORDER;
  phase.raise_objection(this);
  axi4_virtual_slave_write_h.start(axi4_env_h.axi4_virtual_seqr_h);
  phase.drop_objection(this);
endtask : run_phase

`endif
