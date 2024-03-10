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
                                                         .araddr(axi4LiteSlaveReadInterface.araddr),
                                                         .arprot(axi4LiteSlaveReadInterface.arprot),
                                                         .arvalid(axi4LiteSlaveReadInterface.arvalid),
                                                         .arready(axi4LiteSlaveReadInterface.arready),
                                                         .rdata(axi4LiteSlaveReadInterface.rdata),
                                                         .rresp(axi4LiteSlaveReadInterface.rresp),
                                                         .rvalid(axi4LiteSlaveReadInterface.rvalid),
                                                         .rready(axi4LiteSlaveReadInterface.rready) 
                                                        );

  //-------------------------------------------------------
  //Axi4LiteSlaveWriteMonitorBFM instantiation
  //-------------------------------------------------------
  Axi4LiteSlaveReadMonitorBFM axi4LiteSlaveReadMonitorBFM (.aclk(axi4LiteSlaveReadInterface.aclk),
                                                           .aresetn(axi4LiteSlaveReadInterface.aresetn),
                                                           .araddr(axi4LiteSlaveReadInterface.araddr),
                                                           .arprot(axi4LiteSlaveReadInterface.arprot),
                                                           .arvalid(axi4LiteSlaveReadInterface.arvalid),
                                                           .arready(axi4LiteSlaveReadInterface.arready),
                                                           .rdata(axi4LiteSlaveReadInterface.rdata),
                                                           .rresp(axi4LiteSlaveReadInterface.rresp),
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
                                                         .araddr(araddr),  
                                                         .arprot(arprot),
                                                         .arvalid(arvalid), 
                                                         .arready(arready),
                                                         .rdata(rdata),
                                                         .rresp(rresp),
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
