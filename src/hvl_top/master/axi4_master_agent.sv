`ifndef AXI4_MASTER_AGENT_INCLUDED_
`define AXI4_MASTER_AGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_master_agent
// This agent is a configurable with respect to configuration which can create active and passive components
// It contains testbench components like sequencer,driver_proxy and monitor_proxy for AXI4
//--------------------------------------------------------------------------------------------
class axi4_master_agent extends uvm_agent;
  `uvm_component_utils(axi4_master_agent)

  // Variable: axi4_master_agent_cfg_h
  // Declaring handle for master agent configuration class 
  axi4_master_agent_config axi4_master_agent_cfg_h;

  // Varible: axi4_master_write_seqr_h 
  // Handle for master write sequencer
  axi4_master_write_sequencer axi4_master_write_seqr_h;
  
  // Varible: axi4_master_read_seqr_h 
  // Handle for master read sequencer
  axi4_master_read_sequencer axi4_master_read_seqr_h;
  
  // Variable: axi4_master_drv_proxy_h
  // Creating a Handle for axi4_master driver proxy 
  axi4_master_driver_proxy axi4_master_drv_proxy_h;

  // Variable: axi4_master_mon_proxy_h
  // Declaring a handle for axi4_master monitor proxy 
  axi4_master_monitor_proxy axi4_master_mon_proxy_h;
  
  // Variable: axi4_master_coverage
  // Decalring a handle for axi4_master_coverage
  axi4_master_coverage axi4_master_cov_h;


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_agent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi4_master_agent

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_master_agent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_master_agent::new(string name = "axi4_master_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
//  Function: build_phase
//  Creates the required ports, gets the required configuration from config_db
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(axi4_master_agent_cfg_h.is_active == UVM_ACTIVE) begin
    axi4_master_drv_proxy_h=axi4_master_driver_proxy::type_id::create("axi4_master_drv_proxy_h",this);
    axi4_master_write_seqr_h=axi4_master_write_sequencer::type_id::create("axi4_master_write_seqr_h",this);
    axi4_master_read_seqr_h=axi4_master_read_sequencer::type_id::create("axi4_master_read_seqr_h",this);
  end
  
  axi4_master_mon_proxy_h=axi4_master_monitor_proxy::type_id::create("axi4_master_mon_proxy_h",this);
  
  if(axi4_master_agent_cfg_h.has_coverage) begin
   axi4_master_cov_h = axi4_master_coverage ::type_id::create("axi4_master_cov_h",this);
  end

  if(!uvm_config_db#(read_data_type_mode_e)::get(this,"","read_data_mode",axi4_master_agent_cfg_h.read_data_mode)) begin
    `uvm_fatal("FATAL_MA_AGENT_CONFIG", $sformatf("Couldn't get the read_data_mode from config_db"))
  end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase 
//  Connecting axi4 master driver, master monitor and master sequencer for configuration
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(axi4_master_agent_cfg_h.is_active == UVM_ACTIVE) begin
    axi4_master_drv_proxy_h.axi4_master_agent_cfg_h = axi4_master_agent_cfg_h;
    axi4_master_write_seqr_h.axi4_master_agent_cfg_h = axi4_master_agent_cfg_h;
    axi4_master_read_seqr_h.axi4_master_agent_cfg_h = axi4_master_agent_cfg_h;
    axi4_master_cov_h.axi4_master_agent_cfg_h = axi4_master_agent_cfg_h;
  
    //Connecting the ports
    axi4_master_drv_proxy_h.axi_write_seq_item_port.connect(axi4_master_write_seqr_h.seq_item_export);
    axi4_master_drv_proxy_h.axi_read_seq_item_port.connect(axi4_master_read_seqr_h.seq_item_export);
  end

  if(axi4_master_agent_cfg_h.has_coverage) begin
    axi4_master_cov_h.axi4_master_agent_cfg_h = axi4_master_agent_cfg_h;   
    //Connecting monitor_proxy port to coverage export
    axi4_master_mon_proxy_h.axi4_master_read_address_analysis_port.connect(axi4_master_cov_h.analysis_export);
    axi4_master_mon_proxy_h.axi4_master_read_data_analysis_port.connect(axi4_master_cov_h.analysis_export);
    axi4_master_mon_proxy_h.axi4_master_write_address_analysis_port.connect(axi4_master_cov_h.analysis_export);
    axi4_master_mon_proxy_h.axi4_master_write_data_analysis_port.connect(axi4_master_cov_h.analysis_export);
    axi4_master_mon_proxy_h.axi4_master_write_response_analysis_port.connect(axi4_master_cov_h.analysis_export);
  end
  
  axi4_master_mon_proxy_h.axi4_master_agent_cfg_h = axi4_master_agent_cfg_h;

endfunction : connect_phase

`endif

