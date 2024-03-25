`ifndef AXI4LITEMASTERWRITEDRIVERPROXY_INCLUDED_
`define AXI4LITEMASTERWRITEDRIVERPROXY_INCLUDED_

class Axi4LiteMasterWriteDriverProxy extends uvm_driver #(Axi4LiteMasterWriteTransaction);
  `uvm_component_utils(Axi4LiteMasterWriteDriverProxy)

  uvm_seq_item_pull_port #(REQ, RSP) axi4LiteMasterWriteSeqItemPort;
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

function Axi4LiteMasterWriteDriverProxy::new(string name = "Axi4LiteMasterWriteDriverProxy",
                                             uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterWriteSeqItemPort = new("axi4LiteMasterWriteSeqItemPort", this);
  axi4LiteMasterWriteRspPort     = new("axi4LiteMasterWriteRspPort", this);
  axi4LiteMasterWriteFIFO        = new("axi4LiteMasterWriteFIFO", this);
endfunction : new

function void Axi4LiteMasterWriteDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual Axi4LiteMasterWriteDriverBFM)::get(
          this, "", "Axi4LiteMasterWriteDriverBFM", axi4LiteMasterWriteDriverBFM
      )) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterWriteDriverBFM",
               "cannot get() axi4LiteMasterWriteDriverBFM");
  end
endfunction : build_phase

function void Axi4LiteMasterWriteDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  axi4LiteMasterWriteDriverBFM.axi4LiteMasterWriteDriverProxy = this;
endfunction : end_of_elaboration_phase

task Axi4LiteMasterWriteDriverProxy::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("gopal::run_phase started"),UVM_NONE);
  axi4LiteMasterWriteDriverBFM.wait_for_aresetn();
    `uvm_info(get_type_name(), $sformatf("gopal::After reset task"),UVM_NONE);
  writeTransferTask();
endtask : run_phase


task Axi4LiteMasterWriteDriverProxy::writeTransferTask();
  
  forever begin
    Axi4LiteMasterWriteTransaction  masterWriteTx;
    axi4LiteWriteTransferCfgStruct  masterWriteCfgStruct;
    axi4LiteWriteTransferCharStruct masterWriteCharStruct;

    axi4LiteMasterWriteSeqItemPort.get_next_item(reqWrite);
    `uvm_info(get_type_name(), $sformatf(
              "MASTER_WRITE_TASK::Before Sending_Req_Write_Packet = \n%s", reqWrite.sprint()),
              UVM_HIGH);

    /*
    Axi4LiteMasterWriteConfigConverter::fromClass(axi4LiteMasterWriteAgentConfig,
                                                  masterWriteCfgStruct);
    `uvm_info(get_type_name(), $sformatf(
              "MASTER_WRITE_TASK::Checking transfer type Before calling task if = %s",
              reqWrite.transferType
              ), UVM_FULL);

    if (reqWrite.transferType == BLOCKING_WRITE) begin
      Axi4LiteMasterWriteTransaction localMasterWriteTx;
      Axi4LiteMasterWriteSeqItemConverter::fromWriteClass(reqWrite, masterWriteCharStruct);
      `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Checking transfer type = %s", reqWrite.transferType),
                UVM_MEDIUM);
      axi4LiteMasterWriteDriverBFM.masterWriteAddressChannelTask(masterWriteCharStruct,
                                                                 masterWriteCfgStruct);
      axi4LiteMasterWriteDriverBFM.masterWriteDataChannelTask(masterWriteCharStruct,
                                                              masterWriteCfgStruct);
      axi4LiteMasterWriteDriverBFM.masterWriteResponseChannelTask(masterWriteCharStruct,
                                                                  masterWriteCfgStruct);

      Axi4LiteMasterWriteSeqItemConverter::toWriteClass(masterWriteCharStruct, localMasterWriteTx);
      `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Response Received_Req_write_Packet = \n %s",localMasterWriteTx.sprint()), UVM_MEDIUM);

    end 
    else if (reqWrite.transferType == NON_BLOCKING_WRITE) begin
     
      fork
       begin : WRITE_ADDRESS_CHANNEL 
         Axi4LiteMasterWriteTransaction masterWriteAddressTx;
         axi4LiteWriteTransferCharStruct masterWriteAddressCharStruct;
         Axi4LiteMasterWriteSeqItemConverter::fromWriteClass(reqWrite, masterWriteAddressCharStruct);
         `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Checking transfer type = %s", reqWrite.transferType),UVM_MEDIUM);
          
         axi4LiteMasterWriteDriverBFM.masterWriteAddressChannelTask(masterWriteAddressCharStruct,
                                                                  masterWriteCfgStruct);
         Axi4LiteMasterWriteSeqItemConverter::toWriteClass(masterWriteAddressCharStruct, masterWriteAddressTx);
        `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Response Received_Req_write_Packet = \n %s",masterWriteAddressTx.sprint()), UVM_MEDIUM);
      end : WRITE_ADDRESS_CHANNEL

      begin : WRITE_DATA_CHANNEL
         Axi4LiteMasterWriteTransaction masterWriteDataTx;
         axi4LiteWriteTransferCharStruct masterWriteDataCharStruct;
         Axi4LiteMasterWriteSeqItemConverter::fromWriteClass(reqWrite, masterWriteDataCharStruct);
         `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Checking transfer type = %s", reqWrite.transferType),UVM_MEDIUM);
         axi4LiteMasterWriteDriverBFM.masterWriteDataChannelTask(masterWriteDataCharStruct,
                                                                 masterWriteCfgStruct);
         Axi4LiteMasterWriteSeqItemConverter::toWriteClass(masterWriteDataCharStruct, masterWriteDataTx);
        `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Response Received_Req_write_Packet = \n %s",masterWriteDataTx.sprint()), UVM_MEDIUM);
     end : WRITE_DATA_CHANNEL

      begin : WRITE_RESPONSE_CHANNEL
         Axi4LiteMasterWriteTransaction masterWriteResponseTx;
         axi4LiteWriteTransferCharStruct masterWriteResponseCharStruct;
         Axi4LiteMasterWriteSeqItemConverter::fromWriteClass(reqWrite, masterWriteResponseCharStruct);
         `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Checking transfer type = %s", reqWrite.transferType),UVM_MEDIUM);
         axi4LiteMasterWriteDriverBFM.masterWriteResponseChannelTask(masterWriteResponseCharStruct,
                                                                      masterWriteCfgStruct);
         Axi4LiteMasterWriteSeqItemConverter::toWriteClass(masterWriteResponseCharStruct, masterWriteResponseTx);
        `uvm_info(get_type_name(), $sformatf("MASTER_WRITE_TASK::Response Received_Req_write_Packet = \n %s",masterWriteResponseTx.sprint()), UVM_MEDIUM);
      end : WRITE_RESPONSE_CHANNEL
      join_any


    end
    */
    axi4LiteMasterWriteSeqItemPort.item_done();
  end
endtask : writeTransferTask

`endif

