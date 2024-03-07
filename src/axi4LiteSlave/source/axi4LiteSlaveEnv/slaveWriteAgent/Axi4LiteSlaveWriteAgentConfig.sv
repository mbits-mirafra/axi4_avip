`ifndef AXI4LITESLAVEWRITEAGENTCONFIG_INCLUDED_
`define AXI4LITESLAVEWRITEAGENTCONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteSlaveWriteAgentConfig
// Used as the configuration class for axi4_slave agent and it's components
//--------------------------------------------------------------------------------------------
class Axi4LiteSlaveWriteAgentConfig extends uvm_object;
  `uvm_object_utils(Axi4LiteSlaveWriteAgentConfig)

  //Variable: isActive
  //Used for creating the agent in either passive or active mode
  uvm_active_passive_enum isActive = UVM_ACTIVE;  
  
  //Variable: hasCoverage
  //Used for enabling the slave agent coverage
  bit hasCoverage;

  //Variable: slave_id
  //Gives the slave id
  int slave_id;
  
  //Variable : max_address
  //Used to store the maximum address value of this slave
  bit [ADDRESS_WIDTH-1:0] max_address;

  //Variable : min_address
  //Used to store the minimum address value of this slave
  bit [ADDRESS_WIDTH-1:0] min_address;
  
  //Variable : wait_count_write_response_channel;
  //Used to determine the number of wait states inserted for write response channel
  int wait_count_write_response_channel;
  
  //Variable : wait_count_read_data_channel;
  //Used to determine the number of wait states inserted for read data channel
  int wait_count_read_data_channel;

  //Variable: slave_response_mode
  //Used to enable the out_of_order for writres and reads
  rand response_mode_e slave_response_mode;

  //Variable: minimum_transactions
  //Used to set the minimum txns for out_of_order
  protected bit[1:0] minimum_transactions = 2;

  //Variable: maximum_transactions
  //Used to set the maximumm txns for out_of_order
  bit[3:0] maximum_transactions;

  //Variable: read_data_mode
  //Used to set type of data to read
  read_data_type_mode_e read_data_mode;

  //Used to set the qos mode
  qos_mode_e qos_mode_type;

  //Variable: user_rdata
  //Used to set default read data
  bit[DATA_WIDTH-1:0] user_rdata;

  //constraint: maximum_txns
  //Make sure to have minimum txns to perform out_of_order
  constraint maximum_txns_c{maximum_transactions >= minimum_transactions;}


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteSlaveWriteAgentConfig");
  extern function void do_print(uvm_printer printer);
// GopalS:   extern function int get_minimum_transactions();
endclass : Axi4LiteSlaveWriteAgentConfig

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - Axi4LiteSlaveWriteAgentConfig
//--------------------------------------------------------------------------------------------
function Axi4LiteSlaveWriteAgentConfig::new(string name = "Axi4LiteSlaveWriteAgentConfig");
  super.new(name); 
endfunction : new
/*
function int Axi4LiteSlaveWriteAgentConfig::get_minimum_transactions();
  return (this.minimum_transactions);
endfunction
*/
//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//
// Parameters:
//  printer - uvm_printer
//--------------------------------------------------------------------------------------------
function void Axi4LiteSlaveWriteAgentConfig::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_string ("isActive",   isActive.name());
  printer.print_field ("slave_id",     slave_id,     $bits(slave_id),     UVM_DEC);
  printer.print_field ("hasCoverage", hasCoverage, $bits(hasCoverage), UVM_DEC);
         
endfunction : do_print

`endif

