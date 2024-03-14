`ifndef AXI4LITEMASTERENV_INCLUDED_
`define AXI4LITEMASTERENV_INCLUDED_

// Environment contains slave_agent_top,master_agent_top and Axi4LiteVirtualMasterSequencer

class Axi4LiteMasterEnv extends uvm_env;
  `uvm_component_utils(Axi4LiteMasterEnv)
  
  Axi4LiteMasterEnvConfig axi4LiteMasterEnvConfig;

  Axi4LiteMasterWriteAgent axi4LiteMasterWriteAgent[];
  Axi4LiteMasterReadAgent axi4LiteMasterReadAgent[];

  Axi4LiteMasterVirtualSequencer axi4LiteMasterVirtualSequencer;

  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig[];
  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig[];

  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4LiteMasterWriteEnvAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4LiteMasterWriteEnvDataAnalysisPort;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4LiteMasterWriteEnvResponseAnalysisPort;
  uvm_analysis_port#(Axi4LiteMasterReadTransaction) axi4LiteMasterReadEnvAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteMasterReadTransaction) axi4LiteMasterReadEnvDataAnalysisPort;

  extern function new(string name = "Axi4LiteMasterEnv", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteMasterEnv

function Axi4LiteMasterEnv::new(string name = "Axi4LiteMasterEnv",uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterWriteEnvAddressAnalysisPort  = new("axi4LiteMasterWriteEnvAddressAnalysisPort",this);
  axi4LiteMasterWriteEnvDataAnalysisPort     = new("axi4LiteMasterWriteEnvDataAnalysisPort",this);
  axi4LiteMasterWriteEnvResponseAnalysisPort = new("axi4LiteMasterWriteEnvResponseAnalysisPort",this);
  axi4LiteMasterReadEnvAddressAnalysisPort  = new("axi4LiteMasterReadEnvAddressAnalysisPort",this);
  axi4LiteMasterReadEnvDataAnalysisPort     = new("axi4LiteMasterReadEnvDataAnalysisPort",this);
endfunction : new

function void Axi4LiteMasterEnv::build_phase(uvm_phase phase);
  super.build_phase(phase);
 axi4LiteMasterEnvConfig = Axi4LiteMasterEnvConfig::type_id::create("axi4LiteMasterEnvConfig"); 
  
  if(!uvm_config_db #(Axi4LiteMasterEnvConfig)::get(this,"","Axi4LiteMasterEnvConfig",axi4LiteMasterEnvConfig)) begin
    `uvm_fatal("FATAL_MASTER_ENV_AGENT_CONFIG", $sformatf("Couldn't get the master_env_agent_config from config_db"))
  end

 axi4LiteMasterWriteAgentConfig = new[axi4LiteMasterEnvConfig.no_of_masters];
  foreach(axi4LiteMasterWriteAgentConfig[i]) begin
    if(!uvm_config_db#(Axi4LiteMasterWriteAgentConfig)::get(this,"",$sformatf("Axi4LiteMasterWriteAgentConfig[%0d]",i),axi4LiteMasterWriteAgentConfig[i])) begin
      `uvm_fatal("FATAL_MASTER_WRITE_AGENT_CONFIG", $sformatf("Couldn't get the Axi4LiteMasterWriteAgentConfig[%0d] from config_db",i))
    end
  end

  axi4LiteMasterReadAgentConfig = new[axi4LiteMasterEnvConfig.no_of_masters];
  foreach(axi4LiteMasterReadAgentConfig[i]) begin
    if(!uvm_config_db #(Axi4LiteMasterReadAgentConfig)::get(this,"",$sformatf("Axi4LiteMasterReadAgentConfig[%0d]",i),axi4LiteMasterReadAgentConfig[i])) begin
      `uvm_fatal("FATAL_MASTER_READ_AGENT_CONFIG", $sformatf("Couldn't get the Axi4LiteMasterReadAgentConfig[%0d] from config_db",i))
    end
  end

  axi4LiteMasterWriteAgent = new[axi4LiteMasterEnvConfig.no_of_masters];
  foreach(axi4LiteMasterWriteAgent[i]) begin
    axi4LiteMasterWriteAgent[i]=Axi4LiteMasterWriteAgent::type_id::create($sformatf("axi4LiteMasterWriteAgent[%0d]",i),this);
  end

  axi4LiteMasterReadAgent = new[axi4LiteMasterEnvConfig.no_of_masters];
  foreach(axi4LiteMasterReadAgent[i]) begin
    axi4LiteMasterReadAgent[i]=Axi4LiteMasterReadAgent::type_id::create($sformatf("axi4LiteMasterReadAgent[%0d]",i),this);
  end

  if(axi4LiteMasterEnvConfig.hasMasterVirtualSequencer) begin
    axi4LiteMasterVirtualSequencer = Axi4LiteMasterVirtualSequencer::type_id::create("axi4LiteVirtualMasterSequencer",this);
  end

  foreach(axi4LiteMasterWriteAgent[i]) begin
    axi4LiteMasterWriteAgent[i].axi4LiteMasterWriteAgentConfig = axi4LiteMasterWriteAgentConfig[i];
  end
  
  foreach(axi4LiteMasterReadAgent[i]) begin
    axi4LiteMasterReadAgent[i].axi4LiteMasterReadAgentConfig = axi4LiteMasterReadAgentConfig[i];
  end
  
endfunction : build_phase


function void Axi4LiteMasterEnv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(axi4LiteMasterEnvConfig.hasMasterVirtualSequencer) begin
    foreach(axi4LiteMasterWriteAgent[i]) begin
      axi4LiteMasterVirtualSequencer.axi4LiteMasterWriteSequencer = axi4LiteMasterWriteAgent[i].axi4LiteMasterWriteSequencer;
    end
    foreach(axi4LiteMasterReadAgent[i]) begin
     axi4LiteMasterVirtualSequencer.axi4LiteMasterReadSequencer = axi4LiteMasterReadAgent[i].axi4LiteMasterReadSequencer;
    end
  end

  foreach(axi4LiteMasterWriteAgent[i]) begin
    axi4LiteMasterWriteAgent[i].axi4LiteMasterWriteAgentAddressAnalysisPort.connect(axi4LiteMasterWriteEnvAddressAnalysisPort);
    axi4LiteMasterWriteAgent[i].axi4LiteMasterWriteAgentDataAnalysisPort.connect(axi4LiteMasterWriteEnvDataAnalysisPort);
    axi4LiteMasterWriteAgent[i].axi4LiteMasterWriteAgentResponseAnalysisPort.connect(axi4LiteMasterWriteEnvResponseAnalysisPort);
  end

  foreach(axi4LiteMasterReadAgent[i]) begin
    axi4LiteMasterReadAgent[i].axi4LiteMasterReadAgentAddressAnalysisPort.connect(axi4LiteMasterReadEnvAddressAnalysisPort);
    axi4LiteMasterReadAgent[i].axi4LiteMasterReadAgentDataAnalysisPort.connect(axi4LiteMasterReadEnvDataAnalysisPort);
  end

endfunction : connect_phase

`endif

