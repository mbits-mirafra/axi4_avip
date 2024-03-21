`ifndef AXI4LITESLAVEWRITEDRIVERBFM_INCLUDED_
`define AXI4LITESLAVEWRITEDRIVERBFM_INCLUDED_

//-------------------------------------------------------
// Importing global package
//-------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Axi4LiteSlaveWriteDriverBFM
//  Used as the HDL driver for axi4
//  It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
interface Axi4LiteSlaveWriteDriverBFM(input               aclk    , 
                                      input                     aresetn ,
                                      //Write_address_channel
                                      input [ADDRESS_WIDTH-1:0] awaddr  ,
                                      input [2: 0]              awprot  ,
                                      input                     awvalid ,
                                      output reg	              awready ,
      
                                      //Write_data_channel
                                      input [DATA_WIDTH-1: 0]     wdata  ,
                                      input [(DATA_WIDTH/8)-1: 0] wstrb  ,
                                      input                       wvalid ,
                                      output reg	                wready ,
      
                                      //Write Response Channel
                                      output reg [1:0]            bresp  ,
                                      output reg                  bvalid ,
                                      input		                    bready
                                    ); 
   import uvm_pkg::*;
  `include "uvm_macros.svh" 

  //-------------------------------------------------------
  // Importing Global Package
  //-------------------------------------------------------

  import Axi4LiteSlaveWritePkg::Axi4LiteSlaveWriteDriverProxy;
  //Variable: name
  //Used to store the name of the interface
  string name = "Axi4LiteSlaveWriteDriverBFM"; 
  
  //Variable: axi4LiteSlaveWriteDriverProxy
  //Creating the handle for MasterWriteDriverProxy
  Axi4LiteSlaveWriteDriverProxy axi4LiteSlaveWriteDriverProxy;

  reg [7: 0] i = 0;
  reg [7: 0] j = 0;
  reg [7: 0] a = 0;

  initial begin
    `uvm_info("axi4 slave driver bfm",$sformatf("AXI4 SLAVE DRIVER BFM"),UVM_LOW);
  end


  // Creating Memories for each signal to store each transaction attributes

  
  //-------------------------------------------------------
  // Task: wait_for_system_reset
  // Waiting for the system reset to be active low
  //-------------------------------------------------------

  task wait_for_system_reset();
    @(negedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET ACTIVATED"),UVM_NONE)
    awready <= 0;
    wready  <= 0;
    bvalid  <= 0;
    bresp   <= 'b0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DE-ACTIVATED"),UVM_NONE)
  endtask 
  
endinterface : Axi4LiteSlaveWriteDriverBFM

`endif

