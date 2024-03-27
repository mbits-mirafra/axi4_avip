`ifndef AXI4LITESLAVEREADAGENTBFM_INCLUDED_
`define AXI4LITESLAVEREADAGENTBFM_INCLUDED_

module Axi4LiteSlaveReadAgentBFM #(parameter int ADDR_WIDTH = 32,
                                   parameter int DATA_WIDTH = 32
                                   )
                                   (input  aclk,
                                    input  aresetn,
                                    input  valid,
                                    output ready
                                    );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  Axi4LiteSlaveReadInterface axi4LiteSlaveReadInterface(.aclk(aclk), 
                                                        .aresetn(aresetn)
                                                       );

  Axi4LiteSlaveReadDriverBFM axi4LiteSlaveReadDriverBFM (.aclk(axi4LiteSlaveReadInterface.aclk), 
                                                         .aresetn(axi4LiteSlaveReadInterface.aresetn),
                                                         .valid(axi4LiteSlaveReadInterface.valid),
                                                         .ready(axi4LiteSlaveReadInterface.ready)
                                                        );

  Axi4LiteSlaveReadMonitorBFM axi4LiteSlaveReadMonitorBFM (.aclk(axi4LiteSlaveReadInterface.aclk),
                                                           .aresetn(axi4LiteSlaveReadInterface.aresetn),
                                                           .valid(axi4LiteSlaveReadInterface.valid),
                                                           .ready(axi4LiteSlaveReadInterface.ready)
                                                          );

  assign axi4LiteSlaveReadInterface.valid = valid; 
  assign ready = axi4LiteSlaveReadInterface.ready; 


  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveReadDriverBFM)::set(null,"*", "Axi4LiteSlaveReadDriverBFM", axi4LiteSlaveReadDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveReadMonitorBFM)::set(null,"*", "Axi4LiteSlaveReadMonitorBFM",axi4LiteSlaveReadMonitorBFM);
  end

  bind axi4LiteSlaveReadMonitorBFM Axi4LiteSlaveReadAssertions M_A (.aclk(aclk),
                                                         .aresetn(aresetn),
                                                         .valid(valid), 
                                                         .ready(ready)
                                                        );


  initial begin
   uvm_config_db#(virtual Axi4LiteSlaveReadDriverBFM)::set(null,"*", "Axi4LiteSlaveReadDriverBFM", axi4LiteSlaveReadDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveReadMonitorBFM)::set(null,"*", "Axi4LiteSlaveReadMonitorBFM", axi4LiteSlaveReadMonitorBFM);
  end

  initial begin
    `uvm_info("Axi4LiteSlaveReadAgentBFM",$sformatf("AXI4LITE SlaveREADAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveReadAgentBFM
`endif
