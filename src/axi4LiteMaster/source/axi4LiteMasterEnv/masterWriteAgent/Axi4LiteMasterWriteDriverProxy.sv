`ifndef AXI4LITEMASTERWRITEDRIVERPROXY_INCLUDED_
`define AXI4LITEMASTERWRITEDRIVERPROXY_INCLUDED_

class Axi4LiteMasterWriteDriverProxy extends uvm_driver#(Axi4LiteMasterWriteTransaction);
  `uvm_component_utils(Axi4LiteMasterWriteDriverProxy)

  uvm_seq_item_pull_port #(REQ,RSP) axi4LiteMasterWriteSeqItemPort;
  uvm_analysis_port #(RSP) axi4LiteMasterWriteRspPort;
  uvm_tlm_analysis_fifo #(Axi4LiteMasterWriteTransaction) axi4LiteMasterWriteFIFO;
  
  REQ reqWrite; 
  RSP rspWrite;
      
  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig;

  virtual Axi4LiteMasterWriteDriverBFM axi4LiteMasterWriteDriverBFM;
 
  extern function new(string name = "Axi4LiteMasterWriteDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task writeTransferTask();

endclass : Axi4LiteMasterWriteDriverProxy

function Axi4LiteMasterWriteDriverProxy::new(string name = "Axi4LiteMasterWriteDriverProxy", uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterWriteSeqItemPort  = new("axi4LiteMasterWriteSeqItemPort",this);
  axi4LiteMasterWriteRspPort      = new("axi4LiteMasterWriteRspPort",this);
  axi4LiteMasterWriteFIFO         = new("axi4LiteMasterWriteFIFO",this);
endfunction : new

function void Axi4LiteMasterWriteDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual Axi4LiteMasterWriteDriverBFM)::get(this,"","Axi4LiteMasterWriteDriverBFM",axi4LiteMasterWriteDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterWriteDriverBFM","cannot get() axi4LiteMasterWriteDriverBFM");
  end
endfunction : build_phase

function void Axi4LiteMasterWriteDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  axi4LiteMasterWriteDriverBFM.axi4LiteMasterWriteDriverProxy = this;
endfunction : end_of_elaboration_phase

task Axi4LiteMasterWriteDriverProxy::run_phase(uvm_phase phase);
  axi4LiteMasterWriteDriverBFM.wait_for_aresetn();
  writeTransferTask();
endtask : run_phase

  
task Axi4LiteMasterWriteDriverProxy::writeTransferTask();
  forever begin
    Axi4LiteMasterWriteTransaction masterWriteTx;
    axi4LiteWriteTransferCfgStruct masterWriteCfgStruct;
    axi4LiteWriteTransferCharStruct masterWriteCharStruct;

    axi4LiteMasterWriteSeqItemPort.get_next_item(reqWrite);
  `uvm_info(get_type_name(),$sformatf("MASTER_WRITE_TASK::Before Sending_Req_Write_Packet = \n%s",reqWrite.sprint()),UVM_HIGH);

     Axi4LiteMasterWriteConfigConverter::fromClass(axi4LiteMasterWriteAgentConfig, masterWriteCfgStruct); 
     `uvm_info(get_type_name(),$sformatf("MASTER_WRITE_TASK::Checking transfer type Before calling task if = %s",reqWrite.transferType),UVM_FULL);

     if(reqWrite.transferType == BLOCKING_WRITE) begin
     
     end

     else if(reqWrite.transferType == NON_BLOCKING_WRITE) begin
     end

     axi4LiteMasterWriteSeqItemPort.item_done();
   end
 endtask : writeTransferTask 

`endif

