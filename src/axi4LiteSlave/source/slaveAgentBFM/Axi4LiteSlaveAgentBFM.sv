`ifndef AXI4LITESLAVEAGENTBFM_INCLUDED_
`define AXI4LITESLAVEAGENTBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module:Axi4LiteSlaveAgentBFM 
// This module is used as the configuration class for master agent bfm and its components
//--------------------------------------------------------------------------------------------
module Axi4LiteSlaveAgentBFM #(parameter int SLAVE_ID = 0)(Axi4LiteSlaveInterface axi4LiteSlaveInterface);
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  

  //Printing Axi4LiteMasterAgent
  initial begin
    `uvm_info("Axi4LiteMasterAgent",$sformatf("AXI4LITESLAVEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveAgentBFM
`endif
