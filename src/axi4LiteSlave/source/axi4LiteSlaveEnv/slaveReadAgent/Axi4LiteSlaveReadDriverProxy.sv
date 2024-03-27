`ifndef AXI4LITESLAVEREADDRIVERPROXY_INCLUDED_
`define AXI4LITESLAVEREADDRIVERPROXY_INCLUDED_

class Axi4LiteSlaveReadDriverProxy extends uvm_driver#(Axi4LiteSlaveReadTransaction);
  `uvm_component_utils(Axi4LiteSlaveReadDriverProxy)

  uvm_seq_item_pull_port #(REQ, RSP) axi4LiteSlaveReadSeqItemPort;
  uvm_analysis_port #(RSP) axi4LiteSlaveReadRspPort;
  
  REQ reqRead;
  RSP rspRead;

  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig;

  virtual Axi4LiteSlaveReadDriverBFM axi4LiteSlaveReadDriverBFM;

  uvm_tlm_fifo #(Axi4LiteSlaveReadTransaction) axi4LiteSlaveReadAddressFIFO;
  uvm_tlm_fifo #(Axi4LiteSlaveReadTransaction) axi4LiteSlaveWriteDataInFIFO;

  extern function new(string name = "Axi4LiteSlaveReadDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task readTransferTask();

endclass : Axi4LiteSlaveReadDriverProxy

function Axi4LiteSlaveReadDriverProxy::new(string name = "Axi4LiteSlaveReadDriverProxy",
                                      uvm_component parent = null);
  super.new(name, parent);
  axi4LiteSlaveReadSeqItemPort       = new("axi4LiteSlaveReadSeqItemPort", this);
  axi4LiteSlaveReadRspPort           = new("axi4LiteSlaveReadRspPort", this);
  axi4LiteSlaveReadAddressFIFO       = new("axi4LiteSlaveReadAddressFIFO",this,16);
  axi4LiteSlaveWriteDataInFIFO       = new("axi4LiteSlaveWriteDataInFIFO",this,16);
endfunction : new

function void Axi4LiteSlaveReadDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual Axi4LiteSlaveReadDriverBFM)::get(this,"","Axi4LiteSlaveReadDriverBFM",axi4LiteSlaveReadDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_tx_DRIVER_BFM","cannot get() axi4LiteSlaveReadDriverBFM");
  end

 endfunction : build_phase

function void Axi4LiteSlaveReadDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  axi4LiteSlaveReadDriverBFM.axi4LiteSlaveReadDriverProxy= this;
endfunction  : end_of_elaboration_phase


task Axi4LiteSlaveReadDriverProxy::run_phase(uvm_phase phase);
  axi4LiteSlaveReadDriverBFM.wait_for_system_reset();
  readTransferTask();
endtask : run_phase 


task Axi4LiteSlaveReadDriverProxy::readTransferTask();
  forever begin
    Axi4LiteSlaveReadTransaction slaveReadTx;
    axi4LiteReadTransferCfgStruct slaveReadCfgStruct;
    axi4LiteReadTransferCharStruct slaveReadCharStruct;

    axi4LiteSlaveReadSeqItemPort.get_next_item(reqRead);
  `uvm_info(get_type_name(),$sformatf("SLAVE_READ_TASK::Before Sending_Req_Read_Packet = \n%s",reqRead.sprint()),UVM_HIGH);

     axi4LiteSlaveReadSeqItemPort.item_done();
   end
 
endtask : readTransferTask

`endif
