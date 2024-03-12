`ifndef AXI4LITEMASTERREADMONITORPROXY_INCLUDED_
`define AXI4LITEMASTERREADMONITORPROXY_INCLUDED_

class Axi4LiteMasterReadMonitorProxy extends uvm_component;
  `uvm_component_utils(Axi4LiteMasterReadMonitorProxy)

  // Variable: axi4LiteMasterReadAgentConfig
  // Declaring handle for axi4_master agent config class 
  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig;

  // Declaring handles for master transaction
  Axi4LiteMasterReadTransaction req_rd;

  // Variable : apb_master_mon_bfm_h
  // Declaring handle for apb monitor bfm
  virtual Axi4LiteMasterReadMonitorBFM axi4LiteMasterReadMonitorBFM;
  
  // Declaring analysis port for the monitor port
  uvm_analysis_port#(Axi4LiteMasterReadTransaction) axi4_master_read_address_analysis_port;
  uvm_analysis_port#(Axi4LiteMasterReadTransaction) axi4_master_read_data_analysis_port;

  //Variable: axi4_master_read_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for read task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterReadTransaction) axi4_master_read_fifo_h;

  extern function new(string name = "Axi4LiteMasterReadMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:   extern virtual task axi4_read_address();
// GopalS:   extern virtual task axi4_read_data();

endclass : Axi4LiteMasterReadMonitorProxy

function Axi4LiteMasterReadMonitorProxy::new(string name = "Axi4LiteMasterReadMonitorProxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_master_read_address_analysis_port   = new("axi4_master_read_address_analysis_port",this);
  axi4_master_read_data_analysis_port      = new("axi4_master_read_data_analysis_port",this);
  axi4_master_read_fifo_h = new("axi4_master_read_fifo_h",this);
endfunction : new

function void Axi4LiteMasterReadMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
/*  if(!uvm_config_db #(virtual Axi4LiteMasterReadMonitorBFM)::get(this,"","Axi4LiteMasterReadMonitorBFM",axi4LiteMasterReadMonitorBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterReadMonitorBFM","cannot get() axi4LiteMasterReadMonitorBFM");
  end 
*/endfunction : build_phase

function void Axi4LiteMasterReadMonitorProxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteMasterReadMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteMasterReadMonitorBFM.axi4LiteMasterReadMonitorProxy = this;
endfunction : end_of_elaboration_phase

task Axi4LiteMasterReadMonitorProxy::run_phase(uvm_phase phase);
/*
  axi4LiteMasterReadMonitorBFM.wait_for_aresetn();

  fork 
    axi4_read_address();
    axi4_read_data();
  join
*/
endtask : run_phase
//--------------------------------------------------------------------------------------------
// Task: axi4_read_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------
/*
task Axi4LiteMasterReadMonitorProxy::axi4_read_data();

endtask
*/
`endif

