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
    `uvm_info(name,$sformatf("SYSTEM RESET ACTIVATED"),UVM_HIGH)
    ready <= 0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DE-ACTIVATED"),UVM_HIGH)
  endtask 
 
  initial begin
    `uvm_info(name,$sformatf(name),UVM_LOW)
  end

  task readChannelTask(input axi4LiteReadTransferCfgStruct slaveReadCfgStruct, 
                       inout axi4LiteReadTransferCharStruct slaveReadCharStruct
                      );
    `uvm_info(name,$sformatf("READ_CHANNEL_TASK_STARTED"),UVM_HIGH)
    do begin
      @(posedge aclk);
    end while(valid===0);

    repeat(slaveReadCharStruct.readDelayForReady) begin 
      @(posedge aclk);
    end
    ready <= 1'b1;
    `uvm_info(name,$sformatf("READ_CHANNEL_TASK_ENDED"),UVM_HIGH)
  endtask

/*
  task slaveReadAddressChannelTask(inout axi4LiteReadTransferCharStruct slaveReadCharStruct,axi4LiteReadTransferCfgStruct slaveReadCfgStruct);

  endtask : slaveReadAddressChannelTask

task slaveReadDataChannelTask(inout axi4LiteReadTransferCharStruct slaveReadCharStruct,axi4LiteReadTransferCfgStruct slaveReadCfgStruct);

endtask : slaveReadDataChannelTask

task slaveReadResponseChannelTask(inout axi4LiteReadTransferCharStruct slaveReadCharStruct,axi4LiteReadTransferCfgStruct slaveReadCfgStruct);

endtask : slaveReadResponseChannelTask

*/
 endinterface : Axi4LiteSlaveReadDriverBFM

`endif

