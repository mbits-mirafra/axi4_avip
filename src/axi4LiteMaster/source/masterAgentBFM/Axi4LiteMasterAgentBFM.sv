`ifndef AXI4LITEMASTERAGENTBFM_INCLUDED_
`define AXI4LITEMASTERAGENTBFM_INCLUDED_

  
module Axi4LiteMasterAgentBFM #(parameter int ADDR_WIDTH = 32,
                                parameter int DATA_WIDTH = 32
                                )
                                (input   aclk,
                                 input   aresetn,
                                 output  valid,
                                 input   ready
                                 );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  Axi4LiteMasterInterface axi4LiteMasterInterface(.aclk(aclk), 
                                                  .aresetn(aresetn)
                                                 );

  Axi4LiteMasterWriteAgentBFM axi4LiteMasterWriteAgentBFM (.aclk(axi4LiteMasterInterface.aclk), 
                                                         .aresetn(axi4LiteMasterInterface.aresetn),
                                                         .valid(axi4LiteMasterInterface.valid),
                                                         .ready(axi4LiteMasterInterface.ready)
                                                        );

  Axi4LiteMasterReadAgentBFM axi4LiteMasterReadAgentBFM (.aclk(axi4LiteMasterInterface.aclk), 
                                                       .aresetn(axi4LiteMasterInterface.aresetn),
                                                       .valid(axi4LiteMasterInterface.valid),
                                                       .ready(axi4LiteMasterInterface.ready)
                                                      );
  assign valid = axi4LiteMasterInterface.valid;
  assign axi4LiteMasterInterface.ready = ready;   

  initial begin
    `uvm_info("Axi4LiteMasterAgent",$sformatf("AXI4LITEMASTERAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterAgentBFM
`endif
