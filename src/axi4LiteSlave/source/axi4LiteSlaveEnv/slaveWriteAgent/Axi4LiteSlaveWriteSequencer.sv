`ifndef AXI4LITESLAVEWRITESEQUENCER_INCLUDED_
`define AXI4LITESLAVEWRITESEQUENCER_INCLUDED_

class Axi4LiteSlaveWriteSequencer extends uvm_sequencer#(Axi4LiteSlaveWriteTransaction);
  `uvm_component_utils(Axi4LiteSlaveWriteSequencer)

  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig;
  
  extern function new(string name = "Axi4LiteSlaveWriteSequencer", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteSlaveWriteSequencer

function Axi4LiteSlaveWriteSequencer::new(string name = "Axi4LiteSlaveWriteSequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteSlaveWriteSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void Axi4LiteSlaveWriteSequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteSlaveWriteSequencer::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

function void Axi4LiteSlaveWriteSequencer::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

task Axi4LiteSlaveWriteSequencer::run_phase(uvm_phase phase);

  // Work here
  // ...

endtask : run_phase

`endif

