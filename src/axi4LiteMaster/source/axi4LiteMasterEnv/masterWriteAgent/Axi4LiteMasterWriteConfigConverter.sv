`ifndef AXI4LITEMASTERWRITECONFIGCONVERTER_INCLUDED_
`define AXI4LITEMASTERWRITECONFIGCONVERTER_INCLUDED_

class Axi4LiteMasterWriteConfigConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterWriteConfigConverter)

  extern function new(string name = "Axi4LiteMasterWriteConfigConverter");
  extern static function void fromClass(input Axi4LiteMasterWriteAgentConfig input_conv, output axi4LiteWriteTransferCfgStruct output_conv);
 // extern function void do_print(uvm_printer printer);

endclass : Axi4LiteMasterWriteConfigConverter

function Axi4LiteMasterWriteConfigConverter::new(string name = "Axi4LiteMasterWriteConfigConverter");
  super.new(name);
endfunction : new

function void Axi4LiteMasterWriteConfigConverter::fromClass(input Axi4LiteMasterWriteAgentConfig input_conv, output axi4LiteWriteTransferCfgStruct output_conv);
endfunction: fromClass

/*function void Axi4LiteMasterWriteConfigConverter:: do_print(uvm_printer printer); 
  axi4_transfer_cfg_s axi4_cfg;
endfunction : do_print
*/
`endif

