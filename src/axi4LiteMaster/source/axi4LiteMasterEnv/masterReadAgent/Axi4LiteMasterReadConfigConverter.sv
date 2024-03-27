`ifndef AXI4LITEMASTERREADCONFIGCONVERTER_INCLUDED_
`define AXI4LITEMASTERREADCONFIGCONVERTER_INCLUDED_

class Axi4LiteMasterReadConfigConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterReadConfigConverter)

  extern function new(string name = "Axi4LiteMasterReadConfigConverter");
  extern static function void fromClass(input Axi4LiteMasterReadAgentConfig input_conv,output axi4LiteReadTransferCfgStruct output_conv);
 // extern function void do_print(uvm_printer printer);

endclass : Axi4LiteMasterReadConfigConverter

function Axi4LiteMasterReadConfigConverter::new(string name = "Axi4LiteMasterReadConfigConverter");
  super.new(name);
endfunction : new

function void Axi4LiteMasterReadConfigConverter::fromClass(input Axi4LiteMasterReadAgentConfig input_conv, output axi4LiteReadTransferCfgStruct output_conv);
  
endfunction: fromClass

/*function void Axi4LiteMasterReadConfigConverter:: do_print(uvm_printer printer); 
  axi4_transfer_cfg_s axi4_cfg;
endfunction : do_print
*/
`endif

