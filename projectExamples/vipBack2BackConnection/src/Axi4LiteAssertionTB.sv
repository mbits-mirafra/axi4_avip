`ifndef AXI4LITEASSERTIONTB_INCLUDED_
`define AXI4LITEASSERTIONTB_INCLUDED_

import Axi4LiteGlobalsPkg::*;

`include "uvm_macros.svh"
import uvm_pkg::*;

module Axi4LiteAssertionTB;
  bit aclk;
  bit aresetn;
  logic [ADDRESS_WIDTH-1:0]  addr;
  logic               [2:0]  prot;
  logic                      valid;
  logic                      ready;
  logic     [DATA_WIDTH-1:0] data;
  logic [(DATA_WIDTH/8)-1:0] strb;
  logic                [1:0] resp;

  
  string name = "AXI4LITE_ASSERTIONS_TB";

  initial begin
    `uvm_info(name,$sformatf("TEST_BENCH_FOR_AXI4LITE_ASSERTIONS"),UVM_LOW);
  end
/*
  Axi4LiteMasterWriteAssertions Axi4LiteMasterWriteAssertions(.aclk(aclk),
                                                              .aresetn(aresetn),
                                                              .awaddr(addr),
                                                              .awvalid(valid),
                                                              .awready(ready),
                                                              .awprot(prot),
                                                              .wdata(data),
                                                              .wstrb(strb),
                                                              .wvalid(valid),
                                                              .wready(ready),
                                                              .bresp(resp),
                                                              .bvalid(valid),
                                                              .bready(ready)
                                                            );

  Axi4LiteMasterReadAssertions Axi4LiteMasterReadAssertions(.aclk(aclk),
                                                            .aresetn(aresetn),
                                                            .araddr(addr),
                                                            .arvalid(valid),
                                                            .arready(ready),
                                                            .arprot(prot),
                                                            .rdata(data),
                                                            .rvalid(valid),
                                                            .rready(ready),
                                                            .rresp(resp)
                                                           );

  Axi4LiteSlaveWriteAssertions Axi4LiteSlaveWriteAssertions(.aclk(aclk),
                                                            .aresetn(aresetn),
                                                            .awaddr(addr),
                                                            .awvalid(valid),
                                                            .awready(ready),
                                                            .awprot(prot),
                                                            .wdata(data),
                                                            .wstrb(strb),
                                                            .wvalid(valid),
                                                            .wready(ready),
                                                            .bresp(resp),
                                                            .bvalid(valid),
                                                            .bready(ready)
                                                           );

  Axi4LiteSlaveReadAssertions Axi4LiteSlaveReadAssertions(.aclk(aclk),
                                                          .aresetn(aresetn),
                                                          .araddr(addr),
                                                          .arvalid(valid),
                                                          .arready(ready),
                                                          .arprot(prot),
                                                          .rdata(data),
                                                          .rvalid(valid),
                                                          .rready(ready),
                                                          .rresp(resp)
                                                         );
*/
  always #10 aclk = ~aclk;

  task aresetn_gen();
    aresetn = 1'b0;
    repeat(1) begin
      @(posedge aclk); 
    end
    aresetn = 1'b1;
    `uvm_info(name,$sformatf("Generating_aresetn"),UVM_HIGH);
  endtask : aresetn_gen

  
  Axi4LiteAssertions axi4LiteAssertions(.aclk(aclk),
                                        .aresetn(aresetn)
                                       );

  initial begin
    whenAresetnIsAssertedThenValidWillNotBeUnknown();
    validOnceAssertedThenRemainsHighTillReadyAsserted();
    validIsAssertedThenReadyNeedsToBeAssertedWithin16ClockCycles();
  end

  AXI4LITE_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(valid,ready));
  AXI4LITE_SIGNALS_CHECK_VALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(valid,ready));
  AXI4LITE_SIGNALS_CHECK_VALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(valid,ready));

  task whenAresetnIsAssertedThenValidWillNotBeUnknown();
    `uvm_info(name,$sformatf("whenAresetnIsAssertedThenValidWillNotBeUnknown Task started"),UVM_HIGH);
    //Calling task aresetn_gen()
    aresetn_gen();
    
    repeat(6) begin
      @(posedge aclk);
      valid <= 1'bx;
      ready <= 1'bx;
  
      repeat(2) begin
        @(posedge aclk);
      end
      aresetn <= 1'b0;

      repeat(3) begin
        @(posedge aclk);
      end
      aresetn <= 1'b1;

      repeat(4) begin
        @(posedge aclk);
      end
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;

      @(posedge aclk);
      aresetn <= 1'b1;

      `uvm_info(name,$sformatf("whenAresetnIsAssertedThenValidWillNotBeUnknown::INSIDE WHILE LOOP"),UVM_HIGH);
    end
    `uvm_info(name,$sformatf("whenAresetnIsAssertedThenValidWillNotBeUnknown Task Ended"),UVM_HIGH);
  endtask

  task validOnceAssertedThenRemainsHighTillReadyAsserted();
    //Calling task aresetn_gen()
    aresetn_gen();
    
    repeat(6) begin

      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
  
      repeat(1) begin
        @(posedge aclk);
      end
      valid <= 1'b1;

      repeat(3) begin
        @(posedge aclk);
      end
      ready <= 1'b1;

      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;

      repeat(2) begin
        @(posedge aclk);
      end
      valid <= 1'b1;

      repeat(3) begin
        @(posedge aclk);
      end
      valid <= 1'b0;

      repeat(1) begin
        @(posedge aclk);
      end
      ready <= 1'b1;

      `uvm_info(name,$sformatf("validOnceAssertedThenRemainsHighTillReadyAsserted::INSIDE WHILE LOOP"),UVM_HIGH);
    end
  endtask

  task validIsAssertedThenReadyNeedsToBeAssertedWithin16ClockCycles();
    //Calling task aresetn_gen()
    aresetn_gen();
    
    repeat(6) begin

      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
  
      repeat(1) begin
        @(posedge aclk);
      end
      valid <= 1'b1;

      repeat(4) begin
        @(posedge aclk);
      end
      ready <= 1'b1;

      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;

      repeat(1) begin
        @(posedge aclk);
      end
      valid <= 1'b1;

      repeat(17) begin
        @(posedge aclk);
      end
      ready <= 1'b1;

      `uvm_info(name,$sformatf("validIsAssertedThenReadyNeedsToBeAssertedWithin16ClockCycles::INSIDE WHILE LOOP"),UVM_HIGH);
    end
  endtask

  task validIsAssertedThenSignalsRemainsStableUntilReadyGetAsserted();
    //Calling task aresetn_gen()
    aresetn_gen();
    
    repeat(6) begin

      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
  
      repeat(1) begin
        @(posedge aclk);
      end
      valid <= 1'b1;

      repeat(4) begin
        @(posedge aclk);
      end
      ready <= 1'b1;

      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;

      @(posedge aclk);
      valid <= 1'b1;

      repeat(2) begin
        @(posedge aclk);
      end
      valid <= 1'b0;

      repeat(3) begin
        @(posedge aclk);
      end
      ready <= 1'b1;

      `uvm_info(name,$sformatf("validIsAssertedThenSignalsRemainsStableUntilReadyGetAsserted::INSIDE WHILE LOOP"),UVM_HIGH);
    end
  endtask

endmodule : Axi4LiteAssertionTB

`endif

