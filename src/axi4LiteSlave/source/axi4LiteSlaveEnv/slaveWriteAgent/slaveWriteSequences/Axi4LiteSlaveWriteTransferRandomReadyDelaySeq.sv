`ifndef AXI4LITESLAVEWRITETRANSFERRANDOMREADYDELAYSEQ_INCLUDED_
`define AXI4LITESLAVEWRITETRANSFERRANDOMREADYDELAYSEQ_INCLUDED_
 
class Axi4LiteSlaveWriteTransferRandomReadyDelaySeq extends Axi4LiteSlaveWriteBaseSeq;
  `uvm_object_utils(Axi4LiteSlaveWriteTransferRandomReadyDelaySeq)
 
  extern function new(string name = "Axi4LiteSlaveWriteTransferRandomReadyDelaySeq");
  extern task body();
endclass : Axi4LiteSlaveWriteTransferRandomReadyDelaySeq
 
function Axi4LiteSlaveWriteTransferRandomReadyDelaySeq::new(string name = "Axi4LiteSlaveWriteTransferRandomReadyDelaySeq");
  super.new(name);
endfunction : new
 
task Axi4LiteSlaveWriteTransferRandomReadyDelaySeq::body();
  super.body();
 
  req = Axi4LiteSlaveWriteTransaction::type_id::create("req");
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: BEFORE start_item Axi4LiteSlaveWriteTransferRandomReadyDelaySeq"), UVM_NONE);
 
  start_item(req);
  if(!req.randomize() with {
                  writeDelayForReady inside {p_sequencer.axi4LiteSlaveWriteAgentConfig.delayForReadyWriteCfgValue};
                }) begin
    `uvm_fatal("Axi4LiteSlaveWriteTransferRandomReadyDelaySeq","Rand failed");
  end
 
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Axi4LiteSlaveWriteTransferRandomReadyDelaySeq \n%s",req.sprint()), UVM_NONE);
 
  finish_item(req);
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: AFTER finish_item Axi4LiteSlaveWriteTransferRandomReadyDelaySeq"), UVM_NONE);
 
endtask : body
 
`endif
