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
                                input [3: 0]                arid    ,
                                input [ADDRESS_WIDTH-1: 0]  araddr  ,
                                input [7:0]                 arlen   ,
                                input [2:0]                 arsize  ,
                                input [1:0]                 arburst ,
                                input [1:0]                 arlock  ,
                                input [3:0]                 arcache ,
                                input [2:0]                 arprot  ,
                                input [3:0]                 arqos   ,
                                input [3:0]                 arregion,
                                input [3:0]                 aruser  ,
                                input                       arvalid ,
                                output reg                  arready ,

                                //Read Data Channel
                                output reg [3:0]                rid    ,
                                output reg [DATA_WIDTH-1: 0]    rdata  ,
                                output reg [1:0]                rresp  ,
                                output reg                      rlast  ,
                                output reg [3:0]                ruser  ,
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

  reg [	3 : 0] 	            mem_awid	  [2**LENGTH];
  reg [	ADDRESS_WIDTH-1: 0]	mem_waddr	  [2**LENGTH];
  reg [	7 : 0]	            mem_wlen	  [2**LENGTH];
  reg [	2 : 0]	            mem_wsize	  [2**LENGTH];
  reg [ 1	: 0]	            mem_wburst  [2**LENGTH];
  bit                       mem_wlast   [2**LENGTH];
  
  reg [	3 : 0]	            mem_arid	  [2**LENGTH];
  reg [	ADDRESS_WIDTH-1: 0]	mem_raddr	  [2**LENGTH];
  reg [	7	: 0]	            mem_rlen	  [2**LENGTH];
  reg [	2	: 0]	            mem_rsize	  [2**LENGTH];
  reg [ 1	: 0]	            mem_rburst  [2**LENGTH];
  
  //-------------------------------------------------------
  // Task: wait_for_system_reset
  // Waiting for the system reset to be active low
  //-------------------------------------------------------

  task wait_for_system_reset();
    @(negedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET ACTIVATED"),UVM_NONE)
    rvalid  <= 0;
    rlast   <= 0;
    arready <= 0;
    rid     <= 'bx;
    rdata   <= 'b0;
    rresp   <= 'b0;
    ruser   <= 'b0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DE-ACTIVATED"),UVM_NONE)
  endtask 
 
  initial begin
    `uvm_info(name,$sformatf(name),UVM_LOW)
  end

  /*
  //--------------------------------------------------------------------------------------------
  // Tasks written for all 5 channels in BFM are given below
  //--------------------------------------------------------------------------------------------

  //-------------------------------------------------------
  // Task: axi4_write_address_channel_task
  // This task will drive the write address signals
  //-------------------------------------------------------
task axi4_write_address_channel_task (inout axi4_write_transfer_char_s data_write_packet, axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);

    `uvm_info(name,$sformatf("data_write_packet=\n%p",data_write_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVING_WRITE_ADDRESS_CHANNEL"),UVM_HIGH)
    
    awid     <= data_write_packet.awid;
    awaddr   <= data_write_packet.awaddr;
    awlen    <= data_write_packet.awlen;
    awsize   <= data_write_packet.awsize;
    awburst  <= data_write_packet.awburst;
    awlock   <= data_write_packet.awlock;
    awcache  <= data_write_packet.awcache;
    awprot   <= data_write_packet.awprot;
    awqos    <= data_write_packet.awqos;
    awregion <= data_write_packet.awregion;
    awuser   <= data_write_packet.awuser;
    awvalid  <= 1'b1;
    
    `uvm_info(name,$sformatf("detect_awready = %0d",awready),UVM_HIGH)
    
    do begin
      @(posedge aclk);
      data_write_packet.wait_count_write_address_channel++;
    end
    while(awready !== 1);

    `uvm_info(name,$sformatf("After_loop_of_Detecting_awready = %0d, awvalid = %0d",awready,awvalid),UVM_HIGH)
    awvalid <= 1'b0;

  endtask : axi4_write_address_channel_task

  //-------------------------------------------------------
  // Task: axi4_write_data_channel_task
  // This task will drive the write data signals
  //-------------------------------------------------------
  task axi4_write_data_channel_task (inout axi4_write_transfer_char_s data_write_packet, input axi4_transfer_cfg_s cfg_packet);
    
    `uvm_info(name,$sformatf("data_write_packet=\n%p",data_write_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVE TO WRITE DATA CHANNEL"),UVM_HIGH)

    @(posedge aclk);

    for(int i=0; i<data_write_packet.awlen + 1; i++) begin
      wdata  <= data_write_packet.wdata[i];
      wstrb  <= data_write_packet.wstrb[i];
      wuser  <= data_write_packet.wuser;
      wlast  <= 1'b0;
      wvalid <= 1'b1;
      `uvm_info(name,$sformatf("DETECT_WRITE_DATA_WAIT_STATE"),UVM_HIGH)
        
      if(data_write_packet.awlen == i)begin  
        wlast  <= 1'b1;
      end

      do begin
        @(posedge aclk);
      end while(wready===0);
      `uvm_info(name,$sformatf("DEBUG_NA:WDATA[%0d]=%0h",i,data_write_packet.wdata[i]),UVM_HIGH)
    end

    wlast <= 1'b0;
    wvalid<= 1'b0;
    `uvm_info(name,$sformatf("WRITE_DATA_COMP data_write_packet=\n%p",data_write_packet),UVM_HIGH)
  endtask : axi4_write_data_channel_task

  //-------------------------------------------------------
  // Task: axi4_write_response_channel_task
  // This task will drive the write response signals
  //-------------------------------------------------------
  task axi4_write_response_channel_task (inout axi4_write_transfer_char_s data_write_packet, input axi4_transfer_cfg_s cfg_packet);

    `uvm_info(name,$sformatf("WRITE_RESP data_write_packet=\n%p",data_write_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVE TO WRITE RESPONSE CHANNEL"),UVM_HIGH)
    
    do begin
      @(posedge aclk);
    end while(bvalid !== 1'b1); 

    repeat(data_write_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING WAIT STATES in write response:: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
      @(posedge aclk);
      bready <= 0;
    end

    data_write_packet.bvalid = bvalid;
    data_write_packet.bid    = bid;
    data_write_packet.bresp  = bresp;
    data_write_packet.buser  = buser;
    bready <= 1'b1;

    `uvm_info(name,$sformatf("CHECKING WRITE RESPONSE :: %p",data_write_packet),UVM_HIGH);
    @(posedge aclk);
    bready <= 1'b0;

  endtask : axi4_write_response_channel_task
*/
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
    mem_arid 	[j]	  = arid  	;	
	  mem_raddr	[j] 	= araddr	;
	  mem_rlen 	[j]	  = arlen	  ;	
	  mem_rsize	[j] 	= arsize	;	
	  mem_rburst[j] 	= arburst ;	
    arready         = 1       ;

    data_read_packet.arid    = mem_arid[j]     ;
    data_read_packet.araddr  = mem_raddr[j]    ;
    data_read_packet.arlen   = mem_rlen[j]     ;
    data_read_packet.arsize  = mem_rsize[j]    ;
    data_read_packet.arburst = mem_rburst[j]   ;
	  j = j+1                                    ;

    `uvm_info("mem_arid",$sformatf("mem_arid[%0d]=%0d",j,mem_arid[j]),UVM_HIGH)
    `uvm_info("mem_arid",$sformatf("arid=%0d",arid),UVM_HIGH)
    `uvm_info(name,$sformatf("struct_pkt_rd_addr_phase = \n %0p",data_read_packet),UVM_HIGH)
    
    @(posedge aclk);
    arready <= 0;
  
  endtask: axi4_read_address_phase
    
  //-------------------------------------------------------
  // Task: axi4_read_data_channel_task
  // This task will drive the read data signals
  //-------------------------------------------------------
  task axi4_read_data_phase (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    int j1;
    @(posedge aclk);
    data_read_packet.rid <= mem_arid[j1];
    `uvm_info("RDATA_DEBUG",$sformatf("data_packet_rid= %0d",data_read_packet.rid),UVM_HIGH);
    `uvm_info("RDATA_DEBUG",$sformatf("data_packet_rid= %0d",mem_arid[j1]),UVM_HIGH);
    `uvm_info(name,$sformatf("INSIDE READ DATA CHANNEL"),UVM_LOW);
    
    for(int i1=0, k1=0; i1<mem_rlen[j1] + 1; i1++) begin
      `uvm_info("RDATA_DEBUG",$sformatf("rid= %0d",rid),UVM_HIGH);
      `uvm_info("RDATA_DEBUG",$sformatf("arlen= %0d",mem_rlen[j1]),UVM_HIGH);
      `uvm_info("RDATA_DEBUG",$sformatf("i1_arlen= %0d",i1),UVM_HIGH);

      if(mem_rsize[j1] == DATA_WIDTH/OUTSTANDING_FIFO_DEPTH) begin
        k1 = 0;
      end
       if(mem_rsize[j1] == 0 || mem_rsize[j1] == DATA_WIDTH/DATA_WIDTH) begin
        if(k1 == DATA_WIDTH/LENGTH) begin
          k1 = 0;
        end
      end
      
      rid  <= mem_arid[j1];
      for(int l1=0; l1<(2**mem_rsize[j1]); l1++) begin
        `uvm_info("RSIZE_DEBUG",$sformatf("mem_rsize= %0d",mem_rsize[j1]),UVM_HIGH);
        `uvm_info("RSIZE_DEBUG",$sformatf("mem_rsize_l1= %0d",l1),UVM_HIGH);
        
        //Sending the rdata based on each byte lane
        //RHS: Is used to send Byte by Byte
        //LHS: Is used to shift the location for each Byte
        rdata[8*k1+7 -: 8]<=data_read_packet.rdata[l1*8+i1];
        `uvm_info("RDATA_DEBUG",$sformatf("RDATA[%0d]=%0h",i1,data_read_packet.rdata[l1*8+i1]),UVM_HIGH)
        `uvm_info("RDATA_DEBUG",$sformatf("RDATA=%0h",rdata[8*k1+7 -: 8]),UVM_HIGH)
        k1++;
      end
     
     if(mem_rsize[j1]<=DATA_WIDTH/OUTSTANDING_FIFO_DEPTH) begin
       rresp<=data_read_packet.rresp;
     end
     else begin
       rresp <= READ_SLVERR;
       data_read_packet.rresp <= READ_SLVERR;
     end

      ruser<=data_read_packet.ruser;
      rvalid<=1'b1;
      
      if((mem_rlen[j1]) == i1)begin
        rlast  <= 1'b1;
        @(posedge aclk);
        rlast <= 1'b0;
        rvalid <= 1'b0;
      end
      
      do begin
        @(posedge aclk);
      end while(rready===0);
    end
    j1++;
    
       
  endtask : axi4_read_data_phase

endinterface : Axi4LiteSlaveReadDriverBFM

`endif

