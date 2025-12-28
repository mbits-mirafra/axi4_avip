`ifndef AXI4_IF_INCLUDED_
`define AXI4_IF_INCLUDED_

// Import axi4_globals_pkg 
import axi4_globals_pkg::*;

//--------------------------------------------------------------------------------------------
// Interface : axi4_if
// Declaration of pin level signals for axi4 interface
//--------------------------------------------------------------------------------------------
interface axi4_if(input aclk, input aresetn);

  //Write_address_channel
  logic     [3: 0] awid     ;
  logic     [ADDRESS_WIDTH-1: 0] awaddr ;
  logic     [3: 0] awlen     ;
  logic     [2: 0] awsize    ;
  logic     [1: 0] awburst   ;
  logic     [1: 0] awlock    ;
  logic     [3: 0] awcache   ;
  logic     [2: 0] awprot    ;
  logic     [3:0] awqos      ;
  logic     [3:0] awregion   ;
  logic           awuser     ;
  logic            awvalid   ;
  logic		         awready   ;
  //Write_data_channel
  logic     [DATA_WIDTH-1: 0] wdata     ;
  logic     [(DATA_WIDTH/8)-1: 0] wstrb ;
  logic            wlast     ;
  logic      [3:0] wuser     ;
  logic            wvalid    ;
 	logic            wready    ;
  //Write Response Channel
  logic     [3: 0] bid       ;
  logic     [1: 0] bresp     ;
  logic     [3: 0] buser     ;
  logic            bvalid    ;
  logic            bready    ;
  //Read Address Channel
  logic     [3: 0] arid     ;
  logic     [ADDRESS_WIDTH-1:0] araddr  ;
  logic     [7:0] arlen      ;
  logic     [2:0] arsize     ;
  logic     [1:0] arburst    ;
  logic     [1:0] arlock     ;
  logic     [3:0] arcache    ;
  logic     [2:0] arprot     ;
  logic     [3:0] arqos      ;
  logic     [3:0] arregion   ;
  logic     [3:0] aruser     ;
  logic           arvalid    ;
 	logic	          arready    ;
  //Read Data Channel
  logic     [3: 0] rid      ;
  logic     [DATA_WIDTH-1: 0] rdata     ;
  logic     [1:0] rresp      ;
  logic           rlast      ;
  logic     [3:0] ruser      ;
  logic           rvalid     ;
  logic  	        rready     ;
  

endinterface: axi4_if 

`endif
