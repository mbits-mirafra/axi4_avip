`ifndef AXI4LITEMASTERAGENTBFM_INCLUDED_
`define AXI4LITEMASTERAGENTBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module:Axi4LiteMasterAgentBFM 
// This module is used as the configuration class for master agent bfm and its components
//--------------------------------------------------------------------------------------------
module Axi4LiteMasterAgentBFM #(parameter int MASTER_ID = 0)(Axi4LiteMasterInterface axi4LiteMasterInterface);
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  

  //Printing Axi4LiteMasterAgent
  initial begin
    `uvm_info("Axi4LiteMasterAgent",$sformatf("AXI4LITEMASTERAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterAgentBFM
`endif
