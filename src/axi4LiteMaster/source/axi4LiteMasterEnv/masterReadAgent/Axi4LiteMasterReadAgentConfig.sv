`ifndef AXI4LITEMASTERREADAGENTCONFIG_INCLUDED_
`define AXI4LITEMASTERREADAGENTCONFIG_INCLUDED_

class Axi4LiteMasterReadAgentConfig extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterReadAgentConfig)

  //Used for creating the agent in either passive or active mode
  uvm_active_passive_enum isActive=UVM_ACTIVE;  
  
  //Used for enabling the master agent coverage
  bit hasCoverage;


  extern function new(string name = "Axi4LiteMasterReadAgentConfig");
  extern function void do_print(uvm_printer printer);
endclass : Axi4LiteMasterReadAgentConfig

function Axi4LiteMasterReadAgentConfig::new(string name = "Axi4LiteMasterReadAgentConfig");
  super.new(name);
endfunction : new

function void Axi4LiteMasterReadAgentConfig::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_string ("isActive",isActive.name());
  printer.print_field ("hasCoverage",  hasCoverage, $bits(hasCoverage),  UVM_DEC);
endfunction : do_print

`endif

