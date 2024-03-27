`ifndef AXI4LITEMASTERWRITEDRIVERBFM_INCLUDED_
`define AXI4LITEMASTERWRITEDRIVERBFM_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteMasterWriteDriverBFM(input bit  aclk, 
                                       input bit  aresetn,
                                       output reg valid,
                                       input    	ready
                                      );  
  
  import uvm_pkg::*;
  `include "uvm_macros.svh" 


import Axi4LiteMasterWritePkg::Axi4LiteMasterWriteDriverProxy; 
  //Variable: name
  //Used to store the name of the interface
  string name = "Axi4LiteMasterWriteDriverBFM"; 

  //Variable: axi4LiteMasterWriteDriverProxy
  //Creating the handle for MasterWriteDriverProxy
  Axi4LiteMasterWriteDriverProxy axi4LiteMasterWriteDriverProxy;

  initial begin
    `uvm_info(name,$sformatf(name),UVM_LOW)
  end

  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //-------------------------------------------------------
  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH)
    valid <= 1'b0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn

task masterWriteAddressChannelTask(inout axi4LiteWriteTransferCharStruct masterWriteCharStruct,axi4LiteWriteTransferCfgStruct masterWriteCfgStruct);

endtask : masterWriteAddressChannelTask

task masterWriteDataChannelTask(inout axi4LiteWriteTransferCharStruct masterWriteCharStruct,axi4LiteWriteTransferCfgStruct masterWriteCfgStruct);

endtask : masterWriteDataChannelTask

task masterWriteResponseChannelTask(inout axi4LiteWriteTransferCharStruct masterWriteCharStruct,axi4LiteWriteTransferCfgStruct masterWriteCfgStruct);

endtask : masterWriteResponseChannelTask

endinterface : Axi4LiteMasterWriteDriverBFM

`endif

