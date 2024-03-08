`ifndef AXI4LITEMASTERWRITEAGENT_INCLUDED_
`define AXI4LITEMASTERWRITEAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module:Axi4LiteMasterWriteAgent 
// This module is used as the configuration class for master agent bfm and its components
//--------------------------------------------------------------------------------------------
module Axi4LiteMasterWriteAgent #(parameter int MASTER_ID = 0)(Axi4LiteMasterWriteInterface axi4LiteMasterWriteInterface);
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Axi4LiteMasterWriteDriverBFM instantiation
  //-------------------------------------------------------
  Axi4LiteMasterWriteDriverBFM axi4LiteMasterWriteDriverBFM (.aclk(axi4LiteMasterWriteInterface.aclk), 
                                                .aresetn(axi4LiteMasterWriteInterface.aresetn),
                                                .awid(axi4LiteMasterWriteInterface.awid),
                                                .awaddr(axi4LiteMasterWriteInterface.awaddr),
                                                .awlen(axi4LiteMasterWriteInterface.awlen),
                                                .awsize(axi4LiteMasterWriteInterface.awsize),
                                                .awburst(axi4LiteMasterWriteInterface.awburst),
                                                .awlock(axi4LiteMasterWriteInterface.awlock),
                                                .awcache(axi4LiteMasterWriteInterface.awcache),
                                                .awprot(axi4LiteMasterWriteInterface.awprot),
                                                .awqos(axi4LiteMasterWriteInterface.awqos),
                                                .awregion(axi4LiteMasterWriteInterface.awregion),
                                                .awuser(axi4LiteMasterWriteInterface.awuser),
                                                .awvalid(axi4LiteMasterWriteInterface.awvalid),
                                                .awready(axi4LiteMasterWriteInterface.awready),
                                                .wdata(axi4LiteMasterWriteInterface.wdata),
                                                .wstrb(axi4LiteMasterWriteInterface.wstrb),
                                                .wlast(axi4LiteMasterWriteInterface.wlast),
                                                .wuser(axi4LiteMasterWriteInterface.wuser),
                                                .wvalid(axi4LiteMasterWriteInterface.wvalid),
                                                .wready(axi4LiteMasterWriteInterface.wready),
                                                .bid(axi4LiteMasterWriteInterface.bid),
                                                .bresp(axi4LiteMasterWriteInterface.bresp),
                                                .buser(axi4LiteMasterWriteInterface.buser),
                                                .bvalid(axi4LiteMasterWriteInterface.bvalid),
                                                .bready(axi4LiteMasterWriteInterface.bready)
                                              /*.arid(axi4LiteMasterWriteInterface.arid),
                                                .araddr(axi4LiteMasterWriteInterface.araddr),
                                                .arlen(axi4LiteMasterWriteInterface.arlen),
                                                .arsize(axi4LiteMasterWriteInterface.arsize),
                                                .arburst(axi4LiteMasterWriteInterface.arburst),
                                                .arlock(axi4LiteMasterWriteInterface.arlock),
                                                .arcache(axi4LiteMasterWriteInterface.arcache),
                                                .arprot(axi4LiteMasterWriteInterface.arprot),
                                                .arqos(axi4LiteMasterWriteInterface.arqos),
                                                .arregion(axi4LiteMasterWriteInterface.arregion),
                                                .aruser(axi4LiteMasterWriteInterface.aruser),
                                                .arvalid(axi4LiteMasterWriteInterface.arvalid),
                                                .arready(axi4LiteMasterWriteInterface.arready),
                                                .rid(axi4LiteMasterWriteInterface.rid),
                                                .rdata(axi4LiteMasterWriteInterface.rdata),
                                                .rresp(axi4LiteMasterWriteInterface.rresp),
                                                .rlast(axi4LiteMasterWriteInterface.rlast),
                                                .ruser(axi4LiteMasterWriteInterface.ruser),      
                                                .rvalid(axi4LiteMasterWriteInterface.rvalid),
                                                .rready(axi4LiteMasterWriteInterface.rready) */
                                                );

  //-------------------------------------------------------
  //Axi4LiteMasterWriteMonitorBFM instantiation
  //-------------------------------------------------------
  Axi4LiteMasterWriteMonitorBFM axi4LiteMasterWriteMonitorBFM (.aclk(axi4LiteMasterWriteInterface.aclk),
                                                 .aresetn(axi4LiteMasterWriteInterface.aresetn),
                                                 .awid(axi4LiteMasterWriteInterface.awid),
                                                 .awaddr(axi4LiteMasterWriteInterface.awaddr),
                                                 .awlen(axi4LiteMasterWriteInterface.awlen),
                                                 .awsize(axi4LiteMasterWriteInterface.awsize),
                                                 .awburst(axi4LiteMasterWriteInterface.awburst),
                                                 .awlock(axi4LiteMasterWriteInterface.awlock),
                                                 .awcache(axi4LiteMasterWriteInterface.awcache),
                                                 .awprot(axi4LiteMasterWriteInterface.awprot),
                                                 .awvalid(axi4LiteMasterWriteInterface.awvalid),
                                                 .awready(axi4LiteMasterWriteInterface.awready),
                                                 .wdata(axi4LiteMasterWriteInterface.wdata),
                                                 .wstrb(axi4LiteMasterWriteInterface.wstrb),
                                                 .wlast(axi4LiteMasterWriteInterface.wlast),
                                                 .wuser(axi4LiteMasterWriteInterface.wuser),
                                                 .wvalid(axi4LiteMasterWriteInterface.wvalid),
                                                 .wready(axi4LiteMasterWriteInterface.wready),
                                                 .bid(axi4LiteMasterWriteInterface.bid),
                                                 .bresp(axi4LiteMasterWriteInterface.bresp),
                                                 .buser(axi4LiteMasterWriteInterface.buser),
                                                 .bvalid(axi4LiteMasterWriteInterface.bvalid),
                                                 .bready(axi4LiteMasterWriteInterface.bready)
                                          /*       .arid(axi4LiteMasterWriteInterface.arid),
                                                 .araddr(axi4LiteMasterWriteInterface.araddr),
                                                 .arlen(axi4LiteMasterWriteInterface.arlen),
                                                 .arsize(axi4LiteMasterWriteInterface.arsize),
                                                 .arburst(axi4LiteMasterWriteInterface.arburst),
                                                 .arlock(axi4LiteMasterWriteInterface.arlock),
                                                 .arcache(axi4LiteMasterWriteInterface.arcache),
                                                 .arprot(axi4LiteMasterWriteInterface.arprot),
                                                 .arqos(axi4LiteMasterWriteInterface.arqos),
                                                 .arregion(axi4LiteMasterWriteInterface.arregion),
                                                 .aruser(axi4LiteMasterWriteInterface.aruser),
                                                 .arvalid(axi4LiteMasterWriteInterface.arvalid),
                                                 .arready(axi4LiteMasterWriteInterface.arready),
                                                 .rid(axi4LiteMasterWriteInterface.rid),
                                                 .rdata(axi4LiteMasterWriteInterface.rdata),
                                                 .rresp(axi4LiteMasterWriteInterface.rresp),
                                                 .rlast(axi4LiteMasterWriteInterface.rlast),
                                                 .ruser(axi4LiteMasterWriteInterface.ruser),      
                                                 .rvalid(axi4LiteMasterWriteInterface.rvalid),
                                                 .rready(axi4LiteMasterWriteInterface.rready)
                                            */     );

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteMasterWriteDriverBFM)::set(null,"*", "Axi4LiteMasterWriteDriverBFM", axi4LiteMasterWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteMasterWriteMonitorBFM)::set(null,"*", "Axi4LiteMasterWriteMonitorBFM", axi4LiteMasterWriteMonitorBFM);
  end

  bind axi4LiteMasterWriteMonitorBFM master_assertions M_A (.aclk(aclk),
                                                      .aresetn(aresetn),
                                                      .awid(awid),
                                                      .awaddr(awaddr),
                                                      .awlen(awlen),
                                                      .awsize(awsize),
                                                      .awburst(awburst),
                                                      .awlock(awlock),
                                                      .awcache(awcache),
                                                      .awprot(awprot),
                                                      .awvalid(awvalid),
                                                      .awready(awready),
                                                      .wdata(wdata),
                                                      .wstrb(wstrb),
                                                      .wlast(wlast),
                                                      .wuser(wuser),
                                                      .wvalid(wvalid),
                                                      .wready(wready),
                                                      .bid(bid),
                                                      .buser(buser),
                                                      .bvalid(bvalid),
                                                      .bready(bready),
                                                      .bresp(bresp)
                                                     /* .arid(arid),
                                                      .araddr(araddr),  
                                                      .arlen(arlen),   
                                                      .arsize(arsize), 
                                                      .arburst(arburst), 
                                                      .arlock(arlock),  
                                                      .arcache(arcache), 
                                                      .arprot(arprot),
                                                      .arqos(arqos),   
                                                      .arregion(arregion), 
                                                      .aruser(aruser),  
                                                      .arvalid(arvalid), 
                                                      .arready(arready),
                                                      .rid(rid),
                                                      .rdata(rdata),
                                                      .rresp(rresp),
                                                      .rlast(rlast),
                                                      .ruser(ruser),
                                                      .rvalid(rvalid),
                                                      .rready(rready)
                                                   */ );


  //Printing Axi4LiteMasterWriteAgent
  initial begin
    `uvm_info("Axi4LiteMasterWriteAgent",$sformatf("AXI4LITE MASTERWRITEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterWriteAgent
`endif
