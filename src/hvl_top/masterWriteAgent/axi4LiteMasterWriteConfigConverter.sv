`ifndef AXI4LITEMASTERWRITECONFIGCONVERTER_INCLUDED_
`define AXI4LITEMASTERWRITECONFIGCONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Description:
// class for converting the transaction items to struct and vice versa
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterWriteConfigConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterWriteConfigConverter)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteMasterWriteConfigConverter");
 // GopalS:  extern static function void from_class(input axi4_master_agent_config input_conv,output axi4_transfer_cfg_s output_conv);
 // GopalS:  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteMasterWriteConfigConverter

function Axi4LiteMasterWriteConfigConverter::new(string name = "Axi4LiteMasterWriteConfigConverter");
  super.new(name);
endfunction : new
/*
//--------------------------------------------------------------------------------------------
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterWriteConfigConverter::from_class(input axi4_master_agent_config input_conv, output axi4_transfer_cfg_s output_conv);
  output_conv.wait_count_write_address_channel =input_conv.wait_count_write_address_channel ;
  output_conv.wait_count_write_data_channel =input_conv.wait_count_write_data_channel ;
  output_conv.wait_count_read_address_channel =input_conv.wait_count_read_address_channel ;
  output_conv.outstanding_write_tx =input_conv.outstanding_write_tx ;
  output_conv.outstanding_read_tx =input_conv.outstanding_read_tx ;
endfunction: from_class

//--------------------------------------------------------------------------------------------
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterWriteConfigConverter:: do_print(uvm_printer printer); 
  axi4_transfer_cfg_s axi4_cfg;
  printer.print_field ("wait_count_write_address_channel",axi4_cfg.wait_count_write_address_channel,$bits(axi4_cfg.wait_count_write_address_channel),UVM_DEC);
  printer.print_field ("wait_count_write_data_channel",axi4_cfg.wait_count_write_data_channel,$bits(axi4_cfg.wait_count_write_data_channel),UVM_DEC);
  printer.print_field ("wait_count_write_response_channel",axi4_cfg.wait_count_read_address_channel,$bits(axi4_cfg.wait_count_read_address_channel),UVM_DEC);
  printer.print_field ("outstanding_write_tx",axi4_cfg.outstanding_write_tx,$bits(axi4_cfg.outstanding_write_tx),UVM_DEC);
  printer.print_field ("outstanding_read_tx",axi4_cfg.outstanding_read_tx,$bits(axi4_cfg.outstanding_read_tx),UVM_DEC);
endfunction : do_print
*/
`endif

