`ifndef AXI4LITESLAVEENV_INCLUDED_
`define AXI4LITESLAVEENV_INCLUDED_

class Axi4LiteSlaveEnv extends uvm_env;
  `uvm_component_utils(Axi4LiteSlaveEnv)
  
  Axi4LiteSlaveEnvConfig axi4LiteSlaveEnvConfig;

  Axi4LiteSlaveWriteAgent axi4LiteSlaveWriteAgent[];
  Axi4LiteSlaveReadAgent axi4LiteSlaveReadAgent[];

  Axi4LiteSlaveVirtualSequencer axi4LiteSlaveVirtualSequencer;

  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig[];
  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig[];

  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteEnvAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteEnvDataAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteEnvResponseAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveReadTransaction) axi4LiteSlaveReadEnvAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveReadTransaction) axi4LiteSlaveReadEnvDataAnalysisPort;

  extern function new(string name = "Axi4LiteSlaveEnv", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteSlaveEnv

function Axi4LiteSlaveEnv::new(string name = "Axi4LiteSlaveEnv",uvm_component parent = null);
  super.new(name, parent);
  axi4LiteSlaveWriteEnvAddressAnalysisPort  = new("axi4LiteSlaveWriteEnvAddressAnalysisPort",this);
  axi4LiteSlaveWriteEnvDataAnalysisPort     = new("axi4LiteSlaveWriteEnvDataAnalysisPort",this);
  axi4LiteSlaveWriteEnvResponseAnalysisPort = new("axi4LiteSlaveWriteEnvResponseAnalysisPort",this);
  axi4LiteSlaveReadEnvAddressAnalysisPort  = new("axi4LiteSlaveReadEnvAddressAnalysisPort",this);
  axi4LiteSlaveReadEnvDataAnalysisPort     = new("axi4LiteSlaveReadEnvDataAnalysisPort",this);
endfunction : new

function void Axi4LiteSlaveEnv::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db #(Axi4LiteSlaveEnvConfig)::get(this,"","Axi4LiteSlaveEnvConfig",axi4LiteSlaveEnvConfig)) begin
    `uvm_fatal("FATAL_SLAVE_ENV_AGENT_CONFIG", $sformatf("Couldn't get the Slave_env_agent_config from config_db"))
  end
  
  axi4LiteSlaveWriteAgentConfig = new[axi4LiteSlaveEnvConfig.no_of_slaves];
  foreach(axi4LiteSlaveWriteAgentConfig[i]) begin
    if(!uvm_config_db#(Axi4LiteSlaveWriteAgentConfig)::get(this,"",$sformatf("Axi4LiteSlaveWriteAgentConfig[%0d]",i),axi4LiteSlaveWriteAgentConfig[i])) begin
      `uvm_fatal("FATAL_SLAVE_WRITE_AGENT_CONFIG", $sformatf("Couldn't get the Axi4LiteSlaveWriteAgentConfig[%0d] from config_db",i))
    end
  end

  axi4LiteSlaveReadAgentConfig = new[axi4LiteSlaveEnvConfig.no_of_slaves];
  foreach(axi4LiteSlaveReadAgentConfig[i]) begin
    if(!uvm_config_db #(Axi4LiteSlaveReadAgentConfig)::get(this,"",$sformatf("Axi4LiteSlaveReadAgentConfig[%0d]",i),axi4LiteSlaveReadAgentConfig[i])) begin
      `uvm_fatal("FATAL_SLAVE_READ_AGENT_CONFIG", $sformatf("Couldn't get the Axi4LiteSlaveReadAgentConfig[%0d] from config_db",i))
    end
  end

  axi4LiteSlaveWriteAgent = new[axi4LiteSlaveEnvConfig.no_of_slaves];
  foreach(axi4LiteSlaveWriteAgent[i]) begin
    axi4LiteSlaveWriteAgent[i]=Axi4LiteSlaveWriteAgent::type_id::create($sformatf("axi4LiteSlaveWriteAgent[%0d]",i),this);
  end

  axi4LiteSlaveReadAgent = new[axi4LiteSlaveEnvConfig.no_of_slaves];
  foreach(axi4LiteSlaveReadAgent[i]) begin
    axi4LiteSlaveReadAgent[i]=Axi4LiteSlaveReadAgent::type_id::create($sformatf("axi4LiteSlaveReadAgent[%0d]",i),this);
  end

  if(axi4LiteSlaveEnvConfig.hasSlaveVirtualSequencer) begin
    axi4LiteSlaveVirtualSequencer = Axi4LiteSlaveVirtualSequencer::type_id::create("axi4LiteSlaveVirtualSequencer",this);
  end

  foreach(axi4LiteSlaveWriteAgent[i]) begin
    axi4LiteSlaveWriteAgent[i].axi4LiteSlaveWriteAgentConfig = axi4LiteSlaveWriteAgentConfig[i];
  end
  
  foreach(axi4LiteSlaveReadAgent[i]) begin
    axi4LiteSlaveReadAgent[i].axi4LiteSlaveReadAgentConfig = axi4LiteSlaveReadAgentConfig[i];
  end
  
endfunction : build_phase


function void Axi4LiteSlaveEnv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(axi4LiteSlaveEnvConfig.hasSlaveVirtualSequencer) begin
    foreach(axi4LiteSlaveWriteAgent[i]) begin
      axi4LiteSlaveVirtualSequencer.axi4LiteSlaveWriteSequencer = axi4LiteSlaveWriteAgent[i].axi4LiteSlaveWriteSequencer;
    end
    foreach(axi4LiteSlaveReadAgent[i]) begin
      axi4LiteSlaveVirtualSequencer.axi4LiteSlaveReadSequencer = axi4LiteSlaveReadAgent[i].axi4LiteSlaveReadSequencer;
    end
  end

  foreach(axi4LiteSlaveWriteAgent[i]) begin
    axi4LiteSlaveWriteAgent[i].axi4LiteSlaveWriteAgentAddressAnalysisPort.connect(axi4LiteSlaveWriteEnvAddressAnalysisPort);
    axi4LiteSlaveWriteAgent[i].axi4LiteSlaveWriteAgentDataAnalysisPort.connect(axi4LiteSlaveWriteEnvDataAnalysisPort);
    axi4LiteSlaveWriteAgent[i].axi4LiteSlaveWriteAgentResponseAnalysisPort.connect(axi4LiteSlaveWriteEnvResponseAnalysisPort);
  end

  foreach(axi4LiteSlaveReadAgent[i]) begin
    axi4LiteSlaveReadAgent[i].axi4LiteSlaveReadAgentAddressAnalysisPort.connect(axi4LiteSlaveReadEnvAddressAnalysisPort);
    axi4LiteSlaveReadAgent[i].axi4LiteSlaveReadAgentDataAnalysisPort.connect(axi4LiteSlaveReadEnvDataAnalysisPort);
  end

endfunction : connect_phase

`endif

