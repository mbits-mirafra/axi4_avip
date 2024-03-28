`ifndef AXI4LITEVIRTUALMASTERVALIDGENERATESEQ_INCLUDED_
`define AXI4LITEVIRTUALMASTERVALIDGENERATESEQ_INCLUDED_
 
class Axi4LiteVirtualMasterValidGenerateSeq extends Axi4LiteVirtualBaseSeq;
  `uvm_object_utils(Axi4LiteVirtualMasterValidGenerateSeq)
 
   Axi4LiteMasterWriteTransferValidGenerateSeq axi4LiteMasterWriteTransferValidGenerateSeq;
   Axi4LiteMasterReadTransferValidGenerateSeq axi4LiteMasterReadTransferValidGenerateSeq;
 
  extern function new(string name = "Axi4LiteVirtualMasterValidGenerateSeq");
  extern task body();
endclass : Axi4LiteVirtualMasterValidGenerateSeq
 
function Axi4LiteVirtualMasterValidGenerateSeq::new(string name = "Axi4LiteVirtualMasterValidGenerateSeq");
  super.new(name);
endfunction : new
 
task Axi4LiteVirtualMasterValidGenerateSeq::body();
  axi4LiteMasterWriteTransferValidGenerateSeq = Axi4LiteMasterWriteTransferValidGenerateSeq::type_id::create("axi4LiteMasterWriteTransferValidGenerateSeq");
  axi4LiteMasterReadTransferValidGenerateSeq = Axi4LiteMasterReadTransferValidGenerateSeq::type_id::create("axi4LiteMasterReadTransferValidGenerateSeq");
 
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Inside Axi4LiteVirtualMasterValidGenerateSeq"), UVM_NONE);
 
  fork
    begin: MASTER_WRITE
        axi4LiteMasterWriteTransferValidGenerateSeq.start(p_sequencer.axi4LiteMasterVirtualSequencer.axi4LiteMasterWriteSequencer);
    end
    begin: MASTER_READ
       axi4LiteMasterReadTransferValidGenerateSeq.start(p_sequencer.axi4LiteMasterVirtualSequencer.axi4LiteMasterReadSequencer);
    end
  join_none
endtask : body
 
`endif
