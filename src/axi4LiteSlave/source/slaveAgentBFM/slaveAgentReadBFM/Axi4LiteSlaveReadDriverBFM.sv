`ifndef AXI4LITESLAVEREADDRIVERBFM_INCLUDED_
`define AXI4LITESLAVEREADDRIVERBFM_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveReadDriverBFM(input bit  aclk, 
                                     input bit  aresetn,
                                     input      valid,
                                     output reg ready
                                    );  
  
  import uvm_pkg::*;
  `include "uvm_macros.svh" 

  import Axi4LiteSlaveReadPkg::Axi4LiteSlaveReadDriverProxy;

  string name = "Axi4LiteSlaveReadDriverBFM"; 

  Axi4LiteSlaveReadDriverProxy axi4LiteSlaveReadDriverProxy;
 
  initial begin
    `uvm_info("axi4 slave driver bfm",$sformatf("AXI4 SLAVE DRIVER BFM"),UVM_LOW);
  end

   task wait_for_system_reset();
    @(negedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET ACTIVATED"),UVM_NONE)
    ready <= 0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DE-ACTIVATED"),UVM_NONE)
  endtask 
 
  initial begin
    `uvm_info(name,$sformatf(name),UVM_LOW)
  end

  task slaveReadAddressChannelTask(inout axi4LiteReadTransferCharStruct slaveReadCharStruct,axi4LiteReadTransferCfgStruct slaveReadCfgStruct);

  endtask : slaveReadAddressChannelTask

task slaveReadDataChannelTask(inout axi4LiteReadTransferCharStruct slaveReadCharStruct,axi4LiteReadTransferCfgStruct slaveReadCfgStruct);

endtask : slaveReadDataChannelTask

task slaveReadResponseChannelTask(inout axi4LiteReadTransferCharStruct slaveReadCharStruct,axi4LiteReadTransferCfgStruct slaveReadCfgStruct);

endtask : slaveReadResponseChannelTask



  
 endinterface : Axi4LiteSlaveReadDriverBFM

`endif

