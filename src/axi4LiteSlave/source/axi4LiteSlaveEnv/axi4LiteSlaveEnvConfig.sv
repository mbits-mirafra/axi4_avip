`ifndef AXI4LITESLAVEENVCONFIG_INCLUDED_
`define AXI4LITESLAVEENVCONFIG_INCLUDED_

class axi4LiteSlaveEnvConfig extends uvm_object;
  `uvm_object_utils(axi4LiteSlaveEnvConfig)
  
  bit hasSlaveVirtualSequencer = 1;

  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig[];
  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig[];

  extern function new(string name = "axi4LiteSlaveEnvConfig");
  extern function void do_print(uvm_printer printer);

endclass : axi4LiteSlaveEnvConfig

function axi4LiteSlaveEnvConfig::new(string name = "axi4LiteSlaveEnvConfig");
  super.new(name);
endfunction : new

function void axi4LiteSlaveEnvConfig::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field ("hasSlaveVirtualSequencer",hasSlaveVirtualSequencer,1, UVM_DEC);

endfunction : do_print

`endif

