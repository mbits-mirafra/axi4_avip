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
      
    req.awid    = awid ;
    req.awaddr  = awaddr;
    req.awlen   = awlen;
    req.awsize  = awsize;
    req.awburst = awburst;
    req.awlock  = awlock;
    req.awcache = awcache;
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
      req.wuser[i] = wuser;
      req.wlast    = wlast;
  
      `uvm_info("FROM MASTER MON BFM write data",$sformatf("write datapacket wdata[%0d] = 'h%0x",i,req.wdata[i]),UVM_HIGH)
      `uvm_info("FROM MASTER MON BFM write data",$sformatf("write datapacket wstrb[%0d] = 'h%0x",i,req.wstrb[i]),UVM_HIGH)
      if(req.wlast == 1) begin
        `uvm_info("FROM MASTER MON BFM write data",$sformatf("Inside wlast write datapacket  =%p",req),UVM_HIGH)
        i = 0;
        break;
      end
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
    req.bid      = bid;
    req.bresp    = bresp;
    `uvm_info("FROM MASTER MON BFM::WRITE RESPONSE",$sformatf("WRITE RESPONSE PACKET: \n %p",req),UVM_HIGH)
  endtask
  
  //-------------------------------------------------------
  // Task: axi4_read_address_sampling
  // Used for sample the read address channel signals
  //-------------------------------------------------------
  task axi4_read_address_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    do begin
      @(posedge aclk);
    end while((arvalid!==1 || arready!==1));

    req.arid    = arid;
    req.araddr  = araddr;
    req.arlen   = arlen;
    req.arsize  = arsize;
    req.arburst = arburst;
    req.arlock  = arlock;
    req.arcache = arcache;
    req.arprot  = arprot;
    req.arqos   = arqos;
    req.arregion = arregion;
    req.aruser     = aruser;
    `uvm_info("FROM MASTER MON BFM",$sformatf("datapacket =%p",req),UVM_HIGH)
  endtask
  
  //-------------------------------------------------------
  // Task: axi4_read_data_sampling
  // Used for sample the read data channel signals
  //-------------------------------------------------------
  task axi4_read_data_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
    static reg[7:0] i = 0;
    forever begin
      // Wait for valid and ready to be high
      do begin
        @(posedge aclk);
      end while((rvalid!==1 || rready!==1));
  
      req.rid      = rid;
      req.rdata[i] = rdata;
      req.ruser    = ruser;
      req.rresp    = rresp;
      req.rlast    = rlast;
      i++;
      
      if(req.rlast == 1) begin
        `uvm_info("FROM MASTER MON BFM write data",$sformatf("Inside RLAST Read Data Packet  =%p",req),UVM_HIGH)
        i = 0;
        break;
      end 
      `uvm_info("FROM MASTER MON BFM READ DATA",$sformatf("Read data packet: %p",req),UVM_HIGH)
    end
  endtask
endinterface : axi4_master_monitor_bfm

`endif
