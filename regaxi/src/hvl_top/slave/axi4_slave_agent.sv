`ifndef AXI4_SLAVE_AGENT_INCLUDED_
`define AXI4_SLAVE_AGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_agent
// This agent has sequencer, driver_proxy, monitor_proxy for axi4  
//--------------------------------------------------------------------------------------------
class axi4_slave_agent extends uvm_agent;
  `uvm_component_utils(axi4_slave_agent)

  // Variable: axi4_slave_agent_cfg_h;
  // Handle for axi4_slave agent configuration
  axi4_slave_agent_config axi4_slave_agent_cfg_h;

  // Varible: axi4_slave_write_seqr_h 
  // Handle for slave write sequencer
  axi4_slave_write_sequencer axi4_slave_write_seqr_h;
  
  // Varible: axi4_slave_read_seqr_h 
  // Handle for slave read sequencer
  axi4_slave_read_sequencer axi4_slave_read_seqr_h;

  // Variable: axi4_slave_drv_proxy_h
  // Handle for axi4_slave driver proxy
  axi4_slave_driver_proxy axi4_slave_drv_proxy_h;

  // Variable: axi4_slave_mon_proxy_h
  // Handle for axi4_slave monitor proxy
  axi4_slave_monitor_proxy axi4_slave_mon_proxy_h;

  // Variable: axi4_slave_coverage
  // Decalring a handle for axi4_slave_coverage
  axi4_slave_coverage axi4_slave_cov_h;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_agent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi4_slave_agent

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes the axi4_slave_agent class object
//
// Parameters:
//  name - instance name of the  axi4_slave_agent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_slave_agent::new(string name = "axi4_slave_agent", uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Creates the required ports, gets the required configuration from config_db
//
// Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void axi4_slave_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

   if(axi4_slave_agent_cfg_h.is_active == UVM_ACTIVE) begin
     axi4_slave_drv_proxy_h  = axi4_slave_driver_proxy::type_id::create("axi4_slave_drv_proxy_h",this);
     axi4_slave_write_seqr_h = axi4_slave_write_sequencer::type_id::create("axi4_slave_write_seqr_h",this);
     axi4_slave_read_seqr_h  = axi4_slave_read_sequencer::type_id::create("axi4_slave_read_seqr_h",this);
   end

   axi4_slave_mon_proxy_h = axi4_slave_monitor_proxy::type_id::create("axi4_slave_mon_proxy_h",this);

   if(axi4_slave_agent_cfg_h.has_coverage) begin
    axi4_slave_cov_h = axi4_slave_coverage::type_id::create("axi4_slave_cov_h",this);
   end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase 
//  Connecting axi4 slave driver, slave monitor and slave sequencer for configuration
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_slave_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(axi4_slave_agent_cfg_h.is_active == UVM_ACTIVE) begin
    axi4_slave_drv_proxy_h.axi4_slave_agent_cfg_h  = axi4_slave_agent_cfg_h;
    axi4_slave_write_seqr_h.axi4_slave_agent_cfg_h = axi4_slave_agent_cfg_h;
    axi4_slave_read_seqr_h.axi4_slave_agent_cfg_h  = axi4_slave_agent_cfg_h;
    axi4_slave_cov_h.axi4_slave_agent_cfg_h        = axi4_slave_agent_cfg_h;
    
    // Connecting the ports
    axi4_slave_drv_proxy_h.axi_write_seq_item_port.connect(axi4_slave_write_seqr_h.seq_item_export);
    axi4_slave_drv_proxy_h.axi_read_seq_item_port.connect(axi4_slave_read_seqr_h.seq_item_export);
  end

  if(axi4_slave_agent_cfg_h.has_coverage) begin
    axi4_slave_cov_h.axi4_slave_agent_cfg_h = axi4_slave_agent_cfg_h; 
    // Connecting monitor_proxy port to coverage export
    axi4_slave_mon_proxy_h.axi4_slave_read_address_analysis_port.connect(axi4_slave_cov_h.analysis_export);
    axi4_slave_mon_proxy_h.axi4_slave_read_data_analysis_port.connect(axi4_slave_cov_h.analysis_export);
    axi4_slave_mon_proxy_h.axi4_slave_write_address_analysis_port.connect(axi4_slave_cov_h.analysis_export);
    axi4_slave_mon_proxy_h.axi4_slave_write_data_analysis_port.connect(axi4_slave_cov_h.analysis_export);
    axi4_slave_mon_proxy_h.axi4_slave_write_response_analysis_port.connect(axi4_slave_cov_h.analysis_export);
  end

  axi4_slave_mon_proxy_h.axi4_slave_agent_cfg_h = axi4_slave_agent_cfg_h;

endfunction: connect_phase

`endif

