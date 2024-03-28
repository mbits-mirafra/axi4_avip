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

  bit [DELAY_WIDTH-1:0] delayForReadyReadCfgValue[];

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
         
  foreach(delayForReadyReadCfgValue[i]) begin
    printer.print_field ($sformatf("delayForReadyReadCfgValue[%0d]",i),this.delayForReadyReadCfgValue[i],$bits(delayForReadyReadCfgValue[i]),UVM_HEX);
  end
endfunction : do_print

`endif

