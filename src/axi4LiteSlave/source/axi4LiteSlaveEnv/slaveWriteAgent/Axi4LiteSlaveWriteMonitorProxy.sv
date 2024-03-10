`ifndef AXI4LITESLAVEWRITEMONITORPROXY_INCLUDED_
`define AXI4LITESLAVEWRITEMONITORPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveWriteMonitorProxy
// This is the HVL axi4_slave monitor proxy
// It gets the sampled data from the HDL axi4_slave monitor and 
// converts them into transaction items
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveWriteMonitorProxy extends uvm_monitor;
  `uvm_component_utils(Axi4LiteSlaveWriteMonitorProxy)

  // Variable: axi4LiteSlaveWriteAgentConfig;
  // Handle for axi4 slave agent configuration
  Axi4LiteSlaveWriteAgentConfig axi4LiteSlaveWriteAgentConfig;

  // Declaring Virtual Monitor BFM Handle
  virtual Axi4LiteSlaveWriteMonitorBFM axi4LiteSlaveWriteMonitorBFM;

  Axi4LiteSlaveWriteTransaction req_rd;
  Axi4LiteSlaveWriteTransaction req_wr;

  // Variable: axi4_slave_analysis_port
  // Declaring analysis port for the monitor port
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_write_address_analysis_port;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_write_data_analysis_port;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_write_response_analysis_port;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_read_address_analysis_port;
  uvm_analysis_port#(Axi4LiteSlaveWriteTransaction) axi4_slave_read_data_analysis_port;

  //Variable: axi4_slave_write_address_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_address_fifo_h;
  
  //Variable: axi4_slave_write_data_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for write task
  uvm_tlm_analysis_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_write_data_fifo_h;
  
  //Variable: axi4_slave_read_fifo_h
  //Declaring handle for uvm_tlm_analysis_fifo for read task
  uvm_tlm_analysis_fifo #(Axi4LiteSlaveWriteTransaction) axi4_slave_read_fifo_h;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteSlaveWriteMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
// GopalS:   extern virtual task axi4_slave_write_address();
// GopalS:   extern virtual task axi4_slave_write_data();
// GopalS:   extern virtual task axi4_slave_write_response();
// GopalS:   extern virtual task axi4_slave_read_address();
// GopalS:   extern virtual task axi4_slave_read_data();

endclass : Axi4LiteSlaveWriteMonitorProxy

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - Axi4LiteSlaveWriteMonitorProxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function Axi4LiteSlaveWriteMonitorProxy::new(string name = "Axi4LiteSlaveWriteMonitorProxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_slave_read_address_analysis_port = new("axi4_slave_read_address_analysis_port",this);
  axi4_slave_read_data_analysis_port = new("axi4_slave_read_data_analysis_port",this);
  axi4_slave_write_address_analysis_port = new("axi4_slave_write_address_analysis_port",this);
  axi4_slave_write_data_analysis_port = new("axi4_slave_write_data_analysis_port",this);
  axi4_slave_write_response_analysis_port = new("axi4_slave_write_response_analysis_port",this);
  axi4_slave_write_address_fifo_h= new("axi4_slave_write_address_fifo_h",this);
  axi4_slave_write_data_fifo_h= new("axi4_slave_write_data_fifo_h",this);
  axi4_slave_read_fifo_h = new("axi4_slave_read_fifo_h",this);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteSlaveWriteMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
   if(!uvm_config_db#(virtual Axi4LiteSlaveWriteMonitorBFM)::get(this,"","Axi4LiteSlaveWriteMonitorBFM",axi4LiteSlaveWriteMonitorBFM)) begin
     `uvm_fatal("FATAL_SMP_MON_BFM",$sformatf("Couldn't get S_MON_BFM in Axi4LiteSlaveWriteMonitorProxy"));  
  end 
endfunction : build_phase

//-------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
//Description: connects monitor_proxy and monitor_bfm
//
// Parameters:
//  phase - stores the current phase
//------------------------------------------------------------------------------------------
function void Axi4LiteSlaveWriteMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // GopalS: axi4LiteSlaveWriteMonitorBFM.axi4LiteSlaveWriteMonitorProxy = this;
endfunction : end_of_elaboration_phase


//--------------------------------------------------------------------------------------------
// Task: run_phase
//--------------------------------------------------------------------------------------------
task Axi4LiteSlaveWriteMonitorProxy::run_phase(uvm_phase phase);
/*
  axi4LiteSlaveWriteMonitorBFM.wait_for_aresetn();

  fork 
    axi4_slave_write_address();
    axi4_slave_write_data();
    axi4_slave_write_response();
    axi4_slave_read_address();
    axi4_slave_read_data();
  join
*/
endtask : run_phase 
/*
//--------------------------------------------------------------------------------------------
// Task : axi4_slave_write_address
// Description: converting,sampling and again converting 
//--------------------------------------------------------------------------------------------
task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_write_address();
  forever begin
    axi4_write_transfer_char_s struct_write_packet;
    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteSlaveWriteTransaction              req_wr_clone_packet;


    axi4_slave_cfg_converter::from_class(axi4LiteSlaveWriteAgentConfig, struct_cfg);
    axi4LiteSlaveWriteMonitorBFM.axi4_slave_write_address_sampling(struct_write_packet,struct_cfg);
    axi4_slave_seq_item_converter::to_write_class(struct_write_packet,req_wr);
    
    axi4_slave_write_address_fifo_h.write(req_wr);

    $cast(req_wr_clone_packet,req_wr.clone());    
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_slave_write_address_sampling is %s",req_wr_clone_packet.sprint()),UVM_HIGH)
    axi4_slave_write_address_analysis_port.write(req_wr_clone_packet);

  end
endtask
//--------------------------------------------------------------------------------------------
// Task: axi4_slave_write_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_write_data();
  forever begin
    axi4_write_transfer_char_s struct_write_packet;

    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteSlaveWriteTransaction             req_wr_clone_packet;
    Axi4LiteSlaveWriteTransaction             local_write_addr_packet;
    
    axi4_slave_cfg_converter::from_class(axi4LiteSlaveWriteAgentConfig, struct_cfg);
    axi4LiteSlaveWriteMonitorBFM.axi4_slave_write_data_sampling(struct_write_packet,struct_cfg);
    axi4_slave_seq_item_converter::to_write_class(struct_write_packet,req_wr);
    
    //Getting the write address packet
    axi4_slave_write_address_fifo_h.get(local_write_addr_packet);
    `uvm_info(get_type_name(),$sformatf("ADDR_Packet received from fifo is \n %s",local_write_addr_packet.sprint()),UVM_HIGH)   
    
    //Combining write address and write data packets
    axi4_slave_seq_item_converter::to_write_addr_data_class(local_write_addr_packet,struct_write_packet,req_wr);

    axi4_slave_write_data_fifo_h.write(req_wr);

    //clone and publish the clone to the analysis port 
    $cast(req_wr_clone_packet,req_wr.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_slave_write_data is \n %s",req_wr_clone_packet.sprint()),UVM_HIGH)

    axi4_slave_write_data_analysis_port.write(req_wr);
  end

endtask
//--------------------------------------------------------------------------------------------
// Task: axi4_slave_write_response
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_write_response();

  forever begin
    axi4_write_transfer_char_s struct_write_packet;
    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteSlaveWriteTransaction             Axi4LiteSlaveWriteTransaction_clone_packet;
    Axi4LiteSlaveWriteTransaction             local_write_addr_data_packet;

    axi4_slave_cfg_converter::from_class(axi4LiteSlaveWriteAgentConfig, struct_cfg);
    axi4LiteSlaveWriteMonitorBFM.axi4_write_response_sampling(struct_write_packet,struct_cfg);
    axi4_slave_seq_item_converter::to_write_class(struct_write_packet,req_wr);
    
    //Getting the write address packet
    axi4_slave_write_data_fifo_h.get(local_write_addr_data_packet);
    
    //Combining write address and write data packets
    axi4_slave_seq_item_converter::to_write_addr_data_resp_class(local_write_addr_data_packet,struct_write_packet,req_wr);

    //clone and publish the clone to the analysis port 
    $cast(Axi4LiteSlaveWriteTransaction_clone_packet,req_wr.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_slave_write_response is \n %s",Axi4LiteSlaveWriteTransaction_clone_packet.sprint()),UVM_HIGH);
    
    axi4_slave_write_response_analysis_port.write(Axi4LiteSlaveWriteTransaction_clone_packet);
  end
endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_slave_read_address
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_read_address();
  forever begin
    axi4_read_transfer_char_s struct_read_packet;
    axi4_transfer_cfg_s        struct_cfg;
    Axi4LiteSlaveWriteTransaction             req_rd_clone_packet;

    axi4_slave_cfg_converter::from_class(axi4LiteSlaveWriteAgentConfig, struct_cfg);
    axi4LiteSlaveWriteMonitorBFM.axi4_read_address_sampling(struct_read_packet,struct_cfg);
    axi4_slave_seq_item_converter::to_read_class(struct_read_packet,req_rd);

    axi4_slave_read_fifo_h.write(req_rd);

    $cast(req_rd_clone_packet,req_rd.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_slave_read_address is \n %s",req_rd_clone_packet.sprint()),UVM_HIGH)

    axi4_slave_read_address_analysis_port.write(req_rd_clone_packet); 
  end

endtask

//--------------------------------------------------------------------------------------------
// Task: axi4_slave_read_data
//  Gets the struct packet samples the data, convert it to req and drives to analysis port
//--------------------------------------------------------------------------------------------

task Axi4LiteSlaveWriteMonitorProxy::axi4_slave_read_data();
  forever begin
    axi4_read_transfer_char_s struct_read_packet;
    axi4_transfer_cfg_s       struct_cfg;
    Axi4LiteSlaveWriteTransaction             req_rd_clone_packet; 
    Axi4LiteSlaveWriteTransaction             local_read_addr_packet; 

    axi4_slave_cfg_converter::from_class(axi4LiteSlaveWriteAgentConfig, struct_cfg);
    axi4LiteSlaveWriteMonitorBFM.axi4_read_data_sampling(struct_read_packet,struct_cfg);
    axi4_slave_seq_item_converter::to_read_class(struct_read_packet,req_rd);
    
    axi4_slave_read_fifo_h.get(local_read_addr_packet);
    `uvm_info(get_type_name(),$sformatf("READ_ADDR_Packet received from fifo is \n %s",local_read_addr_packet.sprint()),UVM_HIGH)   
    
    axi4_slave_seq_item_converter::to_read_addr_data_class(local_read_addr_packet,struct_read_packet,req_rd);
    //clone and publish the clone to the analysis port 
    $cast(req_rd_clone_packet,req_rd.clone());
    `uvm_info(get_type_name(),$sformatf("Packet received from axi4_slave_read_data is \n %s",req_rd_clone_packet.sprint()),UVM_HIGH)

    axi4_slave_read_data_analysis_port.write(req_rd_clone_packet);
  end
endtask
*/
`endif
