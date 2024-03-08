`ifndef HDLTOP_INCLUDED_
`define HDLTOP_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module      : HDL Top
// Description : Has a interface master and slave agent bfm.
//--------------------------------------------------------------------------------------------

module HdlTop;

  import uvm_pkg::*;
  import Axi4LiteGlobalsPkg::*;
  `include "uvm_macros.svh"

  //-------------------------------------------------------
  // Clock Reset Initialization
  //-------------------------------------------------------
  bit aclk;
  bit aresetn;

  //-------------------------------------------------------
  // Display statement for HDL_TOP
  //-------------------------------------------------------
  initial begin
    $display("HDL_TOP");
  end

  //-------------------------------------------------------
  // System Clock Generation
  //-------------------------------------------------------
  initial begin
    aclk = 1'b0;
    forever #10 aclk = ~aclk;
  end

  //-------------------------------------------------------
  // System Reset Generation
  // Active low reset
  //-------------------------------------------------------
  initial begin
    aresetn = 1'b1;
    #10 aresetn = 1'b0;

    repeat (1) begin
      @(posedge aclk);
    end
    aresetn = 1'b1;
  end

  // Variable : intf
  // axi4 Interface Instantiation
  Axi4LiteMasterInterface masterIntf(.aclk(aclk),
                               .aresetn(aresetn));

  Axi4LiteSlaveInterface slaveIntf(.aclk(aclk),
                               .aresetn(aresetn));
  //-------------------------------------------------------
  // AXI4  No of Master and Slaves Agent Instantiation
  //-------------------------------------------------------
  genvar i;
  generate
    for (i=0; i<NO_OF_MASTERS; i++) begin : Axi4LiteMasterAgentBFM
      Axi4LiteMasterAgentBFM #(.MASTER_ID(i)) axi4LiteMasterAgentBFM(masterIntf);
      defparam Axi4LiteMasterAgentBFM[i].axi4LiteMasterAgentBFM.MASTER_ID = i;
    end
    for (i=0; i<NO_OF_SLAVES; i++) begin : Axi4LiteSlaveAgentBFM
      Axi4LiteSlaveAgentBFM #(.SLAVE_ID(i)) axi4LiteSlaveAgentBFM(slaveIntf);
      defparam Axi4LiteSlaveAgentBFM[i].axi4LiteSlaveAgentBFM.SLAVE_ID = i;
    end
  endgenerate
  
endmodule : HdlTop

`endif

