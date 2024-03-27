`ifndef AXI4LITESLAVEWRITEINTERFACE_INCLUDED_
`define AXI4LITESLAVEWRITEINTERFACE_INCLUDED_

// Import Axi4LiteGlobalsPkg 
import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveWriteInterface(input aclk, input aresetn);

  logic valid;
  logic	ready;

endinterface: Axi4LiteSlaveWriteInterface 

`endif
