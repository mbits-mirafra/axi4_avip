`ifndef AXI4LITESLAVEWRITEAGENTBFM_INCLUDED_
`define AXI4LITESLAVEWRITEAGENTBFM_INCLUDED_

   
module Axi4LiteSlaveWriteAgentBFM #(parameter int ADDR_WIDTH = 32,
                                    parameter int DATA_WIDTH = 32
                                   )
                                   (input  aclk,
                                    input  aresetn,
                                    input  valid,
                                    output ready
                                    );
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  Axi4LiteSlaveWriteInterface axi4LiteSlaveWriteInterface(.aclk(aclk), 
                                                          .aresetn(aresetn)
                                                         );
  
  Axi4LiteSlaveWriteDriverBFM axi4LiteSlaveWriteDriverBFM (.aclk(axi4LiteSlaveWriteInterface.aclk), 
                                                           .aresetn(axi4LiteSlaveWriteInterface.aresetn),
                                                           .valid(axi4LiteSlaveWriteInterface.valid),
                                                           .ready(axi4LiteSlaveWriteInterface.ready)
                                                          );

  Axi4LiteSlaveWriteMonitorBFM axi4LiteSlaveWriteMonitorBFM (.aclk(axi4LiteSlaveWriteInterface.aclk),
                                                             .aresetn(axi4LiteSlaveWriteInterface.aresetn),
                                                             .valid(axi4LiteSlaveWriteInterface.valid),
                                                             .ready(axi4LiteSlaveWriteInterface.ready)
                                                            );

  assign axi4LiteSlaveWriteInterface.valid = valid;
  assign ready = axi4LiteSlaveWriteInterface.ready;  

  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveWriteDriverBFM)::set(null,"*", "Axi4LiteSlaveWriteDriverBFM", axi4LiteSlaveWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::set(null,"*", "Axi4LiteSlaveWriteMonitorBFM", axi4LiteSlaveWriteMonitorBFM);
  end

  bind axi4LiteSlaveWriteMonitorBFM Axi4LiteSlaveWriteAssertions M_A (.aclk(aclk),
                                                          .aresetn(aresetn),
                                                          .valid(valid),
                                                          .ready(ready)
                                                         );
  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveWriteDriverBFM)::set(null,"*", "Axi4LiteSlaveWriteDriverBFM", axi4LiteSlaveWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::set(null,"*", "Axi4LiteSlaveWriteMonitorBFM", axi4LiteSlaveWriteMonitorBFM);
  end

  initial begin
    `uvm_info("Axi4LiteSlaveWriteAgentBFM",$sformatf("AXI4LITE SLAVEWRITEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveWriteAgentBFM
`endif
