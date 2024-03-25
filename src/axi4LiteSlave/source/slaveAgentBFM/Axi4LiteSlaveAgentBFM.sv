`ifndef AXI4LITESLAVEAGENTBFM_INCLUDED_
`define AXI4LITESLAVEAGENTBFM_INCLUDED_

module Axi4LiteSlaveAgentBFM #(parameter int ADDR_WIDTH = 32,
                               parameter int DATA_WIDTH = 32
                                )
                                (input  aclk,
                                 input  aresetn,
                                 input  awaddr,
                                 input  awprot,
                                 input  awvalid,
                                 output awready,
                                 input  wdata,
                                 input  wstrb,
                                 input  wvalid,
                                 output wready,
                                 output bresp,
                                 output bvalid,
                                 input  bready,

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

  Axi4LiteSlaveInterface axi4LiteSlaveInterface(.aclk(aclk), 
                                                .aresetn(aresetn)
                                               );

  Axi4LiteSlaveWriteAgentBFM axi4LiteSlaveWriteAgentBFM (.aclk(axi4LiteSlaveInterface.aclk), 
                                                         .aresetn(axi4LiteSlaveInterface.aresetn),
                                                         .awaddr(axi4LiteSlaveInterface.awaddr),
                                                         .awprot(axi4LiteSlaveInterface.awprot),
                                                         .awvalid(axi4LiteSlaveInterface.awvalid),
                                                         .awready(axi4LiteSlaveInterface.awready),
                                                         .wdata(axi4LiteSlaveInterface.wdata),
                                                         .wstrb(axi4LiteSlaveInterface.wstrb),
                                                         .wvalid(axi4LiteSlaveInterface.wvalid),
                                                         .wready(axi4LiteSlaveInterface.wready),
                                                         .bresp(axi4LiteSlaveInterface.bresp),
                                                         .bvalid(axi4LiteSlaveInterface.bvalid),
                                                         .bready(axi4LiteSlaveInterface.bready)
                                                        );

  Axi4LiteSlaveReadAgentBFM axi4LiteSlaveReadAgentBFM (.aclk(axi4LiteSlaveInterface.aclk), 
                                                       .aresetn(axi4LiteSlaveInterface.aresetn),
                                                       .araddr(axi4LiteSlaveInterface.araddr),
                                                       .arprot(axi4LiteSlaveInterface.arprot),
                                                       .arvalid(axi4LiteSlaveInterface.arvalid),
                                                       .arready(axi4LiteSlaveInterface.arready),
                                                       .rdata(axi4LiteSlaveInterface.rdata),
                                                       .rresp(axi4LiteSlaveInterface.rresp),
                                                       .rvalid(axi4LiteSlaveInterface.rvalid),
                                                       .rready(axi4LiteSlaveInterface.rready) 
                                                      );
                                 
  assign axi4LiteSlaveInterface.awaddr  = awaddr; 
  assign axi4LiteSlaveInterface.awprot  = awprot; 
  assign axi4LiteSlaveInterface.awvalid = awvalid;
  assign axi4LiteSlaveInterface.wdata   = wdata;  
  assign axi4LiteSlaveInterface.wstrb   = wstrb;  
  assign axi4LiteSlaveInterface.wvalid  = wvalid; 
  assign axi4LiteSlaveInterface.bready  = bready; 

  assign axi4LiteSlaveInterface.araddr  = araddr; 
  assign axi4LiteSlaveInterface.arprot  = arprot;   
  assign axi4LiteSlaveInterface.arvalid = arvalid; 
  assign axi4LiteSlaveInterface.rdata   = rdata;  
  assign axi4LiteSlaveInterface.rready  = rready;  

  assign awready = axi4LiteSlaveInterface.awready;  
  assign wready  = axi4LiteSlaveInterface.wready;
  assign bresp   = axi4LiteSlaveInterface.bresp;
  assign bvalid  = axi4LiteSlaveInterface.bvalid;

  assign arready = axi4LiteSlaveInterface.arready; 
  assign rresp   = axi4LiteSlaveInterface.rresp; 
  assign rvalid  = axi4LiteSlaveInterface.rvalid; 

  initial begin
    `uvm_info("Axi4LiteMasterAgent",$sformatf("AXI4LITESLAVEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveAgentBFM
`endif
