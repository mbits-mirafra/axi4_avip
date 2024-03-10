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
                                                           .araddr(axi4LiteMasterReadInterface.araddr),
                                                           .arprot(axi4LiteMasterReadInterface.arprot),
                                                           .arvalid(axi4LiteMasterReadInterface.arvalid),
                                                           .arready(axi4LiteMasterReadInterface.arready),
                                                           .rdata(axi4LiteMasterReadInterface.rdata),
                                                           .rresp(axi4LiteMasterReadInterface.rresp),
                                                           .rvalid(axi4LiteMasterReadInterface.rvalid),
                                                           .rready(axi4LiteMasterReadInterface.rready) 
                                                          );

  //-------------------------------------------------------
  //Axi4LiteMasterWriteMonitorBFM instantiation
  //-------------------------------------------------------
  Axi4LiteMasterReadMonitorBFM axi4LiteMasterReadMonitorBFM (.aclk(axi4LiteMasterReadInterface.aclk),
                                                             .aresetn(axi4LiteMasterReadInterface.aresetn),
                                                             .araddr(axi4LiteMasterReadInterface.araddr),
                                                             .arprot(axi4LiteMasterReadInterface.arprot),
                                                             .arvalid(axi4LiteMasterReadInterface.arvalid),
                                                             .arready(axi4LiteMasterReadInterface.arready),
                                                             .rdata(axi4LiteMasterReadInterface.rdata),
                                                             .rresp(axi4LiteMasterReadInterface.rresp),
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
                                                           .araddr(araddr),  
                                                           .arprot(arprot),
                                                           .arvalid(arvalid), 
                                                           .arready(arready),
                                                           .rdata(rdata),
                                                           .rresp(rresp),
                                                           .rvalid(rvalid),
                                                           .rready(rready)
                                                          );


  //Printing Axi4LiteMasterReadAgent
  initial begin
    `uvm_info("Axi4LiteMasterReadAgent",$sformatf("AXI4LITE MASTERREADAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterReadAgent
`endif
