`ifndef AXI4LITESLAVEREADMONITORBFM_INCLUDED_
`define AXI4LITESLAVEREADMONITORBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : Axi4LiteSlaveReadMonitorBFM
//Used as the HDL monitor for axi4
//It connects with the HVL monitor_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveReadMonitorBFM(input bit aclk, input bit aresetn,
                                      //Read Address Channel Signals
                                      input  [ADDRESS_WIDTH-1: 0]araddr,
                                      input  [2:0]arprot,
                                      input  arvalid,
                                      input  arready, 
                                      //Read Data Channel Signals
                                      input  [DATA_WIDTH-1: 0]rdata,
                                      input  [1:0]rresp,
                                      input  rvalid,
                                      input  rready  
                                     );  

  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  //-------------------------------------------------------
  // Importing axi4 Global Package Slave package
  //-------------------------------------------------------
  import Axi4LiteSlaveReadPkg::Axi4LiteSlaveReadMonitorProxy;
 
  //Variable : Axi4LiteSlaveReadMonitorProxy
  //Creating the handle for proxy monitor
 
  Axi4LiteSlaveReadMonitorProxy axi4LiteSlaveReadMonitorProxy;
  
  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //-------------------------------------------------------
  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info("axi4LiteSlaveReadMonitorProxy",$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH) 
    @(posedge aresetn);
    `uvm_info("FROM Slave MON BFM",$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn

  //-------------------------------------------------------
  // Task: axi4_read_address_sampling
  // Used for sample the read address channel signals
  //-------------------------------------------------------
  task axi4_read_address_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(posedge aclk);
    while(arvalid!==1 || arready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("INSIDE WHILE LOOP OF READ ADDRESS"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("AFTER WHILE LOOP OF READ ADDRESS"),UVM_HIGH)
    
    req.araddr   = araddr;
    req.arprot   = arprot;

    `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("datapacket =%p",req),UVM_HIGH)
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
  
      `uvm_info("FROM SLAVE MON BFM",$sformatf("after do_while loop of read data sample"),UVM_HIGH)

      req.rdata[i] = rdata;
      req.rresp    = rresp;

      `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON REQ.RID=%0d",req.rid),UVM_HIGH)
      `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON RDATA[%0d]=%0h",i,rdata),UVM_HIGH)
      `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON REQ.RDATA[%0d]=%0h",i,req.rdata[i]),UVM_HIGH)
      i++;
      
      `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("Read data packet: %p",req),UVM_HIGH)
   end
  endtask

  
endinterface : Axi4LiteSlaveReadMonitorBFM

`endif
