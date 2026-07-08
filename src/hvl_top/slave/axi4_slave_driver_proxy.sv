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
    axi4_slave_write_addr_fifo_h              = new("axi4_slave_write_addr_fifo_h",this,1600);
    axi4_slave_write_data_in_fifo_h           = new("axi4_slave_write_data_in_fifo_h",this,1600);
    axi4_slave_write_response_fifo_h          = new("axi4_slave_write_response_fifo_h",this,1600);
    axi4_slave_write_data_out_fifo_h          = new("axi4_slave_write_data_out_fifo_h",this,1600);
    axi4_slave_read_addr_fifo_h               = new("axi4_slave_read_addr_fifo_h",this,1600);
    axi4_slave_read_data_in_fifo_h            = new("axi4_slave_read_data_in_fifo_h",this,1600);
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
      `uvm_fatal(get_type_name(),"Cannot get axi4_slave_driver_bfm handle from uvm_config_db - was it set() in hdl_top/agent?");
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
    axi4_slave_mem_h = axi4_slave_memory::type_id::create("axi4_slave_mem_h");
    axi4_slave_drv_bfm_h.axi4_slave_drv_proxy_h= this;
  endfunction  : end_of_elaboration_phase


  //--------------------------------------------------------------------------------------------
  // Task: run_phase
  //--------------------------------------------------------------------------------------------
  task axi4_slave_driver_proxy::run_phase(uvm_phase phase);

    `uvm_info(get_type_name(),"Slave driver proxy started - waiting for system reset",UVM_LOW)

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
          axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
          `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH); 
          axi4_slave_drv_bfm_h.axi4_write_address_phase(struct_write_packet);
          axi4_slave_seq_item_converter::to_write_class(struct_write_packet,req_wr);
          axiSlaveAddressQueue.push_back(req_wr);
          `uvm_info(get_type_name(),$sformatf("WRITE_ADDRESS_CHANNEL::Received write address packet, awid = %0d",req_wr.awid),UVM_MEDIUM)
          axiSlaveIdQueue.push_back(req_wr.awid);
        end:WRITE_ADDRESS_CHANNEL

        begin : WRITE_DATA_CHANNEL
          axi4_slave_tx              local_slave_data_tx;
          axi4_write_transfer_char_s struct_write_packet;
          axi4_transfer_cfg_s        struct_cfg;
          data_tx=process::self();
          semaphore_write_key.get(1);
          axi4_slave_write_data_in_fifo_h.get(local_slave_data_tx);
          local_slave_data_tx = axi4_slave_tx :: type_id :: create("data_tx");
          axi4_slave_seq_item_converter::from_write_class(local_slave_data_tx,struct_write_packet);
          axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
          `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
          axi4_slave_drv_bfm_h.axi4_write_data_phase(struct_write_packet,struct_cfg);
          `uvm_info("DEBUG_SLAVE_WDATA_PROXY", $sformatf("AFTER :: Reciving struct pkt from bfm \n%p",struct_write_packet), UVM_HIGH);
          axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_data_tx);
          `uvm_info(get_type_name(), $sformatf("W data sampled | beats=%0d wlast=%0b",
                    local_slave_data_tx.wdata.size(), local_slave_data_tx.wlast), UVM_MEDIUM)
          axiSlaveDataQueue.push_back(local_slave_data_tx);
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
          int                        start_wrap_addr;

          response_tx=process::self();

          data_tx.await();

          //getting the key from semaphore 
          semaphore_rsp_write_key.get(1);

          if(axi4_slave_write_response_fifo_h.is_empty) begin 
            `uvm_error(get_type_name(),"Write-response FIFO is empty - no pending write to respond to (check AW/W handshake)");
          end 
          else begin 
            //getting the data from response fifo
            axi4_slave_write_response_fifo_h.get(local_slave_response_tx);
          end 

          local_slave_response_tx = axi4_slave_tx :: type_id :: create("slave tx");
          //Converting transactions into struct data type
          axi4_slave_seq_item_converter::from_write_class(local_slave_response_tx,struct_write_packet);

          //Converting configurations into struct config type
          axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
          `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);

          `uvm_info("slave_driver_proxy",$sformatf("min_tx=%0d",axi4_slave_agent_cfg_h.get_minimum_transactions),UVM_HIGH)
          if((axi4_slave_agent_cfg_h.slave_response_mode == RESP_OUT_OF_ORDER)) begin 
            if( flag ==0) 
              wait(numberOfDataTransaction >= activeTransactionCapacity );  
            else 
              wait(axiSlaveDataQueue.size()>0);

            wait(axiSlaveAddressQueue.size()>0);
            axiSlaveIdDynamicArray = new[numberOfDataTransaction];
            axiSlaveIdDynamicArray = axiSlaveIdQueue[0:numberOfDataTransaction-1];
            axiSlaveIdDynamicArray.shuffle();
            indexTracker = axiSlaveIdQueue.find_first_index with(item == axiSlaveIdDynamicArray[0]);
            local_slave_addr_tx = axiSlaveAddressQueue[indexTracker[0]];
            axiSlaveIdQueue.delete(indexTracker[0]);
            axiSlaveAddressQueue.delete(indexTracker[0]);
            local_slave_data_tx = axiSlaveDataQueue[indexTracker[0]];
            axiSlaveDataQueue.delete(indexTracker[0]);
            `uvm_info(get_type_name(),$sformatf("WRITE_RESPONSE_CHANNEL::Slave driver sending out bid = %0d",local_slave_addr_tx.awid),UVM_MEDIUM)
            bid_local = local_slave_addr_tx.awid;
            if(local_slave_addr_tx.awburst == WRITE_FIXED) begin 
              end_wrap_addr =  local_slave_addr_tx.awaddr + ((2**local_slave_addr_tx.awsize));
            end 
            if(local_slave_addr_tx.awburst == WRITE_INCR) begin 
              end_wrap_addr =  local_slave_addr_tx.awaddr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
            end 
            if(local_slave_addr_tx.awburst == WRITE_WRAP) begin 
              end_wrap_addr = local_slave_addr_tx.awaddr - int'(local_slave_addr_tx.awaddr%((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize)));
              start_wrap_addr = end_wrap_addr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
            end 
            `uvm_info("slave_driver_proxy",$sformatf("fifo_size = %0d",axi4_slave_write_data_out_fifo_h.used()),UVM_HIGH)
            if(!((local_slave_addr_tx.awaddr inside {[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]}) && (end_wrap_addr inside{[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}) && (start_wrap_addr inside{[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}))) begin
              struct_write_packet.bresp = WRITE_SLVERR;
            end 
            if(local_slave_addr_tx.awburst == WRITE_FIXED )begin //check fifo overrun
              bit[ADDRESS_WIDTH-1:0]addr = local_slave_addr_tx.awaddr;
              int size = (2**(local_slave_addr_tx.awsize));
              int unalignedAmount = addr - ((addr/(2**local_slave_addr_tx.awsize))*(2**local_slave_addr_tx.awsize));
              int strbLine = addr %(DATA_WIDTH/8);
              int sizeOfFifo = axi4_slave_mem_h.fifo_memory.size();
              bit[(DATA_WIDTH/8)-1:0]strb = local_slave_data_tx.wstrb[0];
              int counts;
              for(int i=0;i<(local_slave_addr_tx.awlen+1);i++) begin 
                if(i!=0)begin 
                  unalignedAmount=0;
                end 
                strb = local_slave_data_tx.wstrb[i];

                for(int j=0;j<(size-unalignedAmount);j++)begin 
                  strbLine = addr %(DATA_WIDTH/8);
                  if(strb[strbLine]==1)begin 
                    counts++;
                  end
                  addr++;
                end 
              end 
              if((sizeOfFifo+counts) > FIFO_SIZE)begin 
                struct_write_packet.bresp = WRITE_SLVERR;
              end 
            end  
            // write response_task
            axi4_slave_drv_bfm_h.axi4_write_response_phase(struct_write_packet,struct_cfg,bid_local);
          end 
          else begin
            wait(axiSlaveDataQueue.size()>0);
            wait(axiSlaveAddressQueue.size()>0);
            local_slave_addr_tx = axiSlaveAddressQueue.pop_front();
            local_slave_data_tx = axiSlaveDataQueue.pop_front();
            `uvm_info(get_type_name(),$sformatf("WRITE_RESPONSE_CHANNEL::Slave driver sending out bid = %0d",local_slave_addr_tx.awid),UVM_MEDIUM)
            bid_local = local_slave_addr_tx.awid;
            if(local_slave_addr_tx.awburst == WRITE_FIXED) begin
              end_wrap_addr =  local_slave_addr_tx.awaddr + ((2**local_slave_addr_tx.awsize));
            end
            if(local_slave_addr_tx.awburst == WRITE_INCR) begin
              end_wrap_addr =  local_slave_addr_tx.awaddr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
            end
            if(local_slave_addr_tx.awburst == WRITE_WRAP) begin
              end_wrap_addr = local_slave_addr_tx.awaddr - int'(local_slave_addr_tx.awaddr%((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize)));
              start_wrap_addr = end_wrap_addr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
            end
            if(!((local_slave_addr_tx.awaddr inside {[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]}) && (end_wrap_addr inside{[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}) && (start_wrap_addr inside{[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}))) begin
              struct_write_packet.bresp = WRITE_SLVERR;

            end
            if(local_slave_addr_tx.awburst == WRITE_FIXED )begin //check fifo overrun
              bit[ADDRESS_WIDTH-1:0]addr = local_slave_addr_tx.awaddr;
              int size = (2**(local_slave_addr_tx.awsize));
              int unalignedAmount = addr - ((addr/(2**local_slave_addr_tx.awsize))*(2**local_slave_addr_tx.awsize));
              int strbLine = addr %(DATA_WIDTH/8);
              int sizeOfFifo = axi4_slave_mem_h.fifo_memory.size();
              bit[(DATA_WIDTH/8)-1:0]strb = local_slave_data_tx.wstrb[0];
              int counts;
              for(int i=0;i<(local_slave_addr_tx.awlen+1);i++) begin 
                if(i!=0)begin 
                  unalignedAmount=0;
                end 
                strb = local_slave_data_tx.wstrb[i];
                for(int j=0;j<(size-unalignedAmount);j++)begin 
                  strbLine = addr %(DATA_WIDTH/8);
                  if(strb[strbLine]==1)begin 
                    counts++;
                  end
                  addr++;
                end 
              end
              if((sizeOfFifo+counts) > FIFO_SIZE)begin 
                struct_write_packet.bresp = WRITE_SLVERR;
              end 
            end 

            axi4_slave_drv_bfm_h.axi4_write_response_phase(struct_write_packet,struct_cfg,bid_local);
          end 
          axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_response_tx);

          //Calling combined data packet from converter class
          axi4_slave_seq_item_converter::tx_write_packet(local_slave_addr_tx,local_slave_data_tx,local_slave_response_tx,packet);
          task_memory_write(packet);
          rsp_wr = RSP :: type_id :: create("RSP OBJECT"); 
          rsp_wr.set_id_info(local_slave_addr_tx);
          axi_write_seq_item_port.put_response(rsp_wr); 
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

    end 

  endtask : axi4_write_task

  //-------------------------------------------------------
  // task axi4 read task
  //-------------------------------------------------------
  task axi4_slave_driver_proxy::axi4_read_task();

    forever begin 

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

          //Converting configurations into struct config type
          axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
          `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);

          //read address_task
          axi4_slave_drv_bfm_h.axi4_read_address_phase(struct_read_packet,struct_cfg);
          //Converting struct into transaction data type
          axi4_slave_seq_item_converter::to_read_class(struct_read_packet,req_rd);
          `uvm_info("DEBUG_SLAVE_READ_ADDR_PROXY", $sformatf(" to_class_raddr_phase_slave_proxy  \n %p",struct_read_packet), UVM_HIGH);


          //Putting back the sampled read address data into fifo
          axi4_slave_read_addr_fifo_h.put(req_rd);
          axiReadSlaveAddressQueue.push_back(req_rd);
          axiReadSlaveIdQueue.push_back(req_rd.arid);
          waitStates++; 

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

          //Getting the data from read data fifo
          axi4_slave_read_data_in_fifo_h.get(local_slave_rdata_tx);

          if((axi4_slave_agent_cfg_h.slave_response_mode == RESP_OUT_OF_ORDER) ) begin 
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
            `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_HIGH); 
          end 
          else if((axi4_slave_agent_cfg_h.slave_response_mode == RESP_IN_ORDER )) begin 
            wait(axiReadSlaveAddressQueue.size()>0);
            local_slave_raddr_tx  = axiReadSlaveAddressQueue.pop_front();
            //Converting transactions into struct data type
            axi4_slave_seq_item_converter::from_read_class(local_slave_raddr_tx,struct_read_packet);
            `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_data_packet = \n %0p",struct_read_packet), UVM_MEDIUM);
            //Converting configurations into struct config type
            axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
            `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
          end  
          for(int i=0;i<(struct_read_packet.arlen+1);i++)
            struct_read_packet.rdata[i] ='0;

          total_bytes = (local_slave_raddr_tx.arlen+1)*(2**(local_slave_raddr_tx.arsize));
          task_memory_read(local_slave_raddr_tx,struct_read_packet);
           rsp_rd = RSP :: type_id :: create("RSP OBJECT"); 
          rsp_rd.set_id_info(local_slave_rdata_tx);
          axi_read_seq_item_port.put_response(rsp_rd); 
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
    bit[ADDRESS_WIDTH-1:0] lower_addr,end_addr,k_t;
    automatic bit[ADDRESS_WIDTH-1:0] addr=struct_write_packet.awaddr;
    struct_write_packet.print();
    if(struct_write_packet.awburst == WRITE_FIXED) begin
      int unalignedAmount;
      if(addr % (2**struct_write_packet.awsize) != 0) begin
        unalignedAmount = addr - ((addr/(2**struct_write_packet.awsize))*(2**struct_write_packet.awsize));
        `uvm_info(get_type_name(),$sformatf("THE WRITE ADDRESS IS UNALIGNED BY AN AMOUNT %0d WHEN THE ARSIZE IS %0d AND ADDRESS IS %0d",unalignedAmount,struct_write_packet.awsize,addr),UVM_HIGH)
      end

      for(int j=0;j<(struct_write_packet.awlen+1);j++)begin
        `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
        if(j!=0 )
          unalignedAmount =0;
        for(int strb=0,k=0;strb<((2**(struct_write_packet.awsize))-unalignedAmount);strb++) begin
          `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h,k=%0d",struct_write_packet.wstrb[strb],k), UVM_HIGH);
          k = addr % (DATA_WIDTH/8);
          if(struct_write_packet.wstrb[j][k] == 1) begin
            axi4_slave_mem_h.fifo_write(struct_write_packet.wdata[j][8*k +: 8]);
          end
          addr++;
        end
      end
    end 
    if(struct_write_packet.awburst == WRITE_INCR) begin
      int unalignedAmount;
      if(addr % (2**struct_write_packet.awsize) != 0) begin
        unalignedAmount = addr - ((addr/(2**struct_write_packet.awsize))*(2**struct_write_packet.awsize));
        `uvm_info(get_type_name(),$sformatf("THE WRITE ADDRESS IS UNALIGNED BY AN AMOUNT %0d WHEN THE ARSIZE IS %0d AND ADDRESS IS %0d",unalignedAmount,struct_write_packet.awsize,addr),UVM_HIGH)
      end
      for(int j=0,int k=0;j<(struct_write_packet.awlen+1);j++)begin
        `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
        if(j != 0)
          unalignedAmount =0;

        for(int strb=0,k=0;strb<((2**struct_write_packet.awsize)-unalignedAmount);strb++) begin
          `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h,k=%0d",struct_write_packet.wstrb[strb],k), UVM_HIGH);
          k = addr % (DATA_WIDTH/8);
          if(struct_write_packet.wstrb[j][k] == 1) begin
            `uvm_info(get_type_name(),$sformatf("THE BYTE WRITTEN TO THE MEMORY IS %h AND THE ADDRESS IS %0d",struct_write_packet.wdata[j][8*k+7 -: 8],addr),UVM_HIGH)
            axi4_slave_mem_h.mem_write(addr,struct_write_packet.wdata[j][8*k +: 8]);
          end
          addr++;
        end
      end
    end
    if(struct_write_packet.awburst == WRITE_WRAP) begin
      int unalignedAmount;
      if(addr % (2**struct_write_packet.awsize) != 0) begin
        unalignedAmount = addr - ((addr/(2**struct_write_packet.awsize))*(2**struct_write_packet.awsize));
        `uvm_info(get_type_name(),$sformatf("THE WRITE ADDRESS IS UNALIGNED BY AN AMOUNT %0d WHEN THE ARSIZE IS %0d AND ADDRESS IS %0d",unalignedAmount,struct_write_packet.awsize,addr),UVM_HIGH)
      end
      lower_addr = struct_write_packet.awaddr - int'(struct_write_packet.awaddr%((struct_write_packet.awlen+1)*(2**struct_write_packet.awsize)));
      end_addr = lower_addr + ((struct_write_packet.awlen+1)*(2**struct_write_packet.awsize));

      `uvm_info(get_type_name(),$sformatf("WRITE WRAP TRANSFER ADDRESS BOUNDARY IS %0d to %0d",lower_addr,end_addr),UVM_HIGH)

      for(int j=0,int k=0;j<(struct_write_packet.awlen+1);j++)begin
        `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
        if(j !=0)
          unalignedAmount =0;
        for(int strb=0,k=0;strb<((2**struct_write_packet.awsize)-unalignedAmount);strb++) begin
          `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h,k=%0d",struct_write_packet.wstrb[strb],k), UVM_HIGH);
          k = addr %(DATA_WIDTH/8);
          if(struct_write_packet.wstrb[j][k] == 1) begin
            if(addr < end_addr)  begin
              `uvm_info(get_type_name(),$sformatf("THE BYTE WRITTEN TO THE MEMORY IS %h AND THE ADDRESS IS %0d",struct_write_packet.wdata[j][8*k+7 -: 8],addr),UVM_HIGH) 
              axi4_slave_mem_h.mem_write(addr,struct_write_packet.wdata[j][8*k +: 8]);
            end 
          end
          addr++;
          if(addr == end_addr)
            addr = lower_addr;
        end
      end
    end

  endtask : task_memory_write

  task axi4_slave_driver_proxy::task_memory_read(input axi4_slave_tx read_pkt,ref axi4_read_transfer_char_s struct_read_packet);
    bit[ADDRESS_WIDTH-1:0] lower_addr,end_addr,k_t;
    automatic int flag =0;
    bit[ADDRESS_WIDTH-1:0] addr;
    addr = read_pkt.araddr;
    struct_read_packet.araddr = addr;
    struct_read_packet.arsize = read_pkt.arsize;
    struct_read_packet.arlen = read_pkt.arlen;
    struct_read_packet.rid = read_pkt.arid;
    if(read_pkt.arburst == READ_FIXED) begin
      int unalignedAmount;
      for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
        if(read_pkt.araddr % (2**read_pkt.arsize) != 0) begin
          unalignedAmount = read_pkt.araddr - ((read_pkt.araddr/(2**read_pkt.arsize))*(2**read_pkt.arsize));
          `uvm_info(get_type_name(),$sformatf("THE READ ADDRESS IS UNALIGNED BY AN AMOUNT %0d WHEN THE ARSIZE IS %0d AND ADDRESS IS %0d",unalignedAmount,read_pkt.arsize,addr),UVM_HIGH)

        end
          
        if(j != 0)
          unalignedAmount =0;
        for(int strb=0;strb<((2**(read_pkt.arsize))-unalignedAmount);strb++) begin
          k = addr % (DATA_WIDTH/8);
          axi4_slave_mem_h.fifo_read(struct_read_packet.rdata[0][8*k +: 8]);
          addr++;
        end 

        if((read_pkt.araddr+((2**(read_pkt.arsize))))> axi4_slave_agent_cfg_h.max_address) begin
          struct_read_packet.rresp[0] = READ_SLVERR;
        end
        else 
          struct_read_packet.rresp[0]=READ_OKAY;
        if(j == read_pkt.arlen)
          struct_read_packet.rlast=1;
        axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet);
      end
    end
    if(read_pkt.arburst == READ_INCR) begin
      int unalignedAmount;
      if(read_pkt.araddr % (2**read_pkt.arsize) != 0) begin
        unalignedAmount = read_pkt.araddr - ((read_pkt.araddr/(2**read_pkt.arsize))*(2**read_pkt.arsize));
        `uvm_info(get_type_name(),$sformatf("THE READ ADDRESS IS UNALIGNED BY AN AMOUNT %0d WHEN THE ARSIZE IS %0d AND ADDRESS IS %0d",unalignedAmount,read_pkt.arsize,addr),UVM_HIGH)

      end
      for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
        struct_read_packet.rresp[0] = READ_OKAY;
        if(j!=0) begin 
          unalignedAmount =0;
        end 

        `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_arlen=%d",read_pkt.arlen),UVM_HIGH)
        for(int strb=0;strb<((2**(read_pkt.arsize))-unalignedAmount);strb++) begin
          k = addr % (DATA_WIDTH/8);

          if(axi4_slave_mem_h.is_slave_addr_exists(addr) && read_pkt.araddr inside {[axi4_slave_agent_cfg_h.min_address :axi4_slave_agent_cfg_h.max_address]})begin

            axi4_slave_mem_h.mem_read(addr,struct_read_packet.rdata[0][8*k +: 8]);
            addr++;
            `uvm_info(get_type_name(),$sformatf("SLAVE WRAP READ THE DATA EXISTS READ FROM %0d AND READ DATA IS %0d",addr,struct_read_packet.rdata[0][8*k+7 -: 8]),UVM_HIGH)

          end 
          else begin 
            struct_read_packet.rresp[0] = READ_SLVERR;
            `uvm_info(get_type_name(),$sformatf("SLAVE WRAP READ THE DATA DOESNT EXIST READ FROM %0d",addr),UVM_HIGH)
            struct_read_packet.rdata[0][8*k +:8] = '0;
            addr++;
          end 
        end
        if(j == read_pkt.arlen)
          struct_read_packet.rlast=1;
        axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet);
      end
    end
    if(read_pkt.arburst == READ_WRAP) begin
      int unalignedAmount;
      lower_addr = read_pkt.araddr - int'(read_pkt.araddr%((read_pkt.arlen+1)*(2**read_pkt.arsize)));
      end_addr = lower_addr + ((read_pkt.arlen+1)*(2**read_pkt.arsize));
      `uvm_info(get_type_name(),$sformatf("READ WRAP TRANSFER ADDRESS BOUNDARY IS %0d to %0d",lower_addr,end_addr),UVM_HIGH)

      k_t = read_pkt.araddr;
      if(k_t % (2**read_pkt.arsize) != 0) begin
        unalignedAmount = k_t - ((k_t/(2**read_pkt.arsize))*(2**read_pkt.arsize));
        `uvm_info(get_type_name(),$sformatf("THE READ ADDRESS IS UNALIGNED BY AN AMOUNT %0d WHEN THE ARSIZE IS %0d AND ADDRESS IS %0d",unalignedAmount,read_pkt.arsize,k_t),UVM_HIGH)
      end
      for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
        struct_read_packet.rresp[0] = READ_OKAY;
        if(j !=0)
          unalignedAmount =0;

        for(int strb=0;strb<((2**read_pkt.arsize)-unalignedAmount);strb++) begin
          if(k_t < end_addr)  begin
            if(k_t >axi4_slave_agent_cfg_h.max_address && k_t < axi4_slave_agent_cfg_h.min_address)
              struct_read_packet.rresp[0] = READ_SLVERR; 
            k = k_t % (DATA_WIDTH/8);
            if(axi4_slave_mem_h.is_slave_addr_exists(k_t))begin  
              axi4_slave_mem_h.mem_read(k_t,struct_read_packet.rdata[0][8*k +: 8]);
              `uvm_info(get_type_name(),$sformatf("SLAVE WRAP READ THE DATA EXISTS READ FROM %0d AND READ DATA IS %0d",k_t,struct_read_packet.rdata[0][8*k+7 -: 8]),UVM_HIGH)
              k_t++;
            end 
            else begin
              `uvm_info(get_type_name(),$sformatf("SLAVE WRAP READ THE DATA DOESNT EXIST READ FROM %0d",k_t),UVM_HIGH)

              struct_read_packet.rresp[0] = READ_SLVERR;
              struct_read_packet.rdata[0][8*k +:8] = '0;
              k_t++;
            end 
            if(k_t == end_addr) 
              k_t = lower_addr;
          end
        end
        if(j == read_pkt.arlen)
          struct_read_packet.rlast=1;
        axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet);

      end
    end
  endtask : task_memory_read

`endif
