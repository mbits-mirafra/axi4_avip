`ifndef AXI4LITESLAVEWRITEASSERTIONS_INCLUDED_
`define AXI4LITESLAVEWRITEASSERTIONS_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveWriteAssertions (input                     aclk,
                             input                     aresetn,
                             //Write Address Channel Signals
                             input [ADDRESS_WIDTH-1:0] awaddr,
                             input               [2:0] awprot,
                             input                     awvalid,
                             input                     awready,
                             //Write Data Channel Signals
                             input     [DATA_WIDTH-1:0] wdata,
                             input [(DATA_WIDTH/8)-1:0] wstrb,
                             input                      wvalid,
                             input                      wready,
                             //Write Response Channel
                             input [1:0] bresp,
                             input       bvalid,
                             input       bready
                            );  

  import uvm_pkg::*;
  `include "uvm_macros.svh";

  initial begin
    `uvm_info("Axi4LiteSlaveWriteAssertions","Axi4LiteSlaveWriteAssertions",UVM_LOW);
  end
  
// WRITE ADDRESS CHANNEL
  property ifWriteAddressSignalsAreUnknown;
    @(posedge aclk)
     !aresetn |-> !($isunknown(awvalid) && $isunknown(awready));
  endproperty : ifWriteAddressSignalsAreUnknown

  AXI4LITE_SLAVEWRITE_ADDRESS_SIGNALS_CHECK_IFUNKNOWN: assert property (ifWriteAddressSignalsAreUnknown);

  property writeAddressSignalawvalidStableUntillawreadyDeasserted;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(awvalid) |-> awvalid until_with awready;
  endproperty : writeAddressSignalawvalidStableUntillawreadyDeasserted

  AXI4LITE_SLAVEWRITE_ADDRESS_SIGNALS_CHECK_AWVALIDSTABLE: assert property (writeAddressSignalawvalidStableUntillawreadyDeasserted);

  property writeAddressSignalawvalidStableCheckUpto16ClkIfawreadyLow;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(awvalid) |-> ##[0:15] $rose(awready);
  endproperty : writeAddressSignalawvalidStableCheckUpto16ClkIfawreadyLow

  AXI4LITE_SLAVEWRITE_ADDRESS_SIGNALS_CHECK_AWVALIDSTABLE_UPTO16CLK: assert property (writeAddressSignalawvalidStableCheckUpto16ClkIfawreadyLow);


// WRITE DATA CHANNEL
  property ifWriteDataSignalsAreUnknown;
    @(posedge aclk)
     !aresetn |-> !($isunknown(wvalid) && $isunknown(wready));
  endproperty : ifWriteDataSignalsAreUnknown

  AXI4LITE_SLAVEWRITE_DATA_SIGNALS_CHECK_IFUNKNOWN: assert property (ifWriteDataSignalsAreUnknown);

  property WriteDataSignalwvalidStableUntillwreadyDeasserted;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(wvalid) |-> wvalid until_with wready;
  endproperty : WriteDataSignalwvalidStableUntillwreadyDeasserted

  AXI4LITE_SLAVEWRITE_DATA_SIGNALS_CHECK_WVALIDSTABLE: assert property (WriteDataSignalwvalidStableUntillwreadyDeasserted);

  property WriteDataSignalwvalidStableCheckUpto16ClkIfwreadyLow;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(wvalid) |-> ##[0:15] $rose(wready);
  endproperty : WriteDataSignalwvalidStableCheckUpto16ClkIfwreadyLow

  AXI4LITE_SLAVEWRITE_DATA_SIGNALS_CHECK_WVALIDSTABLE_UPTO16CLK: assert property (WriteDataSignalwvalidStableCheckUpto16ClkIfwreadyLow);

  property WriteDataSignalwvalidAssertedCorrespondingDataCannotBeUnknown;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(wvalid) |-> !$isunknown(wdata);
  endproperty : WriteDataSignalwvalidAssertedCorrespondingDataCannotBeUnknown

  AXI4LITE_SLAVEWRITE_DATA_SIGNALS_WVALIDASSERTED_DATAISNOTUNKNOWN: assert property (WriteDataSignalwvalidAssertedCorrespondingDataCannotBeUnknown);

  property WriteDataSignalwreadyAssertedBeforeThewvalidCorrespondingDataCanBeUnknown;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(wready) |-> (wready && $isunknown(wdata)) throughout ( !$rose(wvalid) ##0 !$isunknown(wdata));
  endproperty : WriteDataSignalwreadyAssertedBeforeThewvalidCorrespondingDataCanBeUnknown

  AXI4LITE_SLAVEWRITE_DATA_SIGNALS_WREADYASSERTED_BEFOREWVALID_DATACANBEUNKNOWN: assert property (WriteDataSignalwreadyAssertedBeforeThewvalidCorrespondingDataCanBeUnknown);

// WRITE RESPONSE CHANNEL
  property ifWriteResponseSignalsAreUnknown;
    @(posedge aclk)
     !aresetn |-> !($isunknown(bvalid) && $isunknown(bready));
  endproperty : ifWriteResponseSignalsAreUnknown

  AXI4LITE_SLAVEWRITE_RESPONSE_SIGNALS_CHECK_IFUNKNOWN: assert property (ifWriteResponseSignalsAreUnknown);

  property writeResponseSignalbvalidStableUntillbreadyDeasserted;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(bvalid) |-> bvalid until_with bready;
  endproperty : writeResponseSignalbvalidStableUntillbreadyDeasserted

  AXI4LITE_SLAVEWRITE_RESPONSE_SIGNALS_CHECK_BVALIDSTABLE: assert property (writeResponseSignalbvalidStableUntillbreadyDeasserted);

  property writeResponseSignalbvalidStableCheckUpto16ClkIfbreadyLow;
    @(posedge aclk) disable iff (!aresetn)  
    $rose(bvalid) |-> ##[0:15] $rose(bready);
  endproperty : writeResponseSignalbvalidStableCheckUpto16ClkIfbreadyLow

  AXI4LITE_SLAVEWRITE_RESPONSE_SIGNALS_CHECK_BVALIDSTABLE_UPTO16CLK: assert property (writeResponseSignalbvalidStableCheckUpto16ClkIfbreadyLow);


endinterface : Axi4LiteSlaveWriteAssertions

`endif

