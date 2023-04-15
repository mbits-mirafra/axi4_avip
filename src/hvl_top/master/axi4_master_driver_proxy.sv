`ifndef AXI4_MASTER_DRIVER_PROXY_INCLUDED_
`define AXI4_MASTER_DRIVER_PROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: master_driver_proxy
//  Driver is written by extending uvm_driver,uvm_driver is inherited from uvm_component, 
//  Methods and TLM port (seq_item_port) are defined for communication between sequencer and driver,
//  uvm_driver is a parameterized class and it is parameterized with the type of the request 
//  sequence_item and the type of the response sequence_item 
//--------------------------------------------------------------------------------------------
class axi4_master_driver_proxy extends uvm_driver#(axi4_master_tx);
  `uvm_component_utils(axi4_master_driver_proxy)

  //Port: axi_write_seq_item_port
  //This port is used to request write items from the sequencer, they are also used it to send responses back.
  uvm_seq_item_pull_port #(REQ,RSP) axi_write_seq_item_port;
  
  //Port: axi_read_seq_item_port
  //This port is used to request read items from the sequencer, they are also used it to send responses back.
  uvm_seq_item_pull_port #(REQ,RSP) axi_read_seq_item_port;

  //Port: axi_write_rsp_port
  //This port provides an alternate way of sending responses back to the originating sequencer. 
  //Which port to use depends on which export the sequencer provides for connection.
  uvm_analysis_port #(RSP) axi_write_rsp_port;
  
  //Port: axi_read_rsp_port
  //This port provides an alternate way of sending responses back to the originating sequencer. 
  //Which port to use depends on which export the sequencer provides for connection.
  uvm_analysis_port #(RSP) axi_read_rsp_port;

  //Variable: axi4_master_write_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(axi4_master_tx) axi4_master_write_fifo_h;

  //Variable: axi4_master_write_resp_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(axi4_master_tx) axi4_master_write_resp_fifo_h;
  
  //Variable: axi4_master_read_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for read task
  uvm_tlm_analysis_fifo #(axi4_master_tx) axi4_master_read_fifo_h;

  //Variable: req_wr, req_rd
  //Declaration of REQ handles
  REQ req_wr, req_rd;
  
  //Variable: rsp_wr, rsp_rd
  //Declaration of RSP handles
  RSP rsp_wr, rsp_rd;
      
  //Variable: axi4_master_agent_cfg_h
  //Declaring handle for axi4_master agent config class 
  axi4_master_agent_config axi4_master_agent_cfg_h;

  //Variable: axi4_master_drv_bfm_h
  //Declaring handle for axi4 driver bfm
  virtual axi4_master_driver_bfm axi4_master_drv_bfm_h;

  //Vaiaable : write_data_channel_key
  //Used to assign keys to this semaphore and 
  //to take keys from the semaphore
  //Used to block the process from happening until the key is put
  semaphore write_data_channel_key;
  
  //Vaiaable : write_response_channel_key
  //Used to assign keys to this semaphore and 
  //to take keys from the semaphore
  //Used to block the process from happening until the key is put
  semaphore write_response_channel_key;

  //Vaiaable : write_response_channel_key
  //Used to assign keys to this semaphore and 
  //to take keys from the semaphore
  //Used to block the process from happening until the key is put
  semaphore read_channel_key;
  

  int address,length,size;

  bit wait_for_wr_addr;

  write_read_data_mode_e write_read_mode_h;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_driver_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task axi4_write_task();
  extern virtual task axi4_read_task();

endclass : axi4_master_driver_proxy

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_master_driver_proxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_master_driver_proxy::new(string name = "axi4_master_driver_proxy", uvm_component parent = null);
  super.new(name, parent);
  axi_write_seq_item_port    = new("axi_write_seq_item_port",this);
  axi_read_seq_item_port     = new("axi_read_seq_item_port",this);
  axi_write_rsp_port         = new("axi_write_rsp_port",this);
  axi_read_rsp_port          = new("axi_read_rsp_port",this);
  axi4_master_write_fifo_h   = new("axi4_master_write_fifo_h",this);
  axi4_master_write_resp_fifo_h   = new("axi4_master_write_resp_fifo_h",this);
  axi4_master_read_fifo_h    = new("axi4_master_read_fifo_h",this);
  read_channel_key           = new(1);
  write_data_channel_key     = new(1);
  write_response_channel_key = new(1);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_master_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual axi4_master_driver_bfm)::get(this,"","axi4_master_driver_bfm",axi4_master_drv_bfm_h)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_AXI4_MASTER_DRIVER_BFM","cannot get() axi4_master_drv_bfm_h");
  end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_master_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  axi4_master_drv_bfm_h.axi4_master_drv_proxy_h = this;
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
//  Gets the sequence_item, converts them to struct compatible transactions
//  and sends them to the BFM to drive the data over the interface
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task axi4_master_driver_proxy::run_phase(uvm_phase phase);

  //waiting for system reset
  axi4_master_drv_bfm_h.wait_for_aresetn();

  fork 
    axi4_write_task();
    axi4_read_task();
  join

endtask : run_phase

//--------------------------------------------------------------------------------------------
// Task: axi4_write_task
//  Gets the sequence_item, converts them to struct compatible transactions
//  and sends them to the BFM to drive the data over the interface
//--------------------------------------------------------------------------------------------
task axi4_master_driver_proxy::axi4_write_task();

  forever begin
    axi4_master_tx             local_master_tx;
    axi4_transfer_cfg_s        struct_cfg;
    axi4_write_transfer_char_s struct_write_packet;

    axi_write_seq_item_port.get_next_item(req_wr);
    `uvm_info(get_type_name(),$sformatf("WRITE_TASK::Before Sending_req_write_packet = \n %s",req_wr.sprint()),UVM_NONE); 

    if(axi4_master_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE) begin 
      address = req_wr.awaddr;
      length = req_wr.awlen;
      size = req_wr.awsize;
    end

    //Converting configurations into struct config type
    axi4_master_cfg_converter::from_class(axi4_master_agent_cfg_h,struct_cfg);


    `uvm_info(get_type_name(),$sformatf("WRITE_TASK::Checking transfer type outside if = %s",req_wr.transfer_type),UVM_FULL); 
    
    //Checking if the tranfer type is blocking write 
    if(req_wr.transfer_type == BLOCKING_WRITE) begin
      
      axi4_master_tx local_master_write_tx; 
      axi4_master_seq_item_converter::from_write_class(req_wr,struct_write_packet);
      `uvm_info(get_type_name(),$sformatf("WRITE_TASK::Checking transfer type = %s",req_wr.transfer_type),UVM_MEDIUM); 
      
      //Calling 3 write tasks from axi4_master_drv_bfm in HDL side
      axi4_master_drv_bfm_h.axi4_write_address_channel_task(struct_write_packet,struct_cfg);
      axi4_master_drv_bfm_h.axi4_write_data_channel_task(struct_write_packet,struct_cfg);
      axi4_master_drv_bfm_h.axi4_write_response_channel_task(struct_write_packet,struct_cfg);

      //Converts the struct packet to req packet
      axi4_master_seq_item_converter::to_write_class(struct_write_packet,local_master_write_tx);
      `uvm_info(get_type_name(),$sformatf("WRITE_TASK::Response Received_req_write_packet = \n %s",
                                           local_master_write_tx.sprint()),UVM_MEDIUM);
    end

    //Checking if the tranfer type is non blocking write 
    else if(req_wr.transfer_type == NON_BLOCKING_WRITE) begin

      //Variable : write_address_process
      //Used to control the fork_join process
      //Use Case is fork_join process should wait for write address to complete.
      process write_address_process;

      //Variable : write_data_process
      //Used to control the fork_join process
      process write_data_process;

      //Variable : write_response_process
      //Used to control the fork_join process
      process write_response_process;

      //Keeping the req packet into the write fifo 
      //This fifo is used if the transfer_type is NON_BLOCKING_WRITE
      //Throws the error if the write fifo reaches the limit
      if(!axi4_master_write_fifo_h.is_full()) begin
        axi4_master_write_fifo_h.write(req_wr);
      end
      else begin
        `uvm_error(get_type_name(),$sformatf("WRITE_TASK::Cannot write into FIFO as WRITE_FIFO IS FULL"));
      end

      if(!axi4_master_write_resp_fifo_h.is_full()) begin
        axi4_master_write_resp_fifo_h.write(req_wr);
      end
      else begin
        `uvm_error(get_type_name(),$sformatf("WRITE_TASK::Cannot write into FIFO as WRITE_RESP_FIFO IS FULL"));
      end

      fork
        begin : WRITE_ADDRESS_CHANNEL 
          axi4_master_tx             local_master_addr_tx;
          axi4_write_transfer_char_s struct_write_addr_packet;

          //Added the write_address_process to keep track of this write address channel thread
          //self is a static method which creates the write_address_process of type process
          write_address_process = process::self();
          
          //Converting the req packet to struct packet
          axi4_master_seq_item_converter::from_write_class(req_wr,struct_write_addr_packet);
          `uvm_info(get_type_name(),$sformatf("WRITE_ADDRESS_THREAD::Checking write address struct packet = %p",
                                               struct_write_addr_packet),UVM_MEDIUM); 

          //Calling the bfm task which drives write address channel signals
          axi4_master_drv_bfm_h.axi4_write_address_channel_task(struct_write_addr_packet,struct_cfg);

          //Converting the write data struct packet to req packet
          axi4_master_seq_item_converter::to_write_class(struct_write_addr_packet,req_wr);
          `uvm_info(get_type_name(),$sformatf("WRITE_ADDRESS_THREAD::Received_req_write_packet = \n %s",
                                               req_wr.sprint()),UVM_MEDIUM);

          //Returns the number of packets written to fifo
          `uvm_info(get_type_name(),$sformatf("WRITE_ADDRESS_THREAD::Checking fifo size used= %0d",
                                               axi4_master_write_fifo_h.used()),UVM_FULL);
        end
    
        begin : WRITE_DATA_CHANNEL
          axi4_master_tx             local_master_data_tx;
          axi4_write_transfer_char_s struct_write_data_packet;

          //Added the write_data_process to keep track of this write address channel thread
          //self is a static method which creates the write_data_process of type process
          write_data_process=process::self();

          //Getting the key from the write_data_channel so that 
          //the other transaction should start after completion of the previous transaction
          write_data_channel_key.get(1);
          
          //Returns the number of elements written into fifo
          `uvm_info(get_type_name(),$sformatf("WRITE_DATA_THREAD::Checking fifo size used in write_data= %0d",
                                               axi4_master_write_fifo_h.used()),UVM_FULL);

          //Return the fifo size that it is capable to hold
          //A return value of 0 indicates the FIFO capacity has no limit
          `uvm_info(get_type_name(),$sformatf("WRITE_DATA_THREAD::Checking fifo size = %0d",
                                               axi4_master_write_fifo_h.size()),UVM_FULL); 
         
          //Peek method gets the packet from the fifo but the fifo doesn't discard the packet
          //It throws an error if peek is done into an empty fifo
          if(!axi4_master_write_fifo_h.is_empty()) begin
            axi4_master_write_fifo_h.get(local_master_data_tx);
          end
          else begin
            `uvm_error(get_type_name(),$sformatf("WRITE_DATA_THREAD::Cannot peek into FIFO as WRITE_FIFO IS EMPTY"));
          end

          //Converts the received req_packet to struct packet
          axi4_master_seq_item_converter::from_write_class(local_master_data_tx,struct_write_data_packet);
          `uvm_info(get_type_name(),$sformatf("WRITE_DATA_THREAD::Checking write data struct packet = %p",
                                               struct_write_data_packet),UVM_MEDIUM);

          //Calling the write data channel in bfm to drive all the write data signals
          axi4_master_drv_bfm_h.axi4_write_data_channel_task(struct_write_data_packet,struct_cfg);
         
          //Converting the write data struct packet to req packet
          axi4_master_seq_item_converter::to_write_class(struct_write_data_packet,local_master_data_tx);
          `uvm_info(get_type_name(),$sformatf("WRITE_DATA_THREAD::Received_req_write_packet = \n %s",
                                               local_master_data_tx.sprint()),UVM_MEDIUM);
          
                                               //Returns the number of packets written into fifo
          `uvm_info(get_type_name(),$sformatf("WRITE_DATA_THREAD::Checking fifo size used= %0d",
                                               axi4_master_write_fifo_h.used()),UVM_FULL);

          //Keeps the key back in the semaphore as the current transaction is completed
          //and the next transacion can be started.
          write_data_channel_key.put(1);
        end
     
        begin : WRITE_RESPONSE_CHANNEL

          axi4_master_tx             local_master_response_tx;
          axi4_write_transfer_char_s struct_write_response_packet;

          //Added the write_response_process to keep track of this write response channel thread
          //self is a static method which creates the write_response_process of type process
          write_response_process=process::self();

          //Getting the key from the write_response_channel so that 
          //the other transaction should start after completion of the previous transaction
          write_response_channel_key.get(1);

          //write_address_process.await();

          `uvm_info(get_type_name(),$sformatf("WRITE_RESPONSE_THREAD::Checking fifo size used = %0d",
                                               axi4_master_write_resp_fifo_h.used()),UVM_FULL); 
         
          //Get method gets the packet and discards the packet from fifo
          //It throws an error if get is done into an empty fifo
          if(!axi4_master_write_resp_fifo_h.is_empty()) begin
            axi4_master_write_resp_fifo_h.get(local_master_response_tx);
          end
          else begin
            `uvm_error(get_type_name(),$sformatf("WRITE_RESPONSE_THREAD::Cannot peek into FIFO as WRITE_RESP_FIFO IS EMPTY"));
          end
          
          //Converts the received req_packet to struct packet
          axi4_master_seq_item_converter::from_write_class(local_master_response_tx,struct_write_response_packet);
          `uvm_info(get_type_name(),$sformatf("WRITE_RESPONSE_THREAD::Checking struct packet = %p",
                                               struct_write_response_packet),UVM_MEDIUM); 
          
          //Calls the write response channel on the bfm to sample the write response channel signals
          axi4_master_drv_bfm_h.axi4_write_response_channel_task(struct_write_response_packet,struct_cfg);
          `uvm_info(get_type_name(),$sformatf("WRITE_RESPONSE_THREAD::Received_struct_packet = %p",
                                               struct_write_response_packet),UVM_FULL);

          //Converting the write data struct packet to req packet
          axi4_master_seq_item_converter::to_write_class(struct_write_response_packet,local_master_response_tx);
          `uvm_info(get_type_name(),$sformatf("WRITE_RESPONSE_THREAD::Received_req_write_packet = \n %s",
                                               local_master_response_tx.sprint()),UVM_MEDIUM);

          `uvm_info(get_type_name(),$sformatf("WRITE_RESPONSE_THREAD::Checking fifo size used= %0d",
                                               axi4_master_write_resp_fifo_h.used()),UVM_FULL); 

          `uvm_info(get_type_name(), $sformatf("WRITE_RESPONSE_THREAD :: Out of response task"), UVM_FULL); 
          
          //Getting the key from the write_response_channel so that 
          //the other transaction should start after completion of the previous transaction
          write_response_channel_key.put(1);
        end

      join_any

      //fine-grain control
      //status returns whether the process is FINISHED or WAITING or RUNNING.
      `uvm_info(get_type_name(), $sformatf("WRITE_TASK :: Out of fork_join : Before await write_address.status()=%s",
                                            write_address_process.status()), UVM_NONE); 
      //Waiting for write address channel to complete 
      //As we don't have control on fork-join_any or fork-join_none processes,
      //the await method makes sure that it waits for the write address to complete
      write_address_process.await();
      
      //status returns whether the process is FINISHED or WAITING or RUNNING.
      `uvm_info(get_type_name(), $sformatf("WRITE_TASK :: Out of fork_join : After await write_address.status()=%s",
                                            write_address_process.status()), UVM_NONE); 
    end

    wait_for_wr_addr = 1;

    axi_write_seq_item_port.item_done();
  end
endtask : axi4_write_task

//--------------------------------------------------------------------------------------------
// Task: axi4_read_task
//  Gets the sequence_item, converts them to struct compatible transactions
//  and sends them to the BFM to drive the data over the interface
//--------------------------------------------------------------------------------------------
task axi4_master_driver_proxy::axi4_read_task();
  forever begin
    
    //axi4_master_tx local_master_read_tx;
    axi4_read_transfer_char_s struct_read_packet;
    axi4_transfer_cfg_s       struct_cfg;

    axi_read_seq_item_port.get_next_item(req_rd);
    `uvm_info(get_type_name(),$sformatf("READ_TASK:: Before Sending_req_read_packet = \n %s",req_rd.sprint()),UVM_NONE); 

    if(axi4_master_agent_cfg_h.read_data_mode == SLAVE_MEM_MODE && write_read_mode_h != ONLY_READ_DATA) begin 
      wait(wait_for_wr_addr);
      req_rd.araddr = address;
      req_rd.arlen  = length;
      req_rd.arsize = arsize_e'(size);
    end

    //Converting configurations into struct config type
    axi4_master_cfg_converter::from_class(axi4_master_agent_cfg_h,struct_cfg);


    //Return the fifo size that it is capable to hold
    //A return value of 0 indicates the FIFO capacity has no limit
    `uvm_info(get_type_name(),$sformatf("READ_TASK::Checking fifo_size = %0d",axi4_master_write_fifo_h.size()),UVM_FULL); 
    `uvm_info(get_type_name(),$sformatf("READ_TASK::Checking fifo_resp_size = %0d",axi4_master_write_resp_fifo_h.size()),UVM_FULL); 

    `uvm_info(get_type_name(),$sformatf("READ_TASK::Checking transfer type outside if= %s",req_rd.transfer_type),UVM_FULL); 
    `uvm_info(get_type_name(),$sformatf("READ_TASK::Checking transfer type outside if= %s",req_rd.transfer_type),UVM_FULL); 
    
    if(req_rd.transfer_type == BLOCKING_READ) begin
      
      //Converts the req read packet to struct read packet
      axi4_master_seq_item_converter::from_read_class(req_rd,struct_read_packet);
      `uvm_info(get_type_name(),$sformatf("READ_TASK::Checking transfer type in read task = %s",req_rd.transfer_type),UVM_MEDIUM); 

      //Calling read address channel and read data channel tasks declared in bfm to drive the
      //read address channel signals and to sample the read data channel siganls
      axi4_master_drv_bfm_h.axi4_read_address_channel_task(struct_read_packet,struct_cfg);
      axi4_master_drv_bfm_h.axi4_read_data_channel_task(struct_read_packet,struct_cfg);
      
      //Converting transactions into struct data type
      axi4_master_seq_item_converter::to_read_class(struct_read_packet,req_rd);

      `uvm_info(get_type_name(),$sformatf("READ_TASK::Response_received_req_read_packet = \n %s",req_rd.sprint()),UVM_MEDIUM);
    end

    else if(req_rd.transfer_type ==  NON_BLOCKING_READ) begin

      //Variable : read_addr_process
      //Used to control the fork_join process
      //Use Case is fork_join process should wait for read address to complete.
      process read_addr_process;

      //Variable : read_data_process
      //Used to control the fork_join process
      process read_data_process;

      //Keeping the req packet into the read fifo 
      //This fifo is used if the transfer_type is NON_BLOCKING_READ
      //Throws the error when it reaches the limit of the fifo
      if(!axi4_master_read_fifo_h.is_full()) begin
        axi4_master_read_fifo_h.write(req_rd);
      end
      else begin
        `uvm_error(get_type_name(),$sformatf("READ_TASK::Cannot write into FIFO as READ_FIFO IS FULL"));
      end

      fork
        begin : READ_ADDRESS_CHANNEL  
          axi4_read_transfer_char_s struct_read_address_packet;

          //Added the read_addr_process to keep track of this read address channel thread
          //self is a static method which creates the read_addr_process of type process
          read_addr_process = process::self();

          `uvm_info(get_type_name(),$sformatf("READ_ADDRESS_THREAD::Checking transfer type inside fork = %s",
                                               req_rd.transfer_type),UVM_FULL); 

          `uvm_info(get_type_name(),$sformatf("READ_ADDRESS_THREAD::Checking req_rd = %s",req_rd.sprint()),UVM_FULL); 
          
          //Converts the read req packet to struct packet
          axi4_master_seq_item_converter::from_read_class(req_rd,struct_read_address_packet);
          `uvm_info(get_type_name(),$sformatf("READ_ADDRESS_THREAD::Checking struct packet = %p",
                                               struct_read_address_packet),UVM_MEDIUM); 
          
          //Calls the read address channel to drive the read address channel signals
          axi4_master_drv_bfm_h.axi4_read_address_channel_task(struct_read_address_packet,struct_cfg);

          //Converting transactions into struct data type
          axi4_master_seq_item_converter::to_read_class(struct_read_packet,req_rd);
          `uvm_info(get_type_name(),$sformatf("READ_ADDRESS_THREAD::Checking struct packet = %p",req_rd.sprint()),UVM_MEDIUM); 
        end

        begin : READ_DATA_CHANNEL
          axi4_master_tx local_master_read_data_tx;
          axi4_read_transfer_char_s struct_read_data_packet;
          
          //Added the read_data_process to keep track of this read data channel thread
          //self is a static method which creates the read_data_process of type process
          read_data_process = process::self();
          
          //Getting the key from the read_data_channel so that 
          //the other transaction should start after completion of the previous transaction
          read_channel_key.get(1);

          //Get method gets the packet and discards the packet from fifo
          //It throws an error if get is done into an empty fifo
          if(!axi4_master_read_fifo_h.is_empty()) begin
            axi4_master_read_fifo_h.get(local_master_read_data_tx);
          end
          else begin
            `uvm_error(get_type_name(),$sformatf("READ_DATA_THREAD::Cannot read from read fifo, as it is empty"));
          end

          //Converts the req packet to struct packet
          axi4_master_seq_item_converter::from_read_class(local_master_read_data_tx,struct_read_data_packet);
          `uvm_info(get_type_name(),$sformatf("READ_DATA_THREAD::Checking struct packet = %p",
                                               struct_read_data_packet),UVM_MEDIUM); 
          
          //Calls the read data channel task in bfm to sample the read data signals
          axi4_master_drv_bfm_h.axi4_read_data_channel_task(struct_read_data_packet,struct_cfg);
          `uvm_info(get_type_name(),$sformatf("READ_DATA_THREAD::Checking response struct packet = %p",
                                               struct_read_data_packet),UVM_FULL); 
          
          //Getting the key from the write_response_channel so that 
          //the other transaction should start after completion of the previous transaction
          read_channel_key.put(1);
          
          //Converting transactions into struct data type
          axi4_master_seq_item_converter::to_read_class(struct_read_data_packet,req_rd);

          `uvm_info(get_type_name(),$sformatf("READ_DATA_THREAD::Response_received_req_read_packet = \n %s",
                                               req_rd.sprint()),UVM_MEDIUM);
        end
      join_any

      //fine-grain control
      //status returns whether the process is FINISHED or WAITING or RUNNING.
      `uvm_info(get_type_name(), $sformatf("READ_TASK :: Out of fork_join : Before await read_addr.status()=%s ",
                                            read_addr_process.status()), UVM_FULL); 

      //Waiting for read address channel to complete 
      //As we don't have control on fork-join_any or fork-join_none processes,
      //the await method makes sure that it waits for the read address to complete
      read_addr_process.await();

      //status returns whether the process is FINISHED or WAITING or RUNNING.
      `uvm_info(get_type_name(), $sformatf("READ_TASK :: Out of fork_join : After await read_addr.status()=%s ",
                                            read_addr_process.status()), UVM_FULL); 
    end

    axi_read_seq_item_port.item_done();
  end
endtask : axi4_read_task

`endif

