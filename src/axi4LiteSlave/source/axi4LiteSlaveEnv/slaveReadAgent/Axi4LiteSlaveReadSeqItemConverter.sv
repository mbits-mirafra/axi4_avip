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

endfunction : fromReadClass

function void Axi4LiteSlaveReadSeqItemConverter::toReadClass(input axi4LiteReadTransferCharStruct input_conv_h, output Axi4LiteSlaveReadTransaction output_conv_h);
  `uvm_info("axi4Lite_Slave_Read_Seq_item_conv_class",$sformatf("--------------------------------------------toReadClass--------------------------"),UVM_HIGH);
 
endfunction : toReadClass

function void Axi4LiteSlaveReadSeqItemConverter::do_print(uvm_printer printer);


//  axi4_write_transfer_char_s axi4_w_st;
//  axi4_read_transfer_char_s axi4_r_st;
  super.do_print(printer);
/*
  printer.print_field("awid",axi4_w_st.awid,$bits(axi4_w_st.awid),UVM_HEX);
  printer.print_field("awlen",axi4_w_st.awlen,$bits(axi4_w_st.awlen),UVM_HEX);
  printer.print_field("awsize",axi4_w_st.awsize,$bits(axi4_w_st.awsize),UVM_DEC);
  printer.print_field("awburst",axi4_w_st.awburst,$bits(axi4_w_st.awburst),UVM_DEC);
  printer.print_field("awlock",axi4_w_st.awlock,$bits(axi4_w_st.awlock),UVM_DEC);
  printer.print_field("awcache",axi4_w_st.awcache,$bits(axi4_w_st.awcache),UVM_DEC);
  printer.print_field("awprot",axi4_w_st.awprot,$bits(axi4_w_st.awprot),UVM_HEX);
  printer.print_field("bid",axi4_w_st.bid,$bits(axi4_w_st.bid),UVM_HEX);
 
  printer.print_field("arid",axi4_r_st.arid,$bits(axi4_r_st.arid),UVM_HEX);
  printer.print_field("arlen",axi4_r_st.arlen,$bits(axi4_r_st.arlen),UVM_HEX);
  printer.print_field("arsize",axi4_r_st.arsize,$bits(axi4_r_st.arsize),UVM_DEC);
  printer.print_field("arburst",axi4_r_st.arburst,$bits(axi4_r_st.arburst),UVM_DEC);
  printer.print_field("arlock",axi4_r_st.arlock,$bits(axi4_r_st.arlock),UVM_DEC);
  printer.print_field("arcache",axi4_r_st.arcache,$bits(axi4_r_st.arcache),UVM_DEC);
  printer.print_field("arprot",axi4_r_st.arprot,$bits(axi4_r_st.arprot),UVM_HEX);
  printer.print_field("rresp",axi4_r_st.rresp,$bits(axi4_r_st.rresp),UVM_HEX);
 
  foreach(axi4_r_st.rdata[i]) begin
    printer.print_field($sformatf("rdata[%0d]",i),axi4_r_st.rdata[i],$bits(axi4_r_st.rdata[i]),UVM_HEX);
  end
*/
endfunction : do_print

`endif
