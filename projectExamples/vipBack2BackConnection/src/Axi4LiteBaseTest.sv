`ifndef AXI4LITEBASETEST_INCLUDED_
`define AXI4LITEBASETEST_INCLUDED_

class Axi4LiteBaseTest extends uvm_test; 
  `uvm_component_utils(Axi4LiteBaseTest)

  Axi4LiteEnvConfig axi4LiteEnvConfig;
  Axi4LiteEnv axi4LiteEnv;

  extern function new(string name = "Axi4LiteBaseTest", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void setupAxi4LiteEnvConfig();
/*  extern virtual function void setup_axi4_master_agent_cfg();
  extern virtual function void setup_axi4_slave_agent_cfg();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
*/  extern virtual task run_phase(uvm_phase phase);

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
  // setup_axi4_master_agent_cfg();
  
  // Setup the axi4_slave agent cfg 
  // setup_axi4_slave_agent_cfg();

  // set method for axi4_env_cfg
  uvm_config_db #(Axi4LiteEnvConfig)::set(this,"*","Axi4LiteEnvConfig",axi4LiteEnvConfig);
  `uvm_info(get_type_name(),$sformatf("\nAxi4LiteEnvConfig\n%s",axi4LiteEnvConfig.sprint()),UVM_LOW);
endfunction: setupAxi4LiteEnvConfig
/*
//--------------------------------------------------------------------------------------------
// Function: setup_axi4_master_agent_cfg
// Setup the axi4_master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void Axi4LiteBaseTest::setup_axi4_master_agent_cfg();
  bit [63:0]local_min_address;
  bit [63:0]local_max_address;
  axi4LiteEnvConfig.axi4_master_agent_cfg_h = new[axi4LiteEnvConfig.no_of_masters];
  foreach(axi4LiteEnvConfig.axi4_master_agent_cfg_h[i])begin
    axi4LiteEnvConfig.axi4_master_agent_cfg_h[i] =
    axi4_master_agent_config::type_id::create($sformatf("axi4_master_agent_cfg_h[%0d]",i));
    axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].is_active   = uvm_active_passive_enum'(UVM_ACTIVE);
    axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].has_coverage = 1; 
    uvm_config_db#(axi4_master_agent_config)::set(this,"*env*",$sformatf("axi4_master_agent_config[%0d]",i),axi4LiteEnvConfig.axi4_master_agent_cfg_h[i]);
  end

  for(int i =0; i<NO_OF_SLAVES; i++) begin
    if(i == 0) begin  
      axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_min_addr_range(i,0);
      local_min_address = axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_min_addr_range_array[i];
      axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_max_addr_range(i,2**(SLAVE_MEMORY_SIZE)-1 );
      local_max_address = axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_max_addr_range_array[i];
    end
    else begin
      axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_min_addr_range(i,local_max_address + SLAVE_MEMORY_GAP);
      local_min_address = axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_min_addr_range_array[i];
      axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_max_addr_range(i,local_max_address+ 2**(SLAVE_MEMORY_SIZE)-1 + 
                                                                      SLAVE_MEMORY_GAP);
      local_max_address = axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].master_max_addr_range_array[i];
    end
   `uvm_info(get_type_name(),$sformatf("\nAXI4_MASTER_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].sprint()),UVM_LOW);
  end
endfunction: setup_axi4_master_agent_cfg

//--------------------------------------------------------------------------------------------
// Function: setup_axi4_slave_agents_cfg
// Setup the axi4_slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void Axi4LiteBaseTest::setup_axi4_slave_agent_cfg();
  axi4LiteEnvConfig.axi4_slave_agent_cfg_h = new[axi4LiteEnvConfig.no_of_slaves];
  foreach(axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i])begin
    axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i] =
    axi4_slave_agent_config::type_id::create($sformatf("axi4_slave_agent_cfg_h[%0d]",i));
    axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i].slave_id = i;
    axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i].min_address = axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].
                                                           master_min_addr_range_array[i];
    axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i].max_address = axi4LiteEnvConfig.axi4_master_agent_cfg_h[i].
                                                           master_max_addr_range_array[i];
    if(SLAVE_AGENT_ACTIVE === 1) begin
    axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i].is_active = uvm_active_passive_enum'(UVM_ACTIVE);
    end
    else begin
    axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i].is_active = uvm_active_passive_enum'(UVM_PASSIVE);
    end 
    axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i].has_coverage = 1; 
    
    uvm_config_db #(axi4_slave_agent_config)::set(this,"*env*",$sformatf("axi4_slave_agent_config[%0d]",i), axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i]);   
   `uvm_info(get_type_name(),$sformatf("\nAXI4_SLAVE_CONFIG[%0d]\n%s",i,axi4LiteEnvConfig.axi4_slave_agent_cfg_h[i].sprint()),UVM_LOW);
  end
endfunction: setup_axi4_slave_agent_cfg

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// Used for printing the testbench topology
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
/*
function void Axi4LiteBaseTest::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
  uvm_test_done.set_drain_time(this,3000ns);
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation 
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
*/
task Axi4LiteBaseTest::run_phase(uvm_phase phase);

  phase.raise_objection(this, "Axi4LiteBaseTest");

  `uvm_info(get_type_name(), $sformatf("Inside BASE_TEST"), UVM_NONE);
  super.run_phase(phase);
  #100;
  `uvm_info(get_type_name(), $sformatf("Done BASE_TEST"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase

`endif

