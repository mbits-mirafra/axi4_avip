`ifndef AXI4LITESLAVEAGENTBFM_INCLUDED_
`define AXI4LITESLAVEAGENTBFM_INCLUDED_

module Axi4LiteSlaveAgentBFM #(parameter int ADDR_WIDTH = 32,
                               parameter int DATA_WIDTH = 32
                                )
                                (input  aclk,
                                 input  aresetn,
                                 input  valid,
                                 output ready
                                 );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  Axi4LiteSlaveInterface axi4LiteSlaveInterface(.aclk(aclk), 
                                                .aresetn(aresetn)
                                               );

  Axi4LiteSlaveWriteAgentBFM axi4LiteSlaveWriteAgentBFM (.aclk(axi4LiteSlaveInterface.aclk), 
                                                         .aresetn(axi4LiteSlaveInterface.aresetn),
                                                         .valid(axi4LiteSlaveInterface.valid),
                                                         .ready(axi4LiteSlaveInterface.ready)
                                                        );

  Axi4LiteSlaveReadAgentBFM axi4LiteSlaveReadAgentBFM (.aclk(axi4LiteSlaveInterface.aclk), 
                                                       .aresetn(axi4LiteSlaveInterface.aresetn),
                                                       .valid(axi4LiteSlaveInterface.valid),
                                                       .ready(axi4LiteSlaveInterface.ready)
                                                      );
                                 
  assign axi4LiteSlaveInterface.valid = valid;
  assign ready = axi4LiteSlaveInterface.ready;  

  initial begin
    `uvm_info("Axi4LiteMasterAgent",$sformatf("AXI4LITESLAVEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveAgentBFM
`endif
