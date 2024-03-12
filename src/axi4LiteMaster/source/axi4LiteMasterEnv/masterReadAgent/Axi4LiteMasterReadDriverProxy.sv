`ifndef AXI4LITEMASTERREADDRIVERPROXY_INCLUDED_
`define AXI4LITEMASTERREADDRIVERPROXY_INCLUDED_

class Axi4LiteMasterReadDriverProxy extends uvm_driver#(Axi4LiteMasterReadTransaction);
  `uvm_component_utils(Axi4LiteMasterReadDriverProxy)

 
  //Port: axi4LiteMasterReadSeqItemPort
  //This port is used to request read items from the sequencer, they are also used it to send responses back.
  uvm_seq_item_pull_port #(REQ,RSP) axi4LiteMasterReadSeqItemPort;

  //Port: axi_read_rsp_port
  //This port provides an alternate way of sending responses back to the originating sequencer. 
  //Which port to use depends on which export the sequencer provides for connection.
  uvm_analysis_port #(RSP) axi_read_rsp_port;

  //Variable: axi4_master_read_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for read task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterReadTransaction) axi4_master_read_fifo_h;

  //Variable: req_wr, req_rd
  //Declaration of REQ handles
  REQ req_rd;
  
  //Variable: rsp_wr, rsp_rd
  //Declaration of RSP handles
  RSP rsp_rd;
      
  //Variable: axi4LiteMasterReadAgentConfig
  //Declaring handle for axi4_master agent config class 
  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig;

  //Variable: axi4LiteMasterReadDriverBFM
  //Declaring handle for axi4 driver bfm
  virtual Axi4LiteMasterReadDriverBFM axi4LiteMasterReadDriverBFM;

  extern function new(string name = "Axi4LiteMasterReadDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:  extern virtual task axi4_read_task();

endclass : Axi4LiteMasterReadDriverProxy

function Axi4LiteMasterReadDriverProxy::new(string name = "Axi4LiteMasterReadDriverProxy", uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterReadSeqItemPort     = new("axi4LiteMasterReadSeqItemPort",this);
  axi_read_rsp_port          = new("axi_read_rsp_port",this);
  axi4_master_read_fifo_h    = new("axi4_master_read_fifo_h",this);
endfunction : new

function void Axi4LiteMasterReadDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
/*  if(!uvm_config_db #(virtual Axi4LiteMasterReadDriverBFM)::get(this,"","Axi4LiteMasterReadDriverBFM",axi4LiteMasterReadDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterReadDriverBFM","cannot get() axi4LiteMasterReadDriverBFM");
  end
*/endfunction : build_phase

function void Axi4LiteMasterReadDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS:axi4LiteMasterReadDriverBFM.axi4LiteMasterReadDriverProxy = this;
endfunction : end_of_elaboration_phase

task Axi4LiteMasterReadDriverProxy::run_phase(uvm_phase phase);

  //waiting for system reset
/*  axi4LiteMasterReadDriverBFM.wait_for_aresetn();
  fork 
    axi4_read_task();
  join
*/
endtask : run_phase

//--------------------------------------------------------------------------------------------
// Task: axi4_read_task
//  Gets the sequence_item, converts them to struct compatible transactions
//  and sends them to the BFM to drive the data over the interface
//--------------------------------------------------------------------------------------------
/*task Axi4LiteMasterReadDriverProxy::axi4_read_task();
endtask : axi4_read_task
*/
`endif

