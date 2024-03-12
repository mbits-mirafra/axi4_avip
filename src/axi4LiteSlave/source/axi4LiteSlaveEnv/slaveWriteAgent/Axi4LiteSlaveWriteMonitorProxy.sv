`ifndef AXI4LITESLAVEWRITEMONITORPROXY_INCLUDED_
`define AXI4LITESLAVEWRITEMONITORPROXY_INCLUDED_

class Axi4LiteSlaveWriteMonitorProxy extends uvm_monitor;
  `uvm_component_utils(Axi4LiteSlaveWriteMonitorProxy)

  // Variable: axi4LiteSlaveWriteAgentConfig;
  // Handle for axi4 slave agent configuration
  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig;

  // Declaring Virtual Monitor BFM Handle
  virtual Axi4LiteSlaveWriteMonitorBFM axi4LiteSlaveWriteMonitorBFM;

  Axi4LiteSlaveWriteTransaction req_rd;
  Axi4LiteSlaveWriteTransaction req_wr;

  // Variable: axi4_slave_analysis_port
  // Declaring analysis port for the monitor port
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_write_address_analysis_port;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_write_data_analysis_port;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_write_response_analysis_port;

  //Variable: axi4_slave_write_address_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_address_fifo_h;
  
  //Variable: axi4_slave_write_data_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_data_fifo_h;
  
  extern function new(string name = "Axi4LiteSlaveWriteMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:   extern virtual task axi4_slave_write_address();
// GopalS:   extern virtual task axi4_slave_write_data();
// GopalS:   extern virtual task axi4_slave_write_response();

endclass : Axi4LiteSlaveWriteMonitorProxy

function Axi4LiteSlaveWriteMonitorProxy::new(string name = "Axi4LiteSlaveWriteMonitorProxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_slave_write_address_analysis_port = new("axi4_slave_write_address_analysis_port",this);
  axi4_slave_write_data_analysis_port = new("axi4_slave_write_data_analysis_port",this);
  axi4_slave_write_response_analysis_port = new("axi4_slave_write_response_analysis_port",this);
  axi4_slave_write_address_fifo_h= new("axi4_slave_write_address_fifo_h",this);
  axi4_slave_write_data_fifo_h= new("axi4_slave_write_data_fifo_h",this);
endfunction : new

function void Axi4LiteSlaveWriteMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
/*   if(!uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::get(this,"","Axi4LiteSlaveWriteMonitorBFM",axi4LiteSlaveWriteMonitorBFM)) begin
     `uvm_fatal("FATAL_SMP_MON_BFM",$sformatf("Couldn't get S_MON_BFM in Axi4LiteSlaveWriteMonitorProxy"));  
  end 
*/endfunction : build_phase

function void Axi4LiteSlaveWriteMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteSlaveWriteMonitorBFM.axi4LiteSlaveWriteMonitorProxy = this;
endfunction : end_of_elaboration_phase


task Axi4LiteSlaveWriteMonitorProxy::run_phase(uvm_phase phase);
/*
  axi4LiteSlaveWriteMonitorBFM.wait_for_aresetn();

  fork 
    axi4_slave_write_address();
    axi4_slave_write_data();
    axi4_slave_write_response();
  join
*/
endtask : run_phase 
/*
//--------------------------------------------------------------------------------------------
// Task : axi4_slave_write_address
// Description: converting,sampling and again converting 
//--------------------------------------------------------------------------------------------
task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_write_address();

endtask


//--------------------------------------------------------------------------------------------
// Task: axi4_slave_write_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_write_data();

endtask
//--------------------------------------------------------------------------------------------
// Task: axi4_slave_write_response
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_write_response();

endtask

*/
`endif
