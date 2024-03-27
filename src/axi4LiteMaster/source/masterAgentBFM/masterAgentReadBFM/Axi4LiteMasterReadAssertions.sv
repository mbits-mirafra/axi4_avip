`ifndef AXI4LITEMASTERREADASSERTIONS_INCLUDED_
`define AXI4LITEMASTERREADASSERTIONS_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteMasterReadAssertions (input aclk,
                                        input aresetn,
                                        input valid,
                                        input	ready
                                       );  

  import uvm_pkg::*;
  `include "uvm_macros.svh";

  Axi4LiteAssertions axi4LiteAssertions();

  initial begin
    `uvm_info("Axi4LiteMasterReadAssertions","Axi4LiteMasterReadAssertions",UVM_LOW);
  end
 /* 
// READ ADDRESS CHANNEL
  AXI4LITE_MASTERREAD_ADDRESS_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(arvalid,arready));
  AXI4LITE_MASTERREAD_ADDRESS_SIGNALS_CHECK_ARVALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(arvalid,arready));
  AXI4LITE_MASTERREAD_ADDRESS_SIGNALS_CHECK_ARVALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(arvalid,arready));

// READ DATA CHANNEL
  AXI4LITE_MASTERREAD_DATA_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(rvalid,rready));
  AXI4LITE_MASTERREAD_DATA_SIGNALS_CHECK_RVALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(rvalid,rready));
  AXI4LITE_MASTERREAD_DATA_SIGNALS_CHECK_RVALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(rvalid,rready));
//  AXI4LITE_MASTERREAD_DATA_SIGNALS_RVALIDASSERTED_DATAISNOTUNKNOWN: assert property (axi4LiteAssertions.validAssertedCorrespondingDataCannotBeUnknown(rvalid,rready,rdata));
//  AXI4LITE_MASTERREAD_DATA_SIGNALS_RREADYASSERTED_BEFORERVALID_DATACANBEUNKNOWN: assert property (axi4LiteAssertions.readyAssertedBeforeThewvalidCorrespondingDataCanBeUnknown(rvalid,rready,rdata));
*/
endinterface : Axi4LiteMasterReadAssertions

`endif

