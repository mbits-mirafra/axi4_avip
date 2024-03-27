`ifndef AXI4LITESLAVEREADINTERFACE_INCLUDED_
`define AXI4LITESLAVEREADINTERFACE_INCLUDED_

// Import Axi4LiteGlobalsPkg 
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveReadInterface(input aclk, input aresetn);

  logic valid;
 	logic	ready;

endinterface: Axi4LiteSlaveReadInterface 

`endif
