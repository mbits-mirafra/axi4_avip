`ifndef AXI4LITESLAVEWRITESEQITEMCONVERTER_INCLUDED_
`define AXI4LITESLAVEWRITESEQITEMCONVERTER_INCLUDED_

class Axi4LiteSlaveWriteSeqItemConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteSlaveWriteSeqItemConverter)

  extern function new(string name = "Axi4LiteSlaveWriteSeqItemConverter");
  extern static function void fromWriteClass(input Axi4LiteSlaveWriteTransaction input_conv_h, output axi4LiteWriteTransferCharStruct output_conv_h);
  extern static function void toWriteClass(input axi4LiteWriteTransferCharStruct input_conv_h, output Axi4LiteSlaveWriteTransaction output_conv_h);
  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteSlaveWriteSeqItemConverter

function Axi4LiteSlaveWriteSeqItemConverter::new(string name = "Axi4LiteSlaveWriteSeqItemConverter");
  super.new(name);
endfunction : new

function void Axi4LiteSlaveWriteSeqItemConverter::fromWriteClass(input Axi4LiteSlaveWriteTransaction input_conv_h,output axi4LiteWriteTransferCharStruct output_conv_h);

  `uvm_info("axi4Lite_Slave_Write_Seq_item_conv_class",$sformatf("------------------------------------fromWriteClass----------------------------------"),UVM_HIGH);

  output_conv_h.writeDelayForReady = input_conv_h.writeDelayForReady;

endfunction : fromWriteClass

function void  Axi4LiteSlaveWriteSeqItemConverter::toWriteClass(input axi4LiteWriteTransferCharStruct input_conv_h, output Axi4LiteSlaveWriteTransaction output_conv_h);
  `uvm_info("axi4Lite_Slave_Write_Seq_item_conv_class",$sformatf("--------------------------------------------toWriteClass--------------------------"),UVM_HIGH);
 
  output_conv_h = new();
  output_conv_h.writeDelayForReady = input_conv_h.writeDelayForReady;

endfunction : toWriteClass

function void Axi4LiteSlaveWriteSeqItemConverter::do_print(uvm_printer printer);
  axi4LiteWriteTransferCharStruct writeCharStruct; 
  super.do_print(printer);
  printer.print_field("writeDelayForReady",writeCharStruct.writeDelayForReady,$bits(writeCharStruct.writeDelayForReady),UVM_HEX);
endfunction : do_print

`endif
