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
 
/*
  
  initial begin 
    #45;
    repeat(2) begin 
     repeat(1) @(posedge intf.aclk);
       randomize(wr_trn_en) with{wr_trn_en== 1;};
       randomize(rd_trn_en) with{rd_trn_en== 0;};
       randomize(TXN_ID_W_dec);
       randomize(AWADDR_dec) with{AWADDR_dec inside {100,180,260};};
       randomize(AWBURST_dec) with {AWBURST_dec == 1;};
       randomize(AWLEN_dec) with{AWLEN_dec == 10;};
       randomize(AWSIZE_dec) with{AWSIZE_dec == 2;};
       randomize(WSTRB_dec) with{$countones(WSTRB_dec)== 2**AWSIZE_dec;};  
       wait(intf.wvalid ==1);
       $display("GOT IT");   
       repeat(AWLEN_dec+1) begin 
         @(negedge intf.aclk);
           
            randomize(WDATA_dec) with{WDATA_dec inside {[64'h a1234568a1232288 : 64'h b246288474893039]};};
          wait(intf.wready == 1);
       end    
      wait(dut1.axi_ns == 6);
      @(negedge intf.aclk);
      $display("HEY RANDOMIZED AT %0t",$time());
       randomize(TXN_ID_R_dec)  with{TXN_ID_R_dec == 10;};
       randomize(wr_trn_en) with{wr_trn_en== 0;}; 
       randomize(rd_trn_en) with{rd_trn_en== 1;};
       randomize(ARADDR_dec) with {ARADDR_dec == AWADDR_dec;};
       randomize(ARBURST_dec) with { ARBURST_dec== AWBURST_dec;};

       randomize(ARLEN_dec)with{ARLEN_dec == AWLEN_dec;}; 

       randomize(ARSIZE_dec) with{ARSIZE_dec == AWSIZE_dec;};
        wait(dut1.axi_ns == 5);
        wait(dut1.axi_ns == 6); 
            @(negedge intf.aclk);
       randomize(rd_trn_en) with{rd_trn_en== 0;};
      
   end 
  end 

*/

endmodule : hdl_top

`endif

