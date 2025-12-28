`ifndef AXI4_VIRTUAL_BASE_SEQ_INCLUDED_
`define AXI4_VIRTUAL_BASE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
//Class: axi4_virtual_base_seq
// Description:
// This class contains the handle of actual sequencer pointing towards them
//--------------------------------------------------------------------------------------------
class axi4_virtual_base_seq extends uvm_sequence;
  `uvm_object_utils(axi4_virtual_base_seq)

   //p sequencer macro declaration 
   `uvm_declare_p_sequencer(axi4_virtual_sequencer)
 
   axi4_env_config env_cfg_h;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="axi4_virtual_base_seq");
  extern task body();

endclass:axi4_virtual_base_seq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_virtual_base_seq::new(string name="axi4_virtual_base_seq");
  super.new(name);
endfunction:new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task axi4_virtual_base_seq::body();

   if(!uvm_config_db#(axi4_env_config) ::get(null,get_full_name(),"axi4_env_config",env_cfg_h)) begin
    `uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db.Have you set() it?")
  end

  if(!$cast(p_sequencer,m_sequencer))begin
    `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
  end
endtask:body

`endif
