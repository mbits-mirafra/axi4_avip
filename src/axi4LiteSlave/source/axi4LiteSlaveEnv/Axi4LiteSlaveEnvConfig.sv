`ifndef AXI4LITESLAVEENVCONFIG_INCLUDED_
`define AXI4LITESLAVEENVCONFIG_INCLUDED_

class Axi4LiteSlaveEnvConfig extends uvm_object;
  `uvm_object_utils(Axi4LiteSlaveEnvConfig)
  
  bit hasSlaveVirtualSequencer = 1;
  int no_of_slaves;

  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig[];
  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig[];

  extern function new(string name = "Axi4LiteSlaveEnvConfig");
  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteSlaveEnvConfig

function Axi4LiteSlaveEnvConfig::new(string name = "Axi4LiteSlaveEnvConfig");
  super.new(name);
endfunction : new

function void Axi4LiteSlaveEnvConfig::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field ("hasSlaveVirtualSequencer",hasSlaveVirtualSequencer,1, UVM_DEC);

endfunction : do_print

`endif

