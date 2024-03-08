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
  //-------------------------------------------------------
  // Task: axi4_slave_write_address_sampling
  // Used for sample the write address channel signals
  //-------------------------------------------------------
  task axi4_slave_write_address_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(posedge aclk);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("from axi4_slave_write_address_sampling "),UVM_HIGH)

    while(awvalid!==1 || awready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop from axi4_slave_write_address_sampling"),UVM_HIGH)
    end    
    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop from axi4_slave_write_address_sampling "),UVM_HIGH)
   
    req.awid = awid;
    req.awaddr = awaddr;
    req.awlen = awlen;
    req.awsize = awsize;
    req.awburst = awburst;
    req.awlock = awlock;
    req.awcache = awcache;
    req.awprot = awprot;  
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop from axi4_slave_write_address_sampling req=%p ",req),UVM_HIGH)
  endtask

  //-------------------------------------------------------
  // Task: axi4_slave_write_data_sampling
  // Used for sample the write data channel signals
  //-------------------------------------------------------
  task axi4_slave_write_data_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
endtask
 
  //-------------------------------------------------------
  // Task: axi4_write_response_sampling
  // Used for sample the write response channel signals
  //-------------------------------------------------------
  task axi4_write_response_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
  @(posedge aclk);
    while(bvalid!==1 || bready!==1)begin
    `uvm_info("FROM SLAVE MON BFM",$sformatf("values :: bvalid=%d & bready=%d",bvalid,bready),UVM_HIGH)
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop of write response sample"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop of write response "),UVM_HIGH)
    
    @(posedge aclk);
    req.bid      = bid;
    req.bresp    = bresp;  
    `uvm_info("FROM SLAVE MON BFM WRITE RESPONSE",$sformatf("write response packet: \n %p",req),UVM_HIGH)
  endtask


  /* 
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
  */
endinterface : Axi4LiteSlaveWriteMonitorBFM

`endif
