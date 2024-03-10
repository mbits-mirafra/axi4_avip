`ifndef AXI4LITESLAVEWRITEAGENT_INCLUDED_
`define AXI4LITESLAVEWRITEAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveWriteAgent
// This agent has sequencer, driver_proxy, monitor_proxy for axi4  
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveWriteAgent extends uvm_agent;
  `uvm_component_utils(Axi4LiteSlaveWriteAgent)

  // Variable: axi4LiteSlaveWriteAgentConfig;
  // Handle for axi4_slave agent configuration
  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig;

  // Varible: axi4LiteSlaveWriteSequencer 
  // Handle for slave write sequencer
  Axi4LiteSlaveWriteSequencer axi4LiteSlaveWriteSequencer;
  
  // Variable: axi4LiteSlaveWriteDriverProxy
  // Handle for axi4_slave driver proxy
  Axi4LiteSlaveWriteDriverProxy axi4LiteSlaveWriteDriverProxy;

  // Variable: axi4LiteSlaveWriteMonitorProxy
  // Handle for axi4_slave monitor proxy
  Axi4LiteSlaveWriteMonitorProxy axi4LiteSlaveWriteMonitorProxy;

  // Variable: Axi4LiteSlaveWriteCoverage
  // Decalring a handle for Axi4LiteSlaveWriteCoverage
  Axi4LiteSlaveWriteCoverage axi4LiteSlaveWriteCoverage;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteSlaveWriteAgent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Axi4LiteSlaveWriteAgent

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes the Axi4LiteSlaveWriteAgent class object
//
// Parameters:
//  name - instance name of the  Axi4LiteSlaveWriteAgent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function Axi4LiteSlaveWriteAgent::new(string name = "Axi4LiteSlaveWriteAgent", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void Axi4LiteSlaveWriteAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);

   if(axi4LiteSlaveWriteAgentConfig.isActive == UVM_ACTIVE) begin
     axi4LiteSlaveWriteDriverProxy  = Axi4LiteSlaveWriteDriverProxy::type_id::create("axi4LiteSlaveWriteDriverProxy",this);
     axi4LiteSlaveWriteSequencer = Axi4LiteSlaveWriteSequencer::type_id::create("axi4LiteSlaveWriteSequencer",this);
   end

   axi4LiteSlaveWriteMonitorProxy = Axi4LiteSlaveWriteMonitorProxy::type_id::create("axi4LiteSlaveWriteMonitorProxy",this);

   if(axi4LiteSlaveWriteAgentConfig.hasCoverage) begin
    axi4LiteSlaveWriteCoverage = Axi4LiteSlaveWriteCoverage::type_id::create("axi4LiteSlaveWriteCoverage",this);
   end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase 
//  Connecting axi4 slave driver, slave monitor and slave sequencer for configuration
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteSlaveWriteAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(axi4LiteSlaveWriteAgentConfig.isActive == UVM_ACTIVE) begin
    axi4LiteSlaveWriteDriverProxy.axi4LiteSlaveWriteAgentConfig  = axi4LiteSlaveWriteAgentConfig;
    axi4LiteSlaveWriteSequencer.axi4LiteSlaveWriteAgentConfig = axi4LiteSlaveWriteAgentConfig;
    end
    /*  
    // Connecting the ports
    axi4LiteSlaveWriteDriverProxy.axi_write_seq_item_port.connect(axi4LiteSlaveWriteSequencer.seq_item_export);
    axi4LiteSlaveWriteDriverProxy.axi_read_seq_item_port.connect(axi4_slave_read_seqr_h.seq_item_export);
  end

  if(axi4LiteSlaveWriteAgentConfig.hasCoverage) begin
    axi4LiteSlaveWriteCoverage.axi4LiteSlaveWriteAgentConfig = axi4LiteSlaveWriteAgentConfig; 
    // Connecting monitor_proxy port to coverage export
    axi4LiteSlaveWriteMonitorProxy.axi4_slave_read_address_analysis_port.connect(axi4LiteSlaveWriteCoverage.analysis_export);
    axi4LiteSlaveWriteMonitorProxy.axi4_slave_read_data_analysis_port.connect(axi4LiteSlaveWriteCoverage.analysis_export);
    axi4LiteSlaveWriteMonitorProxy.axi4_slave_write_address_analysis_port.connect(axi4LiteSlaveWriteCoverage.analysis_export);
    axi4LiteSlaveWriteMonitorProxy.axi4_slave_write_data_analysis_port.connect(axi4LiteSlaveWriteCoverage.analysis_export);
    axi4LiteSlaveWriteMonitorProxy.axi4_slave_write_response_analysis_port.connect(axi4LiteSlaveWriteCoverage.analysis_export);
  end
*/
  axi4LiteSlaveWriteMonitorProxy.axi4LiteSlaveWriteAgentConfig = axi4LiteSlaveWriteAgentConfig;

endfunction: connect_phase

`endif

