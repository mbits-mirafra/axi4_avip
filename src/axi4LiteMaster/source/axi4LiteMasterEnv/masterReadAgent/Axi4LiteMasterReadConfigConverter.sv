`ifndef AXI4LITEMASTERREADCONFIGCONVERTER_INCLUDED_
`define AXI4LITEMASTERREADCONFIGCONVERTER_INCLUDED_

class Axi4LiteMasterReadConfigConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterReadConfigConverter)

  extern function new(string name = "Axi4LiteMasterReadConfigConverter");
  extern static function void fromClass(input Axi4LiteMasterReadAgentConfig input_conv,output axi4LiteReadTransferCfgStruct output_conv);
 // GopalS:  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteMasterReadConfigConverter

function Axi4LiteMasterReadConfigConverter::new(string name = "Axi4LiteMasterReadConfigConverter");
  super.new(name);
endfunction : new

function void Axi4LiteMasterReadConfigConverter::fromClass(input Axi4LiteMasterReadAgentConfig input_conv, output axi4LiteReadTransferCfgStruct output_conv);
  
/*  output_conv.wait_count_write_address_channel =input_conv.wait_count_write_address_channel ;
  output_conv.wait_count_write_data_channel =input_conv.wait_count_write_data_channel ;
  output_conv.wait_count_read_address_channel =input_conv.wait_count_read_address_channel ;
  output_conv.outstanding_write_tx =input_conv.outstanding_write_tx ;
  output_conv.outstanding_read_tx =input_conv.outstanding_read_tx ;
*/
endfunction: fromClass

/*function void Axi4LiteMasterReadConfigConverter:: do_print(uvm_printer printer); 
  axi4_transfer_cfg_s axi4_cfg;
  printer.print_field ("wait_count_write_address_channel",axi4_cfg.wait_count_write_address_channel,$bits(axi4_cfg.wait_count_write_address_channel),UVM_DEC);
  printer.print_field ("wait_count_write_data_channel",axi4_cfg.wait_count_write_data_channel,$bits(axi4_cfg.wait_count_write_data_channel),UVM_DEC);
  printer.print_field ("wait_count_write_response_channel",axi4_cfg.wait_count_read_address_channel,$bits(axi4_cfg.wait_count_read_address_channel),UVM_DEC);
  printer.print_field ("outstanding_write_tx",axi4_cfg.outstanding_write_tx,$bits(axi4_cfg.outstanding_write_tx),UVM_DEC);
  printer.print_field ("outstanding_read_tx",axi4_cfg.outstanding_read_tx,$bits(axi4_cfg.outstanding_read_tx),UVM_DEC);
endfunction : do_print
*/
`endif

