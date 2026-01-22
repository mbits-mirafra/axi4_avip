`ifndef AXI4_SCOREBOARD_INCLUDED_
`define AXI4_SCOREBOARD_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_scoreboard
// Scoreboard the data getting from monitor port that goes into the implementation port
//--------------------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_master_write_data)
`uvm_analysis_imp_decl(_master_read_data)
`uvm_analysis_imp_decl(_slave_write_data)
`uvm_analysis_imp_decl(_slave_read_data)
`uvm_analysis_imp_decl(_slave_write_address)
`uvm_analysis_imp_decl(_slave_read_address)
`uvm_analysis_imp_decl(_master_write_address)
`uvm_analysis_imp_decl(_master_read_address)

class axi4_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi4_scoreboard)

  // Declaring handles for master tx and slave tx
  axi4_master_tx axi4_master_tx_h1;
  axi4_master_tx axi4_master_tx_h2;
  axi4_master_tx axi4_master_tx_h3;
  axi4_master_tx axi4_master_tx_h4;
  axi4_master_tx axi4_master_tx_h5;

  axi4_slave_tx axi4_slave_tx_h1;
  axi4_slave_tx axi4_slave_tx_h2;
  axi4_slave_tx axi4_slave_tx_h3;
  axi4_slave_tx axi4_slave_tx_h4;
  axi4_slave_tx axi4_slave_tx_h5;

  int count1,count2,count3,count4;
  typedef struct{bit[DATA_WIDTH-1:0]data;bit[(DATA_WIDTH/8)-1:0]strobe;}DataTransaction;
  //keep track of data obtained 
  typedef DataTransaction dataTransactionQueue[$];
  
 //queue of data transaction
  dataTransactionQueue masterArrayDataQueue[longint];
  
  dataTransactionQueue slaveArrayDataQueue[longint];

  axi4_master_tx masterWriteAddressQueue[int];
  axi4_slave_tx slaveWriteAddressQueue[int];
  axi4_master_tx masterReadAddressQueue[int];
  axi4_slave_tx slaveReadAddressQueue[int];

  logic[7:0]referenceData[longint];
  //Variable : axi4_master_analysis_fifo
  //Used to store the axi4_master_data
  uvm_analysis_imp_master_read_address#(axi4_master_tx,axi4_scoreboard) axi4_master_read_address_analysis_fifo;
  uvm_tlm_analysis_fifo#(axi4_master_tx) axi4_master_read_data_analysis_fifo;
  uvm_analysis_imp_master_write_address#(axi4_master_tx,axi4_scoreboard) axi4_master_write_address_analysis_fifo;
  uvm_analysis_imp_master_write_data#(axi4_master_tx,axi4_scoreboard) axi4_master_write_data_analysis_fifo;
  uvm_tlm_analysis_fifo#(axi4_master_tx) axi4_master_write_response_analysis_fifo;
  
  //Variable : axi4_slave_analysis_fifo
  //Used to store the axi4_slave_data
  uvm_analysis_imp_slave_read_address#(axi4_slave_tx,axi4_scoreboard) axi4_slave_read_address_analysis_fifo;
  uvm_tlm_analysis_fifo#(axi4_slave_tx) axi4_slave_read_data_analysis_fifo;
  uvm_analysis_imp_slave_write_address#(axi4_slave_tx,axi4_scoreboard) axi4_slave_write_address_analysis_fifo;
  uvm_analysis_imp_slave_write_data#(axi4_slave_tx,axi4_scoreboard) axi4_slave_write_data_analysis_fifo;
  uvm_tlm_analysis_fifo#(axi4_slave_tx) axi4_slave_write_response_analysis_fifo;

  //field to keep track of non existing mem read
  int nonExistantMemRead;

  //master tx_count
  int axi4_master_tx_awaddr_count;
  //slave tx count
  int axi4_slave_tx_awaddr_count;
  
  //master tx_count
  int axi4_master_tx_wdata_count;
  //slave tx count
  int axi4_slave_tx_wdata_count;
  
  //master tx_count
  int axi4_master_tx_bresp_count;
  //slave tx count
  int axi4_slave_tx_bresp_count;
  
  //master tx_count
  int axi4_master_tx_araddr_count;
  //slave tx count
  int axi4_slave_tx_araddr_count;
  
  //master tx_count
  int axi4_master_tx_rdata_count;
  //slave tx count
  int axi4_slave_tx_rdata_count;
  
  //master tx_count
  int axi4_master_tx_rresp_count;
  //slave tx count
  int axi4_slave_tx_rresp_count;
  
  // Signals used to declare verified count
  int byte_data_cmp_verified_awid_count;
  int byte_data_cmp_verified_awaddr_count;
  int byte_data_cmp_verified_awsize_count;
  int byte_data_cmp_verified_awlen_count;
  int byte_data_cmp_verified_awburst_count;
  int byte_data_cmp_verified_awcache_count;
  int byte_data_cmp_verified_awlock_count;
  int byte_data_cmp_verified_awprot_count;

  int byte_data_cmp_verified_wdata_count;
  int byte_data_cmp_verified_wstrb_count;
  int byte_data_cmp_verified_wuser_count;

  int byte_data_cmp_verified_bid_count;
  int byte_data_cmp_verified_bresp_count;
  int byte_data_cmp_verified_buser_count;

  int byte_data_cmp_verified_arid_count;
  int byte_data_cmp_verified_araddr_count;
  int byte_data_cmp_verified_arsize_count;
  int byte_data_cmp_verified_arlen_count;
  int byte_data_cmp_verified_arburst_count;
  int byte_data_cmp_verified_arcache_count;
  int byte_data_cmp_verified_arlock_count;
  int byte_data_cmp_verified_arprot_count;
  int byte_data_cmp_verified_arregion_count;
  int byte_data_cmp_verified_arqos_count;

  int byte_data_cmp_verified_rid_count;
  int byte_data_cmp_verified_rdata_count;
  int byte_data_cmp_verified_rresp_count;
  int byte_data_cmp_verified_ruser_count;
  
  // Signals used to declare failed count
  int byte_data_cmp_failed_awid_count;
  int byte_data_cmp_failed_awaddr_count;
  int byte_data_cmp_failed_awsize_count;
  int byte_data_cmp_failed_awlen_count;
  int byte_data_cmp_failed_awburst_count;
  int byte_data_cmp_failed_awcache_count;
  int byte_data_cmp_failed_awlock_count;
  int byte_data_cmp_failed_awprot_count;

  int byte_data_cmp_failed_wdata_count;
  int byte_data_cmp_failed_wstrb_count;
  int byte_data_cmp_failed_wuser_count;

  int byte_data_cmp_failed_bid_count;
  int byte_data_cmp_failed_bresp_count;
  int byte_data_cmp_failed_buser_count;

  int byte_data_cmp_failed_arid_count;
  int byte_data_cmp_failed_araddr_count;
  int byte_data_cmp_failed_arsize_count;
  int byte_data_cmp_failed_arlen_count;
  int byte_data_cmp_failed_arburst_count;
  int byte_data_cmp_failed_arcache_count;
  int byte_data_cmp_failed_arlock_count;
  int byte_data_cmp_failed_arprot_count;
  int byte_data_cmp_failed_arregion_count;
  int byte_data_cmp_failed_arqos_count;

  int byte_data_cmp_failed_rid_count;
  int byte_data_cmp_failed_rdata_count;
  int byte_data_cmp_failed_rresp_count;
  int byte_data_cmp_failed_ruser_count;

  int index1,index2;
   bit flag;
  semaphore write_address_key;
  semaphore write_data_key;
  semaphore write_response_key;
  semaphore read_address_key;
  semaphore read_data_key;

   int indextemp[$];
  int index;
 
 int align;
 int alignAmount;
 axi4_master_tx t;
 axi4_master_tx temp;
 axi4_slave_tx t1;
 axi4_slave_tx t2;
 int tempAddress;
 logic[7:0] readCompare;
 int wrapStartAddress;
 int wrapEndAddress;
 axi4_master_tx axi_master_address_tx;
 axi4_slave_tx axi_slave_address_tx;
  rresp_e readError;
  bit slave_err;
  
  int count;
  bit flag1;
  bit flag2;



  //Variable : axi4_env_cfg_h
  //Declaring handle for axi4_env_config_object
  axi4_env_config axi4_env_cfg_h;
  axi4_slave_agent_config axi4_slave_agent_cfg_h;
  
  uvm_tlm_fifo #(int) referenceFifo;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_scoreboard", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern function void write_master_write_data(axi4_master_tx t);
  extern function void write_slave_write_data(axi4_slave_tx t);
  extern function void write_master_write_address(axi4_master_tx t);
  extern function void write_master_read_address(axi4_master_tx t);
  extern function void write_slave_write_address ( axi4_slave_tx t);
  extern function void write_slave_read_address(axi4_slave_tx t);

  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task axi4_write_address_comparision(input axi4_master_tx axi4_master_tx_h1,input axi4_slave_tx axi4_slave_tx_h1);
  extern virtual task axi4_write_response_comparision(input axi4_master_tx axi4_master_tx_h3,input axi4_slave_tx axi4_slave_tx_h3);
  extern virtual task axi4_read_address_comparision(input axi4_master_tx axi4_master_tx_h4,input axi4_slave_tx axi4_slave_tx_h4);
  extern virtual function void check_phase (uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);

endclass : axi4_scoreboard

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_scoreboard
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------

function void axi4_scoreboard :: write_master_write_data(axi4_master_tx t);
  DataTransaction tempTransaction;

   tempTransaction.data = t.wdata[0];
  tempTransaction.strobe = t.wstrb[0];
    if(t.wlast == 1) begin 
      masterArrayDataQueue[index1].push_back(tempTransaction);
      index1++;
      axi4_master_tx_wdata_count++;     

    end
    else begin 
      masterArrayDataQueue[index1].push_back(tempTransaction);
    end
endfunction 

function void axi4_scoreboard :: write_slave_write_data(axi4_slave_tx t);
  DataTransaction tempTransaction;
   tempTransaction.data = t.wdata[0];
  tempTransaction.strobe = t.wstrb[0];
    if(t.wlast == 1) begin 
      slaveArrayDataQueue[index2].push_back(tempTransaction);
      index2++;
       axi4_slave_tx_wdata_count++;
    end
    else begin 
      slaveArrayDataQueue[index2].push_back(tempTransaction);

    end
endfunction 


function void axi4_scoreboard :: write_master_write_address(axi4_master_tx t);
  masterWriteAddressQueue[count1] = t;
  axi4_master_tx_awaddr_count++;
  count1++;
endfunction 

function void axi4_scoreboard :: write_slave_write_address(axi4_slave_tx t);
  axi4_slave_tx_awaddr_count++;
  slaveWriteAddressQueue[count2]=(t);
 count2++;
endfunction 

function void axi4_scoreboard :: write_master_read_address(axi4_master_tx t);
  axi4_master_tx_araddr_count++;
  masterReadAddressQueue[count3]=t;
  count3++;
endfunction 

function void axi4_scoreboard :: write_slave_read_address(axi4_slave_tx t);
  axi4_slave_tx_araddr_count++;
  slaveReadAddressQueue[count4]=t;
  count4++;
endfunction 

function axi4_scoreboard::new(string name = "axi4_scoreboard",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_master_write_address_analysis_fifo = new("axi4_master_write_address_analysis_fifo",this);
  axi4_master_write_data_analysis_fifo = new("axi4_master_write_data_analysis_fifo",this);
  axi4_master_write_response_analysis_fifo= new("axi4_master_write_response_analysis_fifo",this);
  axi4_master_read_address_analysis_fifo = new("axi4_master_read_address_analysis_fifo",this);
  axi4_master_read_data_analysis_fifo = new("axi4_master_read_data_analysis_fifo",this);
   referenceFifo = new("refrenceFifo",this);
  axi4_slave_write_address_analysis_fifo = new("axi4_slave_write_address_analysis_fifo",this);
  axi4_slave_write_data_analysis_fifo = new("axi4_slave_write_data_analysis_fifo",this);
  axi4_slave_write_response_analysis_fifo= new("axi4_slave_write_response_analysis_fifo",this);
  axi4_slave_read_address_analysis_fifo = new("axi4_slave_read_address_analysis_fifo",this);
  axi4_slave_read_data_analysis_fifo = new("axi4_slave_read_data_analysis_fifo",this);

  write_address_key = new(1);
  write_data_key = new(1);
  write_response_key = new(1);
  read_address_key = new(1);
  read_data_key = new(1);

endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(axi4_slave_agent_config)::get(this,"",$sformatf("axi4_slave_agent_config[0]"),axi4_slave_agent_cfg_h)) begin
      `uvm_fatal("FATAL_SA_AGENT_CONFIG", $sformatf("Couldn't get the axi4_slave_agent_config[%0d] from config_db",0))
    end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_scoreboard::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Function: start_of_simulation_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_scoreboard::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// All the comparision are done
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task axi4_scoreboard::run_phase(uvm_phase phase);

  super.run_phase(phase);
fork 

 
  forever begin 


   axi4_master_write_response_analysis_fifo.get(temp);
    axi4_master_tx_bresp_count++;
     `uvm_info("CHECK","ENTERED FOR WRITE CHECK ",UVM_NONE) 
    
     axi4_slave_write_response_analysis_fifo.get(t2);
    axi4_slave_tx_bresp_count++;
     indextemp = slaveWriteAddressQueue.find_first_index() with(item.awid == t2.bid);
     index =indextemp[0];
     axi_master_address_tx = masterWriteAddressQueue[index];
     axi_slave_address_tx = slaveWriteAddressQueue[index];
     temp.bid = bid_e'(int'(axi_master_address_tx.awid));

     tempAddress = axi_master_address_tx.awaddr;
     
     masterWriteAddressQueue.delete(index);
     slaveWriteAddressQueue.delete(index);
     //$display("THE BURST IN SCB IS %0d",axi_master_address_tx.awburst); 
     wrapStartAddress =tempAddress - int'(tempAddress % ((2**(axi_master_address_tx.awsize))* (axi_master_address_tx.awlen +1)));
     wrapEndAddress = wrapStartAddress + (((2**(axi_master_address_tx.awsize))* (axi_master_address_tx.awlen +1)));
     axi4_write_address_comparision(axi_master_address_tx,axi_slave_address_tx); //address check done 
     if((axi_master_address_tx.awaddr % (2**axi_master_address_tx.awsize))!= 0) begin
 align =0; 
 alignAmount = axi_master_address_tx.awaddr - ((2**(axi_master_address_tx.awsize))  *(int'(axi_master_address_tx.awaddr/(2**(axi_master_address_tx.awsize))))); 
     end
     else begin 
      align=1;
     end 
     for(int i=0;i < masterArrayDataQueue[index].size();i++) begin    
       int count =0; 
       int j=0;
        if(i !=0)
          alignAmount =0;
    
        case(axi_master_address_tx.awburst)
          2'b 00: begin 
            for(int j=0;j<((2**(axi_master_address_tx.awsize)-(alignAmount)));j++) begin 
              if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin 
                temp.bresp = WRITE_SLVERR;
              end 
              if(masterArrayDataQueue[index][i].data[8*j+7 -: 8] != slaveArrayDataQueue[index][i].data[8*j+7 -: 8])begin 
                 `uvm_error("WRITE CHECK FAIL",$sformatf("THE BYTE %0D is not equal the byte in expected is %0b and in actual is %0b",j,masterArrayDataQueue[index][i].data[8*j+7 -: 8],slaveArrayDataQueue[index][i].data[8*j+7 -: 8]))
              byte_data_cmp_failed_wdata_count++;
              end 
              else begin 
                `uvm_info("WRITE CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d reference data is %0h",j,masterArrayDataQueue[index][i].data[8*j+7 -: 8]),UVM_NONE);

                byte_data_cmp_verified_wdata_count++;
              end    
             referenceFifo.put(masterArrayDataQueue[index][i].data[8*j+7-:8]);            
            end  
          end  
          2'b 01: begin 
            for(int k=0;k< ((2**(axi_master_address_tx.awsize) - (alignAmount)));k++) begin   
              if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin 
               temp.bresp = WRITE_SLVERR;
              end 
              j =tempAddress % (DATA_WIDTH/8);
              if(masterArrayDataQueue[index][i].data[8*j+7 -: 8] != slaveArrayDataQueue[index][i].data[8*j+7 -: 8])begin 
     `uvm_error("WRITE CHECK FAIL",$sformatf("THE BYTE %0D is not equal the byte in expected is %0b and in actual is %0b",j,masterArrayDataQueue[index][i].data[8*j+7 -: 8],slaveArrayDataQueue[index][i].data[8*j+7 -: 8]))
                byte_data_cmp_failed_wdata_count++; 
              end
               else begin 
                `uvm_info("WRITE CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d reference data is %0h",j,masterArrayDataQueue[index][i].data[8*j+7 -: 8]),UVM_NONE);

                byte_data_cmp_verified_wdata_count++;
              end 
              if(masterArrayDataQueue[index][i].strobe[j]==1)begin 
               referenceData[tempAddress]=(masterArrayDataQueue[index][i].data[8*j+7-:8]);
              end  
              tempAddress++;
            end            
          end 

          2'b10:begin 
            
            for(int k=0;k< ((2**(axi_master_address_tx.awsize) - (alignAmount)));k++) begin
              if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin 
                temp.bresp = WRITE_SLVERR;
              end 
             j =tempAddress % (DATA_WIDTH/8);
              if(masterArrayDataQueue[index][i].data[8*j+7 -: 8] != slaveArrayDataQueue[index][i].data[8*j+7 -: 8])begin 
                 `uvm_error("WRITE CHECK FAIL",$sformatf("THE BYTE %0D is not equal the byte in expected is %0b and in actual is %0b",j,masterArrayDataQueue[index][i].data[8*j+7 -: 8],slaveArrayDataQueue[index][i].data[8*j+7 -: 8]))
                byte_data_cmp_failed_wdata_count++;
              end
               else begin 
                `uvm_info("WRITE CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d reference data is %0h",j,masterArrayDataQueue[index][i].data[8*j+7 -: 8]),UVM_NONE);
                 byte_data_cmp_verified_wdata_count++;
              end 
              if(masterArrayDataQueue[index][i].strobe[j]==1)      begin                                       referenceData[tempAddress]=(masterArrayDataQueue[index][i].data[8*j+7-:8]);
end  
              tempAddress++;
 
              if(tempAddress == wrapEndAddress)
                 tempAddress = wrapStartAddress; 
            end 
              
          end 
        endcase   
     end
      axi4_write_response_comparision(temp,t2);
      masterArrayDataQueue.delete(index);
      slaveArrayDataQueue.delete(index); 
    end
        


  forever begin 
    axi4_master_read_data_analysis_fifo.try_get(t); 
     `uvm_info("CHECK","ENTERED READ CHECK",UVM_NONE)
     axi4_master_tx_rresp_count++;
     axi4_master_tx_rdata_count++;
    axi4_slave_read_data_analysis_fifo.get(t1);
    `uvm_info("CHECK","ENTERED READ CHECK",UVM_NONE)
    axi4_slave_tx_rdata_count++;
    axi4_slave_tx_rresp_count++;
     if(flag ==0) begin
       indextemp = slaveReadAddressQueue.find_first_index() with(item.arid == t1.rid);
       index = indextemp[0];
       flag2=0;
   
       if(masterReadAddressQueue[index].arid == t1.rid) begin 
         byte_data_cmp_verified_rid_count++;
       end  
       axi_master_address_tx = masterReadAddressQueue[index];
       axi_slave_address_tx = slaveReadAddressQueue[index];
       tempAddress = axi_master_address_tx.araddr;

       masterReadAddressQueue.delete(index);
       slaveReadAddressQueue.delete(index);
       wrapStartAddress =tempAddress - int'(tempAddress % ((2**(axi_master_address_tx.arsize))* (axi_master_address_tx.arlen +1)));
       wrapEndAddress = wrapStartAddress + (((2**(axi_master_address_tx.arsize))* (axi_master_address_tx.arlen +1)));
       axi4_read_address_comparision(axi_master_address_tx,axi_slave_address_tx); //address check done 
       if(axi_master_address_tx.araddr % (2**axi_master_address_tx.arsize) != 0) begin
        align =0; 
      alignAmount = axi_master_address_tx.araddr %((2**(axi_master_address_tx.arsize)));
          
        end
        else begin 
           align=1;
        end 
        flag=1;
     end
     else begin 
        alignAmount =0;
     end  
     if(t1.rlast ==1) begin
       flag=0;
     end 
     
        case(axi_master_address_tx.arburst)
          
          2'b 00: begin 
            for(int k=0,j=0; k< ((2**(axi_master_address_tx.arsize))- (alignAmount));k++) begin 
              if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin 
                 `uvm_info("SCOREBOARD","ADDRESS OUTSIDE SLAVE ADDRESS RANGE",UVM_HIGH)
              end    
   
             referenceFifo.get(readCompare);
              if(t1.rdata[0][8*j+7-:8] !=readCompare) begin 
                 `uvm_error("READ CHECK FAIL",$sformatf("THE READ DATA DOESNT MATCH when reference DATA  is %0d and actual one is %0d",readCompare,t1.rdata[0]))
                  byte_data_cmp_failed_rdata_count++;
              end   
              else begin 
                `uvm_info("READ CHECK PASS",$sformatf("THE READ DATA MATCHES  %0d",readCompare),UVM_NONE);
                byte_data_cmp_verified_rdata_count++;
              end                   
             end 
            end 
          2'b 01: begin
            count=0; 
            for(int k=0,j=0; k< ((2**(axi_master_address_tx.arsize))- (alignAmount));k++) begin     
              if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin
               	`uvm_info("SCOREBOARD","ADDRESS OUTSIDE SLAVE ADDRESS RANGE",UVM_HIGH) 
              end 
              if(referenceData.exists(tempAddress) ==1) begin
                j = tempAddress % (DATA_WIDTH/8);
                if(referenceData[tempAddress] != t1.rdata[0][8*j+7-:8])begin 
                  `uvm_error("READ CHECK FAIL",$sformatf("THE BYTE DOESNT MATCH IN THE POSITION %0d when reference byte is %0d and actual one is %0d",j,referenceData[tempAddress],t1.rdata[0][8*j+7-:8]))
                  byte_data_cmp_failed_rdata_count++;
                end   
                else begin 
                   byte_data_cmp_verified_rdata_count++;
                  `uvm_info("READ CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d and reference byte is %0h",j,referenceData[tempAddress]),UVM_NONE);
                end  
                tempAddress++;
              end 
              else begin 
               nonExistantMemRead++;
               `uvm_info("NON EXISTANT READ",$sformatf("READING FROM LOCATION %0h which doesnt exist so read slaver os %0s",tempAddress,t1.rresp),UVM_HIGH)
                tempAddress++;
              end
            end
           end
             
          

          2'b10:begin 
            
             for(int k=0,j=0; k< ((2**(axi_master_address_tx.arsize))- (alignAmount));k++) begin      
              if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin
                `uvm_info("SCOREBOARD","ADDRESS OUTSIDE SLAVE ADDRESS RANGE",UVM_HIGH) 
              end 
              if(referenceData.exists(tempAddress) ==1) begin
                j = tempAddress % (DATA_WIDTH/8);
              
                if(referenceData[tempAddress] != t1.rdata[0][8*j+7-:8])begin 
                  `uvm_error("READ CHECK FAIL",$sformatf("THE BYTE DOESNT MATCH IN THE POSITION %0d when reference byte is %0d and actual one is %0d",j,readCompare,t1.rdata[0][8*j+7-:8]))
                  byte_data_cmp_failed_rdata_count++;
                end   
                else begin 
                 byte_data_cmp_verified_rdata_count++;
                  `uvm_info("READ CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d",j),UVM_NONE);
                end 
                tempAddress++;
              end
              else begin 
               nonExistantMemRead++;
               `uvm_info("NON EXISTANT READ",$sformatf("READING FROM LOCATION %0h which doesnt exist so read slaver os %0s",tempAddress,t1.rresp),UVM_HIGH)
                tempAddress++;
              end 
              if(tempAddress == wrapEndAddress)
                 tempAddress = wrapStartAddress; 
            end 
              
          end 
        endcase   
    end 
join_none

endtask : run_phase


//--------------------------------------------------------------------------------------------
// Task : axi4_write_address_comparision
// Used to compare the received master and slave write address
// Parameter :
//  axi4_master_tx_h1 - axi4_master_tx
//  axi4_slave_tx_h1  - axi4_slave_tx
//--------------------------------------------------------------------------------------------
task axi4_scoreboard::axi4_write_address_comparision(input axi4_master_tx axi4_master_tx_h1,input axi4_slave_tx axi4_slave_tx_h1);
  $display("HHHH COMP");
  if(axi4_master_tx_h1.awid == axi4_slave_tx_h1.awid)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awid from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_AWID_MATCHED", $sformatf("Master AWID = 'h%0x and Slave AWID = 'h%0x",axi4_master_tx_h1.awid,axi4_slave_tx_h1.awid), UVM_HIGH);             
    byte_data_cmp_verified_awid_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awid from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_AWID_NOT_MATCHED", $sformatf("Master AWID = 'h%0x and Slave AWID = 'h%0x",axi4_master_tx_h1.awid,axi4_slave_tx_h1.awid), UVM_HIGH);             
    byte_data_cmp_failed_awid_count++;
  end
  
  if(axi4_master_tx_h1.awaddr == axi4_slave_tx_h1.awaddr)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awaddr from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_AWADDR_MATCHED", $sformatf("Master AWADDR = 'h%0x and Slave AWADDR = 'h%0x",axi4_master_tx_h1.awaddr,axi4_slave_tx_h1.awaddr), UVM_HIGH);             
    byte_data_cmp_verified_awaddr_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awaddr from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_AWADDR_NOT_MATCHED", $sformatf("Master AWADDR = 'h%0x and Slave AWADDR = 'h%0x",axi4_master_tx_h1.awaddr,axi4_slave_tx_h1.awaddr), UVM_HIGH);             
    byte_data_cmp_failed_awaddr_count++;
  end

  if(axi4_master_tx_h1.awlen == axi4_slave_tx_h1.awlen)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awlen from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_awlen_MATCHED", $sformatf("Master awlen = 'h%0x and Slave awlen = 'h%0x",axi4_master_tx_h1.awlen,axi4_slave_tx_h1.awlen), UVM_HIGH);             
    byte_data_cmp_verified_awlen_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awlen from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_awlen_NOT_MATCHED", $sformatf("Master awlen = 'h%0x and Slave awlen = 'h%0x",axi4_master_tx_h1.awlen,axi4_slave_tx_h1.awlen), UVM_HIGH);             
    byte_data_cmp_failed_awlen_count++;
  end

  if(axi4_master_tx_h1.awsize == axi4_slave_tx_h1.awsize)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awsize from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_awsize_MATCHED", $sformatf("Master awsize = 'h%0x and Slave awsize = 'h%0x",axi4_master_tx_h1.awsize,axi4_slave_tx_h1.awsize), UVM_HIGH);             
    byte_data_cmp_verified_awsize_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awsize from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_awsize_NOT_MATCHED", $sformatf("Master awsize = 'h%0x and Slave awsize = 'h%0x",axi4_master_tx_h1.awsize,axi4_slave_tx_h1.awsize), UVM_HIGH);             
    byte_data_cmp_failed_awsize_count++;
  end

  if(axi4_master_tx_h1.awburst == axi4_slave_tx_h1.awburst)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awburst from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_awburst_MATCHED", $sformatf("Master awburst = 'h%0x and Slave awburst = 'h%0x",axi4_master_tx_h1.awburst,axi4_slave_tx_h1.awburst), UVM_HIGH);             
    byte_data_cmp_verified_awburst_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awburst from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_awburst_NOT_MATCHED", $sformatf("Master awburst = 'h%0x and Slave awburst = 'h%0x",axi4_master_tx_h1.awburst,axi4_slave_tx_h1.awburst), UVM_HIGH);             
    byte_data_cmp_failed_awburst_count++;
  end

  if(axi4_master_tx_h1.awlock == axi4_slave_tx_h1.awlock)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awlock from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_awlock_MATCHED", $sformatf("Master awlock = 'h%0x and Slave awlock = 'h%0x",axi4_master_tx_h1.awlock,axi4_slave_tx_h1.awlock), UVM_HIGH);             
    byte_data_cmp_verified_awlock_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awlock from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_awlock_NOT_MATCHED", $sformatf("Master awlock = 'h%0x and Slave awlock = 'h%0x",axi4_master_tx_h1.awlock,axi4_slave_tx_h1.awlock), UVM_HIGH);             
    byte_data_cmp_failed_awlock_count++;
  end

  if(axi4_master_tx_h1.awcache == axi4_slave_tx_h1.awcache)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awcache from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_awcache_MATCHED", $sformatf("Master awcache = 'h%0x and Slave awcache = 'h%0x",axi4_master_tx_h1.awcache,axi4_slave_tx_h1.awcache), UVM_HIGH);             
    byte_data_cmp_verified_awcache_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awcache from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_awcache_NOT_MATCHED", $sformatf("Master awcache = 'h%0x and Slave awcache = 'h%0x",axi4_master_tx_h1.awcache,axi4_slave_tx_h1.awcache), UVM_HIGH);             
    byte_data_cmp_failed_awcache_count++;
  end

  if(axi4_master_tx_h1.awprot == axi4_slave_tx_h1.awprot)begin
    `uvm_info(get_type_name(),$sformatf("axi4_awprot from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_awprot_MATCHED", $sformatf("Master awprot = 'h%0x and Slave awprot = 'h%0x",axi4_master_tx_h1.awprot,axi4_slave_tx_h1.awprot), UVM_HIGH);             
    byte_data_cmp_verified_awprot_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_awprot from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_awprot_NOT_MATCHED", $sformatf("Master awprot = 'h%0x and Slave awprot = 'h%0x",axi4_master_tx_h1.awprot,axi4_slave_tx_h1.awprot), UVM_HIGH);
    byte_data_cmp_failed_awprot_count++;
  end

endtask : axi4_write_address_comparision


//--------------------------------------------------------------------------------------------
// Task : axi4_write_response_comparision
// Used to compare the received master and slave write response
// Parameter :
//  axi4_master_tx_h3 - axi4_master_tx
//  axi4_slave_tx_h3  - axi4_slave_tx
//--------------------------------------------------------------------------------------------
task axi4_scoreboard::axi4_write_response_comparision(input axi4_master_tx axi4_master_tx_h3,input axi4_slave_tx axi4_slave_tx_h3);

  if(axi4_master_tx_h3.bid == axi4_slave_tx_h3.bid)begin
    `uvm_info(get_type_name(),$sformatf("axi4_bid from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_bid_MATCHED", $sformatf("Master bid = %0p and Slave bid = %0p",axi4_master_tx_h3.bid,axi4_slave_tx_h3.bid), UVM_HIGH);             
    byte_data_cmp_verified_bid_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_bid from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_bid_NOT_MATCHED", $sformatf("Master bid = %0p and Slave bid = %0p",axi4_master_tx_h3.bid,axi4_slave_tx_h3.bid), UVM_HIGH);             
  end

  if(axi4_master_tx_h3.bresp == axi4_slave_tx_h3.bresp)begin
    `uvm_info(get_type_name(),$sformatf("axi4_bresp from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_bresp_MATCHED", $sformatf("Master bresp = %0p and Slave bresp = %0p",axi4_master_tx_h3.bresp,axi4_slave_tx_h3.bresp), UVM_HIGH);             
    byte_data_cmp_verified_bresp_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_bresp from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_bresp_NOT_MATCHED", $sformatf("Master bresp = %0p and Slave bresp = %0p",axi4_master_tx_h3.bresp,axi4_slave_tx_h3.bresp), UVM_HIGH);             
  end

  if(axi4_master_tx_h3.buser == axi4_slave_tx_h3.buser)begin
    `uvm_info(get_type_name(),$sformatf("axi4_buser from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_buser_MATCHED", $sformatf("Master buser = 'h%0x and Slave buser = 'h%0x",axi4_master_tx_h3.buser,axi4_slave_tx_h3.buser), UVM_HIGH);             
    byte_data_cmp_verified_buser_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_buser from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_buser_NOT_MATCHED", $sformatf("Master buser = 'h%0x and Slave buser = 'h%0x",axi4_master_tx_h3.buser,axi4_slave_tx_h3.buser), UVM_HIGH);             
  end
endtask : axi4_write_response_comparision

//--------------------------------------------------------------------------------------------
// Task : axi4_read_address_comparision
// Used to compare the received master and slave read address
// Parameter :
//  axi4_master_tx_h4 - axi4_master_tx
//  axi4_slave_tx_h4  - axi4_slave_tx
//--------------------------------------------------------------------------------------------
task axi4_scoreboard::axi4_read_address_comparision(input axi4_master_tx axi4_master_tx_h4,input axi4_slave_tx axi4_slave_tx_h4);

  
  if(axi4_master_tx_h4.arid == axi4_slave_tx_h4.arid)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arid from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arID_MATCHED", $sformatf("Master arID = 'h%0x and Slave arID = 'h%0x",axi4_master_tx_h4.arid,axi4_slave_tx_h4.arid), UVM_HIGH);             
    byte_data_cmp_verified_arid_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arid from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arID_NOT_MATCHED", $sformatf("Master arID = 'h%0x and Slave arID = 'h%0x",axi4_master_tx_h4.arid,axi4_slave_tx_h4.arid), UVM_HIGH);             
  end
  
  if(axi4_master_tx_h4.araddr == axi4_slave_tx_h4.araddr)begin
    `uvm_info(get_type_name(),$sformatf("axi4_araddr from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arADDR_MATCHED", $sformatf("Master arADDR = 'h%0x and Slave arADDR = 'h%0x",axi4_master_tx_h4.araddr,axi4_slave_tx_h4.araddr), UVM_HIGH);             
    byte_data_cmp_verified_araddr_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_araddr from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arADDR_NOT_MATCHED", $sformatf("Master arADDR = 'h%0x and Slave arADDR = 'h%0x",axi4_master_tx_h4.araddr,axi4_slave_tx_h4.araddr), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arlen == axi4_slave_tx_h4.arlen)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arlen from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arlen_MATCHED", $sformatf("Master arlen = 'h%0x and Slave arlen = 'h%0x",axi4_master_tx_h4.arlen,axi4_slave_tx_h4.arlen), UVM_HIGH);             
    byte_data_cmp_verified_arlen_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arlen from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arlen_NOT_MATCHED", $sformatf("Master arlen = 'h%0x and Slave arlen = 'h%0x",axi4_master_tx_h4.arlen,axi4_slave_tx_h4.arlen), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arsize == axi4_slave_tx_h4.arsize)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arsize from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arsize_MATCHED", $sformatf("Master arsize = 'h%0x and Slave arsize = 'h%0x",axi4_master_tx_h4.arsize,axi4_slave_tx_h4.arsize), UVM_HIGH);             
    byte_data_cmp_verified_arsize_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arsize from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arsize_NOT_MATCHED", $sformatf("Master arsize = 'h%0x and Slave arsize = 'h%0x",axi4_master_tx_h4.arsize,axi4_slave_tx_h4.arsize), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arburst == axi4_slave_tx_h4.arburst)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arburst from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arburst_MATCHED", $sformatf("Master arburst = 'h%0x and Slave arburst = 'h%0x",axi4_master_tx_h4.arburst,axi4_slave_tx_h4.arburst), UVM_HIGH);             
    byte_data_cmp_verified_arburst_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arburst from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arburst_NOT_MATCHED", $sformatf("Master arburst = 'h%0x and Slave arburst = 'h%0x",axi4_master_tx_h4.arburst,axi4_slave_tx_h4.arburst), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arlock == axi4_slave_tx_h4.arlock)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arlock from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arlock_MATCHED", $sformatf("Master arlock = 'h%0x and Slave arlock = 'h%0x",axi4_master_tx_h4.arlock,axi4_slave_tx_h4.arlock), UVM_HIGH);             
    byte_data_cmp_verified_arlock_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arlock from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arlock_NOT_MATCHED", $sformatf("Master arlock = 'h%0x and Slave arlock = 'h%0x",axi4_master_tx_h4.arlock,axi4_slave_tx_h4.arlock), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arcache == axi4_slave_tx_h4.arcache)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arcache from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arcache_MATCHED", $sformatf("Master arcache = 'h%0x and Slave arcache = 'h%0x",axi4_master_tx_h4.arcache,axi4_slave_tx_h4.arcache), UVM_HIGH);             
    byte_data_cmp_verified_arcache_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arcache from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arcache_NOT_MATCHED", $sformatf("Master arcache = 'h%0x and Slave arcache = 'h%0x",axi4_master_tx_h4.arcache,axi4_slave_tx_h4.arcache), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arprot == axi4_slave_tx_h4.arprot)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arprot from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arprot_MATCHED", $sformatf("Master arprot = 'h%0x and Slave arprot = 'h%0x",axi4_master_tx_h4.arprot,axi4_slave_tx_h4.arprot), UVM_HIGH);             
    byte_data_cmp_verified_arprot_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arprot from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arprot_NOT_MATCHED", $sformatf("Master arprot = 'h%0x and Slave arprot = 'h%0x",axi4_master_tx_h4.arprot,axi4_slave_tx_h4.arprot), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arregion == axi4_slave_tx_h4.arregion)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arregion from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arregion_MATCHED", $sformatf("Master arregion = 'h%0x and Slave arregion = 'h%0x",axi4_master_tx_h4.arregion,axi4_slave_tx_h4.arregion), UVM_HIGH);             
    byte_data_cmp_verified_arregion_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arregion from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arregion_NOT_MATCHED", $sformatf("Master arregion = 'h%0x and Slave arregion = 'h%0x",axi4_master_tx_h4.arregion,axi4_slave_tx_h4.arregion), UVM_HIGH);             
  end

  if(axi4_master_tx_h4.arqos == axi4_slave_tx_h4.arqos)begin
    `uvm_info(get_type_name(),$sformatf("axi4_arqos from master and slave is equal"),UVM_HIGH);
    `uvm_info("SB_arqos_MATCHED", $sformatf("Master arqos = 'h%0x and Slave arqos = 'h%0x",axi4_master_tx_h4.arqos,axi4_slave_tx_h4.arqos), UVM_HIGH);             
    byte_data_cmp_verified_arqos_count++;
  end
  else begin
    `uvm_info(get_type_name(),$sformatf("axi4_arqos from master and slave is  not equal"),UVM_HIGH);
    `uvm_info("SB_arqos_NOT_MATCHED", $sformatf("Master arqos = 'h%0x and Slave arqos = 'h%0x",axi4_master_tx_h4.arqos,axi4_slave_tx_h4.arqos), UVM_HIGH);             
  end
endtask : axi4_read_address_comparision


//--------------------------------------------------------------------------------------------
// Function: check_phase
// Display the result of simulation
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_scoreboard::check_phase(uvm_phase phase);
  super.check_phase(phase);
/*
  `uvm_info(get_type_name(),$sformatf("--\n----------------------------------------------SCOREBOARD CHECK PHASE---------------------------------------"),UVM_HIGH) 
  
  `uvm_info (get_type_name(),$sformatf(" Scoreboard Check Phase is starting"),UVM_HIGH); 
  
  //--------------------------------------------------------------------------------------------
  // 1.Check if the comparisions counter is NON-zero
  //   A non-zero value indicates that the comparisions never happened and throw error
  // 2.Initial count of the failed count is zero
  //   If the failed count is more than 0 it means comparision is failed and gives error  
  //--------------------------------------------------------------------------------------------

  //-------------------------------------------------------
  // Write_Address_Channel comparision
  //-------------------------------------------------------
  if(axi4_env_cfg_h.write_read_mode_h == ONLY_WRITE_DATA || axi4_env_cfg_h.write_read_mode_h == WRITE_READ_DATA) begin
    if ((byte_data_cmp_verified_awid_count != 0) && (byte_data_cmp_failed_awid_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awid count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awid_count :%0d",
                                              byte_data_cmp_verified_awid_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awid_count : %0d", 
                                              byte_data_cmp_failed_awid_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awid count comparisions are failed"));
    end

    if ((byte_data_cmp_verified_awaddr_count != 0) && (byte_data_cmp_failed_awaddr_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awaddr count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awaddr_count :%0d",
                                              byte_data_cmp_verified_awaddr_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awaddr_count : %0d", 
                                              byte_data_cmp_failed_awaddr_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awaddr count comparisions are failed"));
    end

    if ((byte_data_cmp_verified_awsize_count != 0) && (byte_data_cmp_failed_awsize_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awsize count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awsize_count :%0d",
                                              byte_data_cmp_verified_awsize_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awsize_count : %0d", 
                                              byte_data_cmp_failed_awsize_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awsize count comparisions are failed"));
    end

    if ((byte_data_cmp_verified_awlen_count != 0) && (byte_data_cmp_failed_awlen_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awlen count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awlen_count :%0d",
                                              byte_data_cmp_verified_awlen_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awlen_count : %0d", 
                                              byte_data_cmp_failed_awlen_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awlen count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_awburst_count != 0) && (byte_data_cmp_failed_awburst_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awburst count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awburst_count :%0d",
                                              byte_data_cmp_verified_awburst_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awburst_count : %0d", 
                                              byte_data_cmp_failed_awburst_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awburst count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_awcache_count != 0) && (byte_data_cmp_failed_awcache_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awcache count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awcache_count :%0d",
                                              byte_data_cmp_verified_awcache_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awcache_count : %0d", 
                                              byte_data_cmp_failed_awcache_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awcache count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_awlock_count != 0) && (byte_data_cmp_failed_awlock_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awlock count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awlock_count :%0d",
                                              byte_data_cmp_verified_awlock_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awlock_count : %0d", 
                                              byte_data_cmp_failed_awlock_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awlock count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_awprot_count != 0) && (byte_data_cmp_failed_awprot_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("awprot count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awprot_count :%0d",
                                              byte_data_cmp_verified_awprot_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awprot_count : %0d", 
                                              byte_data_cmp_failed_awprot_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("awprot count comparisions are failed"));
    end
    
    //-------------------------------------------------------
    // Write_Data_Channel comparision
    //-------------------------------------------------------
    
    if ((byte_data_cmp_verified_wdata_count != 0) && (byte_data_cmp_failed_wdata_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("wdata count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_wdata_count :%0d",
                                              byte_data_cmp_verified_wdata_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_wdata_count : %0d", 
                                              byte_data_cmp_failed_wdata_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("wdata count comparisions are failed"));
    end 


    if ((byte_data_cmp_verified_wstrb_count != 0) && (byte_data_cmp_failed_wstrb_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("wstrb count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_wstrb_count :%0d",
                                              byte_data_cmp_verified_wstrb_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_wstrb_count : %0d", 
                                              byte_data_cmp_failed_wstrb_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("wstrb count comparisions are failed"));
    end 


    if ((byte_data_cmp_verified_wuser_count != 0) && (byte_data_cmp_failed_wuser_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("wuser count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_wuser_count :%0d",
                                              byte_data_cmp_verified_wuser_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_wuser_count : %0d", 
                                              byte_data_cmp_failed_wuser_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("wuser count comparisions are failed"));
    end 

    //-------------------------------------------------------
    // Write_Response_Channel comparision
    //-------------------------------------------------------


    if ((byte_data_cmp_verified_bid_count != 0) && (byte_data_cmp_failed_bid_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("bid count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_bid_count :%0d",
                                              byte_data_cmp_verified_bid_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_bid_count : %0d", 
                                              byte_data_cmp_failed_bid_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("bid count comparisions are failed"));
    end 


    if ((byte_data_cmp_verified_bresp_count != 0) && (byte_data_cmp_failed_bresp_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("bresp count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_bresp_count :%0d",
                                              byte_data_cmp_verified_bresp_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_bresp_count : %0d", 
                                              byte_data_cmp_failed_bresp_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("bresp count comparisions are failed"));
    end 


    if ((byte_data_cmp_verified_buser_count != 0) && (byte_data_cmp_failed_buser_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("buser count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_buser_count :%0d",
                                              byte_data_cmp_verified_buser_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_buser_count : %0d", 
                                              byte_data_cmp_failed_buser_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("buser count comparisions are failed"));
    end 
  end

  //-------------------------------------------------------
  // Read_Address_Channel comparision
  //-------------------------------------------------------
  if(axi4_env_cfg_h.write_read_mode_h == ONLY_READ_DATA || axi4_env_cfg_h.write_read_mode_h == WRITE_READ_DATA) begin
    if ((byte_data_cmp_verified_arid_count != 0) && (byte_data_cmp_failed_arid_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arid count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arid_count :%0d",
                                              byte_data_cmp_verified_arid_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arid_count : %0d", 
                                              byte_data_cmp_failed_arid_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arid count comparisions are failed"));
    end

    if ((byte_data_cmp_verified_araddr_count != 0) && (byte_data_cmp_failed_araddr_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("araddr count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_araddr_count :%0d",
                                              byte_data_cmp_verified_araddr_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_araddr_count : %0d", 
                                              byte_data_cmp_failed_araddr_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("araddr count comparisions are failed"));
    end

    if ((byte_data_cmp_verified_arsize_count != 0) && (byte_data_cmp_failed_arsize_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arsize count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arsize_count :%0d",
                                              byte_data_cmp_verified_arsize_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arsize_count : %0d", 
                                              byte_data_cmp_failed_arsize_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arsize count comparisions are failed"));
    end

    if ((byte_data_cmp_verified_arlen_count != 0) && (byte_data_cmp_failed_arlen_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arlen count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arlen_count :%0d",
                                              byte_data_cmp_verified_arlen_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arlen_count : %0d", 
                                              byte_data_cmp_failed_arlen_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arlen count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_arburst_count != 0) && (byte_data_cmp_failed_arburst_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arburst count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arburst_count :%0d",
                                              byte_data_cmp_verified_arburst_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arburst_count : %0d", 
                                              byte_data_cmp_failed_arburst_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arburst count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_arcache_count != 0) && (byte_data_cmp_failed_arcache_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arcache count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arcache_count :%0d",
                                              byte_data_cmp_verified_arcache_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arcache_count : %0d", 
                                              byte_data_cmp_failed_arcache_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arcache count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_arlock_count != 0) && (byte_data_cmp_failed_arlock_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arlock count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arlock_count :%0d",
                                              byte_data_cmp_verified_arlock_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arlock_count : %0d", 
                                              byte_data_cmp_failed_arlock_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arlock count comparisions are failed"));
    end
    
    if ((byte_data_cmp_verified_arprot_count != 0) && (byte_data_cmp_failed_arprot_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arprot count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arprot_count :%0d",
                                              byte_data_cmp_verified_arprot_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arprot_count : %0d", 
                                              byte_data_cmp_failed_arprot_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arprot count comparisions are failed"));
    end
 
    if ((byte_data_cmp_verified_arregion_count != 0) && (byte_data_cmp_failed_arregion_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arregion count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arregion_count :%0d",
                                              byte_data_cmp_verified_arregion_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arregion_count : %0d", 
                                              byte_data_cmp_failed_arregion_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arregion count comparisions are failed"));
    end

    if ((byte_data_cmp_verified_arqos_count != 0) && (byte_data_cmp_failed_arqos_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("arqos count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arqos_count :%0d",
                                              byte_data_cmp_verified_arqos_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arqos_count : %0d", 
                                              byte_data_cmp_failed_arqos_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("arqos count comparisions are failed"));
    end 

    //-------------------------------------------------------
    // Read_Data_Channel comparision
    //-------------------------------------------------------
    if ((byte_data_cmp_verified_rid_count != 0) && (byte_data_cmp_failed_rid_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("rid count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_rid_count :%0d",
                                              byte_data_cmp_verified_rid_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_rid_count : %0d", 
                                              byte_data_cmp_failed_rid_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("rid count comparisions are failed"));
    end

     if ((byte_data_cmp_verified_rdata_count != 0) && (byte_data_cmp_failed_rdata_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("rdata count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_rdata_count :%0d",
                                              byte_data_cmp_verified_rdata_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_rdata_count : %0d", 
                                              byte_data_cmp_failed_rdata_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("rdata count comparisions are failed"));
    end


     if ((byte_data_cmp_verified_rresp_count != 0) && (byte_data_cmp_failed_rresp_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("rresp count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_rresp_count :%0d",
                                              byte_data_cmp_verified_rresp_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_rresp_count : %0d", 
                                              byte_data_cmp_failed_rresp_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("rresp count comparisions are failed"));
    end

     if ((byte_data_cmp_verified_ruser_count != 0) && (byte_data_cmp_failed_ruser_count == 0)) begin
	    `uvm_info (get_type_name(), $sformatf ("ruser count comparisions are succesful"),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_ruser_count :%0d",
                                              byte_data_cmp_verified_ruser_count),UVM_HIGH);
	    `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_ruser_count : %0d", 
                                              byte_data_cmp_failed_ruser_count),UVM_HIGH);
      `uvm_error (get_type_name(), $sformatf ("ruser count comparisions are failed"));
    end
  end


  //--------------------------------------------------------------------------------------------
  // 2.Check if master packets received are same as slave packets received
  //   To Make sure that we have equal number of master and slave packets
  //--------------------------------------------------------------------------------------------
  
  //--------------------------------------------------------------------------------------------
  // 3.Analysis fifos must be zero - This will indicate that all the packets have been compared
  //   This is to make sure that we have taken all packets from both FIFOs and made the comparisions
  //--------------------------------------------------------------------------------------------
  if (axi4_master_write_address_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 Master write address analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_master_write_address_analysis_fifo:%0d",axi4_master_write_address_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 Master write address analysis FIFO is not empty"));
  end

  if (axi4_master_write_data_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 Master write data analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_master_write_data_analysis_fifo:%0d",axi4_master_write_data_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 Master write data analysis FIFO is not empty"));
  end

  if (axi4_master_write_response_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 Master write response analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_master_write_response_analysis_fifo:%0d",axi4_master_write_response_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 Master write response analysis FIFO is not empty"));
  end
 
  if (axi4_master_read_address_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 Master read address analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_master_read_address_analysis_fifo:%0d",axi4_master_read_address_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 Master read address analysis FIFO is not empty"));
  end

  if (axi4_master_read_data_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 Master read data analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_master_read_data_analysis_fifo:%0d",axi4_master_read_data_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 Master read data analysis FIFO is not empty"));
  end

  if (axi4_slave_write_address_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 slave write address analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_slave_write_address_analysis_fifo:%0d",axi4_slave_write_address_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 slave write address analysis FIFO is not empty"));
  end

  if (axi4_slave_write_data_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 slave write data analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_slave_write_data_analysis_fifo:%0d",axi4_slave_write_data_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 slave write data analysis FIFO is not empty"));
  end

  if (axi4_slave_write_response_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 slave write response analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_slave_write_response_analysis_fifo:%0d",axi4_slave_write_response_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 slave write response analysis FIFO is not empty"));
  end
 
  if (axi4_slave_read_address_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 slave read address analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_slave_read_address_analysis_fifo:%0d",axi4_slave_read_address_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 slave read address analysis FIFO is not empty"));
  end

  if (axi4_slave_read_data_analysis_fifo.size() == 0) begin
    `uvm_info (get_type_name(), $sformatf ("axi4 slave read data analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("axi4_slave_read_data_analysis_fifo:%0d",axi4_slave_read_data_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("axi4 slave read data analysis FIFO is not empty"));
  end

  `uvm_info(get_type_name(),$sformatf("--\n----------------------------------------------END OF SCOREBOARD CHECK PHASE---------------------------------------"),UVM_HIGH)
*/
endfunction : check_phase

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Display the result of simulation
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_scoreboard::report_phase(uvm_phase phase);
  super.report_phase(phase);
  
  //$display(" ");
  //$display("-------------------------------------------- ");
    $display("SCOREBOARD REPORT PHASE");
  //$display("-------------------------------------------- ");
  //$display(" ");
  
  $display("WRITE_ADDRESS_PHASE");

  //Number of awid comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awid comparisions:%0d",byte_data_cmp_verified_awid_count+byte_data_cmp_failed_awid_count),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awid failed comparisions:%0d",byte_data_cmp_failed_awid_count),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awid verified comparisions:%0d",byte_data_cmp_verified_awid_count),UVM_HIGH);

 
  //Number of awaddr comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr comparisions:%0d",byte_data_cmp_verified_awaddr_count+byte_data_cmp_failed_awaddr_count),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr failed comparisions:%0d",byte_data_cmp_failed_awaddr_count),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr verified comparisions:%0d",byte_data_cmp_verified_awaddr_count ),UVM_HIGH);


  //Number of awsize comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awsize comparisions:%0d",byte_data_cmp_verified_awsize_count+byte_data_cmp_failed_awsize_count),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awsize failed comparisions:%0d",byte_data_cmp_failed_awsize_count),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awsize verified comparisions:%0d",byte_data_cmp_verified_awsize_count ),UVM_HIGH);
  
  
  //Number of awlen comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlen comparisions:%0d" ,byte_data_cmp_verified_awlen_count+byte_data_cmp_failed_awlen_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlen failed comparisions:%0d" ,byte_data_cmp_failed_awlen_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlen verified comparisions:%0d" ,byte_data_cmp_verified_awlen_count ),UVM_HIGH);
  
  
  //Number of awburst comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awburst comparisions:%0d",byte_data_cmp_verified_awburst_count+byte_data_cmp_failed_awburst_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awburst failed comparisions:%0d",byte_data_cmp_failed_awburst_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awburst verified comparisions:%0d",byte_data_cmp_verified_awburst_count ),UVM_HIGH);
  
  
  //Number of awcache comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awcache comparisions:%0d",byte_data_cmp_verified_awcache_count+byte_data_cmp_failed_awcache_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awcache failed comparisions:%0d",byte_data_cmp_failed_awcache_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awcache verified comparisions:%0d",byte_data_cmp_verified_awcache_count ),UVM_HIGH);
  
  
  //Number of awlock comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlock comparisions:%0d",byte_data_cmp_verified_awlock_count+byte_data_cmp_failed_awlock_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlock failed comparisions:%0d",byte_data_cmp_failed_awlock_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlock verified comparisions:%0d",byte_data_cmp_verified_awlock_count ),UVM_HIGH);
  
  
  //Number of awprot comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awprot comparisions:%0d",byte_data_cmp_verified_awprot_count+byte_data_cmp_failed_awprot_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awprot failed comparisions:%0d",byte_data_cmp_failed_awprot_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awprot verified comparisions:%0d",byte_data_cmp_verified_awprot_count ),UVM_HIGH);
  
  $display("WRITE_DATA_PHASE");
  
  //Number of wdata comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wdata comparisions:%0d",byte_data_cmp_verified_wdata_count+byte_data_cmp_failed_wdata_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wdata failed comparisions:%0d",byte_data_cmp_failed_wdata_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wdata verified comparisions:%0d",byte_data_cmp_verified_wdata_count ),UVM_HIGH);
  
  
  //Number of wstrb comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wstrb comparisions:%0d",byte_data_cmp_verified_wstrb_count+byte_data_cmp_failed_wstrb_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wstrb failed comparisions:%0d",byte_data_cmp_failed_wstrb_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wstrb verified comparisions:%0d",byte_data_cmp_verified_wstrb_count ),UVM_HIGH);
 
  
  //Number of wuser comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wuser comparisions:%0d",byte_data_cmp_verified_wuser_count+byte_data_cmp_failed_wuser_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wuser failed comparisions:%0d",byte_data_cmp_failed_wuser_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wuser verified comparisions:%0d",byte_data_cmp_verified_wuser_count ),UVM_HIGH);
 
  $display("WRITE_RESPONSE_PHASE");
  
  //Number of bid comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bid comparisions:%0d",byte_data_cmp_verified_bid_count+byte_data_cmp_failed_bid_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bid failed comparisions:%0d",byte_data_cmp_failed_bid_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bid verified comparisions:%0d",byte_data_cmp_verified_bid_count ),UVM_HIGH);
 
  //Number of bresp comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bresp comparisions:%0d",byte_data_cmp_verified_bresp_count+byte_data_cmp_failed_bresp_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bresp failed comparisions:%0d",byte_data_cmp_failed_bresp_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bresp verified comparisions:%0d",byte_data_cmp_verified_bresp_count ),UVM_HIGH);

  // $display(" ");
  //$display("-------------------------------------------- ");
  $display("SCOREBOARD WRITE ADDRESS PACKETS");
  //$display("-------------------------------------------- ");
  //$display(" ");
    `uvm_info(get_type_name(),$sformatf("scoreboard's write address packets count  from master   \n %0d",axi4_master_tx_awaddr_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's write address packets count  from slave    \n %0d",axi4_slave_tx_awaddr_count),UVM_HIGH)
    //`uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr verified comparisions:%0d",byte_data_cmp_verified_awaddr_count ),UVM_NONE);
  //`uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr failed comparisions:%0d",byte_data_cmp_failed_awaddr_count ),UVM_NONE);
 
  //$display(" ");
  //$display("-------------------------------------------- ");
  $display("SCOREBOARD WRITE DATA PACKETS");
  //$display("-------------------------------------------- ");
  //$display(" ");
    `uvm_info(get_type_name(),$sformatf("scoreboard's  write data packets count from master \n %0d",axi4_master_tx_wdata_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's  write data packets count from slave   \n %0d",axi4_slave_tx_wdata_count),UVM_HIGH)
  
  //$display(" ");
  $display("-------------------------------------------- ");
  $display("SCOREBOARD WRITE RESPONSE PACKETS");
  $display("-------------------------------------------- ");
  //$display(" ");
    `uvm_info(get_type_name(),$sformatf("scoreboard's write response packets count from master \n %0d",axi4_master_tx_bresp_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's write response packets count from slave  \n %0d",axi4_slave_tx_bresp_count),UVM_HIGH)
  

  
  $display("-------------------------------------------- ");
  $display("READ_ADDRESS_PHASE");
  $display("-------------------------------------------- ");
  
  //Number of arid comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arid comparisions:%0d",byte_data_cmp_verified_arid_count+byte_data_cmp_failed_arid_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arid failed comparisions:%0d",byte_data_cmp_failed_arid_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arid verified comparisions:%0d",byte_data_cmp_verified_arid_count ),UVM_HIGH);
  
  
  //Number of araddr comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise araddr comparisions:%0d",byte_data_cmp_verified_araddr_count+byte_data_cmp_failed_araddr_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise araddr failed comparisions:%0d",byte_data_cmp_failed_araddr_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise araddr verified comparisions:%0d",byte_data_cmp_verified_araddr_count ),UVM_HIGH);
 
  
  //Number of arsize comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arsize comparisions:%0d",byte_data_cmp_verified_arsize_count+byte_data_cmp_failed_arsize_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arsize failed comparisions:%0d",byte_data_cmp_failed_arsize_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arsize verified comparisions:%0d",byte_data_cmp_verified_arsize_count ),UVM_HIGH);
  
  
  //Number of arlen comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlen comparisions:%0d",byte_data_cmp_verified_arlen_count+byte_data_cmp_failed_arlen_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlen failed comparisions:%0d",byte_data_cmp_failed_arlen_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlen verified comparisions:%0d",byte_data_cmp_verified_arlen_count ),UVM_HIGH);

  
  //Number of arburst comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arburst comparisions:%0d",byte_data_cmp_verified_arburst_count+byte_data_cmp_failed_arburst_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arburst failed comparisions:%0d",byte_data_cmp_failed_arburst_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arburst verified comparisions:%0d",byte_data_cmp_verified_arburst_count ),UVM_HIGH);
 
  
  //Number of arcache comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arcache comparisions:%0d",byte_data_cmp_verified_arcache_count+byte_data_cmp_failed_arcache_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arcache failed comparisions:%0d",byte_data_cmp_failed_arcache_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arcache verified comparisions:%0d",byte_data_cmp_verified_arcache_count ),UVM_HIGH);
  
  
  //Number of arlock comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlock comparisions:%0d",byte_data_cmp_verified_arlock_count+byte_data_cmp_failed_arlock_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlock failed comparisions:%0d",byte_data_cmp_failed_arlock_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlock verified comparisions:%0d",byte_data_cmp_verified_arlock_count ),UVM_HIGH);
  
  
  //Number of arprot comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arprot  comparisions:%0d",byte_data_cmp_verified_arprot_count+byte_data_cmp_failed_arprot_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arprot failed comparisions:%0d",byte_data_cmp_failed_arprot_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arprot verified comparisions:%0d",byte_data_cmp_verified_arprot_count ),UVM_HIGH);
  
  
  //Number of arregion comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arregion comparisions:%0d",byte_data_cmp_verified_arregion_count+byte_data_cmp_failed_arregion_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arregion failed comparisions:%0d",byte_data_cmp_failed_arregion_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arregion verified comparisions:%0d",byte_data_cmp_verified_arregion_count ),UVM_HIGH);
 
  
  //Number of arqos comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arqos comparisions:%0d",byte_data_cmp_verified_arqos_count+byte_data_cmp_failed_arqos_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arqos failed comparisions:%0d",byte_data_cmp_failed_arqos_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arqos verified comparisions:%0d",byte_data_cmp_verified_arqos_count ),UVM_HIGH);
  
  $display("READ_DATA_PHASE");
 
  //Number of rid comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rid comparisions:%0d",byte_data_cmp_verified_rid_count+byte_data_cmp_failed_rid_count ),UVM_HIGH);
  
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rid failed comparisions:%0d",byte_data_cmp_failed_rid_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rid  verified comparisions:%0d",byte_data_cmp_verified_rid_count ),UVM_HIGH);
 
  //Number of rdata comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rdata comparisions:%0d",byte_data_cmp_verified_rdata_count+byte_data_cmp_failed_rdata_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rdata failed comparisions:%0d",byte_data_cmp_failed_rdata_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rdata verified comparisions:%0d",byte_data_cmp_verified_rdata_count ),UVM_HIGH);
  
  
  //Number of rresp comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rresp comparisions:%0d",byte_data_cmp_verified_rresp_count+byte_data_cmp_failed_rresp_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rresp failed comparisions:%0d",byte_data_cmp_failed_rresp_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rresp verified comparisions:%0d",byte_data_cmp_verified_rresp_count ),UVM_HIGH);
  
  
  //Number of ruser comparisoins done
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise ruser comparisions:%0d",byte_data_cmp_verified_ruser_count+byte_data_cmp_failed_ruser_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise ruser failed comparisions:%0d",byte_data_cmp_failed_ruser_count ),UVM_HIGH);
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise ruser verified comparisions:%0d",byte_data_cmp_verified_ruser_count ),UVM_HIGH);
  
  //$display(" ");
  $display("-------------------------------------------- ");
  $display("SCOREBOARD READ ADDRESS PACKETS");
  $display("-------------------------------------------- ");
  //$display(" ");
    `uvm_info(get_type_name(),$sformatf("scoreboard's read address packets count from master \n %0d",axi4_master_tx_araddr_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's read address packets count from slave  \n %0d",axi4_slave_tx_araddr_count),UVM_HIGH)
  
  //$display(" ");
  $display("-------------------------------------------- ");
  $display("SCOREBOARD READ DATA PACKETS");
  $display("-------------------------------------------- ");
  //$display(" ");
    `uvm_info(get_type_name(),$sformatf("scoreboard's  read data packets count from master \n %0d",axi4_master_tx_rdata_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's  read data packets count from slave  \n %0d",axi4_slave_tx_rdata_count),UVM_HIGH)

    `uvm_info(get_type_name(),$sformatf("scoreboard's  non existant memory read count is \n %0d",nonExistantMemRead),UVM_HIGH)
  //$display(" ");
  $display("-------------------------------------------- ");
  $display("SCOREBOARD READ RESPONSE PACKETS");
  $display("-------------------------------------------- ");
  //$display(" ");
    `uvm_info(get_type_name(),$sformatf("scoreboard's read response packets count from master \n %0d",axi4_master_tx_rresp_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's read response packets count from slave   \n %0d",axi4_slave_tx_rresp_count),UVM_HIGH)

endfunction : report_phase

`endif

