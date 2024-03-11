`ifndef AXI4LITEENVCONFIG_INCLUDED_
`define AXI4LITEENVCONFIG_INCLUDED_

class Axi4LiteEnvConfig extends uvm_object;
  `uvm_object_utils(Axi4LiteEnvConfig)
  
  bit hasScoreboard = 1;

  bit hasVirtualSequencer = 1;

  int no_of_slaves;
  
  int no_of_masters;

  Axi4LiteMasterEnvConfig axi4LiteMasterEnvConfig[];
  Axi4LiteSlaveEnvConfig axi4LiteSlaveEnvConfig[];

  extern function new(string name = "Axi4LiteEnvConfig");
  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteEnvConfig

function Axi4LiteEnvConfig::new(string name = "Axi4LiteEnvConfig");
  super.new(name);
endfunction : new

function void Axi4LiteEnvConfig::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field ("hasScoreboard",hasScoreboard,1, UVM_DEC);
  printer.print_field ("hasVirtualSequencer",hasVirtualSequencer,1, UVM_DEC);
  printer.print_field ("no_of_masters",no_of_masters,$bits(no_of_masters), UVM_HEX);
  printer.print_field ("no_of_slaves",no_of_slaves,$bits(no_of_slaves), UVM_HEX);

endfunction : do_print

`endif

