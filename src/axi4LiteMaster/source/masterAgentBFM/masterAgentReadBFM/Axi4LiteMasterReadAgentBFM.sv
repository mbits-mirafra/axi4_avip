`ifndef AXI4LITEMASTERREADAGENTBFM_INCLUDED_
`define AXI4LITEMASTERREADAGENTBFM_INCLUDED_

module Axi4LiteMasterReadAgentBFM #(parameter int ADDR_WIDTH = 32,
                                    parameter int DATA_WIDTH = 32
                                   )
                                   (input  aclk,
                                    input  aresetn,
                                    output araddr,
                                    output arprot,
                                    output arvalid,
                                    input  arready,
                                    input  rdata,
                                    output rresp,
                                    input  rvalid,
                                    output rready
                                    );
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  Axi4LiteMasterReadInterface axi4LiteMasterReadInterface();

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

   assign clk     = axi4LiteMasterReadInterface.aclk;
   assign aresetn = axi4LiteMasterReadInterface.aresetn;
   assign araddr  = axi4LiteMasterReadInterface.araddr;
   assign arprot  = axi4LiteMasterReadInterface.arprot;
   assign arvalid = axi4LiteMasterReadInterface.arvalid;
   assign arready = axi4LiteMasterReadInterface.arready;
   assign rdata   = axi4LiteMasterReadInterface.rdata;
   assign rresp   = axi4LiteMasterReadInterface.rresp;
   assign rvalid  = axi4LiteMasterReadInterface.rvalid;
   assign rready  = axi4LiteMasterReadInterface.rready;

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteMasterReadDriverBFM)::set(null,"*", "Axi4LiteMasterReadDriverBFM", axi4LiteMasterReadDriverBFM); 
    uvm_config_db#(virtual Axi4LiteMasterReadMonitorBFM)::set(null,"*", "Axi4LiteMasterReadMonitorBFM",axi4LiteMasterReadMonitorBFM);
  end

  bind axi4LiteMasterReadMonitorBFM MasterAssertions M_A (.aclk(aclk),
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
    `uvm_info("Axi4LiteMasterReadAgentBFM",$sformatf("AXI4LITE MASTERREADAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterReadAgentBFM
`endif
