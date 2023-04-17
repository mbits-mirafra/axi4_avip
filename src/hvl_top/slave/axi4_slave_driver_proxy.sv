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
  
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task axi4_write_task();
  extern virtual task axi4_read_task();
  extern virtual task task_memory_write(inout axi4_slave_tx struct_write_packet);
  extern virtual task task_memory_read(input axi4_slave_tx read_pkt,output axi4_read_transfer_char_s struct_read_packet);
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
  
  forever begin
    
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
    
      //returns status of address thread
      addr_tx=process::self();
      

      //Converting transactions into struct data type
      axi4_slave_seq_item_converter::from_write_class(req_wr,struct_write_packet);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_write_packet = \n %0p",struct_write_packet), UVM_HIGH); 

     //Converting configurations into struct config type
     axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
     `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
     
     //write address_task
     axi4_slave_drv_bfm_h.axi4_write_address_phase(struct_write_packet);

     if(axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER || axi4_slave_agent_cfg_h.slave_response_mode == ONLY_WRITE_RESP_OUT_OF_ORDER) begin
       if(response_id_queue.size() == 0) begin
         response_id_queue.push_back(struct_write_packet.awid);
       end
       else begin
         // condition to check if the same id's are coming back to back
         if(struct_write_packet.awid == response_id_queue[$]) begin
           drive_id_cont = 1'b1;
           local_awid = response_id_queue.pop_back();
           response_id_cont_queue.push_back(local_awid);
           response_id_cont_queue.push_back(struct_write_packet.awid);
         end
         else begin
           response_id_queue.push_back(struct_write_packet.awid);
         end
       end
     end

     //Converting struct into transaction data type
     axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_addr_tx);
     
     `uvm_info("DEBUG_SLAVE_WRITE_ADDR_PROXY", $sformatf("AFTER :: Received req packet \n %s",local_slave_addr_tx.sprint()), UVM_NONE);
     
     // putting write address data into address fifo
     if(axi4_slave_write_addr_fifo_h.is_full) begin
       `uvm_error(get_type_name(),$sformatf("WRITE_ADDR_THREAD::Cannot put into FIFO as WRITE_FIFO is FULL"));
     end
     else begin
       axi4_slave_write_addr_fifo_h.put(local_slave_addr_tx);
     end
     wr_addr_cnt++;
   
   end
 
  begin : WRITE_DATA_CHANNEL

      axi4_slave_tx              local_slave_data_tx;
      axi4_write_transfer_char_s struct_write_packet;
      axi4_transfer_cfg_s        struct_cfg;
      
      //returns status of write data thread
      data_tx=process::self();

      // Trying to get the write key 
      semaphore_write_key.get(1);

      //getting the data from write data fifo
      axi4_slave_write_data_in_fifo_h.get(local_slave_data_tx);
      
      //Converting transactions into struct data type
      axi4_slave_seq_item_converter::from_write_class(local_slave_data_tx,struct_write_packet);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_write_packet = \n %0p",struct_write_packet), UVM_HIGH); 

      //Converting configurations into struct config type
      axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);

      // write data_task
      axi4_slave_drv_bfm_h.axi4_write_data_phase(struct_write_packet,struct_cfg);
      `uvm_info("DEBUG_SLAVE_WDATA_PROXY", $sformatf("AFTER :: Reciving struct pkt from bfm \n%p",struct_write_packet), UVM_HIGH);
     
      
      //Converting struct into transaction data type
      axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_data_tx);


     `uvm_info("DEBUG_SLAVE_WDATA_PROXY_TO_CLASS", $sformatf("AFTER TO CLASS :: Received req packet \n %s", local_slave_data_tx.sprint()), UVM_NONE);

     //putting the write data into write data out fifo 
      axi4_slave_write_data_out_fifo_h.put(local_slave_data_tx);

      //putting back the semaphore key
      semaphore_write_key.put(1);
    
    end
  
  begin : WRITE_RESPONSE_CHANNEL

      axi4_slave_tx              local_slave_addr_tx;
      axi4_slave_tx              local_slave_data_tx;
      axi4_slave_tx              local_slave_response_tx;
      axi4_slave_tx              packet;
      axi4_write_transfer_char_s struct_write_packet;
      axi4_transfer_cfg_s        struct_cfg;
      bit[3:0]                   bid_local;
      int                        end_wrap_addr;
      bit                        slave_err;
      
      //returns status of response thread
      response_tx=process::self();

      data_tx.await();
      
      //getting the key from semaphore 
      semaphore_rsp_write_key.get(1);

      //getting the data from response fifo
      axi4_slave_write_response_fifo_h.get(local_slave_response_tx);
      
      //Converting transactions into struct data type
      axi4_slave_seq_item_converter::from_write_class(local_slave_response_tx,struct_write_packet);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_write_packet = \n %0p",struct_write_packet), UVM_HIGH); 

      //Converting configurations into struct config type
      axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
      `uvm_info(get_type_name(), $sformatf("from_write_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);

      //check for fifo empty if not get the data 
      if(axi4_slave_write_addr_fifo_h.is_empty) begin
        `uvm_error(get_type_name(),$sformatf("WRITE_RESP_THREAD::Cannot get write addr data from FIFO as WRITE_ADDR_FIFO is EMPTY"));
      end
      else begin
       axi4_slave_write_addr_fifo_h.get(local_slave_addr_tx);
       `uvm_info("DEBUG_FIFO",$sformatf("fifo_size = %0d",axi4_slave_write_addr_fifo_h.size()),UVM_HIGH)
       `uvm_info("DEBUG_FIFO",$sformatf("fifo_used =%0d",axi4_slave_write_addr_fifo_h.used()),UVM_NONE)
      end

      if(local_slave_addr_tx.awburst == WRITE_FIXED) begin
        end_wrap_addr =  local_slave_addr_tx.awaddr + ((2**local_slave_addr_tx.awsize));
      end
      if(local_slave_addr_tx.awburst == WRITE_INCR) begin
        end_wrap_addr =  local_slave_addr_tx.awaddr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
      end
      if(local_slave_addr_tx.awburst == WRITE_WRAP) begin
         end_wrap_addr = local_slave_addr_tx.awaddr - int'(local_slave_addr_tx.awaddr%((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize)));
         end_wrap_addr = end_wrap_addr + ((local_slave_addr_tx.awlen+1)*(2**local_slave_addr_tx.awsize));
      end
      `uvm_info("get_type_name",$sformatf("end_addr=%0h",end_wrap_addr),UVM_HIGH);

      `uvm_info("slave_driver_proxy",$sformatf("min_tx=%0d",axi4_slave_agent_cfg_h.get_minimum_transactions),UVM_HIGH)
      if(axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER || axi4_slave_agent_cfg_h.slave_response_mode == ONLY_WRITE_RESP_OUT_OF_ORDER) begin
        wait(axi4_slave_write_data_out_fifo_h.size > axi4_slave_agent_cfg_h.get_minimum_transactions); //begin
          `uvm_info("slave_driver_proxy",$sformatf("fifo_size = %0d",axi4_slave_write_data_out_fifo_h.used()),UVM_HIGH)
          if(drive_id_cont == 1) begin
            bid_local = response_id_cont_queue.pop_front(); 
            `uvm_info("slave_driver_proxy",$sformatf("bid_local = %0d",bid_local),UVM_HIGH)
            `uvm_info("slave_driver_proxy",$sformatf("drive_id_cont = %0d",drive_id_cont),UVM_HIGH)
            if(response_id_cont_queue.size()==0) drive_id_cont = 1'b0;
          end
          else begin
            response_id_queue.shuffle();
            bid_local = response_id_queue.pop_front(); 
            `uvm_info("slave_driver_proxy",$sformatf("bid_local = %0d",bid_local),UVM_HIGH)
          end
          if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE || axi4_slave_agent_cfg_h.read_data_mode == SLAVE_ERR_RESP_MODE) begin
             if(!((local_slave_addr_tx.awaddr inside {[axi4_slave_agent_cfg_h.min_address :
               axi4_slave_agent_cfg_h.max_address]}) && (end_wrap_addr inside
               {[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}))) begin
               struct_write_packet.bresp = WRITE_SLVERR;
               slave_err = 1;
             end
          end
          // write response_task
          axi4_slave_drv_bfm_h.axi4_write_response_phase(struct_write_packet,struct_cfg,bid_local);
          `uvm_info("DEBUG_SLAVE_WDATA_PROXY", $sformatf("AFTER :: Reciving struct pkt from bfm \n %p",struct_write_packet), UVM_HIGH);
      //  end
      end
      else begin
       if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE || axi4_slave_agent_cfg_h.read_data_mode == SLAVE_ERR_RESP_MODE) begin
          if(!((local_slave_addr_tx.awaddr inside {[axi4_slave_agent_cfg_h.min_address :
            axi4_slave_agent_cfg_h.max_address]}) && (end_wrap_addr inside
            {[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}))) begin
            struct_write_packet.bresp = WRITE_SLVERR;
            slave_err = 1;
          end
        end
        // write response_task
        axi4_slave_drv_bfm_h.axi4_write_response_phase(struct_write_packet,struct_cfg,bid_local);
        `uvm_info("DEBUG_SLAVE_WDATA_PROXY", $sformatf("AFTER :: Reciving struct pkt from bfm \n %p",struct_write_packet), UVM_HIGH);
      end

      //Converting struct into transaction data type
      axi4_slave_seq_item_converter::to_write_class(struct_write_packet,local_slave_response_tx);

     `uvm_info("DEBUG_SLAVE_WDATA_PROXY_TO_CLASS", $sformatf("AFTER TO CLASS :: Received req packet \n %s", local_slave_response_tx.sprint()), UVM_NONE);
     

      axi4_slave_write_data_out_fifo_h.get(local_slave_data_tx);

     //Calling combined data packet from converter class
     axi4_slave_seq_item_converter::tx_write_packet(local_slave_addr_tx,local_slave_data_tx,local_slave_response_tx,packet);
     `uvm_info("DEBUG_SLAVE_WDATA_PROXY", $sformatf("AFTER :: COMBINED WRITE CHANNEL PACKET \n%s",packet.sprint()), UVM_NONE);

     //calling task memory write to store the data into slave memory
     if(axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE && ~slave_err) begin
       task_memory_write(packet);
     end
     wr_resp_cnt++;
     if(wr_addr_cnt == wr_resp_cnt) begin
       completed_initial_txn=1;
     end
     
     semaphore_rsp_write_key.put(1);
   end
 
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
      `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_HIGH); 
      
      //Converting configurations into struct config type
      axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
      `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
      
      //read address_task
      axi4_slave_drv_bfm_h.axi4_read_address_phase(struct_read_packet,struct_cfg);

     // Storing data for enabling out_of_order feature
     if(axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER || axi4_slave_agent_cfg_h.slave_response_mode == ONLY_READ_RESP_OUT_OF_ORDER) begin
       if(rd_response_id_queue.size() == 0) begin
         rd_response_id_queue.push_back(struct_read_packet);
       end
       else begin
         // condition to check if the same id's are coming back to back
         oor_struct_read_packet = rd_response_id_queue[$];
         if(struct_read_packet.arid == oor_struct_read_packet.arid) begin
           drive_rd_id_cont = 1'b1;
           oor_struct_read_packet = rd_response_id_queue.pop_back();
           rd_response_id_cont_queue.push_back(oor_struct_read_packet);
           rd_response_id_cont_queue.push_back(struct_read_packet);
         end
         else begin
           rd_response_id_queue.push_back(struct_read_packet);
         end
       end
     end
      
     //Converting struct into transaction data type
     axi4_slave_seq_item_converter::to_read_class(struct_read_packet,local_slave_tx);
     `uvm_info("DEBUG_SLAVE_READ_ADDR_PROXY", $sformatf(" to_class_raddr_phase_slave_proxy  \n %p",struct_read_packet), UVM_NONE);
     
     //Putting back the sampled read address data into fifo
     axi4_slave_read_addr_fifo_h.put(local_slave_tx);
     `uvm_info("DEBUG_SLAVE_READ_ADDR_PROXY", $sformatf("AFTER :: Received req packet \n %s",local_slave_tx.sprint()), UVM_NONE);
    
   end
  
   begin : READ_DATA_CHANNEL
    
     axi4_slave_tx              local_slave_rdata_tx;
     axi4_slave_tx              local_slave_raddr_tx;
     axi4_slave_tx              local_slave_addr_chk_tx;
     axi4_slave_tx              packet;
     axi4_read_transfer_char_s struct_read_packet;
     axi4_transfer_cfg_s       struct_cfg;
     int                       total_bytes;

     //returns status of data thread
     rd_data = process::self();


     //Waiting for the read address thread to complete
     rd_addr.await();

     //Getting the data from read data fifo
     axi4_slave_read_data_in_fifo_h.get(local_slave_rdata_tx);

     if(axi4_slave_agent_cfg_h.read_data_mode == RANDOM_DATA_MODE || write_read_mode_h == ONLY_READ_DATA) begin
       
       //Getting the key from semaphore
       semaphore_read_key.get(1);

       //Converting transactions into struct data type
       axi4_slave_seq_item_converter::from_read_class(local_slave_rdata_tx,struct_read_packet);
       `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_HIGH); 
 
       //Converting configurations into struct config type
       axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
       `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);
       
       //Task to check the out_of_order enable and updates the read structure 
       if((axi4_slave_agent_cfg_h.slave_response_mode == ONLY_READ_RESP_OUT_OF_ORDER) || (axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER) ) begin
         out_of_order_for_reads(struct_read_packet);
         `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_NONE); 
       end
       
       //read data task
       axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
       `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ CHANNEL PACKET \n %p",struct_read_packet), UVM_HIGH);
     end
     else if (axi4_slave_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE || axi4_slave_agent_cfg_h.read_data_mode == SLAVE_ERR_RESP_MODE && write_read_mode_h != ONLY_READ_DATA) begin

       wait(completed_initial_txn==1);
       //Converting transactions into struct data type
       axi4_slave_seq_item_converter::from_read_class(local_slave_rdata_tx,struct_read_packet);
       `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_NONE); 
 
       //Converting configurations into struct config type
       axi4_slave_cfg_converter::from_class(axi4_slave_agent_cfg_h,struct_cfg);
       `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_cfg =  \n %0p",struct_cfg),UVM_HIGH);

       if((axi4_slave_agent_cfg_h.slave_response_mode == ONLY_READ_RESP_OUT_OF_ORDER) || (axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER) ) begin
         out_of_order_for_reads(struct_read_packet);
         `uvm_info(get_type_name(), $sformatf("from_read_class:: struct_read_packet = \n %0p",struct_read_packet), UVM_NONE); 
       end

      semaphore_read_key.get(1);
      axi4_slave_read_addr_fifo_h.peek(local_slave_addr_chk_tx);
      total_bytes = (local_slave_addr_chk_tx.arlen+1)*(2**(local_slave_addr_chk_tx.arsize));
      if(local_slave_addr_chk_tx.araddr inside {[axi4_slave_agent_cfg_h.min_address : axi4_slave_agent_cfg_h.max_address]}) begin : ADDR_INSIDE_SLAVE_MEM_RANGE
        if(local_slave_addr_chk_tx.arburst == READ_FIXED) begin
          task_memory_read(local_slave_addr_chk_tx,struct_read_packet);
          if(crossed_read_addr) begin 
            for(int depth=0;depth<(local_slave_addr_chk_tx.arlen+1);depth++) begin
              struct_read_packet.rresp[depth] = READ_SLVERR; 
            end
          end
          else begin 
            struct_read_packet.rresp = READ_OKAY;
          end
          //read data task
          axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
          `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ_CHANNEL_PACKET \n%p",struct_read_packet), UVM_NONE);
        end
        else if(local_slave_addr_chk_tx.arburst == READ_WRAP || local_slave_addr_chk_tx.arburst == READ_INCR) begin
          if(axi4_slave_mem_h.is_slave_addr_exists(local_slave_addr_chk_tx.araddr)) begin 
            task_memory_read(local_slave_addr_chk_tx,struct_read_packet);
            for(int j=0,int loc=0;j<total_bytes;j++) begin
              if((local_slave_addr_chk_tx.araddr+j)==crossed_read_addr) begin
                loc = j/STROBE_WIDTH;
                for(int depth=0;depth<(local_slave_addr_chk_tx.arlen+1);depth++) begin
                  if(depth > loc) struct_read_packet.rresp[depth] = READ_SLVERR;
                  else struct_read_packet.rresp[depth] = READ_OKAY;
                end
                break;
              end
            end
            //read data task
            axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
            `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ_CHANNEL_PACKET \n%p",struct_read_packet), UVM_NONE);
          end
          else begin
            axi4_slave_agent_cfg_h.user_rdata = (local_slave_addr_chk_tx.arsize ==
            READ_1_BYTE)?32'ha:((local_slave_addr_chk_tx.arsize ==
            READ_2_BYTES)?32'haa:((local_slave_addr_chk_tx.arsize ==
            READ_4_BYTES)?32'hdead_beaf:{DATA_WIDTH{16'habcd}}));
            for(int i=0;i<local_slave_addr_chk_tx.arlen+1;i++) begin
              struct_read_packet.rdata[i] =  axi4_slave_agent_cfg_h.user_rdata;
            end
            //read data task
            axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
            `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ_CHANNEL_PACKET \n%p",struct_read_packet), UVM_NONE);
            `uvm_error("AXI4_SLAVE_DRIVER_PROXY",$sformatf("ADDRESS trying to read DOESN'T EXIST in the slave memory... READING DEFAULT VALUES...."));
          end
        end
      end
      else begin : ADDR_NOT_INSIDE_SLAVE_MEM_RANGE
        for(int depth=0;depth<(((axi4_slave_agent_cfg_h.slave_response_mode == WRITE_READ_RESP_OUT_OF_ORDER) || (axi4_slave_agent_cfg_h.slave_response_mode == ONLY_READ_RESP_OUT_OF_ORDER))  ? (struct_read_packet.arlen+1) : (local_slave_addr_chk_tx.arlen+1));depth++) begin
          struct_read_packet.rresp[depth] = READ_SLVERR; 
        end
        $display("rspp:%0p,id:%0h,len:%0h",struct_read_packet.rdata,struct_read_packet.arid,struct_read_packet.arlen);

        //read data task
        axi4_slave_drv_bfm_h.axi4_read_data_phase(struct_read_packet,struct_cfg,axi4_slave_agent_cfg_h.slave_response_mode);
        `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ CHANNEL PACKET \n %p",struct_read_packet), UVM_HIGH);
      end
     end
     //Calling converter class for reads to convert struct to req
     axi4_slave_seq_item_converter::to_read_class(struct_read_packet,local_slave_rdata_tx);
     `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: READ CHANNEL PACKET \n %s",local_slave_rdata_tx.sprint()), UVM_HIGH);

     //Getting teh sampled read address from read address fifo
     axi4_slave_read_addr_fifo_h.get(local_slave_raddr_tx);
    
     //Calling the Combined coverter class to combine read address and read data packet
     axi4_slave_seq_item_converter::tx_read_packet(local_slave_raddr_tx,local_slave_rdata_tx,packet);
     `uvm_info("DEBUG_SLAVE_RDATA_PROXY", $sformatf("AFTER :: COMBINED READ CHANNEL PACKET \n%s",packet.sprint()), UVM_NONE);
     
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

task axi4_slave_driver_proxy::task_memory_write(inout axi4_slave_tx struct_write_packet);
  int lower_addr,end_addr,k_t;
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
    for(int j=0,int k=0;j<(struct_write_packet.awlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
        for(int strb=0;strb<STROBE_WIDTH;strb++) begin
        `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h,k=%0d",struct_write_packet.wstrb[strb],k), UVM_HIGH);
        if(struct_write_packet.wstrb[j][strb] == 1) begin
          axi4_slave_mem_h.mem_write(struct_write_packet.awaddr+k,struct_write_packet.wdata[j][8*strb+7 -: 8]);
          k++;
        end
      end
    end
  end
  if(struct_write_packet.awburst == WRITE_WRAP) begin
    lower_addr = struct_write_packet.awaddr - int'(struct_write_packet.awaddr%((struct_write_packet.awlen+1)*(2**struct_write_packet.awsize)));
    end_addr = lower_addr + ((struct_write_packet.awlen+1)*(2**struct_write_packet.awsize));
    k_t = struct_write_packet.awaddr;
    for(int j=0,int k=0;j<(struct_write_packet.awlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_awlen=%d",struct_write_packet.awlen),UVM_HIGH)
        for(int strb=0;strb<STROBE_WIDTH;strb++) begin
        `uvm_info("DEBUG_MEMORY_WRITE", $sformatf("task_memory_write inside for loop wstrb = %0h,k=%0d",struct_write_packet.wstrb[strb],k), UVM_HIGH);
          if(struct_write_packet.wstrb[j][strb] == 1) begin
            if(k_t < end_addr)  begin
            axi4_slave_mem_h.mem_write(struct_write_packet.awaddr+k,struct_write_packet.wdata[j][8*strb+7 -: 8]);
            k++;
            k_t++;
            if(k_t == end_addr) k = 0;
          end
          else begin
            axi4_slave_mem_h.mem_write(lower_addr+k,struct_write_packet.wdata[j][8*strb+7 -: 8]);
            k++;
          end
        end
      end
    end
  end

endtask : task_memory_write

task axi4_slave_driver_proxy::task_memory_read(input axi4_slave_tx read_pkt,output axi4_read_transfer_char_s struct_read_packet);
  int lower_addr,end_addr,k_t;
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
    for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_arlen=%d",read_pkt.arlen),UVM_HIGH)
        for(int strb=0;strb<(2**(read_pkt.arsize));strb++) begin
          axi4_slave_mem_h.mem_read(read_pkt.araddr+k,struct_read_packet.rdata[j][8*strb+7 -: 8]);
          if(read_pkt.araddr+k > axi4_slave_agent_cfg_h.max_address) begin 
            crossed_read_addr = read_pkt.araddr+k;
          end
          k++;
        end
      end
    end
  if(read_pkt.arburst == READ_WRAP) begin
    lower_addr = read_pkt.araddr - int'(read_pkt.araddr%((read_pkt.arlen+1)*(2**read_pkt.arsize)));
    end_addr = lower_addr + ((read_pkt.arlen+1)*(2**read_pkt.arsize));
    k_t = read_pkt.araddr;
    for(int j=0,int k=0;j<(read_pkt.arlen+1);j++)begin
      `uvm_info("DEBUG_MEMORY_WRITE",$sformatf("memory_task_arlen=%d",read_pkt.arlen),UVM_HIGH)
        for(int strb=0;strb<(2**(read_pkt.arsize));strb++) begin
          if(k_t < end_addr)  begin
             axi4_slave_mem_h.mem_read(read_pkt.araddr+k,struct_read_packet.rdata[j][8*strb+7 -: 8]);
             if(read_pkt.araddr+k > axi4_slave_agent_cfg_h.max_address) crossed_read_addr = read_pkt.araddr+k;
             k++;
             k_t++;
             if(k_t == end_addr) k = 0;
          end
          else begin
            axi4_slave_mem_h.mem_read(lower_addr+k,struct_read_packet.rdata[j][8*strb+7 -: 8]);
             if(crossed_read_addr == -1) begin
               if(lower_addr+k > axi4_slave_agent_cfg_h.max_address) crossed_read_addr = lower_addr+k;
             end
            k++;
          end
        end
      end
    end
endtask : task_memory_read


task axi4_slave_driver_proxy::out_of_order_for_reads(output axi4_read_transfer_char_s oor_read_data_struct_read_packet);
 $display("Inside_read_OOR");
 wait(axi4_slave_read_addr_fifo_h.size > axi4_slave_agent_cfg_h.get_minimum_transactions); 
 `uvm_info("slave_driver_proxy",$sformatf("fifo_size = %0d",axi4_slave_read_addr_fifo_h.used()),UVM_NONE)
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
