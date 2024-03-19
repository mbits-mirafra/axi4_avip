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

endinterface : Axi4LiteSlaveWriteMonitorBFM

`endif
