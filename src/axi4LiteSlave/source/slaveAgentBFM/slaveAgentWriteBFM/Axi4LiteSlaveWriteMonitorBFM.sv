`ifndef AXI4LITESLAVEWRITEMONITORBFM_INCLUDED_
`define AXI4LITESLAVEWRITEMONITORBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : Axi4LiteSlaveWriteMonitorBFM
//Used as the HDL monitor for axi4
//It connects with the HVL Axi4LiteSlaveWriteMonitorProxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveWriteMonitorBFM(input bit aclk, 
                                       input bit aresetn,
                                       input  valid,
                                       input  ready
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

endinterface : Axi4LiteSlaveWriteMonitorBFM

`endif
