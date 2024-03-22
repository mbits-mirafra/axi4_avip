`ifndef AXI4LITEASSERTIONS_INCLUDED_
`define AXI4LITEASSERTIONS_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteAssertions (input aclk,
                              input aresetn
                             );  

  import uvm_pkg::*;
  `include "uvm_macros.svh";

  initial begin
    `uvm_info("Axi4LiteAssertions","Axi4LiteAssertions",UVM_LOW);
  end

  property ifSignalsAreUnknown(logic valid, logic ready);
    @(posedge aclk)
     !aresetn |-> !($isunknown(valid) && $isunknown(ready));
  endproperty : ifSignalsAreUnknown

  property validStableUntillreadyDeasserted(logic valid, logic ready);
    @(posedge aclk) disable iff (!aresetn)  
    $rose(valid) |-> valid until_with ready;
  endproperty : validStableUntillreadyDeasserted

  property validStableCheckUpto16ClkIfreadyLow(logic valid, logic ready);
    @(posedge aclk) disable iff (!aresetn)  
    $rose(valid) |-> ##[0:15] $rose(ready);
  endproperty : validStableCheckUpto16ClkIfreadyLow

 /* property validAssertedCorrespondingDataCannotBeUnknown(logic valid, logic data);
    @(posedge aclk) disable iff (!aresetn)  
    $rose(valid) |-> !$isunknown(data);
  endproperty : validAssertedCorrespondingDataCannotBeUnknown

  property readyAssertedBeforeThevalidCorrespondingDataCanBeUnknown(logic valid, logic ready, logic data);
    @(posedge aclk) disable iff (!aresetn)  
    $rose(ready) |-> (ready && $isunknown(data)) throughout ( !$rose(valid) ##0 !$isunknown(data));
  endproperty : readyAssertedBeforeThevalidCorrespondingDataCanBeUnknown
*/
endinterface : Axi4LiteAssertions

`endif

