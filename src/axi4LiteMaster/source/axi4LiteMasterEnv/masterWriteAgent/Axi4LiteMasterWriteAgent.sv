`ifndef AXI4LITEMASTERWRITEAGENT_INCLUDED_
`define AXI4LITEMASTERWRITEAGENT_INCLUDED_

class Axi4LiteMasterWriteAgent extends uvm_agent;
  `uvm_component_utils(Axi4LiteMasterWriteAgent)

  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig;

  Axi4LiteMasterWriteSequencer axi4LiteMasterWriteSequencer;
  
  Axi4LiteMasterWriteDriverProxy axi4LiteMasterWriteDriverProxy;
  Axi4LiteMasterWriteMonitorProxy axi4LiteMasterWriteMonitorProxy;
  
  Axi4LiteMasterWriteCoverage axi4LiteMasterWriteCoverage;

  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4LiteMasterWriteAgentAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4LiteMasterWriteAgentDataAnalysisPort;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4LiteMasterWriteAgentResponseAnalysisPort;

  extern function new(string name = "Axi4LiteMasterWriteAgent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteMasterWriteAgent

function Axi4LiteMasterWriteAgent::new(string name = "Axi4LiteMasterWriteAgent", uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterWriteAgentAddressAnalysisPort  = new("axi4LiteMasterWriteAgentAddressAnalysisPort",this);
  axi4LiteMasterWriteAgentDataAnalysisPort     = new("axi4LiteMasterWriteAgentDataAnalysisPort",this);
  axi4LiteMasterWriteAgentResponseAnalysisPort = new("axi4LiteMasterWriteAgentResponseAnalysisPort",this);
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

function void Axi4LiteMasterWriteAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(axi4LiteMasterWriteAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteMasterWriteDriverProxy.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;
    axi4LiteMasterWriteSequencer.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;
  
    //Connecting the ports
    axi4LiteMasterWriteDriverProxy.axi4LiteMasterWriteSeqItemPort.connect(axi4LiteMasterWriteSequencer.seq_item_export);
  end

  if(axi4LiteMasterWriteAgentConfig.hasCoverage) begin
    //Connecting monitor_proxy port to coverage export
    axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteAddressAnalysisPort.connect(axi4LiteMasterWriteCoverage.analysis_export);
    axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteDataAnalysisPort.connect(axi4LiteMasterWriteCoverage.analysis_export);
    axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteResponseAnalysisPort.connect(axi4LiteMasterWriteCoverage.analysis_export);
  end
  
  axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteAddressAnalysisPort.connect(axi4LiteMasterWriteAgentAddressAnalysisPort);
  axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteDataAnalysisPort.connect(axi4LiteMasterWriteAgentDataAnalysisPort);
  axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteResponseAnalysisPort.connect(axi4LiteMasterWriteAgentResponseAnalysisPort);

  axi4LiteMasterWriteMonitorProxy.axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig;

endfunction : connect_phase

`endif

