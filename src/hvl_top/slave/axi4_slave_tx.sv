`ifndef AXI4_SLAVE_TX_INCLUDED_
`define AXI4_SLAVE_TX_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_tx
//  This class holds the data items required to drive stimulus to dut
//  and also holds methods that manipulate those data items
//--------------------------------------------------------------------------------------------
class axi4_slave_tx extends uvm_sequence_item;
  
  `uvm_object_utils(axi4_slave_tx)
  
  //-------------------------------------------------------
  // WRITE ADDRESS CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : awaddr
  //Address selected in axi_slave
  bit [ADDRESS_WIDTH-1:0] awaddr;

  //Variable : awid
  //Used to identify the write transaction for the adress
  awid_e awid;

  //Variable : alen
  //Used to represent the no.of beats in a transaction
  bit [LENGTH-1:0] awlen;

  //Variable : awsize
  //Used to send the write address size
  awsize_e awsize;

  //Variable : awburst
  //Used to send the address burst type
  awburst_e awburst;

  //Variable : awlock
  //Used to send the  write address lock
  awlock_e awlock;

  //Variable : awcache
  //Used to send the write address cache
  awcache_e awcache;

  //Variable : awqos
  //Used to send the write address quality os service
  bit awqos;

  //Variable : addr_write_prot
  //used for different access
  awprot_e awprot;

  //Variable : endian
  //Used to store data in adress location
  endian_e endian;
  
  //-------------------------------------------------------
  // WRITE DATA CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : wdata
  //Used to send the write data 
  bit [DATA_WIDTH-1:0] wdata [$:2**LENGTH];

  //Variable : wstrb
  //Used to hold the valid data byte lanes
  bit [(DATA_WIDTH/8)-1:0] wstrb [$:2**LENGTH];

  //Variable : wlast
  //Used to represent the last byte of the transaction
  bit wlast;

  //Variable : wuser
  //Used to represent the user type
  bit [3:0] wuser;

  //-------------------------------------------------------
  // WRITE RESPONSE CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : bid
  //Used to send the response to particular id
  bid_e bid;

  //Variable : bresp
  //Used to send the write response for the transaction
  rand bresp_e bresp;

  //Variable : buser
  //Used to send the user signal for the transaction
  rand bit [3:0] buser;

  //-------------------------------------------------------
  // READ ADDRESS CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : arid
  //Used to identify the read transaction for the adress
  rand arid_e arid;
  
  //Variable : araddr
  //Address selected in axi_slave
  rand bit [ADDRESS_WIDTH-1:0] araddr;

  //Variable : arlen
  //Used to represent the no.of beats in a transaction
  rand bit [LENGTH-1:0] arlen;

  //Variable : arsize
  //Used to send the write address size
  rand arsize_e arsize;

  //Variable : arburst
  //Used to send the address burst type
  rand arburst_e arburst;
 
  //Variable : awlock
  //Used to send the  write address lock
  rand arlock_e arlock;

  //Variable : awcache
  //Used to send the write address cache
  rand arcache_e arcache;

  //Variable : arprot
  //used for different access
  rand arprot_e arprot;

  //Variable : arregion
  //Used to accept the address region
  bit arregion;
  
  //Variable : arqos
  //Used to send the read address quality of service
  rand bit arqos;

  //-------------------------------------------------------
  // READ DATA CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : rid
  //Used to identify the read data and response
  rand rid_e rid;

  //Variable : rdata
  //Used to send the read data 
  //rand bit [DATA_WIDTH-1:0] rdata [$:DATA_WIDTH];
  rand bit [DATA_WIDTH-1:0] rdata [$:2**LENGTH];

  //Variable : rlast
  //Used to represent the last byte of the transaction
  bit rlast;

  //Variable : rvalid
  //Used to accept the valid address
  bit rvalid;

  //Variable : rresp
  //Used to store the read response
  rand rresp_e rresp ;

  //Variable : ruser
  //Used to store the read user
  rand bit [3:0] ruser;

  //Variable : no_of_wait_states
  //Used to count number of wait states
  rand int no_of_wait_states;
  
  //Variable : tx_type
  //Used to determine the transaction type
  tx_type_e tx_type;
  
  //Variable : transfer_type
  //Used to determine the tranfer type
  transfer_type_e transfer_type;

  //Variable: wait_count_write_address_channel
  //Used to determine wait count for write address channel
  int wait_count_write_address_channel;

  //Variable: wait_count_write_data_channel
  //Used to determine wait count for write data channel
  int wait_count_write_data_channel;
  
  //Variable: wait_count_write_response_channel
  //Used to determine wait count for write response channel
  int wait_count_write_response_channel;

  //Variable: wait_count_read_address_channel
  //Used to determine wait count for write response channel
  int wait_count_read_address_channel;

  //Variable: wait_count_read_data_channel
  //Used to determine wait count for write response channel
  int wait_count_read_data_channel;
  
  //Variable: outstanding_write_tx
  //Used to determine the outstanding write tx count
  int outstanding_write_tx;
  
  //Variable: outstanding_write_tx
  //Used to determine the outstanding write tx count
  int outstanding_read_tx;

  //-------------------------------------------------------
  // Constraints
  //-------------------------------------------------------
  
  //Constraint : rdata_c1
  //Adding constraint to restrict the read data based on awlength
  constraint rdata_c1 { rdata.size() == arlen + 1; 
                        rdata.size() != 0;}
  
  //Constraint : rresp_c1
  //Adding constraint to select the type of read response
  constraint rresp_c1 {soft rresp == READ_OKAY;}

  //Constraint : rresp_c1
  //Adding constraint to select the type of read response
  constraint bresp_c1 {soft bresp == WRITE_OKAY;}

  //Constraint : wait_states_c1             
  //To randomise the wait states in range of 0 to 3
  constraint wait_states_c1 {soft no_of_wait_states inside {[0:3]};}
                    
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_tx");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare (uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);

endclass : axi4_slave_tx

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes the class object
//
// Parameters:
// name - axi4_slave_tx
//--------------------------------------------------------------------------------------------
function axi4_slave_tx::new(string name = "axi4_slave_tx");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: do_copy
// Compare method is implemented using handle rhs
//
// Parameters:
// rhs - handle
//--------------------------------------------------------------------------------------------
function void axi4_slave_tx::do_copy (uvm_object rhs);
  axi4_slave_tx axi_slave_tx_copy_obj;

  if(!$cast(axi_slave_tx_copy_obj,rhs )) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end

  super.do_copy(rhs);
  //WRITE ADDRESS CHANNEL
  awaddr  = axi_slave_tx_copy_obj.awaddr;
  awid    = axi_slave_tx_copy_obj.awid;
  awlen   = axi_slave_tx_copy_obj.awlen;
  awsize  = axi_slave_tx_copy_obj.awsize;
  awburst = axi_slave_tx_copy_obj.awburst;
  awlock  = axi_slave_tx_copy_obj.awlock;
  awcache = axi_slave_tx_copy_obj.awcache;
  awqos   = axi_slave_tx_copy_obj.awqos;
  awprot  = axi_slave_tx_copy_obj.awprot;
  //WRITE DATA CHANNEL
  wdata   = axi_slave_tx_copy_obj.wdata;
  wstrb   = axi_slave_tx_copy_obj.wstrb;
  //WRITE RESPONSE CHANNEL
  bid     = axi_slave_tx_copy_obj.bid;
  bresp   = axi_slave_tx_copy_obj.bresp;
  buser   = axi_slave_tx_copy_obj.buser;
  //READ ADDRESS CHANNEL
  araddr  = axi_slave_tx_copy_obj.araddr;
  arid    = axi_slave_tx_copy_obj.arid;
  arlen   = axi_slave_tx_copy_obj.arlen;
  arsize  = axi_slave_tx_copy_obj.arsize;
  arburst = axi_slave_tx_copy_obj.arburst;
  arregion = axi_slave_tx_copy_obj.arregion;
  arlock  = axi_slave_tx_copy_obj.arlock;
  arcache = axi_slave_tx_copy_obj.arcache;
  arqos   = axi_slave_tx_copy_obj.arqos;
  arprot  = axi_slave_tx_copy_obj.arprot;
  //READ DATA CHANNEL
  rid   = axi_slave_tx_copy_obj.rid;
  rdata = axi_slave_tx_copy_obj.rdata;
  rresp = axi_slave_tx_copy_obj.rresp;
  //OTHERS
  tx_type = axi_slave_tx_copy_obj.tx_type;
  transfer_type = axi_slave_tx_copy_obj.transfer_type;

endfunction : do_copy

//--------------------------------------------------------------------------------------------
//  Function: do_compare
//  Compare method is implemented using handle rhs
//
//  Parameters:
//  comparer - handle
//--------------------------------------------------------------------------------------------
function bit axi4_slave_tx::do_compare (uvm_object rhs, uvm_comparer comparer);
  axi4_slave_tx axi_slave_tx_compare_obj;

  if(!$cast(axi_slave_tx_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_SLAVE_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(axi_slave_tx_compare_obj, comparer) &&
  //WRITE ADDRESS CHANNEL
  awaddr  == axi_slave_tx_compare_obj.awaddr  &&   
  awid    == axi_slave_tx_compare_obj.awid    &&
  awlen   == axi_slave_tx_compare_obj.awlen   &&
  awsize  == axi_slave_tx_compare_obj.awsize  &&
  awburst == axi_slave_tx_compare_obj.awburst &&
  awlock  == axi_slave_tx_compare_obj.awlock  &&
  awcache == axi_slave_tx_compare_obj.awcache &&
  awqos   == axi_slave_tx_compare_obj.awqos   &&
  awprot  == axi_slave_tx_compare_obj.awprot  &&
  //WRITE DATA CHANNEL
  wdata == axi_slave_tx_compare_obj.wdata &&
  wstrb == axi_slave_tx_compare_obj.wstrb &&
  //WRITE RESPONSE CHANNEL
  bid   == axi_slave_tx_compare_obj.bid   &&
  bresp == axi_slave_tx_compare_obj.bresp &&
  buser == axi_slave_tx_compare_obj.buser &&
  //READ ADDRESS CHANNEL
  araddr  == axi_slave_tx_compare_obj.araddr   &&
  arid    == axi_slave_tx_compare_obj.arid     &&
  arlen   == axi_slave_tx_compare_obj.arlen    &&
  arsize  == axi_slave_tx_compare_obj.arsize   &&
  arburst == axi_slave_tx_compare_obj.arburst  &&
  arlock  == axi_slave_tx_compare_obj.arlock   &&
  arcache == axi_slave_tx_compare_obj.arcache  &&
  arqos   == axi_slave_tx_compare_obj.arqos    &&
  arregion== axi_slave_tx_compare_obj.arregion &&
  arprot  == axi_slave_tx_compare_obj.arprot   &&
  //READ DATA CHANNEL
  rid   == axi_slave_tx_compare_obj.rid   &&  
  rdata == axi_slave_tx_compare_obj.rdata && 
  rresp == axi_slave_tx_compare_obj.rresp &&
  ruser == axi_slave_tx_compare_obj.ruser;
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void axi4_slave_tx::do_print(uvm_printer printer);
  printer.print_string("tx_type",tx_type.name());
  if(tx_type == WRITE) begin
    //`uvm_info("------------------------------------------WRITE_ADDRESS_CHANNEL","------------------------------------",UVM_LOW);
    printer.print_string("awid",awid.name());
    printer.print_field("awaddr",awaddr,$bits(awaddr),UVM_HEX);
    printer.print_field("awlen",awlen,$bits(awlen),UVM_DEC);
    printer.print_string("awsize",awsize.name());
    printer.print_string("awburst",awburst.name());
    printer.print_string("awlock",awlock.name());
    printer.print_string("awcache",awcache.name());
    printer.print_string("awprot",awprot.name());
    printer.print_field("awqos",awqos,$bits(awqos),UVM_HEX);
    //`uvm_info("------------------------------------------WRITE_DATA_CHANNEL","---------------------------------------",UVM_LOW);
    foreach(wdata[i]) begin
      printer.print_field($sformatf("wdata[%0d]",i),wdata[i],$bits(wdata[i]),UVM_HEX);
    end
    foreach(wstrb[i]) begin
      printer.print_field($sformatf("wstrb[%0d]",i),wstrb[i],$bits(wstrb[i]),UVM_HEX);
    end
    printer.print_field("wlast",wlast,$bits(wlast),UVM_DEC);
    printer.print_field("wuser",wuser,$bits(wuser),UVM_DEC);
    //`uvm_info("------------------------------------------WRITE_RESPONSE_CHANNEL","-----------------------------------",UVM_LOW);
    printer.print_string("bid",bid.name());
    printer.print_string("bresp",bresp.name());
    printer.print_field("buser",buser,$bits(buser),UVM_DEC);
  end
  else if(tx_type == READ) begin
    //`uvm_info("------------------------------------------READ_ADDRESS_CHANNEL","-------------------------------------",UVM_LOW);
    printer.print_string("arid",arid.name());
    printer.print_field("araddr",araddr,$bits(araddr),UVM_HEX);
    printer.print_field("arlen",arlen,$bits(arlen),UVM_DEC);
    printer.print_string("arsize",arsize.name());
    printer.print_string("arburst",arburst.name());
    printer.print_string("arlock",arlock.name());
    printer.print_string("arcache",arcache.name());
    printer.print_string("arprot",arprot.name());
    printer.print_field("arqos",arqos,$bits(arqos),UVM_HEX);
    //`uvm_info("------------------------------------------READ_DATA_CHANNEL","----------------------------------------",UVM_LOW);
    printer.print_string("rid",rid.name());
    foreach(rdata[i])begin
      printer.print_field($sformatf("rdata[%0d]",i),rdata[i],$bits(rdata[i]),UVM_HEX);
    end
    printer.print_string("rresp",rresp.name());
    printer.print_field("ruser",ruser,$bits(ruser),UVM_HEX);
    printer.print_field("no_of_wait_states",no_of_wait_states,$bits(no_of_wait_states),UVM_HEX);
  end
endfunction : do_print

`endif

