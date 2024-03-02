`ifndef AXI4LITESLAVEENV_INCLUDED_
`define AXI4LITESLAVEENV_INCLUDED_

class Axi4LiteSlaveEnv extends uvm_env;
  `uvm_component_utils(Axi4LiteSlaveEnv)
  
  Axi4LiteSlaveEnvConfig axi4LiteSlaveEnvConfig;

  Axi4LiteSlaveWriteAgent axi4LiteSlaveWriteAgent[];
  Axi4LiteSlaveReadAgent axi4LiteSlaveReadAgent[];

  Axi4LiteVirtualSlaveSequencer axi4LiteVirtualSlaveSequencer;

  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig[];
  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig[];

  extern function new(string name = "Axi4LiteSlaveEnv", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteSlaveEnv

function Axi4LiteSlaveEnv::new(string name = "Axi4LiteSlaveEnv",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteSlaveEnv::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db #(Axi4LiteSlaveEnvConfig)::get(this,"","Axi4LiteSlaveEnvConfig",axi4LiteSlaveEnvConfig)) begin
    `uvm_fatal("FATAL_SLAVE_ENV_AGENT_CONFIG", $sformatf("Couldn't get the master_env_agent_config from config_db"))
  end
  
  axi4LiteSlaveWriteAgentConfig = new[axi4LiteSlaveEnvConfig.no_of_masters];
  foreach(axi4LiteSlaveWriteAgentConfig[i]) begin
    if(!uvm_config_db#(Axi4LiteSlaveWriteAgentConfig)::get(this,"",$sformatf("Axi4LiteSlaveWriteAgentConfig[%0d]",i),axi4LiteSlaveWriteAgentConfig[i])) begin
      `uvm_fatal("FATAL_SLAVE_WRITE_AGENT_CONFIG", $sformatf("Couldn't get the Axi4LiteSlaveWriteAgentConfig[%0d] from config_db",i))
    end
  end

  axi4LiteSlaveReadAgentConfig = new[axi4LiteSlaveEnvConfig.no_of_masters];
  foreach(axi4LiteSlaveReadAgentConfig[i]) begin
    if(!uvm_config_db #(Axi4LiteSlaveReadAgentConfig)::get(this,"",$sformatf("Axi4LiteSlaveReadAgentConfig[%0d]",i),axi4LiteSlaveReadAgentConfig[i])) begin
      `uvm_fatal("FATAL_SLAVE_READ_AGENT_CONFIG", $sformatf("Couldn't get the Axi4LiteSlaveReadAgentConfig[%0d] from config_db",i))
    end
  end

  axi4LiteSlaveWriteAgent = new[axi4LiteSlaveEnvConfig.no_of_masters];
  foreach(axi4LiteSlaveWriteAgent[i]) begin
    axi4LiteSlaveWriteAgent[i]=Axi4LiteSlaveWriteAgent::type_id::create($sformatf("axi4LiteSlaveWriteAgent[%0d]",i),this);
  end

  axi4LiteSlaveReadAgent = new[axi4LiteSlaveEnvConfig.no_of_masters];
  foreach(axi4LiteSlaveReadAgent[i]) begin
    axi4LiteSlaveReadAgent[i]=Axi4LiteSlaveReadAgent::type_id::create($sformatf("axi4LiteSlaveReadAgent[%0d]",i),this);
  end
  
  if(axi4LiteSlaveEnvConfig.hasVirtualSequencer) begin
    axi4LiteVirtualSlaveSequencer = Axi4LiteVirtualSlaveSequencer::type_id::create("axi4LiteVirtualSlaveSequencer",this);
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

  if(axi4LiteSlaveEnvConfig.hasVirtualSequencer) begin
    foreach(axi4LiteSlaveWriteAgent[i]) begin
      axi4LiteVirtualSlaveSequencer.axi4LiteSlaveWriteSequencer = axi4LiteSlaveWriteAgent[i].axi4LiteSlaveWriteSequencer;
    end
    foreach(axi4LiteSlaveReadAgent[i]) begin
      axi4LiteVirtualSlaveSequencer.axi4LiteSlaveReadSequencer = axi4LiteSlaveReadAgent[i].axi4LiteSlaveReadSequencer;
    end
  end
 /* 
  foreach(axi4LiteSlaveWriteAgent[i]) begin
    axi4LiteSlaveWriteAgent[i].axi4LiteSlaveMonitorProxy.axi4LiteSlaveReadAddressAnalysisPort.connect(axi4_scoreboard_h.axi4_master_read_address_analysis_fifo.analysis_export);
    axi4LiteSlaveWriteAgent[i].axi4_master_mon_proxy_h.axi4_master_read_data_analysis_port.connect(axi4_scoreboard_h.axi4_master_read_data_analysis_fifo.analysis_export);
    axi4LiteSlaveWriteAgent[i].axi4_master_mon_proxy_h.axi4_master_write_address_analysis_port.connect(axi4_scoreboard_h.axi4_master_write_address_analysis_fifo.analysis_export);
    axi4LiteSlaveWriteAgent[i].axi4_master_mon_proxy_h.axi4_master_write_data_analysis_port.connect(axi4_scoreboard_h.axi4_master_write_data_analysis_fifo.analysis_export);
    axi4LiteSlaveWriteAgent[i].axi4_master_mon_proxy_h.axi4_master_write_response_analysis_port.connect(axi4_scoreboard_h.axi4_master_write_response_analysis_fifo.analysis_export);
  end

  foreach(axi4LiteSlaveReadAgent[i]) begin
    axi4LiteSlaveReadAgent[i].axi4_slave_mon_proxy_h.axi4_slave_write_address_analysis_port.connect(axi4_scoreboard_h.axi4_slave_write_address_analysis_fifo.analysis_export);
    axi4LiteSlaveReadAgent[i].axi4_slave_mon_proxy_h.axi4_slave_write_data_analysis_port.connect(axi4_scoreboard_h.axi4_slave_write_data_analysis_fifo.analysis_export);
    axi4LiteSlaveReadAgent[i].axi4_slave_mon_proxy_h.axi4_slave_write_response_analysis_port.connect(axi4_scoreboard_h.axi4_slave_write_response_analysis_fifo.analysis_export);
    axi4LiteSlaveReadAgent[i].axi4_slave_mon_proxy_h.axi4_slave_read_address_analysis_port.connect(axi4_scoreboard_h.axi4_slave_read_address_analysis_fifo.analysis_export);
    axi4LiteSlaveReadAgent[i].axi4_slave_mon_proxy_h.axi4_slave_read_data_analysis_port.connect(axi4_scoreboard_h.axi4_slave_read_data_analysis_fifo.analysis_export);
  end */
endfunction : connect_phase

`endif

