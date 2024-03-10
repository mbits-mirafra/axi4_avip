`ifndef AXI4LITESLAVEREADDRIVERBFM_INCLUDED_
`define AXI4LITESLAVEREADDRIVERBFM_INCLUDED_

//-------------------------------------------------------
// Importing global package
//-------------------------------------------------------
import Axi4LiteGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Axi4LiteSlaveReadDriverBFM
//  Used as the HDL driver for axi4
//  It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
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
  
  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 

  //-------------------------------------------------------
  // Importing Global Package
  //-------------------------------------------------------
  import Axi4LiteSlaveReadPkg::Axi4LiteSlaveReadDriverProxy;

  //Variable: name
  //Used to store the name of the interface
  string name = "Axi4LiteSlaveReadDriverBFM"; 

  //Variable: axi4LiteSlaveReadDriverProxy
  //Creating the handle for SlaveWriteDriverProxy
  Axi4LiteSlaveReadDriverProxy axi4LiteSlaveReadDriverProxy;
  reg [7: 0] i = 0;
  reg [7: 0] j = 0;
  reg [7: 0] a = 0;

  initial begin
    `uvm_info("axi4 slave driver bfm",$sformatf("AXI4 SLAVE DRIVER BFM"),UVM_LOW);
  end

  // Creating Memories for each signal to store each transaction attributes

  reg [	ADDRESS_WIDTH-1: 0]	mem_raddr	  [2**LENGTH];
  
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

 //-------------------------------------------------------
  // Task: axi4_read_address_phase
  // This task will sample the read address signals
  //-------------------------------------------------------
  task axi4_read_address_phase (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);
    `uvm_info(name,$sformatf("data_read_packet=\n%p",data_read_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("INSIDE READ ADDRESS CHANNEL"),UVM_HIGH);
    
    // Ready can be HIGH even before we start to check 
    // based on wait_cycles variable
    // Can make arready to zero 
     arready <= 0;

    while(arvalid === 0) begin
      @(posedge aclk);
    end
   
    repeat(data_read_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING_READ_ADDRS_WAIT_STATES :: %0d",data_read_packet.no_of_wait_states),UVM_HIGH);
      @(posedge aclk);
      arready<=0;
    end

    `uvm_info("SLAVE_DRIVER_RADDR_PHASE", $sformatf("outside of arvalid"), UVM_NONE); 
    
    // Sample the values
	  mem_raddr	[j] 	= araddr	;
    arready         = 1       ;

    data_read_packet.araddr  = mem_raddr[j]    ;
	  j = j+1                                    ;

    `uvm_info(name,$sformatf("struct_pkt_rd_addr_phase = \n %0p",data_read_packet),UVM_HIGH)
    
    @(posedge aclk);
    arready <= 0;
  
  endtask: axi4_read_address_phase
    
  //-------------------------------------------------------
  // Task: axi4_read_data_channel_task
  // This task will drive the read data signals
  //-------------------------------------------------------
  task axi4_read_data_phase (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    `uvm_info(name,$sformatf("INSIDE READ DATA CHANNEL"),UVM_LOW);
    
  endtask : axi4_read_data_phase

endinterface : Axi4LiteSlaveReadDriverBFM

`endif

