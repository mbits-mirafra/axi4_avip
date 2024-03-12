`ifndef AXI4LITEMASTERWRITEMONITORPROXY_INCLUDED_
`define AXI4LITEMASTERWRITEMONITORPROXY_INCLUDED_

class Axi4LiteMasterWriteMonitorProxy extends uvm_component;
  `uvm_component_utils(Axi4LiteMasterWriteMonitorProxy)

  // Variable: axi4LiteMasterWriteAgentConfig
  // Declaring handle for axi4_master agent config class 
  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig;

  // Declaring handles for master transaction
  Axi4LiteMasterWriteTransaction req_wr;

  // Variable : apb_master_mon_bfm_h
  // Declaring handle for apb monitor bfm
  virtual Axi4LiteMasterWriteMonitorBFM axi4LiteMasterWriteMonitorBFM;
  
  // Declaring analysis port for the monitor port
 uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_write_address_analysis_port;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_write_data_analysis_port;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_write_response_analysis_port;

  //Variable: axi4_master_write_address_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterWriteTransaction) axi4_master_write_address_fifo_h;
  
  //Variable: axi4_master_write_data_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterWriteTransaction) axi4_master_write_data_fifo_h;

  extern function new(string name = "Axi4LiteMasterWriteMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:   extern virtual task axi4_write_address();
// GopalS:   extern virtual task axi4_write_data();
// GopalS:   extern virtual task axi4_write_response();

endclass : Axi4LiteMasterWriteMonitorProxy


function Axi4LiteMasterWriteMonitorProxy::new(string name = "Axi4LiteMasterWriteMonitorProxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_master_write_address_analysis_port  = new("axi4_master_write_address_analysis_port",this);
  axi4_master_write_data_analysis_port     = new("axi4_master_write_data_analysis_port",this);
  axi4_master_write_response_analysis_port = new("axi4_master_write_response_analysis_port",this);
  axi4_master_write_address_fifo_h= new("axi4_master_write_address_fifo_h",this);
  axi4_master_write_data_fifo_h= new("axi4_master_write_data_fifo_h",this);
endfunction : new

function void Axi4LiteMasterWriteMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
/*  if(!uvm_config_db #(virtual Axi4LiteMasterWriteMonitorBFM)::get(this,"","Axi4LiteMasterWriteMonitorBFM",axi4LiteMasterWriteMonitorBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterWriteMonitorBFM","cannot get() axi4LiteMasterWriteMonitorBFM");
  end */
endfunction : build_phase

function void Axi4LiteMasterWriteMonitorProxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteMasterWriteMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteMasterWriteMonitorBFM.axi4LiteMasterWriteMonitorProxy = this;
endfunction : end_of_elaboration_phase


task Axi4LiteMasterWriteMonitorProxy::run_phase(uvm_phase phase);
/*
  axi4LiteMasterWriteMonitorBFM.wait_for_aresetn();

  fork 
    axi4_write_address();
    axi4_write_data();
    axi4_write_response();
  join
*/
endtask : run_phase

//--------------------------------------------------------------------------------------------
// Task: axi4_write_address
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------
/*
task Axi4LiteMasterWriteMonitorProxy::axi4_write_address();
 
endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_write_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteMasterWriteMonitorProxy::axi4_write_data();

endtask

// Task: axi4_write_response
// Gets the struct packet samples the data, convert it to req and drives to analysis port

task Axi4LiteMasterWriteMonitorProxy::axi4_write_response();

endtask
*/

`endif

