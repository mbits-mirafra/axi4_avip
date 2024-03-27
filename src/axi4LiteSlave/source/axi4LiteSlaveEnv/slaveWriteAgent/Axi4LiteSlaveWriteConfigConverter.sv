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
endfunction: fromClass   

/*
function void Axi4LiteSlaveWriteConfigConverter:: do_print(uvm_printer printer);                            
  axi4_transfer_cfg_s axi4_cfg;                                                                       

 endfunction : do_print                                                                              
 */                                                                                               
`endif
