`ifndef AXI4LITESLAVEREADTRANSACTION_INCLUDED_
`define AXI4LITESLAVEREADTRANSACTION_INCLUDED_

class Axi4LiteSlaveReadTransaction extends uvm_sequence_item;
  
  `uvm_object_utils(Axi4LiteSlaveReadTransaction)
  
  rand bit [ADDRESS_WIDTH-1:0] araddr;

  rand arprotEnum arprot;

  rand bit [DATA_WIDTH-1:0] rdata;

  bit rvalid;

  rand rrespEnum rresp ;

  rand int no_of_wait_states;
  
  transactionTypeEnum tx_type;
  
  transferTypeEnum transferType;

  //Variable: wait_count_read_address_channel
  //Used to determine wait count for write response channel
  int wait_count_read_address_channel;

  //Variable: wait_count_read_data_channel
  //Used to determine wait count for write response channel
  int wait_count_read_data_channel;
  
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
  //READ ADDRESS CHANNEL
  araddr  = axi_slave_tx_copy_obj.araddr;
  arprot  = axi_slave_tx_copy_obj.arprot;
  //READ DATA CHANNEL
  rdata = axi_slave_tx_copy_obj.rdata;
  rresp = axi_slave_tx_copy_obj.rresp;
  //OTHERS
  tx_type = axi_slave_tx_copy_obj.tx_type;
  transferType = axi_slave_tx_copy_obj.transferType;

endfunction : do_copy

function bit Axi4LiteSlaveReadTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteSlaveReadTransaction axi_slave_tx_compare_obj;

  if(!$cast(axi_slave_tx_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_SLAVE_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(axi_slave_tx_compare_obj, comparer) &&
  //READ ADDRESS CHANNEL
  araddr  == axi_slave_tx_compare_obj.araddr   &&
  arprot  == axi_slave_tx_compare_obj.arprot   &&
  //READ DATA CHANNEL
  rdata == axi_slave_tx_compare_obj.rdata && 
  rresp == axi_slave_tx_compare_obj.rresp;
endfunction : do_compare

function void Axi4LiteSlaveReadTransaction::do_print(uvm_printer printer);
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
endfunction : do_print

`endif

