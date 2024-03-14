`ifndef AXI4LITEMASTERREADTRANSACTION_INCLUDED_
`define AXI4LITEMASTERREADTRANSACTION_INCLUDED_

class Axi4LiteMasterReadTransaction extends uvm_sequence_item;
  
  `uvm_object_utils(Axi4LiteMasterReadTransaction)

  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig; 
  
  rand bit [ADDRESS_WIDTH-1:0] araddr;

  rand arprot_e arprot;

  rid_e rid;
  
  //varaible[$] gives a unbounded queue
  //variable[$:value] gives a bounded queue to a value of given value 
  bit [DATA_WIDTH-1:0] rdata [$:2**LENGTH];

  rresp_e rresp;
  //Used to differentiate the type of memory storage

  rand endian_e endian;

  //Variable : tx_type
  //Used to determine the transaction type
  rand tx_type_e tx_type;

  //Variable: transfer_type
  //Used to the determine the type of the transfer
  rand transfer_type_e transfer_type;
  
  //Variable : no_of_wait_states
  //Used to count number of wait states
  rand int no_of_wait_states;

  //Variable: wait_count_read_address_channel
  //Used to determine wait count for write response channel
  int wait_count_read_address_channel;

  //Variable: wait_count_read_data_channel
  //Used to determine wait count for write response channel
  int wait_count_read_data_channel;
  
  extern function new (string name = "Axi4LiteMasterReadTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function void post_randomize();
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
endclass : Axi4LiteMasterReadTransaction

function Axi4LiteMasterReadTransaction::new(string name = "Axi4LiteMasterReadTransaction");
  super.new(name);
endfunction : new

function void Axi4LiteMasterReadTransaction::post_randomize();

endfunction : post_randomize

function void Axi4LiteMasterReadTransaction::do_copy(uvm_object rhs);
  Axi4LiteMasterReadTransaction Axi4LiteMasterReadTransaction_copy_obj;

  if(!$cast(Axi4LiteMasterReadTransaction_copy_obj,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);
  
  //READ ADDRESS CHANNEL
  araddr   = Axi4LiteMasterReadTransaction_copy_obj.araddr;
  arprot   = Axi4LiteMasterReadTransaction_copy_obj.arprot;
  //READ DATA CHANNEL
  rdata = Axi4LiteMasterReadTransaction_copy_obj.rdata;
  rresp = Axi4LiteMasterReadTransaction_copy_obj.rresp;
  //OTHERS
  tx_type       = Axi4LiteMasterReadTransaction_copy_obj.tx_type;
  transfer_type = Axi4LiteMasterReadTransaction_copy_obj.transfer_type;
endfunction : do_copy

function bit Axi4LiteMasterReadTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteMasterReadTransaction Axi4LiteMasterReadTransaction_compare_obj;

  if(!$cast(Axi4LiteMasterReadTransaction_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_MASTER_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
    return 0;
  end
  
  return super.do_compare(Axi4LiteMasterReadTransaction_compare_obj, comparer) &&
  araddr  == Axi4LiteMasterReadTransaction_compare_obj.araddr  &&
  arprot  == Axi4LiteMasterReadTransaction_compare_obj.arprot  &&

  rdata == Axi4LiteMasterReadTransaction_compare_obj.rdata &&
  rresp == Axi4LiteMasterReadTransaction_compare_obj.rresp;
endfunction : do_compare

function void Axi4LiteMasterReadTransaction::do_print(uvm_printer printer);
  printer.print_string("tx_type",tx_type.name());

  if(tx_type == READ) begin
    //`uvm_info("------------------------------------------READ_ADDRESS_CHANNEL","-------------------------------------",UVM_LOW);
    printer.print_field("araddr",araddr,$bits(araddr),UVM_HEX);
    printer.print_string("arprot",arprot.name());
    //`uvm_info("------------------------------------------READ_DATA_CHANNEL","----------------------------------------",UVM_LOW);
    foreach(rdata[i])begin
      printer.print_field($sformatf("rdata[%0d]",i),rdata[i],$bits(rdata[i]),UVM_HEX);
    end
    printer.print_string("rresp",rresp.name());
  end
  printer.print_string("transfer_type",transfer_type.name());
endfunction : do_print

`endif

