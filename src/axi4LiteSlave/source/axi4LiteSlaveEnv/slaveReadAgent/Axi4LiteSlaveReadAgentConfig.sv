`ifndef AXI4LITESLAVEREADAGENTCONFIG_INCLUDED_
`define AXI4LITESLAVEREADAGENTCONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveReadAgentConfig
// Used as the configuration class for axi4_slave agent and it's components
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveReadAgentConfig extends uvm_object;
  `uvm_object_utils(Axi4LiteSlaveReadAgentConfig)

  //Variable: isActive
  //Used for creating the agent in either passive or active mode
  uvm_active_passive_enum isActive = UVM_ACTIVE;  
  
  //Variable: hasCoverage
  //Used for enabling the master agent coverage
  bit hasCoverage;

  extern function new(string name = "Axi4LiteSlaveReadAgentConfig");
  extern function void do_print(uvm_printer printer);
endclass : Axi4LiteSlaveReadAgentConfig

function Axi4LiteSlaveReadAgentConfig::new(string name = "Axi4LiteSlaveReadAgentConfig");
  super.new(name); 
endfunction : new

function void Axi4LiteSlaveReadAgentConfig::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_string ("isActive",   isActive.name());
  printer.print_field ("hasCoverage", hasCoverage, $bits(hasCoverage), UVM_DEC);
         
endfunction : do_print

`endif

