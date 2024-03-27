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

  Axi4LiteInterface axi4LiteInterface(.aclk(aclk),
                                      .aresetn(aresetn));

  Axi4LiteAssertions axi4LiteAssertions(.aclk(aclk),
                                      .aresetn(aresetn));

  genvar i;
  generate
    for (i=0; i<NO_OF_MASTERS; i++) begin : Axi4LiteMasterAgentBFM
      Axi4LiteMasterAgentBFM #() axi4LiteMasterAgentBFM(.aclk(axi4LiteInterface.aclk),
                                                        .aresetn(axi4LiteInterface.aresetn),
                                                        .valid(axi4LiteInterface.valid),
                                                        .ready(axi4LiteInterface.ready)
                                                       );
    end
    for (i=0; i<NO_OF_SLAVES; i++) begin : Axi4LiteSlaveAgentBFM
      Axi4LiteSlaveAgentBFM #() axi4LiteSlaveAgentBFM(.aclk(axi4LiteInterface.aclk),
                                                      .aresetn(axi4LiteInterface.aresetn),
                                                      .valid(axi4LiteInterface.valid),
                                                      .ready(axi4LiteInterface.ready)
                                                     );
    end
  endgenerate
  
endmodule : HdlTop

`endif

