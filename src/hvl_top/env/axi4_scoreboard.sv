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

    bit[7:0]referenceData[longint];
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
    semaphore write_address_key;
    semaphore write_data_key;
    semaphore write_response_key;
    semaphore read_address_key;
    semaphore read_data_key;

    axi4_master_tx t;
    axi4_master_tx temp;
    axi4_slave_tx t1;
    axi4_slave_tx t2;
    logic[7:0] readCompare;
    rresp_e readError;
    bit slave_err;
    int count;
    bit flag1;
    bit flag2;

    // Per-transaction pass/fail tracking
    // A transaction is FAIL if at least one data byte mismatched (wdata for
    // writes, rdata for reads); otherwise it is PASS.
    int total_write_txn, passed_write_txn, failed_write_txn;
    int total_read_txn,  passed_read_txn,  failed_read_txn;
    bit write_txn_failed; // set when any wdata byte of current write txn mismatches
    bit read_txn_failed;  // set when any rdata byte of current read txn mismatches

    //Variable : axi4_env_cfg_h
    //Declaring handle for axi4_env_config_object
    axi4_env_config axi4_env_cfg_h;
    axi4_slave_agent_config axi4_slave_agent_cfg_h;

    uvm_tlm_fifo #(bit[7:0])  referenceFifo;

    int fifoCounter;
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
    end else begin 
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
    axi4_slave_write_address_analysis_fifo = new("axi4_slave_write_address_analysis_fifo",this);
    axi4_slave_write_data_analysis_fifo = new("axi4_slave_write_data_analysis_fifo",this);
    axi4_slave_write_response_analysis_fifo= new("axi4_slave_write_response_analysis_fifo",this);
    axi4_slave_read_address_analysis_fifo = new("axi4_slave_read_address_analysis_fifo",this);
    axi4_slave_read_data_analysis_fifo = new("axi4_slave_read_data_analysis_fifo",this);

    referenceFifo = new("referenceFifo",this,FIFO_SIZE);
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

      begin : read_check
        // Thread-local scratch state, independent of the write-check thread.
        // 'flag', 'axi_master_address_tx', 'tempAddress', 'alignAmount' and the
        // wrap bounds must persist across beats of a burst but stay private to
        // this thread so the write loop can no longer clobber arburst etc.
        int index;
        int indextemp[$];
        bit[ADDRESS_WIDTH-1:0]tempAddress; 
        int alignAmount;
        bit[ADDRESS_WIDTH-1:0] wrapStartAddress, wrapEndAddress;
        bit flag;
        axi4_master_tx axi_master_address_tx;
        axi4_slave_tx  axi_slave_address_tx;
      forever begin
        axi4_slave_read_data_analysis_fifo.get(t1);
        `uvm_info("CHECK","ENTERED READ CHECK",UVM_NONE)
        `uvm_info(get_type_name(),$sformatf("Read check: rlast = %0d",t1.rlast),UVM_HIGH)
        axi4_master_tx_rresp_count++;
        axi4_master_tx_rdata_count++;

        axi4_slave_tx_rdata_count++;
        axi4_slave_tx_rresp_count++;
        if(flag ==0) begin
          indextemp = slaveReadAddressQueue.find_first_index() with(item.arid == t1.rid);
          index = indextemp[0];
          flag2=0;
          read_txn_failed = 0; // new read transaction starts at its first beat

          if(masterReadAddressQueue[index].arid == t1.rid) begin 
            byte_data_cmp_verified_rid_count++;
          end 
          `uvm_info(get_type_name(),$sformatf("masterReadAddressQueue = %p, index = %0d",masterReadAddressQueue,index),UVM_HIGH)
          axi_master_address_tx = masterReadAddressQueue[index];
          axi_slave_address_tx = slaveReadAddressQueue[index];
          tempAddress = axi_master_address_tx.araddr;

          masterReadAddressQueue.delete(index);
          slaveReadAddressQueue.delete(index);
          wrapStartAddress =tempAddress - int'(tempAddress % ((2**(axi_master_address_tx.arsize))* (axi_master_address_tx.arlen +1)));
          wrapEndAddress = wrapStartAddress + (((2**(axi_master_address_tx.arsize))* (axi_master_address_tx.arlen +1)));
          axi4_read_address_comparision(axi_master_address_tx,axi_slave_address_tx); //address check done 
          if(axi_master_address_tx.araddr % (2**axi_master_address_tx.arsize) != 0) begin
            alignAmount = axi_master_address_tx.araddr %((2**(axi_master_address_tx.arsize)));          
          end
          else 
            alignAmount =0;

          `uvm_info(get_type_name(),$sformatf("alignAmount = %0d when araddr = %0d and arsize = %0d",alignAmount,axi_master_address_tx.araddr,axi_master_address_tx.arsize),UVM_HIGH)
          flag=1;
        end
        else begin 
          alignAmount =0;
        end  
        if(t1.rlast ==1) begin
          flag=0;
        end
        `uvm_info(get_type_name(),$sformatf("Burst type = %0d, transfer size = %0d, alignAmount = %0d",axi_master_address_tx.arburst,((2**(axi_master_address_tx.arsize))- (alignAmount)),alignAmount),UVM_HIGH)
        case(axi_master_address_tx.arburst)
          2'b 00: begin 
            for(int k=0,j=0; k< ((2**(axi_master_address_tx.arsize))- (alignAmount));k++) begin 
              if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin 
                `uvm_info("SCOREBOARD","ADDRESS OUTSIDE SLAVE ADDRESS RANGE",UVM_HIGH)
              end    
              j = tempAddress % (DATA_WIDTH/8);
              if(referenceFifo.used()>0) begin
                referenceFifo.get(readCompare);
              end 
              else begin 
                readCompare ='0;
              end 
              if(t1.rdata[0][8*j +:8] !=readCompare) begin 
                `uvm_error("READ CHECK FAIL",$sformatf("THE READ DATA DOESNT MATCH when reference DATA  is %h and actual one is %h",readCompare,t1.rdata[0][8*j+:8]))
                byte_data_cmp_failed_rdata_count++;
                read_txn_failed = 1;
              end
              else begin 
                `uvm_info("READ CHECK PASS",$sformatf("THE READ DATA MATCHES  %h",readCompare),UVM_NONE);
                byte_data_cmp_verified_rdata_count++;
              end              
              tempAddress++;
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
                if(referenceData[tempAddress] != t1.rdata[0][8*j +:8])begin 
                  `uvm_error("READ CHECK FAIL",$sformatf("THE BYTE DOESNT MATCH IN THE POSITION %0d when reference byte is %0d and actual one is %0d",j,referenceData[tempAddress],t1.rdata[0][8*j+7-:8]))
                  byte_data_cmp_failed_rdata_count++;
                  read_txn_failed = 1;

                end   
                else begin 
                  byte_data_cmp_verified_rdata_count++;
                  `uvm_info("READ CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d and reference byte is %0h",j,referenceData[tempAddress]),UVM_NONE);
                end  
                tempAddress++;
              end 
              else begin 
                if(t1.rresp== READ_SLVERR) begin
                  byte_data_cmp_verified_rresp_count++;

                end
                else begin
                  byte_data_cmp_failed_rresp_count++;
                end 
                nonExistantMemRead++;
                `uvm_info("NON EXISTANT READ",$sformatf("READING FROM LOCATION %0h which doesnt exist so read slaver os %0s",tempAddress,t1.rresp),UVM_NONE)
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

                if(referenceData[tempAddress] != t1.rdata[0][8*j +:8])begin 
                  `uvm_error("READ CHECK FAIL",$sformatf("THE BYTE DOESNT MATCH IN THE POSITION %0d when reference byte is %0d and actual one is %0d",j,referenceData[tempAddress],t1.rdata[0][8*j +:8]))
                  byte_data_cmp_failed_rdata_count++;
                  read_txn_failed = 1;
                end   
                else begin 
                  byte_data_cmp_verified_rdata_count++;
                  `uvm_info("READ CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d",j),UVM_NONE);
                end 
                tempAddress++;
              end
              else begin 
                nonExistantMemRead++;
                if(t1.rresp == READ_SLVERR) begin
                  byte_data_cmp_verified_rresp_count++;
                end
                else begin 
                  byte_data_cmp_failed_rresp_count++;
                end 
                `uvm_info("NON EXISTANT READ",$sformatf("READING FROM LOCATION %0h which doesnt exist so read slaver os %0s",tempAddress,t1.rresp),UVM_HIGH)
                tempAddress++;
              end 
              if(tempAddress == wrapEndAddress)
                tempAddress = wrapStartAddress; 
            end     
          end 
        endcase
        if(t1.rlast == 1) begin
          total_read_txn++;
          if(read_txn_failed) 
            failed_read_txn++;
          else                
            passed_read_txn++;

          read_txn_failed =0;
          `uvm_info(get_type_name(),$sformatf("READ transaction %0s | total_read=%0d pass=%0d fail=%0d",
            read_txn_failed ? "FAIL" : "PASS", total_read_txn, passed_read_txn, failed_read_txn),UVM_MEDIUM)
        end
      end
      end : read_check
       begin : write_check
        // Thread-local scratch state. These were previously class members
        // shared with the read-check thread, which corrupted each other
        // (e.g. the read burst type read as 0 after a write completed).
        int index;
        int indextemp[$];
        bit[ADDRESS_WIDTH-1:0]tempAddress; 
        int alignAmount;
        bit[ADDRESS_WIDTH-1:0] wrapStartAddress, wrapEndAddress;
        axi4_master_tx axi_master_address_tx;
        axi4_slave_tx  axi_slave_address_tx;
       forever begin
        axi4_master_write_response_analysis_fifo.get(temp);
        temp.bresp=WRITE_OKAY;
        axi4_master_tx_bresp_count++;
        write_txn_failed = 0;
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
        wrapStartAddress =tempAddress - int'(tempAddress % ((2**(axi_master_address_tx.awsize))* (axi_master_address_tx.awlen +1)));
        wrapEndAddress = wrapStartAddress + (((2**(axi_master_address_tx.awsize))* (axi_master_address_tx.awlen +1)));
        axi4_write_address_comparision(axi_master_address_tx,axi_slave_address_tx); //address check done 

        if((axi_master_address_tx.awaddr % (2**axi_master_address_tx.awsize))!= 0) begin
          alignAmount = axi_master_address_tx.awaddr - ((2**(axi_master_address_tx.awsize))*(int'(axi_master_address_tx.awaddr/(2**(axi_master_address_tx.awsize))))); 
        end
        else
          alignAmount = 0;
        `uvm_info(get_type_name(),$sformatf("Write check: alignAmount = %0d",alignAmount),UVM_HIGH)
        for(int i=0;i < masterArrayDataQueue[index].size();i++) begin    
          int count =0; 
          int j=0;

          if(masterArrayDataQueue[index][i].strobe == slaveArrayDataQueue[index][i].strobe) begin 
            byte_data_cmp_verified_wstrb_count++;
          end  
          else begin 
            byte_data_cmp_failed_wstrb_count++;
          end 

          if(i !=0)
            alignAmount =0;

          case(axi_master_address_tx.awburst)
            2'b 00: begin
              `uvm_info(get_type_name(),$sformatf("Write strobe = %b",masterArrayDataQueue[index][i].strobe),UVM_HIGH)
              for(int j=0,k=0;j<((2**(axi_master_address_tx.awsize))-alignAmount);j++) begin 
                if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin 
                  temp.bresp = WRITE_SLVERR;
                end 
                k=tempAddress % (DATA_WIDTH/8);
                if(masterArrayDataQueue[index][i].data[8*k +: 8] != slaveArrayDataQueue[index][i].data[8*k +: 8])begin 
                  `uvm_error("WRITE CHECK FAIL",$sformatf("THE BYTE %0D is not equal the byte in expected is %0b and in actual is %0b",j,masterArrayDataQueue[index][i].data[8*k +: 8],slaveArrayDataQueue[index][i].data[8*k +: 8]))
                  byte_data_cmp_failed_wdata_count++;
                  write_txn_failed = 1;
                end 
                else begin 
                  `uvm_info("WRITE CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d reference data is %0h",j,masterArrayDataQueue[index][i].data[8*k +: 8]),UVM_NONE);

                  byte_data_cmp_verified_wdata_count++;
                end
                if(masterArrayDataQueue[index][i].strobe[k]==1)begin
                  `uvm_info(get_type_name(),$sformatf("Data pushed into reference FIFO = %h",masterArrayDataQueue[index][i].data[8*k +:8]),UVM_HIGH)
                  if(referenceFifo.used()==FIFO_SIZE) begin 
                    temp.bresp=WRITE_SLVERR;
                  end 
                  else begin 
                    referenceFifo.put(masterArrayDataQueue[index][i].data[8*k +:8]); 
                  end 
                end
                tempAddress++;
              end  
            end  
            2'b 01: begin 
              for(int k=0;k< ((2**(axi_master_address_tx.awsize) - (alignAmount)));k++) begin   
                if(!(tempAddress inside{[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})) begin 
                  temp.bresp = WRITE_SLVERR;
                end 
                j =tempAddress % (DATA_WIDTH/8);
                if(masterArrayDataQueue[index][i].data[8*j +: 8] != slaveArrayDataQueue[index][i].data[8*j +: 8])begin 
                  `uvm_error("WRITE CHECK FAIL",$sformatf("THE BYTE %0D is not equal the byte in expected is %0b and in actual is %0b",j,masterArrayDataQueue[index][i].data[8*j +: 8],slaveArrayDataQueue[index][i].data[8*j +: 8]))
                  byte_data_cmp_failed_wdata_count++;
                  write_txn_failed = 1; 
                end
                else begin 
                  `uvm_info("WRITE CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d reference data is %0h",j,masterArrayDataQueue[index][i].data[8*j +: 8]),UVM_NONE);

                  byte_data_cmp_verified_wdata_count++;
                end 
                if(masterArrayDataQueue[index][i].strobe[j]==1)begin 
                  referenceData[tempAddress]=(masterArrayDataQueue[index][i].data[8*j +:8]);
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
                if(masterArrayDataQueue[index][i].data[8*j +: 8] != slaveArrayDataQueue[index][i].data[8*j +: 8])begin 
                  `uvm_error("WRITE CHECK FAIL",$sformatf("THE BYTE %0D is not equal the byte in expected is %0b and in actual is %0b",j,masterArrayDataQueue[index][i].data[8*j +: 8],slaveArrayDataQueue[index][i].data[8*j +: 8]))
                  byte_data_cmp_failed_wdata_count++;
                  write_txn_failed = 1;
                end
                else begin 
                  `uvm_info("WRITE CHECK PASS",$sformatf("THE BYTE MATCHES IN POSITION %0d reference data is %0h",j,masterArrayDataQueue[index][i].data[8*j +: 8]),UVM_NONE);
                  byte_data_cmp_verified_wdata_count++;
                end 
                if(masterArrayDataQueue[index][i].strobe[j]==1)      begin                                             referenceData[tempAddress]=(masterArrayDataQueue[index][i].data[8*j +:8]);
                end  
                tempAddress++;

                if(tempAddress == wrapEndAddress)
                  tempAddress = wrapStartAddress; 
              end 
            end 
          endcase   
        end
        total_write_txn++;
        if(write_txn_failed) failed_write_txn++;
        else                 passed_write_txn++;
        `uvm_info(get_type_name(),$sformatf("WRITE transaction %0s | total_write=%0d pass=%0d fail=%0d",
          write_txn_failed ? "FAIL" : "PASS", total_write_txn, passed_write_txn, failed_write_txn),UVM_MEDIUM)
        axi4_write_response_comparision(temp,t2);
        masterArrayDataQueue.delete(index);
        slaveArrayDataQueue.delete(index);
      end
      end : write_check



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
      byte_data_cmp_failed_bresp_count++;
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
    `uvm_info(get_type_name(),$sformatf("--\n----------------------------------------------SCOREBOARD CHECK PHASE---------------------------------------"),UVM_HIGH) 

    `uvm_info (get_type_name(),$sformatf(" Scoreboard Check Phase is starting"),UVM_HIGH); 

    //--------------------------------------------------------------------------------------------
    // 1.Check if the comparisons counter is NON-zero
    //   A non-zero value indicates that the comparisons never happened and throw error
    // 2.Initial count of the failed count is zero
    //   If the failed count is more than 0 it means comparision is failed and gives error  
    //--------------------------------------------------------------------------------------------

    //-------------------------------------------------------
    // Write_Address_Channel comparision
    //-------------------------------------------------------
      if ((byte_data_cmp_failed_awid_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awid count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awid_count :%0d",
          byte_data_cmp_verified_awid_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awid_count : %0d", 
          byte_data_cmp_failed_awid_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awid count comparisons are failed"));
      end

      if ( (byte_data_cmp_failed_awaddr_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awaddr count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awaddr_count :%0d",
          byte_data_cmp_verified_awaddr_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awaddr_count : %0d", 
          byte_data_cmp_failed_awaddr_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awaddr count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_awsize_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awsize count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awsize_count :%0d",
          byte_data_cmp_verified_awsize_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awsize_count : %0d", 
          byte_data_cmp_failed_awsize_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awsize count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_awlen_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awlen count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awlen_count :%0d",
          byte_data_cmp_verified_awlen_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awlen_count : %0d", 
          byte_data_cmp_failed_awlen_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awlen count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_awburst_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awburst count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awburst_count :%0d",
          byte_data_cmp_verified_awburst_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awburst_count : %0d", 
          byte_data_cmp_failed_awburst_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awburst count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_awcache_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awcache count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awcache_count :%0d",
          byte_data_cmp_verified_awcache_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awcache_count : %0d", 
          byte_data_cmp_failed_awcache_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awcache count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_awlock_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awlock count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awlock_count :%0d",
          byte_data_cmp_verified_awlock_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awlock_count : %0d", 
          byte_data_cmp_failed_awlock_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awlock count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_awprot_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("awprot count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_awprot_count :%0d",
          byte_data_cmp_verified_awprot_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_awprot_count : %0d", 
          byte_data_cmp_failed_awprot_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("awprot count comparisons are failed"));
      end

      //-------------------------------------------------------
      // Write_Data_Channel comparision
      //-------------------------------------------------------

      if ((byte_data_cmp_failed_wdata_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("wdata count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_wdata_count :%0d",
          byte_data_cmp_verified_wdata_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_wdata_count : %0d", 
          byte_data_cmp_failed_wdata_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("wdata count comparisons are failed"));
      end 


      if ((byte_data_cmp_failed_wstrb_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("wstrb count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_wstrb_count :%0d",
          byte_data_cmp_verified_wstrb_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_wstrb_count : %0d", 
          byte_data_cmp_failed_wstrb_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("wstrb count comparisons are failed"));
      end 



      //-------------------------------------------------------
      // Write_Response_Channel comparision
      //-------------------------------------------------------


      if ((byte_data_cmp_failed_bid_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("bid count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_bid_count :%0d",
          byte_data_cmp_verified_bid_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_bid_count : %0d", 
          byte_data_cmp_failed_bid_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("bid count comparisons are failed"));
      end 


      if ((byte_data_cmp_failed_bresp_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("bresp count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_bresp_count :%0d",
          byte_data_cmp_verified_bresp_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_bresp_count : %0d", 
          byte_data_cmp_failed_bresp_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("bresp count comparisons are failed"));
      end 


      if ((byte_data_cmp_failed_buser_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("buser count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_buser_count :%0d",
          byte_data_cmp_verified_buser_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_buser_count : %0d", 
          byte_data_cmp_failed_buser_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("buser count comparisons are failed"));
      end 

    //-------------------------------------------------------
    // Read_Address_Channel comparision
    //-------------------------------------------------------
      if ((byte_data_cmp_failed_arid_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arid count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arid_count :%0d",
          byte_data_cmp_verified_arid_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arid_count : %0d", 
          byte_data_cmp_failed_arid_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arid count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_araddr_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("araddr count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_araddr_count :%0d",
          byte_data_cmp_verified_araddr_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_araddr_count : %0d", 
          byte_data_cmp_failed_araddr_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("araddr count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arsize_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arsize count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arsize_count :%0d",
          byte_data_cmp_verified_arsize_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arsize_count : %0d", 
          byte_data_cmp_failed_arsize_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arsize count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arlen_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arlen count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arlen_count :%0d",
          byte_data_cmp_verified_arlen_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arlen_count : %0d", 
          byte_data_cmp_failed_arlen_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arlen count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arburst_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arburst count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arburst_count :%0d",
          byte_data_cmp_verified_arburst_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arburst_count : %0d", 
          byte_data_cmp_failed_arburst_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arburst count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arcache_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arcache count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arcache_count :%0d",
          byte_data_cmp_verified_arcache_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arcache_count : %0d", 
          byte_data_cmp_failed_arcache_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arcache count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arlock_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arlock count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arlock_count :%0d",
          byte_data_cmp_verified_arlock_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arlock_count : %0d", 
          byte_data_cmp_failed_arlock_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arlock count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arprot_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arprot count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arprot_count :%0d",
          byte_data_cmp_verified_arprot_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arprot_count : %0d", 
          byte_data_cmp_failed_arprot_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arprot count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arregion_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arregion count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arregion_count :%0d",
          byte_data_cmp_verified_arregion_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arregion_count : %0d", 
          byte_data_cmp_failed_arregion_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arregion count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_arqos_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("arqos count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_arqos_count :%0d",
          byte_data_cmp_verified_arqos_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_arqos_count : %0d", 
          byte_data_cmp_failed_arqos_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("arqos count comparisons are failed"));
      end 

      //-------------------------------------------------------
      // Read_Data_Channel comparision
      //-------------------------------------------------------
      if ((byte_data_cmp_failed_rid_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("rid count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_rid_count :%0d",
          byte_data_cmp_verified_rid_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_rid_count : %0d", 
          byte_data_cmp_failed_rid_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("rid count comparisons are failed"));
      end

      if ((byte_data_cmp_failed_rdata_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("rdata count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_rdata_count :%0d",
          byte_data_cmp_verified_rdata_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_rdata_count : %0d", 
          byte_data_cmp_failed_rdata_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("rdata count comparisons are failed"));
      end


      if ((byte_data_cmp_failed_rresp_count == 0)) begin
        `uvm_info (get_type_name(), $sformatf ("rresp count comparisons are successful"),UVM_HIGH);
      end
      else begin
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_verified_rresp_count :%0d",
          byte_data_cmp_verified_rresp_count),UVM_HIGH);
        `uvm_info (get_type_name(), $sformatf ("byte_data_cmp_failed_rresp_count : %0d", 
          byte_data_cmp_failed_rresp_count),UVM_HIGH);
        `uvm_error (get_type_name(), $sformatf ("rresp count comparisons are failed"));
      end



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

    `uvm_info(get_type_name(),"\n--------------------------------------------\nSCOREBOARD REPORT PHASE\n--------------------------------------------\n",UVM_HIGH)

    `uvm_info(get_type_name(),"WRITE_ADDRESS_PHASE",UVM_HIGH)

    //Number of awid comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awid comparisons:%0d",byte_data_cmp_verified_awid_count+byte_data_cmp_failed_awid_count),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awid failed comparisons:%0d",byte_data_cmp_failed_awid_count),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awid verified comparisons:%0d",byte_data_cmp_verified_awid_count),UVM_HIGH);


    //Number of awaddr comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr comparisons:%0d",byte_data_cmp_verified_awaddr_count+byte_data_cmp_failed_awaddr_count),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr failed comparisons:%0d",byte_data_cmp_failed_awaddr_count),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr verified comparisons:%0d",byte_data_cmp_verified_awaddr_count ),UVM_HIGH);


    //Number of awsize comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awsize comparisons:%0d",byte_data_cmp_verified_awsize_count+byte_data_cmp_failed_awsize_count),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awsize failed comparisons:%0d",byte_data_cmp_failed_awsize_count),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awsize verified comparisons:%0d",byte_data_cmp_verified_awsize_count ),UVM_HIGH);


    //Number of awlen comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlen comparisons:%0d" ,byte_data_cmp_verified_awlen_count+byte_data_cmp_failed_awlen_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlen failed comparisons:%0d" ,byte_data_cmp_failed_awlen_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlen verified comparisons:%0d" ,byte_data_cmp_verified_awlen_count ),UVM_HIGH);


    //Number of awburst comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awburst comparisons:%0d",byte_data_cmp_verified_awburst_count+byte_data_cmp_failed_awburst_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awburst failed comparisons:%0d",byte_data_cmp_failed_awburst_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awburst verified comparisons:%0d",byte_data_cmp_verified_awburst_count ),UVM_HIGH);


    //Number of awcache comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awcache comparisons:%0d",byte_data_cmp_verified_awcache_count+byte_data_cmp_failed_awcache_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awcache failed comparisons:%0d",byte_data_cmp_failed_awcache_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awcache verified comparisons:%0d",byte_data_cmp_verified_awcache_count ),UVM_HIGH);


    //Number of awlock comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlock comparisons:%0d",byte_data_cmp_verified_awlock_count+byte_data_cmp_failed_awlock_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlock failed comparisons:%0d",byte_data_cmp_failed_awlock_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awlock verified comparisons:%0d",byte_data_cmp_verified_awlock_count ),UVM_HIGH);


    //Number of awprot comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awprot comparisons:%0d",byte_data_cmp_verified_awprot_count+byte_data_cmp_failed_awprot_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awprot failed comparisons:%0d",byte_data_cmp_failed_awprot_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise awprot verified comparisons:%0d",byte_data_cmp_verified_awprot_count ),UVM_HIGH);

    `uvm_info(get_type_name(),"WRITE_DATA_PHASE",UVM_HIGH)

    //Number of wdata comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wdata comparisons:%0d",byte_data_cmp_verified_wdata_count+byte_data_cmp_failed_wdata_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wdata failed comparisons:%0d",byte_data_cmp_failed_wdata_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wdata verified comparisons:%0d",byte_data_cmp_verified_wdata_count ),UVM_HIGH);


    //Number of wstrb comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wstrb comparisons:%0d",byte_data_cmp_verified_wstrb_count+byte_data_cmp_failed_wstrb_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wstrb failed comparisons:%0d",byte_data_cmp_failed_wstrb_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wstrb verified comparisons:%0d",byte_data_cmp_verified_wstrb_count ),UVM_HIGH);


    //Number of wuser comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wuser comparisons:%0d",byte_data_cmp_verified_wuser_count+byte_data_cmp_failed_wuser_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wuser failed comparisons:%0d",byte_data_cmp_failed_wuser_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise wuser verified comparisons:%0d",byte_data_cmp_verified_wuser_count ),UVM_HIGH);

    `uvm_info(get_type_name(),"WRITE_RESPONSE_PHASE",UVM_HIGH)

    //Number of bid comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bid comparisons:%0d",byte_data_cmp_verified_bid_count+byte_data_cmp_failed_bid_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bid failed comparisons:%0d",byte_data_cmp_failed_bid_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bid verified comparisons:%0d",byte_data_cmp_verified_bid_count ),UVM_HIGH);

    //Number of bresp comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bresp comparisons:%0d",byte_data_cmp_verified_bresp_count+byte_data_cmp_failed_bresp_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bresp failed comparisons:%0d",byte_data_cmp_failed_bresp_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise bresp verified comparisons:%0d",byte_data_cmp_verified_bresp_count ),UVM_HIGH);

    `uvm_info(get_type_name(),"\n--------------------------------------------\nSCOREBOARD WRITE ADDRESS PACKETS\n--------------------------------------------\n",UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's write address packets count  from master   \n %0d",axi4_master_tx_awaddr_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's write address packets count  from slave    \n %0d",axi4_slave_tx_awaddr_count),UVM_HIGH)
    //`uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr verified comparisons:%0d",byte_data_cmp_verified_awaddr_count ),UVM_NONE);
    //`uvm_info (get_type_name(),$sformatf("Total no. of byte wise awaddr failed comparisons:%0d",byte_data_cmp_failed_awaddr_count ),UVM_NONE);

    `uvm_info(get_type_name(),"\n--------------------------------------------\nSCOREBOARD WRITE DATA PACKETS\n--------------------------------------------\n",UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's  write data packets count from master \n %0d",axi4_master_tx_wdata_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's  write data packets count from slave   \n %0d",axi4_slave_tx_wdata_count),UVM_HIGH)

    `uvm_info(get_type_name(),"\n--------------------------------------------\nSCOREBOARD WRITE RESPONSE PACKETS\n--------------------------------------------\n",UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's write response packets count from master \n %0d",axi4_master_tx_bresp_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's write response packets count from slave  \n %0d",axi4_slave_tx_bresp_count),UVM_HIGH)



    `uvm_info(get_type_name(),"\n--------------------------------------------\nREAD_ADDRESS_PHASE\n--------------------------------------------\n",UVM_HIGH)

    //Number of arid comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arid comparisons:%0d",byte_data_cmp_verified_arid_count+byte_data_cmp_failed_arid_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arid failed comparisons:%0d",byte_data_cmp_failed_arid_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arid verified comparisons:%0d",byte_data_cmp_verified_arid_count ),UVM_HIGH);


    //Number of araddr comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise araddr comparisons:%0d",byte_data_cmp_verified_araddr_count+byte_data_cmp_failed_araddr_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise araddr failed comparisons:%0d",byte_data_cmp_failed_araddr_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise araddr verified comparisons:%0d",byte_data_cmp_verified_araddr_count ),UVM_HIGH);


    //Number of arsize comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arsize comparisons:%0d",byte_data_cmp_verified_arsize_count+byte_data_cmp_failed_arsize_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arsize failed comparisons:%0d",byte_data_cmp_failed_arsize_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arsize verified comparisons:%0d",byte_data_cmp_verified_arsize_count ),UVM_HIGH);


    //Number of arlen comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlen comparisons:%0d",byte_data_cmp_verified_arlen_count+byte_data_cmp_failed_arlen_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlen failed comparisons:%0d",byte_data_cmp_failed_arlen_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlen verified comparisons:%0d",byte_data_cmp_verified_arlen_count ),UVM_HIGH);


    //Number of arburst comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arburst comparisons:%0d",byte_data_cmp_verified_arburst_count+byte_data_cmp_failed_arburst_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arburst failed comparisons:%0d",byte_data_cmp_failed_arburst_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arburst verified comparisons:%0d",byte_data_cmp_verified_arburst_count ),UVM_HIGH);


    //Number of arcache comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arcache comparisons:%0d",byte_data_cmp_verified_arcache_count+byte_data_cmp_failed_arcache_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arcache failed comparisons:%0d",byte_data_cmp_failed_arcache_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arcache verified comparisons:%0d",byte_data_cmp_verified_arcache_count ),UVM_HIGH);


    //Number of arlock comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlock comparisons:%0d",byte_data_cmp_verified_arlock_count+byte_data_cmp_failed_arlock_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlock failed comparisons:%0d",byte_data_cmp_failed_arlock_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arlock verified comparisons:%0d",byte_data_cmp_verified_arlock_count ),UVM_HIGH);


    //Number of arprot comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arprot  comparisons:%0d",byte_data_cmp_verified_arprot_count+byte_data_cmp_failed_arprot_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arprot failed comparisons:%0d",byte_data_cmp_failed_arprot_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arprot verified comparisons:%0d",byte_data_cmp_verified_arprot_count ),UVM_HIGH);


    //Number of arregion comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arregion comparisons:%0d",byte_data_cmp_verified_arregion_count+byte_data_cmp_failed_arregion_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arregion failed comparisons:%0d",byte_data_cmp_failed_arregion_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arregion verified comparisons:%0d",byte_data_cmp_verified_arregion_count ),UVM_HIGH);


    //Number of arqos comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arqos comparisons:%0d",byte_data_cmp_verified_arqos_count+byte_data_cmp_failed_arqos_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arqos failed comparisons:%0d",byte_data_cmp_failed_arqos_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise arqos verified comparisons:%0d",byte_data_cmp_verified_arqos_count ),UVM_HIGH);

    `uvm_info(get_type_name(),"READ_DATA_PHASE",UVM_HIGH)

    //Number of rid comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rid comparisons:%0d",byte_data_cmp_verified_rid_count+byte_data_cmp_failed_rid_count ),UVM_HIGH);

    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rid failed comparisons:%0d",byte_data_cmp_failed_rid_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rid  verified comparisons:%0d",byte_data_cmp_verified_rid_count ),UVM_HIGH);

    //Number of rdata comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rdata comparisons:%0d",byte_data_cmp_verified_rdata_count+byte_data_cmp_failed_rdata_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rdata failed comparisons:%0d",byte_data_cmp_failed_rdata_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rdata verified comparisons:%0d",byte_data_cmp_verified_rdata_count ),UVM_HIGH);


    //Number of rresp comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rresp comparisons:%0d",byte_data_cmp_verified_rresp_count+byte_data_cmp_failed_rresp_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rresp failed comparisons:%0d",byte_data_cmp_failed_rresp_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise rresp verified comparisons:%0d",byte_data_cmp_verified_rresp_count ),UVM_HIGH);


    //Number of ruser comparisons done
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise ruser comparisons:%0d",byte_data_cmp_verified_ruser_count+byte_data_cmp_failed_ruser_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise ruser failed comparisons:%0d",byte_data_cmp_failed_ruser_count ),UVM_HIGH);
    `uvm_info (get_type_name(),$sformatf("Total no. of byte wise ruser verified comparisons:%0d",byte_data_cmp_verified_ruser_count ),UVM_HIGH);

    `uvm_info(get_type_name(),"\n--------------------------------------------\nSCOREBOARD READ ADDRESS PACKETS\n--------------------------------------------\n",UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's read address packets count from master \n %0d",axi4_master_tx_araddr_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's read address packets count from slave  \n %0d",axi4_slave_tx_araddr_count),UVM_HIGH)

    `uvm_info(get_type_name(),"\n--------------------------------------------\nSCOREBOARD READ DATA PACKETS\n--------------------------------------------\n",UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's  read data packets count from master \n %0d",axi4_master_tx_rdata_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's  read data packets count from slave  \n %0d",axi4_slave_tx_rdata_count),UVM_HIGH)

    `uvm_info(get_type_name(),$sformatf("scoreboard's  non existant memory read count is \n %0d",nonExistantMemRead),UVM_HIGH)
    `uvm_info(get_type_name(),"\n--------------------------------------------\nSCOREBOARD READ RESPONSE PACKETS\n--------------------------------------------\n",UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's read response packets count from master \n %0d",axi4_master_tx_rresp_count),UVM_HIGH)
    `uvm_info(get_type_name(),$sformatf("scoreboard's read response packets count from slave   \n %0d",axi4_slave_tx_rresp_count),UVM_HIGH)

    //-------------------------------------------------------------------------------------------
    // Transaction-level PASS/FAIL summary
    // A transaction is counted FAIL if at least one data byte mismatched
    // (wdata for write transactions, rdata for read transactions).
    //-------------------------------------------------------------------------------------------
    `uvm_info(get_type_name(),"==================================================================",UVM_NONE)
    `uvm_info(get_type_name(),"                 TRANSACTION PASS/FAIL SUMMARY                    ",UVM_NONE)
    `uvm_info(get_type_name(),"==================================================================",UVM_NONE)
    `uvm_info(get_type_name(),$sformatf("WRITE transactions : total=%0d  pass=%0d  fail=%0d",
      total_write_txn, passed_write_txn, failed_write_txn),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf("READ  transactions : total=%0d  pass=%0d  fail=%0d",
      total_read_txn, passed_read_txn, failed_read_txn),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf("TOTAL transactions : total=%0d  pass=%0d  fail=%0d",
      total_write_txn + total_read_txn,
      passed_write_txn + passed_read_txn,
      failed_write_txn + failed_read_txn),UVM_NONE)
    `uvm_info(get_type_name(),"==================================================================",UVM_NONE)

  endfunction : report_phase

`endif

