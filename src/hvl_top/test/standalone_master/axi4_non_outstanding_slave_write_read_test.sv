`ifndef AXI4_NON_OUTSTANDING_SLAVE_WRITE_READ_TEST_INCLUDED_
`define AXI4_NON_OUTSTANDING_SLAVE_WRITE_READ_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_non_outstanding_slave_write_read_test
// Extends the base test and starts the non-outstanding slave write-read virtual sequence
//--------------------------------------------------------------------------------------------
class axi4_non_outstanding_slave_write_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_non_outstanding_slave_write_read_test)

  //Variable: axi4_virtual_slave_write_read_h
  //Instantiation of the slave write-read virtual sequence
  axi4_virtual_slave_write_read axi4_virtual_slave_write_read_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_non_outstanding_slave_write_read_test", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);

endclass : axi4_non_outstanding_slave_write_read_test

//--------------------------------------------------------------------------------------------
// Construct: new
//--------------------------------------------------------------------------------------------
function axi4_non_outstanding_slave_write_read_test::new(string name = "axi4_non_outstanding_slave_write_read_test",
                                                         uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates and starts the non-outstanding slave write-read virtual sequence
//--------------------------------------------------------------------------------------------
task axi4_non_outstanding_slave_write_read_test::run_phase(uvm_phase phase);
  axi4_virtual_slave_write_read_h = axi4_virtual_slave_write_read::type_id::create("axi4_virtual_slave_write_read_h");
  axi4_virtual_slave_write_read_h.writeTransferType = NON_OUTSTANDING_WRITE;
  axi4_virtual_slave_write_read_h.readTransferType  = NON_OUTSTANDING_READ;
  `uvm_info(get_type_name(),$sformatf("axi4_non_outstanding_slave_write_read_test"),UVM_LOW);
  phase.raise_objection(this);
  axi4_virtual_slave_write_read_h.start(axi4_env_h.axi4_virtual_seqr_h);
  phase.drop_objection(this);
endtask : run_phase

`endif
