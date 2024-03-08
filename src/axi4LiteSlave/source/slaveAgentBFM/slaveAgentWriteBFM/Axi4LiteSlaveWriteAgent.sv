`ifndef AXI4LITESLAVEWRITEAGENT_INCLUDED_
`define AXI4LITESLAVEWRITEAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module:Axi4LiteSlaveWriteAgent 
// This module is used as the configuration class for slave agent bfm and its components
//--------------------------------------------------------------------------------------------
module Axi4LiteSlaveWriteAgent #(parameter int SLAVE_ID = 0)(Axi4LiteSlaveWriteInterface axi4LiteSlaveWriteInterface);
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Axi4LiteSlaveWriteDriverBFM instantiation
  //-------------------------------------------------------
  Axi4LiteSlaveWriteDriverBFM axi4LiteSlaveWriteDriverBFM (.aclk(axi4LiteSlaveWriteInterface.aclk), 
                                                .aresetn(axi4LiteSlaveWriteInterface.aresetn),
                                                .awid(axi4LiteSlaveWriteInterface.awid),
                                                .awaddr(axi4LiteSlaveWriteInterface.awaddr),
                                                .awlen(axi4LiteSlaveWriteInterface.awlen),
                                                .awsize(axi4LiteSlaveWriteInterface.awsize),
                                                .awburst(axi4LiteSlaveWriteInterface.awburst),
                                                .awlock(axi4LiteSlaveWriteInterface.awlock),
                                                .awcache(axi4LiteSlaveWriteInterface.awcache),
                                                .awprot(axi4LiteSlaveWriteInterface.awprot),
                                                .awqos(axi4LiteSlaveWriteInterface.awqos),
                                                .awregion(axi4LiteSlaveWriteInterface.awregion),
                                                .awuser(axi4LiteSlaveWriteInterface.awuser),
                                                .awvalid(axi4LiteSlaveWriteInterface.awvalid),
                                                .awready(axi4LiteSlaveWriteInterface.awready),
                                                .wdata(axi4LiteSlaveWriteInterface.wdata),
                                                .wstrb(axi4LiteSlaveWriteInterface.wstrb),
                                                .wlast(axi4LiteSlaveWriteInterface.wlast),
                                                .wuser(axi4LiteSlaveWriteInterface.wuser),
                                                .wvalid(axi4LiteSlaveWriteInterface.wvalid),
                                                .wready(axi4LiteSlaveWriteInterface.wready),
                                                .bid(axi4LiteSlaveWriteInterface.bid),
                                                .bresp(axi4LiteSlaveWriteInterface.bresp),
                                                .buser(axi4LiteSlaveWriteInterface.buser),
                                                .bvalid(axi4LiteSlaveWriteInterface.bvalid),
                                                .bready(axi4LiteSlaveWriteInterface.bready)
                                              /*  .arid(axi4LiteSlaveWriteInterface.arid),
                                                .araddr(axi4LiteSlaveWriteInterface.araddr),
                                                .arlen(axi4LiteSlaveWriteInterface.arlen),
                                                .arsize(axi4LiteSlaveWriteInterface.arsize),
                                                .arburst(axi4LiteSlaveWriteInterface.arburst),
                                                .arlock(axi4LiteSlaveWriteInterface.arlock),
                                                .arcache(axi4LiteSlaveWriteInterface.arcache),
                                                .arprot(axi4LiteSlaveWriteInterface.arprot),
                                                .arqos(axi4LiteSlaveWriteInterface.arqos),
                                                .arregion(axi4LiteSlaveWriteInterface.arregion),
                                                .aruser(axi4LiteSlaveWriteInterface.aruser),
                                                .arvalid(axi4LiteSlaveWriteInterface.arvalid),
                                                .arready(axi4LiteSlaveWriteInterface.arready),
                                                .rid(axi4LiteSlaveWriteInterface.rid),
                                                .rdata(axi4LiteSlaveWriteInterface.rdata),
                                                .rresp(axi4LiteSlaveWriteInterface.rresp),
                                                .rlast(axi4LiteSlaveWriteInterface.rlast),
                                                .ruser(axi4LiteSlaveWriteInterface.ruser),      
                                                .rvalid(axi4LiteSlaveWriteInterface.rvalid),
                                                .rready(axi4LiteSlaveWriteInterface.rready) */
                                                );

  //-------------------------------------------------------
  //Axi4LiteSlaveWriteMonitorBFM instantiation
  //-------------------------------------------------------
  Axi4LiteSlaveWriteMonitorBFM axi4LiteSlaveWriteMonitorBFM (.aclk(axi4LiteSlaveWriteInterface.aclk),
                                                 .aresetn(axi4LiteSlaveWriteInterface.aresetn),
                                                 .awid(axi4LiteSlaveWriteInterface.awid),
                                                 .awaddr(axi4LiteSlaveWriteInterface.awaddr),
                                                 .awlen(axi4LiteSlaveWriteInterface.awlen),
                                                 .awsize(axi4LiteSlaveWriteInterface.awsize),
                                                 .awburst(axi4LiteSlaveWriteInterface.awburst),
                                                 .awlock(axi4LiteSlaveWriteInterface.awlock),
                                                 .awcache(axi4LiteSlaveWriteInterface.awcache),
                                                 .awprot(axi4LiteSlaveWriteInterface.awprot),
                                                 .awvalid(axi4LiteSlaveWriteInterface.awvalid),
                                                 .awready(axi4LiteSlaveWriteInterface.awready),
                                                 .wdata(axi4LiteSlaveWriteInterface.wdata),
                                                 .wstrb(axi4LiteSlaveWriteInterface.wstrb),
                                                 .wlast(axi4LiteSlaveWriteInterface.wlast),
                                                 .wuser(axi4LiteSlaveWriteInterface.wuser),
                                                 .wvalid(axi4LiteSlaveWriteInterface.wvalid),
                                                 .wready(axi4LiteSlaveWriteInterface.wready),
                                                 .bid(axi4LiteSlaveWriteInterface.bid),
                                                 .bresp(axi4LiteSlaveWriteInterface.bresp),
                                                 .buser(axi4LiteSlaveWriteInterface.buser),
                                                 .bvalid(axi4LiteSlaveWriteInterface.bvalid),
                                                 .bready(axi4LiteSlaveWriteInterface.bready)
                                          /*       .arid(axi4LiteSlaveWriteInterface.arid),
                                                 .araddr(axi4LiteSlaveWriteInterface.araddr),
                                                 .arlen(axi4LiteSlaveWriteInterface.arlen),
                                                 .arsize(axi4LiteSlaveWriteInterface.arsize),
                                                 .arburst(axi4LiteSlaveWriteInterface.arburst),
                                                 .arlock(axi4LiteSlaveWriteInterface.arlock),
                                                 .arcache(axi4LiteSlaveWriteInterface.arcache),
                                                 .arprot(axi4LiteSlaveWriteInterface.arprot),
                                                 .arqos(axi4LiteSlaveWriteInterface.arqos),
                                                 .arregion(axi4LiteSlaveWriteInterface.arregion),
                                                 .aruser(axi4LiteSlaveWriteInterface.aruser),
                                                 .arvalid(axi4LiteSlaveWriteInterface.arvalid),
                                                 .arready(axi4LiteSlaveWriteInterface.arready),
                                                 .rid(axi4LiteSlaveWriteInterface.rid),
                                                 .rdata(axi4LiteSlaveWriteInterface.rdata),
                                                 .rresp(axi4LiteSlaveWriteInterface.rresp),
                                                 .rlast(axi4LiteSlaveWriteInterface.rlast),
                                                 .ruser(axi4LiteSlaveWriteInterface.ruser),      
                                                 .rvalid(axi4LiteSlaveWriteInterface.rvalid),
                                                 .rready(axi4LiteSlaveWriteInterface.rready)
                                            */     );

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveWriteDriverBFM)::set(null,"*", "Axi4LiteSlaveWriteDriverBFM", axi4LiteSlaveWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::set(null,"*", "Axi4LiteSlaveWriteMonitorBFM", axi4LiteSlaveWriteMonitorBFM);
  end

  bind axi4LiteSlaveWriteMonitorBFM slave_assertions M_A (.aclk(aclk),
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
  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveWriteDriverBFM)::set(null,"*", "Axi4LiteSlaveWriteDriverBFM", axi4LiteSlaveWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::set(null,"*", "Axi4LiteSlaveWriteMonitorBFM", axi4LiteSlaveWriteMonitorBFM);
  end

  //Printing Axi4LiteSlaveWriteAgent
  initial begin
    `uvm_info("Axi4LiteSlaveWriteAgent",$sformatf("AXI4LITE SLAVEWRITEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveWriteAgent
`endif
