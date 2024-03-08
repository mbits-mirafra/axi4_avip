`ifndef AXI4LITESLAVEREADINTERFACE_INCLUDED_
`define AXI4LITESLAVEREADINTERFACE_INCLUDED_

// Import Axi4LiteGlobalsPkg 
import Axi4LiteGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Axi4LiteSlaveReadInterface
// Declaration of pin level signals for axi4 interface
//--------------------------------------------------------------------------------------------
interface Axi4LiteSlaveReadInterface(input aclk, input aresetn);

  
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

endinterface: Axi4LiteSlaveReadInterface 

`endif
