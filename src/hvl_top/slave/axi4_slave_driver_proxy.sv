`ifndef AXI4_SLAVE_DRIVER_PROXY_INCLUDED_
`define AXI4_SLAVE_DRIVER_PROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_driver_proxy
// This is the proxy driver on the HVL side
// It receives the transactions and converts them to task calls for the HDL driver
//--------------------------------------------------------------------------------------------
class axi4_slave_driver_proxy extends uvm_driver#(axi4_slave_tx);
  `uvm_component_utils(axi4_slave_driver_proxy)

  // Port: seq_item_port
  // Derived driver classes should use this port to request items from the sequencer
  // They may also use it to send responses back.
  uvm_seq_item_pull_port #(REQ, RSP) axi_write_seq_item_port;
  uvm_seq_item_pull_port #(REQ, RSP) axi_read_seq_item_port;

  // Port: rsp_port
  // This port provides an alternate way of sending responses back to the originating sequencer.
  // Which port to use depends on which export the sequencer provides for connection.
  uvm_analysis_port #(RSP) axi_write_rsp_port;
  uvm_analysis_port #(RSP) axi_read_rsp_port;
  
  REQ req_wr, req_rd;
  RSP rsp_wr, rsp_rd;

  // Variable: axi4_slave_agent_cfg_h
  // Declaring handle for axi4_slave agent config class 
  axi4_slave_agent_config axi4_slave_agent_cfg_h;

  // Variable: axi4_slave_mem_h
  // Declaring handle for axi4_slave memory config class 
  axi4_slave_memory axi4_slave_mem_h;

  //Variable : axi4_slave_drv_bfm_h
  //Declaring handle for axi4 driver bfm
  virtual axi4_slave_driver_bfm axi4_slave_drv_bfm_h;

  //Declaring handle for uvm_tlm_analysis_fifo's for all the five channels
  uvm_tlm_fifo #(axi4_slave_tx) axi4_slave_write_addr_fifo_h;
  uvm_tlm_fifo #(axi4_slave_tx) axi4_slave_write_data_in_fifo_h;
  uvm_tlm_fifo #(axi4_slave_tx) axi4_slave_write_response_fifo_h;
  uvm_tlm_fifo #(axi4_slave_tx) axi4_slave_write_data_out_fifo_h;
  uvm_tlm_fifo #(axi4_slave_tx) axi4_slave_read_addr_fifo_h;
  uvm_tlm_fifo #(axi4_slave_tx) axi4_slave_read_data_in_fifo_h;



  //queue for holding the packets in axi channel needed to get the packet during out of order transmission of data

  axi4_slave_tx axiSlaveAddressQueue[$];
  axi4_slave_tx axiSlaveDataQueue[$];
  int axiSlaveIdQueue[$];
  int axiSlaveIdDynamicArray[];
  int indexTracker[$];  
  int numberOfDataTransaction;
  bit flag=0;


  axi4_slave_tx axiReadSlaveAddressQueue[$];
  axi4_slave_tx axiReadSlaveDatatQueue[$];
  int axiReadSlaveIdQueue[$];
  int axiReadSlaveIdDynamicArray[];
  int readIndexTracker[$];
  int readFlag =0;
  int waitStates = 0;


  //Declaring Semaphore handles for writes and reads
  semaphore semaphore_write_key;
  semaphore semaphore_rsp_write_key;
  semaphore semaphore_read_key;

  //write_read_mode_h used to get the transfer type
  write_read_data_mode_e write_read_mode_h;

  bit[3:0] wr_addr_cnt;
  bit[3:0] wr_resp_cnt;

  // Variables used for out of order support
  bit[3:0] response_id_queue[$];
  bit[3:0] response_id_cont_queue[$];
  bit      drive_id_cont;
  bit      drive_rd_id_cont;
  axi4_read_transfer_char_s rd_response_id_queue[$];
  axi4_read_transfer_char_s rd_response_id_cont_queue[$];

  bit      completed_initial_txn;
  int      crossed_read_addr=0;

  //Qos mode signals
  axi4_slave_tx  qos_queue[$];
  axi4_slave_tx  qos_read_queue[$];
  int            queue_index;
  bit            qos_wait_enable = 1'b1;
  int            read_queue_index;
  
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task axi4_write_task();
  extern virtual task axi4_read_task();
  extern virtual task task_memory_write(input axi4_slave_tx struct_write_packet);
  extern virtual task task_memory_read(input axi4_slave_tx read_pkt,ref axi4_read_transfer_char_s struct_read_packet);
  extern virtual task out_of_order_for_reads(output axi4_read_transfer_char_s oor_read_data_struct_read_packet);
endclass : axi4_slave_driver_proxy

//--------------------------------------------------------------------------------------------
// Construct: new
// Parameters:
//  name - axi4_slave_driver_proxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_slave_driver_proxy::new(string name = "axi4_slave_driver_proxy",
                                      uvm_component parent = null);
  super.new(name, parent);
  axi_write_seq_item_port                   = new("axi_write_seq_item_port", this);
  axi_read_seq_item_port                    = new("axi_read_seq_item_port", this);
  axi_write_rsp_port                        = new("axi_write_rsp_port", this);
  axi_read_rsp_port                         = new("axi_read_rsp_port", this);
  axi4_slave_write_addr_fifo_h              = new("axi4_slave_write_addr_fifo_h",this,16);
  axi4_slave_write_data_in_fifo_h           = new("axi4_slave_write_data_in_fifo_h",this,16);
  axi4_slave_write_response_fifo_h          = new("axi4_slave_write_response_fifo_h",this,16);
  axi4_slave_write_data_out_fifo_h          = new("axi4_slave_write_data_out_fifo_h",this,16);
  axi4_slave_read_addr_fifo_h               = new("axi4_slave_read_addr_fifo_h",this,16);
  axi4_slave_read_data_in_fifo_h            = new("axi4_slave_read_data_in_fifo_h",this,16);
  semaphore_write_key                       = new(1);
  semaphore_rsp_write_key                   = new(1);
  semaphore_read_key                        = new(1);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_slave_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual axi4_slave_driver_bfm)::get(this,"","axi4_slave_driver_bfm",axi4_slave_drv_bfm_h)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_tx_DRIVER_BFM","cannot get() axi4_slave_drv_bfm_h");
  end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_slave_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE) begin
    axi4_slave_mem_h = axi4_slave_memory::type_id::create("axi4_slave_mem_h");
  end
  axi4_slave_drv_bfm_h.axi4_slave_drv_proxy_h= this;
endfunction  : end_of_elaboration_phase


//--------------------------------------------------------------------------------------------
// Task: run_phase
//--------------------------------------------------------------------------------------------
task axi4_slave_driver_proxy::run_phase(uvm_phase phase);

  `uvm_info(get_type_name(),"SLAVE_DRIVER_PROXY",UVM_MEDIUM)

  //wait for system reset
  axi4_slave_drv_bfm_h.wait_for_system_reset();

  fork 
    axi4_write_task();
    axi4_read_task();
  join


endtask : run_phase 

//--------------------------------------------------------------------------------------------
// task axi4 write task
//--------------------------------------------------------------------------------------------
task axi4_slave_driver_proxy::axi4_write_task();
  
  forever begin :fb1
    process addr_tx;
    process data_tx;
    process response_tx;

    axi_write_seq_item_port.get_next_item(req_wr);

    // writting the req into write data and response fifo's
    axi4_slave_write_data_in_fifo_h.put(req_wr);
    axi4_slave_write_response_fifo_h.put(req_wr);
    fork 
    begin : WRITE_ADDRESS_CHANNEL 
      axi4_slave_tx              local_slave_addr_tx;
      axi4_write_transfer_char_s struct_write_packet;
      axi4_transfer_cfg_s        struct_cfg;
      bit[3:0]                   local_awid;
    
      addr_tx=process::self();
      axi4_slave_seq_item_converter::from_write_class(req_wr,struct_write_packet);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_write_packet = \n %0p",struct_write_packet), UVM_HIGH); 
      axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH); 
      axi4_slave_drv_bfm_h.axi4_write_address_phase(struct_write_packet);
      axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_addr_tx);
      if((axi4_slave_agent_cfg_h.qos_mode_type == ONLY_WRITE_QOS_MODE_ENABLE) || (axi4_slave_agent_cfg_h.qos_mode_type == WRITE_READ_QOS_MODE_ENABLE)) begin:ib1
        qos_queue.push_front(local_slave_addr_tx);
      end:ib1
      `uvm_info("DEBUG_SLAVE_WRITE_ADDR_PROXY", $sformatf("AFTER :: Received req packet \n %s",local_slave_addr_tx.sprint()), UVM_MEDIUM);
      axiSlaveAddressQueue.push_back(local_slave_addr_tx);
      axiSlaveIdQueue.push_back(local_slave_addr_tx.awid);
      wr_addr_cnt++;
   
    end:WRITE_ADDRESS_CHANNEL

    begin : WRITE_DATA_CHANNEL
      axi4_slave_tx              local_slave_data_tx;
      axi4_write_transfer_char_s struct_write_packet;
      axi4_transfer_cfg_s        struct_cfg;
      data_tx=process::self();
      semaphore_write_key.get(1);
      axi4_slave_write_data_in_fifo_h.get(local_slave_data_tx);
      axi4_slave_seq_item_converter::from_write_class(local_slave_data_tx,struct_write_packet);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_write_packet = \n %0p",struct_write_packet), UVM_HIGH); 
      axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
      axi4_slave_drv_bfm_h.axi4_write_data_phase(struct_write_packet,struct_cfg);
      `uvm_info("DEBUG_SLAVE_WDATA_PROXY", $sformatf("AFTER :: Reciving struct pkt from bfm \n%p",struct_write_packet), UVM_HIGH);
      axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_data_tx);
     `uvm_info("DEBUG_SLAVE_WDATA_PROXY_TO_CLASS", $sformatf("AFTER TO CLASS :: Received req packet \n %s", local_slave_data_tx.sprint()), UVM_MEDIUM);
      axiSlaveDataQueue.push_back(local_slave_data_tx);
      $display("\N\N\N THE SLAVE DATA QUEUE IS %p \n \n \n ",axiSlaveDataQueue);
      numberOfDataTransaction++;
      semaphore_write_key.put(1);
    end : WRITE_DATA_CHANNEL

    begin : WRITE_RESPONSE_CHANNEL
      axi4_slave_tx              local_slave_addr_tx;
      axi4_slave_tx              local_slave_data_tx;
      axi4_slave_tx              local_slave_response_tx;
      axi4_slave_tx              packet;
      axi4_slave_tx              qos_value_check_1;
      axi4_write_transfer_char_s struct_write_packet;
      axi4_transfer_cfg_s        struct_cfg;
      bit[3:0]                   bid_local;
      int                        end_wrap_addr;
      bit                        slave_err;
      response_tx=process::self();

      data_tx.await();
      
      //getting the key from semaphore 
      semaphore_rsp_write_key.get(1);

      if((axi4_slave_agent_cfg_h.qos_mode_type == ONLY_WRITE_QOS_MODE_ENABLE) || (axi4_slave_agent_cfg_h.qos_mode_type == WRITE_READ_QOS_MODE_ENABLE)) begin:ib2
        qos_value_check_1 = qos_queue[$];
        for(int i=0;i<qos_queue.size();i++) begin : fb1
          if(qos_queue[i].awqos >= qos_value_check_1.awqos) begin : ib3
            qos_value_check_1 = qos_queue[i];
            queue_index = i;
          end : ib3
        end : fb1

        local_slave_response_tx = qos_queue[queue_index];
        qos_queue.delete(queue_index);
      end : ib2
      else begin : eb1
        if(axi4_slave_write_response_fifo_h.is_empty) begin : ib4
          `uvm_error(get_type_name(),$sformatf("WRITE_RESP_THREAD::Cannot get write resp data from FIFO as WRITE_RESP_FIFO is EMPTY"));
        end : ib4
        else begin : eb2
          //getting the data from response fifo
          axi4_slave_write_response_fifo_h.get(local_slave_response_tx);
        end :eb2
      end : eb1

      
      //Converting transactions into struct data type
      axi4_slave_seq_item_converter::from_write_class(local_slave_response_tx,struct_write_packet);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_write_packet = \n %0p",struct_write_packet), UVM_HIGH); 

      //Converting configurations into struct config type
      axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);

      //check for fifo empty if not get the data 
      if((axi4_slave_agent_cfg_h.qos_mode_type == ONLY_WRITE_QOS_MODE_ENABLE) || (axi4_slave_agent_cfg_h.qos_mode_type == WRITE_READ_QOS_MODE_ENABLE)) begin : ib5
        local_slave_addr_tx = local_slave_response_tx;
        struct_write_packet.bid = awid_queue_for_qos.pop_front();
      end : ib5

      `uvm_info("slave_driver_proxy",$sformatf("min_tx=%0d",axi4_slave_agent_cfg_h.get_minimum_transactions),UVM_HIGH)
      if((axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER || axi4_slave_agent_cfg_h.slave_response_mode == ONLY_WRITE_RESP_OUT_OF_ORDER)&& (local_slave_response_tx.transfer_type == NON_BLOCKING_WRITE)) begin : ib6    
        $display("THE FLAG IS %0d",flag);
        if( flag ==0) 
          wait(numberOfDataTransaction >= activeTransactionCapacity );  
        else 
          wait(axiSlaveDataQueue.size()>0);
           
        axiSlaveIdDynamicArray = new[numberOfDataTransaction];
        axiSlaveIdDynamicArray = axiSlaveIdQueue[0:numberOfDataTransaction-1];
        axiSlaveIdDynamicArray.shuffle();
        indexTracker = axiSlaveIdQueue.find_first_index with(item == axiSlaveIdDynamicArray[0]);
        local_slave_addr_tx = axiSlaveAddressQueue[indexTracker[0]];
        axiSlaveIdQueue.delete(indexTracker[0]);
        axiSlaveAddressQueue.delete(indexTracker[0]);
        local_slave_data_tx = axiSlaveDataQueue[indexTracker[0]];
        axiSlaveDataQueue.delete(indexTracker[0]);
        bid_local = local_slave_addr_tx.awid;
        if(local_slave_addr_tx.awburst == WRITE_FIXED) begin : ib7
          end_wrap_addr =  local_slave_addr_tx.awaddr + ((2**local_slave_addr_tx.awsize));
        end : ib7
        if(local_slave_addr_tx.awburst == WRITE_INCR) begin : ib8
          end_wrap_addr =  local_slave_addr_tx.awaddr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
        end :ib8
        if(local_slave_addr_tx.awburst == WRITE_WRAP) begin : ib9
          end_wrap_addr = local_slave_addr_tx.awaddr - int'(local_slave_addr_tx.awaddr%((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize)));
          end_wrap_addr = end_wrap_addr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
        end : ib9
        `uvm_info("slave_driver_proxy",$sformatf("fifo_size = %0d",axi4_slave_write_data_out_fifo_h.used()),UVM_HIGH)
        if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE || axi4_slave_agent_cfg_h.read_data_mode == SLAVE_ERR_RESP_MODE) begin : ib10
          if(!((local_slave_addr_tx.awaddr inside {[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]}) && (end_wrap_addr inside{[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}))) begin :ib11
            struct_write_packet.bresp = WRITE_SLVERR;
            slave_err = 1;
          end : ib11
        end:ib10

        // write response_task
        axi4_slave_drv_bfm_h.axi4_write_response_phase(struct_write_packet,struct_cfg,bid_local);
       `uvm_info("WRITE RESPONSE CHANNEL PACKET", $sformatf("AFTER :: Reciving struct pkt from bfm \n %p",struct_write_packet), UVM_NONE);
      end : ib6
      else begin : eb3
        local_slave_addr_tx = axiSlaveAddressQueue.pop_front();
        local_slave_data_tx = axiSlaveDataQueue.pop_front();
        bid_local = local_slave_addr_tx.awid;
        if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE || axi4_slave_agent_cfg_h.read_data_mode == SLAVE_ERR_RESP_MODE) begin : ib12
          if(!((local_slave_addr_tx.awaddr inside {[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]}) && (end_wrap_addr inside{[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}))) begin : ib13
            struct_write_packet.bresp = WRITE_SLVERR;
            slave_err = 1;
          end :ib13
        end : ib12
        axi4_slave_drv_bfm_h.axi4_write_response_phase(struct_write_packet,struct_cfg,bid_local);
        `uvm_info("WRITE RESPONSE CHANNEL RESPONSE ", $sformatf("AFTER :: Reciving struct pkt from bfm \n %p",struct_write_packet), UVM_NONE);
      end : eb3

      //Converting struct into transaction data type
      axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_response_tx);

      `uvm_info("DEBUG_SLAVE_WDATA_PROXY_TO_CLASS", $sformatf("AFTER TO CLASS :: Received req packet \n %s", local_slave_response_tx.sprint()), UVM_NONE);
     

      //axi4_slave_write_data_out_fifo_h.get(local_slave_data_tx);

     //Calling combined data packet from converter class
      axi4_slave_seq_item_converter::tx_write_packet(local_slave_addr_tx,local_slave_data_tx,local_slave_response_tx,packet);
      `uvm_info("DEBUG_SLAVE_WDATA_PROXY", $sformatf("AFTER :: COMBINED WRITE CHANNEL PACKET \n%s",packet.sprint()), UVM_NONE);
      if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE && ~slave_err) begin
       task_memory_write(packet);
      end
      wr_resp_cnt++;
      completed_initial_txn=1;
      flag =1;
      numberOfDataTransaction--; 
      semaphore_rsp_write_key.put(1);
    end : WRITE_RESPONSE_CHANNEL
 
    join_any

  //checking the status of write address thread
    addr_tx.await();
    `uvm_info("SLAVE_STATUS_CHECK",$sformatf("AFTER_FORK_JOIN_ANY:: SLAVE_ADDRESS_CHANNEL_STATUS =\n %s",addr_tx.status()),UVM_MEDIUM)
    `uvm_info("SLAVE_STATUS_CHECK",$sformatf("AFTER_FORK_JOIN_ANY:: SLAVE_WDATA_CHANNEL_STATUS = \n %s",data_tx.status()),UVM_MEDIUM)
    `uvm_info("SLAVE_STATUS_CHECK",$sformatf("AFTER_FORK_JOIN_ANY:: SLAVE_WRESP_CHANNEL_STATUS = \n%s",response_tx.status()),UVM_MEDIUM)
   
    axi_write_seq_item_port.item_done();

  end : fb1
 
endtask : axi4_write_task

//-------------------------------------------------------
// task axi4 read task
//-------------------------------------------------------
task axi4_slave_driver_proxy::axi4_read_task();
  
  forever begin : ff1
    
    //Declaring the process for read address channel and read data channel for status check 
    process rd_addr;
    process rd_data;

    axi_read_seq_item_port.get_next_item(req_rd);
    

    //putting the data into read data fifo
    axi4_slave_read_data_in_fifo_h.put(req_rd);

    fork
    begin : READ_ADDRESS_CHANNEL
      
      axi4_slave_tx              local_slave_tx;
      axi4_read_transfer_char_s struct_read_packet;
      axi4_read_transfer_char_s oor_struct_read_packet;
      axi4_transfer_cfg_s       struct_cfg;
      
      //returns status of address thread
      rd_addr = process::self();
      
      //Converting transactions into struct data type
      axi4_slave_seq_item_converter::from_read_class(req_rd,struct_read_packet);
      `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_HIGH); 
      
      //Converting configurations into struct config type
      axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
      `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
      
      //read address_task
      axi4_slave_drv_bfm_h.axi4_read_address_phase(struct_read_packet,struct_cfg);
      //Converting struct into transaction data type
      axi4_slave_seq_item_converter::to_read_class(struct_read_packet,local_slave_tx);
      `uvm_info("DEBUG_SLAVE_READ_ADDR_PROXY", $sformatf(" to_class_raddr_phase_slave_proxy  \n %p",struct_read_packet), UVM_HIGH);

      if((axi4_slave_agent_cfg_h.qos_mode_type == ONLY_READ_QOS_MODE_ENABLE) || (axi4_slave_agent_cfg_h.qos_mode_type == WRITE_READ_QOS_MODE_ENABLE)) begin : if1
        qos_read_queue.push_front(local_slave_tx);
      end : if1
     
      //Putting back the sampled read address data into fifo
      axi4_slave_read_addr_fifo_h.put(local_slave_tx);
      axiReadSlaveAddressQueue.push_back(local_slave_tx);
      axiReadSlaveIdQueue.push_back(local_slave_tx.arid);
      waitStates++; 
      `uvm_info("DEBUG_SLAVE_READ_ADDR_PROXY", $sformatf("AFTER :: Received req packet \n %s",local_slave_tx.sprint()), UVM_MEDIUM);
    
    end : READ_ADDRESS_CHANNEL
  
    begin : READ_DATA_CHANNEL
    
      axi4_slave_tx              local_slave_rdata_tx;
      axi4_slave_tx              local_slave_raddr_tx;
      axi4_slave_tx              qos_value_check_1;
      axi4_slave_tx              packet;
      axi4_read_transfer_char_s  struct_read_packet;
      axi4_transfer_cfg_s        struct_cfg;
      int                        total_bytes;

      //returns status of data thread
      rd_data = process::self();
      //Waiting for the read address thread to complete
      rd_addr.await();

      //Getting the key from semaphore
      semaphore_read_key.get(1);

      if((axi4_slave_agent_cfg_h.qos_mode_type == ONLY_READ_QOS_MODE_ENABLE) || (axi4_slave_agent_cfg_h.qos_mode_type == WRITE_READ_QOS_MODE_ENABLE)) begin : if2
        if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE) begin : if3
          wait(completed_initial_txn==1);
        end : if3
        if(qos_wait_enable) begin : if4
          wait(qos_read_queue.size>=2);
        end : if4
        qos_wait_enable = 1'b0;
        qos_value_check_1 = qos_read_queue[$];
        for(int i=0;i<qos_read_queue.size();i++) begin : fl1
          if(qos_read_queue[i].arqos >= qos_value_check_1.arqos) begin : if5
            qos_value_check_1 = qos_read_queue[i];
            read_queue_index = i;
          end : if5
        end : fl1
        //Getting the data from read data fifo
        //axi4_slave_read_data_in_fifo_h.get(local_slave_rdata_tx);
        //local_slave_rdata_tx.rid = rid_e'(qos_read_queue[read_queue_index].arid);
        local_slave_rdata_tx =  qos_read_queue[read_queue_index];
        qos_read_queue.delete(read_queue_index);
      end : if2
      else begin :ef1
        //Getting the data from read data fifo
        axi4_slave_read_data_in_fifo_h.get(local_slave_rdata_tx);
      end : ef1

      if(((axi4_slave_agent_cfg_h.read_data_mode == RANDOM_DATA_MODE) || (write_read_mode_h == ONLY_READ_DATA)) && (axi4_slave_agent_cfg_h.read_data_mode !== SLAVE_MEM_MODE)) begin : if6
       
        //Converting transactions into struct data type
        axi4_slave_seq_item_converter::from_read_class(local_slave_rdata_tx,struct_read_packet);
        `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_HIGH); 
 
        //Converting configurations into struct config type
        axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
        `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
       
        axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
        `uvm_info("READ DATA CHANNEL PACKET", $sformatf("AFTER :: READ CHANNEL PACKET \n %p",struct_read_packet), UVM_NONE);
      end : if6
      else if (axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE || axi4_slave_agent_cfg_h.read_data_mode == SLAVE_ERR_RESP_MODE && write_read_mode_h != ONLY_READ_DATA) begin : ef2
        if(((axi4_slave_agent_cfg_h.slave_response_mode == ONLY_READ_RESP_OUT_OF_ORDER) || (axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER) ) &&(local_slave_rdata_tx.transfer_type == NON_BLOCKING_READ)==0) begin : if8
          //wait(completed_initial_txn==1);
          if(readFlag ==0)
            wait(waitStates >= activeTransactionCapacity);
          else
            wait(axiReadSlaveAddressQueue.size()>0);
          axiReadSlaveIdDynamicArray = new[waitStates];
          axiReadSlaveIdDynamicArray = axiReadSlaveIdQueue[0:waitStates-1];
          axiReadSlaveIdDynamicArray.shuffle();
          readIndexTracker = axiReadSlaveIdQueue.find_first_index with(item == axiReadSlaveIdDynamicArray[0]);
          local_slave_raddr_tx  = axiReadSlaveAddressQueue[readIndexTracker[0]];
          axiReadSlaveIdQueue.delete(readIndexTracker[0]);
          axiReadSlaveAddressQueue.delete(readIndexTracker[0]); 
          axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
          `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);

         axi4_slave_seq_item_converter::from_read_class(local_slave_raddr_tx,struct_read_packet);
          `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_NONE);
          `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_HIGH); 
        end :if8
        else if((axi4_slave_agent_cfg_h.slave_response_mode == RESP_IN_ORDER || axi4_slave_agent_cfg_h.slave_response_mode == ONLY_WRITE_RESP_OUT_OF_ORDER) || local_slave_rdata_tx.transfer_type==BLOCKING_READ) begin 
          wait(axiReadSlaveAddressQueue.size()>0);
          local_slave_raddr_tx  = axiReadSlaveAddressQueue[0];
        //Converting transactions into struct data type
          axi4_slave_seq_item_converter::from_read_class(local_slave_raddr_tx,struct_read_packet);
        `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_data_packet = \n %0p",struct_read_packet), UVM_MEDIUM);
        //Converting configurations into struct config type
          axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
          `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
        end  
        for(int i=0;i<struct_read_packet.arlen;i++)
           struct_read_packet.rdata[i] ='0;

 
        total_bytes = (local_slave_raddr_tx.arlen+1)*(2**(local_slave_raddr_tx.arsize));
        if(local_slave_raddr_tx.araddr inside {[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]} && axi4_slave_agent_cfg_h.read_data_mode != SLAVE_ERR_RESP_MODE )begin : ADDR_INSIDE_SLAVE_MEM_RANGE
          if(local_slave_raddr_tx.arburst == READ_FIXED) begin : if9
            task_memory_read(local_slave_raddr_tx,struct_read_packet);
            if(crossed_read_addr) begin  : if10
              for(int depth=0;depth<(local_slave_raddr_tx.arlen+1);depth++) begin
                struct_read_packet.rresp[depth] = READ_SLVERR; 
              end
            end : if10
            else begin : ef3 
              struct_read_packet.rresp = READ_OKAY;
            end : ef3
            //read data task
            axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
            `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ_DATA_CHANNEL_PACKET \n%p",struct_read_packet), UVM_NONE);
          end : if9
          else if(local_slave_raddr_tx.arburst == READ_WRAP || local_slave_raddr_tx.arburst == READ_INCR) begin : ef4
            if(axi4_slave_mem_h.is_slave_addr_exists(local_slave_raddr_tx.araddr)) begin :if11
              task_memory_read(local_slave_raddr_tx,struct_read_packet);
              if(local_slave_raddr_tx.arburst == READ_INCR) begin 
                for(int j=0,int loc=0;j<total_bytes;j++) begin : fl2
                  if((local_slave_raddr_tx.araddr+j)==crossed_read_addr) begin : if12
                    loc = j/STROBE_WIDTH;
                    for(int depth=0;depth<(local_slave_raddr_tx.arlen+1);depth++) begin
                      if(depth > loc) struct_read_packet.rresp[depth] = READ_SLVERR;
                      else struct_read_packet.rresp[depth] = READ_OKAY;
                    end
                    break;
                  end : if12
                end: fl2
              end 
              //read data task
              axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
              `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ_DATA_CHANNEL_PACKET \n%p",struct_read_packet), UVM_NONE);
            end : if11
            else begin : ef5
              axi4_slave_agent_cfg_h.user_rdata = (local_slave_raddr_tx.arsize ==READ_1_BYTE)?32'ha:((local_slave_raddr_tx.arsize ==READ_2_BYTES)?32'haa:((local_slave_raddr_tx.arsize ==READ_4_BYTES)?32'hdead_beaf:{DATA_WIDTH{16'habcd}}));
              for(int i=0;i<local_slave_raddr_tx.arlen+1;i++) begin
                struct_read_packet.rdata[i] =  axi4_slave_agent_cfg_h.user_rdata;
              end
              //read data task
              axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
              `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ_DATA_CHANNEL_PACKET \n%p",struct_read_packet), UVM_HIGH);
              `uvm_error("AXI4_SLAVE_DRIVER_PROXY",$sformatf("ADDRESS trying to read DOESN'T EXIST in the slave memory... READING DEFAULT VALUES...."));
            end :ef5
          end : ef4 
        end :ADDR_INSIDE_SLAVE_MEM_RANGE
        else begin : ADDR_NOT_INSIDE_SLAVE_MEM_RANGE
          for(int depth=0;depth<(((axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER)|| (axi4_slave_agent_cfg_h.slave_response_mode == ONLY_READ_RESP_OUT_OF_ORDER) ||(axi4_slave_agent_cfg_h.qos_mode_type == ONLY_READ_QOS_MODE_ENABLE) ||(axi4_slave_agent_cfg_h.qos_mode_type == WRITE_READ_QOS_MODE_ENABLE))  ? (struct_read_packet.arlen+1) : (local_slave_raddr_tx.arlen+1));depth++) begin
            struct_read_packet.rresp[depth] = READ_SLVERR;
          end

          //read data task
          axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
          `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ CHANNEL PACKET \n %p",struct_read_packet), UVM_HIGH);
        end
      end : ef2
      else begin 
        wait(axiReadSlaveAddressQueue.size()>0);
        local_slave_raddr_tx = axiReadSlaveAddressQueue[0];
        axi4_slave_agent_cfg_h.user_rdata = (local_slave_raddr_tx.arsize ==READ_1_BYTE)?32'ha:((local_slave_raddr_tx.arsize ==READ_2_BYTES)?32'haa:((local_slave_raddr_tx.arsize ==READ_4_BYTES)?32'hdead_beaf:{DATA_WIDTH{16'habcd}}));
        for(int i=0;i<local_slave_raddr_tx.arlen+1;i++) begin
            struct_read_packet.rdata[i] =  axi4_slave_agent_cfg_h.user_rdata;
         end
              //read data task
         axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);



      end 
      //Calling converter class for reads to convert struct to req
      axi4_slave_seq_item_converter::to_read_class(struct_read_packet,local_slave_rdata_tx);
      `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ CHANNEL PACKET \n %s",local_slave_rdata_tx.sprint()), UVM_HIGH);

      //Getting teh sampled read address from read address fifo
      axi4_slave_read_addr_fifo_h.get(local_slave_raddr_tx);
    
      //Calling the Combined coverter class to combine read address and read data packet
      axi4_slave_seq_item_converter::tx_read_packet(local_slave_raddr_tx,local_slave_rdata_tx,packet);
      `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: COMBINED READ CHANNEL PACKET \n%s",packet.sprint()), UVM_HIGH);
      readFlag =1;
      waitStates--;     
      //Putting back the key
      semaphore_read_key.put(1);
    end
    join_any
 
    //Check the status of read address thread
    rd_addr.await();
    `uvm_info("SLAVE_STATUS_CHECK",$sformatf("AFTER_FORK_JOIN_ANY:: SLAVE_READ_CHANNEL_STATUS = \n %s",rd_addr.status()),UVM_MEDIUM)
    `uvm_info("SLAVE_STATUS_CHECK",$sformatf("AFTER_FORK_JOIN_ANY:: SLAVE_RDATA_CHANNEL_STATUS = \n %s",rd_data.status()),UVM_MEDIUM)

    axi_read_seq_item_port.item_done();
  end

endtask : axi4_read_task

//--------------------------------------------------------------------------------------------
// Task: task_memory_write
// This task is used to write the data into the slave memory
// Parameters:
//  struct_packet   - axi4_write_transfer_char_s
//--------------------------------------------------------------------------------------------

task axi4_slave_driver_proxy::task_memory_write(input axi4_slave_tx struct_write_packet);
  int lower_addr,end_addr,k_t;
 automatic int addr=struct_write_packet.awaddr;
 struct_write_packet.print(); 
 if(struct_write_packet.awburst == WRITE_FIXED) begin
    for(int j=0;j<(struct_write_packet.awlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
        for(int strb=0;strb<STROBE_WIDTH;strb++) begin
        `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h",struct_write_packet.wstrb[strb]), UVM_HIGH);
        if(struct_write_packet.wstrb[j][strb] == 1) begin
          axi4_slave_mem_h.fifo_write(struct_write_packet.wdata[j][8*strb+7 -: 8]);
        end
      end
    end
  end
  if(struct_write_packet.awburst == WRITE_INCR) begin
    bit unalign;
    int amount;
       if(addr % (2**struct_write_packet.awsize) != 0) begin
             amount = addr - ((addr/(2**struct_write_packet.awsize))*(2**struct_write_packet.awsize));
              $display("DIV AMOUNT IS %0d",(addr/(2**struct_write_packet.awsize)));
             unalign=1;      
       end
    for(int j=0,int k=0;j<(struct_write_packet.awlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
       $display("THE AMOUNT IS %0d when addr is %0d",amount,addr); 
        for(int strb=(addr)%(DATA_WIDTH/8),k=0;strb<((unalign==1) ?( ((addr)%(DATA_WIDTH/8))+(2**struct_write_packet.awsize)-amount) :( ((addr)%(DATA_WIDTH/8))+(2**struct_write_packet.awsize)));strb++) begin
          $display("THE DATA IS wriiteh to mem %0d when addr is %0d and k is %0d",addr+k,addr,k);
          $display("COND IS %0d", ((addr)%(DATA_WIDTH/8))+(2**struct_write_packet.awsize)-amount); 
          $display("STRB IS %0d and addr =%0d",strb,addr+k);
           `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h,k=%0d",struct_write_packet.wstrb[strb],k), UVM_HIGH);
          if(struct_write_packet.wstrb[j][strb] == 1) begin
            axi4_slave_mem_h.mem_write(addr+k,struct_write_packet.wdata[j][8*strb+7 -: 8]);
          end
          k++;
      end
      if(unalign)  begin 
       addr = addr+(2**struct_write_packet.awsize)- amount;
       unalign=0;
     end
     else 
      addr = addr + (2**struct_write_packet.awsize);
    end
  end
  if(struct_write_packet.awburst == WRITE_WRAP) begin
    bit unalign;
    int amount;
       if(addr % (2**struct_write_packet.awsize) != 0) begin
             amount = addr - ((addr/(2**struct_write_packet.awsize))*(2**struct_write_packet.awsize));
              $display("AMOUNT IS %0d",amount);
             unalign=1;
       end


    lower_addr = struct_write_packet.awaddr - int'(struct_write_packet.awaddr%((struct_write_packet.awlen+1)*(2**struct_write_packet.awsize)));
    end_addr = lower_addr + ((struct_write_packet.awlen+1)*(2**struct_write_packet.awsize));

    for(int j=0,int k=0;j<(struct_write_packet.awlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
          $display("NEXT PACK"); 
        for(int strb=(addr)%(DATA_WIDTH/8),k=0;k<((unalign==1) ?((2**struct_write_packet.awsize)-amount):(2**struct_write_packet.awsize));k++) begin
         $display("TEH STRB IS %0d and address is %0d limiter is%0d",strb,addr,k);
         `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h,k=%0d",struct_write_packet.wstrb[strb],k), UVM_HIGH);
          if(struct_write_packet.wstrb[j][strb] == 1) begin
            if(addr < end_addr)  begin
              axi4_slave_mem_h.mem_write(addr,struct_write_packet.wdata[j][8*strb+7 -: 8]);
            end 
          end
          addr++;
          if(addr == end_addr)
            addr = lower_addr;
          strb = (addr)%(DATA_WIDTH/8);
        end
        $display("UNALIGN IS MADE 0");
        unalign=0;
    end
  end

endtask : task_memory_write

task axi4_slave_driver_proxy::task_memory_read(input axi4_slave_tx read_pkt,ref axi4_read_transfer_char_s struct_read_packet);
  int lower_addr,end_addr,k_t;
  automatic int flag =0;
  if(read_pkt.arburst == READ_FIXED) begin
    for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_arlen=%d",read_pkt.arlen),UVM_HIGH)
      for(int strb=0;strb<(2**(read_pkt.arsize));strb++) begin
        axi4_slave_mem_h.fifo_read(struct_read_packet.rdata[j][8*strb+7 -: 8]);
        k++;
      end
    end
    if((read_pkt.araddr+((2**(read_pkt.arsize))))> axi4_slave_agent_cfg_h.max_address) begin 
      crossed_read_addr = 1;
    end
    else crossed_read_addr = 0;
  end
  if(read_pkt.arburst == READ_INCR) begin
    bit unalign;
    int amount;
       if(read_pkt.araddr % (2**read_pkt.arsize) != 0) begin
             amount = read_pkt.araddr - ((read_pkt.araddr/(2**read_pkt.arsize))*(2**read_pkt.arsize));
              $display("DIV AMOUNT IS %0d",(read_pkt.araddr/(2**read_pkt.arsize)));
             unalign=1;
       end
     
    for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
       $display("NEXT PACK");
       `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_arlen=%d",read_pkt.arlen),UVM_HIGH)
        for(int strb=0;strb<((unalign==1)?((2**(read_pkt.arsize))-amount):(2**(read_pkt.arsize)));strb++) begin
         $display("THE ADDRESS DATA READ FROM IS %0d",read_pkt.araddr+k); 
        axi4_slave_mem_h.mem_read(read_pkt.araddr+k,struct_read_packet.rdata[j][8*strb+7 -: 8]);
          if(read_pkt.araddr+k > axi4_slave_agent_cfg_h.max_address && flag ==0) begin 
            crossed_read_addr = read_pkt.araddr+k;
             flag =1;
             $display("CROSSED ADDRESS IS %0d",crossed_read_addr);
          end
          k++;
        end

       unalign=0;
      end
  end
  if(read_pkt.arburst == READ_WRAP) begin
         bit unalign;
    int amount;

    lower_addr = read_pkt.araddr - int'(read_pkt.araddr%((read_pkt.arlen+1)*(2**read_pkt.arsize)));
    end_addr = lower_addr + ((read_pkt.arlen+1)*(2**read_pkt.arsize));
    k_t = read_pkt.araddr;
       if(k_t % (2**read_pkt.arsize) != 0) begin
             amount = k_t - ((k_t/(2**read_pkt.arsize))*(2**read_pkt.arsize));
              $display("DIV AMOUNT IS %0d",(k_t/(2**read_pkt.arsize)));
             unalign=1;
       end

    for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
      struct_read_packet.rresp[j] = READ_OKAY;
         $display("NEXT");
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_arlen=%d",read_pkt.arlen),UVM_HIGH)
        for(int strb=0;strb<((unalign==1)?((2**(read_pkt.arsize))-amount):(2**(read_pkt.arsize)));strb++) begin
          $display("READ TEH STRB IS %0d and address is %0d",strb,k_t);
          if(k_t < end_addr)  begin
             if(k_t >axi4_slave_agent_cfg_h.max_address)
              struct_read_packet.rresp[j] = READ_SLVERR; 
             axi4_slave_mem_h.mem_read(k_t,struct_read_packet.rdata[j][8*strb+7 -: 8]);
                k_t++;
              if(k_t == end_addr) 
                    k_t = lower_addr;
             
              if(k_t > axi4_slave_agent_cfg_h.max_address && flag ==0)begin  
                 crossed_read_addr = k_t;
                 flag =1;
              end 
          end

        end
        unalign=0;
          
      end
    end
endtask : task_memory_read


task axi4_slave_driver_proxy::out_of_order_for_reads(output axi4_read_transfer_char_s oor_read_data_struct_read_packet);
 wait(axi4_slave_read_addr_fifo_h.size > axi4_slave_agent_cfg_h.get_minimum_transactions); 
 `uvm_info("slave_driver_proxy",$sformatf("fifo_size = %0d",axi4_slave_read_addr_fifo_h.used()),UVM_HIGH)
 if(drive_rd_id_cont == 1) begin
   oor_read_data_struct_read_packet = rd_response_id_cont_queue.pop_front(); 
   if(rd_response_id_cont_queue.size()==0) drive_rd_id_cont = 1'b0;
 end
 else begin
   rd_response_id_queue.shuffle();
   oor_read_data_struct_read_packet = rd_response_id_queue.pop_front(); 
 end
endtask : out_of_order_for_reads

`endif
