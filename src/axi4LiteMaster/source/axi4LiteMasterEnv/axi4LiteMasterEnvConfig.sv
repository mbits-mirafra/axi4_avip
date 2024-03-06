`ifndef AXI4LITEMASTERENVCONFIG_INCLUDED_
`define AXI4LITEMASTERENVCONFIG_INCLUDED_

class axi4LiteMasterEnvConfig extends uvm_object;
  `uvm_object_utils(axi4LiteMasterEnvConfig)
  
  bit hasMasterVirtualSequencer = 1;

  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig[];
  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig[];

  extern function new(string name = "axi4LiteMasterEnvConfig");
  extern function void do_print(uvm_printer printer);

endclass : axi4LiteMasterEnvConfig

function axi4LiteMasterEnvConfig::new(string name = "axi4LiteMasterEnvConfig");
  super.new(name);
endfunction : new

function void axi4LiteMasterEnvConfig::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field ("hasMasterVirtualSequencer",hasMasterVirtualSequencer,1, UVM_DEC);

endfunction : do_print

`endif

