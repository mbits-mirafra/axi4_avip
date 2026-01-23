`ifndef AXI4_SLAVE_MONITOR_BFM_INCLUDED_
`define AXI4_SLAVE_MONITOR_BFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : axi4_slave_monitor_bfm
//Used as the HDL monitor for axi4
//It connects with the HVL monitor_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import axi4_globals_pkg::*;
interface axi4_slave_monitor_bfm(input aclk, input aresetn,
                                //Write_address_channel
                                input [3:0]awid    ,
                                input [ADDRESS_WIDTH-1:0]awaddr  ,
                                input [3: 0]awlen   ,
                                input [2: 0]awsize  ,
                                input [1: 0]awburst ,
                                input [1: 0]awlock  ,
                                input [3: 0]awcache ,
                                input [2: 0]awprot  ,
                                input awvalid ,
                                input awready ,

                                
                                //write_data_channel
                                input [DATA_WIDTH-1: 0]wdata  ,
                                input [(DATA_WIDTH/8)-1: 0]wstrb  ,
                                input wlast  ,
                                input [3: 0]wuser  ,
                                input wvalid ,
                                input wready ,

                                //Write Response Channel
                                input  [3:0]bid    ,
                                input  [1:0]bresp  ,
                                input  [3:0]buser  ,
                                input bvalid ,
                                input bready ,

                                //Read Address Channel
                                input [3: 0] arid    ,
                                input [ADDRESS_WIDTH-1: 0]araddr  ,
                                input [7:0]arlen   ,
                                input [2:0]arsize  ,
                                input [1:0]arburst ,
                                input [1:0]arlock  ,
                                input [3:0]arcache ,
                                input [2:0]arprot  ,
                                input [3:0]arqos   ,
                                input [3:0]arregion,
                                input [3:0]aruser  ,
                                input arvalid ,
                                input arready ,

                                //Read Data Channel
                                input  [3:0]rid    ,
                                input  [DATA_WIDTH-1: 0]rdata  ,
                                input  [1:0]rresp  ,
                                input  rlast  ,
                                input  [3:0]ruser  ,
                                input  rvalid ,
                                input  rready   
  
                               ); 
  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  //-------------------------------------------------------
  // Importing axi4 Global Package slave package
  //-------------------------------------------------------
  import axi4_slave_pkg::axi4_slave_monitor_proxy;

  reg[3:0] i = 0;

  //Variable : axi4_slave_monitor_proxy_h
  //Creating the handle for proxy monitor
  axi4_slave_monitor_proxy axi4_slave_mon_proxy_h;
  
  //Printing axi4 slave monitor bfm
  initial begin
    `uvm_info("axi4 slave monitor bfm",$sformatf("AXI4 SLAVE MONITOR BFM"),UVM_LOW);
  end

  
 clocking slaveMonCb @(posedge aclk);
   default input #1step output #1step;
   input awid ,awaddr, awlen,awsize,awburst,awlock,awcache,awprot,awvalid,awready,wdata,wstrb,wlast,wuser,wvalid,
    wready,bid,bresp,buser,bvalid,bready,arid,araddr,arlen,arsize,arburst,arlock,arcache,arprot,arqos,arregion,
    aruser,arvalid,arready,rid,rdata,rresp,rlast,ruser,rvalid,rready;
  endclocking 

  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //------------------------------------------------------
  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH)
   
    @(posedge aresetn);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn
  
  //-------------------------------------------------------
  // Task: axi4_slave_write_address_sampling
  // Used for sample the write address channel signals
  //-------------------------------------------------------
  task axi4_slave_write_address_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(slaveMonCb);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("from axi4_slave_write_address_sampling "),UVM_HIGH)

    while(slaveMonCb.awvalid!==1 || slaveMonCb.awready!==1)begin
      @(slaveMonCb);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop from axi4_slave_write_address_sampling"),UVM_HIGH)
    end    
    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop from axi4_slave_write_address_sampling "),UVM_HIGH)
   
    req.awid = slaveMonCb.awid;
    req.awaddr = slaveMonCb.awaddr;
    req.awlen = slaveMonCb.awlen;
    req.awsize = slaveMonCb.awsize;
    req.awburst = slaveMonCb.awburst;
    req.awlock = slaveMonCb.awlock;
    req.awcache = slaveMonCb.awcache;
    req.awprot = slaveMonCb.awprot;  
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop from axi4_slave_write_address_sampling req=%0p ",req),UVM_FULL)
  endtask

  //-------------------------------------------------------
  // Task: axi4_slave_write_data_sampling
  // Used for sample the write data channel signals
  //-------------------------------------------------------
  task axi4_slave_write_data_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
  
  
   // wait for valid and ready to be high
   do begin
   @(slaveMonCb);
   end while(slaveMonCb.wvalid!==1 || slaveMonCb.wready!==1);

   `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop......"),UVM_HIGH)
    req.wdata[0] = slaveMonCb.wdata;
    req.wstrb[0] = slaveMonCb.wstrb;
    req.wlast =slaveMonCb.wlast;
    req.wuser[i] = slaveMonCb.wuser;

   `uvm_info("FROM SLAVE MON BFM write data",$sformatf("write datapacket wdata[%0d] = 'h%0x",i,req.wdata[i]),UVM_HIGH)
   `uvm_info("FROM SLAVE MON BFM write data",$sformatf("write datapacket wstrb[%0d] = 'h%0x",i,req.wstrb[i]),UVM_HIGH)

 
 endtask
 
  //-------------------------------------------------------
  // Task: axi4_write_response_sampling
  // Used for sample the write response channel signals
  //-------------------------------------------------------
  task axi4_write_response_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
  @(slaveMonCb);
    while(slaveMonCb.bvalid!==1 || slaveMonCb.bready!==1)begin
    `uvm_info("FROM SLAVE MON BFM",$sformatf("values :: bvalid=%d & bready=%d",bvalid,bready),UVM_HIGH)
      @(slaveMonCb);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop of write response sample"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop of write response "),UVM_HIGH)
    
    @(slaveMonCb);
    req.bid      = slaveMonCb.bid;
    req.bresp    = slaveMonCb.bresp;  
    `uvm_info("FROM SLAVE MON BFM WRITE RESPONSE",$sformatf("write response packet: \n %p",req),UVM_FULL)
  endtask

  //-------------------------------------------------------
  // Task: axi4_read_address_sampling
  // Used for sample the read address channel signals
  //-------------------------------------------------------  
  task axi4_read_address_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(slaveMonCb);
    while(slaveMonCb.arvalid!==1 || slaveMonCb.arready!==1)begin
      @(slaveMonCb);
      `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("INSIDE WHILE LOOP OF READ ADDRESS"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("AFTER WHILE LOOP OF READ ADDRESS"),UVM_HIGH)
    
    req.arid     = slaveMonCb.arid;
    req.araddr   = slaveMonCb.araddr;
    req.arlen    = slaveMonCb.arlen;
    req.arsize   = slaveMonCb.arsize;
    req.arburst  = slaveMonCb.arburst;
    req.arlock   = slaveMonCb.arlock;
    req.arcache  = slaveMonCb.arcache;
    req.arprot   = slaveMonCb.arprot;
    req.arqos    = slaveMonCb.arqos;
    req.arregion = slaveMonCb.arregion;
    req.aruser   = slaveMonCb.aruser;

    `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("datapacket =%p",req),UVM_FULL)
  endtask

  //-------------------------------------------------------
  // Task: axi4_read_data_sampling
  // Used for sample the read data channel signals
  //-------------------------------------------------------
  task axi4_read_data_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
    static reg[7:0] i = 0;
    
    
      // Wait for valid and ready to be high
      do begin
        @(slaveMonCb);
      end while((rvalid!==1 || rready!==1));
  
      `uvm_info("FROM SLAVE MON BFM",$sformatf("after do_while loop of read data sample"),UVM_HIGH)

      req.rid      = slaveMonCb.rid;
      req.rdata[0] = slaveMonCb.rdata;
      req.ruser    = slaveMonCb.ruser;
      req.rresp    = slaveMonCb.rresp;
      req.rlast    = slaveMonCb.rlast;

      `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON REQ.RID=%0d",req.rid),UVM_HIGH)
      `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON RDATA[%0d]=%0h",i,rdata),UVM_HIGH)
      `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON REQ.RDATA[%0d]=%0h",i,req.rdata[i]),UVM_HIGH)
 
 
  endtask

endinterface : axi4_slave_monitor_bfm
`endif
