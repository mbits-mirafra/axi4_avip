`ifndef AXI4LITEMASTERWRITETRANSFERVALIDGENERATESEQ_INCLUDED_
`define AXI4LITEMASTERWRITETRANSFERVALIDGENERATESEQ_INCLUDED_
 
class Axi4LiteMasterWriteTransferValidGenerateSeq extends Axi4LiteMasterWriteBaseSeq;
  `uvm_object_utils(Axi4LiteMasterWriteTransferValidGenerateSeq)
 
  extern function new(string name = "Axi4LiteMasterWriteTransferValidGenerateSeq");
  extern task body();
endclass : Axi4LiteMasterWriteTransferValidGenerateSeq
 
function Axi4LiteMasterWriteTransferValidGenerateSeq::new(string name = "Axi4LiteMasterWriteTransferValidGenerateSeq");
  super.new(name);
endfunction : new
 
task Axi4LiteMasterWriteTransferValidGenerateSeq::body();
  super.body();
 
  req = Axi4LiteMasterWriteTransaction::type_id::create("req");
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: BEFORE start_item Axi4LiteMasterWriteTransferValidGenerateSeq"), UVM_NONE);
 
  start_item(req);
  if(!req.randomize()) begin
    `uvm_fatal("Axi4LiteMasterWriteTransferValidGenerateSeq","Rand failed");
  end
 
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Axi4LiteMasterWriteTransferValidGenerateSeq \n%s",req.sprint()), UVM_NONE);
 
  finish_item(req);
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: AFTER finish_item Axi4LiteMasterWriteTransferValidGenerateSeq"), UVM_NONE);
 
endtask : body
 
`endif
