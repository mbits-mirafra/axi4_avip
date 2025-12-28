`ifndef AXI4_NON_BLOCKING_64B_WRITE_DATA_TEST_INCLUDED_
`define AXI4_NON_BLOCKING_64B_WRITE_DATA_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_non_blocking_64b_write_data_test
// Extends the base test and starts the virtual sequenceof write
//--------------------------------------------------------------------------------------------
class axi4_non_blocking_64b_write_data_test extends axi4_base_test;
  `uvm_component_utils(axi4_non_blocking_64b_write_data_test)

  //Variable : axi4_virtual_write_seq_h
  //Instatiation of axi4_virtual_write_seq
  axi4_virtual_nbk_64b_write_data_seq axi4_virtual_nbk_64b_write_data_seq_h;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_non_blocking_64b_write_data_test", uvm_component parent = null);

  extern function void setup_axi4_env_cfg();
  extern virtual task run_phase(uvm_phase phase);

endclass : axi4_non_blocking_64b_write_data_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_non_blocking_64b_write_data_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_non_blocking_64b_write_data_test::new(string name = "axi4_non_blocking_64b_write_data_test",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new



function void axi4_non_blocking_64b_write_data_test::setup_axi4_env_cfg();
  super.setup_axi4_env_cfg();
  axi4_env_cfg_h.write_read_mode_h = ONLY_WRITE_DATA;
endfunction:setup_axi4_env_cfg

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates the axi4_virtual_64b_write_data_seq sequence and starts the write virtual sequences
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task axi4_non_blocking_64b_write_data_test::run_phase(uvm_phase phase);

  axi4_virtual_nbk_64b_write_data_seq_h=axi4_virtual_nbk_64b_write_data_seq::type_id::create("axi4_virtual_nbk_64b_write_data_seq_h");
  `uvm_info(get_type_name(),$sformatf("axi4_non_blocking_64b_write_data_test"),UVM_LOW);
  phase.raise_objection(this);
  axi4_virtual_nbk_64b_write_data_seq_h.start(axi4_env_h.axi4_virtual_seqr_h);
  phase.drop_objection(this);

endtask : run_phase

`endif

