`ifndef AXI4LITEMASTERWRITEDRIVERPROXY_INCLUDED_
`define AXI4LITEMASTERWRITEDRIVERPROXY_INCLUDED_

class Axi4LiteMasterWriteDriverProxy extends uvm_driver#(Axi4LiteMasterWriteTransaction);
  `uvm_component_utils(Axi4LiteMasterWriteDriverProxy)

  uvm_seq_item_pull_port #(REQ,RSP) axi4LiteMasterWriteSeqItemPort;
  
  //Port: axi_write_rsp_port
  //This port provides an alternate way of sending responses back to the originating sequencer. 
  //Which port to use depends on which export the sequencer provides for connection.
  uvm_analysis_port #(RSP) axi_write_rsp_port;
  
    //Variable: axi4_master_write_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterWriteTransaction) axi4_master_write_fifo_h;
  
  //Variable: req_wr
  //Declaration of REQ handles
  REQ req_wr; 
  
  //Variable: rsp_wr
  //Declaration of RSP handles
  RSP rsp_wr;
      
  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig;

  virtual Axi4LiteMasterWriteDriverBFM axi4LiteMasterWriteDriverBFM;
 
  extern function new(string name = "Axi4LiteMasterWriteDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:   extern virtual task axi4_write_task();

endclass : Axi4LiteMasterWriteDriverProxy

function Axi4LiteMasterWriteDriverProxy::new(string name = "Axi4LiteMasterWriteDriverProxy", uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterWriteSeqItemPort    = new("axi4LiteMasterWriteSeqItemPort",this);
  axi_write_rsp_port         = new("axi_write_rsp_port",this);
  axi4_master_write_fifo_h   = new("axi4_master_write_fifo_h",this);
endfunction : new

function void Axi4LiteMasterWriteDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
 /* if(!uvm_config_db #(virtual Axi4LiteMasterWriteDriverBFM)::get(this,"","Axi4LiteMasterWriteDriverBFM",axi4LiteMasterWriteDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterWriteDriverBFM","cannot get() axi4LiteMasterWriteDriverBFM");
  end
*/endfunction : build_phase

function void Axi4LiteMasterWriteDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
 // GopalS:  axi4LiteMasterWriteDriverBFM.axi4LiteMasterWriteDriverProxy = this;
endfunction : end_of_elaboration_phase

task Axi4LiteMasterWriteDriverProxy::run_phase(uvm_phase phase);

/*  axi4LiteMasterWriteDriverBFM.wait_for_aresetn();
  fork 
    axi4_write_task();
  join
*/
endtask : run_phase

/*
task Axi4LiteMasterWriteDriverProxy::axi4_write_task();

endtask : axi4_write_task
*/
`endif

