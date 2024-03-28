`ifndef AXI4LITESLAVEREADSEQITEMCONVERTER_INCLUDED_
`define AXI4LITESLAVEREADSEQITEMCONVERTER_INCLUDED_

class Axi4LiteSlaveReadSeqItemConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteSlaveReadSeqItemConverter)

  extern function new(string name = "Axi4LiteSlaveReadSeqItemConverter");
  extern static function void fromReadClass(input Axi4LiteSlaveReadTransaction input_conv_h, output axi4LiteReadTransferCharStruct output_conv_h);
  extern static function void toReadClass(input axi4LiteReadTransferCharStruct input_conv_h, output Axi4LiteSlaveReadTransaction output_conv_h);
   
  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteSlaveReadSeqItemConverter

function Axi4LiteSlaveReadSeqItemConverter::new(string name = "Axi4LiteSlaveReadSeqItemConverter");
  super.new(name);
endfunction : new

function void Axi4LiteSlaveReadSeqItemConverter::fromReadClass(input Axi4LiteSlaveReadTransaction input_conv_h,output axi4LiteReadTransferCharStruct output_conv_h);

  `uvm_info("axi4Lite_Slave_Read_Seq_item_conv_class",$sformatf("------------------------------------fromReadClass----------------------------------"),UVM_HIGH);

  output_conv_h.readDelayForReady = input_conv_h.readDelayForReady;

endfunction : fromReadClass

function void Axi4LiteSlaveReadSeqItemConverter::toReadClass(input axi4LiteReadTransferCharStruct input_conv_h, output Axi4LiteSlaveReadTransaction output_conv_h);
  `uvm_info("axi4Lite_Slave_Read_Seq_item_conv_class",$sformatf("--------------------------------------------toReadClass--------------------------"),UVM_HIGH);
 
  output_conv_h = new();
  output_conv_h.readDelayForReady = input_conv_h.readDelayForReady;

endfunction : toReadClass

function void Axi4LiteSlaveReadSeqItemConverter::do_print(uvm_printer printer);
  axi4LiteReadTransferCharStruct readCharStruct; 
  super.do_print(printer);
  printer.print_field("readDelayForReady",readCharStruct.readDelayForReady,$bits(readCharStruct.readDelayForReady),UVM_HEX);
endfunction : do_print

`endif
