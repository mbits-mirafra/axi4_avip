`ifndef AXI4LITESLAVEREADAGENT_INCLUDED_
`define AXI4LITESLAVEREADAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module:Axi4LiteSlaveReadAgent 
// This module is used as the configuration class for Slave agent bfm and its components
//--------------------------------------------------------------------------------------------
module Axi4LiteSlaveReadAgent #(parameter int Slave_ID = 0)(Axi4LiteSlaveReadInterface axi4LiteSlaveReadInterface);
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Axi4LiteSlaveReadDriverBFM instantiation
  //-------------------------------------------------------
  Axi4LiteSlaveReadDriverBFM axi4LiteSlaveReadDriverBFM (.aclk(axi4LiteSlaveReadInterface.aclk), 
                                                .aresetn(axi4LiteSlaveReadInterface.aresetn),
                                              /*  .awid(axi4LiteSlaveReadInterface.awid),
                                                .awaddr(axi4LiteSlaveReadInterface.awaddr),
                                                .awlen(axi4LiteSlaveReadInterface.awlen),
                                                .awsize(axi4LiteSlaveReadInterface.awsize),
                                                .awburst(axi4LiteSlaveReadInterface.awburst),
                                                .awlock(axi4LiteSlaveReadInterface.awlock),
                                                .awcache(axi4LiteSlaveReadInterface.awcache),
                                                .awprot(axi4LiteSlaveReadInterface.awprot),
                                                .awqos(axi4LiteSlaveReadInterface.awqos),
                                                .awregion(axi4LiteSlaveReadInterface.awregion),
                                                .awuser(axi4LiteSlaveReadInterface.awuser),
                                                .awvalid(axi4LiteSlaveReadInterface.awvalid),
                                                .awready(axi4LiteSlaveReadInterface.awready),
                                                .wdata(axi4LiteSlaveReadInterface.wdata),
                                                .wstrb(axi4LiteSlaveReadInterface.wstrb),
                                                .wlast(axi4LiteSlaveReadInterface.wlast),
                                                .wuser(axi4LiteSlaveReadInterface.wuser),
                                                .wvalid(axi4LiteSlaveReadInterface.wvalid),
                                                .wready(axi4LiteSlaveReadInterface.wready),
                                                .bid(axi4LiteSlaveReadInterface.bid),
                                                .bresp(axi4LiteSlaveReadInterface.bresp),
                                                .buser(axi4LiteSlaveReadInterface.buser),
                                                .bvalid(axi4LiteSlaveReadInterface.bvalid),
                                                .bready(axi4LiteSlaveReadInterface.bready),*/
                                                .arid(axi4LiteSlaveReadInterface.arid),
                                                .araddr(axi4LiteSlaveReadInterface.araddr),
                                                .arlen(axi4LiteSlaveReadInterface.arlen),
                                                .arsize(axi4LiteSlaveReadInterface.arsize),
                                                .arburst(axi4LiteSlaveReadInterface.arburst),
                                                .arlock(axi4LiteSlaveReadInterface.arlock),
                                                .arcache(axi4LiteSlaveReadInterface.arcache),
                                                .arprot(axi4LiteSlaveReadInterface.arprot),
                                                .arqos(axi4LiteSlaveReadInterface.arqos),
                                                .arregion(axi4LiteSlaveReadInterface.arregion),
                                                .aruser(axi4LiteSlaveReadInterface.aruser),
                                                .arvalid(axi4LiteSlaveReadInterface.arvalid),
                                                .arready(axi4LiteSlaveReadInterface.arready),
                                                .rid(axi4LiteSlaveReadInterface.rid),
                                                .rdata(axi4LiteSlaveReadInterface.rdata),
                                                .rresp(axi4LiteSlaveReadInterface.rresp),
                                                .rlast(axi4LiteSlaveReadInterface.rlast),
                                                .ruser(axi4LiteSlaveReadInterface.ruser),      
                                                .rvalid(axi4LiteSlaveReadInterface.rvalid),
                                                .rready(axi4LiteSlaveReadInterface.rready) 
                                                );

  //-------------------------------------------------------
  //Axi4LiteSlaveWriteMonitorBFM instantiation
  //-------------------------------------------------------
  Axi4LiteSlaveReadMonitorBFM axi4LiteSlaveReadMonitorBFM (.aclk(axi4LiteSlaveReadInterface.aclk),
                                                 .aresetn(axi4LiteSlaveReadInterface.aresetn),
                                                /* .awid(axi4LiteSlaveReadInterface.awid),
                                                 .awaddr(axi4LiteSlaveReadInterface.awaddr),
                                                 .awlen(axi4LiteSlaveReadInterface.awlen),
                                                 .awsize(axi4LiteSlaveReadInterface.awsize),
                                                 .awburst(axi4LiteSlaveReadInterface.awburst),
                                                 .awlock(axi4LiteSlaveReadInterface.awlock),
                                                 .awcache(axi4LiteSlaveReadInterface.awcache),
                                                 .awprot(axi4LiteSlaveReadInterface.awprot),
                                                 .awvalid(axi4LiteSlaveReadInterface.awvalid),
                                                 .awready(axi4LiteSlaveReadInterface.awready),
                                                 .wdata(axi4LiteSlaveReadInterface.wdata),
                                                 .wstrb(axi4LiteSlaveReadInterface.wstrb),
                                                 .wlast(axi4LiteSlaveReadInterface.wlast),
                                                 .wuser(axi4LiteSlaveReadInterface.wuser),
                                                 .wvalid(axi4LiteSlaveReadInterface.wvalid),
                                                 .wready(axi4LiteSlaveReadInterface.wready),
                                                 .bid(axi4LiteSlaveReadInterface.bid),
                                                 .bresp(axi4LiteSlaveReadInterface.bresp),
                                                 .buser(axi4LiteSlaveReadInterface.buser),
                                                 .bvalid(axi4LiteSlaveReadInterface.bvalid),
                                                 .bready(axi4LiteSlaveReadInterface.bready),*/
                                                 .arid(axi4LiteSlaveReadInterface.arid),
                                                 .araddr(axi4LiteSlaveReadInterface.araddr),
                                                 .arlen(axi4LiteSlaveReadInterface.arlen),
                                                 .arsize(axi4LiteSlaveReadInterface.arsize),
                                                 .arburst(axi4LiteSlaveReadInterface.arburst),
                                                 .arlock(axi4LiteSlaveReadInterface.arlock),
                                                 .arcache(axi4LiteSlaveReadInterface.arcache),
                                                 .arprot(axi4LiteSlaveReadInterface.arprot),
                                                 .arqos(axi4LiteSlaveReadInterface.arqos),
                                                 .arregion(axi4LiteSlaveReadInterface.arregion),
                                                 .aruser(axi4LiteSlaveReadInterface.aruser),
                                                 .arvalid(axi4LiteSlaveReadInterface.arvalid),
                                                 .arready(axi4LiteSlaveReadInterface.arready),
                                                 .rid(axi4LiteSlaveReadInterface.rid),
                                                 .rdata(axi4LiteSlaveReadInterface.rdata),
                                                 .rresp(axi4LiteSlaveReadInterface.rresp),
                                                 .rlast(axi4LiteSlaveReadInterface.rlast),
                                                 .ruser(axi4LiteSlaveReadInterface.ruser),      
                                                 .rvalid(axi4LiteSlaveReadInterface.rvalid),
                                                 .rready(axi4LiteSlaveReadInterface.rready)
                                                 );

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveReadDriverBFM)::set(null,"*", "Axi4LiteSlaveReadDriverBFM", axi4LiteSlaveReadDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveReadMonitorBFM)::set(null,"*", "Axi4LiteSlaveReadMonitorBFM",axi4LiteSlaveReadMonitorBFM);
  end

  bind axi4LiteSlaveReadMonitorBFM Slave_assertions M_A (.aclk(aclk),
                                                      .aresetn(aresetn),
                                                     /* .awid(awid),
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
                                                      .bresp(bresp),*/
                                                      .arid(arid),
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
                                                      );


  initial begin
   uvm_config_db#(virtual Axi4LiteSlaveReadDriverBFM)::set(null,"*", "Axi4LiteSlaveReadDriverBFM", axi4LiteSlaveReadDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveReadMonitorBFM)::set(null,"*", "Axi4LiteSlaveReadMonitorBFM", axi4LiteSlaveReadMonitorBFM);
  end
  //Printing Axi4LiteSlaveReadAgent
  initial begin
    `uvm_info("Axi4LiteSlaveReadAgent",$sformatf("AXI4LITE SlaveREADAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteSlaveReadAgent
`endif
