`ifndef AXI4LITESLAVEWRITETRANSACTION_INCLUDED_
`define AXI4LITESLAVEWRITETRANSACTION_INCLUDED_

class Axi4LiteSlaveWriteTransaction extends uvm_sequence_item;
  
  `uvm_object_utils(Axi4LiteSlaveWriteTransaction)
  
  bit [ADDRESS_WIDTH-1:0] awaddr;

  awprotEnum awprot;

  bit [DATA_WIDTH-1:0] wdata;

  bit [(DATA_WIDTH/8)-1:0] wstrb;

  rand brespEnum bresp;

  //Variable : no_of_wait_states
  //Used to count number of wait states
  rand int no_of_wait_states;
  
  //Variable : tx_type
  //Used to determine the transaction type
   transactionTypeEnum tx_type;
  
  //Variable : transferType
  //Used to determine the tranfer type
  transferTypeEnum transferType;

  //Variable: wait_count_write_address_channel
  //Used to determine wait count for write address channel
  int wait_count_write_address_channel;

  //Variable: wait_count_write_data_channel
  //Used to determine wait count for write data channel
  int wait_count_write_data_channel;
  
  //Variable: wait_count_write_response_channel
  //Used to determine wait count for write response channel
  int wait_count_write_response_channel;

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
  //WRITE ADDRESS CHANNEL
  awaddr  = axi_slave_tx_copy_obj.awaddr;
  awprot  = axi_slave_tx_copy_obj.awprot;
  //WRITE DATA CHANNEL
  wdata   = axi_slave_tx_copy_obj.wdata;
  wstrb   = axi_slave_tx_copy_obj.wstrb;
  //WRITE RESPONSE CHANNEL
  bresp   = axi_slave_tx_copy_obj.bresp;
  //OTHERS
  tx_type = axi_slave_tx_copy_obj.tx_type;
  transferType = axi_slave_tx_copy_obj.transferType;

endfunction : do_copy

function bit Axi4LiteSlaveWriteTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteSlaveWriteTransaction axi_slave_tx_compare_obj;

  if(!$cast(axi_slave_tx_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_SLAVE_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(axi_slave_tx_compare_obj, comparer) &&
  //WRITE ADDRESS CHANNEL
  awaddr  == axi_slave_tx_compare_obj.awaddr  &&   
  awprot  == axi_slave_tx_compare_obj.awprot  &&
  //WRITE DATA CHANNEL
  wdata == axi_slave_tx_compare_obj.wdata &&
  wstrb == axi_slave_tx_compare_obj.wstrb &&
  //WRITE RESPONSE CHANNEL
  bresp == axi_slave_tx_compare_obj.bresp;
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void Axi4LiteSlaveWriteTransaction::do_print(uvm_printer printer);
  printer.print_string("tx_type",tx_type.name());
  if(tx_type == WRITE) begin
    //`uvm_info("------------------------------------------WRITE_ADDRESS_CHANNEL","------------------------------------",UVM_LOW);
    printer.print_field("awaddr",awaddr,$bits(awaddr),UVM_HEX);
    printer.print_string("awprot",awprot.name());
    //`uvm_info("------------------------------------------WRITE_DATA_CHANNEL","---------------------------------------",UVM_LOW);
    foreach(wdata[i]) begin
      printer.print_field($sformatf("wdata[%0d]",i),wdata[i],$bits(wdata[i]),UVM_HEX);
    end
    foreach(wstrb[i]) begin
      printer.print_field($sformatf("wstrb[%0d]",i),wstrb[i],$bits(wstrb[i]),UVM_HEX);
    end
    //`uvm_info("------------------------------------------WRITE_RESPONSE_CHANNEL","-----------------------------------",UVM_LOW);
    printer.print_string("bresp",bresp.name());
  end
endfunction : do_print

`endif

