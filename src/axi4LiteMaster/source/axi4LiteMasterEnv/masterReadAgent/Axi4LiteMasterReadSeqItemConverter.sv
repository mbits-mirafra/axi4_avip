`ifndef AXI4LITEMASTERREADSEQITEMCONVERTER_INCLUDED_
`define AXI4LITEMASTERREADSEQITEMCONVERTER_INCLUDED_

class Axi4LiteMasterReadSeqItemConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterReadSeqItemConverter)
  
  extern function new(string name = "Axi4LiteMasterReadSeqItemConverter");
  extern static function void fromReadClass(input Axi4LiteMasterReadTransaction input_conv_h,output axi4LiteReadTransferCharStruct output_conv_h);
 extern static function void toReadClass(input axi4LiteReadTransferCharStruct input_conv_h,output Axi4LiteMasterReadTransaction output_conv_h);
endclass : Axi4LiteMasterReadSeqItemConverter

function Axi4LiteMasterReadSeqItemConverter::new(string name = "Axi4LiteMasterReadSeqItemConverter");
  super.new(name);
endfunction : new

function void Axi4LiteMasterReadSeqItemConverter::fromReadClass( input Axi4LiteMasterReadTransaction input_conv_h,output axi4LiteReadTransferCharStruct output_conv_h);

  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
  
endfunction : fromReadClass 

function void Axi4LiteMasterReadSeqItemConverter::toReadClass( input axi4LiteReadTransferCharStruct
  input_conv_h, output Axi4LiteMasterReadTransaction output_conv_h);

  output_conv_h = new();
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
endfunction : toReadClass

/*
function void Axi4LiteMasterReadSeqItemConverter::do_print(uvm_printer printer);

  axi4_write_transfer_char_s axi4_w_st;
  axi4_read_transfer_char_s axi4_r_st;
  super.do_print(printer);
endfunction : do_print
*/
`endif
