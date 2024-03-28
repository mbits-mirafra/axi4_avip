`ifndef AXI4LITEMASTERREADTRANSFERVALIDGENERATESEQ_INCLUDED_
`define AXI4LITEMASTERREADTRANSFERVALIDGENERATESEQ_INCLUDED_
 
class Axi4LiteMasterReadTransferValidGenerateSeq extends Axi4LiteMasterReadBaseSeq;
  `uvm_object_utils(Axi4LiteMasterReadTransferValidGenerateSeq)
 
  extern function new(string name = "Axi4LiteMasterReadTransferValidGenerateSeq");
  extern task body();
endclass : Axi4LiteMasterReadTransferValidGenerateSeq
 
function Axi4LiteMasterReadTransferValidGenerateSeq::new(string name = "Axi4LiteMasterReadTransferValidGenerateSeq");
  super.new(name);
endfunction : new
 
task Axi4LiteMasterReadTransferValidGenerateSeq::body();
  super.body();
 
  req = Axi4LiteMasterReadTransaction::type_id::create("req");
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: BEFORE start_item Axi4LiteMasterReadTransferValidGenerateSeq"), UVM_NONE);
 
  start_item(req);
  if(!req.randomize()) begin
    `uvm_fatal("Axi4LiteMasterReadTransferValidGenerateSeq","Rand failed");
  end
 
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Axi4LiteMasterReadTransferValidGenerateSeq \n%s",req.sprint()), UVM_NONE);
 
  finish_item(req);
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: AFTER finish_item Axi4LiteMasterReadTransferValidGenerateSeq"), UVM_NONE);
 
endtask : body
 
`endif
