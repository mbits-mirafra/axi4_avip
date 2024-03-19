`ifndef AXI4LITEMASTERREADASSERTIONS_INCLUDED_
`define AXI4LITEMASTERREADASSERTIONS_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteMasterReadAssertions (input                     aclk,
                             input                     aresetn,
                             //Read Address Channel Signals
                             input [ADDRESS_WIDTH-1:0] araddr,  
                             input               [2:0] arprot,     
                             input                     arvalid,
                             input	                   arready,
                             //Read Data Channel Signals
                             input [DATA_WIDTH-1:0] rdata,
                             input            [1:0] rresp,
                             input                  rvalid,
                             input                  rready  
                            );  

  import uvm_pkg::*;
  `include "uvm_macros.svh";

  initial begin
    `uvm_info("Axi4LiteMasterReadAssertions","Axi4LiteMasterReadAssertions",UVM_LOW);
  end
  
// READ ADDRESS CHANNEL
  property ifReadAddressSignalsAreUnknown;
    @(posedge aclk)
     !aresetn |-> !($isunknown(arvalid) && $isunknown(arready));
  endproperty : ifReadAddressSignalsAreUnknown

  AXI4LITE_MASTERREAD_ADDRESS_SIGNALS_CHECK_IFUNKNOWN: assert property (ifReadAddressSignalsAreUnknown);

  property readAddressSignalarvalidStableUntillarreadyDeasserted;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(arvalid) |-> arvalid until_with arready;
  endproperty : readAddressSignalarvalidStableUntillarreadyDeasserted

  AXI4LITE_MASTERREAD_ADDRESS_SIGNALS_CHECK_ARVALIDSTABLE: assert property (readAddressSignalarvalidStableUntillarreadyDeasserted);

  property readAddressSignalarvalidStableCheckUpto16ClkIfarreadyLow;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(arvalid) |-> ##[0:15] $rose(arready);
  endproperty : readAddressSignalarvalidStableCheckUpto16ClkIfarreadyLow

  AXI4LITE_MASTERREAD_ADDRESS_SIGNALS_CHECK_ARVALIDSTABLE_UPTO16CLK: assert property (readAddressSignalarvalidStableCheckUpto16ClkIfarreadyLow);


// READ DATA CHANNEL
  property ifReadDataSignalsAreUnknown;
    @(posedge aclk)
     !aresetn |-> !($isunknown(rvalid) && $isunknown(rready));
  endproperty : ifReadDataSignalsAreUnknown

  AXI4LITE_MASTERREAD_DATA_SIGNALS_CHECK_IFUNKNOWN: assert property (ifReadDataSignalsAreUnknown);

  property readDataSignalrvalidStableUntillrreadyDeasserted;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(rvalid) |-> rvalid until_with rready;
  endproperty : readDataSignalrvalidStableUntillrreadyDeasserted

  AXI4LITE_MASTERREAD_DATA_SIGNALS_CHECK_RVALIDSTABLE: assert property (readDataSignalrvalidStableUntillrreadyDeasserted);

  property readDataSignalrvalidStableCheckUpto16ClkIfrreadyLow;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(rvalid) |-> ##[0:15] $rose(rready);
  endproperty : readDataSignalrvalidStableCheckUpto16ClkIfrreadyLow

  AXI4LITE_MASTERREAD_DATA_SIGNALS_CHECK_RVALIDSTABLE_UPTO16CLK: assert property (readDataSignalrvalidStableCheckUpto16ClkIfrreadyLow);

  property readDataSignalrvalidAssertedCorrespondingDataCannotBeUnknown;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(rvalid) |-> !$isunknown(rdata);
  endproperty : readDataSignalrvalidAssertedCorrespondingDataCannotBeUnknown

  AXI4LITE_MASTERREAD_DATA_SIGNALS_RVALIDASSERTED_DATAISNOTUNKNOWN: assert property (readDataSignalrvalidAssertedCorrespondingDataCannotBeUnknown);

  property readDataSignalrreadyAssertedBeforeThervalidCorrespondingDataCanBeUnknown;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(rready) |-> (rready && $isunknown(rdata)) throughout ( !$rose(rvalid) ##0 !$isunknown(rdata));
  endproperty : readDataSignalrreadyAssertedBeforeThervalidCorrespondingDataCanBeUnknown

  AXI4LITE_MASTERREAD_DATA_SIGNALS_RREADYASSERTED_BEFORERVALID_DATACANBEUNKNOWN: assert property (readDataSignalrreadyAssertedBeforeThervalidCorrespondingDataCanBeUnknown);

endinterface : Axi4LiteMasterReadAssertions

`endif

