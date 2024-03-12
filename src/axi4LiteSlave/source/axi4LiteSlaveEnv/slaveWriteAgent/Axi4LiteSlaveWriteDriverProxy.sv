`ifndef AXI4LITESLAVEWRITEDRIVERPROXY_INCLUDED_
`define AXI4LITESLAVEWRITEDRIVERPROXY_INCLUDED_

class Axi4LiteSlaveWriteDriverProxy extends uvm_driver#(Axi4LiteSlaveWriteTransaction);
  `uvm_component_utils(Axi4LiteSlaveWriteDriverProxy)

  uvm_seq_item_pull_port #(REQ, RSP) axi4LiteSlaveWriteSeqItemPort;

  uvm_analysis_port #(RSP) axi_write_rsp_port;
  
  REQ req_wr;
  RSP rsp_wr;

  // Variable: axi4LiteSlaveWriteAgentConfig
  // Declaring handle for axi4_slave agent config class 
  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig;

  //Variable : axi4LiteSlaveWriteDriverBFM
  //Declaring handle for axi4 driver bfm
  virtual Axi4LiteSlaveWriteDriverBFM axi4LiteSlaveWriteDriverBFM;

  //Declaring handle for uvm_tlm_analysis_fifo's for all the five channels
  uvm_tlm_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_addr_fifo_h;
  uvm_tlm_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_data_in_fifo_h;
  uvm_tlm_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_response_fifo_h;
  uvm_tlm_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_data_out_fifo_h;

  bit[3:0] wr_addr_cnt;
  bit[3:0] wr_resp_cnt;

  extern function new(string name = "Axi4LiteSlaveWriteDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
 /* extern virtual task axi4_write_task();
  extern virtual task task_memory_write(input Axi4LiteSlaveWriteTransaction struct_write_packet);
*/
 endclass : Axi4LiteSlaveWriteDriverProxy

function Axi4LiteSlaveWriteDriverProxy::new(string name = "Axi4LiteSlaveWriteDriverProxy",
                                      uvm_component parent = null);
  super.new(name, parent);
  axi4LiteSlaveWriteSeqItemPort                   = new("axi4LiteSlaveWriteSeqItemPort", this);
  axi_write_rsp_port                        = new("axi_write_rsp_port", this);
  axi4_slave_write_addr_fifo_h              = new("axi4_slave_write_addr_fifo_h",this,16);
  axi4_slave_write_data_in_fifo_h           = new("axi4_slave_write_data_in_fifo_h",this,16);
  axi4_slave_write_response_fifo_h          = new("axi4_slave_write_response_fifo_h",this,16);
  axi4_slave_write_data_out_fifo_h          = new("axi4_slave_write_data_out_fifo_h",this,16);
endfunction : new

function void Axi4LiteSlaveWriteDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
/*  if(!uvm_config_db #(virtual Axi4LiteSlaveWriteDriverBFM)::get(this,"","Axi4LiteSlaveWriteDriverBFM",axi4LiteSlaveWriteDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_tx_DRIVER_BFM","cannot get() axi4LiteSlaveWriteDriverBFM");
  end
*/endfunction : build_phase

function void Axi4LiteSlaveWriteDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteSlaveWriteDriverBFM.axi4LiteSlaveWriteDriverProxy= this;
endfunction  : end_of_elaboration_phase

task Axi4LiteSlaveWriteDriverProxy::run_phase(uvm_phase phase);

  `uvm_info(get_type_name(),"SLAVE_DRIVER_PROXY",UVM_MEDIUM)
/*
  //wait for system reset
  axi4LiteSlaveWriteDriverBFM.wait_for_system_reset();
  fork 
    axi4_write_task();
  join
*/

endtask : run_phase 
/*
//--------------------------------------------------------------------------------------------
// task axi4 write task
//--------------------------------------------------------------------------------------------
task Axi4LiteSlaveWriteDriverProxy::axi4_write_task();
 
 
 endtask : axi4_write_task
*/
`endif
