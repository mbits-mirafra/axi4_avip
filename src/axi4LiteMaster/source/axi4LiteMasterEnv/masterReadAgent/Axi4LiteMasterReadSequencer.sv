`ifndef AXI4LITEMASTERREADSEQUENCER_INCLUDED_
`define AXI4LITEMASTERREADSEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteMasterReadSequencer
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterReadSequencer extends uvm_sequencer#(Axi4LiteMasterReadTransaction);
  `uvm_component_utils(Axi4LiteMasterReadSequencer)

  // Declaring handle for master agent config class 
  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig;
  
  extern function new(string name = "Axi4LiteMasterReadSequencer", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteMasterReadSequencer

function Axi4LiteMasterReadSequencer::new(string name = "Axi4LiteMasterReadSequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadSequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadSequencer::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Function: start_of_simulation_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadSequencer::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task Axi4LiteMasterReadSequencer::run_phase(uvm_phase phase);

  // Work here
  // ...

endtask : run_phase

`endif

