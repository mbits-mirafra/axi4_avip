`ifndef AXI4LITEMASTERREADDRIVERBFM_INCLUDED_
`define AXI4LITEMASTERREADDRIVERBFM_INCLUDED_

//-------------------------------------------------------
// Importing global package
//-------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Axi4LiteMasterReadDriverBFM
//  Used as the HDL driver for axi4
//  It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
interface Axi4LiteMasterReadDriverBFM(input bit                      aclk, 
                                      input bit                      aresetn,
                                      //Write Address Channel Signals
                                      //Read Address Channel Signals
                                      output reg [ADDRESS_WIDTH-1:0] araddr,
                                      output reg               [2:0] arprot,
                                      output reg                     arvalid,
                                      input                          arready,
                                      //Read Data Channel Signals
                                      input      [DATA_WIDTH-1: 0] rdata,
                                      input                  [1:0] rresp,
                                      input                        rvalid,
                                      output	reg                   rready  
                                     );  
  
  import uvm_pkg::*;
  `include "uvm_macros.svh" 

  import Axi4LiteMasterReadPkg::Axi4LiteMasterReadDriverProxy;
  //Variable: name
  //Used to store the name of the interface
  string name = "Axi4LiteMasterReadDriverBFM"; 

  //Variable: axi4LiteMasterReadDriverProxy
  //Creating the handle for MasterWriteDriverProxy
  Axi4LiteMasterReadDriverProxy axi4LiteMasterReadDriverProxy;

  initial begin
    `uvm_info(name,$sformatf(name),UVM_LOW)
  end

  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //-------------------------------------------------------
  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH)
    arvalid <= 1'b0;
    rready  <= 1'b0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn

  //-------------------------------------------------------
  // Task: axi4_read_address_channel_task
  // This task will drive the read address signals
  //-------------------------------------------------------
  task axi4_read_address_channel_task (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);
    
    `uvm_info(name,$sformatf("data_read_packet=\n%p",data_read_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVE TO READ ADDRESS CHANNEL"),UVM_HIGH)

    araddr   <= data_read_packet.araddr;
    arprot   <= data_read_packet.arprot;
    arvalid  <= 1'b1;

    `uvm_info(name,$sformatf("detect_awready = %0d",arready),UVM_HIGH)
    do begin
      @(posedge aclk);
      data_read_packet.wait_count_read_address_channel++;
    end
    while(arready !== 1);

    `uvm_info(name,$sformatf("After_loop_of_Detecting_arready = %0d, awvalid = %0d",arready,arvalid),UVM_HIGH)
    arvalid <= 1'b0;
  endtask : axi4_read_address_channel_task

  //-------------------------------------------------------
  // Task: axi4_read_data_channel_task
  // This task will drive the read data signals
  //-------------------------------------------------------
  task axi4_read_data_channel_task (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    
    static reg [7:0]i =0;
    `uvm_info(name,$sformatf("data_read_packet in read data Channel=\n%p",data_read_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVE TO READ DATA CHANNEL"),UVM_HIGH)
    
    do begin
      @(posedge aclk);
      //Driving rready as low initially
      rready  <= 0;
    end while(rvalid === 1'b0);
    
    repeat(data_read_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING WAIT STATES in read data channel :: %0d",data_read_packet.no_of_wait_states),UVM_HIGH);
      @(posedge aclk);
    end

    //Driving ready as high
    rready <= 1'b1;

    forever begin
      do begin
        @(posedge aclk);
      end while(rvalid === 1'b0);

      data_read_packet.rdata[i] = rdata;
      data_read_packet.rresp    = rresp;
      `uvm_info(name,$sformatf("DEBUG_NA:RDATA[%0d]=%0h",i,data_read_packet.rdata[i]),UVM_HIGH)
      
      i++;  

    end
   
    @(posedge aclk);
    rready <= 1'b0;

  endtask : axi4_read_data_channel_task

endinterface : Axi4LiteMasterReadDriverBFM

`endif

