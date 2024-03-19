`ifndef AXI4LITESLAVEREADCONFIGCONVERTER_INCLUDED_
`define AXI4LITESLAVEREADCONFIGCONVERTER_INCLUDED_                                                                                             
class Axi4LiteSlaveReadConfigConverter extends uvm_object;                                                 
`uvm_object_utils(Axi4LiteSlaveReadConfigConverter)                                                      
                                                                                                     
  extern function new(string name = "Axi4LiteSlaveReadConfigConverter");                                   
  extern static function void fromClass(input Axi4LiteSlaveReadAgentConfig input_conv, output axi4LiteReadTransferCfgStruct output_conv);
  extern function void do_print(uvm_printer printer);  

endclass : Axi4LiteSlaveReadConfigConverter                                                                
                                                                                                     
function Axi4LiteSlaveReadConfigConverter::new(string name = "Axi4LiteSlaveReadConfigConverter");                 
  super.new(name);                                                                                  
endfunction : new                                                                                   

function void Axi4LiteSlaveReadConfigConverter::fromClass(input Axi4LiteSlaveReadAgentConfig input_conv, output axi4LiteReadTransferCfgStruct output_conv);
/*  output_conv.min_address=input_conv.min_address;
output_conv.max_address=input_conv.max_address;
  output_conv.slave_response_mode = input_conv.slave_response_mode;
  output_conv.qos_mode_type = input_conv.qos_mode_type;
*/
endfunction: fromClass  
 
 //--------------------------------------------------------------------------------------------      
 // Function: do_print method                                                                        
 // Print method can be added to display the data members values                                     
 //--------------------------------------------------------------------------------------------      
 function void Axi4LiteSlaveReadConfigConverter:: do_print(uvm_printer printer);                            
 /* axi4_transfer_cfg_s axi4_cfg;                                                                       
  printer.print_field("min_address",axi4_cfg.min_address,$bits(axi4_cfg.min_address),UVM_HEX);
  printer.print_field("max_address",axi4_cfg.max_address,$bits(axi4_cfg.max_address),UVM_HEX);
*/
 endfunction : do_print                                                                              
                                                                                                
`endif
