`ifndef AXI4LITEMASTERREADDRIVERBFM_INCLUDED_
`define AXI4LITEMASTERREADDRIVERBFM_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteMasterReadDriverBFM(input bit  aclk, 
                                      input bit  aresetn,
                                      output reg valid,
                                      input      ready
                                     );  
  
  import uvm_pkg::*;
  `include "uvm_macros.svh" 

  import Axi4LiteMasterReadPkg::Axi4LiteMasterReadDriverProxy;
  string name = "Axi4LiteMasterReadDriverBFM"; 

  Axi4LiteMasterReadDriverProxy axi4LiteMasterReadDriverProxy;

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

task masterReadAddressChannelTask(inout axi4LiteReadTransferCharStruct masterReadCharStruct,axi4LiteReadTransferCfgStruct masterReadCfgStruct);

endtask : masterReadAddressChannelTask

task masterReadDataChannelTask(inout axi4LiteReadTransferCharStruct masterReadCharStruct,axi4LiteReadTransferCfgStruct masterReadCfgStruct);

endtask : masterReadDataChannelTask



endinterface : Axi4LiteMasterReadDriverBFM

`endif

