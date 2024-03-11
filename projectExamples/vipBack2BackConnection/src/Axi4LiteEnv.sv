`ifndef AXI4LITEENV_INCLUDED_
`define AXI4LITEENV_INCLUDED_

class Axi4LiteEnv extends uvm_env;
  `uvm_component_utils(Axi4LiteEnv)
  
  Axi4LiteEnvConfig axi4LiteEnvConfig;

  Axi4LiteMasterEnv axi4LiteMasterEnv[];
  Axi4LiteSlaveEnv axi4LiteSlaveEnv[];

  Axi4LiteVirtualSequencer axi4LiteVirtualSequencer;

  Axi4LiteMasterEnvConfig axi4LiteMasterEnvConfig[];
  Axi4LiteSlaveEnvConfig axi4LiteSlaveEnvConfig[];

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

  axi4LiteMasterEnvConfig = new[axi4LiteEnvConfig.no_of_masters];
  foreach(axi4LiteMasterEnvConfig[i]) begin
    if(!uvm_config_db#(Axi4LiteMasterEnvConfig)::get(this,"",$sformatf("Axi4LiteMasterEnvConfig[%0d]",i),axi4LiteMasterEnvConfig[i])) begin
      `uvm_fatal("FATAL_MASTER_ENV_CONFIG", $sformatf("Couldn't get the Axi4LiteMasterEnvConfig[%0d] from config_db",i))
    end
  end

  axi4LiteSlaveEnvConfig = new[axi4LiteEnvConfig.no_of_slaves];
  foreach(axi4LiteSlaveEnvConfig[i]) begin
    if(!uvm_config_db#(Axi4LiteSlaveEnvConfig)::get(this,"",$sformatf("Axi4LiteSlaveEnvConfig[%0d]",i),axi4LiteSlaveEnvConfig[i])) begin
      `uvm_fatal("FATAL_SLAVE_ENV_CONFIG", $sformatf("Couldn't get the Axi4LiteSlaveEnvConfig[%0d] from config_db",i))
    end
  end

  if(axi4LiteEnvConfig.hasVirtualSequencer) begin
    axi4LiteVirtualSequencer = Axi4LiteVirtualSequencer::type_id::create("axi4LiteVirtualSequencer",this);
  end

  axi4LiteMasterEnv = new[axi4LiteEnvConfig.no_of_masters];
  foreach(axi4LiteMasterEnv[i]) begin
    axi4LiteMasterEnv[i] = Axi4LiteMasterEnv::type_id::create($sformatf("axi4LiteMasterEnv[%0d]",i),this);
  end

  axi4LiteSlaveEnv = new[axi4LiteEnvConfig.no_of_slaves];
  foreach(axi4LiteSlaveEnv[i]) begin
    axi4LiteSlaveEnv[i] = Axi4LiteSlaveEnv::type_id::create($sformatf("axi4LiteSlaveEnv[%0d]",i),this);
  end

  foreach(axi4LiteMasterEnv[i]) begin
    axi4LiteMasterEnv[i].axi4LiteMasterEnvConfig = axi4LiteMasterEnvConfig[i];
  end
  
  foreach(axi4LiteSlaveEnv[i]) begin
    axi4LiteSlaveEnv[i].axi4LiteSlaveEnvConfig = axi4LiteSlaveEnvConfig[i];
  end
endfunction : build_phase


function void Axi4LiteEnv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(axi4LiteEnvConfig.hasVirtualSequencer) begin
    foreach(axi4LiteMasterEnv[i]) begin
      axi4LiteVirtualSequencer.axi4LiteMasterVirtualSequencer = axi4LiteMasterEnv[i].axi4LiteMasterVirtualSequencer;
    end

    foreach(axi4LiteSlaveEnv[i]) begin
      axi4LiteVirtualSequencer.axi4LiteSlaveVirtualSequencer = axi4LiteSlaveEnv[i].axi4LiteSlaveVirtualSequencer;
    end
  end
endfunction : connect_phase

`endif

