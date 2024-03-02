`ifndef AXI4LITEENV_INCLUDED_
`define AXI4LITEENV_INCLUDED_

class Axi4LiteEnv extends uvm_env;
  `uvm_component_utils(Axi4LiteEnv)
  
  extern function new(string name = "Axi4LiteEnv", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteEnv

function Axi4LiteEnv::new(string name = "Axi4LiteEnv",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteEnv::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  
endfunction : build_phase


function void Axi4LiteEnv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

endfunction : connect_phase

`endif

