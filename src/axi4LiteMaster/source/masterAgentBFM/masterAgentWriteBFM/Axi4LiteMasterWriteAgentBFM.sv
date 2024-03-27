`ifndef AXI4LITEMASTERWRITEAGENTBFM_INCLUDED_
`define AXI4LITEMASTERWRITEAGENTBFM_INCLUDED_

module Axi4LiteMasterWriteAgentBFM #(parameter int ADDR_WIDTH = 32,
                                     parameter int DATA_WIDTH = 32
                                    )
                                    (input  aclk,
                                     input  aresetn,
                                     output valid,
                                     input  ready
                                     );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  Axi4LiteMasterWriteInterface axi4LiteMasterWriteInterface(.aclk(aclk), 
                                                            .aresetn(aresetn)
                                                           );

  Axi4LiteMasterWriteDriverBFM axi4LiteMasterWriteDriverBFM (.aclk(axi4LiteMasterWriteInterface.aclk), 
                                                             .aresetn(axi4LiteMasterWriteInterface.aresetn),
                                                             .valid(axi4LiteMasterWriteInterface.valid),
                                                             .ready(axi4LiteMasterWriteInterface.ready)
                                                            );

  Axi4LiteMasterWriteMonitorBFM axi4LiteMasterWriteMonitorBFM (.aclk(axi4LiteMasterWriteInterface.aclk),
                                                               .aresetn(axi4LiteMasterWriteInterface.aresetn),
                                                               .valid(axi4LiteMasterWriteInterface.valid),
                                                               .ready(axi4LiteMasterWriteInterface.ready)
                                                               );

  assign valid = axi4LiteMasterWriteInterface.valid;
  assign axi4LiteMasterWriteInterface.ready = ready;   

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteMasterWriteDriverBFM)::set(null,"*", "Axi4LiteMasterWriteDriverBFM", axi4LiteMasterWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteMasterWriteMonitorBFM)::set(null,"*", "Axi4LiteMasterWriteMonitorBFM", axi4LiteMasterWriteMonitorBFM);
  end

  bind axi4LiteMasterWriteMonitorBFM Axi4LiteMasterWriteAssertions M_A (.aclk(aclk),
                                                            .aresetn(aresetn),
                                                            .valid(valid),
                                                            .ready(ready)
                                                           );


  initial begin
    `uvm_info("Axi4LiteMasterWriteAgentBFM",$sformatf("AXI4LITE MASTERWRITEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterWriteAgentBFM
`endif
