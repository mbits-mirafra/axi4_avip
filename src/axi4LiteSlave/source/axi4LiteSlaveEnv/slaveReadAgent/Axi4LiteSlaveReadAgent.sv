`ifndef AXI4LITESLAVEREADAGENT_INCLUDED_
`define AXI4LITESLAVEREADAGENT_INCLUDED_

class Axi4LiteSlaveReadAgent extends uvm_agent;
  `uvm_component_utils(Axi4LiteSlaveReadAgent)

  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig;

  Axi4LiteSlaveReadSequencer axi4LiteSlaveReadSequencer;
  
  Axi4LiteSlaveReadDriverProxy axi4LiteSlaveReadDriverProxy;

  Axi4LiteSlaveReadMonitorProxy axi4LiteSlaveReadMonitorProxy;

  Axi4LiteSlaveReadCoverage axi4LiteSlaveReadCoverage;
  
  uvm_analysis_port#(Axi4LiteSlaveReadTransaction) axi4LiteSlaveReadAgentAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveReadTransaction) axi4LiteSlaveReadAgentDataAnalysisPort;

  extern function new(string name = "Axi4LiteSlaveReadAgent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteSlaveReadAgent

function Axi4LiteSlaveReadAgent::new(string name = "Axi4LiteSlaveReadAgent", uvm_component parent);
  super.new(name, parent);
  axi4LiteSlaveReadAgentAddressAnalysisPort  = new("axi4LiteSlaveReadAgentAddressAnalysisPort",this);
  axi4LiteSlaveReadAgentDataAnalysisPort     = new("axi4LiteSlaveReadAgentDataAnalysisPort",this);
endfunction : new

function void Axi4LiteSlaveReadAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);

   if(axi4LiteSlaveReadAgentConfig.isActive == UVM_ACTIVE) begin
     axi4LiteSlaveReadDriverProxy  = Axi4LiteSlaveReadDriverProxy::type_id::create("axi4LiteSlaveReadDriverProxy",this);
     axi4LiteSlaveReadSequencer = Axi4LiteSlaveReadSequencer::type_id::create("axi4LiteSlaveReadSequencer",this);
   end

   axi4LiteSlaveReadMonitorProxy = Axi4LiteSlaveReadMonitorProxy::type_id::create("axi4LiteSlaveReadMonitorProxy",this);

   if(axi4LiteSlaveReadAgentConfig.hasCoverage) begin
    axi4LiteSlaveReadCoverage = Axi4LiteSlaveReadCoverage::type_id::create("axi4LiteSlaveReadCoverage",this);
   end
endfunction : build_phase

function void Axi4LiteSlaveReadAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(axi4LiteSlaveReadAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteSlaveReadDriverProxy.axi4LiteSlaveReadAgentConfig  = axi4LiteSlaveReadAgentConfig;
    axi4LiteSlaveReadSequencer.axi4LiteSlaveReadAgentConfig = axi4LiteSlaveReadAgentConfig;
    // Connecting the ports
    axi4LiteSlaveReadDriverProxy.axi4LiteSlaveReadSeqItemPort.connect(axi4LiteSlaveReadSequencer.seq_item_export);
  end

  if(axi4LiteSlaveReadAgentConfig.hasCoverage) begin
    // Connecting monitor_proxy port to coverage export
    axi4LiteSlaveReadMonitorProxy.axi4LiteSlaveReadAddressAnalysisPort.connect(axi4LiteSlaveReadCoverage.analysis_export);
    axi4LiteSlaveReadMonitorProxy.axi4LiteSlaveReadDataAnalysisPort.connect(axi4LiteSlaveReadCoverage.analysis_export);
  end

  axi4LiteSlaveReadMonitorProxy.axi4LiteSlaveReadAddressAnalysisPort.connect(axi4LiteSlaveReadAgentAddressAnalysisPort);
  axi4LiteSlaveReadMonitorProxy.axi4LiteSlaveReadDataAnalysisPort.connect(axi4LiteSlaveReadAgentDataAnalysisPort);

  axi4LiteSlaveReadMonitorProxy.axi4LiteSlaveReadAgentConfig = axi4LiteSlaveReadAgentConfig;

endfunction: connect_phase

`endif

