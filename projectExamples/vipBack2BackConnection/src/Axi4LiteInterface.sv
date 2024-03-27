`ifndef AXI4LITEMASTERINTERFACE_INCLUDED_
`define AXI4LITEMASTERINTERFACE_INCLUDED_

// Import Axi4LiteGlobalsPkg 
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteInterface(input aclk, input aresetn);

  logic valid;
  logic	ready;

endinterface: Axi4LiteInterface 

`endif
