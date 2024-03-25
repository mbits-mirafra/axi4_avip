`ifndef AXI4LITESLAVEREADAGENTBFM_INCLUDED_
`define AXI4LITESLAVEREADAGENTBFM_INCLUDED_

module Axi4LiteSlaveReadAgentBFM #(parameter int ADDR_WIDTH = 32,
                                   parameter int DATA_WIDTH = 32
                                   )
                                   (input  aclk,
                                    input  aresetn,
                                    input  araddr,
                                    input  arprot,
                                    input  arvalid,
                                    output arready,
                                    output rdata,
                                    input  rresp,
                                    output rvalid,
                                    input  rready
                                    );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  Axi4LiteSlaveReadInterface axi4LiteSlaveReadInterface(.aclk(aclk), 
                                                        .aresetn(aresetn)
                                                       );

  Axi4LiteSlaveReadDriverBFM axi4LiteSlaveReadDriverBFM (.aclk(axi4LiteSlaveReadInterface.aclk), 
                                                         .aresetn(axi4LiteSlaveReadInterface.aresetn),
                                                         .araddr(axi4LiteSlaveReadInterface.araddr),
                                                         .arprot(axi4LiteSlaveReadInterface.arprot),
                                                         .arvalid(axi4LiteSlaveReadInterface.arvalid),
                                                         .arready(axi4LiteSlaveReadInterface.arready),
                                                         .rdata(axi4LiteSlaveReadInterface.rdata),
                                                         .rresp(axi4LiteSlaveReadInterface.rresp),
                                                         .rvalid(axi4LiteSlaveReadInterface.rvalid),
                                                         .rready(axi4LiteSlaveReadInterface.rready) 
                                                        );

  Axi4LiteSlaveReadMonitorBFM axi4LiteSlaveReadMonitorBFM (.aclk(axi4LiteSlaveReadInterface.aclk),
                                                           .aresetn(axi4LiteSlaveReadInterface.aresetn),
                                                           .araddr(axi4LiteSlaveReadInterface.araddr),
                                                           .arprot(axi4LiteSlaveReadInterface.arprot),
                                                           .arvalid(axi4LiteSlaveReadInterface.arvalid),
                                                           .arready(axi4LiteSlaveReadInterface.arready),
                                                           .rdata(axi4LiteSlaveReadInterface.rdata),
                                                           .rresp(axi4LiteSlaveReadInterface.rresp),
                                                           .rvalid(axi4LiteSlaveReadInterface.rvalid),
                                                           .rready(axi4LiteSlaveReadInterface.rready)
                                                          );

  assign axi4LiteSlaveReadInterface.araddr  = araddr; 
  assign axi4LiteSlaveReadInterface.arprot  = arprot;   
  assign axi4LiteSlaveReadInterface.arvalid = arvalid; 
  assign axi4LiteSlaveReadInterface.rdata   = rdata;  
  assign axi4LiteSlaveReadInterface.rready  = rready;  
  assign arready = axi4LiteSlaveReadInterface.arready; 
  assign rresp   = axi4LiteSlaveReadInterface.rresp; 
  assign rvalid  = axi4LiteSlaveReadInterface.rvalid; 


  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveReadDriverBFM)::set(null,"*", "Axi4LiteSlaveReadDriverBFM", axi4LiteSlaveReadDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveReadMonitorBFM)::set(null,"*", "Axi4LiteSlaveReadMonitorBFM",axi4LiteSlaveReadMonitorBFM);
  end

  bind axi4LiteSlaveReadMonitorBFM Axi4LiteSlaveReadAssertions M_A (.aclk(aclk),
                                                         .aresetn(aresetn),
                                                         .araddr(araddr),  
                                                         .arprot(arprot),
                                                         .arvalid(arvalid), 
                                                         .arready(arready),
                                                         .rdata(rdata),
                                                         .rresp(rresp),
                                                         .rvalid(rvalid),
                                                         .rready(rready)
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
