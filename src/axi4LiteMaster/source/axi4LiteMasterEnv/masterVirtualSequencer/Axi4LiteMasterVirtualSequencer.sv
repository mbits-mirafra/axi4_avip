`ifndef AXI4LITEMASTERVIRTUALSEQUENCER_INCLUDED_
`define AXI4LITEMASTERVIRTUALSEQUENCER_INCLUDED_

class Axi4LiteMasterVirtualSequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(Axi4LiteMasterVirtualSequencer)

  Axi4LiteMasterWriteSequencer axi4LiteMasterWriteSequencer;
  Axi4LiteMasterReadSequencer axi4LiteMasterReadSequencer;

  extern function new(string name = "Axi4LiteMasterVirtualSequencer", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteMasterVirtualSequencer

function Axi4LiteMasterVirtualSequencer::new(string name = "Axi4LiteMasterVirtualSequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteMasterVirtualSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void Axi4LiteMasterVirtualSequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteMasterVirtualSequencer::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

function void Axi4LiteMasterVirtualSequencer::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase


task Axi4LiteMasterVirtualSequencer::run_phase(uvm_phase phase);

  // Work here
  // ...

endtask : run_phase

`endif

