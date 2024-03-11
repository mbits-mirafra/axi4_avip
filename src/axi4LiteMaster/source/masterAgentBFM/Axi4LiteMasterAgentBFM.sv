`ifndef AXI4LITEMASTERAGENTBFM_INCLUDED_
`define AXI4LITEMASTERAGENTBFM_INCLUDED_

  
module Axi4LiteMasterAgentBFM #(parameter int ADDR_WIDTH = 32,
                                parameter int DATA_WIDTH = 32
                                )
                                (input   clk,
                                 input   aresetn,
                                 output  awaddr,
                                 output  awprot,
                                 output  awvalid,
                                 input   awready,
                                 output  wdata,
                                 output  wstrb,
                                 output  wvalid,
                                 input   wready,
                                 input   bresp,
                                 input   bvalid,
                                 output  bready,

                                 output  araddr,
                                 output  arprot,
                                 output  arvalid,
                                 input   arready,
                                 input   rdata,
                                 output  rresp,
                                 input   rvalid,
                                 output  rready
                                 );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  Axi4LiteMasterInterface axi4LiteMasterInterface();

  Axi4LiteMasterWriteAgentBFM axi4LiteMasterWriteAgentBFM (.aclk(axi4LiteMasterInterface.aclk), 
                                                         .aresetn(axi4LiteMasterInterface.aresetn),
                                                         .awaddr(axi4LiteMasterInterface.awaddr),
                                                         .awprot(axi4LiteMasterInterface.awprot),
                                                         .awvalid(axi4LiteMasterInterface.awvalid),
                                                         .awready(axi4LiteMasterInterface.awready),
                                                         .wdata(axi4LiteMasterInterface.wdata),
                                                         .wstrb(axi4LiteMasterInterface.wstrb),
                                                         .wvalid(axi4LiteMasterInterface.wvalid),
                                                         .wready(axi4LiteMasterInterface.wready),
                                                         .bresp(axi4LiteMasterInterface.bresp),
                                                         .bvalid(axi4LiteMasterInterface.bvalid),
                                                         .bready(axi4LiteMasterInterface.bready)
                                                        );

  Axi4LiteMasterReadAgentBFM axi4LiteMasterReadAgentBFM (.aclk(axi4LiteMasterInterface.aclk), 
                                                       .aresetn(axi4LiteMasterInterface.aresetn),
                                                       .araddr(axi4LiteMasterInterface.araddr),
                                                       .arprot(axi4LiteMasterInterface.arprot),
                                                       .arvalid(axi4LiteMasterInterface.arvalid),
                                                       .arready(axi4LiteMasterInterface.arready),
                                                       .rdata(axi4LiteMasterInterface.rdata),
                                                       .rresp(axi4LiteMasterInterface.rresp),
                                                       .rvalid(axi4LiteMasterInterface.rvalid),
                                                       .rready(axi4LiteMasterInterface.rready) 
                                                      );

  assign clk     = axi4LiteMasterInterface.aclk;
  assign areset  = axi4LiteMasterInterface.aresetn;
  assign awaddr  = axi4LiteMasterInterface.awaddr;
  assign awprot  = axi4LiteMasterInterface.awprot;
  assign awvalid = axi4LiteMasterInterface.awvalid;
  assign awready = axi4LiteMasterInterface.awready;  
  assign wdata   = axi4LiteMasterInterface.wdata;
  assign wstrb   = axi4LiteMasterInterface.wstrb;
  assign wvalid  = axi4LiteMasterInterface.wvalid;
  assign wready  = axi4LiteMasterInterface.wready;
  assign bresp   = axi4LiteMasterInterface.bresp;
  assign bvalid  = axi4LiteMasterInterface.bvalid;
  assign bready  = axi4LiteMasterInterface.bready;

  assign araddr  = axi4LiteMasterInterface.araddr;
  assign arprot  = axi4LiteMasterInterface.arprot;  
  assign arvalid = axi4LiteMasterInterface.arvalid; 
  assign arready = axi4LiteMasterInterface.arready; 
  assign rdata   = axi4LiteMasterInterface.rdata; 
  assign rresp   = axi4LiteMasterInterface.rresp; 
  assign rvalid  = axi4LiteMasterInterface.rvalid; 
  assign rready  = axi4LiteMasterInterface.rready; 

  initial begin
    `uvm_info("Axi4LiteMasterAgent",$sformatf("AXI4LITEMASTERAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterAgentBFM
`endif
