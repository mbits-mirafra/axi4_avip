`ifndef AXI4_SLAVE_SEQ_ITEM_CONVERTER_INCLUDED_
`define AXI4_SLAVE_SEQ_ITEM_CONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_seq_item_converter
// Description:
// class for converting the transaction items to struct and vice versa
//--------------------------------------------------------------------------------------------
class axi4_slave_seq_item_converter extends uvm_object;
  `uvm_object_utils(axi4_slave_seq_item_converter)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_seq_item_converter");
  extern static function void from_write_class(input axi4_slave_tx input_conv_h, output axi4_write_transfer_char_s output_conv);
  extern static function void from_read_class(input axi4_slave_tx input_conv_h, output axi4_read_transfer_char_s output_conv);
  extern static function void to_write_class(input axi4_write_transfer_char_s input_conv_h, output axi4_slave_tx output_conv_h);
  extern static function void to_read_class(input axi4_read_transfer_char_s input_conv_h, output axi4_slave_tx output_conv_h);
  
  extern static function void tx_write_packet(input axi4_slave_tx input_addr_h, input axi4_slave_tx input_data_h,input axi4_slave_tx input_resp_h,output axi4_slave_tx packet_h);
  extern static function void tx_read_packet(input axi4_slave_tx input_addr_h, input axi4_slave_tx input_data_h,output axi4_slave_tx packet_h);

  extern static function void to_write_addr_data_class(input axi4_slave_tx waddr_packet, input axi4_write_transfer_char_s input_conv_h,output axi4_slave_tx output_conv_h);
  extern static function void to_write_addr_data_resp_class(input axi4_slave_tx waddr_data_packet, input axi4_write_transfer_char_s input_conv_h,output axi4_slave_tx output_conv_h);
  extern static function void to_read_addr_data_class(input axi4_slave_tx raddr_packet, input axi4_read_transfer_char_s input_conv_h,output axi4_slave_tx output_conv_h);
  
  extern function void do_print(uvm_printer printer);

endclass : axi4_slave_seq_item_converter
//------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
// name - axi4_slave_seq_item_converter
//--------------------------------------------------------------------------------------------
function axi4_slave_seq_item_converter::new(string name = "axi4_slave_seq_item_converter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------      
// Function: from_write_class                                                                             
// Converting seq_item transactions into struct data items                                          
//                                                                                                  
// Parameters:                                                                                      
// name - axi4_slave_tx, axi4_write_transfer_char_s                                                      
//--------------------------------------------------------------------------------------------      
function void axi4_slave_seq_item_converter::from_write_class(input axi4_slave_tx input_conv_h,output axi4_write_transfer_char_s output_conv);

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
   
  $cast(output_conv.awid,input_conv_h.awid); 
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awid =  %b",output_conv.awid),UVM_FULL);
  
  $cast(output_conv.awlen,input_conv_h.awlen); 
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awlen =  %b",output_conv.awlen),UVM_FULL);
  
  $cast(output_conv.awsize,input_conv_h.awsize);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomizing awsize =  %b",output_conv.awsize),UVM_FULL);
  
  $cast(output_conv.awburst,input_conv_h.awburst);  
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awburst =  %b",output_conv.awburst),UVM_FULL);
   
  $cast(output_conv.awlock,input_conv_h.awlock);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awlock =  %b",output_conv.awlock),UVM_FULL);
 
  $cast(output_conv.awcache,input_conv_h.awcache);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomizing awcache =  %b",output_conv.awcache),UVM_FULL);
   
  $cast(output_conv.awprot,input_conv_h.awprot);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomizing awprot =  %b",output_conv.awprot),UVM_FULL);
   
  $cast(output_conv.bid,input_conv_h.bid);   
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize bid =  %b",output_conv.bid),UVM_FULL);

   output_conv.awqos = input_conv_h.awqos;   
   `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig awqos =  %0h",output_conv.awqos),UVM_FULL);
   
   foreach(input_conv_h.wdata[i]) begin
     if(input_conv_h.wdata[i] != 0)begin
      output_conv.wdata[i] = input_conv_h.wdata[i];
      `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig wdata = %0h",output_conv.wdata[i]),UVM_FULL);
    end
   end
   
   foreach(input_conv_h.wstrb[i]) begin
     output_conv.wstrb[i] = input_conv_h.wstrb[i];
     `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig wstrb[%0d] =  %0h",i,output_conv.wstrb[i]),UVM_FULL);
   end

  $cast(output_conv.bresp,input_conv_h.bresp);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize bresp =  %b",output_conv.bresp),UVM_FULL);                        

  output_conv.awaddr = input_conv_h.awaddr;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig awaddr =  %0h",output_conv.awaddr),UVM_FULL);
  
  output_conv.no_of_wait_states = input_conv_h.no_of_wait_states;
  
  output_conv.wait_count_write_address_channel =input_conv_h.wait_count_write_address_channel ;
  output_conv.wait_count_write_data_channel =input_conv_h.wait_count_write_data_channel ;
  output_conv.wait_count_write_response_channel =input_conv_h.wait_count_write_response_channel ;

endfunction : from_write_class
//--------------------------------------------------------------------------------------------      
// Function: from_read_class                                                                             
// Converting seq_item transactions into struct data items                                          
//                                                                                                  
// Parameters:                                                                                      
// name - axi4_slave_tx, axi4_read_transfer_char_s                                                      
//--------------------------------------------------------------------------------------------      

function void axi4_slave_seq_item_converter::from_read_class(input axi4_slave_tx input_conv_h,output axi4_read_transfer_char_s output_conv);

  $cast(output_conv.arid,input_conv_h.arid);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arid =  %b",output_conv.arid),UVM_FULL);

  $cast(output_conv.arlen,input_conv_h.arlen);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arlen =  %b",output_conv.arlen),UVM_FULL);

  $cast(output_conv.arsize,input_conv_h.arsize);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arsize =  %b",output_conv.arsize),UVM_FULL);

  $cast(output_conv.arburst,input_conv_h.arburst);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arburst =  %b",output_conv.arburst),UVM_FULL);

  $cast(output_conv.arlock,input_conv_h.arlock);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arlock =  %b",output_conv.arlock),UVM_FULL);

  $cast(output_conv.arcache,input_conv_h.arcache);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arcache =  %b",output_conv.arcache),UVM_FULL);

  $cast(output_conv.arprot,input_conv_h.arprot);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arprot =  %b",output_conv.arprot),UVM_FULL);

  $cast(output_conv.rresp,input_conv_h.rresp);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize rresp =  %b",output_conv.rresp),UVM_FULL);
  
  output_conv.araddr = input_conv_h.araddr;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig araddr =  %0h",output_conv.araddr),UVM_FULL);

  output_conv.arqos = input_conv_h.arqos;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig arqos =  %0h",output_conv.arqos),UVM_FULL);

  foreach(input_conv_h.rdata[i]) begin
    if(input_conv_h.rdata[i] != 0)begin
      output_conv.rdata[i] = input_conv_h.rdata[i];
      `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig rdata = %0p",output_conv.rdata[i]),UVM_FULL);
    end
  end

  output_conv.araddr = input_conv_h.araddr;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig araddr =  %0h",output_conv.araddr),UVM_FULL);
  
  output_conv.wait_count_read_address_channel =input_conv_h.wait_count_read_address_channel ;
  output_conv.wait_count_read_data_channel =input_conv_h.wait_count_read_data_channel ;

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_FULL);
  
endfunction : from_read_class  

//--------------------------------------------------------------------------------------------      
// Function: to_write_class                                                                               
// Converting struct data items into seq_item transactions                                          
// Parameters:                                                                                      
// name - axi4_slave_tx, axi4_write_transfer_char_s                                                      
//--------------------------------------------------------------------------------------------      


function void axi4_slave_seq_item_converter::to_write_class(input axi4_write_transfer_char_s input_conv_h, output axi4_slave_tx output_conv_h);

  int i;
  output_conv_h = new();

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_FULL);
  
  output_conv_h.tx_type = WRITE; 
 
  $cast(output_conv_h.awid,input_conv_h.awid); 
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awid =  %b",output_conv_h.awid),UVM_FULL);

  $cast(output_conv_h.awlen,input_conv_h.awlen);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awlen =  %b",output_conv_h.awlen),UVM_FULL);

  $cast(output_conv_h.awsize,input_conv_h.awsize);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomizing awsize =  %b",output_conv_h.awsize),UVM_FULL);

  $cast(output_conv_h.awburst,input_conv_h.awburst); 
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awburst =  %b",output_conv_h.awburst),UVM_FULL);

  $cast(output_conv_h.awlock,input_conv_h.awlock);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize awlock =  %b",output_conv_h.awlock),UVM_FULL);

  $cast(output_conv_h.awcache,input_conv_h.awcache);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomizing awcache =  %b",output_conv_h.awcache),UVM_FULL);

  $cast(output_conv_h.awprot,input_conv_h.awprot);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomizing awprot =  %b",output_conv_h.awprot),UVM_FULL);

  $cast(output_conv_h.bid,input_conv_h.bid);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize bid =  %b",output_conv_h.bid),UVM_FULL);

  $cast(output_conv_h.bresp,input_conv_h.bresp);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize bresp =  %b",output_conv_h.bresp),UVM_FULL);

  output_conv_h.awaddr = input_conv_h.awaddr;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig awaddr =  %0h",output_conv_h.awaddr),UVM_FULL);

  output_conv_h.awqos = input_conv_h.awqos;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig awqos =  %0h",output_conv_h.awqos),UVM_FULL);

  while(input_conv_h.wdata[i]!==0) begin
      output_conv_h.wdata[i] = input_conv_h.wdata[i];
      i++;
  end
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig wdata to class = \n %0s",output_conv_h.sprint()),UVM_FULL);

  for(int i=0;i<input_conv_h.wdata[i];i++) begin
      output_conv_h.wstrb[i] = input_conv_h.wstrb[i];
  end
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after writnig wstrb to class = \n %0s",output_conv_h.sprint()),UVM_FULL);
  
  output_conv_h.wlast = input_conv_h.wlast;

endfunction : to_write_class


//--------------------------------------------------------------------------------------------      
// Function: to_read_class                                                                               
// Converting struct data items into seq_item transactions                                          
// Parameters:                                                                                      
// name - axi4_slave_tx, axi4_read_transfer_char_s                                                      
//--------------------------------------------------------------------------------------------      
function void axi4_slave_seq_item_converter::to_read_class( input axi4_read_transfer_char_s input_conv_h, output axi4_slave_tx output_conv_h);
 int i;
  output_conv_h = new();

  $cast(output_conv_h.arid,input_conv_h.arid);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arid =  %b",output_conv_h.arid),UVM_FULL);
  
  $cast(output_conv_h.rid,input_conv_h.rid);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize rid =  %b",output_conv_h.rid),UVM_FULL);

  $cast(output_conv_h.arlen,input_conv_h.arlen);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arlen =  %b",output_conv_h.arlen),UVM_FULL);

  $cast(output_conv_h.arsize,input_conv_h.arsize);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arsize =  %b",output_conv_h.arsize),UVM_FULL);

  $cast(output_conv_h.arburst,input_conv_h.arburst);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arburst =  %b",output_conv_h.arburst),UVM_FULL);

  $cast(output_conv_h.arlock,input_conv_h.arlock);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arlock =  %b",output_conv_h.arlock),UVM_FULL);

  $cast(output_conv_h.arcache,input_conv_h.arcache);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arcache =  %b",output_conv_h.arcache),UVM_FULL);

  $cast(output_conv_h.arprot,input_conv_h.arprot);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize arprot =  %b",output_conv_h.arprot),UVM_FULL);

  foreach(input_conv_h.rresp[i]) begin
    $cast(output_conv_h.rresp,input_conv_h.rresp[i]);
  end
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After randomize rresp =  %b",output_conv_h.rresp),UVM_FULL);

  output_conv_h.araddr = input_conv_h.araddr;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after reading araddr =  %0h",output_conv_h.araddr),UVM_FULL);

  output_conv_h.arqos = input_conv_h.arqos;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after reading arqos =  %0h",output_conv_h.arqos),UVM_FULL);

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after reading arlength = \n %0d",input_conv_h.arlen),UVM_FULL);

  while(input_conv_h.rdata[i] != 0)begin
      output_conv_h.rdata[i] = input_conv_h.rdata[i];
      i++;
    end
    `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after reading rdata = \n %0s",output_conv_h.sprint()),UVM_FULL);

  output_conv_h.araddr = input_conv_h.araddr;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("after reading araddr =  %0h",output_conv_h.araddr),UVM_FULL);

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_FULL);
endfunction : to_read_class

//--------------------------------------------------------------------------------------------
// Function: tx_write_packet                                                                               
// Used to combine write address and write data and write response into  single packet
// Parameters:                                                                                      
// name - axi4_slave_tx   
//--------------------------------------------------------------------------------------------
function  void axi4_slave_seq_item_converter::tx_write_packet(input axi4_slave_tx input_addr_h,
  input axi4_slave_tx input_data_h,input axi4_slave_tx input_resp_h,output axi4_slave_tx packet_h);
 
  int i;
  packet_h = new();

  packet_h.tx_type=WRITE;
  packet_h.awaddr=input_addr_h.awaddr;
  packet_h.awid=input_addr_h.awid;
  packet_h.awlen=input_addr_h.awlen;
  packet_h.awsize=input_addr_h.awsize;
  packet_h.awburst=input_addr_h.awburst;
  packet_h.awqos=input_addr_h.awqos;
  packet_h.awprot=input_addr_h.awprot;
  packet_h.awlock=input_addr_h.awlock;
  packet_h.awcache=input_addr_h.awcache;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("combined addr packet=\n%s",packet_h.sprint),UVM_FULL);

  while(input_data_h.wdata[i]!==0) begin
    packet_h.wdata[i]= input_data_h.wdata[i];
    i++;
  end

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("combined data packet after writing wdata= %0p",packet_h.wdata[i]),UVM_FULL);

  for(int i=0;i<input_data_h.wdata[i];i++) begin
    packet_h.wstrb[i] = input_data_h.wstrb[i];
  end
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("combined packet for strobe after writing wstrb =  %0p",packet_h.wstrb[i]),UVM_FULL);
  
  packet_h.wlast=input_data_h.wlast;
  
  packet_h.bid=input_resp_h.bid;
  packet_h.bresp=input_resp_h.bresp;

  `uvm_info("DEBUG_COMBINED_PACKET_CLASS",$sformatf("Final packet= \n %s",packet_h.sprint),UVM_FULL);

endfunction : tx_write_packet

//--------------------------------------------------------------------------------------------
// Function: tx_read_packet                                                                               
// Used to combine raed address and read data into single packet
// Parameters:                                                                                      
// name - axi4_slave_tx   
//--------------------------------------------------------------------------------------------
function  void axi4_slave_seq_item_converter::tx_read_packet(input axi4_slave_tx input_addr_h,
  input axi4_slave_tx input_data_h,output axi4_slave_tx packet_h);
  
  int i;
  packet_h = new();

  packet_h.araddr=input_addr_h.araddr;
  packet_h.arid=input_addr_h.arid;
  packet_h.arlen=input_addr_h.arlen;
  packet_h.arsize=input_addr_h.arsize;
  packet_h.arburst=input_addr_h.arburst;
  packet_h.arqos=input_addr_h.arqos;
  packet_h.arprot=input_addr_h.arprot;
  packet_h.arlock=input_addr_h.arlock;
  packet_h.arcache=input_addr_h.arcache;
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("combined read addr packet=\n%s",packet_h.sprint),UVM_FULL);
  
  packet_h.rid=input_data_h.rid;
  
  for(int i=0;i<input_addr_h.arlen+1;i++)begin
    for(int j=0;j<(2**(input_addr_h.arsize));j++)begin
      packet_h.rdata[i][8*j+7 -: 8] = input_data_h.rdata[j*8+i];
    end
  end
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("combined read data packet after reading rdata= %0p",packet_h.rdata[i]),UVM_FULL);

   packet_h.rresp=input_data_h.rresp;
   packet_h.rlast=input_data_h.rlast;

  `uvm_info("DEBUG_COMBINED_PACKET_CLASS",$sformatf("Final read packet= \n %s",packet_h.sprint),UVM_FULL);

endfunction : tx_read_packet


//--------------------------------------------------------------------------------------------
// Function: to_write_addr_data_class
// Converting struct data items into seq_item transactions
//
// Parameters:
// name - axi4_slave_tx, axi4_write_transfer_char_s
//--------------------------------------------------------------------------------------------
function void axi4_slave_seq_item_converter::to_write_addr_data_class(input axi4_slave_tx waddr_packet, 
  input axi4_write_transfer_char_s input_conv_h, output axi4_slave_tx output_conv_h);
  
  output_conv_h = new();

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
 

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
      `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After converting wdata[%0d] =  %0h",i,output_conv_h.wdata[i]),UVM_HIGH);
    end
  end

  foreach(input_conv_h.wdata[i]) begin
    if(input_conv_h.wdata[i] != 0)begin
      output_conv_h.wstrb.push_front(input_conv_h.wstrb[i]);
      `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After converting wstrb[%0d] =  %0d",i,output_conv_h.wstrb[i]),UVM_HIGH);
    end
  end

  output_conv_h.wlast = input_conv_h.wlast;
  output_conv_h.wuser = input_conv_h.wuser;
  $cast(output_conv_h.bid,input_conv_h.bid);
  $cast(output_conv_h.bresp,input_conv_h.bresp);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After converting =  %s",output_conv_h.sprint()),UVM_HIGH);

endfunction : to_write_addr_data_class

//--------------------------------------------------------------------------------------------
// Function: to_write_addr_data_resp_class
// Converting struct data items into seq_item transactions
//
// Parameters:
// name - axi4_slave_tx, axi4_write_transfer_char_s
//--------------------------------------------------------------------------------------------
function void axi4_slave_seq_item_converter::to_write_addr_data_resp_class(input axi4_slave_tx waddr_data_packet, 
  input axi4_write_transfer_char_s input_conv_h, output axi4_slave_tx output_conv_h);
  
  output_conv_h = new();

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
 

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
      `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After converting wdata[%0d] =  %0h",i,output_conv_h.wdata[i]),UVM_HIGH);
    end
  end

  foreach(waddr_data_packet.wdata[i]) begin
    if(waddr_data_packet.wdata[i] != 0)begin
      output_conv_h.wstrb.push_back(waddr_data_packet.wstrb[i]);
      `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After converting wstrb[%0d] =  %0d",i,output_conv_h.wstrb[i]),UVM_HIGH);
    end
  end

  output_conv_h.wlast = waddr_data_packet.wlast;
  output_conv_h.wuser = waddr_data_packet.wuser;
  $cast(output_conv_h.bid,input_conv_h.bid);
  $cast(output_conv_h.bresp,input_conv_h.bresp);
  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After converting =  %s",output_conv_h.sprint()),UVM_HIGH);

endfunction : to_write_addr_data_resp_class

//--------------------------------------------------------------------------------------------
// Function: to_read_addr_data_class
// Converting struct data items into seq_item transactions
//
// Parameters:
// name - axi4_slave_tx, axi4_read_transfer_char_s
//--------------------------------------------------------------------------------------------
function void axi4_slave_seq_item_converter::to_read_addr_data_class(input axi4_slave_tx raddr_packet, 
  input axi4_read_transfer_char_s input_conv_h, output axi4_slave_tx output_conv_h);

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
    `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("combined read data packet after reading rdata= %0p",output_conv_h.rdata[i]),UVM_FULL);
  end
  
  $cast(output_conv_h.rresp,input_conv_h.rresp);

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("After converting read_addr_data_packet =  %s",output_conv_h.sprint()),UVM_HIGH);

  `uvm_info("axi4_slave_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
endfunction : to_read_addr_data_class

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void axi4_slave_seq_item_converter::do_print(uvm_printer printer);


  axi4_write_transfer_char_s axi4_w_st;
  axi4_read_transfer_char_s axi4_r_st;
  super.do_print(printer);

  printer.print_field("awid",axi4_w_st.awid,$bits(axi4_w_st.awid),UVM_HEX);
  printer.print_field("awlen",axi4_w_st.awlen,$bits(axi4_w_st.awlen),UVM_HEX);
  printer.print_field("awsize",axi4_w_st.awsize,$bits(axi4_w_st.awsize),UVM_DEC);
  printer.print_field("awburst",axi4_w_st.awburst,$bits(axi4_w_st.awburst),UVM_DEC);
  printer.print_field("awlock",axi4_w_st.awlock,$bits(axi4_w_st.awlock),UVM_DEC);
  printer.print_field("awcache",axi4_w_st.awcache,$bits(axi4_w_st.awcache),UVM_DEC);
  printer.print_field("awprot",axi4_w_st.awprot,$bits(axi4_w_st.awprot),UVM_HEX);
  printer.print_field("bid",axi4_w_st.bid,$bits(axi4_w_st.bid),UVM_HEX);
 
  printer.print_field("arid",axi4_r_st.arid,$bits(axi4_r_st.arid),UVM_HEX);
  printer.print_field("arlen",axi4_r_st.arlen,$bits(axi4_r_st.arlen),UVM_HEX);
  printer.print_field("arsize",axi4_r_st.arsize,$bits(axi4_r_st.arsize),UVM_DEC);
  printer.print_field("arburst",axi4_r_st.arburst,$bits(axi4_r_st.arburst),UVM_DEC);
  printer.print_field("arlock",axi4_r_st.arlock,$bits(axi4_r_st.arlock),UVM_DEC);
  printer.print_field("arcache",axi4_r_st.arcache,$bits(axi4_r_st.arcache),UVM_DEC);
  printer.print_field("arprot",axi4_r_st.arprot,$bits(axi4_r_st.arprot),UVM_HEX);
  printer.print_field("rresp",axi4_r_st.rresp,$bits(axi4_r_st.rresp),UVM_HEX);
 
  foreach(axi4_r_st.rdata[i]) begin
    printer.print_field($sformatf("rdata[%0d]",i),axi4_r_st.rdata[i],$bits(axi4_r_st.rdata[i]),UVM_HEX);
  end

endfunction : do_print

`endif
