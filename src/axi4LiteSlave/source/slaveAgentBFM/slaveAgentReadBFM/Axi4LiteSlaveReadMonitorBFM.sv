`ifndef AXI4LITESLAVEREADMONITORBFM_INCLUDED_
`define AXI4LITESLAVEREADMONITORBFM_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveReadMonitorBFM(input bit aclk, input bit aresetn,
                                      //Read Address Channel Signals
                                      input  [ADDRESS_WIDTH-1: 0]araddr,
                                      input  [2:0]arprot,
                                      input  arvalid,
                                      input  arready, 
                                      //Read Data Channel Signals
                                      input  [DATA_WIDTH-1: 0]rdata,
                                      input  [1:0]rresp,
                                      input  rvalid,
                                      input  rready  
                                     );  

  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  import Axi4LiteSlaveReadPkg::Axi4LiteSlaveReadMonitorProxy;
 
  Axi4LiteSlaveReadMonitorProxy axi4LiteSlaveReadMonitorProxy;
  
  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //-------------------------------------------------------
  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info("axi4LiteSlaveReadMonitorProxy",$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH) 
    @(posedge aresetn);
    `uvm_info("FROM Slave MON BFM",$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn

endinterface : Axi4LiteSlaveReadMonitorBFM

`endif
