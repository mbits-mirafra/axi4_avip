`ifndef AXI4LITESLAVEREADASSERTIONS_INCLUDED_
`define AXI4LITESLAVEREADASSERTIONS_INCLUDED_

import Axi4LiteGlobalsPkg::*;

interface Axi4LiteSlaveReadAssertions (input                     aclk,
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

  Axi4LiteAssertions axi4LiteAssertions();

  initial begin
    `uvm_info("Axi4LiteSlaveReadAssertions","Axi4LiteSlaveReadAssertions",UVM_LOW);
  end
  
// READ ADDRESS CHANNEL
  AXI4LITE_SLAVEREAD_ADDRESS_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(arvalid,arready));
  AXI4LITE_SLAVEREAD_ADDRESS_SIGNALS_CHECK_ARVALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(arvalid,arready));
  AXI4LITE_SLAVEREAD_ADDRESS_SIGNALS_CHECK_ARVALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(arvalid,arready));

// READ DATA CHANNEL
  AXI4LITE_SLAVEREAD_DATA_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(rvalid,rready));
  AXI4LITE_SLAVEREAD_DATA_SIGNALS_CHECK_RVALIDSTABLE: assert property (axi4LiteAssertions.validStableUntillreadyDeasserted(rvalid,rready));
  AXI4LITE_SLAVEREAD_DATA_SIGNALS_CHECK_RVALIDSTABLE_UPTO16CLK: assert property (axi4LiteAssertions.validStableCheckUpto16ClkIfreadyLow(rvalid,rready));
//  AXI4LITE_SLAVEREAD_DATA_SIGNALS_RVALIDASSERTED_DATAISNOTUNKNOWN: assert property (axi4LiteAssertions.validAssertedCorrespondingDataCannotBeUnknown(rvalid,rready,rdata));
//  AXI4LITE_SLAVEREAD_DATA_SIGNALS_RREADYASSERTED_BEFORERVALID_DATACANBEUNKNOWN: assert property (axi4LiteAssertions.readyAssertedBeforeThewvalidCorrespondingDataCanBeUnknown(rvalid,rready,rdata));

endinterface : Axi4LiteSlaveReadAssertions

`endif

