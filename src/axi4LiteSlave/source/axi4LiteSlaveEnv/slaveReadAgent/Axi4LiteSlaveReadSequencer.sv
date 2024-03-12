`ifndef AXI4LITESLAVEREADSEQUENCER_INCLUDED_
`define AXI4LITESLAVEREADSEQUENCER_INCLUDED_

class Axi4LiteSlaveReadSequencer extends uvm_sequencer#(Axi4LiteSlaveReadTransaction);
  `uvm_component_utils(Axi4LiteSlaveReadSequencer)

  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig;
  
  extern function new(string name = "Axi4LiteSlaveReadSequencer", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteSlaveReadSequencer

function Axi4LiteSlaveReadSequencer::new(string name = "Axi4LiteSlaveReadSequencer",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteSlaveReadSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void Axi4LiteSlaveReadSequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteSlaveReadSequencer::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

function void Axi4LiteSlaveReadSequencer::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

task Axi4LiteSlaveReadSequencer::run_phase(uvm_phase phase);

endtask : run_phase

`endif

