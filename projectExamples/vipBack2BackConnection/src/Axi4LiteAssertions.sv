`ifndef AXI4LITEASSERTIONS_INCLUDED_
`define AXI4LITEASSERTIONS_INCLUDED_

interface Axi4LiteAssertions (input aclk,
                              input aresetn
                             );  

  import uvm_pkg::*;
  `include "uvm_macros.svh";

  initial begin
    `uvm_info("Axi4LiteAssertions","Axi4LiteAssertions",UVM_LOW);
  end

  property ifSignalsAreUnknown(logic valid);
    @(negedge aresetn)
     1 |-> !$isunknown(valid);
  endproperty : ifSignalsAreUnknown

  property validAssertedThenRemainsHighUntillReadyAsserted(logic valid, logic ready);
    @(posedge aclk) disable iff (!aresetn)  
    $rose(valid) |-> valid until_with ready;
  endproperty : validAssertedThenRemainsHighUntillReadyAsserted

  property validAssertedThenReadyNeedsToBeAssertedWithin16Clk(logic valid, logic ready);
    @(posedge aclk) disable iff (!aresetn)  
    $rose(valid) |-> ##[0:15] $rose(ready);
  endproperty : validAssertedThenReadyNeedsToBeAssertedWithin16Clk

/*
  property ifSignalsAreUnknown(logic valid);
    logic Valid;
    @(negedge aresetn)
     (1,Valid=valid) |-> (1,isUnknown(Valid,0));
  endproperty : ifSignalsAreUnknown

  task automatic isUnknown(ref logic Valid, input logic value);
    assert (Valid == value);
  endtask
*/
endinterface : Axi4LiteAssertions

`endif

