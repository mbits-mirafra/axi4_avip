`ifndef AXI4LITESLAVEWRITECONFIGCONVERTER_INCLUDED_
`define AXI4LITESLAVEWRITECONFIGCONVERTER_INCLUDED_                                                                                             
class Axi4LiteSlaveWriteConfigConverter extends uvm_object;                                                 
`uvm_object_utils(Axi4LiteSlaveWriteConfigConverter)                                                      
                                                                                                     
  extern function new(string name = "Axi4LiteSlaveWriteConfigConverter");                                   
  extern static function void fromClass(input Axi4LiteSlaveWriteAgentConfig input_conv,output axi4LiteWriteTransferCfgStruct output_conv);
//  extern function void do_print(uvm_printer printer);  

endclass : Axi4LiteSlaveWriteConfigConverter                                                                
                                                                                                     
function Axi4LiteSlaveWriteConfigConverter::new(string name = "Axi4LiteSlaveWriteConfigConverter");                 
  super.new(name);                                                                                  
endfunction : new                                                                                   

function void Axi4LiteSlaveWriteConfigConverter::fromClass(input Axi4LiteSlaveWriteAgentConfig input_conv,output axi4LiteWriteTransferCfgStruct output_conv);
/*  output_conv.min_address=input_conv.min_address;
  output_conv.max_address=input_conv.max_address;
  output_conv.slave_response_mode = input_conv.slave_response_mode;
  output_conv.qos_mode_type = input_conv.qos_mode_type;
*/
endfunction: fromClass   
/*
function void Axi4LiteSlaveWriteConfigConverter:: do_print(uvm_printer printer);                            
  axi4_transfer_cfg_s axi4_cfg;                                                                       
  printer.print_field("min_address",axi4_cfg.min_address,$bits(axi4_cfg.min_address),UVM_HEX);
  printer.print_field("max_address",axi4_cfg.max_address,$bits(axi4_cfg.max_address),UVM_HEX);

 endfunction : do_print                                                                              
 */                                                                                               
`endif
