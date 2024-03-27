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
endfunction: fromClass  
 
 function void Axi4LiteSlaveReadConfigConverter:: do_print(uvm_printer printer);                            
 endfunction : do_print                                                                              
                                                                                                
`endif
