`ifndef AXI4LITEMASTERREADTRANSACTION_INCLUDED_
`define AXI4LITEMASTERREADTRANSACTION_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteMasterReadTransaction
// This class holds the data items required to drive the stimulus to dut
// and also holds methods that manipulate those data items.
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterReadTransaction extends uvm_sequence_item;
  
  `uvm_object_utils(Axi4LiteMasterReadTransaction)

  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig; 
  
  //-------------------------------------------------------
  // READ ADDRESS CHANNEL SIGNALS
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
   // READ DATA CHANNEL SIGNALS
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
  // READ RESPONSE CHANNEL SIGNALS
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
  rand bit arqos;

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
  // READ ADDRESS Constraints
  //-------------------------------------------------------
  //Constraint : awaddr
  //Used to generate the alligned address with respect to size
  constraint awaddr_c0 {soft awaddr == (awaddr%(2**awsize)) == 0;}

  //Constraint : awburst_c1
  //Restricting write burst to select only FIXED, INCR and WRAP types
  constraint awburst_c1 {awburst != READ_RESERVED;}

  //Constraint : awlength_c2
  //Adding constraint for restricting write trasnfers
  constraint awlength_c2 {if(awburst==READ_FIXED || READ_WRAP)
                              awlen inside {[0:15]};
                          else if(awburst == READ_INCR) 
                              awlen inside {[0:255]};}

  //Constraint : awlength_c3
  //Adding constraint for restricting to get multiples of 2 in wrap burst
  constraint awlength_c3 {if(awburst == READ_WRAP)
                          awlen + 1 inside {2,4,8,16};}
  
  //Constraint : awlock_c4
  //Adding constraint to select the lock transfer type
  constraint awlock_c4 {soft awlock == READ_NORMAL_ACCESS;}

  //Constraint : awburst_c5
  //Adding a soft constraint to detrmine the burst type
  constraint awburst_c5 {soft awburst == READ_INCR;}

  //Constraint : awsize_c6
  //Adding a soft constraint to detrmine the awsize
  constraint awsize_c6 {soft awsize inside {[0:2]};}

  //-------------------------------------------------------
  // READ DATA Constraints
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
  extern function new (string name = "Axi4LiteMasterReadTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function void post_randomize();
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
endclass : Axi4LiteMasterReadTransaction

//--------------------------------------------------------------------------------------------
// Construct: new
// initializes the class object
//
// Parameters:
// name - Axi4LiteMasterReadTransaction
//--------------------------------------------------------------------------------------------
function Axi4LiteMasterReadTransaction::new(string name = "Axi4LiteMasterReadTransaction");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function : post_randomize 
// Implements the narrow transfers and unalligned transfers
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadTransaction::post_randomize();
  bit[3:0] wstrb_local;
  bit[3:0] wstrb_size_0_local;
  bit[3:0] awsize_0;
  bit[3:0] awsize_1;

  bit[3:0] unallignd_wstrb0;
  bit[3:0] unallignd_wstrb1;
  bit[3:0] unallignd_wstrb2;
  bit[1:0] unallignd_wstrb0_cnt;
  bit[3:0] alligned_wstrb0_cnt;
  int index;
  int quotient_check;
  int quotient_check_1;
  int remainder_check;

  //-------------------------------------------------------
  // Step-1: for awsize == 0
  // Calculate the remainder by dividing awaddr and 2**awsize
  // that gives the nearest alligned address based on the 
  // remainder assert that particular strobe bit.
  //
  // Step-2: for awsize == 1
  // Calculate the quotient by dividing awaddr and 2**awsize
  // if quotient is alligned assert first 2 bits of strobes
  // else assert next 2 bits of strobes
  //
  //Step-3: for awsize == 2
  //Here you can assert all 4bits of strobes since it is a 
  //alligned address and all 4bits needs to pass
  //(addr ex: 0,4,8..)
  //-------------------------------------------------------
  //-------------------------------------------------------
  // Narrow Transfers for alligned address
  //-------------------------------------------------------
  if(awaddr % 2**awsize == 0) begin
    awsize_0 = 4'b0001;
    awsize_1 = 4'b1111;
    remainder_check = awaddr % 4;
    `uvm_info("rem_check",$sformatf("remainder_check = %0d",remainder_check),UVM_HIGH)
    
    // Assigning the initial strobe values based on the size and address issued
    if(awsize == 0) begin
      if(remainder_check == 0) wstrb_local = 4'b0001; 
      if(remainder_check == 1) wstrb_local = 4'b0010; 
      if(remainder_check == 2) wstrb_local = 4'b0100; 
      if(remainder_check == 3) wstrb_local = 4'b1000; 
    end
   
    if(awsize == 1) begin 
      quotient_check_1 = awaddr / 2**awsize;
      if(quotient_check_1 % 2 == 0) begin
      wstrb_local = 4'b0011;
    end
    else begin
      wstrb_local = 4'b1100;
    end
  end
  
  if(awsize == 2) wstrb_local = 4'b1111;
  `uvm_info(get_type_name(), $sformatf("DEBUG_LOCAL :: wstrb_local =  %0b",wstrb_local), UVM_HIGH); 
  `uvm_info(get_type_name(), $sformatf("DEBUG_LOCL :: awsize =  %0d",awsize), UVM_HIGH); 
  
  wstrb_size_0_local = wstrb_local;

  //for loop to generate the strobe values based on strobe size
  for(int i=0;i<wstrb.size();i++) begin
    `uvm_info(get_type_name(),$sformatf("inside for loop of post randomize"),UVM_HIGH)
    
    if(awsize == 0) begin
      if(remainder_check == 0)begin
        if(i==0) begin
          wstrb[0] = wstrb_local;
          `uvm_info(get_type_name(), $sformatf("DEBUG_IN_LOOP :: wstrb[0] =  %0b",wstrb[0]), UVM_HIGH); 
        end 
        else begin
          // since remainder is 0 it will be in 1st(0) lane
          // so after every 4 transfers u need to assign wstrb(0)
          if(i%4 == 0) begin
            this.wstrb[i] = awsize_0;
            wstrb_size_0_local = awsize_0;
          end
          else begin
            wstrb_size_0_local = (wstrb_size_0_local << 2**awsize);
            this.wstrb[i] = wstrb_size_0_local;
          end
          `uvm_info(get_type_name(), $sformatf("DEBUG_IN_LOOP :: wstrb[%0d] =  %0b",i,this.wstrb[i]), UVM_HIGH); 
          `uvm_info(get_type_name(),$sformatf("outside for loop of post randomize"),UVM_HIGH)
        end
      end
      
      // since remainder is 1 it will be in 2nd(1) lane
      else if (remainder_check == 1) begin
        if(i==0) begin
          wstrb[0] = wstrb_local;
          `uvm_info(get_type_name(), $sformatf("DEBUG_IN_LOOP :: wstrb[0] =  %0b",wstrb[0]), UVM_HIGH); 
        end 
        else if(i == 1) begin
          wstrb[1] = wstrb[0] << i;
        end
        else if(i == 2) begin
          wstrb[2] = wstrb[0] << i;
          wstrb_size_0_local = awsize_0;
        end
        else begin 
          this.wstrb[i] = wstrb_size_0_local;
          wstrb_size_0_local = (wstrb_size_0_local << 2**awsize);
          alligned_wstrb0_cnt++;
          if(alligned_wstrb0_cnt == 4) begin
            // so after every 4 transfers u need to assign awsize_0
            wstrb_size_0_local = awsize_0;
            alligned_wstrb0_cnt = 0;
          end
        end
      end  
      
      else if (remainder_check == 2) begin
        if(i==0) begin
          wstrb[0] = wstrb_local;
          `uvm_info(get_type_name(), $sformatf("DEBUG_IN_LOOP :: wstrb[0] =  %0b",wstrb[0]), UVM_HIGH); 
        end 
        else if(i == 1) begin
          wstrb[1] = wstrb[0] << i;
          wstrb_size_0_local = awsize_0;
        end
        
        else begin 
          this.wstrb[i] = wstrb_size_0_local;
          wstrb_size_0_local = (wstrb_size_0_local << 2**awsize);
          alligned_wstrb0_cnt++;
          if(alligned_wstrb0_cnt == 4) begin
            wstrb_size_0_local = awsize_0;
            alligned_wstrb0_cnt = 0;
          end
        end
      end
      
      else if (remainder_check == 3) begin
        if(i==0) begin
          wstrb[0] = wstrb_local;
          wstrb_size_0_local = awsize_0;
          `uvm_info(get_type_name(), $sformatf("DEBUG_IN_LOOP :: wstrb[0] =  %0b",wstrb[0]), UVM_HIGH); 
        end 
        
        else begin 
          this.wstrb[i] = wstrb_size_0_local;
          wstrb_size_0_local = (wstrb_size_0_local << 2**awsize);
          alligned_wstrb0_cnt++;
          if(alligned_wstrb0_cnt == 4) begin
            wstrb_size_0_local = awsize_0;
            alligned_wstrb0_cnt = 0;
          end
        end
      end
    end
    
    else if(awsize == 1) begin
      if(quotient_check_1 % 2**awsize == 0) begin 
        if(i==0) begin
          wstrb[0] = wstrb_local;
          `uvm_info(get_type_name(), $sformatf("DEBUG_IN_LOOP :: wstrb[0] =  %0b",wstrb[0]), UVM_HIGH); 
        end 
        else begin
          if(i%2 == 0) begin
            this.wstrb[i] = {(wstrb_local << 2**awsize)^awsize_1};
          end
          else begin
            this.wstrb[i] = (wstrb_local << 2**awsize);
          end
        end
      end
      
      else begin
        if(i==0) begin
          wstrb[0] = wstrb_local;
          `uvm_info(get_type_name(), $sformatf("DEBUG_IN_LOOP :: wstrb[0] =  %0b",wstrb[0]), UVM_HIGH); 
        end 
        else begin
          if(i%2 == 0) begin
            this.wstrb[i] = wstrb_local;
          end
          else begin
            this.wstrb[i] = (wstrb_local >> 2**awsize);
          end
        end
      end
    end
    
    else if(awsize == 2) begin
      wstrb[i] = wstrb_local;
    end
  end
end


//-------------------------------------------------------
// Strobes for Unalligned transfers
//-------------------------------------------------------
if(awaddr % 2**awsize != 0) begin
  
  unallignd_wstrb0 = 4'b0001;
  unallignd_wstrb1 = 4'b0011;
  unallignd_wstrb2 = 4'b1111;
  
  quotient_check = awaddr / 2**awsize;
  
  if(awsize == 0) begin
    wstrb_local = 4'b0001;
  end
  if(awsize == 1) begin
    if(quotient_check%2 == 0) begin
      wstrb_local = 4'b0010;
    end
    else begin
      wstrb_local = 4'b1000;
    end
  end
  //in the 1st case why 3 bits made 1 becoz 
  //since addr is 1 if you pass only that address as high 
  //then in nxt lane it will start from addr 2 which is unalligned for size
  //so if u pass all 3 bits nxt transfer will strat from 4 which is alligned.
  if(awsize == 2) begin
    if(awaddr % 2**awsize == 1) wstrb_local = 4'b1110; 
    if(awaddr % 2**awsize == 2) wstrb_local = 4'b1100; 
    if(awaddr % 2**awsize == 3) wstrb_local = 4'b1000;
  end
  
  for(int i=0;i<wstrb.size();i++) begin
    if(awsize == 0) begin
      if(i == 0) begin
        wstrb[0] = wstrb_local;
      end
      else begin
        wstrb[i] = wstrb_local << 1;
        unallignd_wstrb0_cnt++;
        if(unallignd_wstrb0_cnt == 'd3) begin
          wstrb[i] = wstrb_local;
          unallignd_wstrb0_cnt = 0;
        end
      end
    end
    
    if(awsize == 1) begin
      if(i == 0) begin
        wstrb[0] = wstrb_local;
      end
      else if(i == 1) begin
        wstrb[i] = unallignd_wstrb1;
      end
      else begin
        if(i%2 == 0) begin
        wstrb[i] = unallignd_wstrb1 << 2;
      end
      else if(i%2 != 0) begin
        wstrb[i] = unallignd_wstrb1;
      end
    end
  end
  
  if(awsize == 2) begin
    if(i==0) begin
      wstrb[0] = wstrb_local;
    end
    else begin
      wstrb[i] = unallignd_wstrb2;
    end
   end
  end
end

endfunction : post_randomize

//--------------------------------------------------------------------------------------------
// Function : do_copy
// Copies the axi4 slave_tx into the rhs object
//
// Parameters:
// rhs - uvm_object
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadTransaction::do_copy(uvm_object rhs);
  Axi4LiteMasterReadTransaction Axi4LiteMasterReadTransaction_copy_obj;

  if(!$cast(Axi4LiteMasterReadTransaction_copy_obj,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);
  
  //READ ADDRESS CHANNEL
  awid    = Axi4LiteMasterReadTransaction_copy_obj.awid;
  awaddr  = Axi4LiteMasterReadTransaction_copy_obj.awaddr;
  awlen   = Axi4LiteMasterReadTransaction_copy_obj.awlen;
  awsize  = Axi4LiteMasterReadTransaction_copy_obj.awsize;
  awburst = Axi4LiteMasterReadTransaction_copy_obj.awburst;
  awlock  = Axi4LiteMasterReadTransaction_copy_obj.awlock;
  awcache = Axi4LiteMasterReadTransaction_copy_obj.awcache;
  awprot  = Axi4LiteMasterReadTransaction_copy_obj.awprot;
  awqos   = Axi4LiteMasterReadTransaction_copy_obj.awqos;
  //READ DATA CHANNEL
  wdata = Axi4LiteMasterReadTransaction_copy_obj.wdata;
  wstrb = Axi4LiteMasterReadTransaction_copy_obj.wstrb;
  wuser = Axi4LiteMasterReadTransaction_copy_obj.wuser;
  //READ RESPONSE CHANNEL
  bid   = Axi4LiteMasterReadTransaction_copy_obj.bid;
  bresp = Axi4LiteMasterReadTransaction_copy_obj.bresp;
  buser = Axi4LiteMasterReadTransaction_copy_obj.buser;
  //READ ADDRESS CHANNEL
  arid     = Axi4LiteMasterReadTransaction_copy_obj.arid;
  araddr   = Axi4LiteMasterReadTransaction_copy_obj.araddr;
  arlen    = Axi4LiteMasterReadTransaction_copy_obj.arlen;
  arsize   = Axi4LiteMasterReadTransaction_copy_obj.arsize;
  arburst  = Axi4LiteMasterReadTransaction_copy_obj.arburst;
  arlock   = Axi4LiteMasterReadTransaction_copy_obj.arlock;
  arcache  = Axi4LiteMasterReadTransaction_copy_obj.arcache;
  arprot   = Axi4LiteMasterReadTransaction_copy_obj.arprot;
  arqos    = Axi4LiteMasterReadTransaction_copy_obj.arqos;
  arregion = Axi4LiteMasterReadTransaction_copy_obj.arregion;
  aruser   = Axi4LiteMasterReadTransaction_copy_obj.aruser;
  //READ DATA CHANNEL
  rid   = Axi4LiteMasterReadTransaction_copy_obj.rid;
  rdata = Axi4LiteMasterReadTransaction_copy_obj.rdata;
  rresp = Axi4LiteMasterReadTransaction_copy_obj.rresp;
  ruser = Axi4LiteMasterReadTransaction_copy_obj.ruser;
  //OTHERS
  tx_type       = Axi4LiteMasterReadTransaction_copy_obj.tx_type;
  transfer_type = Axi4LiteMasterReadTransaction_copy_obj.transfer_type;
endfunction : do_copy

//--------------------------------------------------------------------------------------------
// Function: do_compare
// Compare method is implemented using handle rhs
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function bit Axi4LiteMasterReadTransaction::do_compare (uvm_object rhs, uvm_comparer comparer);
  Axi4LiteMasterReadTransaction Axi4LiteMasterReadTransaction_compare_obj;

  if(!$cast(Axi4LiteMasterReadTransaction_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_axi_MASTER_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
    return 0;
  end
  
  return super.do_compare(Axi4LiteMasterReadTransaction_compare_obj, comparer) &&
  //READ ADDRESS CHANNEL
  awid    == Axi4LiteMasterReadTransaction_compare_obj.awid    &&
  awaddr  == Axi4LiteMasterReadTransaction_compare_obj.awaddr  &&
  awlen   == Axi4LiteMasterReadTransaction_compare_obj.awlen   &&
  awsize  == Axi4LiteMasterReadTransaction_compare_obj.awsize  &&
  awburst == Axi4LiteMasterReadTransaction_compare_obj.awburst &&
  awlock  == Axi4LiteMasterReadTransaction_compare_obj.awlock  &&
  awcache == Axi4LiteMasterReadTransaction_compare_obj.awcache &&
  awprot  == Axi4LiteMasterReadTransaction_compare_obj.awprot  &&
  awqos   == Axi4LiteMasterReadTransaction_compare_obj.awqos   &&
  //READ DATA CHANNEL
  wdata == Axi4LiteMasterReadTransaction_compare_obj.wdata &&
  wstrb == Axi4LiteMasterReadTransaction_compare_obj.wstrb &&
  //READ RESPONSE CHANNEL
  bid   == Axi4LiteMasterReadTransaction_compare_obj.bid   &&
  bresp == Axi4LiteMasterReadTransaction_compare_obj.bresp &&
  //READ ADDRESS CHANNEL
  arid    == Axi4LiteMasterReadTransaction_compare_obj.arid    &&
  araddr  == Axi4LiteMasterReadTransaction_compare_obj.araddr  &&
  arlen   == Axi4LiteMasterReadTransaction_compare_obj.arlen   &&
  arsize  == Axi4LiteMasterReadTransaction_compare_obj.arsize  &&
  arburst == Axi4LiteMasterReadTransaction_compare_obj.arburst &&
  arlock  == Axi4LiteMasterReadTransaction_compare_obj.arlock  &&
  arcache == Axi4LiteMasterReadTransaction_compare_obj.arcache &&
  arprot  == Axi4LiteMasterReadTransaction_compare_obj.arprot  &&
  arqos   == Axi4LiteMasterReadTransaction_compare_obj.arqos   &&
  //READ DATA CHANNEL
  rid   == Axi4LiteMasterReadTransaction_compare_obj.rid   &&
  rdata == Axi4LiteMasterReadTransaction_compare_obj.rdata &&
  rresp == Axi4LiteMasterReadTransaction_compare_obj.rresp;
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//
// Parameters :
// printer  - uvm_printer
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadTransaction::do_print(uvm_printer printer);
  printer.print_string("tx_type",tx_type.name());
  if(tx_type == READ) begin
  //`uvm_info("------------------------------------------READ_ADDRESS_CHANNEL","-------------------------------------",UVM_LOW);
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
    //`uvm_info("------------------------------------------READ_DATA_CHANNEL","---------------------------------------",UVM_LOW);
    foreach(wdata[i])begin
      printer.print_field($sformatf("wdata[%0d]",i),wdata[i],$bits(wdata[i]),UVM_HEX);
    end
    foreach(wstrb[i])begin
      // MSHA: printer.print_field($sformatf("wstrb[%0d]",i),wstrb[i],$bits(wstrb[i]),UVM_HEX);
      printer.print_field($sformatf("wstrb[%0d]",i),wstrb[i],$bits(wstrb[i]),UVM_HEX);
    end
    printer.print_field("wait_count_write_data_channel",wait_count_write_data_channel,
                         $bits(wait_count_write_data_channel),UVM_HEX);
    //`uvm_info("-----------------------------------------READ_RESPONSE_CHANNEL","------------------------------------",UVM_LOW);
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

