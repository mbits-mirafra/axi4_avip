`ifndef AXI4LITEMASTERWRITESEQUENCER_INCLUDED_
`define AXI4LITEMASTERWRITESEQUENCER_INCLUDED_

class Axi4LiteMasterWriteSequencer extends uvm_sequencer#(Axi4LiteMasterWriteTransaction);
  `uvm_component_utils(Axi4LiteMasterWriteSequencer)

  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig;
  
  extern function new(string name = "Axi4LiteMasterWriteSequencer", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteMasterWriteSequencer

function Axi4LiteMasterWriteSequencer::new(string name = "Axi4LiteMasterWriteSequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteMasterWriteSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void Axi4LiteMasterWriteSequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteMasterWriteSequencer::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

function void Axi4LiteMasterWriteSequencer::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

task Axi4LiteMasterWriteSequencer::run_phase(uvm_phase phase);

  // Work here
  // ...

endtask : run_phase

`endif

