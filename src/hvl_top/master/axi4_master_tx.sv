`ifndef AXI4_MASTER_TX_INCLUDED_
`define AXI4_MASTER_TX_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_master_tx
// This class holds the data items required to drive the stimulus to dut
// and also holds methods that manipulate those data items.
//--------------------------------------------------------------------------------------------
class axi4_master_tx extends uvm_sequence_item;
  
  `uvm_object_utils(axi4_master_tx)

  axi4_master_agent_config axi4_master_agent_cfg_h; 
  
  //-------------------------------------------------------
  // WRITE ADDRESS CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : awid
  //Used to send the write address id
  rand awid_e awid;

  //Variable : awaddr
  //Used to send the write address
  rand bit [ADDRESS_WIDTH-1:0] awaddr;

  //Variable : awlen
  //Used to send the write address length
  rand bit [LENGTH-1:0] awlen;

  //Variable : awsize
  //Used to send the write address size
  rand awsize_e awsize;
  
  //Variable : awburst
  //Used to send the write address burst
  rand awburst_e awburst;

  //Variable : awlock
  //Used to send the write address lock
  rand awlock_e awlock;
  
  //Variable : awcache
  //Used to send the write address cache
  rand awcache_e awcache;

  //Variable : awprot
  //Used to send the write address prot
  rand awprot_e awprot;

  //Variable : awqos
  //Used to send the write address quality of service
  rand bit [3:0] awqos;

  //Variable : awregion
  //Used to send the write address region selected
  rand bit [3:0] awregion;

  //Variable : awuser
  //Used to send the write address user
  rand bit awuser;

  //-------------------------------------------------------
   // WRITE DATA CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : wdata
  //Used to randomise write data
  //varaible[$] gives a unbounded queue
  //variable[$:value] gives a bounded queue to a value of given value 
  rand bit [DATA_WIDTH-1:0] wdata [$:2**LENGTH];

  //Variable : wstrb
  //Used to randomise write strobe
  //varaible[$] gives a unbounded queue
  //variable[$:value] gives a bounded queue to a value of given value 
  rand bit [(DATA_WIDTH/8)-1:0] wstrb [$:2**LENGTH];

  //Variable : wlast
  //Used to store the write last transfer
  bit wlast;

  //Variable : wuser
  //Used to send the user bit value
  rand bit [3:0] wuser;

  //-------------------------------------------------------
  // WRITE RESPONSE CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : bid
  //Used to send the response id
  bid_e bid;

  //Variable : bresp
  //Used to capture the write response of the trasnaction
  bresp_e bresp;
  
  //Variable : buser
  //Used to capture the buser
  bit buser;

  //-------------------------------------------------------
  // READ ADDRESS CHANNEL SIGNALS
  //-------------------------------------------------------
  //Variable : arid
  //Used to send the read address id
  rand arid_e arid;
 
  //Variable : araddr
  //Used to send the read address
  rand bit [ADDRESS_WIDTH-1:0] araddr;

  //Variable : arlen
  //Used to send the read address length
  rand bit [LENGTH-1:0] arlen;

  //Variable : arsize
  //Used to send the read address size
  rand arsize_e arsize;
  
  //Variable : arburst
  //Used to send the read address burst
  rand arburst_e arburst;

  //Variable : arlock
  //Used to send the read address lock
  rand arlock_e arlock;
  
  //Variable : arcache
  //Used to send the read address cache
  rand arcache_e arcache;

  //Variable : arprot
  //Used to send the read address prot
  rand arprot_e arprot;

  //Variable : arqos
  //Used to send the read address quality of service
  rand bit [3:0] arqos;

  //Variable : aruser
  //Used to send the read address user data
  rand bit aruser;

  //Variable : arregion
  //Used to send the read address region data
  rand bit arregion;

  //-------------------------------------------------------
  // READ DATA CHANNEL SIGNALS 
  //-------------------------------------------------------
  //Variable : rid
  //Used to send the read address id
  rid_e rid;
  
  //Variable : rdata
  //Used to randomise read data
  //varaible[$] gives a unbounded queue
  //variable[$:value] gives a bounded queue to a value of given value 
  bit [DATA_WIDTH-1:0] rdata [$:2**LENGTH];

  //Variable : rresp
  //Used to capture the read response of the trasnaction
  rresp_e rresp;

  //Variable : rlast
  //Used to store the read last transfer
  bit rlast;

  //Variable : ruser
  //Used to read the read user value
  bit ruser;
  
  //Variable : endian
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
  // WRITE ADDRESS Constraints
  //-------------------------------------------------------
  //Constraint : awaddr
  //Used to generate the alligned address with respect to size
  constraint awaddr_c0 {soft awaddr == (awaddr%(2**awsize)) == 0;}

  //Constraint : awburst_c1
  //Restricting write burst to select only FIXED, INCR and WRAP types
  constraint awburst_c1 {awburst != WRITE_RESERVED;}

  //Constraint : awlength_c2
  //Adding constraint for restricting write trasnfers
  constraint awlength_c2 {if(awburst==WRITE_FIXED || WRITE_WRAP)
                              awlen inside {[0:15]};
                          else if(awburst == WRITE_INCR) 
                              awlen inside {[0:255]};}

  //Constraint : awlength_c3
  //Adding constraint for restricting to get multiples of 2 in wrap burst
  constraint awlength_c3 {if(awburst == WRITE_WRAP)
                          awlen + 1 inside {2,4,8,16};}
  
  //Constraint : awlock_c4
  //Adding constraint to select the lock transfer type
  constraint awlock_c4 {soft awlock == WRITE_NORMAL_ACCESS;}

  //Constraint : awburst_c5
  //Adding a soft constraint to detrmine the burst type
  constraint awburst_c5 {soft awburst == WRITE_INCR;}

  //Constraint : awsize_c6
  //Adding a soft constraint to detrmine the awsize
  constraint awsize_c6 {soft awsize inside {[0:2]};}

  //-------------------------------------------------------
  // WRITE DATA Constraints
  //-------------------------------------------------------
  //Constraint : wdata_c1
  //Adding constraint to restrict the write data based on awlength
  constraint wdata_c1 {wdata.size() == awlen + 1;} 

  //Constraint : wstrb_c2
  //Adding constraint to restrict the write strobe based on awlength
  constraint wstrb_c2 {wstrb.size() == awlen + 1;}

  //Constraint : wstrb_c3
  //wstrb shouldn't be zero
  constraint wstrb_c3 {foreach(wstrb[i]) wstrb[i]!=0; }

  //Constraint: wstrb_c4
  //based on size setting the strobe values
  constraint wstrb_c4 {foreach(wstrb[i]) $countones(wstrb[i]) == 2**awsize;}

  //Constraint : no_of_wait_states_c3
  //Adding constraint to restrict the number of wait states for response
  constraint no_of_wait_states_c3 {no_of_wait_states inside {[0:3]};}
  
  //-------------------------------------------------------
  // READ ADDRESS Constraints
  //-------------------------------------------------------
  
  //Constraint : araddr
  //Used to generate the alligned address with respect to size
  constraint araddr_c0 {soft araddr == (araddr%(2**arsize)) == 0;}
  
  //Constraint : arburst_c1
  //Restricting read burst to select only FIXED, INCR and WRAP types
  constraint arburst_c1 { arburst != READ_RESERVED;}

  //Constraint : arlength_c2
  //Adding constraint for restricting read trasnfers
  constraint arlength_c2 { if(arburst==READ_FIXED || READ_WRAP)
                            arlen inside {[0:15]};
                           else if(arburst == READ_INCR) 
                            arlen inside {[0:255]};
                         }
  
  //Constraint : arlength_c3
  //Adding constraint for restricting to get multiples of 2 in wrap burst
  constraint arlength_c3 { if(arburst == READ_WRAP)
                            arlen + 1 inside {2,4,8,16};
                         }

  //Constraint : arlock_c9
  //Adding constraint to select the lock transfer type
  constraint arlock_c4 { soft arlock == READ_NORMAL_ACCESS;}

  //Constraint : arburst_c5
  //Adding a soft constraint to detrmine the burst type
  constraint arburst_c5 { soft arburst == READ_INCR;}

  //Constraint : arsize_c6
  //Adding a soft constraint to detrmine the arsize
  constraint arsize_c6 { soft arsize inside {[0:2]};}

  //-------------------------------------------------------
  // Memory Constraints
  //-------------------------------------------------------
  //Constraint : endian_c1
  //Adding constraint to select the endianess
  constraint endian_c1 { soft endian == LITTLE_ENDIAN;}

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new (string name = "axi4_master_tx");
  extern function void do_copy(uvm_object rhs);
  extern function void post_randomize();
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
endclass : axi4_master_tx

//--------------------------------------------------------------------------------------------
// Construct: new
// initializes the class object
//
// Parameters:
// name - axi4_master_tx
//--------------------------------------------------------------------------------------------
function axi4_master_tx::new(string name = "axi4_master_tx");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function : post_randomize 
// Implements the narrow transfers and unalligned transfers
//--------------------------------------------------------------------------------------------
function void axi4_master_tx::post_randomize();
//-------------------------------------------------------
// Strobes for alligned with narrow transfers and
// Unalligned transfers
//-------------------------------------------------------
begin //{
  bit[STROBE_WIDTH-1:0]  remainder_check;
  // strobe_data provides you the strobe for starting addr
  bit [STROBE_WIDTH-1:0] strobe_data[int][1];

  // for awsize =0 which means 1B need to transfer 
  // for this case always addrs will be alligned
  // because remainder always be 0... in this case

  bit [STROBE_WIDTH-1:0] local_addr;
  bit [STROBE_WIDTH-1:0] min;
  bit [STROBE_WIDTH-1:0] shift_loc;

  remainder_check = (awaddr%(STROBE_WIDTH));
  min = (awsize == 1) ? {2{1'b1}} : ((awsize == 2) ? {4{1'b1}} : ((awsize == 3) ? {8{1'b1}} :
  ((awsize == 4) ? {16{1'b1}} : ((awsize == 5) ? {32{1'b1}} : ((awsize == 6) ? {64{1'b1}} : {128{1'b1}})))));

  for(int l=0;l<STROBE_WIDTH;l++) begin
    if((remainder_check+l)%2**awsize == 0) begin
      shift_loc = remainder_check+l;
      break;
    end
  end
  if(awsize == 0) begin
    strobe_data[STROBE_WIDTH][0][remainder_check] = 1'b1;
  end
  else begin
    if(awaddr % 2**awsize != 0) begin
        unique case(awsize)
          1: strobe_data[STROBE_WIDTH][0] = 1'b1 << remainder_check;
          2: strobe_data[STROBE_WIDTH][0] = ({STROBE_WIDTH{1'b1}} << remainder_check) & ~({STROBE_WIDTH{1'b1}} << (4*(awaddr/2**awsize)+4));
          3: strobe_data[STROBE_WIDTH][0] = ({STROBE_WIDTH{1'b1}} << remainder_check) & ~({STROBE_WIDTH{1'b1}} << (8*(awaddr/2**awsize)+8));
          4: strobe_data[STROBE_WIDTH][0] = ({STROBE_WIDTH{1'b1}} << remainder_check) & ~({STROBE_WIDTH{1'b1}} << (16*(awaddr/2**awsize)+16));
          5: strobe_data[STROBE_WIDTH][0] = ({STROBE_WIDTH{1'b1}} << remainder_check) & ~({STROBE_WIDTH{1'b1}} << (32*(awaddr/2**awsize)+32));
          6: strobe_data[STROBE_WIDTH][0] = ({STROBE_WIDTH{1'b1}} << remainder_check) & ~({STROBE_WIDTH{1'b1}} << (64*(awaddr/2**awsize)+64));
          7: strobe_data[STROBE_WIDTH][0] = ({STROBE_WIDTH{1'b1}} << remainder_check) & ~({STROBE_WIDTH{1'b1}} << (128*(awaddr/2**awsize)+128));
        endcase
    end
    else begin  //{ alligned address
        unique case(awsize)
          1: strobe_data[STROBE_WIDTH][0] = 2'b11 << remainder_check;
          2: strobe_data[STROBE_WIDTH][0] = 4'b1111 << remainder_check; 
          3: strobe_data[STROBE_WIDTH][0] = 8'b1111_1111 << remainder_check; 
          4: strobe_data[STROBE_WIDTH][0] = {16{1'b1}} << remainder_check; 
          5: strobe_data[STROBE_WIDTH][0] = {32{1'b1}} << remainder_check; 
          6: strobe_data[STROBE_WIDTH][0] = {64{1'b1}} << remainder_check; 
          7: strobe_data[STROBE_WIDTH][0] = {128{1'b1}} << remainder_check; 
        endcase
    end //}
  end
  if(awaddr%2**awsize != 0) begin
    for(int i=0;i<wstrb.size();i++) begin
      if(awsize == 0) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1]) wstrb[i] = local_addr|1'b1;
        else wstrb[i] = wstrb[i-1] << 1; 
      end
      if(awsize == 1) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(i==1) wstrb[i] =  (wstrb[i-1][STROBE_WIDTH-1]) ? (local_addr|2'b11) : min << remainder_check+1 ;
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>1) wstrb[i] = local_addr|2'b11;
        else wstrb[i] = wstrb[i-1] << 2; 
      end
      if(awsize == 2) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(i==1) wstrb[i] =  (wstrb[i-1][STROBE_WIDTH-1]) ? (local_addr|4'b1111) : (min << shift_loc);
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>0) wstrb[i] = local_addr|4'b1111; 
        else wstrb[i] = wstrb[i-1] << 4; 
      end
      if(awsize == 3) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(i==1) wstrb[i] =  (wstrb[i-1][STROBE_WIDTH-1]) ? (local_addr|8'b1111_1111) : (min << shift_loc);
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>1) wstrb[i] = local_addr|8'b1111_1111;
        else wstrb[i] = wstrb[i-1] << 8; 
      end
      if(awsize == 4) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(i==1) wstrb[i] =  (wstrb[i-1][STROBE_WIDTH-1]) ? (local_addr|16'b1111_1111_1111_1111) : (min << shift_loc);
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>1) wstrb[i] = local_addr|16'b1111_1111_1111_1111;
        else wstrb[i] = wstrb[i-1] << 16; 
      end
      if(awsize == 5) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(i==1) wstrb[i] =  (wstrb[i-1][STROBE_WIDTH-1]) ? (local_addr|32'b1111_1111_1111_1111_1111_1111_1111_1111) : (min << shift_loc);
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>1) wstrb[i] = local_addr|32'b1111_1111_1111_1111_1111_1111_1111_1111;
        else wstrb[i] = wstrb[i-1] << 32; 
      end
      if(awsize == 6) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(i==1) wstrb[i] =  (wstrb[i-1][STROBE_WIDTH-1]) ? (local_addr|64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111) : (min << shift_loc);
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>1) wstrb[i] = local_addr|64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
        else wstrb[i] = wstrb[i-1] << 64; 
      end
      if(awsize == 7) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else  wstrb[i] = local_addr|128'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
      end
    end
  end
  else begin 
    for(int i=0;i<wstrb.size();i++) begin
      if(awsize == 0) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1]) wstrb[i] = local_addr|1'b1;
        else wstrb[i] = wstrb[i-1] << 1; 
      end
      if(awsize == 1) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>0) wstrb[i] = local_addr|2'b11;
        else wstrb[i] = wstrb[i-1] << 2; 
      end
      if(awsize == 2) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>0) wstrb[i] = local_addr|4'b1111;
        else wstrb[i] = wstrb[i-1] << 4; 
      end
      if(awsize == 3) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>0) wstrb[i] = local_addr|8'b1111_1111;
        else wstrb[i] = wstrb[i-1] << 8; 
      end
      if(awsize == 4) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>0) wstrb[i] = local_addr|16'b1111_1111_1111_1111;
        else wstrb[i] = wstrb[i-1] << 16; 
      end
      if(awsize == 5) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>0) wstrb[i] = local_addr|32'b1111_1111_1111_1111_1111_1111_1111_1111;
        else wstrb[i] = wstrb[i-1] << 32; 
      end
      if(awsize == 6) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else if(wstrb[i-1][STROBE_WIDTH-1] && i>0) wstrb[i] = local_addr|64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
        else wstrb[i] = wstrb[i-1] << 64; 
      end
      if(awsize == 7) begin
        if(i==0)  wstrb[0] = strobe_data[STROBE_WIDTH][0];
        else wstrb[i] = local_addr|128'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
      end
    end
  end
end //}
endfunction : post_randomize

//--------------------------------------------------------------------------------------------
// Function : do_copy
// Copies the axi4 slave_tx into the rhs object
//
// Parameters:
// rhs - uvm_object
//--------------------------------------------------------------------------------------------
function void axi4_master_tx::do_copy(uvm_object rhs);
  axi4_master_tx axi4_master_tx_copy_obj;

  if(!$cast(axi4_master_tx_copy_obj,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);
  
  //WRITE ADDRESS CHANNEL
  awid    = axi4_master_tx_copy_obj.awid;
  awaddr  = axi4_master_tx_copy_obj.awaddr;
  awlen   = axi4_master_tx_copy_obj.awlen;
  awsize  = axi4_master_tx_copy_obj.awsize;
  awburst = axi4_master_tx_copy_obj.awburst;
  awlock  = axi4_master_tx_copy_obj.awlock;
  awcache = axi4_master_tx_copy_obj.awcache;
  awprot  = axi4_master_tx_copy_obj.awprot;
  awqos   = axi4_master_tx_copy_obj.awqos;
  //WRITE DATA CHANNEL
  wdata = axi4_master_tx_copy_obj.wdata;
  wstrb = axi4_master_tx_copy_obj.wstrb;
  wuser = axi4_master_tx_copy_obj.wuser;
  //WRITE RESPONSE CHANNEL
  bid   = axi4_master_tx_copy_obj.bid;
  bresp = axi4_master_tx_copy_obj.bresp;
  buser = axi4_master_tx_copy_obj.buser;
  //READ ADDRESS CHANNEL
  arid     = axi4_master_tx_copy_obj.arid;
  araddr   = axi4_master_tx_copy_obj.araddr;
  arlen    = axi4_master_tx_copy_obj.arlen;
  arsize   = axi4_master_tx_copy_obj.arsize;
  arburst  = axi4_master_tx_copy_obj.arburst;
  arlock   = axi4_master_tx_copy_obj.arlock;
  arcache  = axi4_master_tx_copy_obj.arcache;
  arprot   = axi4_master_tx_copy_obj.arprot;
  arqos    = axi4_master_tx_copy_obj.arqos;
  arregion = axi4_master_tx_copy_obj.arregion;
  aruser   = axi4_master_tx_copy_obj.aruser;
  //READ DATA CHANNEL
  rid   = axi4_master_tx_copy_obj.rid;
  rdata = axi4_master_tx_copy_obj.rdata;
  rresp = axi4_master_tx_copy_obj.rresp;
  ruser = axi4_master_tx_copy_obj.ruser;
  //OTHERS
  tx_type       = axi4_master_tx_copy_obj.tx_type;
  transfer_type = axi4_master_tx_copy_obj.transfer_type;
endfunction : do_copy

//--------------------------------------------------------------------------------------------
// Function: do_compare
// Compare method is implemented using handle rhs
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function bit axi4_master_tx::do_compare (uvm_object rhs, uvm_comparer comparer);
  axi4_master_tx axi4_master_tx_compare_obj;

  if(!$cast(axi4_master_tx_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_MASTER_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
    return 0;
  end
  
  return super.do_compare(axi4_master_tx_compare_obj, comparer) &&
  //WRITE ADDRESS CHANNEL
  awid    == axi4_master_tx_compare_obj.awid    &&
  awaddr  == axi4_master_tx_compare_obj.awaddr  &&
  awlen   == axi4_master_tx_compare_obj.awlen   &&
  awsize  == axi4_master_tx_compare_obj.awsize  &&
  awburst == axi4_master_tx_compare_obj.awburst &&
  awlock  == axi4_master_tx_compare_obj.awlock  &&
  awcache == axi4_master_tx_compare_obj.awcache &&
  awprot  == axi4_master_tx_compare_obj.awprot  &&
  awqos   == axi4_master_tx_compare_obj.awqos   &&
  //WRITE DATA CHANNEL
  wdata == axi4_master_tx_compare_obj.wdata &&
  wstrb == axi4_master_tx_compare_obj.wstrb &&
  //WRITE RESPONSE CHANNEL
  bid   == axi4_master_tx_compare_obj.bid   &&
  bresp == axi4_master_tx_compare_obj.bresp &&
  //READ ADDRESS CHANNEL
  arid    == axi4_master_tx_compare_obj.arid    &&
  araddr  == axi4_master_tx_compare_obj.araddr  &&
  arlen   == axi4_master_tx_compare_obj.arlen   &&
  arsize  == axi4_master_tx_compare_obj.arsize  &&
  arburst == axi4_master_tx_compare_obj.arburst &&
  arlock  == axi4_master_tx_compare_obj.arlock  &&
  arcache == axi4_master_tx_compare_obj.arcache &&
  arprot  == axi4_master_tx_compare_obj.arprot  &&
  arqos   == axi4_master_tx_compare_obj.arqos   &&
  //READ DATA CHANNEL
  rid   == axi4_master_tx_compare_obj.rid   &&
  rdata == axi4_master_tx_compare_obj.rdata &&
  rresp == axi4_master_tx_compare_obj.rresp;
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//
// Parameters :
// printer  - uvm_printer
//--------------------------------------------------------------------------------------------
function void axi4_master_tx::do_print(uvm_printer printer);
  printer.print_string("tx_type",tx_type.name());
  if(tx_type == WRITE) begin
  //`uvm_info("------------------------------------------WRITE_ADDRESS_CHANNEL","-------------------------------------",UVM_LOW);
    printer.print_string("awid",awid.name());
    printer.print_field("awaddr",awaddr,$bits(awaddr),UVM_HEX);
    printer.print_field("awlen",awlen,$bits(awlen),UVM_DEC);
    printer.print_string("awsize",awsize.name());
    printer.print_string("awburst",awburst.name());
    printer.print_string("awlock",awlock.name());
    printer.print_string("awcache",awcache.name());
    printer.print_string("awprot",awprot.name());
    printer.print_field("awqos",awqos,$bits(awqos),UVM_HEX);
    printer.print_field("wait_count_write_address_channel",wait_count_write_address_channel,
                         $bits(wait_count_write_address_channel),UVM_HEX);
    //`uvm_info("------------------------------------------WRITE_DATA_CHANNEL","---------------------------------------",UVM_LOW);
    foreach(wdata[i])begin
      printer.print_field($sformatf("wdata[%0d]",i),wdata[i],$bits(wdata[i]),UVM_HEX);
    end
    foreach(wstrb[i])begin
      // MSHA: printer.print_field($sformatf("wstrb[%0d]",i),wstrb[i],$bits(wstrb[i]),UVM_HEX);
      printer.print_field($sformatf("wstrb[%0d]",i),wstrb[i],$bits(wstrb[i]),UVM_HEX);
    end
    printer.print_field("wait_count_write_data_channel",wait_count_write_data_channel,
                         $bits(wait_count_write_data_channel),UVM_HEX);
    //`uvm_info("-----------------------------------------WRITE_RESPONSE_CHANNEL","------------------------------------",UVM_LOW);
    printer.print_string("bid",bid.name());
    printer.print_string("bresp",bresp.name());
    printer.print_field("no_of_wait_states",no_of_wait_states,$bits(no_of_wait_states),UVM_DEC);
    printer.print_field("wait_count_write_response_channel",wait_count_write_response_channel,
                         $bits(wait_count_write_response_channel),UVM_HEX);
  end
  
  if(tx_type == READ) begin
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
    printer.print_field("wait_count_read_address_channel",wait_count_read_address_channel,
                         $bits(wait_count_read_address_channel),UVM_HEX);
    //`uvm_info("------------------------------------------READ_DATA_CHANNEL","----------------------------------------",UVM_LOW);
    printer.print_string("rid",rid.name());
    foreach(rdata[i])begin
      printer.print_field($sformatf("rdata[%0d]",i),rdata[i],$bits(rdata[i]),UVM_HEX);
    end
    printer.print_string("rresp",rresp.name());
    printer.print_field("ruser",ruser,$bits(ruser),UVM_HEX);
    printer.print_field("no_of_wait_states",no_of_wait_states,$bits(no_of_wait_states),UVM_DEC);
    printer.print_field("wait_count_read_data_channel",wait_count_read_data_channel,$bits(wait_count_read_data_channel),UVM_HEX);
  end
  printer.print_string("transfer_type",transfer_type.name());
endfunction : do_print

`endif

