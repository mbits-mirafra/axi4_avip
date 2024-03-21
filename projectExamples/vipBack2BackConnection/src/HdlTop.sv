`ifndef HDLTOP_INCLUDED_
`define HDLTOP_INCLUDED_

module HdlTop;

  import uvm_pkg::*;
  import Axi4LiteGlobalsPkg::*;
  `include "uvm_macros.svh"

  bit aclk;
  bit aresetn;

  initial begin
    $display("HDL_TOP");
  end

  initial begin
    aclk = 1'b0;
    forever #10 aclk = ~aclk;
  end

  initial begin
    aresetn = 1'b1;
    #10 aresetn = 1'b0;

    repeat (1) begin
      @(posedge aclk);
    end
    aresetn = 1'b1;
  end

  Axi4LiteInterface Intf(.aclk(aclk),
                         .aresetn(aresetn));

  genvar i;
  generate
    for (i=0; i<NO_OF_MASTERS; i++) begin : Axi4LiteMasterAgentBFM
      Axi4LiteMasterAgentBFM #() axi4LiteMasterAgentBFM(.aclk(Intf.aclk),
                                                        .aresetn(Intf.aresetn),
                                                        .awaddr(Intf.awaddr),
                                                        .awprot(Intf.awprot),
                                                        .awvalid(Intf.awvalid),
                                                        .awready(Intf.awready),
                                                        .wdata(Intf.wdata),
                                                        .wstrb(Intf.wstrb),
                                                        .wvalid(Intf.wvalid),
                                                        .wready(Intf.wready),
                                                        .bresp(Intf.bresp),
                                                        .bvalid(Intf.bvalid),
                                                        .bready(Intf.bready),
                                                        .araddr(Intf.araddr),
                                                        .arprot(Intf.arprot),
                                                        .arvalid(Intf.arvalid),
                                                        .arready(Intf.arready),
                                                        .rdata(Intf.rdata),
                                                        .rresp(Intf.rresp),
                                                        .rvalid(Intf.rvalid),
                                                        .rready(Intf.rready)
                                                       );
    end
    for (i=0; i<NO_OF_SLAVES; i++) begin : Axi4LiteSlaveAgentBFM
      Axi4LiteSlaveAgentBFM #() axi4LiteSlaveAgentBFM(.aclk(Intf.aclk),
                                                      .aresetn(Intf.aresetn),
                                                      .awaddr(Intf.awaddr),
                                                      .awprot(Intf.awprot),
                                                      .awvalid(Intf.awvalid),
                                                      .awready(Intf.awready),
                                                      .wdata(Intf.wdata),
                                                      .wstrb(Intf.wstrb),
                                                      .wvalid(Intf.wvalid),
                                                      .wready(Intf.wready),
                                                      .bresp(Intf.bresp),
                                                      .bvalid(Intf.bvalid),
                                                      .bready(Intf.bready),
                                                      .araddr(Intf.araddr),
                                                      .arprot(Intf.arprot),
                                                      .arvalid(Intf.arvalid),
                                                      .arready(Intf.arready),
                                                      .rdata(Intf.rdata),
                                                      .rresp(Intf.rresp),
                                                      .rvalid(Intf.rvalid),
                                                      .rready(Intf.rready)
                                                     );
    end
  endgenerate
  
endmodule : HdlTop

`endif

