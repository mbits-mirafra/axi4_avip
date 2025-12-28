`ifndef AXI4_MASTER_CFG_CONVERTER_INCLUDED_
`define AXI4_MASTER_CFG_CONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_master_cfg_converter
// Description:
// class for converting the transaction items to struct and vice versa                                                          
//--------------------------------------------------------------------------------------------
class axi4_master_cfg_converter extends uvm_object;
  `uvm_object_utils(axi4_master_cfg_converter)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_cfg_converter");
  extern static function void from_class(input axi4_master_agent_config input_conv,output axi4_transfer_cfg_s output_conv);
  extern function void do_print(uvm_printer printer);

endclass : axi4_master_cfg_converter

//--------------------------------------------------------------------------------------------
// Construct: new
// Parameters:
// name - axi4_master_cfg_converter
//--------------------------------------------------------------------------------------------
function axi4_master_cfg_converter::new(string name = "axi4_master_cfg_converter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: from_write_class
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void axi4_master_cfg_converter::from_class(input axi4_master_agent_config input_conv, output axi4_transfer_cfg_s output_conv);
  output_conv.wait_count_write_address_channel =input_conv.wait_count_write_address_channel ;
  output_conv.wait_count_write_data_channel =input_conv.wait_count_write_data_channel ;
  output_conv.wait_count_read_address_channel =input_conv.wait_count_read_address_channel ;
  output_conv.outstanding_write_tx =input_conv.outstanding_write_tx ;
  output_conv.outstanding_read_tx =input_conv.outstanding_read_tx ;
endfunction: from_class

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void axi4_master_cfg_converter:: do_print(uvm_printer printer); 
  axi4_transfer_cfg_s axi4_cfg;
  printer.print_field ("wait_count_write_address_channel",axi4_cfg.wait_count_write_address_channel,$bits(axi4_cfg.wait_count_write_address_channel),UVM_DEC);
  printer.print_field ("wait_count_write_data_channel",axi4_cfg.wait_count_write_data_channel,$bits(axi4_cfg.wait_count_write_data_channel),UVM_DEC);
  printer.print_field ("wait_count_write_response_channel",axi4_cfg.wait_count_read_address_channel,$bits(axi4_cfg.wait_count_read_address_channel),UVM_DEC);
  printer.print_field ("outstanding_write_tx",axi4_cfg.outstanding_write_tx,$bits(axi4_cfg.outstanding_write_tx),UVM_DEC);
  printer.print_field ("outstanding_read_tx",axi4_cfg.outstanding_read_tx,$bits(axi4_cfg.outstanding_read_tx),UVM_DEC);
endfunction : do_print

`endif

