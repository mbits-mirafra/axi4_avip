`ifndef AXI4LITEMASTERWRITEAGENT_INCLUDED_
`define AXI4LITEMASTERWRITEAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// This agent is a configurable with respect to configuration which can create active and passive components
// It contains testbench components like sequencer,driver_proxy and monitor_proxy for AXI4
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterWriteAgent extends uvm_agent;
  `uvm_component_utils(Axi4LiteMasterWriteAgent)

  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig;

  Axi4LiteMasterWriteSequencer axi4LiteMasterWriteSequencer;
  
  Axi4LiteMasterWriteDriverProxy axi4LiteMasterWriteDriverProxy;
  Axi4LiteMasterWriteMonitorProxy axi4LiteMasterWriteMonitorProxy;
  
  Axi4LiteMasterWriteCoverage axi4LiteMasterWriteCoverage;

  extern function new(string name = "Axi4LiteMasterWriteAgent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteMasterWriteAgent

function Axi4LiteMasterWriteAgent::new(string name = "Axi4LiteMasterWriteAgent", uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteMasterWriteAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(axi4LiteMasterWriteAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteMasterWriteDriverProxy=Axi4LiteMasterWriteDriverProxy::type_id::create("axi4LiteMasterWriteDriverProxy",this);
    axi4LiteMasterWriteSequencer=Axi4LiteMasterWriteSequencer::type_id::create("axi4LiteMasterWriteSequencer",this);
  end
  
  axi4LiteMasterWriteMonitorProxy=Axi4LiteMasterWriteMonitorProxy::type_id::create("axi4LiteMasterWriteMonitorProxy",this);
  
  if(axi4LiteMasterWriteAgentConfig.hasCoverage) begin
   axi4LiteMasterWriteCoverage = Axi4LiteMasterWriteCoverage ::type_id::create("axi4LiteMasterWriteCoverage",this);
  end

endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase 
//  Connecting axi4 master driver, master monitor and master sequencer for configuration
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterWriteAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(axi4LiteMasterWriteAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteMasterWriteDriverProxy.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;
    axi4LiteMasterWriteSequencer.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;
    axi4LiteMasterWriteCoverage.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;
  
    //Connecting the ports
    axi4LiteMasterWriteDriverProxy.axi_write_seq_item_port.connect(axi4LiteMasterWriteSequencer.seq_item_export);
  end

  if(axi4LiteMasterWriteAgentConfig.hasCoverage) begin
    axi4LiteMasterWriteCoverage.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;   
    //Connecting monitor_proxy port to coverage export
    axi4LiteMasterWriteMonitorProxy.axi4_master_read_address_analysis_port.connect(axi4LiteMasterWriteCoverage.analysis_export);
    axi4LiteMasterWriteMonitorProxy.axi4_master_read_data_analysis_port.connect(axi4LiteMasterWriteCoverage.analysis_export);
    axi4LiteMasterWriteMonitorProxy.axi4_master_write_address_analysis_port.connect(axi4LiteMasterWriteCoverage.analysis_export);
    axi4LiteMasterWriteMonitorProxy.axi4_master_write_data_analysis_port.connect(axi4LiteMasterWriteCoverage.analysis_export);
    axi4LiteMasterWriteMonitorProxy.axi4_master_write_response_analysis_port.connect(axi4LiteMasterWriteCoverage.analysis_export);
  end
  
  axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;

endfunction : connect_phase

`endif

