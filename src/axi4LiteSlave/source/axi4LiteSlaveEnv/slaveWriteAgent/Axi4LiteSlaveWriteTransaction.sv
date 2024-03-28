`ifndef AXI4LITESLAVEWRITETRANSACTION_INCLUDED_
`define AXI4LITESLAVEWRITETRANSACTION_INCLUDED_

class Axi4LiteSlaveWriteTransaction extends uvm_sequence_item;
  `uvm_object_utils(Axi4LiteSlaveWriteTransaction)
  
  rand bit [DELAY_WIDTH-1:0] writeDelayForReady;

  extern function new(string name = "Axi4LiteSlaveWriteTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare (uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteSlaveWriteTransaction

function Axi4LiteSlaveWriteTransaction::new(string name = "Axi4LiteSlaveWriteTransaction");
  super.new(name);
endfunction : new

function void Axi4LiteSlaveWriteTransaction::do_copy (uvm_object rhs);
  Axi4LiteSlaveWriteTransaction axi4LiteSlaveWriteTxCopyObj;

  if(!$cast(axi4LiteSlaveWriteTxCopyObj,rhs )) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);
  writeDelayForReady = axi4LiteSlaveWriteTxCopyObj.writeDelayForReady; 
endfunction : do_copy

function bit Axi4LiteSlaveWriteTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteSlaveWriteTransaction axi4LiteSlaveWriteTxCompareObj;

  if(!$cast(axi4LiteSlaveWriteTxCompareObj,rhs)) begin
    `uvm_fatal("FATAL_axi_SLAVE_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(axi4LiteSlaveWriteTxCompareObj, comparer) &&
  writeDelayForReady == axi4LiteSlaveWriteTxCompareObj.writeDelayForReady;

endfunction : do_compare

function void Axi4LiteSlaveWriteTransaction::do_print(uvm_printer printer);
  printer.print_field($sformatf("writeDelayForReady"),this.writeDelayForReady,$bits(writeDelayForReady),UVM_HEX);
endfunction : do_print

`endif

