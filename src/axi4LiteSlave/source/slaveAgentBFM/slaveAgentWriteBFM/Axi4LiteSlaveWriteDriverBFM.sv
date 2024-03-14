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

  reg [	ADDRESS_WIDTH-1: 0]	mem_waddr	  [2**LENGTH];
  
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
  
  //-------------------------------------------------------
  // Task: axi_write_address_phase
  // Sampling the signals that are associated with write_address_channel
  //-------------------------------------------------------

  task axi4_write_address_phase(inout axi4_write_transfer_char_s data_write_packet);
    @(posedge aclk);
    `uvm_info(name,"INSIDE WRITE_ADDRESS_PHASE",UVM_LOW)

    // Ready can be HIGH even before we start to check 
    // based on wait_cycles variable
    // Can make awready to zero 
    awready <= 0;

    do begin
      @(posedge aclk);
    end while(awvalid===0);

    `uvm_info("SLAVE_DRIVER_WADDR_PHASE", $sformatf("outside of awvalid"), UVM_MEDIUM);
    
    if(axi4LiteSlaveWriteDriverProxy.axi4LiteSlaveWriteAddressFIFO.is_full()) begin
      `uvm_error("UVM_TLM_FIFO","FIFO is now FULL!")
    end 
      
   // Sample the values
	 mem_waddr	[i] 	= awaddr	;
   
   data_write_packet.awaddr  = mem_waddr  [i] ;
   
   i = i+1                   ;
    
   `uvm_info("i_SLAVE_ADDR_BFM",$sformatf("no_of reqs=%0d",i),UVM_HIGH)

   `uvm_info("struct_pkt_debug",$sformatf("struct_pkt_wr_addr_phase = \n %0p",data_write_packet),UVM_HIGH)

   // based on the wait_cycles we can choose to drive the awready
    `uvm_info(name,$sformatf("Before DRIVING WRITE ADDRS WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
    repeat(data_write_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING_WRITE_ADDRS_WAIT_STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
      @(posedge aclk);
      awready<=0;
    end
    awready <= 1;
   
  endtask: axi4_write_address_phase 

  //-------------------------------------------------------
  // Task: axi4_write_data_phase
  // This task will sample the write data signals
  //-------------------------------------------------------
  task axi4_write_data_phase (inout axi4_write_transfer_char_s data_write_packet, input axi4_transfer_cfg_s cfg_packet);
    `uvm_info(name,$sformatf("data_write_packet=\n%p",data_write_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("INSIDE WRITE DATA CHANNEL"),UVM_HIGH)
    
    wready <= 0;
    
    do begin
      @(posedge aclk);
    end while(wvalid===0);

    `uvm_info("SLAVE_DRIVER_WRITE_DATA_PHASE", $sformatf("outside of wvalid"), UVM_MEDIUM); 

   // based on the wait_cycles we can choose to drive the wready
    `uvm_info("SLAVE_BFM_WDATA_PHASE",$sformatf("Before DRIVING WRITE DATA WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
    repeat(data_write_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING_WRITE_DATA_WAIT_STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
      @(posedge aclk);
      wready<=0;
    end

    wready <= 1 ;
    
      `uvm_info(name,$sformatf("OUTSIDE WRITE DATA CHANNEL"),UVM_HIGH)
      a++;

      @(posedge aclk);
      wready <= 0;

  endtask : axi4_write_data_phase

  //-------------------------------------------------------
  // Task: axi4_write_response_phase
  // This task will drive the write response signals
  //-------------------------------------------------------
  
  task axi4_write_response_phase(inout axi4_write_transfer_char_s data_write_packet, axi4_transfer_cfg_s struct_cfg);
    
    int j;
    @(posedge aclk);
    `uvm_info(name,"INSIDE WRITE_RESPONSE_PHASE",UVM_LOW)


    //Checks all the conditions satisfied are not to send OKAY RESP
    //1. Resp has to send only wlast is high.
    //2. Size shouldn't more than DBW.
    //3. fifo shouldn't get full.
      
    bvalid <= 1;
    
    while(bready === 0) begin
      @(posedge aclk);
      data_write_packet.wait_count_write_response_channel++;
      `uvm_info(name,$sformatf("inside_detect_bready = %0d",bready),UVM_HIGH)
    end
    `uvm_info(name,$sformatf("After_loop_of_Detecting_bready = %0d",bready),UVM_HIGH)
    bvalid <= 1'b0;
  
  endtask : axi4_write_response_phase

 initial begin
    `uvm_info(name,$sformatf(name),UVM_LOW)
  end

endinterface : Axi4LiteSlaveWriteDriverBFM

`endif

