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
                                input [3:0]               awid    ,
                                input [ADDRESS_WIDTH-1:0] awaddr  ,
                                input [3: 0]              awlen   ,
                                input [2: 0]              awsize  ,
                                input [1: 0]              awburst ,
                                input [1: 0]              awlock  ,
                                input [3: 0]              awcache ,
                                input [2: 0]              awprot  ,
                                input [3: 0]              awqos   ,  
                                input                     awvalid ,
                                output reg	              awready ,

                                //Write_data_channel
                                input [DATA_WIDTH-1: 0]     wdata  ,
                                input [(DATA_WIDTH/8)-1: 0] wstrb  ,
                                input                       wlast  ,
                                input [3: 0]                wuser  ,
                                input                       wvalid ,
                                output reg	                wready ,

                                //Write Response Channel
                                output reg [3:0]            bid    ,
                                output reg [1:0]            bresp  ,
                                output reg [3:0]            buser  ,
                                output reg                  bvalid ,
                                input		                    bready); 
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
    awready <= 0;
    wready  <= 0;
    bvalid  <= 0;
    bid     <= 'bx;
    bresp   <= 'b0;
    buser   <= 'b0;
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
    
    if(axi4_slave_drv_proxy_h.axi4_slave_write_addr_fifo_h.is_full()) begin
      `uvm_error("UVM_TLM_FIFO","FIFO is now FULL!")
    end 
      
   // Sample the values
   mem_awid 	[i]	  = awid  	;	
	 mem_waddr	[i] 	= awaddr	;
	 mem_wlen 	[i]	  = awlen	  ;	
	 mem_wsize	[i] 	= awsize	;	
	 mem_wburst [i]   = awburst ;	
   
   data_write_packet.awid    = mem_awid   [i] ;
   data_write_packet.awaddr  = mem_waddr  [i] ;
   data_write_packet.awlen   = mem_wlen   [i] ;
   data_write_packet.awsize  = mem_wsize  [i] ;
   data_write_packet.awburst = mem_wburst [i] ;
   
   i = i+1                   ;
    
   `uvm_info("mem_awid",$sformatf("mem_awid[%0d]=%0d",i,mem_awid[i]),UVM_HIGH)
   `uvm_info("mem_awid",$sformatf("awid=%0d",awid),UVM_HIGH)
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
    
    for(int s = 0;s<(mem_wlen[a]+1);s = s+1)begin
      @(posedge aclk);
      `uvm_info("SLAVE_DEBUG",$sformatf("mem_length = %0d",mem_wlen[a]),UVM_HIGH)
       data_write_packet.wdata[s]=wdata;
       `uvm_info("slave_wdata",$sformatf("sampled_slave_wdata[%0d] = %0h",s,data_write_packet.wdata[s]),UVM_HIGH);
       data_write_packet.wstrb[s]=wstrb;
       `uvm_info("slave_wstrb",$sformatf("sampled_slave_wstrb[%0d] = %0d",s,data_write_packet.wstrb[s]),UVM_HIGH);
       
       // Used to sample the wlast at the end of transfer
       // and come out of the loop if wlast == 1
        if(s == mem_wlen[a]) begin
          mem_wlast[a] = wlast;
          `uvm_info("slave_wlast",$sformatf("slave1_wlast = %0b",wlast),UVM_HIGH);
          data_write_packet.wlast = wlast;
          if(!data_write_packet.wlast)begin
            @(posedge aclk);
            wready<=0;
            break;
          end
          `uvm_info("slave_wlast",$sformatf("slave_wlast = %0b",wlast),UVM_HIGH);
          `uvm_info("slave_wlast",$sformatf("sampled_slave_wlast = %0b",data_write_packet.wlast),UVM_HIGH);
        end
      end
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
    data_write_packet.bid <= mem_awid[j]; 
    `uvm_info("DEBUG_BRESP",$sformatf("BID = %0d",data_write_packet.bid),UVM_HIGH)
    `uvm_info(name,"INSIDE WRITE_RESPONSE_PHASE",UVM_LOW)

    bid  <= mem_awid[j];
    `uvm_info("DEBUG_BRESP",$sformatf("MEM_BID[%0d] = %0d",j,mem_awid[j]),UVM_HIGH)
    `uvm_info("DEBUG_BRESP_WLAST",$sformatf("wlast = %0d",mem_wlast[j]),UVM_HIGH)

    //Checks all the conditions satisfied are not to send OKAY RESP
    //1. Resp has to send only wlast is high.
    //2. Size shouldn't more than DBW.
    //3. fifo shouldn't get full.
    if(mem_wlast[j]==1 && mem_wsize[j] <= DATA_WIDTH/OUTSTANDING_FIFO_DEPTH && !axi4_slave_drv_proxy_h.axi4_slave_write_addr_fifo_h.is_full()) begin
      bresp <= WRITE_OKAY;
      data_write_packet.bresp <= WRITE_OKAY;
    end
    else begin
      bresp <= WRITE_SLVERR;
      data_write_packet.bresp <= WRITE_SLVERR;
    end
      
    buser<=data_write_packet.buser;
    bvalid <= 1;
    j++;
    `uvm_info("DEBUG_BRESP",$sformatf("BID = %0d",bid),UVM_HIGH)
    
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

 /*
  //-------------------------------------------------------
  // Task: axi4_read_address_channel_task
  // This task will drive the read address signals
  //-------------------------------------------------------
  task axi4_read_address_channel_task (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);
    
    `uvm_info(name,$sformatf("data_read_packet=\n%p",data_read_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVE TO READ ADDRESS CHANNEL"),UVM_HIGH)

    arid     <= data_read_packet.arid;
    araddr   <= data_read_packet.araddr;
    arlen    <= data_read_packet.arlen;
    arsize   <= data_read_packet.arsize;
    arburst  <= data_read_packet.arburst;
    arlock   <= data_read_packet.arlock;
    arcache  <= data_read_packet.arcache;
    arprot   <= data_read_packet.arprot;
    arqos    <= data_read_packet.arqos;
    aruser   <= data_read_packet.aruser;
    arregion <= data_read_packet.arregion;
    arvalid  <= 1'b1;

    `uvm_info(name,$sformatf("detect_awready = %0d",arready),UVM_HIGH)
    do begin
      @(posedge aclk);
      data_read_packet.wait_count_read_address_channel++;
    end
    while(arready !== 1);

    `uvm_info(name,$sformatf("After_loop_of_Detecting_awready = %0d, awvalid = %0d",awready,awvalid),UVM_HIGH)
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

      data_read_packet.rid      = rid;
      data_read_packet.rdata[i] = rdata;
      data_read_packet.ruser    = ruser;
      data_read_packet.rresp    = rresp;
      `uvm_info(name,$sformatf("DEBUG_NA:RDATA[%0d]=%0h",i,data_read_packet.rdata[i]),UVM_HIGH)
      
      i++;  

      if(rlast === 1'b1)begin
        i=0;
        break;
      end
    end
   
    @(posedge aclk);
    rready <= 1'b0;

  endtask : axi4_read_data_channel_task
*/
endinterface : Axi4LiteSlaveWriteDriverBFM

`endif

