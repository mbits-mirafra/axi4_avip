`ifndef AXI4LITEMASTERWRITEASSERTIONS_INCLUDED_
`define AXI4LITEMASTERWRITEASSERTIONS_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteMasterWriteAssertions (input  aclk,
                                         input  aresetn,
                                         input  valid,
                                         input  ready
                                        );  

  import uvm_pkg::*;
  `include "uvm_macros.svh";

  Axi4LiteAssertions axi4LiteAssertions();

  initial begin
    `uvm_info("Axi4LiteMasterWriteAssertions","Axi4LiteMasterWriteAssertions",UVM_LOW);
  end
/*
// WRITE ADDRESS CHANNEL
  AXI4LITE_MASTERWRITE_ADDRESS_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(awvalid,awready));
  AXI4LITE_MASTERWRITE_ADDRESS_SIGNALS_CHECK_AWVALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(awvalid,awready));
  AXI4LITE_MASTERWRITE_ADDRESS_SIGNALS_CHECK_AWVALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(awvalid,awready));

// WRITE DATA CHANNEL
  AXI4LITE_MASTERWRITE_DATA_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(wvalid,wready));
  AXI4LITE_MASTERWRITE_DATA_SIGNALS_CHECK_WVALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(wvalid,wready));
  AXI4LITE_MASTERWRITE_DATA_SIGNALS_CHECK_WVALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(wvalid,wready));
//  AXI4LITE_MASTERWRITE_DATA_SIGNALS_WVALIDASSERTED_DATAISNOTUNKNOWN: assert property (axi4LiteAssertions.validAssertedCorrespondingDataCannotBeUnknown(wvalid,wready,wdata));
//  AXI4LITE_MASTERWRITE_DATA_SIGNALS_WREADYASSERTED_BEFOREWVALID_DATACANBEUNKNOWN: assert property (axi4LiteAssertions.readyAssertedBeforeThewvalidCorrespondingDataCanBeUnknown(wvalid,wready,wdata));

// WRITE RESPONSE CHANNEL
  AXI4LITE_MASTERWRITE_RESPONSE_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(bvalid,bready));
  AXI4LITE_MASTERWRITE_RESPONSE_SIGNALS_CHECK_BVALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(bvalid,bready));
  AXI4LITE_MASTERWRITE_RESPONSE_SIGNALS_CHECK_BVALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(bvalid,bready));
*/
endinterface : Axi4LiteMasterWriteAssertions

`endif

