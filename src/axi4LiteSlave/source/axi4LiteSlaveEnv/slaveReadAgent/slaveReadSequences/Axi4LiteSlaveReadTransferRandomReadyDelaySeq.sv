`ifndef AXI4LITESLAVEREADTRANSFERRANDOMREADYDELAYSEQ_INCLUDED_
`define AXI4LITESLAVEREADTRANSFERRANDOMREADYDELAYSEQ_INCLUDED_
 
class Axi4LiteSlaveReadTransferRandomReadyDelaySeq extends Axi4LiteSlaveReadBaseSeq;
  `uvm_object_utils(Axi4LiteSlaveReadTransferRandomReadyDelaySeq)
 
  extern function new(string name = "Axi4LiteSlaveReadTransferRandomReadyDelaySeq");
  extern task body();
endclass : Axi4LiteSlaveReadTransferRandomReadyDelaySeq
 
function Axi4LiteSlaveReadTransferRandomReadyDelaySeq::new(string name = "Axi4LiteSlaveReadTransferRandomReadyDelaySeq");
  super.new(name);
endfunction : new
 
task Axi4LiteSlaveReadTransferRandomReadyDelaySeq::body();
  super.body();

  req = Axi4LiteSlaveReadTransaction::type_id::create("req");
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: BEFORE start_item Axi4LiteSlaveReadTransferRandomReadyDelaySeq"), UVM_NONE);
 
  start_item(req);
  if(!req.randomize() with {
                  readDelayForReady inside {p_sequencer.axi4LiteSlaveReadAgentConfig.delayForReadyReadCfgValue};
                }) begin
    `uvm_fatal("Axi4LiteSlaveReadTransferRandomReadyDelaySeq","Rand failed");
  end
 
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: Axi4LiteSlaveReadTransferRandomReadyDelaySeq \n%s",req.sprint()), UVM_NONE);
 
  finish_item(req);
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: AFTER finish_item Axi4LiteSlaveReadTransferRandomReadyDelaySeq"), UVM_NONE);
 
endtask : body
 
`endif
