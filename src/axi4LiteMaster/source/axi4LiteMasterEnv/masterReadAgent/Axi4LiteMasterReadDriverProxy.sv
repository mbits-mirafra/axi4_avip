`ifndef AXI4LITEMASTERREADDRIVERPROXY_INCLUDED_
`define AXI4LITEMASTERREADDRIVERPROXY_INCLUDED_

class Axi4LiteMasterReadDriverProxy extends uvm_driver#(Axi4LiteMasterReadTransaction);
  `uvm_component_utils(Axi4LiteMasterReadDriverProxy)

  uvm_seq_item_pull_port #(REQ,RSP) axi4LiteMasterReadSeqItemPort;

  uvm_analysis_port #(RSP) axi4LiteMasterReadRspPort;

  uvm_tlm_analysis_fifo #(Axi4LiteMasterReadTransaction) axi4LiteMasterReadFIFO;

  REQ reqRead;
  RSP rspRead;
      
  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig;

  virtual Axi4LiteMasterReadDriverBFM axi4LiteMasterReadDriverBFM;

  extern function new(string name = "Axi4LiteMasterReadDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task readTransferTask();

endclass : Axi4LiteMasterReadDriverProxy

function Axi4LiteMasterReadDriverProxy::new(string name = "Axi4LiteMasterReadDriverProxy", uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterReadSeqItemPort  = new("axi4LiteMasterReadSeqItemPort",this);
  axi4LiteMasterReadRspPort      = new("axi4LiteMasterReadRspPort",this);
  axi4LiteMasterReadFIFO         = new("axi4LiteMasterReadFIFO",this);
endfunction : new

function void Axi4LiteMasterReadDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual Axi4LiteMasterReadDriverBFM)::get(this,"","Axi4LiteMasterReadDriverBFM",axi4LiteMasterReadDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterReadDriverBFM","cannot get() axi4LiteMasterReadDriverBFM");
  end
endfunction : build_phase

function void Axi4LiteMasterReadDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  axi4LiteMasterReadDriverBFM.axi4LiteMasterReadDriverProxy = this;
endfunction : end_of_elaboration_phase

task Axi4LiteMasterReadDriverProxy::run_phase(uvm_phase phase);
  axi4LiteMasterReadDriverBFM.wait_for_aresetn();
  readTransferTask();
endtask : run_phase

task Axi4LiteMasterReadDriverProxy::readTransferTask();
  forever begin
    Axi4LiteMasterReadTransaction masterReadTx;
    axi4LiteReadTransferCfgStruct masterReadCfgStruct;
    axi4LiteReadTransferCharStruct masterReadCharStruct;

    axi4LiteMasterReadSeqItemPort.get_next_item(reqRead); 
  `uvm_info(get_type_name(),$sformatf("MASTER_READ_TASK::Before Sending_Req_Read_Packet = \n%s",reqRead.sprint()),UVM_HIGH);

  /*
     Axi4LiteMasterReadConfigConverter::fromClass(axi4LiteMasterReadAgentConfig, masterReadCfgStruct); 
     `uvm_info(get_type_name(),$sformatf("MASTER_READ_TASK::Checking transfer type Before calling task if = %s",reqRead.transferType),UVM_FULL);

     if(reqRead.transferType == BLOCKING_WRITE) begin
         Axi4LiteMasterReadTransaction localMasterReadTx;
         Axi4LiteMasterReadSeqItemConverter::fromReadClass(reqRead, masterReadCharStruct);
         `uvm_info(get_type_name(),$sformatf("MASTER_READ_TASK::Checking transfer type = %s",reqRead.transferType),UVM_MEDIUM);        
         axi4LiteMasterReadDriverBFM.masterReadAddressChannelTask(masterReadCharStruct, masterReadCfgStruct);
         axi4LiteMasterReadDriverBFM.masterReadDataChannelTask(masterReadCharStruct, masterReadCfgStruct);

         Axi4LiteMasterReadSeqItemConverter::toReadClass(masterReadCharStruct,localMasterReadTx);
         `uvm_info(get_type_name(),$sformatf("MASTER_READ_TASK::Response Received_Req_write_Packet = \n %s",localMasterReadTx.sprint()),UVM_MEDIUM); 
      end

     else if(reqRead.transferType == NON_BLOCKING_WRITE) begin
     end
     */
     axi4LiteMasterReadSeqItemPort.item_done();
   end
 
endtask : readTransferTask

`endif

