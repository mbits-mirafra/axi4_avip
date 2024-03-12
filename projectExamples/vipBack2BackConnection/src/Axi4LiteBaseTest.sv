`ifndef AXI4LITEBASETEST_INCLUDED_
`define AXI4LITEBASETEST_INCLUDED_

class Axi4LiteBaseTest extends uvm_test; 
  `uvm_component_utils(Axi4LiteBaseTest)

  Axi4LiteEnvConfig axi4LiteEnvConfig;
  Axi4LiteEnv axi4LiteEnv;

  extern function new(string name = "Axi4LiteBaseTest", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void setupAxi4LiteEnvConfig();
  extern virtual function void setupAxi4LiteMasterEnvConfig();
  extern virtual function void setupAxi4LiteMasterWriteAgentConfig();
  extern virtual function void setupAxi4LiteMasterReadAgentConfig();
  extern virtual function void setupAxi4LiteSlaveEnvConfig();
  extern virtual function void setupAxi4LiteSlaveWriteAgentConfig();
  extern virtual function void setupAxi4LiteSlaveReadAgentConfig();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteBaseTest

function Axi4LiteBaseTest::new(string name = "Axi4LiteBaseTest",uvm_component parent = null);
  super.new(name, parent);
endfunction : new


function void Axi4LiteBaseTest::build_phase(uvm_phase phase);
  super.build_phase(phase);

  setupAxi4LiteEnvConfig();
  setupAxi4LiteMasterEnvConfig();
  setupAxi4LiteSlaveEnvConfig();

  axi4LiteEnv =  Axi4LiteEnv::type_id::create("axi4LiteEnv",this);
endfunction : build_phase


function void Axi4LiteBaseTest:: setupAxi4LiteEnvConfig();
  axi4LiteEnvConfig = Axi4LiteEnvConfig::type_id::create("axi4LiteEnvConfig");
 
  axi4LiteEnvConfig.hasScoreboard = 1;
  axi4LiteEnvConfig.hasVirtualSequencer = 1;
  axi4LiteEnvConfig.no_of_masters = NO_OF_MASTERS;
  axi4LiteEnvConfig.no_of_slaves = NO_OF_SLAVES;

  setupAxi4LiteMasterEnvConfig();
  setupAxi4LiteSlaveEnvConfig();
  uvm_config_db #(Axi4LiteEnvConfig)::set(this,"*","Axi4LiteEnvConfig",axi4LiteEnvConfig);
  `uvm_info(get_type_name(),$sformatf("\nAxi4LiteEnvConfig\n%s",axi4LiteEnvConfig.sprint()),UVM_LOW);
endfunction: setupAxi4LiteEnvConfig

function void Axi4LiteBaseTest::setupAxi4LiteMasterEnvConfig();
    axi4LiteEnvConfig.axi4LiteMasterEnvConfig =
    Axi4LiteMasterEnvConfig::type_id::create("axi4LiteMasterEnvConfig");

    axi4LiteEnvConfig.axi4LiteMasterEnvConfig.hasMasterVirtualSequencer = 1;
    axi4LiteEnvConfig.axi4LiteMasterEnvConfig.no_of_masters = NO_OF_MASTERS;
    uvm_config_db#(Axi4LiteMasterEnvConfig)::set(this,"*","Axi4LiteMasterEnvConfig",axi4LiteEnvConfig.axi4LiteMasterEnvConfig);
   `uvm_info(get_type_name(),$sformatf("\nAXI4_MASTER_ENV_CONFIG\n%s",axi4LiteEnvConfig.axi4LiteMasterEnvConfig.sprint()),UVM_LOW);
    setupAxi4LiteMasterWriteAgentConfig();
    setupAxi4LiteMasterReadAgentConfig();
endfunction: setupAxi4LiteMasterEnvConfig

function void Axi4LiteBaseTest::setupAxi4LiteMasterWriteAgentConfig();
    axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterWriteAgentConfig = new[axi4LiteEnvConfig.no_of_masters];
    foreach(axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterWriteAgentConfig[i]) begin
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterWriteAgentConfig[i] = 
      Axi4LiteMasterWriteAgentConfig::type_id::create($sformatf("axi4LiteMasterWriteAgentConfig[%0d]",i));
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterWriteAgentConfig[i].isActive = uvm_active_passive_enum'(UVM_ACTIVE);
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterWriteAgentConfig[i].hasCoverage = 1;
    
      uvm_config_db#(Axi4LiteMasterWriteAgentConfig)::set(this,"*",$sformatf("Axi4LiteMasterWriteAgentConfig[%0d]",i),axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterWriteAgentConfig[i]);
   `uvm_info(get_type_name(),$sformatf("\nAXI4LITE_MASTER_WRITE_AGENT_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterWriteAgentConfig[i].sprint()),UVM_LOW);
 end
endfunction

function void Axi4LiteBaseTest::setupAxi4LiteMasterReadAgentConfig();
    axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterReadAgentConfig = new[axi4LiteEnvConfig.no_of_masters];
    foreach(axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterReadAgentConfig[i]) begin
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterReadAgentConfig[i] = 
      Axi4LiteMasterReadAgentConfig::type_id::create($sformatf("axi4LiteMasterReadAgentConfig[%0d]",i));
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterReadAgentConfig[i].isActive = uvm_active_passive_enum'(UVM_ACTIVE);
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterReadAgentConfig[i].hasCoverage = 1;
   
      uvm_config_db#(Axi4LiteMasterReadAgentConfig)::set(this,"*",$sformatf("Axi4LiteMasterReadAgentConfig[%0d]",i),axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterReadAgentConfig[i]);
   `uvm_info(get_type_name(),$sformatf("\nAXI4LITE_MASTER_READ_AGENT_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4LiteMasterEnvConfig.axi4LiteMasterReadAgentConfig[i].sprint()),UVM_LOW);
end
endfunction

function void Axi4LiteBaseTest::setupAxi4LiteSlaveEnvConfig();
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig =
    Axi4LiteSlaveEnvConfig::type_id::create("axi4LiteSlaveEnvConfig");

    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.hasSlaveVirtualSequencer = 1;
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.no_of_slaves = NO_OF_SLAVES;
    uvm_config_db#(Axi4LiteSlaveEnvConfig)::set(this,"*","Axi4LiteSlaveEnvConfig",axi4LiteEnvConfig.axi4LiteSlaveEnvConfig);
   `uvm_info(get_type_name(),$sformatf("\nAXI4_SLAVE_ENV_CONFIG\n%s",axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.sprint()),UVM_LOW);
   setupAxi4LiteSlaveWriteAgentConfig();
   setupAxi4LiteSlaveReadAgentConfig();
endfunction: setupAxi4LiteSlaveEnvConfig


function void Axi4LiteBaseTest::setupAxi4LiteSlaveWriteAgentConfig();
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveWriteAgentConfig = new[axi4LiteEnvConfig.no_of_slaves];
    foreach(axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveWriteAgentConfig[i]) begin
      axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveWriteAgentConfig[i] = 
      Axi4LiteSlaveWriteAgentConfig::type_id::create($sformatf("axi4LiteSlaveWriteAgentConfig[%0d]",i));
      axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveWriteAgentConfig[i].isActive = uvm_active_passive_enum'(UVM_ACTIVE);
      axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveWriteAgentConfig[i].hasCoverage = 1;
   
      uvm_config_db#(Axi4LiteSlaveWriteAgentConfig)::set(this,"*",$sformatf("Axi4LiteSlaveWriteAgentConfig[%0d]",i),axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveWriteAgentConfig[i]);
   `uvm_info(get_type_name(),$sformatf("\nAXI4LITE_SLAVE_WRITE_AGENT_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveWriteAgentConfig[i].sprint()),UVM_LOW);
end
endfunction

function void Axi4LiteBaseTest::setupAxi4LiteSlaveReadAgentConfig();
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveReadAgentConfig = new[axi4LiteEnvConfig.no_of_slaves];
    foreach(axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveReadAgentConfig[i]) begin
      axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveReadAgentConfig[i] = 
      Axi4LiteSlaveReadAgentConfig::type_id::create($sformatf("axi4LiteSlaveReadAgentConfig[%0d]",i));
      axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveReadAgentConfig[i].isActive = uvm_active_passive_enum'(UVM_ACTIVE);
      axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveReadAgentConfig[i].hasCoverage = 1;

      uvm_config_db#(Axi4LiteSlaveReadAgentConfig)::set(this,"*",$sformatf("Axi4LiteSlaveReadAgentConfig[%0d]",i),axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveReadAgentConfig[i]);
   `uvm_info(get_type_name(),$sformatf("\nAXI4LITE_SLAVE_READ_AGENT_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4LiteSlaveEnvConfig.axi4LiteSlaveReadAgentConfig[i].sprint()),UVM_LOW);
  end
endfunction

function void Axi4LiteBaseTest::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
  uvm_test_done.set_drain_time(this,3000ns);
endfunction : end_of_elaboration_phase


task Axi4LiteBaseTest::run_phase(uvm_phase phase);

  phase.raise_objection(this, "Axi4LiteBaseTest");

  `uvm_info(get_type_name(), $sformatf("Inside BASE_TEST"), UVM_NONE);
  super.run_phase(phase);
  #100;
  `uvm_info(get_type_name(), $sformatf("Done BASE_TEST"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase

`endif

