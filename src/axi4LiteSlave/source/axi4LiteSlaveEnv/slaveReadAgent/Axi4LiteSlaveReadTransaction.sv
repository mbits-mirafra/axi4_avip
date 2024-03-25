`ifndef AXI4LITESLAVEREADTRANSACTION_INCLUDED_
`define AXI4LITESLAVEREADTRANSACTION_INCLUDED_

class Axi4LiteSlaveReadTransaction extends uvm_sequence_item;
  `uvm_object_utils(Axi4LiteSlaveReadTransaction)
  
  extern function new(string name = "Axi4LiteSlaveReadTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare (uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);

endclass : Axi4LiteSlaveReadTransaction

function Axi4LiteSlaveReadTransaction::new(string name = "Axi4LiteSlaveReadTransaction");
  super.new(name);
endfunction : new

function void Axi4LiteSlaveReadTransaction::do_copy (uvm_object rhs);
  Axi4LiteSlaveReadTransaction axi_slave_tx_copy_obj;

  if(!$cast(axi_slave_tx_copy_obj,rhs )) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end

  super.do_copy(rhs);
endfunction : do_copy

function bit Axi4LiteSlaveReadTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteSlaveReadTransaction axi_slave_tx_compare_obj;

  if(!$cast(axi_slave_tx_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_SLAVE_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(axi_slave_tx_compare_obj, comparer);
endfunction : do_compare

function void Axi4LiteSlaveReadTransaction::do_print(uvm_printer printer);

endfunction : do_print

`endif

