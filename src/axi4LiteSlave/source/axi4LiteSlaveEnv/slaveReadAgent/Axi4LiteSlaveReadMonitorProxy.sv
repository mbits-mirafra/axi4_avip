`ifndef AXI4LITESLAVEREADMONITORPROXY_INCLUDED_
`define AXI4LITESLAVEREADMONITORPROXY_INCLUDED_

class Axi4LiteSlaveReadMonitorProxy extends uvm_monitor;
  `uvm_component_utils(Axi4LiteSlaveReadMonitorProxy)

  // Variable: axi4LiteSlaveReadAgentConfig;
  // Handle for axi4 slave agent configuration
  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig;

  // Declaring Virtual Monitor BFM Handle
  virtual Axi4LiteSlaveReadMonitorBFM axi4LiteSlaveReadMonitorBFM;

  Axi4LiteSlaveReadTransaction req_rd;

  // Variable: axi4_slave_analysis_port
 uvm_analysis_port#(Axi4LiteSlaveReadTransaction) axi4_slave_read_address_analysis_port;
  uvm_analysis_port#(Axi4LiteSlaveReadTransaction) axi4_slave_read_data_analysis_port;
 
  //Variable: axi4_slave_read_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for read task
  uvm_tlm_analysis_fifo #(Axi4LiteSlaveReadTransaction) axi4_slave_read_fifo_h;
  
  extern function new(string name = "Axi4LiteSlaveReadMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:   extern virtual task axi4_slave_read_address();
// GopalS:   extern virtual task axi4_slave_read_data();

endclass : Axi4LiteSlaveReadMonitorProxy


function Axi4LiteSlaveReadMonitorProxy::new(string name = "Axi4LiteSlaveReadMonitorProxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_slave_read_address_analysis_port = new("axi4_slave_read_address_analysis_port",this);
  axi4_slave_read_data_analysis_port = new("axi4_slave_read_data_analysis_port",this);
  axi4_slave_read_fifo_h = new("axi4_slave_read_fifo_h",this);
endfunction : new

function void Axi4LiteSlaveReadMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
/*   if(!uvm_config_db#(virtual Axi4LiteSlaveReadMonitorBFM)::get(this,"","Axi4LiteSlaveReadMonitorBFM",axi4LiteSlaveReadMonitorBFM)) begin
     `uvm_fatal("FATAL_SMP_MON_BFM",$sformatf("Couldn't get S_MON_BFM in Axi4LiteSlaveReadMonitorProxy"));  
  end */
endfunction : build_phase

function void Axi4LiteSlaveReadMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteSlaveReadMonitorBFM.axi4LiteSlaveReadMonitorProxy = this;
endfunction : end_of_elaboration_phase

task Axi4LiteSlaveReadMonitorProxy::run_phase(uvm_phase phase);
/*
  axi4LiteSlaveReadMonitorBFM.wait_for_aresetn();
  fork 
    axi4_slave_read_address();
    axi4_slave_read_data();
  join
*/
endtask : run_phase 
//--------------------------------------------------------------------------------------------
// Task: axi4_slave_read_address
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------
/*
task Axi4LiteSlaveReadMonitorProxy::axi4_slave_read_address();
endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_slave_read_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteSlaveReadMonitorProxy::axi4_slave_read_data();
endtask
*/
`endif
