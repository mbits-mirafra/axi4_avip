`ifndef AXI4LITESLAVEREADDRIVERPROXY_INCLUDED_
`define AXI4LITESLAVEREADDRIVERPROXY_INCLUDED_

class Axi4LiteSlaveReadDriverProxy extends uvm_driver#(Axi4LiteSlaveReadTransaction);
  `uvm_component_utils(Axi4LiteSlaveReadDriverProxy)

   uvm_seq_item_pull_port #(REQ, RSP) axi4LiteSlaveReadSeqItemPort;

  uvm_analysis_port #(RSP) axi_read_rsp_port;
  
  REQ req_rd;
  RSP rsp_rd;

  // Variable: axi4LiteSlaveReadAgentConfig
  // Declaring handle for axi4_slave agent config class 
  Axi4LiteSlaveReadAgentConfig axi4LiteSlaveReadAgentConfig;

  //Variable : axi4LiteSlaveReadDriverBFM
  //Declaring handle for axi4 driver bfm
  virtual Axi4LiteSlaveReadDriverBFM axi4LiteSlaveReadDriverBFM;

  //Declaring handle for uvm_tlm_analysis_fifo's for all the five channels
  uvm_tlm_fifo #(Axi4LiteSlaveReadTransaction) axi4_slave_read_addr_fifo_h;
  uvm_tlm_fifo #(Axi4LiteSlaveReadTransaction) axi4_slave_read_data_in_fifo_h;

  bit[3:0] wr_addr_cnt;
  bit[3:0] wr_resp_cnt;

  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteSlaveReadDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
//  extern virtual task axi4_read_task();
//  extern virtual task task_memory_read(input Axi4LiteSlaveReadTransaction read_pkt,ref axi4_read_transfer_char_s struct_read_packet);

 endclass : Axi4LiteSlaveReadDriverProxy

function Axi4LiteSlaveReadDriverProxy::new(string name = "Axi4LiteSlaveReadDriverProxy",
                                      uvm_component parent = null);
  super.new(name, parent);
  axi4LiteSlaveReadSeqItemPort                    = new("axi4LiteSlaveReadSeqItemPort", this);
  axi_read_rsp_port                         = new("axi_read_rsp_port", this);
  axi4_slave_read_addr_fifo_h               = new("axi4_slave_read_addr_fifo_h",this,16);
  axi4_slave_read_data_in_fifo_h            = new("axi4_slave_read_data_in_fifo_h",this,16);
endfunction : new

function void Axi4LiteSlaveReadDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
 /* if(!uvm_config_db #(virtual Axi4LiteSlaveReadDriverBFM)::get(this,"","Axi4LiteSlaveReadDriverBFM",axi4LiteSlaveReadDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_tx_DRIVER_BFM","cannot get() axi4LiteSlaveReadDriverBFM");
  end
*/
 endfunction : build_phase

function void Axi4LiteSlaveReadDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteSlaveReadDriverBFM.axi4LiteSlaveReadDriverProxy= this;
endfunction  : end_of_elaboration_phase


task Axi4LiteSlaveReadDriverProxy::run_phase(uvm_phase phase);

  `uvm_info(get_type_name(),"SLAVE_DRIVER_PROXY",UVM_MEDIUM)
/*
  //wait for system reset
  axi4LiteSlaveReadDriverBFM.wait_for_system_reset();
  fork 
    axi4_read_task();
  join
*/

endtask : run_phase 
/*
//-------------------------------------------------------
// task axi4 read task
//-------------------------------------------------------
task Axi4LiteSlaveReadDriverProxy::axi4_read_task();

endtask : axi4_read_task

task Axi4LiteSlaveReadDriverProxy::task_memory_read(input Axi4LiteSlaveReadTransaction read_pkt,ref axi4_read_transfer_char_s struct_read_packet);

endtask : task_memory_read


task Axi4LiteSlaveReadDriverProxy::out_of_order_for_reads(output axi4_read_transfer_char_s oor_read_data_struct_read_packet);

endtask : out_of_order_for_reads
*/
`endif
