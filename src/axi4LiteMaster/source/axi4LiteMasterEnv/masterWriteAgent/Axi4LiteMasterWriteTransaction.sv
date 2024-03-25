`ifndef AXI4LITEMASTERWRITETRANSACTION_INCLUDED_
`define AXI4LITEMASTERWRITETRANSACTION_INCLUDED_

class Axi4LiteMasterWriteTransaction extends uvm_sequence_item;
  `uvm_object_utils(Axi4LiteMasterWriteTransaction)

  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig; 
  
  extern function new (string name = "Axi4LiteMasterWriteTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function void post_randomize();
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
endclass : Axi4LiteMasterWriteTransaction

function Axi4LiteMasterWriteTransaction::new(string name = "Axi4LiteMasterWriteTransaction");
  super.new(name);
endfunction : new

function void Axi4LiteMasterWriteTransaction::post_randomize();

endfunction : post_randomize

function void Axi4LiteMasterWriteTransaction::do_copy(uvm_object rhs);
  Axi4LiteMasterWriteTransaction Axi4LiteMasterWriteTransaction_copy_obj;

  if(!$cast(Axi4LiteMasterWriteTransaction_copy_obj,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);

endfunction : do_copy

function bit Axi4LiteMasterWriteTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteMasterWriteTransaction Axi4LiteMasterWriteTransaction_compare_obj;

  if(!$cast(Axi4LiteMasterWriteTransaction_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_MASTER_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
    return 0;
  end
  
  return super.do_compare(Axi4LiteMasterWriteTransaction_compare_obj, comparer);
endfunction : do_compare

function void Axi4LiteMasterWriteTransaction::do_print(uvm_printer printer);

endfunction : do_print

`endif

