`ifndef AXI4LITEMASTERWRITEINTERFACE_INCLUDED_
`define AXI4LITEMASTERWRITEINTERFACE_INCLUDED_

// Import Axi4LiteGlobalsPkg 
import Axi4LiteGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Axi4LiteMasterWriteInterface
// Declaration of pin level signals for axi4 interface
//--------------------------------------------------------------------------------------------
interface Axi4LiteMasterWriteInterface(input aclk, input aresetn);

  
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

endinterface: Axi4LiteMasterWriteInterface 

`endif
