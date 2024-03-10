`ifndef AXI4LITESLAVEWRITEMONITORBFM_INCLUDED_
`define AXI4LITESLAVEWRITEMONITORBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : Axi4LiteSlaveWriteMonitorBFM
//Used as the HDL monitor for axi4
//It connects with the HVL Axi4LiteSlaveWriteMonitorProxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveWriteMonitorBFM(input bit aclk, input bit aresetn,
                                       //Write Address Channel Signals
                                       input  [ADDRESS_WIDTH-1:0]awaddr,
                                       input  [2:0]awprot,
                                       input  awvalid,
                                       input  awready,
      
                                       //Write Data Channel Signals
                                       input  [DATA_WIDTH-1: 0]wdata,
                                       input  [(DATA_WIDTH/8)-1:0]wstrb,
                                       input  wvalid,
                                       input  wready,
      
                                       //Write Response Channel Signals
                                       input  [1:0]bresp,
                                       input  bvalid,
                                       input  bready
                                     );  

  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  //-------------------------------------------------------
  // Importing axi4 Global Package master package
  //-------------------------------------------------------
  import Axi4LiteSlaveWritePkg::Axi4LiteSlaveWriteMonitorProxy; 
  //Variable : axi4LiteSlaveWriteMonitorProxy
  //Creating the handle for proxy monitor
 
  Axi4LiteSlaveWriteMonitorProxy axi4LiteSlaveWriteMonitorProxy;
  
  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //-------------------------------------------------------
  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH)
   
    @(posedge aresetn);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn
  //-------------------------------------------------------
  // Task: axi4_slave_write_address_sampling
  // Used for sample the write address channel signals
  //-------------------------------------------------------
  task axi4_slave_write_address_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(posedge aclk);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("from axi4_slave_write_address_sampling "),UVM_HIGH)

    while(awvalid!==1 || awready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop from axi4_slave_write_address_sampling"),UVM_HIGH)
    end    
    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop from axi4_slave_write_address_sampling "),UVM_HIGH)
   
    req.awaddr = awaddr;
    req.awprot = awprot;  
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop from axi4_slave_write_address_sampling req=%p ",req),UVM_HIGH)
  endtask

  //-------------------------------------------------------
  // Task: axi4_slave_write_data_sampling
  // Used for sample the write data channel signals
  //-------------------------------------------------------
  task axi4_slave_write_data_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
endtask
 
  //-------------------------------------------------------
  // Task: axi4_write_response_sampling
  // Used for sample the write response channel signals
  //-------------------------------------------------------
  task axi4_write_response_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
  @(posedge aclk);
    while(bvalid!==1 || bready!==1)begin
    `uvm_info("FROM SLAVE MON BFM",$sformatf("values :: bvalid=%d & bready=%d",bvalid,bready),UVM_HIGH)
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop of write response sample"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop of write response "),UVM_HIGH)
    
    @(posedge aclk);
    req.bresp    = bresp;  
    `uvm_info("FROM SLAVE MON BFM WRITE RESPONSE",$sformatf("write response packet: \n %p",req),UVM_HIGH)
  endtask


endinterface : Axi4LiteSlaveWriteMonitorBFM

`endif
