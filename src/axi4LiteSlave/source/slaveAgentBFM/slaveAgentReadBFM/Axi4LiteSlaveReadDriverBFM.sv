`ifndef AXI4LITESLAVEREADDRIVERBFM_INCLUDED_
`define AXI4LITESLAVEREADDRIVERBFM_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveReadDriverBFM(input bit                      aclk, 
                                     input bit                      aresetn,
                                     //Read Address Channel
                                     input [ADDRESS_WIDTH-1: 0]  araddr  ,
                                     input [2:0]                 arprot  ,
                                     input                       arvalid ,
                                     output reg                  arready ,
     
                                     //Read Data Channel
                                     output reg [DATA_WIDTH-1: 0]    rdata  ,
                                     output reg [1:0]                rresp  ,
                                     output reg                      rvalid ,
                                     input		                        rready   
                                    );  
  
  import uvm_pkg::*;
  `include "uvm_macros.svh" 

  import Axi4LiteSlaveReadPkg::Axi4LiteSlaveReadDriverProxy;

  string name = "Axi4LiteSlaveReadDriverBFM"; 

  Axi4LiteSlaveReadDriverProxy axi4LiteSlaveReadDriverProxy;
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
    rvalid  <= 0;
    arready <= 0;
    rdata   <= 'b0;
    rresp   <= 'b0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DE-ACTIVATED"),UVM_NONE)
  endtask 
 
  initial begin
    `uvm_info(name,$sformatf(name),UVM_LOW)
  end

 endinterface : Axi4LiteSlaveReadDriverBFM

`endif

