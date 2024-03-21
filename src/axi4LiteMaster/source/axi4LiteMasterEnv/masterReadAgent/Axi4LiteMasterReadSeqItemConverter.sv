`ifndef AXI4LITEMASTERREADSEQITEMCONVERTER_INCLUDED_
`define AXI4LITEMASTERREADSEQITEMCONVERTER_INCLUDED_

class Axi4LiteMasterReadSeqItemConverter extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterReadSeqItemConverter)
  
  extern function new(string name = "Axi4LiteMasterReadSeqItemConverter");
  extern static function void fromReadClass(input Axi4LiteMasterReadTransaction input_conv_h,output axi4LiteReadTransferCharStruct output_conv_h);
 extern static function void toReadClass(input axi4LiteReadTransferCharStruct input_conv_h,output Axi4LiteMasterReadTransaction output_conv_h);
/*  extern static function void to_write_addr_data_class(input axi4_master_tx waddr_packet, input axi4_write_transfer_char_s input_conv_h,output axi4_master_tx output_conv_h);
  extern static function void to_write_addr_data_resp_class(input axi4_master_tx waddr_data_packet, input axi4_write_transfer_char_s input_conv_h,output axi4_master_tx output_conv_h);
  extern static function void to_read_addr_data_class(input axi4_master_tx raddr_packet, input axi4_read_transfer_char_s input_conv_h,output axi4_master_tx output_conv_h);
  extern function void do_print(uvm_printer printer);
*/
endclass : Axi4LiteMasterReadSeqItemConverter

function Axi4LiteMasterReadSeqItemConverter::new(string name = "Axi4LiteMasterReadSeqItemConverter");
  super.new(name);
endfunction : new

function void Axi4LiteMasterReadSeqItemConverter::fromReadClass( input Axi4LiteMasterReadTransaction input_conv_h,output axi4LiteReadTransferCharStruct output_conv_h);

  /*
   $cast(output_conv_h.arprot,input_conv_h.arprot);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arprot =  %b",output_conv_h.arprot),UVM_HIGH);

  $cast(output_conv_h.rresp,input_conv_h.rresp);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting rresp =  %b",output_conv_h.rresp),UVM_HIGH);
  
  output_conv_h.araddr = input_conv_h.araddr;
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting araddr =  %0h",output_conv_h.araddr),UVM_HIGH);


 foreach(input_conv_h.rdata[i]) begin
    if(input_conv_h.rdata[i] != 0)begin
      output_conv_h.rdata[i] = input_conv_h.rdata[i];
      `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting rdata = %0p",output_conv_h.rdata[i]),UVM_HIGH);
    end
  end
  output_conv_h.no_of_wait_states = input_conv_h.no_of_wait_states;
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting no_wait_states =  %0d",output_conv_h.no_of_wait_states),UVM_HIGH);

  output_conv_h.wait_count_read_address_channel =input_conv_h.wait_count_read_address_channel ;
  output_conv_h.wait_count_read_data_channel =input_conv_h.wait_count_read_data_channel ;
*/
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
  
endfunction : fromReadClass 

function void Axi4LiteMasterReadSeqItemConverter::toReadClass( input axi4LiteReadTransferCharStruct
  input_conv_h, output Axi4LiteMasterReadTransaction output_conv_h);

  output_conv_h = new();
/*
  output_conv_h.araddr = input_conv_h.araddr;
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting araddr =  %0h",output_conv_h.araddr),UVM_HIGH);

  $cast(output_conv_h.arprot,input_conv_h.arprot);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arprot =  %b",output_conv_h.arprot),UVM_HIGH);

  output_conv_h.wait_count_read_address_channel = input_conv_h.wait_count_read_address_channel;
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wait_count_read_address_channel =  %0h",output_conv_h.wait_count_read_address_channel),UVM_HIGH);

  $cast(output_conv_h.rresp,input_conv_h.rresp);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting rresp =  %b",output_conv_h.rresp),UVM_HIGH);
  
  foreach(input_conv_h.rdata[i]) begin
    if(input_conv_h.rdata[i] != 'h0)begin
      output_conv_h.rdata.push_front(input_conv_h.rdata[i]);
      `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting rdata =  %0h",output_conv_h.rdata[i]),UVM_HIGH);
    end
  end

  output_conv_h.wait_count_read_data_channel = input_conv_h.wait_count_read_data_channel;
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wait_count_read_data_channel =  %0h",output_conv_h.wait_count_read_data_channel),UVM_HIGH);
*/
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
endfunction : toReadClass

//--------------------------------------------------------------------------------------------
// Function: to_write_addr_data_class
// Converting struct data items into seq_item transactions
//
// Parameters:
// name - axi4_master_tx, axi4_write_transfer_char_s
//--------------------------------------------------------------------------------------------
/*function void Axi4LiteMasterReadSeqItemConverter::to_write_addr_data_class(input axi4_master_tx waddr_packet, input axi4_write_transfer_char_s input_conv_h, output axi4_master_tx output_conv_h);
  output_conv_h = new();

  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
 

  output_conv_h.tx_type = WRITE; 

  $cast(output_conv_h.awid,waddr_packet.awid); 
  $cast(output_conv_h.awlen,waddr_packet.awlen);
  $cast(output_conv_h.awsize,waddr_packet.awsize);
  $cast(output_conv_h.awburst,waddr_packet.awburst); 
  $cast(output_conv_h.awlock,waddr_packet.awlock);
  $cast(output_conv_h.awcache,waddr_packet.awcache);
  $cast(output_conv_h.awprot,waddr_packet.awprot);
  output_conv_h.awaddr = waddr_packet.awaddr;
  output_conv_h.awqos = waddr_packet.awqos;

  foreach(input_conv_h.wdata[i]) begin
    if(input_conv_h.wdata[i] != 0)begin
      output_conv_h.wdata.push_front(input_conv_h.wdata[i]);
      `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wdata[%0d] =  %0h",i,output_conv_h.wdata[i]),UVM_HIGH);
    end
  end

  foreach(input_conv_h.wdata[i]) begin
    if(input_conv_h.wdata[i] != 0)begin
      output_conv_h.wstrb.push_front(input_conv_h.wstrb[i]);
      `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wstrb[%0d] =  %0d",i,output_conv_h.wstrb[i]),UVM_HIGH);
    end
  end

  output_conv_h.wlast = input_conv_h.wlast;
  output_conv_h.wuser = input_conv_h.wuser;
  $cast(output_conv_h.bid,input_conv_h.bid);
  $cast(output_conv_h.bresp,input_conv_h.bresp);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting =  %s",output_conv_h.sprint()),UVM_HIGH);

endfunction : to_write_addr_data_class

//--------------------------------------------------------------------------------------------
// Function: to_write_addr_data_resp_class
// Converting struct data items into seq_item transactions
//
// Parameters:
// name - axi4_master_tx, axi4_write_transfer_char_s
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadSeqItemConverter::to_write_addr_data_resp_class(input axi4_master_tx waddr_data_packet, input axi4_write_transfer_char_s input_conv_h, output axi4_master_tx output_conv_h);
  output_conv_h = new();

  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
 

  output_conv_h.tx_type = WRITE; 

  $cast(output_conv_h.awid,waddr_data_packet.awid); 
  $cast(output_conv_h.awlen,waddr_data_packet.awlen);
  $cast(output_conv_h.awsize,waddr_data_packet.awsize);
  $cast(output_conv_h.awburst,waddr_data_packet.awburst); 
  $cast(output_conv_h.awlock,waddr_data_packet.awlock);
  $cast(output_conv_h.awcache,waddr_data_packet.awcache);
  $cast(output_conv_h.awprot,waddr_data_packet.awprot);
  output_conv_h.awaddr = waddr_data_packet.awaddr;
  output_conv_h.awqos = waddr_data_packet.awqos;

  foreach(waddr_data_packet.wdata[i]) begin
    if(waddr_data_packet.wdata[i] != 0)begin
      output_conv_h.wdata.push_back(waddr_data_packet.wdata[i]);
      `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wdata[%0d] =  %0h",i,output_conv_h.wdata[i]),UVM_HIGH);
    end
  end

  foreach(waddr_data_packet.wdata[i]) begin
    if(waddr_data_packet.wdata[i] != 0)begin
      output_conv_h.wstrb.push_back(waddr_data_packet.wstrb[i]);
      `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wstrb[%0d] =  %0d",i,output_conv_h.wstrb[i]),UVM_HIGH);
    end
  end

  output_conv_h.wlast = waddr_data_packet.wlast;
  output_conv_h.wuser = waddr_data_packet.wuser;
  $cast(output_conv_h.bid,input_conv_h.bid);
  $cast(output_conv_h.bresp,input_conv_h.bresp);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting =  %s",output_conv_h.sprint()),UVM_HIGH);

endfunction : to_write_addr_data_resp_class

//--------------------------------------------------------------------------------------------
// Function: to_read_addr_data_class
// Converting struct data items into seq_item transactions
//
// Parameters:
// name - axi4_master_tx, axi4_read_transfer_char_s
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadSeqItemConverter::to_read_addr_data_class(input axi4_master_tx raddr_packet, input axi4_read_transfer_char_s input_conv_h, output axi4_master_tx output_conv_h);

  output_conv_h = new();

  $cast(output_conv_h.arid,raddr_packet.arid);
  $cast(output_conv_h.arlen,raddr_packet.arlen);
  $cast(output_conv_h.arsize,raddr_packet.arsize);
  $cast(output_conv_h.arburst,raddr_packet.arburst);
  $cast(output_conv_h.arlock,raddr_packet.arlock);
  $cast(output_conv_h.arcache,raddr_packet.arcache);
  $cast(output_conv_h.arprot,raddr_packet.arprot);
  output_conv_h.araddr = raddr_packet.araddr;
  output_conv_h.arqos = raddr_packet.arqos;
  $cast(output_conv_h.rid,input_conv_h.rid);

  for(int i=0;i<raddr_packet.arlen+1;i++)begin
        output_conv_h.rdata[i] = input_conv_h.rdata[i];
    `uvm_info("axi4_master_seq_item_conv_class",$sformatf("combined read data packet after reading rdata= %0p",output_conv_h.rdata[i]),UVM_FULL);
    end
  
  $cast(output_conv_h.rresp,input_conv_h.rresp);
  
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting read_addr_data_packet =  %s",output_conv_h.sprint()),UVM_HIGH);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);

endfunction : to_read_addr_data_class


//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadSeqItemConverter::do_print(uvm_printer printer);

  axi4_write_transfer_char_s axi4_w_st;
  axi4_read_transfer_char_s axi4_r_st;
  super.do_print(printer);
  printer.print_field("awid",axi4_w_st.awid,$bits(axi4_w_st.awid),UVM_DEC);
  printer.print_field("awlen",axi4_w_st.awlen,$bits(axi4_w_st.awlen),UVM_DEC);
  printer.print_field("awsize",axi4_w_st.awsize,$bits(axi4_w_st.awsize),UVM_BIN);
  printer.print_field("awburst",axi4_w_st.awburst,$bits(axi4_w_st.awburst),UVM_BIN);
  printer.print_field("awlock",axi4_w_st.awlock,$bits(axi4_w_st.awlock),UVM_BIN);
  printer.print_field("awcache",axi4_w_st.awcache,$bits(axi4_w_st.awcache),UVM_BIN);
  printer.print_field("awprot",axi4_w_st.awprot,$bits(axi4_w_st.awprot),UVM_DEC);
  printer.print_field("bid",axi4_w_st.bid,$bits(axi4_w_st.bid),UVM_DEC);
  foreach(axi4_w_st.wdata[i]) begin
    printer.print_field($sformatf("wdata[%0d]",i),axi4_w_st.wdata[i],$bits(axi4_w_st.wdata[i]),UVM_HEX);
  end
  foreach(axi4_w_st.wstrb[i]) begin
    printer.print_field($sformatf("wstrb[%0d]",i),axi4_w_st.wstrb[i],$bits(axi4_w_st.wstrb[i]),UVM_HEX);
  end
 
 printer.print_field("arid",axi4_r_st.arid,$bits(axi4_r_st.arid),UVM_DEC);
 printer.print_field("arlen",axi4_r_st.arlen,$bits(axi4_r_st.arlen),UVM_DEC);
 printer.print_field("arsize",axi4_r_st.arsize,$bits(axi4_r_st.arsize),UVM_BIN);
 printer.print_field("arburst",axi4_r_st.arburst,$bits(axi4_r_st.arburst),UVM_BIN);
 printer.print_field("arlock",axi4_r_st.arlock,$bits(axi4_r_st.arlock),UVM_BIN);
 printer.print_field("arcache",axi4_r_st.arcache,$bits(axi4_r_st.arcache),UVM_BIN);
 printer.print_field("arprot",axi4_r_st.arprot,$bits(axi4_r_st.arprot),UVM_DEC);
 printer.print_field("rresp",axi4_r_st.rresp,$bits(axi4_r_st.rresp),UVM_DEC);
 foreach(axi4_r_st.rdata[i]) begin
   printer.print_field($sformatf("rdata[%0d]",i),axi4_r_st.rdata[i],$bits(axi4_r_st.rdata[i]),UVM_HEX);
 end
endfunction : do_print
*/
`endif
