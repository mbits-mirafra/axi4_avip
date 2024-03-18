`ifndef AXI4LITEMASTERREADAGENT_INCLUDED_
`define AXI4LITEMASTERREADAGENT_INCLUDED_

class Axi4LiteMasterReadAgent extends uvm_agent;
  `uvm_component_utils(Axi4LiteMasterReadAgent)

  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig;

  Axi4LiteMasterReadSequencer axi4LiteMasterReadSequencer;
  
  Axi4LiteMasterReadDriverProxy axi4LiteMasterReadDriverProxy;
  Axi4LiteMasterReadMonitorProxy axi4LiteMasterReadMonitorProxy;
  
  Axi4LiteMasterReadCoverage axi4LiteMasterReadCoverage;

  uvm_analysis_port#(Axi4LiteMasterReadTransaction) axi4LiteMasterReadAgentAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteMasterReadTransaction) axi4LiteMasterReadAgentDataAnalysisPort;

  extern function new(string name = "Axi4LiteMasterReadAgent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteMasterReadAgent

function Axi4LiteMasterReadAgent::new(string name = "Axi4LiteMasterReadAgent", uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterReadAgentAddressAnalysisPort  = new("axi4LiteMasterReadAgentAddressAnalysisPort",this);
  axi4LiteMasterReadAgentDataAnalysisPort     = new("axi4LiteMasterReadAgentDataAnalysisPort",this);
endfunction : new

function void Axi4LiteMasterReadAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(axi4LiteMasterReadAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteMasterReadDriverProxy=Axi4LiteMasterReadDriverProxy::type_id::create("axi4LiteMasterReadDriverProxy",this);
    axi4LiteMasterReadSequencer=Axi4LiteMasterReadSequencer::type_id::create("axi4LiteMasterReadSequencer",this);
  end
  
  axi4LiteMasterReadMonitorProxy=Axi4LiteMasterReadMonitorProxy::type_id::create("axi4LiteMasterReadMonitorProxy",this);
  
  if(axi4LiteMasterReadAgentConfig.hasCoverage) begin
   axi4LiteMasterReadCoverage = Axi4LiteMasterReadCoverage ::type_id::create("axi4LiteMasterReadCoverage",this);
  end

endfunction : build_phase

function void Axi4LiteMasterReadAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(axi4LiteMasterReadAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteMasterReadDriverProxy.axi4LiteMasterReadAgentConfig = axi4LiteMasterReadAgentConfig;
    axi4LiteMasterReadSequencer.axi4LiteMasterReadAgentConfig = axi4LiteMasterReadAgentConfig;
  
    //Connecting the ports
    axi4LiteMasterReadDriverProxy.axi4LiteMasterReadSeqItemPort.connect(axi4LiteMasterReadSequencer.seq_item_export);
  end

  if(axi4LiteMasterReadAgentConfig.hasCoverage) begin
    axi4LiteMasterReadMonitorProxy.axi4LiteMasterReadAddressAnalysisPort.connect(axi4LiteMasterReadCoverage.analysis_export);
    axi4LiteMasterReadMonitorProxy.axi4LiteMasterReadDataAnalysisPort.connect(axi4LiteMasterReadCoverage.analysis_export);
  end
  
  axi4LiteMasterReadMonitorProxy.axi4LiteMasterReadAddressAnalysisPort.connect(axi4LiteMasterReadAgentAddressAnalysisPort);
  axi4LiteMasterReadMonitorProxy.axi4LiteMasterReadDataAnalysisPort.connect(axi4LiteMasterReadAgentDataAnalysisPort);

  axi4LiteMasterReadMonitorProxy.axi4LiteMasterReadAgentConfig = axi4LiteMasterReadAgentConfig;

endfunction : connect_phase

`endif

