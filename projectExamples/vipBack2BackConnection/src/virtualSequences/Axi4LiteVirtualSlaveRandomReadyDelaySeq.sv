`ifndef AXI4LITEVIRTUALSLAVERANDOMREADYDELAYSEQ_INCLUDED_
`define AXI4LITEVIRTUALSLAVERANDOMREADYDELAYSEQ_INCLUDED_
 
class Axi4LiteVirtualSlaveRandomReadyDelaySeq extends Axi4LiteVirtualBaseSeq;
  `uvm_object_utils(Axi4LiteVirtualSlaveRandomReadyDelaySeq)
 
   Axi4LiteSlaveWriteTransferRandomReadyDelaySeq axi4LiteSlaveWriteTransferRandomReadyDelaySeq;
   Axi4LiteSlaveReadTransferRandomReadyDelaySeq axi4LiteSlaveReadTransferRandomReadyDelaySeq;
 
  extern function new(string name = "Axi4LiteVirtualSlaveRandomReadyDelaySeq");
  extern task body();
endclass : Axi4LiteVirtualSlaveRandomReadyDelaySeq
 
function Axi4LiteVirtualSlaveRandomReadyDelaySeq::new(string name = "Axi4LiteVirtualSlaveRandomReadyDelaySeq");
  super.new(name);
endfunction : new
 
task Axi4LiteVirtualSlaveRandomReadyDelaySeq::body();
  axi4LiteSlaveWriteTransferRandomReadyDelaySeq = Axi4LiteSlaveWriteTransferRandomReadyDelaySeq::type_id::create("axi4LiteSlaveWriteTransferRandomReadyDelaySeq");
  axi4LiteSlaveReadTransferRandomReadyDelaySeq = Axi4LiteSlaveReadTransferRandomReadyDelaySeq::type_id::create("axi4LiteSlaveReadTransferRandomReadyDelaySeq");
 
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Inside Axi4LiteVirtualSlaveRandomReadyDelaySeq"), UVM_NONE);
 
  fork
    begin : SLAVE_WRITE
        axi4LiteSlaveWriteTransferRandomReadyDelaySeq.start(p_sequencer.axi4LiteSlaveVirtualSequencer.axi4LiteSlaveWriteSequencer);
    end
    begin : SLAVE_READ
       axi4LiteSlaveReadTransferRandomReadyDelaySeq.start(p_sequencer.axi4LiteSlaveVirtualSequencer.axi4LiteSlaveReadSequencer);
    end
  join_none
 
endtask : body
 
`endif
