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
  extern virtual function void setupAxi4LiteSlaveEnvConfig();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : Axi4LiteBaseTest

function Axi4LiteBaseTest::new(string name = "Axi4LiteBaseTest",uvm_component parent = null);
  super.new(name, parent);
endfunction : new


function void Axi4LiteBaseTest::build_phase(uvm_phase phase);
  super.build_phase(phase);

  setupAxi4LiteEnvConfig();
  axi4LiteEnv =  Axi4LiteEnv::type_id::create("axi4LiteEnv",this);
endfunction : build_phase


//--------------------------------------------------------------------------------------------
// Function: setupAxi4LiteEnvConfig
// Setup the environment configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void Axi4LiteBaseTest:: setupAxi4LiteEnvConfig();
  axi4LiteEnvConfig = Axi4LiteEnvConfig::type_id::create("axi4LiteEnvConfig");
 
  axi4LiteEnvConfig.hasScoreboard = 1;
  axi4LiteEnvConfig.hasVirtualSequencer = 1;
  axi4LiteEnvConfig.no_of_masters = NO_OF_MASTERS;
  axi4LiteEnvConfig.no_of_slaves = NO_OF_SLAVES;

  // Setup the axi4_master agent cfg 
   setupAxi4LiteMasterEnvConfig();
  
  // Setup the axi4_slave agent cfg 
   setupAxi4LiteSlaveEnvConfig();

  // set method for axi4_env_cfg
  uvm_config_db #(Axi4LiteEnvConfig)::set(this,"*","Axi4LiteEnvConfig",axi4LiteEnvConfig);
  `uvm_info(get_type_name(),$sformatf("\nAxi4LiteEnvConfig\n%s",axi4LiteEnvConfig.sprint()),UVM_LOW);
endfunction: setupAxi4LiteEnvConfig


function void Axi4LiteBaseTest::setupAxi4LiteMasterEnvConfig();
  axi4LiteEnvConfig.axi4LiteMasterEnvConfig = new[axi4LiteEnvConfig.no_of_masters];
  foreach(axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i])begin
    axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i] =
    Axi4LiteMasterEnvConfig::type_id::create($sformatf("axi4LiteMasterEnvConfig[%0d]",i));
  //  axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].is_active   = uvm_active_passive_enum'(UVM_ACTIVE);
  //  axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].has_coverage = 1; 
    uvm_config_db#(Axi4LiteMasterEnvConfig)::set(this,"*",$sformatf("Axi4LiteMasterEnvConfig[%0d]",i),axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i]);
   `uvm_info(get_type_name(),$sformatf("\nAXI4_MASTER_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].sprint()),UVM_LOW);
  end
/*
  for(int i =0; i<NO_OF_SLAVES; i++) begin
    if(i == 0) begin  
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_min_addr_range(i,0);
      local_min_address = axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_min_addr_range_array[i];
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_max_addr_range(i,2**(SLAVE_MEMORY_SIZE)-1 );
      local_max_address = axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_max_addr_range_array[i];
    end
    else begin
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_min_addr_range(i,local_max_address + SLAVE_MEMORY_GAP);
      local_min_address = axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_min_addr_range_array[i];
      axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_max_addr_range(i,local_max_address+ 2**(SLAVE_MEMORY_SIZE)-1 + 
                                                                      SLAVE_MEMORY_GAP);
      local_max_address = axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].master_max_addr_range_array[i];
    end
   `uvm_info(get_type_name(),$sformatf("\nAXI4_MASTER_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].sprint()),UVM_LOW);
  end*/
endfunction: setupAxi4LiteMasterEnvConfig


function void Axi4LiteBaseTest::setupAxi4LiteSlaveEnvConfig();
  axi4LiteEnvConfig.axi4LiteSlaveEnvConfig = new[axi4LiteEnvConfig.no_of_slaves];
  foreach(axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i])begin
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i] =
    Axi4LiteSlaveEnvConfig::type_id::create($sformatf("axi4LiteSlaveEnvConfig[%0d]",i));
   /* axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i].slave_id = i;
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i].min_address = axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].
                                                           master_min_addr_range_array[i];
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i].max_address = axi4LiteEnvConfig.axi4LiteMasterEnvConfig[i].
                                                           master_max_addr_range_array[i];
    if(SLAVE_AGENT_ACTIVE === 1) begin
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i].is_active = uvm_active_passive_enum'(UVM_ACTIVE);
    end
    else begin
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i].is_active = uvm_active_passive_enum'(UVM_PASSIVE);
    end 
    axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i].has_coverage = 1; 
    */
    uvm_config_db #(Axi4LiteSlaveEnvConfig)::set(this,"*",$sformatf("Axi4LiteSlaveEnvConfig[%0d]",i), axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i]);   
   `uvm_info(get_type_name(),$sformatf("\nAXI4_SLAVE_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4LiteSlaveEnvConfig[i].sprint()),UVM_LOW);
  end
endfunction: setupAxi4LiteSlaveEnvConfig


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

