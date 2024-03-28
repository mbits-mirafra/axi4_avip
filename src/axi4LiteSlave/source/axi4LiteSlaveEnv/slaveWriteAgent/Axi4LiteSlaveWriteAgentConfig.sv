`ifndef AXI4LITESLAVEWRITEAGENTCONFIG_INCLUDED_
`define AXI4LITESLAVEWRITEAGENTCONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveWriteAgentConfig
// Used as the configuration class for axi4_slave agent and it's components
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveWriteAgentConfig extends uvm_object;
  `uvm_object_utils(Axi4LiteSlaveWriteAgentConfig)

  //Variable: isActive
  //Used for creating the agent in either passive or active mode
  uvm_active_passive_enum isActive = UVM_ACTIVE;  
  
  //Variable: hasCoverage
  //Used for enabling the slave agent coverage
  bit hasCoverage;

  bit [DELAY_WIDTH-1:0] delayForReadyWriteCfgValue[];

  extern function new(string name = "Axi4LiteSlaveWriteAgentConfig");
  extern function void do_print(uvm_printer printer);
endclass : Axi4LiteSlaveWriteAgentConfig

function Axi4LiteSlaveWriteAgentConfig::new(string name = "Axi4LiteSlaveWriteAgentConfig");
  super.new(name); 
endfunction : new

function void Axi4LiteSlaveWriteAgentConfig::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_string ("isActive",   isActive.name());
  printer.print_field ("hasCoverage", hasCoverage, $bits(hasCoverage), UVM_DEC);

  foreach(delayForReadyWriteCfgValue[i]) begin
    printer.print_field ($sformatf("delayForReadyWriteCfgValue[%0d]",i),this.delayForReadyWriteCfgValue[i],$bits(delayForReadyWriteCfgValue[i]),UVM_HEX);
  end
endfunction : do_print

`endif

