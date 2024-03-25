`ifndef AXI4LITESLAVEWRITETRANSACTION_INCLUDED_
`define AXI4LITESLAVEWRITETRANSACTION_INCLUDED_

class Axi4LiteSlaveWriteTransaction extends uvm_sequence_item;
  `uvm_object_utils(Axi4LiteSlaveWriteTransaction)
  
  extern function new(string name = "Axi4LiteSlaveWriteTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare (uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteSlaveWriteTransaction

function Axi4LiteSlaveWriteTransaction::new(string name = "Axi4LiteSlaveWriteTransaction");
  super.new(name);
endfunction : new

function void Axi4LiteSlaveWriteTransaction::do_copy (uvm_object rhs);
  Axi4LiteSlaveWriteTransaction axi_slave_tx_copy_obj;

  if(!$cast(axi_slave_tx_copy_obj,rhs )) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);
 
endfunction : do_copy

function bit Axi4LiteSlaveWriteTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteSlaveWriteTransaction axi_slave_tx_compare_obj;

  if(!$cast(axi_slave_tx_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_SLAVE_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(axi_slave_tx_compare_obj, comparer);
endfunction : do_compare

function void Axi4LiteSlaveWriteTransaction::do_print(uvm_printer printer);

endfunction : do_print

`endif

