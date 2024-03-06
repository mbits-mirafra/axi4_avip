`ifndef ASSERTION_BASE_TEST_INCLUDED_
`define ASSERTION_BASE_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: assertion_base_test
// axi4_base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class assertion_base_test extends axi4_base_test;
  
  `uvm_component_utils(assertion_base_test)

  // Variable: e_cfg_h
  // Declaring environment config handle
  axi4_env_config axi4_env_cfg_h;

  // Variable: axi4_env_h
  // Handle for environment 
  axi4_env axi4_env_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "assertion_base_test", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);

endclass : assertion_base_test

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes class object
//
// Parameters:
//  name - assertion_base_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function assertion_base_test::new(string name = "assertion_base_test",uvm_component parent = null);
  super.new(name, parent);
endfunction : new


//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation 
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task assertion_base_test::run_phase(uvm_phase phase);

  phase.raise_objection(this);

  `uvm_info(get_type_name(), $sformatf("Inside BASE_TEST"), UVM_NONE);

  #1000;

  `uvm_info(get_type_name(), $sformatf("Done BASE_TEST"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase

`endif
