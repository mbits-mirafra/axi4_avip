`ifndef AXI4_MASTER_MONITOR_BFM_INCLUDED_
`define AXI4_MASTER_MONITOR_BFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : axi4_master_monitor_bfm
//Used as the HDL monitor for axi4
//It connects with the HVL monitor_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import axi4_globals_pkg::*;

interface axi4_master_monitor_bfm(input bit aclk, input bit aresetn,
                                 //Write Address Channel Signals
                                 input  [3:0]awid,
                                 input  [ADDRESS_WIDTH-1:0]awaddr,
                                 input  [3:0]awlen,
                                 input  [2:0]awsize,
                                 input  [1:0]awburst,
                                 input  [1:0]awlock,
                                 input  [3:0]awcache,
                                 input  [2:0]awprot,
                                 input  awvalid,
                                 input  awready,

                                 //Write Data Channel Signals
                                 input  [DATA_WIDTH-1: 0]wdata,
                                 input  [(DATA_WIDTH/8)-1:0]wstrb,
                                 input  wlast,
                                 input  [3:0]wuser,
                                 input  wvalid,
                                 input  wready,

                                 //Write Response Channel Signals
                                 input  [3:0]bid,
                                 input  [1:0]bresp,
                                 input  [3:0]buser,
                                 input  bvalid,
                                 input  bready,

                                 //Read Address Channel Signals
                                 input  [3:0]arid,
                                 input  [ADDRESS_WIDTH-1: 0]araddr,
                                 input  [7:0]arlen,
                                 input  [2:0]arsize,
                                 input  [1:0]arburst,
                                 input  [1:0]arlock,
                                 input  [3:0]arcache,
                                 input  [2:0]arprot,
                                 input  [3:0]arqos,
                                 input  [3:0]arregion,
                                 input  [3:0]aruser,
                                 input  arvalid,
                                 input  arready,
                                 //Read Data Channel Signals
                                 input  [3:0]rid,
                                 input  [DATA_WIDTH-1: 0]rdata,
                                 input  [1:0]rresp,
                                 input  rlast,
                                 input  [3:0]ruser,
                                 input  rvalid,
                                 input  rready  
                                );  

  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  //-------------------------------------------------------
  // Importing axi4 Global Package master package
  //-------------------------------------------------------
  import axi4_master_pkg::axi4_master_monitor_proxy;
 
  //Variable : axi4_master_monitor_proxy_h
  //Creating the handle for proxy monitor
 
  axi4_master_monitor_proxy axi4_master_mon_proxy_h;
  


  clocking masterMonCb @(posedge aclk);
   default input #1step output #1step;
   input awid ,awaddr, awlen,awsize,awburst,awlock,awcache,awprot,awvalid,awready,wdata,wstrb,wlast,wuser,wvalid,
    wready,bid,bresp,buser,bvalid,bready,arid,araddr,arlen,arsize,arburst,arlock,arcache,arprot,arqos,arregion,
    aruser,arvalid,arready,rid,rdata,rresp,rlast,ruser,rvalid,rready;
  endclocking 
   
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

    @(masterMonCb);
    while(masterMonCb.awvalid!==1 || masterMonCb.awready!==1)begin
      @(masterMonCb);
      `uvm_info("FROM MASTER MON BFM",$sformatf("Inside while loop......"),UVM_HIGH)
    end    
    `uvm_info("FROM MASTER MON BFM",$sformatf("after while loop ......."),UVM_HIGH)
      
    req.awid    = masterMonCb.awid ;
    req.awaddr  = masterMonCb.awaddr;
    req.awlen   = masterMonCb.awlen;
    req.awsize  = masterMonCb.awsize;
    req.awburst = masterMonCb.awburst;
    req.awlock  = masterMonCb.awlock;
    req.awcache = masterMonCb.awcache;
    req.awprot  = masterMonCb.awprot;
    `uvm_info("FROM MASTER MON BFM",$sformatf("datapacket =%p",req),UVM_FULL)
  endtask
  
  //-------------------------------------------------------
  // Task: axi4_write_data_sampling
  // Used for sample the write data channel signals
  //-------------------------------------------------------
  task axi4_write_data_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    static int i = 0;

    
      // Wait for valid and ready to be high
      do begin
        @(masterMonCb);
      end while((masterMonCb.wvalid!==1 || masterMonCb.wready!==1));
      `uvm_info("FROM MASTER MON BFM",$sformatf("After while loop write data......"),UVM_HIGH)
  
      req.wdata[0] = masterMonCb.wdata;
      req.wstrb[0] = masterMonCb.wstrb;
      req.wuser[0] = masterMonCb.wuser;
      req.wlast    = masterMonCb.wlast;
  
      `uvm_info("FROM MASTER MON BFM write data",$sformatf("write datapacket wdata[%0d] = 'h%0x",i,req.wdata[i]),UVM_HIGH)
      `uvm_info("FROM MASTER MON BFM write data",$sformatf("write datapacket wstrb[%0d] = 'h%0x",i,req.wstrb[i]),UVM_HIGH)
    
  endtask 

  //-------------------------------------------------------
  // Task: axi4_write_response_sampling
  // Used for sample the write response channel signals
  //-------------------------------------------------------
  task axi4_write_response_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
    `uvm_info("FROM MASTER MON BFM",$sformatf("AFTER WHILE LOOP OF WRITE RESPONSE"),UVM_HIGH)
   
    do begin
      @(masterMonCb);
    end while((masterMonCb.bvalid!==1 || masterMonCb.bready!==1));
    req.bid      = masterMonCb.bid;
    req.bresp    = masterMonCb.bresp;
    `uvm_info("FROM MASTER MON BFM::WRITE RESPONSE",$sformatf("WRITE RESPONSE PACKET: \n %p",req),UVM_FULL)
  endtask
  
  //-------------------------------------------------------
  // Task: axi4_read_address_sampling
  // Used for sample the read address channel signals
  //-------------------------------------------------------
  task axi4_read_address_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    do begin
      @(masterMonCb);
    end while((masterMonCb.arvalid!==1 || masterMonCb.arready!==1));

    req.arid    = masterMonCb.arid;
    req.araddr  = masterMonCb.araddr;
    req.arlen   = masterMonCb.arlen;
    req.arsize  = masterMonCb.arsize;
    req.arburst = masterMonCb.arburst;
    req.arlock  = masterMonCb.arlock;
    req.arcache = masterMonCb.arcache;
    req.arprot  = masterMonCb.arprot;
    req.arqos   = masterMonCb.arqos;
    req.arregion = masterMonCb.arregion;
    req.aruser     = masterMonCb.aruser;
    `uvm_info("FROM MASTER MON BFM",$sformatf("datapacket =%p",req),UVM_FULL)
  endtask
  
  //-------------------------------------------------------
  // Task: axi4_read_data_sampling
  // Used for sample the read data channel signals
  //-------------------------------------------------------
  task axi4_read_data_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
    static reg[7:0] i = 0;
   
      // Wait for valid and ready to be high
      do begin
        @(masterMonCb);
      end while((masterMonCb.rvalid!==1 || masterMonCb.rready!==1));
  
      req.rid      = masterMonCb.rid;
      req.rdata[0] = masterMonCb.rdata;
      req.ruser    = masterMonCb.ruser;
      req.rresp    = masterMonCb.rresp;
      req.rlast    = masterMonCb.rlast;
      i++;
      
     
  endtask
endinterface : axi4_master_monitor_bfm

`endif
