`ifndef AXI4LITESLAVEWRITEMONITORPROXY_INCLUDED_
`define AXI4LITESLAVEWRITEMONITORPROXY_INCLUDED_

class Axi4LiteSlaveWriteMonitorProxy extends uvm_monitor;
  `uvm_component_utils(Axi4LiteSlaveWriteMonitorProxy)

  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig;
  virtual Axi4LiteSlaveWriteMonitorBFM axi4LiteSlaveWriteMonitorBFM;

  Axi4LiteSlaveWriteTransaction reqWrite;

  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteAddressAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteDataAnalysisPort;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteResponseAnalysisPort;

  uvm_tlm_analysis_fifo #(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteAddressFIFO;
  uvm_tlm_analysis_fifo #(Axi4LiteSlaveWriteTransaction) axi4LiteSlaveWriteDataFIFO;
  
  extern function new(string name = "Axi4LiteSlaveWriteMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task axi4LiteSlaveWriteAddress();
  extern virtual task axi4LiteSlaveWriteData();
  extern virtual task axi4LiteSlaveWriteResponse();

endclass : Axi4LiteSlaveWriteMonitorProxy

function Axi4LiteSlaveWriteMonitorProxy::new(string name = "Axi4LiteSlaveWriteMonitorProxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4LiteSlaveWriteAddressAnalysisPort  = new("axi4LiteSlaveWriteAddressAnalysisPort",this);
  axi4LiteSlaveWriteDataAnalysisPort     = new("axi4LiteSlaveWriteDataAnalysisPort",this);
  axi4LiteSlaveWriteResponseAnalysisPort = new("axi4LiteSlaveWriteResponseAnalysisPort",this);
  axi4LiteSlaveWriteAddressFIFO          = new("axi4LiteSlaveWriteAddressFIFO",this);
  axi4LiteSlaveWriteDataFIFO             = new("axi4LiteSlaveWriteDataFIFO",this);
endfunction : new

function void Axi4LiteSlaveWriteMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
/*   if(!uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::get(this,"","Axi4LiteSlaveWriteMonitorBFM",axi4LiteSlaveWriteMonitorBFM)) begin
     `uvm_fatal("FATAL_SMP_MON_BFM",$sformatf("Couldn't get S_MON_BFM in Axi4LiteSlaveWriteMonitorProxy"));  
  end 
*/endfunction : build_phase

function void Axi4LiteSlaveWriteMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteSlaveWriteMonitorBFM.axi4LiteSlaveWriteMonitorProxy = this;
endfunction : end_of_elaboration_phase


task Axi4LiteSlaveWriteMonitorProxy::run_phase(uvm_phase phase);
/*
  axi4LiteSlaveWriteMonitorBFM.wait_for_aresetn();

  fork 
    axi4LiteSlaveWriteAddress();
    axi4LiteSlaveWriteData();
    axi4LiteSlaveWriteResponse();
  join
*/
endtask : run_phase 

task Axi4LiteSlaveWriteMonitorProxy::axi4LiteSlaveWriteAddress();


endtask


task Axi4LiteSlaveWriteMonitorProxy::axi4LiteSlaveWriteData();


endtask

task Axi4LiteSlaveWriteMonitorProxy::axi4LiteSlaveWriteResponse();


endtask


`endif
