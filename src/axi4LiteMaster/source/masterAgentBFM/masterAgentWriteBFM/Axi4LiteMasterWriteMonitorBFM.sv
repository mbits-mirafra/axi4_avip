`ifndef AXI4LITEMASTERWRITEMONITORBFM_INCLUDED_
`define AXI4LITEMASTERWRITEMONITORBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : Axi4LiteMasterWriteMonitorBFM
//Used as the HDL monitor for axi4
//It connects with the HVL Axi4LiteMasterWriteMonitorProxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteMasterWriteMonitorBFM(input bit aclk, 
                                        input bit aresetn,
                                        input  valid,
                                        input  ready
                                      );  

  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  import Axi4LiteMasterWritePkg::Axi4LiteMasterWriteMonitorProxy;  
  //Variable : axi4LiteMasterWriteMonitorProxy
  //Creating the handle for proxy monitor
 
  Axi4LiteMasterWriteMonitorProxy axi4LiteMasterWriteMonitorProxy;
  
  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //-------------------------------------------------------
  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info("FROM MASTER MON BFM",$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH) 
    @(posedge aresetn);
    `uvm_info("FROM MASTER MON BFM",$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn


endinterface : Axi4LiteMasterWriteMonitorBFM

`endif