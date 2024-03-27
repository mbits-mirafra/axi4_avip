`ifndef AXI4LITESLAVEWRITEDRIVERBFM_INCLUDED_
`define AXI4LITESLAVEWRITEDRIVERBFM_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveWriteDriverBFM(input      aclk, 
                                      input      aresetn,
                                      input      valid,
                                      output reg ready
                                    ); 
   import uvm_pkg::*;
  `include "uvm_macros.svh" 

  import Axi4LiteSlaveWritePkg::Axi4LiteSlaveWriteDriverProxy;
  //Variable: name
  //Used to store the name of the interface
  string name = "Axi4LiteSlaveWriteDriverBFM"; 
  
  //Variable: axi4LiteSlaveWriteDriverProxy
  //Creating the handle for MasterWriteDriverProxy
  Axi4LiteSlaveWriteDriverProxy axi4LiteSlaveWriteDriverProxy;

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

task slaveWriteAddressChannelTask(inout axi4LiteWriteTransferCharStruct slaveWriteCharStruct,axi4LiteWriteTransferCfgStruct slaveWriteCfgStruct);

endtask : slaveWriteAddressChannelTask

task slaveWriteDataChannelTask(inout axi4LiteWriteTransferCharStruct slaveWriteCharStruct,axi4LiteWriteTransferCfgStruct slaveWriteCfgStruct);

endtask : slaveWriteDataChannelTask

task slaveWriteResponseChannelTask(inout axi4LiteWriteTransferCharStruct slaveWriteCharStruct,axi4LiteWriteTransferCfgStruct slaveWriteCfgStruct);

endtask : slaveWriteResponseChannelTask



endinterface : Axi4LiteSlaveWriteDriverBFM

`endif

