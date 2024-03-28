`ifndef AXI4LITEVIRTUALVALIDANDREADYWITHPROGRAMMABLEDELAYSEQ_INCLUDED_
`define AXI4LITEVIRTUALVALIDANDREADYWITHPROGRAMMABLEDELAYSEQ_INCLUDED_
 
class Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq extends Axi4LiteVirtualBaseSeq;
  `uvm_object_utils(Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq)
 
   Axi4LiteMasterWriteTransferValidGenerateSeq axi4LiteMasterWriteTransferValidGenerateSeq;
   Axi4LiteMasterReadTransferValidGenerateSeq axi4LiteMasterReadTransferValidGenerateSeq;
   Axi4LiteSlaveWriteTransferRandomReadyDelaySeq axi4LiteSlaveWriteTransferRandomReadyDelaySeq;
   Axi4LiteSlaveReadTransferRandomReadyDelaySeq axi4LiteSlaveReadTransferRandomReadyDelaySeq;
 
  extern function new(string name = "Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq");
  extern task body();
endclass : Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq
 
function Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq::new(string name = "Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq");
  super.new(name);
endfunction : new
 
task Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq::body();
  axi4LiteMasterWriteTransferValidGenerateSeq = Axi4LiteMasterWriteTransferValidGenerateSeq::type_id::create("axi4LiteMasterWriteTransferValidGenerateSeq");
  axi4LiteMasterReadTransferValidGenerateSeq = Axi4LiteMasterReadTransferValidGenerateSeq::type_id::create("axi4LiteMasterReadTransferValidGenerateSeq");
  axi4LiteSlaveWriteTransferRandomReadyDelaySeq = Axi4LiteSlaveWriteTransferRandomReadyDelaySeq::type_id::create("axi4LiteSlaveWriteTransferRandomReadyDelaySeq");
  axi4LiteSlaveReadTransferRandomReadyDelaySeq = Axi4LiteSlaveReadTransferRandomReadyDelaySeq::type_id::create("axi4LiteSlaveReadTransferRandomReadyDelaySeq");
 
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Inside Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq"), UVM_NONE);

  fork
    begin : SLAVE_WRITE
      forever begin
        axi4LiteSlaveWriteTransferRandomReadyDelaySeq.start(p_sequencer.axi4LiteSlaveVirtualSequencer.axi4LiteSlaveWriteSequencer);
      end
    end
    begin : SLAVE_READ
      forever begin
       axi4LiteSlaveReadTransferRandomReadyDelaySeq.start(p_sequencer.axi4LiteSlaveVirtualSequencer.axi4LiteSlaveReadSequencer);
      end
    end
  join_none
 
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
