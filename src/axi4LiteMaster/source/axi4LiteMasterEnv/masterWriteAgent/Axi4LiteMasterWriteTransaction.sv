`ifndef AXI4LITEMASTERWRITETRANSACTION_INCLUDED_
`define AXI4LITEMASTERWRITETRANSACTION_INCLUDED_

class Axi4LiteMasterWriteTransaction extends uvm_sequence_item;
  
  `uvm_object_utils(Axi4LiteMasterWriteTransaction)

  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig; 
  
  rand bit [ADDRESS_WIDTH-1:0] awaddr;
  rand awprotEnum awprot;

  //varaible[$] gives a unbounded queue
  //variable[$:value] gives a bounded queue to a value of given value 
  rand bit [DATA_WIDTH-1:0] wdata;

  //varaible[$] gives a unbounded queue
  //variable[$:value] gives a bounded queue to a value of given value 
  rand bit [(DATA_WIDTH/8)-1:0] wstrb;

  brespEnum bresp;
  
  //Variable : tx_type
  //Used to determine the transaction type
  rand transactionTypeEnum tx_type;

  //Variable: transferType
  //Used to the determine the type of the transfer
  rand transferTypeEnum transferType;
  
  //Variable : no_of_wait_states
  //Used to count number of wait states
  rand int no_of_wait_states;

  //Variable: wait_count_write_address_channel
  //Used to determine wait count for write address channel
  int wait_count_write_address_channel;

  //Variable: wait_count_write_data_channel
  //Used to determine wait count for write data channel
  int wait_count_write_data_channel;
  
  //Variable: wait_count_write_response_channel
  //Used to determine wait count for write response channel
  int wait_count_write_response_channel;

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
  
  //WRITE ADDRESS CHANNEL
  awaddr  = Axi4LiteMasterWriteTransaction_copy_obj.awaddr;
  awprot  = Axi4LiteMasterWriteTransaction_copy_obj.awprot;
  //WRITE DATA CHANNEL
  wdata = Axi4LiteMasterWriteTransaction_copy_obj.wdata;
  wstrb = Axi4LiteMasterWriteTransaction_copy_obj.wstrb;
  //WRITE RESPONSE CHANNEL
  bresp = Axi4LiteMasterWriteTransaction_copy_obj.bresp;
  //OTHERS
  tx_type       = Axi4LiteMasterWriteTransaction_copy_obj.tx_type;
  transferType = Axi4LiteMasterWriteTransaction_copy_obj.transferType;
endfunction : do_copy

function bit Axi4LiteMasterWriteTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteMasterWriteTransaction Axi4LiteMasterWriteTransaction_compare_obj;

  if(!$cast(Axi4LiteMasterWriteTransaction_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_MASTER_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
    return 0;
  end
  
  return super.do_compare(Axi4LiteMasterWriteTransaction_compare_obj, comparer) &&
  //WRITE ADDRESS CHANNEL
  awaddr  == Axi4LiteMasterWriteTransaction_compare_obj.awaddr  &&
  awprot  == Axi4LiteMasterWriteTransaction_compare_obj.awprot  &&
  //WRITE DATA CHANNEL
  wdata == Axi4LiteMasterWriteTransaction_compare_obj.wdata &&
  wstrb == Axi4LiteMasterWriteTransaction_compare_obj.wstrb &&
  //WRITE RESPONSE CHANNEL
  bresp == Axi4LiteMasterWriteTransaction_compare_obj.bresp;
endfunction : do_compare

function void Axi4LiteMasterWriteTransaction::do_print(uvm_printer printer);
  printer.print_string("tx_type",tx_type.name());
  if(tx_type == WRITE) begin
  //`uvm_info("------------------------------------------WRITE_ADDRESS_CHANNEL","-------------------------------------",UVM_LOW);
    printer.print_field("awaddr",awaddr,$bits(awaddr),UVM_HEX);
    printer.print_string("awprot",awprot.name());
    //`uvm_info("------------------------------------------WRITE_DATA_CHANNEL","---------------------------------------",UVM_LOW);
    foreach(wdata[i])begin
      printer.print_field($sformatf("wdata[%0d]",i),wdata[i],$bits(wdata[i]),UVM_HEX);
    end
    foreach(wstrb[i])begin
      printer.print_field($sformatf("wstrb[%0d]",i),wstrb[i],$bits(wstrb[i]),UVM_HEX);
    end
    //`uvm_info("-----------------------------------------WRITE_RESPONSE_CHANNEL","------------------------------------",UVM_LOW);
    printer.print_string("bresp",bresp.name());
  end
  
  printer.print_string("transferType",transferType.name());
endfunction : do_print

`endif

