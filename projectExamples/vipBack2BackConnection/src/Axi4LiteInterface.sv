`ifndef AXI4LITEMASTERINTERFACE_INCLUDED_
`define AXI4LITEMASTERINTERFACE_INCLUDED_

// Import Axi4LiteGlobalsPkg 
import Axi4LiteGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Axi4LiteInterface
// Declaration of pin level signals for axi4 interface
//--------------------------------------------------------------------------------------------
interface Axi4LiteInterface(input aclk, input aresetn);

  
  //Write_address_channel
  logic     [ADDRESS_WIDTH-1: 0] awaddr ;
  logic     [2: 0] awprot    ;
  logic            awvalid   ;
  logic		         awready   ;

    //Write_data_channel
  logic     [DATA_WIDTH-1: 0] wdata     ;
  logic     [(DATA_WIDTH/8)-1: 0] wstrb ;
  logic            wvalid    ;
 	logic            wready    ;

  //Write Response Channel
  logic     [1: 0] bresp     ;
  logic            bvalid    ;
  logic            bready    ;
 
 //Read Address Channel
  logic     [ADDRESS_WIDTH-1:0] araddr  ;
  logic     [2:0] arprot     ;
  logic           arvalid    ;
 	logic	          arready    ;

  //Read Data Channel
  logic     [DATA_WIDTH-1: 0] rdata     ;
  logic     [1:0] rresp      ;
  logic           rvalid     ;
  logic  	        rready     ;

endinterface: Axi4LiteInterface 

`endif
