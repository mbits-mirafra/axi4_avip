`ifndef AXI4LITEMASTERREADAGENT_INCLUDED_
`define AXI4LITEMASTERREADAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module:Axi4LiteMasterReadAgent 
// This module is used as the configuration class for master agent bfm and its components
//--------------------------------------------------------------------------------------------
module Axi4LiteMasterReadAgent #(parameter int MASTER_ID = 0)(Axi4LiteMasterReadInterface axi4LiteMasterReadInterface);
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Axi4LiteMasterReadDriverBFM instantiation
  //-------------------------------------------------------
  Axi4LiteMasterReadDriverBFM axi4LiteMasterReadDriverBFM (.aclk(axi4LiteMasterReadInterface.aclk), 
                                                .aresetn(axi4LiteMasterReadInterface.aresetn),
                                              /*  .awid(axi4LiteMasterReadInterface.awid),
                                                .awaddr(axi4LiteMasterReadInterface.awaddr),
                                                .awlen(axi4LiteMasterReadInterface.awlen),
                                                .awsize(axi4LiteMasterReadInterface.awsize),
                                                .awburst(axi4LiteMasterReadInterface.awburst),
                                                .awlock(axi4LiteMasterReadInterface.awlock),
                                                .awcache(axi4LiteMasterReadInterface.awcache),
                                                .awprot(axi4LiteMasterReadInterface.awprot),
                                                .awqos(axi4LiteMasterReadInterface.awqos),
                                                .awregion(axi4LiteMasterReadInterface.awregion),
                                                .awuser(axi4LiteMasterReadInterface.awuser),
                                                .awvalid(axi4LiteMasterReadInterface.awvalid),
                                                .awready(axi4LiteMasterReadInterface.awready),
                                                .wdata(axi4LiteMasterReadInterface.wdata),
                                                .wstrb(axi4LiteMasterReadInterface.wstrb),
                                                .wlast(axi4LiteMasterReadInterface.wlast),
                                                .wuser(axi4LiteMasterReadInterface.wuser),
                                                .wvalid(axi4LiteMasterReadInterface.wvalid),
                                                .wready(axi4LiteMasterReadInterface.wready),
                                                .bid(axi4LiteMasterReadInterface.bid),
                                                .bresp(axi4LiteMasterReadInterface.bresp),
                                                .buser(axi4LiteMasterReadInterface.buser),
                                                .bvalid(axi4LiteMasterReadInterface.bvalid),
                                                .bready(axi4LiteMasterReadInterface.bready),*/
                                                .arid(axi4LiteMasterReadInterface.arid),
                                                .araddr(axi4LiteMasterReadInterface.araddr),
                                                .arlen(axi4LiteMasterReadInterface.arlen),
                                                .arsize(axi4LiteMasterReadInterface.arsize),
                                                .arburst(axi4LiteMasterReadInterface.arburst),
                                                .arlock(axi4LiteMasterReadInterface.arlock),
                                                .arcache(axi4LiteMasterReadInterface.arcache),
                                                .arprot(axi4LiteMasterReadInterface.arprot),
                                                .arqos(axi4LiteMasterReadInterface.arqos),
                                                .arregion(axi4LiteMasterReadInterface.arregion),
                                                .aruser(axi4LiteMasterReadInterface.aruser),
                                                .arvalid(axi4LiteMasterReadInterface.arvalid),
                                                .arready(axi4LiteMasterReadInterface.arready),
                                                .rid(axi4LiteMasterReadInterface.rid),
                                                .rdata(axi4LiteMasterReadInterface.rdata),
                                                .rresp(axi4LiteMasterReadInterface.rresp),
                                                .rlast(axi4LiteMasterReadInterface.rlast),
                                                .ruser(axi4LiteMasterReadInterface.ruser),      
                                                .rvalid(axi4LiteMasterReadInterface.rvalid),
                                                .rready(axi4LiteMasterReadInterface.rready) 
                                                );

  //-------------------------------------------------------
  //Axi4LiteMasterWriteMonitorBFM instantiation
  //-------------------------------------------------------
  Axi4LiteMasterReadMonitorBFM axi4LiteMasterReadMonitorBFM (.aclk(axi4LiteMasterReadInterface.aclk),
                                                 .aresetn(axi4LiteMasterReadInterface.aresetn),
                                                /* .awid(axi4LiteMasterReadInterface.awid),
                                                 .awaddr(axi4LiteMasterReadInterface.awaddr),
                                                 .awlen(axi4LiteMasterReadInterface.awlen),
                                                 .awsize(axi4LiteMasterReadInterface.awsize),
                                                 .awburst(axi4LiteMasterReadInterface.awburst),
                                                 .awlock(axi4LiteMasterReadInterface.awlock),
                                                 .awcache(axi4LiteMasterReadInterface.awcache),
                                                 .awprot(axi4LiteMasterReadInterface.awprot),
                                                 .awvalid(axi4LiteMasterReadInterface.awvalid),
                                                 .awready(axi4LiteMasterReadInterface.awready),
                                                 .wdata(axi4LiteMasterReadInterface.wdata),
                                                 .wstrb(axi4LiteMasterReadInterface.wstrb),
                                                 .wlast(axi4LiteMasterReadInterface.wlast),
                                                 .wuser(axi4LiteMasterReadInterface.wuser),
                                                 .wvalid(axi4LiteMasterReadInterface.wvalid),
                                                 .wready(axi4LiteMasterReadInterface.wready),
                                                 .bid(axi4LiteMasterReadInterface.bid),
                                                 .bresp(axi4LiteMasterReadInterface.bresp),
                                                 .buser(axi4LiteMasterReadInterface.buser),
                                                 .bvalid(axi4LiteMasterReadInterface.bvalid),
                                                 .bready(axi4LiteMasterReadInterface.bready),*/
                                                 .arid(axi4LiteMasterReadInterface.arid),
                                                 .araddr(axi4LiteMasterReadInterface.araddr),
                                                 .arlen(axi4LiteMasterReadInterface.arlen),
                                                 .arsize(axi4LiteMasterReadInterface.arsize),
                                                 .arburst(axi4LiteMasterReadInterface.arburst),
                                                 .arlock(axi4LiteMasterReadInterface.arlock),
                                                 .arcache(axi4LiteMasterReadInterface.arcache),
                                                 .arprot(axi4LiteMasterReadInterface.arprot),
                                                 .arqos(axi4LiteMasterReadInterface.arqos),
                                                 .arregion(axi4LiteMasterReadInterface.arregion),
                                                 .aruser(axi4LiteMasterReadInterface.aruser),
                                                 .arvalid(axi4LiteMasterReadInterface.arvalid),
                                                 .arready(axi4LiteMasterReadInterface.arready),
                                                 .rid(axi4LiteMasterReadInterface.rid),
                                                 .rdata(axi4LiteMasterReadInterface.rdata),
                                                 .rresp(axi4LiteMasterReadInterface.rresp),
                                                 .rlast(axi4LiteMasterReadInterface.rlast),
                                                 .ruser(axi4LiteMasterReadInterface.ruser),      
                                                 .rvalid(axi4LiteMasterReadInterface.rvalid),
                                                 .rready(axi4LiteMasterReadInterface.rready)
                                                 );

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteMasterReadDriverBFM)::set(null,"*", "Axi4LiteMasterReadDriverBFM", axi4LiteMasterReadDriverBFM); 
    uvm_config_db#(virtual Axi4LiteMasterReadMonitorBFM)::set(null,"*", "Axi4LiteMasterReadMonitorBFM",axi4LiteMasterReadMonitorBFM);
  end

  bind axi4LiteMasterReadMonitorBFM master_assertions M_A (.aclk(aclk),
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


  //Printing Axi4LiteMasterReadAgent
  initial begin
    `uvm_info("Axi4LiteMasterReadAgent",$sformatf("AXI4LITE MASTERREADAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterReadAgent
`endif
