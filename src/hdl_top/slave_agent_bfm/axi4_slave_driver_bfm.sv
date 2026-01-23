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


  clocking axiSlaveCb @(posedge aclk);
    default input #1step output #1step;

    input awid,awaddr, awlen,awsize,awburst, awlock, awcache, awprot,awqos, awvalid, wdata, wstrb, wlast, wuser, wvalid, bready, arid, araddr, arlen, arsize, arburst,arlock, arcache, arprot, arqos, arregion, aruser, arvalid, rready;
 output awready, wready, bid, bresp, buser, bvalid, arready, rid, rdata, rresp, rlast, ruser, rvalid;
  endclocking 


  initial begin
    `uvm_info("axi4 slave driver bfm",$sformatf("AXI4 SLAVE DRIVER BFM"),UVM_LOW);
  end

  string name = "AXI4_SLAVE_DRIVER_BFM";

  // Creating Memories for each signal to store each transaction attributes

  reg [	3 : 0] mem_awid [2**LENGTH];
  reg [	ADDRESS_WIDTH-1: 0] mem_waddr [2**LENGTH];
  reg [	7 : 0] mem_wlen	  [2**LENGTH];
  reg [	2 : 0]	            mem_wsize	  [2**LENGTH];
  reg [ 1	: 0]	            mem_wburst  [2**LENGTH];
  reg [ 3	: 0]	            mem_wqos    [2**LENGTH];
  bit                       mem_wlast   [2**LENGTH];
  
  reg [	3 : 0]	            mem_arid	  [2**LENGTH];
  reg [	ADDRESS_WIDTH-1: 0]	mem_raddr	  [2**LENGTH];
  reg [	7	: 0]	            mem_rlen	  [2**LENGTH];
  reg [	2	: 0]	            mem_rsize	  [2**LENGTH];
  reg [ 1	: 0]	            mem_rburst  [2**LENGTH];
  reg [ 3	: 0]	            mem_rqos    [2**LENGTH];
  
  //-------------------------------------------------------
  // Task: wait_for_system_reset
  // Waiting for the system reset to be active low
  //-------------------------------------------------------

  task wait_for_system_reset();
    @(negedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET ACTIVATED"),UVM_NONE)

    default_values();

    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DE-ACTIVATED"),UVM_NONE)
  endtask 
  
  //-------------------------------------------------------
  // Task: axi_write_address_phase
  // Sampling the signals that are associated with write_address_channel
  //-------------------------------------------------------

  task axi4_write_address_phase(inout axi4_write_transfer_char_s data_write_packet);
    @(axiSlaveCb);
    `uvm_info(name,"INSIDE WRITE_ADDRESS_PHASE",UVM_LOW)

    // Ready can be HIGH even before we start to check 
    // based on wait_cycles variable
    // Can make awready to zero 
    axiSlaveCb.awready <= 0;

    do begin
      @(axiSlaveCb);
    end while(axiSlaveCb.awvalid === 0);

    `uvm_info("SLAVE_DRIVER_WADDR_PHASE", $sformatf("outside of awvalid"), UVM_MEDIUM);
    
    if(axi4_slave_drv_proxy_h.axi4_slave_write_addr_fifo_h.is_full()) begin
      `uvm_error("UVM_TLM_FIFO","FIFO is now FULL!")
    end 
      
   // Sample the values
            data_write_packet.awid= axiSlaveCb.awid;	
	 data_write_packet.awaddr 	= axiSlaveCb.awaddr;
	   data_write_packet.awlen  = axiSlaveCb.awlen;	
	  data_write_packet.awsize	= axiSlaveCb.awsize;	
	 data_write_packet.awburst = axiSlaveCb.awburst;	
data_write_packet.awqos = axiSlaveCb.awqos;
   `uvm_info("struct_pkt_debug",$sformatf("struct_pkt_wr_addr_phase = \n %0p",data_write_packet),UVM_FULL)

   //i = i+1;

   // based on the wait_cycles we can choose to drive the awready
    `uvm_info(name,$sformatf("Before DRIVING WRITE ADDRS WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
    repeat(data_write_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING_WRITE_ADDRS_WAIT_STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
      @(axiSlaveCb);
      axiSlaveCb.awready<=0;
    end
    axiSlaveCb.awready <= 1;
   
  endtask: axi4_write_address_phase 

  //-------------------------------------------------------
  // Task: axi4_write_data_phase
  // This task will sample the write data signals
  //-------------------------------------------------------
  task axi4_write_data_phase (inout axi4_write_transfer_char_s data_write_packet, input axi4_transfer_cfg_s cfg_packet);
    
   static reg [7:0]i =0;
    @(axiSlaveCb);
    `uvm_info(name,$sformatf("data_write_packet=\n%p",data_write_packet),UVM_FULL)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_FULL)
    `uvm_info(name,$sformatf("INSIDE WRITE DATA CHANNEL"),UVM_NONE)
    
    axiSlaveCb.wready <= 0;

   do begin
     @(axiSlaveCb);
   end while(axiSlaveCb.wvalid === 1'b0);

   // based on the wait_cycles we can choose to drive the wready
    `uvm_info("SLAVE_BFM_WDATA_PHASE",$sformatf("Before DRIVING WRITE DATA WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
    repeat(data_write_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING_WRITE_DATA_WAIT_STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
      @(axiSlaveCb);
      axiSlaveCb.wready<=0;
    end

    axiSlaveCb.wready <= 1 ;
    
    forever begin
      do begin
        @(axiSlaveCb);
      end while(axiSlaveCb.wvalid === 1'b0);

      data_write_packet.wdata[i] = axiSlaveCb.wdata;
      data_write_packet.wstrb[i] = axiSlaveCb.wstrb;
      if(axiSlaveCb.wlast === 1'b1)begin
        i=0;
        break;
      end
      i++;
     end
         
    `uvm_info("slave_wlast",$sformatf("slave_wlast = %0b ,a=%0d",axiSlaveCb.wlast,a),UVM_HIGH);
    `uvm_info("slave_wlast",$sformatf("sampled_slave_wlast = %0b",data_write_packet.wlast),UVM_HIGH);

    @(axiSlaveCb);
    axiSlaveCb.wready <= 0;
  endtask : axi4_write_data_phase

  //-------------------------------------------------------
  // Task: axi4_write_response_phase
  // This task will drive the write response signals
  //-------------------------------------------------------
  
  task axi4_write_response_phase(inout axi4_write_transfer_char_s data_write_packet,
    axi4_transfer_cfg_s struct_cfg,bit[3:0] bid_local);
    
    int j;
    @(axiSlaveCb);

    
    if((struct_cfg.qos_mode_type == ONLY_WRITE_QOS_MODE_ENABLE) || (struct_cfg.qos_mode_type == WRITE_READ_QOS_MODE_ENABLE)) begin
      axiSlaveCb.bid <= data_write_packet.bid; 
      axiSlaveCb.bresp <= data_write_packet.bresp;
      axiSlaveCb.buser <= data_write_packet.buser;
      axiSlaveCb.bvalid <= 1;
    end
    else begin 
      axiSlaveCb.bid <= bid_local;
      data_write_packet.bid <= bid_local;
      axiSlaveCb.bresp <= data_write_packet.bresp;
      axiSlaveCb.buser <= data_write_packet.buser;
      axiSlaveCb.bvalid <= 1;
    end 
    
    @(axiSlaveCb);
    while(axiSlaveCb.bready === 0) begin
      @(axiSlaveCb);
      data_write_packet.wait_count_write_response_channel++;
      `uvm_info(name,$sformatf("inside_detect_bready = %0d",axiSlaveCb.bready),UVM_HIGH)
    end
    `uvm_info(name,$sformatf("After_loop_of_Detecting_bready = %0d",axiSlaveCb.bready),UVM_HIGH)
    axiSlaveCb.bvalid <= 1'b0;
  
  endtask : axi4_write_response_phase

  //-------------------------------------------------------
  // Task: axi4_read_address_phase
  // This task will sample the read address signals
  //-------------------------------------------------------
  task axi4_read_address_phase (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    @(axiSlaveCb);
    `uvm_info(name,$sformatf("data_read_packet=\n%p",data_read_packet),UVM_FULL);
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_FULL);
    `uvm_info(name,$sformatf("INSIDE READ ADDRESS CHANNEL"),UVM_HIGH);
    
    // Ready can be HIGH even before we start to check 
    // based on wait_cycles variable
    // Can make arready to zero 
     axiSlaveCb.arready <= 0;

    while(axiSlaveCb.arvalid === 0) begin
      @(axiSlaveCb);
    end
   
    repeat(data_read_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING_READ_ADDRS_WAIT_STATES :: %0d",data_read_packet.no_of_wait_states),UVM_HIGH);
      @(axiSlaveCb);
      axiSlaveCb.arready<=0;
    end

    `uvm_info("SLAVE_DRIVER_RADDR_PHASE", $sformatf("outside of arvalid"), UVM_NONE); 
    
    // Sample the values
    arready         <= 1      ;

    data_read_packet.arid    = axiSlaveCb.arid     ;
    data_read_packet.araddr  = axiSlaveCb.araddr   ;
    data_read_packet.arlen   = axiSlaveCb.arlen    ;
    data_read_packet.arsize  = axiSlaveCb.arsize   ;
    data_read_packet.arburst = axiSlaveCb.arburst  ;
    data_read_packet.arqos   = axiSlaveCb.arqos    ;

    `uvm_info("mem_arid",$sformatf("mem_arid[%0d]=%0d",j,mem_arid[j]),UVM_HIGH)
    `uvm_info("mem_arid",$sformatf("arid=%0d",axiSlaveCb.arid),UVM_HIGH)
    `uvm_info(name,$sformatf("struct_pkt_rd_addr_phase = \n %0p",data_read_packet),UVM_FULL)
    
    @(axiSlaveCb);
    axiSlaveCb.arready <= 0;
  
  endtask: axi4_read_address_phase
    
  //-------------------------------------------------------
  // Task: axi4_read_data_channel_task
  // This task will drive the read data signals
  //-------------------------------------------------------
  task axi4_read_data_phase (inout axi4_read_transfer_char_s data_read_packet);
    int j1;
    int amount;
      axiSlaveCb.rdata<=data_read_packet.rdata[0];
      axiSlaveCb.rresp<=data_read_packet.rresp[0];

      axiSlaveCb.ruser<=data_read_packet.ruser;
      axiSlaveCb.rvalid<=1'b1;

      axiSlaveCb.rlast <= data_read_packet.rlast;
      axiSlaveCb.rid <= data_read_packet.rid;
      do begin
         @(axiSlaveCb);
      end while(axiSlaveCb.rready===0);
      axiSlaveCb.rlast <= 1'b0;
      axiSlaveCb.rvalid <= 1'b0;
       
  endtask : axi4_read_data_phase

  task default_values();
    axiSlaveCb.awready <= 0;
    axiSlaveCb.wready  <= 0;
    axiSlaveCb.rvalid  <= 0;
    axiSlaveCb.bvalid  <= 0;
    axiSlaveCb.arready <= 0;

    axiSlaveCb.bid     <= 'b0;
    axiSlaveCb.bresp   <= 'b0;
    axiSlaveCb.buser   <= 'b0;

    axiSlaveCb.rid     <= 'b0;
    axiSlaveCb.rdata   <= 'b0;
    axiSlaveCb.rresp   <= 'b0;
    axiSlaveCb.ruser   <= 'b0;
    axiSlaveCb.rlast   <= 'b0;
  endtask : default_values

endinterface : axi4_slave_driver_bfm

`endif

