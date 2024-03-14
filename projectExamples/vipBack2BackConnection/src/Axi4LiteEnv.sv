`ifndef AXI4LITEENV_INCLUDED_
`define AXI4LITEENV_INCLUDED_

class Axi4LiteEnv extends uvm_env;
  `uvm_component_utils(Axi4LiteEnv)
  
  Axi4LiteEnvConfig axi4LiteEnvConfig;

  Axi4LiteMasterEnv axi4LiteMasterEnv;
  Axi4LiteSlaveEnv axi4LiteSlaveEnv;

  Axi4LiteVirtualSequencer axi4LiteVirtualSequencer;

  Axi4LiteMasterEnvConfig axi4LiteMasterEnvConfig;
  Axi4LiteSlaveEnvConfig axi4LiteSlaveEnvConfig;

  Axi4LiteScoreboard axi4LiteScoreboard;

  extern function new(string name = "Axi4LiteEnv", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteEnv

function Axi4LiteEnv::new(string name = "Axi4LiteEnv",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteEnv::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db #(Axi4LiteEnvConfig)::get(this,"","Axi4LiteEnvConfig",axi4LiteEnvConfig)) begin
    `uvm_fatal("FATAL_ENV_CONFIG", $sformatf("Couldn't get the env_config from config_db"))
  end

  axi4LiteMasterEnvConfig = Axi4LiteMasterEnvConfig::type_id::create("axi4LiteMasterEnvConfig");
   if(!uvm_config_db #(Axi4LiteMasterEnvConfig)::get(this,"","Axi4LiteMasterEnvConfig",axi4LiteMasterEnvConfig)) 
   `uvm_fatal("FATAL_MASTER_ENV_CONFIG","Couldn't get the Axi4LiteMasterEnvConfig from config_db")

    axi4LiteSlaveEnvConfig = Axi4LiteSlaveEnvConfig::type_id::create("axi4LiteSlaveEnvConfig");
    if(!uvm_config_db#(Axi4LiteSlaveEnvConfig)::get(this,"","Axi4LiteSlaveEnvConfig",axi4LiteSlaveEnvConfig)) 
   `uvm_fatal("FATAL_SLAVE_ENV_CONFIG","Couldn't get the Axi4LiteSlaveEnvConfig from config_db")

    if(axi4LiteEnvConfig.hasVirtualSequencer) begin
    axi4LiteVirtualSequencer = Axi4LiteVirtualSequencer::type_id::create("axi4LiteVirtualSequencer",this);
  end

   axi4LiteMasterEnv = Axi4LiteMasterEnv::type_id::create("axi4LiteMasterEnv",this); 
   axi4LiteSlaveEnv = Axi4LiteSlaveEnv::type_id::create("axi4LiteSlaveEnv",this); 

   axi4LiteMasterEnv.axi4LiteMasterEnvConfig = axi4LiteMasterEnvConfig;
   axi4LiteSlaveEnv.axi4LiteSlaveEnvConfig = axi4LiteSlaveEnvConfig;

   if(axi4LiteEnvConfig.hasScoreboard) begin
     axi4LiteScoreboard = Axi4LiteScoreboard::type_id::create("axi4LiteScoreboard",this); 
   end
  
endfunction : build_phase

function void Axi4LiteEnv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(axi4LiteEnvConfig.hasVirtualSequencer) begin
     axi4LiteVirtualSequencer.axi4LiteMasterVirtualSequencer = axi4LiteMasterEnv.axi4LiteMasterVirtualSequencer;
     axi4LiteVirtualSequencer.axi4LiteSlaveVirtualSequencer = axi4LiteSlaveEnv.axi4LiteSlaveVirtualSequencer;
  end

    axi4LiteMasterEnv.axi4LiteMasterWriteEnvAddressAnalysisPort.connect(axi4LiteScoreboard.axi4LiteMasterWriteEnvAddressFIFO.analysis_export);
    axi4LiteMasterEnv.axi4LiteMasterWriteEnvDataAnalysisPort.connect(axi4LiteScoreboard.axi4LiteMasterWriteEnvDataFIFO.analysis_export);
    axi4LiteMasterEnv.axi4LiteMasterWriteEnvResponseAnalysisPort.connect(axi4LiteScoreboard.axi4LiteMasterWriteEnvResponseFIFO.analysis_export);
    axi4LiteMasterEnv.axi4LiteMasterReadEnvAddressAnalysisPort.connect(axi4LiteScoreboard.axi4LiteMasterReadEnvAddressFIFO.analysis_export);
    axi4LiteMasterEnv.axi4LiteMasterReadEnvDataAnalysisPort.connect(axi4LiteScoreboard.axi4LiteMasterReadEnvDataFIFO.analysis_export);

    axi4LiteSlaveEnv.axi4LiteSlaveWriteEnvAddressAnalysisPort.connect(axi4LiteScoreboard.axi4LiteSlaveWriteEnvAddressFIFO.analysis_export);
    axi4LiteSlaveEnv.axi4LiteSlaveWriteEnvDataAnalysisPort.connect(axi4LiteScoreboard.axi4LiteSlaveWriteEnvDataFIFO.analysis_export);
    axi4LiteSlaveEnv.axi4LiteSlaveWriteEnvResponseAnalysisPort.connect(axi4LiteScoreboard.axi4LiteSlaveWriteEnvResponseFIFO.analysis_export);
    axi4LiteSlaveEnv.axi4LiteSlaveReadEnvAddressAnalysisPort.connect(axi4LiteScoreboard.axi4LiteSlaveReadEnvAddressFIFO.analysis_export);
    axi4LiteSlaveEnv.axi4LiteSlaveReadEnvDataAnalysisPort.connect(axi4LiteScoreboard.axi4LiteSlaveReadEnvDataFIFO.analysis_export);

endfunction : connect_phase

`endif

