`ifndef AXI4LITEVIRTUALSEQUENCER_INCLUDED_
`define AXI4LITEVIRTUALSEQUENCER_INCLUDED_

class Axi4LiteVirtualSequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(Axi4LiteVirtualSequencer)

  Axi4LiteMasterVirtualSequencer axi4LiteMasterVirtualSequencer;
  Axi4LiteSlaveVirtualSequencer axi4LiteSlaveVirtualSequencer;

  extern function new(string name = "Axi4LiteVirtualSequencer", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteVirtualSequencer

function Axi4LiteVirtualSequencer::new(string name = "Axi4LiteVirtualSequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteVirtualSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void Axi4LiteVirtualSequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteVirtualSequencer::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

function void Axi4LiteVirtualSequencer::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase


task Axi4LiteVirtualSequencer::run_phase(uvm_phase phase);

  // Work here
  // ...

endtask : run_phase

`endif

