`ifndef AXI4LITESLAVEREADAGENT_INCLUDED_
`define AXI4LITESLAVEREADAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveReadAgent
// This agent has sequencer, driver_proxy, monitor_proxy for axi4  
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveReadAgent extends uvm_agent;
  `uvm_component_utils(Axi4LiteSlaveReadAgent)

  // Variable: axi4LiteSlaveReadAgentConfig;
  // Handle for axi4_slave agent configuration
  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig;

  // Varible: axi4LiteSlaveReadSequencer 
  // Handle for slave write sequencer
  Axi4LiteSlaveReadSequencer axi4LiteSlaveReadSequencer;
  
  // Variable: axi4LiteSlaveReadDriverProxy
  // Handle for axi4_slave driver proxy
  Axi4LiteSlaveReadDriverProxy axi4LiteSlaveReadDriverProxy;

  // Variable: axi4LiteSlaveReadMonitorProxy
  // Handle for axi4_slave monitor proxy
  Axi4LiteSlaveReadMonitorProxy axi4LiteSlaveReadMonitorProxy;

  // Variable: Axi4LiteSlaveReadCoverage
  // Decalring a handle for Axi4LiteSlaveReadCoverage
  Axi4LiteSlaveReadCoverage axi4LiteSlaveReadCoverage;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteSlaveReadAgent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteSlaveReadAgent

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes the Axi4LiteSlaveReadAgent class object
//
// Parameters:
//  name - instance name of the  Axi4LiteSlaveReadAgent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function Axi4LiteSlaveReadAgent::new(string name = "Axi4LiteSlaveReadAgent", uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Creates the required ports, gets the required configuration from config_db
//
// Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteSlaveReadAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);

   if(axi4LiteSlaveReadAgentConfig.isActive == UVM_ACTIVE) begin
     axi4LiteSlaveReadDriverProxy  = Axi4LiteSlaveReadDriverProxy::type_id::create("axi4LiteSlaveReadDriverProxy",this);
     axi4LiteSlaveReadSequencer = Axi4LiteSlaveReadSequencer::type_id::create("axi4LiteSlaveReadSequencer",this);
   end

   axi4LiteSlaveReadMonitorProxy = Axi4LiteSlaveReadMonitorProxy::type_id::create("axi4LiteSlaveReadMonitorProxy",this);

   if(axi4LiteSlaveReadAgentConfig.hasCoverage) begin
    axi4LiteSlaveReadCoverage = Axi4LiteSlaveReadCoverage::type_id::create("axi4LiteSlaveReadCoverage",this);
   end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase 
//  Connecting axi4 slave driver, slave monitor and slave sequencer for configuration
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteSlaveReadAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(axi4LiteSlaveReadAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteSlaveReadDriverProxy.axi4LiteSlaveReadAgentConfig  = axi4LiteSlaveReadAgentConfig;
    axi4LiteSlaveReadSequencer.axi4LiteSlaveReadAgentConfig = axi4LiteSlaveReadAgentConfig;
    axi4_slave_read_seqr_h.axi4LiteSlaveReadAgentConfig  = axi4LiteSlaveReadAgentConfig;
    axi4LiteSlaveReadCoverage.axi4LiteSlaveReadAgentConfig        = axi4LiteSlaveReadAgentConfig;
  /*  
    // Connecting the ports
    axi4LiteSlaveReadDriverProxy.axi_write_seq_item_port.connect(axi4LiteSlaveReadSequencer.seq_item_export);
    axi4LiteSlaveReadDriverProxy.axi_read_seq_item_port.connect(axi4_slave_read_seqr_h.seq_item_export);
  end

  if(axi4LiteSlaveReadAgentConfig.hasCoverage) begin
    axi4LiteSlaveReadCoverage.axi4LiteSlaveReadAgentConfig = axi4LiteSlaveReadAgentConfig; 
    // Connecting monitor_proxy port to coverage export
    axi4LiteSlaveReadMonitorProxy.axi4_slave_read_address_analysis_port.connect(axi4LiteSlaveReadCoverage.analysis_export);
    axi4LiteSlaveReadMonitorProxy.axi4_slave_read_data_analysis_port.connect(axi4LiteSlaveReadCoverage.analysis_export);
    axi4LiteSlaveReadMonitorProxy.axi4_slave_write_address_analysis_port.connect(axi4LiteSlaveReadCoverage.analysis_export);
    axi4LiteSlaveReadMonitorProxy.axi4_slave_write_data_analysis_port.connect(axi4LiteSlaveReadCoverage.analysis_export);
    axi4LiteSlaveReadMonitorProxy.axi4_slave_write_response_analysis_port.connect(axi4LiteSlaveReadCoverage.analysis_export);
  end
*/
  axi4LiteSlaveReadMonitorProxy.axi4LiteSlaveReadAgentConfig = axi4LiteSlaveReadAgentConfig;

endfunction: connect_phase

`endif

