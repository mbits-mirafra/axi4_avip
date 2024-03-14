`ifndef AXI4LITEMASTERWRITEAGENTBFM_INCLUDED_
`define AXI4LITEMASTERWRITEAGENTBFM_INCLUDED_

module Axi4LiteMasterWriteAgentBFM #(parameter int ADDR_WIDTH = 32,
                                     parameter int DATA_WIDTH = 32
                                    )
                                    (input  aclk,
                                     input  aresetn,
                                     output awaddr,
                                     output awprot,
                                     output awvalid,
                                     input  awready,
                                     output wdata,
                                     output wstrb,
                                     output wvalid,
                                     input  wready,
                                     input  bresp,
                                     input  bvalid,
                                     output bready
                                     );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  Axi4LiteMasterWriteInterface axi4LiteMasterWriteInterface();

  Axi4LiteMasterWriteDriverBFM axi4LiteMasterWriteDriverBFM (.aclk(axi4LiteMasterWriteInterface.aclk), 
                                                .aresetn(axi4LiteMasterWriteInterface.aresetn),
                                                .awaddr(axi4LiteMasterWriteInterface.awaddr),
                                                .awprot(axi4LiteMasterWriteInterface.awprot),
                                                .awvalid(axi4LiteMasterWriteInterface.awvalid),
                                                .awready(axi4LiteMasterWriteInterface.awready),
                                                .wdata(axi4LiteMasterWriteInterface.wdata),
                                                .wstrb(axi4LiteMasterWriteInterface.wstrb),
                                                .wvalid(axi4LiteMasterWriteInterface.wvalid),
                                                .wready(axi4LiteMasterWriteInterface.wready),
                                                .bresp(axi4LiteMasterWriteInterface.bresp),
                                                .bvalid(axi4LiteMasterWriteInterface.bvalid),
                                                .bready(axi4LiteMasterWriteInterface.bready)
                                                );

  Axi4LiteMasterWriteMonitorBFM axi4LiteMasterWriteMonitorBFM (.aclk(axi4LiteMasterWriteInterface.aclk),
                                                 .aresetn(axi4LiteMasterWriteInterface.aresetn),
                                                 .awaddr(axi4LiteMasterWriteInterface.awaddr),
                                                 .awprot(axi4LiteMasterWriteInterface.awprot),
                                                 .awvalid(axi4LiteMasterWriteInterface.awvalid),
                                                 .awready(axi4LiteMasterWriteInterface.awready),
                                                 .wdata(axi4LiteMasterWriteInterface.wdata),
                                                 .wstrb(axi4LiteMasterWriteInterface.wstrb),
                                                 .wvalid(axi4LiteMasterWriteInterface.wvalid),
                                                 .wready(axi4LiteMasterWriteInterface.wready),
                                                 .bresp(axi4LiteMasterWriteInterface.bresp),
                                                 .bvalid(axi4LiteMasterWriteInterface.bvalid),
                                                 .bready(axi4LiteMasterWriteInterface.bready)
                                                 );

  assign clk     = axi4LiteMasterWriteInterface.aclk;
  assign aresetn = axi4LiteMasterWriteInterface.aresetn;
  assign awaddr  = axi4LiteMasterWriteInterface.awaddr;
  assign awprot  = axi4LiteMasterWriteInterface.awprot;
  assign awvalid = axi4LiteMasterWriteInterface.awvalid;
  assign awready = axi4LiteMasterWriteInterface.awready;
  assign wdata   = axi4LiteMasterWriteInterface.wdata;
  assign wstrb   = axi4LiteMasterWriteInterface.wstrb;
  assign wvalid  = axi4LiteMasterWriteInterface.wvalid;
  assign wready  = axi4LiteMasterWriteInterface.wready;
  assign bresp   = axi4LiteMasterWriteInterface.bresp;
  assign bvalid  = axi4LiteMasterWriteInterface.bvalid;
  assign bready  = axi4LiteMasterWriteInterface.bready;

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteMasterWriteDriverBFM)::set(null,"*", "Axi4LiteMasterWriteDriverBFM", axi4LiteMasterWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteMasterWriteMonitorBFM)::set(null,"*", "Axi4LiteMasterWriteMonitorBFM", axi4LiteMasterWriteMonitorBFM);
  end

  bind axi4LiteMasterWriteMonitorBFM MasterAssertions M_A (.aclk(aclk),
                                                            .aresetn(aresetn),
                                                            .awaddr(awaddr),
                                                            .awprot(awprot),
                                                            .awvalid(awvalid),
                                                            .awready(awready),
                                                            .wdata(wdata),
                                                            .wstrb(wstrb),
                                                            .wvalid(wvalid),
                                                            .wready(wready),
                                                            .bvalid(bvalid),
                                                            .bready(bready),
                                                            .bresp(bresp)
                                                           );


  initial begin
    `uvm_info("Axi4LiteMasterWriteAgentBFM",$sformatf("AXI4LITE MASTERWRITEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterWriteAgentBFM
`endif
