`ifndef AXI4LITESLAVEWRITEBASESEQ_INCLUDED_
`define AXI4LITESLAVEWRITEBASESEQ_INCLUDED_

class Axi4LiteSlaveWriteBaseSeq extends uvm_sequence #(Axi4LiteSlaveWriteTransaction);
  `uvm_object_utils(Axi4LiteSlaveWriteBaseSeq)
  
  `uvm_declare_p_sequencer(Axi4LiteSlaveWriteSequencer)

  extern function new(string name = "Axi4LiteSlaveWriteBaseSeq");
  extern task body();
endclass : Axi4LiteSlaveWriteBaseSeq

function Axi4LiteSlaveWriteBaseSeq::new(string name = "Axi4LiteSlaveWriteBaseSeq");
  super.new(name);
endfunction : new

task Axi4LiteSlaveWriteBaseSeq::body();
  //dynamic casting of p_sequencer and m_sequencer
  if(!$cast(p_sequencer,m_sequencer))begin
    `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
  end
endtask : body


`endif
