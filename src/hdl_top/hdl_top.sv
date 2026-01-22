`ifndef HDL_TOP_INCLUDED_
`define HDL_TOP_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module      : HDL Top
// Description : Has a interface master and slave agent bfm.
//--------------------------------------------------------------------------------------------

module hdl_top;

  import uvm_pkg::*;
  import axi4_globals_pkg::*;
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


  //decoder signals 

    logic               [3:0] TXN_ID_W_dec;
    logic               [31:0] AWADDR_dec;
    logic               [1:0] AWBURST_dec;
    logic               [3:0] AWLEN_dec;  //len can go till 255
    logic               [2:0] AWSIZE_dec;
    logic               [1:0] AWLOCK_dec;
    logic               [3:0] AWCACHE_dec;
    logic               [2:0] AWPROT_dec;
    logic               [63:0] WDATA_dec;
    logic               [3:0] WSTRB_dec; // 4 bits not sufficient for strobe 
    logic               [3:0] TXN_ID_R_dec;
    logic               [31:0] ARADDR_dec;
    logic               [1:0] ARBURST_dec;
    logic               [2:0] ARSIZE_dec;
    logic               [3:0] ARLEN_dec;
    logic               [1:0] ARLOCK_dec;
    logic               [2:0] ARCACHE_dec;
    logic               [2:0] ARPROT_dec;
    logic       wr_trn_en;
    logic       rd_trn_en;

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
  
  initial begin
    $dumpfile("waveform.vcd");      // name of the VCD file
    $dumpvars(0, hdl_top);    // dump variables from the testbench top
  end
  // Variable : intf
  // axi4 Interface Instantiation
  axi4_if intf(.aclk(aclk),
               .aresetn(aresetn));

 
  // AXI4  No of Master and Slaves Agent Instantiation
  //-------------------------------------------------------
  genvar i;
  generate
  
    for (i=0; i<NO_OF_MASTERS; i++) begin : axi4_master_agent_bfm
      axi4_master_agent_bfm #(.MASTER_ID(i)) axi4_master_agent_bfm_h(intf);
      defparam axi4_master_agent_bfm[i].axi4_master_agent_bfm_h.MASTER_ID = i;
    end
  

    for (i=0; i<NO_OF_SLAVES; i++) begin : axi4_slave_agent_bfm
      axi4_slave_agent_bfm #(.SLAVE_ID(i)) axi4_slave_agent_bfm_h(intf);
      defparam axi4_slave_agent_bfm[i].axi4_slave_agent_bfm_h.SLAVE_ID = i;
    end
  endgenerate
 

endmodule : hdl_top

`endif

