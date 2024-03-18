`ifndef AXI4LITESLAVEWRITEAGENT_INCLUDED_
`define AXI4LITESLAVEWRITEAGENT_INCLUDED_

class Axi4LiteSlaveWriteAgent extends uvm_agent;
  `uvm_component_utils(Axi4LiteSlaveWriteAgent)

  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig;

  Axi4LiteSlaveWriteSequencer axi4LiteSlaveWriteSequencer;
  
  Axi4LiteSlaveWriteDriverProxy axi4LiteSlaveWriteDriverProxy;

  Axi4LiteSlaveWriteMonitorProxy axi4LiteSlaveWriteMonitorProxy;

  Axi4LiteSlaveWriteCoverage axi4LiteSlaveWriteCoverage;
  
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteAgentAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteAgentDataAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteAgentResponseAnalysisPort;

  extern function new(string name = "Axi4LiteSlaveWriteAgent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteSlaveWriteAgent

function Axi4LiteSlaveWriteAgent::new(string name = "Axi4LiteSlaveWriteAgent", uvm_component parent);
  super.new(name, parent);
  axi4LiteSlaveWriteAgentAddressAnalysisPort  = new("axi4LiteSlaveWriteAgentAddressAnalysisPort",this);
  axi4LiteSlaveWriteAgentDataAnalysisPort     = new("axi4LiteSlaveWriteAgentDataAnalysisPort",this);
  axi4LiteSlaveWriteAgentResponseAnalysisPort = new("axi4LiteSlaveWriteAgentResponseAnalysisPort",this);
endfunction : new

function void Axi4LiteSlaveWriteAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);

   if(axi4LiteSlaveWriteAgentConfig.isActive == UVM_ACTIVE) begin
     axi4LiteSlaveWriteDriverProxy  = Axi4LiteSlaveWriteDriverProxy::type_id::create("axi4LiteSlaveWriteDriverProxy",this);
     axi4LiteSlaveWriteSequencer = Axi4LiteSlaveWriteSequencer::type_id::create("axi4LiteSlaveWriteSequencer",this);
   end

   axi4LiteSlaveWriteMonitorProxy = Axi4LiteSlaveWriteMonitorProxy::type_id::create("axi4LiteSlaveWriteMonitorProxy",this);

   if(axi4LiteSlaveWriteAgentConfig.hasCoverage) begin
    axi4LiteSlaveWriteCoverage = Axi4LiteSlaveWriteCoverage::type_id::create("axi4LiteSlaveWriteCoverage",this);
   end
endfunction : build_phase

function void Axi4LiteSlaveWriteAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(axi4LiteSlaveWriteAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteSlaveWriteDriverProxy.axi4LiteSlaveWriteAgentConfig  = axi4LiteSlaveWriteAgentConfig;
    axi4LiteSlaveWriteSequencer.axi4LiteSlaveWriteAgentConfig = axi4LiteSlaveWriteAgentConfig;
      
    // Connecting the ports
    axi4LiteSlaveWriteDriverProxy.axi4LiteSlaveWriteSeqItemPort.connect(axi4LiteSlaveWriteSequencer.seq_item_export);
    end

  if(axi4LiteSlaveWriteAgentConfig.hasCoverage) begin
    axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteAddressAnalysisPort.connect(axi4LiteSlaveWriteCoverage.analysis_export);
    axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteDataAnalysisPort.connect(axi4LiteSlaveWriteCoverage.analysis_export);
    axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteResponseAnalysisPort.connect(axi4LiteSlaveWriteCoverage.analysis_export);
  end

  axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteAddressAnalysisPort.connect(axi4LiteSlaveWriteAgentAddressAnalysisPort);
  axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteDataAnalysisPort.connect(axi4LiteSlaveWriteAgentDataAnalysisPort);
  axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteResponseAnalysisPort.connect(axi4LiteSlaveWriteAgentResponseAnalysisPort);

  axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteAgentConfig = axi4LiteSlaveWriteAgentConfig;

endfunction: connect_phase

`endif

