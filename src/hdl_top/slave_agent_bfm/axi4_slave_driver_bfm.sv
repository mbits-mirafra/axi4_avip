`ifndef AXI4_SLAVE_DRIVER_BFM_INCLUDED_
`define AXI4_SLAVE_DRIVER_BFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : axi4_slave_driver_bfm
//Used as the HDL driver for axi4
//It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import axi4_globals_pkg::*;
interface axi4_slave_driver_bfm(input                     aclk    , 
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
                                input		                    bready ,

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
  // Importing axi4 slave driver proxy
  //-------------------------------------------------------
  import axi4_slave_pkg::axi4_slave_driver_proxy;

  //Variable : axi4_slave_driver_proxy_h
  //Creating the handle for proxy driver
  axi4_slave_driver_proxy axi4_slave_drv_proxy_h;
  
  reg [7: 0] i = 0;
  reg [7: 0] j = 0;
  reg [7: 0] a = 0;

  initial begin
    `uvm_info("axi4 slave driver bfm",$sformatf("AXI4 SLAVE DRIVER BFM"),UVM_LOW);
  end

  string name = "AXI4_SLAVE_DRIVER_BFM";

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
    rvalid  <= 0;
    rlast   <= 0;
    bvalid  <= 0;
    arready <= 0;
    bid     <= 'bx;
    bresp   <= 'b0;
    buser   <= 'b0;
    rid     <= 'bx;
    rdata   <= 'b0;
    rresp   <= 'b0;
    ruser   <= 'b0;
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
    `uvm_info(name,$sformatf("INSIDE WRITE DATA CHANNEL"),UVM_NONE)
    
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
      `uvm_info("SLAVE_DEBUG",$sformatf("mem_length = %0d",mem_wlen[a]),UVM_NONE)
       data_write_packet.wdata[s]=wdata;
       `uvm_info("slave_wdata",$sformatf("sampled_slave_wdata[%0d] = %0h",s,data_write_packet.wdata[s]),UVM_HIGH);
       data_write_packet.wstrb[s]=wstrb;
       `uvm_info("slave_wstrb",$sformatf("sampled_slave_wstrb[%0d] = %0d",s,data_write_packet.wstrb[s]),UVM_HIGH);
       while(wvalid==0) begin
        @(posedge aclk);
       end 
       
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
          `uvm_info("slave_wlast",$sformatf("slave_wlast = %0b ,a=%0d",wlast,a),UVM_NONE);
          `uvm_info("slave_wlast",$sformatf("sampled_slave_wlast = %0b",data_write_packet.wlast),UVM_HIGH);
        end
      end
      `uvm_info(name,$sformatf("OUTSIDE WRITE DATA CHANNEL"),UVM_NONE)
      a++;

      @(posedge aclk);
      wready <= 0;

  endtask : axi4_write_data_phase

  //-------------------------------------------------------
  // Task: axi4_write_response_phase
  // This task will drive the write response signals
  //-------------------------------------------------------
  
  task axi4_write_response_phase(inout axi4_write_transfer_char_s data_write_packet,
    axi4_transfer_cfg_s struct_cfg,bit[3:0] bid_local);
    
    int j;
    @(posedge aclk);

    if((struct_cfg.slave_response_mode == ONLY_WRITE_RESP_OUT_OF_ORDER) || (struct_cfg.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER)) begin 
      bid <= bid_local; 
      data_write_packet.bid <= bid_local; 
      bresp <= data_write_packet.bresp;
      buser <= data_write_packet.buser;
      bvalid <= 1;
    end
    else begin 
     data_write_packet.bid <= mem_awid[j]; 
     `uvm_info("DEBUG_BRESP",$sformatf("BID = %0d",data_write_packet.bid),UVM_HIGH)
     `uvm_info(name,"INSIDE WRITE_RESPONSE_PHASE",UVM_LOW)

     bid  <= mem_awid[j];
     `uvm_info("DEBUG_BRESP",$sformatf("MEM_BID[%0d] = %0d",j,mem_awid[j]),UVM_HIGH)
     `uvm_info("DEBUG_BRESP_WLAST",$sformatf("wlast = %0d,j=%0d",mem_wlast[j],j),UVM_NONE)
     while(mem_wlast[j]!=1) begin
       @(posedge aclk);
     end
     bresp <= data_write_packet.bresp;
     buser<=data_write_packet.buser;
     bvalid <= 1;
     j++;
     `uvm_info("DEBUG_BRESP",$sformatf("BID = %0d",bid),UVM_HIGH)
   end
    
    while(bready === 0) begin
      @(posedge aclk);
      data_write_packet.wait_count_write_response_channel++;
      `uvm_info(name,$sformatf("inside_detect_bready = %0d",bready),UVM_HIGH)
    end
    `uvm_info(name,$sformatf("After_loop_of_Detecting_bready = %0d",bready),UVM_HIGH)
    bvalid <= 1'b0;
  
  endtask : axi4_write_response_phase

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
    arready         <= 1       ;

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
  task axi4_read_data_phase (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet,response_mode_e out_of_order_enable);
    int j1;
    @(posedge aclk);
    if(out_of_order_enable == RESP_IN_ORDER || out_of_order_enable == ONLY_WRITE_RESP_OUT_OF_ORDER) begin
      data_read_packet.rid <= mem_arid[j1];
      
      for(int i1=0, k1=0; i1<mem_rlen[j1] + 1; i1++) begin
        if(k1 == DATA_WIDTH/8) k1 = 0;
        rid  <= mem_arid[j1];
        //Sending the rdata based on each byte lane
        //RHS: Is used to send Byte by Byte
        //LHS: Is used to shift the location for each Byte
        for(int l1=0; l1<(2**mem_rsize[j1]); l1++) begin
          $display("RDATA_INDSDE:%0h",data_read_packet.rdata[i1][8*l1+7 -: 8]);
          rdata[8*k1+7 -: 8]<=data_read_packet.rdata[i1][8*l1+7 -: 8];
          k1++;
        end
        rresp<=data_read_packet.rresp[i1];
       
        ruser<=data_read_packet.ruser;
        rvalid<=1'b1;
        
        if((mem_rlen[j1]) == i1)begin
          rlast <= 1'b1;
        end
        
        do begin
          @(posedge aclk);
        end while(rready===0);
        rlast <= 1'b0;
        rvalid <= 1'b0;
      end
     end
     else begin
      for(int i1=0, k1=0; i1<data_read_packet.arlen + 1; i1++) begin
        if(k1 == DATA_WIDTH/8) k1 = 0;
        rid  <= data_read_packet.arid;
        //Sending the rdata based on each byte lane
        //RHS: Is used to send Byte by Byte
        //LHS: Is used to shift the location for each Byte
        for(int l1=0; l1<(2**data_read_packet.arsize); l1++) begin
          rdata[8*k1+7 -: 8]<=data_read_packet.rdata[i1][8*l1+7 -: 8];
          k1++;
        end
        rresp<=data_read_packet.rresp[i1];
       
        ruser<=data_read_packet.ruser;
        rvalid<=1'b1;
        
        if((data_read_packet.arlen) == i1)begin
          rlast <= 1'b1;
        end
        
        do begin
          @(posedge aclk);
        end while(rready===0);
        rlast <= 1'b0;
        rvalid <= 1'b0;
      end
     end
    j1++;
       
  endtask : axi4_read_data_phase

endinterface : axi4_slave_driver_bfm

`endif
