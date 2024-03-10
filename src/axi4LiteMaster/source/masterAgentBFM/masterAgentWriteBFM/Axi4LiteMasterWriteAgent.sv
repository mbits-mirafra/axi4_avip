`ifndef AXI4LITEMASTERWRITEAGENT_INCLUDED_
`define AXI4LITEMASTERWRITEAGENT_INCLUDED_

module Axi4LiteMasterWriteAgent #(parameter int MASTER_ID = 0)(Axi4LiteMasterWriteInterface axi4LiteMasterWriteInterface);
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
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

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual Axi4LiteMasterWriteDriverBFM)::set(null,"*", "Axi4LiteMasterWriteDriverBFM", axi4LiteMasterWriteDriverBFM); 
    uvm_config_db#(virtual Axi4LiteMasterWriteMonitorBFM)::set(null,"*", "Axi4LiteMasterWriteMonitorBFM", axi4LiteMasterWriteMonitorBFM);
  end

  bind axi4LiteMasterWriteMonitorBFM master_assertions M_A (.aclk(aclk),
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
    `uvm_info("Axi4LiteMasterWriteAgent",$sformatf("AXI4LITE MASTERWRITEAGENTBFM"),UVM_LOW);
  end
   
endmodule : Axi4LiteMasterWriteAgent
`endif
