`ifndef AXI4LITESLAVEAGENTBFM_INCLUDED_
`define AXI4LITESLAVEAGENTBFM_INCLUDED_

module Axi4LiteSlaveAgentBFM #(parameter int ADDR_WIDTH = 32,
                               parameter int DATA_WIDTH = 32
                                )
                                (input  clk,
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

  Axi4LiteSlaveInterface axi4LiteSlaveInterface();

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
                                 
  assign clk     = axi4LiteSlaveInterface.aclk;
  assign areset  = axi4LiteSlaveInterface.aresetn;
  assign awaddr  = axi4LiteSlaveInterface.awaddr;
  assign awprot  = axi4LiteSlaveInterface.awprot;
  assign awvalid = axi4LiteSlaveInterface.awvalid;
  assign awready = axi4LiteSlaveInterface.awready;  
  assign wdata   = axi4LiteSlaveInterface.wdata;
  assign wstrb   = axi4LiteSlaveInterface.wstrb;
  assign wvalid  = axi4LiteSlaveInterface.wvalid;
  assign wready  = axi4LiteSlaveInterface.wready;
  assign bresp   = axi4LiteSlaveInterface.bresp;
  assign bvalid  = axi4LiteSlaveInterface.bvalid;
  assign bready  = axi4LiteSlaveInterface.bready;

  assign araddr  = axi4LiteSlaveInterface.araddr;
  assign arprot  = axi4LiteSlaveInterface.arprot;  
  assign arvalid = axi4LiteSlaveInterface.arvalid; 
  assign arready = axi4LiteSlaveInterface.arready; 
  assign rdata   = axi4LiteSlaveInterface.rdata; 
  assign rresp   = axi4LiteSlaveInterface.rresp; 
  assign rvalid  = axi4LiteSlaveInterface.rvalid; 
  assign rready  = axi4LiteSlaveInterface.rready; 

  initial begin
    `uvm_info("Axi4LiteMasterAgent",$sformatf("AXI4LITESLAVEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveAgentBFM
`endif
