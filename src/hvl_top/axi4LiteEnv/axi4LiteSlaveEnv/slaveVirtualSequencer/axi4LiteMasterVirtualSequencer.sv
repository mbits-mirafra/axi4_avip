`ifndef AXI4LITESLAVEVIRTUALSEQUENCER_INCLUDED_
`define AXI4LITESLAVEVIRTUALSEQUENCER_INCLUDED_

class Axi4LiteSlaveVirtualSequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(Axi4LiteSlaveVirtualSequencer)

  Axi4LiteSlaveWriteSequencer axi4LiteSlaveWriteSequencer;
  Axi4LiteSlaveReadSequencer axi4LiteSlaveReadSequencer;

  extern function new(string name = "Axi4LiteSlaveVirtualSequencer", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteSlaveVirtualSequencer

function Axi4LiteSlaveVirtualSequencer::new(string name = "Axi4LiteSlaveVirtualSequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteSlaveVirtualSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void Axi4LiteSlaveVirtualSequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteSlaveVirtualSequencer::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

function void Axi4LiteSlaveVirtualSequencer::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase


task Axi4LiteSlaveVirtualSequencer::run_phase(uvm_phase phase);

  // Work here
  // ...

endtask : run_phase

`endif

