`ifndef AXI4LITEMASTERWRITEMONITORPROXY_INCLUDED_
`define AXI4LITEMASTERWRITEMONITORPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: Axi4LiteMasterWriteMonitorProxy
//  
//  Monitor is written by extending uvm_monitor,uvm_monitor is inherited from uvm_component, 
//  A monitor is a passive entity that samples the DUT signals through virtual interface and 
//  converts the signal level activity to transaction level,monitor samples DUT signals but cannot drive them.
//  Monitor should have analysis port (TLM port) and virtual interface handle that points to DUT signal
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterWriteMonitorProxy extends uvm_component;
  `uvm_component_utils(Axi4LiteMasterWriteMonitorProxy)

  // Variable: axi4LiteMasterWriteAgentConfig
  // Declaring handle for axi4_master agent config class 
  Axi4LiteMasterWriteAgentConfig axi4LiteMasterWriteAgentConfig;

  // Declaring handles for master transaction
  Axi4LiteMasterWriteTransaction req_rd;
  Axi4LiteMasterWriteTransaction req_wr;

  // Variable : apb_master_mon_bfm_h
  // Declaring handle for apb monitor bfm
  virtual Axi4LiteMasterWriteMonitorBFM axi4LiteMasterWriteMonitorBFM;
  
  // Declaring analysis port for the monitor port
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_read_address_analysis_port;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_read_data_analysis_port;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_write_address_analysis_port;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_write_data_analysis_port;
  uvm_analysis_port#(Axi4LiteMasterWriteTransaction) axi4_master_write_response_analysis_port;

  //Variable: axi4_master_write_address_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterWriteTransaction) axi4_master_write_address_fifo_h;
  
  //Variable: axi4_master_write_data_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterWriteTransaction) axi4_master_write_data_fifo_h;
  
  //Variable: axi4_master_read_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for read task
  uvm_tlm_analysis_fifo #(Axi4LiteMasterWriteTransaction) axi4_master_read_fifo_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteMasterWriteMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:   extern virtual task axi4_write_address();
// GopalS:   extern virtual task axi4_write_data();
// GopalS:   extern virtual task axi4_write_response();
// GopalS:   extern virtual task axi4_read_address();
// GopalS:   extern virtual task axi4_read_data();

endclass : Axi4LiteMasterWriteMonitorProxy

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - Axi4LiteMasterWriteMonitorProxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function Axi4LiteMasterWriteMonitorProxy::new(string name = "Axi4LiteMasterWriteMonitorProxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_master_read_address_analysis_port   = new("axi4_master_read_address_analysis_port",this);
  axi4_master_read_data_analysis_port      = new("axi4_master_read_data_analysis_port",this);
  axi4_master_write_address_analysis_port  = new("axi4_master_write_address_analysis_port",this);
  axi4_master_write_data_analysis_port     = new("axi4_master_write_data_analysis_port",this);
  axi4_master_write_response_analysis_port = new("axi4_master_write_response_analysis_port",this);
  axi4_master_write_address_fifo_h= new("axi4_master_write_address_fifo_h",this);
  axi4_master_write_data_fifo_h= new("axi4_master_write_data_fifo_h",this);
  axi4_master_read_fifo_h = new("axi4_master_read_fifo_h",this);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterWriteMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual Axi4LiteMasterWriteMonitorBFM)::get(this,"","Axi4LiteMasterWriteMonitorBFM",axi4LiteMasterWriteMonitorBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_Axi4LiteMasterWriteMonitorBFM","cannot get() axi4LiteMasterWriteMonitorBFM");
  end 
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterWriteMonitorProxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterWriteMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  axi4LiteMasterWriteMonitorBFM.axi4LiteMasterWriteMonitorProxy = this;
endfunction : end_of_elaboration_phase


//--------------------------------------------------------------------------------------------
// Task: run_phase
// 
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task Axi4LiteMasterWriteMonitorProxy::run_phase(uvm_phase phase);
/*
  axi4LiteMasterWriteMonitorBFM.wait_for_aresetn();

  fork 
    axi4_write_address();
    axi4_write_data();
    axi4_write_response();
    axi4_read_address();
    axi4_read_data();
  join
*/
endtask : run_phase

//--------------------------------------------------------------------------------------------
// Task: axi4_write_address
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------
/*
task Axi4LiteMasterWriteMonitorProxy::axi4_write_address();
  forever begin
    axi4_write_transfer_char_s struct_write_packet;
    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteMasterWriteTransaction             req_wr_clone_packet;

    axi4_master_cfg_converter::from_class(axi4LiteMasterWriteAgentConfig, struct_cfg);
    axi4LiteMasterWriteMonitorBFM.axi4_write_address_sampling(struct_write_packet,struct_cfg);
    axi4_master_seq_item_converter::to_write_class(struct_write_packet,req_wr);
    
    axi4_master_write_address_fifo_h.write(req_wr);

    // Clone and publish the cloned item to the subscribers
    $cast(req_wr_clone_packet,req_wr.clone());

    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_write_address clone packet is \n %s",req_wr_clone_packet.sprint()),UVM_HIGH)
    axi4_master_write_address_analysis_port.write(req_wr_clone_packet);
  end
endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_write_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteMasterWriteMonitorProxy::axi4_write_data();
  forever begin
    axi4_write_transfer_char_s struct_write_packet;
    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteMasterWriteTransaction             req_wr_clone_packet;
    Axi4LiteMasterWriteTransaction             local_write_addr_packet;
    
    axi4_master_cfg_converter::from_class(axi4LiteMasterWriteAgentConfig, struct_cfg);
    axi4LiteMasterWriteMonitorBFM.axi4_write_data_sampling(struct_write_packet,struct_cfg);
   
    //Getting the write address packet
    axi4_master_write_address_fifo_h.get(local_write_addr_packet);
    `uvm_info(get_type_name(),$sformatf("ADDR_Packet received from fifo is \n %s",local_write_addr_packet.sprint()),UVM_HIGH)   
    
    //Combining write address and write data packets
    axi4_master_seq_item_converter::to_write_addr_data_class(local_write_addr_packet,struct_write_packet,req_wr);

    axi4_master_write_data_fifo_h.write(req_wr);

    // Clone and publish the cloned item to the subscribers
    $cast(req_wr_clone_packet,req_wr.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_write_data clone packet is \n %s",req_wr_clone_packet.sprint()),UVM_HIGH)   
    axi4_master_write_data_analysis_port.write(req_wr_clone_packet);
  end
endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_write_response
// Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteMasterWriteMonitorProxy::axi4_write_response();
  forever begin
    axi4_write_transfer_char_s struct_write_packet;
    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteMasterWriteTransaction             master_tx_clone_packet;
    Axi4LiteMasterWriteTransaction             local_write_addr_data_packet;

    axi4_master_cfg_converter::from_class(axi4LiteMasterWriteAgentConfig, struct_cfg);
    axi4LiteMasterWriteMonitorBFM.axi4_write_response_sampling(struct_write_packet,struct_cfg);
    axi4_master_seq_item_converter::to_write_class(struct_write_packet,req_wr);

    //Getting the write address packet
    axi4_master_write_data_fifo_h.get(local_write_addr_data_packet);
    
    //Combining write address and write data packets
    axi4_master_seq_item_converter::to_write_addr_data_resp_class(local_write_addr_data_packet,struct_write_packet,req_wr);

    //clone and publish the clone to the analysis port 
    $cast(master_tx_clone_packet,req_wr.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_write_response clone packet is \n %s",master_tx_clone_packet.sprint()),UVM_HIGH);
    axi4_master_write_response_analysis_port.write(master_tx_clone_packet);
  end
endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_read_address
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteMasterWriteMonitorProxy::axi4_read_address();
  forever begin
    axi4_read_transfer_char_s struct_read_packet;
    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteMasterWriteTransaction             req_rd_clone_packet;

    axi4_master_cfg_converter::from_class(axi4LiteMasterWriteAgentConfig, struct_cfg);
    axi4LiteMasterWriteMonitorBFM.axi4_read_address_sampling(struct_read_packet,struct_cfg);
    axi4_master_seq_item_converter::to_read_class(struct_read_packet,req_rd);
    
    axi4_master_read_fifo_h.write(req_rd);

    //clone and publish the clone to the analysis port 
    $cast(req_rd_clone_packet,req_rd.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_read_address clone packet is \n %s",req_rd_clone_packet.sprint()),UVM_HIGH)
    axi4_master_read_address_analysis_port.write(req_rd_clone_packet);
  end
endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_read_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteMasterWriteMonitorProxy::axi4_read_data();
  forever begin
    axi4_read_transfer_char_s struct_read_packet;
    axi4_transfer_cfg_s       struct_cfg;
    Axi4LiteMasterWriteTransaction            req_rd_clone_packet; 
    Axi4LiteMasterWriteTransaction            local_read_addr_packet;

    axi4_master_cfg_converter::from_class(axi4LiteMasterWriteAgentConfig, struct_cfg);
    axi4LiteMasterWriteMonitorBFM.axi4_read_data_sampling(struct_read_packet,struct_cfg);

    axi4_master_read_fifo_h.get(local_read_addr_packet);
    
    axi4_master_seq_item_converter::to_read_addr_data_class(local_read_addr_packet,struct_read_packet,req_rd);

    //clone and publish the clone to the analysis port 
    $cast(req_rd_clone_packet,req_rd.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_read_data clone packet is \n %s",req_rd_clone_packet.sprint()),UVM_HIGH)
    axi4_master_read_data_analysis_port.write(req_rd_clone_packet);
  end
endtask
*/
`endif

