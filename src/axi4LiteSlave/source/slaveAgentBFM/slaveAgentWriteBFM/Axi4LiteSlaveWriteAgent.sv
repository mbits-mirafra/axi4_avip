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
                                                           .awaddr(axi4LiteSlaveWriteInterface.awaddr),
                                                           .awprot(axi4LiteSlaveWriteInterface.awprot),
                                                           .awvalid(axi4LiteSlaveWriteInterface.awvalid),
                                                           .awready(axi4LiteSlaveWriteInterface.awready),
                                                           .wdata(axi4LiteSlaveWriteInterface.wdata),
                                                           .wstrb(axi4LiteSlaveWriteInterface.wstrb),
                                                           .wvalid(axi4LiteSlaveWriteInterface.wvalid),
                                                           .wready(axi4LiteSlaveWriteInterface.wready),
                                                           .bresp(axi4LiteSlaveWriteInterface.bresp),
                                                           .bvalid(axi4LiteSlaveWriteInterface.bvalid),
                                                           .bready(axi4LiteSlaveWriteInterface.bready)
                                                          );

  //-------------------------------------------------------
  //Axi4LiteSlaveWriteMonitorBFM instantiation
  //-------------------------------------------------------
  Axi4LiteSlaveWriteMonitorBFM axi4LiteSlaveWriteMonitorBFM (.aclk(axi4LiteSlaveWriteInterface.aclk),
                                                             .aresetn(axi4LiteSlaveWriteInterface.aresetn),
                                                             .awaddr(axi4LiteSlaveWriteInterface.awaddr),
                                                             .awprot(axi4LiteSlaveWriteInterface.awprot),
                                                             .awvalid(axi4LiteSlaveWriteInterface.awvalid),
                                                             .awready(axi4LiteSlaveWriteInterface.awready),
                                                             .wdata(axi4LiteSlaveWriteInterface.wdata),
                                                             .wstrb(axi4LiteSlaveWriteInterface.wstrb),
                                                             .wvalid(axi4LiteSlaveWriteInterface.wvalid),
                                                             .wready(axi4LiteSlaveWriteInterface.wready),
                                                             .bresp(axi4LiteSlaveWriteInterface.bresp),
                                                             .bvalid(axi4LiteSlaveWriteInterface.bvalid),
                                                             .bready(axi4LiteSlaveWriteInterface.bready)
                                                            );

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteSlaveWriteDriverBFM)::set(null,"*", "Axi4LiteSlaveWriteDriverBFM", axi4LiteSlaveWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::set(null,"*", "Axi4LiteSlaveWriteMonitorBFM", axi4LiteSlaveWriteMonitorBFM);
  end

  bind axi4LiteSlaveWriteMonitorBFM slave_assertions M_A (.aclk(aclk),
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
