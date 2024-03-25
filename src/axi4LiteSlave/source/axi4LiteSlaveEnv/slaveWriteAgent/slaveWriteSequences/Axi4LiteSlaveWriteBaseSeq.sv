`ifndef AXI4LITESLAVEWRITEBASESEQ_INCLUDED_
`define AXI4LITESLAVEWRITEBASESEQ_INCLUDED_

class Axi4LiteSlaveWriteBaseSeq extends uvm_sequence #(Axi4LiteSlaveWriteTransaction);
  `uvm_object_utils(Axi4LiteSlaveWriteBaseSeq)
  
    extern function new(string name = "Axi4LiteSlaveWriteBaseSeq");
    extern task body();
endclass : Axi4LiteSlaveWriteBaseSeq

function Axi4LiteSlaveWriteBaseSeq::new(string name = "Axi4LiteSlaveWriteBaseSeq");
  super.new(name);
endfunction : new

task Axi4LiteSlaveWriteBaseSeq::body();
  req = Axi4LiteSlaveWriteTransaction::type_id::create("req");
endtask : body


`endif
