`ifndef AXI4LITEMASTERWRITEINTERFACE_INCLUDED_
`define AXI4LITEMASTERWRITEINTERFACE_INCLUDED_

// Import Axi4LiteGlobalsPkg 
import Axi4LiteGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Axi4LiteMasterWriteInterface
// Declaration of pin level signals for axi4 interface
//--------------------------------------------------------------------------------------------
interface Axi4LiteMasterWriteInterface(input aclk, input aresetn);

  logic  valid;
  logic	 ready;

endinterface: Axi4LiteMasterWriteInterface 

`endif
