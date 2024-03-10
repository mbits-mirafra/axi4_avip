`ifndef AXI4LITEMASTERWRITEMONITORBFM_INCLUDED_
`define AXI4LITEMASTERWRITEMONITORBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : Axi4LiteMasterWriteMonitorBFM
//Used as the HDL monitor for axi4
//It connects with the HVL Axi4LiteMasterWriteMonitorProxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteMasterWriteMonitorBFM(input bit aclk, input bit aresetn,
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

  //-------------------------------------------------------
  // Task: axi4_write_address_sampling
  // Used for sample the write address channel signals
  //-------------------------------------------------------
  task axi4_write_address_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(posedge aclk);
    while(awvalid!==1 || awready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM MASTER MON BFM",$sformatf("Inside while loop......"),UVM_HIGH)
    end    
    `uvm_info("FROM MASTER MON BFM",$sformatf("after while loop ......."),UVM_HIGH)
      
    req.awaddr  = awaddr;
    req.awprot  = awprot;
    `uvm_info("FROM MASTER MON BFM",$sformatf("datapacket =%p",req),UVM_HIGH)
  endtask
  
  //-------------------------------------------------------
  // Task: axi4_write_data_sampling
  // Used for sample the write data channel signals
  //-------------------------------------------------------
  task axi4_write_data_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    static int i = 0;

    forever begin
      // Wait for valid and ready to be high
      do begin
        @(posedge aclk);
      end while((wvalid!==1 || wready!==1));
      `uvm_info("FROM MASTER MON BFM",$sformatf("After while loop write data......"),UVM_HIGH)
  
      req.wdata[i] = wdata;
      req.wstrb[i] = wstrb;
  
      `uvm_info("FROM MASTER MON BFM write data",$sformatf("write datapacket wdata[%0d] = 'h%0x",i,req.wdata[i]),UVM_HIGH)
      `uvm_info("FROM MASTER MON BFM write data",$sformatf("write datapacket wstrb[%0d] = 'h%0x",i,req.wstrb[i]),UVM_HIGH)
     i++;
    end
  endtask 

  //-------------------------------------------------------
  // Task: axi4_write_response_sampling
  // Used for sample the write response channel signals
  //-------------------------------------------------------
  task axi4_write_response_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
    `uvm_info("FROM MASTER MON BFM",$sformatf("AFTER WHILE LOOP OF WRITE RESPONSE"),UVM_HIGH)
   
    do begin
      @(posedge aclk);
    end while((bvalid!==1 || bready!==1));
    req.bresp    = bresp;
    `uvm_info("FROM MASTER MON BFM::WRITE RESPONSE",$sformatf("WRITE RESPONSE PACKET: \n %p",req),UVM_HIGH)
  endtask

endinterface : Axi4LiteMasterWriteMonitorBFM

`endif
